mod auth;
mod handler;
mod model;

use std::env;

use actix_cors::Cors;
use actix_web::dev::ServiceRequest;
use actix_web::middleware::Logger;
use actix_web::{web, App, Error, HttpServer};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use actix_web_httpauth::middleware::HttpAuthentication;
use sqlx::postgres::PgPoolOptions;
use sqlx::{Pool, Postgres};
use url::Url;

pub struct AppState {
    pub db: Pool<Postgres>,
}
async fn validator(
    req: ServiceRequest,
    _credentials: BearerAuth,
) -> Result<ServiceRequest, (Error, ServiceRequest)> {
    match auth::validate_token(_credentials.token()) {
        Ok(_) => Ok(req),
        Err(e) => Err((e, req)),
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    std::env::set_var("RUST_LOG", "actix_web=info");
    env_logger::init();

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
            println!("Connect to database Successfully!");
            pool
        }
        Err(e) => {
            panic!("Fail to connect to database. Error: {}", e)
        }
    };
    println!("Starting Server...");
    HttpServer::new(move || {
        let auth = HttpAuthentication::bearer(validator);
        let cors = Cors::default()
            .allow_any_origin()
            .allow_any_header()
            .allowed_methods(vec!["GET", "POST", "DELETE"])
            .supports_credentials();
        App::new()
            .wrap(Logger::default())
            .wrap(Logger::new("%a %{User-Agent}i"))
            .app_data(web::Data::new(AppState { db: pool.clone() }))
            .wrap(cors)
            .service(handler::get_auth)
            .service(handler::remove_auth)
            .service(
                web::scope("/api")
                    .wrap(auth)
                    .service(handler::get_station)
                    .service(handler::get_station_by_id),
            )
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
