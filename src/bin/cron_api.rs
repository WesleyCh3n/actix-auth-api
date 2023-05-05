use sqlx::postgres::PgPoolOptions;
use std::env;
use std::error::Error as StdError;
use url::Url;

use asr_api::model::Station;

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

    let stations: Vec<Station> =
        sqlx::query_as!(Station, "select * from tbl_station")
            .fetch_all(&pool)
            .await?;
    let json_req = serde_json::json!({
        "length": stations.len(),
        "results": stations
    });
    let client = awc::Client::new();
    let res = client
        .get("https://www.rust-lang.org/")
        .append_header(("User-Agent", "Actix-web"))
        .send()
        .await?;

    println!("Response: {:?}", res);
    let res = client
        .post("http://httpbin.org/post")
        .send_json(&json_req)
        .await?;
    println!("Response: {:?}", res);
    Ok(())
}
