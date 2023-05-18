use chrono::offset::Local;
use chrono::DateTime;
use sqlx::postgres::PgPoolOptions;
use std::env;
use std::error::Error as StdError;
use url::Url;

use asr_api::model::Api;

#[actix_web::main]
async fn main() -> Result<(), Box<dyn StdError>> {
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    dotenv::dotenv().ok();
    let host = env::var("DBHOST").expect("DBHOST");
    let db = env::var("DB").expect("DB");
    let port = env::var("DBPORT").expect("DBPORT");
    let user = env::var("DBUSER").expect("DBUSER");
    let pwd = env::var("DBPWD").expect("DBPWD");
    let db_uri = format!("postgres://{}:{}/{}", host, port, db);
    let mut uri = Url::parse(&db_uri).unwrap();
    uri.set_username(&user).expect("set user");
    uri.set_password(Some(&pwd)).expect("set pwd");
    let uri = uri.as_str();

    let pool = match PgPoolOptions::new().connect(uri).await {
        Ok(pool) => {
            log::log!(log::Level::Info, "Connect to database Successfully!");
            pool
        }
        Err(e) => {
            log::log!(
                log::Level::Error,
                "Fail to connect to database. Error: {}",
                e
            );
            panic!()
        }
    };
    let datetime: DateTime<Local> = std::time::SystemTime::now().into();

    let result: Vec<Api> = sqlx::query_as!(
        Api,
        r#"
        SELECT
            E.code AS "sn?",
            B.code AS ppid,
            C.code AS code,
            TO_CHAR(A.created_at, 'yyyy-MM-dd HH24:mi:ss') AS time
        FROM
            TBL_ChipBinding AS A
            INNER JOIN TBL_SFIS AS B ON A.sfis_id = B.id
            AND A.conflictsfis_id = '0'
            AND A.conflictSN_id = '0'
            AND A.recordmark_id = '0'
            INNER JOIN TBL_ChipSN AS C ON A.chipsn_id = C.id
            LEFT JOIN TBL_SfisPSN AS D ON D.sfis_id = A.sfis_id
            AND D.recordmark_id = '0'
            LEFT JOIN TBL_PSN AS E ON E.id = D.psn_id
        WHERE
            TO_CHAR(A.created_at, 'yyyy-MM-dd') >= $1
            AND TO_CHAR(A.created_at, 'yyyy-MM-dd') <= $1
        ORDER BY
            A.created_at
        "#,
        datetime.format("%Y-%m-%d").to_string()
    )
    .fetch_all(&pool)
    .await?;
    println!("sql: {:#?}", result);
    let json_result = serde_json::json!({ "data": result });
    println!("Day: {}", datetime.format("%Y-%m-%d"));
    println!("{:#?}", json_result);

    let client = awc::Client::new();
    let mut res = client
        .post(env::var("API_URL").expect("API_URL"))
        .send_json(&json_result)
        .await?;
    println!("Rsp Status: {:#?}", res.status());
    println!("Rsp Body: {:#?}", res.json::<serde_json::Value>().await?);
    Ok(())
}
