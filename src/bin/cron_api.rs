use chrono::offset::Local;
use chrono::{DateTime, Duration, NaiveDate};
use sqlx::postgres::PgPoolOptions;
use sqlx::{Pool, Postgres};
use std::env;
use std::error::Error as StdError;

use actix_api::model::Api;

#[actix_web::main]
async fn main() -> Result<(), Box<dyn StdError>> {
    // env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));
    dotenv::dotenv().ok();
    let uri = env::var("DATABASE_URL").expect("DATABASE_URL");
    let pool = match PgPoolOptions::new().connect(&uri).await {
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

    let file_ctx =
        std::fs::read_to_string("last_date.dat").expect("Unable to read file");
    let last_date_str = file_ctx.lines().next().unwrap();
    /* println!(
        "des: {:?}",
        NaiveDate::parse_from_str(last_date_str.as_str(), "%Y-%m-%d")
            .unwrap_err()
            .to_string()
    ); */
    let last_date =
        NaiveDate::parse_from_str(last_date_str, "%Y-%m-%d").unwrap();
    let today: DateTime<Local> = std::time::SystemTime::now().into();
    let yesterday = today - Duration::days(1);
    println!(
        "query from {} to {}",
        last_date.format("%Y-%m-%d"),
        yesterday.format("%Y-%m-%d")
    );
    if last_date.format("%Y-%m-%d").to_string()
        >= yesterday.format("%Y-%m-%d").to_string()
    {
        println!("skip");
        return Ok(());
    }
    let result = query_day(
        &pool,
        &last_date.format("%Y-%m-%d").to_string(),
        &yesterday.format("%Y-%m-%d").to_string(),
    )
    .await?;

    let client = awc::Client::new();
    let json_result = serde_json::json!({ "data": result });
    println!("num: {}", result.len());
    let mut res = client
        .post(env::var("API_URL").expect("API_URL"))
        .timeout(std::time::Duration::from_secs(60 * 20))
        .send_json(&json_result)
        .await?;
    assert_eq!(res.status(), 200);
    println!(
        "Respond Body: {:#?}",
        res.json::<serde_json::Value>().await?
    );
    let next_date = yesterday + Duration::days(1);
    std::fs::write("./last_date.dat", next_date.format("%Y-%m-%d").to_string())
        .expect("Unable to write file");

    // bulk import
    /* use chrono::{Duration, TimeZone};
    let dt0 = Local.with_ymd_and_hms(2023, 7, 4, 0, 0, 0).unwrap();
    let dt1 = Local.with_ymd_and_hms(2023, 7, 13, 0, 0, 0).unwrap();
    let mut dt = dt0;
    let mut total = 0;
    while dt <= dt1 {
        let result = query_day(&pool, &dt).await?;
        let json_result = serde_json::json!({ "data": result });
        println!("num: {}", result.len());
        total += result.len();

        let mut res = client
            .post(env::var("API_URL").expect("API_URL"))
            .timeout(std::time::Duration::from_secs(60 * 10))
            .send_json(&json_result)
            .await?;
        assert_eq!(res.status(), 200);
        println!(
            "Respond Body: {:#?}",
            res.json::<serde_json::Value>().await?
        );

        dt += Duration::days(1);
        std::thread::sleep(std::time::Duration::from_secs(5));
    }
    println!("total: {total}"); */

    Ok(())
}

async fn query_day(
    pg_pool: &Pool<Postgres>,
    from_dt: &str,
    to_dt: &str,
) -> Result<Vec<Api>, Box<dyn StdError>> {
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
            AND TO_CHAR(A.created_at, 'yyyy-MM-dd') <= $2
        ORDER BY
            A.created_at
        "#,
        from_dt,
        to_dt
    )
    .fetch_all(pg_pool)
    .await?;
    Ok(result)
}
