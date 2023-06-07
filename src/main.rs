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

pub struct AppState {
    pub db: Pool<Postgres>,
}
async fn validator(
    req: ServiceRequest,
    credentials: BearerAuth,
) -> Result<ServiceRequest, (Error, ServiceRequest)> {
    match auth::validate_token(credentials.token()) {
        Ok(_) => Ok(req),
        Err(e) => Err((e, req)),
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    dotenv::dotenv().ok();
    let uri = env::var("DATABASE_URL").expect("DATABASE_URL");
    println!("{uri}");

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
    log::log!(log::Level::Info, "Starting Server...");
    HttpServer::new(move || {
        let auth = HttpAuthentication::bearer(validator);
        let cors = Cors::default()
            .allow_any_origin()
            .allow_any_header()
            .allowed_methods(vec!["GET", "POST", "DELETE"])
            .supports_credentials();
        App::new()
            .wrap(Logger::new("%a %r %s"))
            .app_data(web::Data::new(AppState { db: pool.clone() }))
            .wrap(cors)
            .service(handler::get_auth)
            .service(handler::remove_auth)
            .service(
                web::scope("/api")
                    .wrap(auth)
                    .service(handler::get_station)
                    .service(handler::get_station_by_id)
                    .service(handler::get_chip),
            )
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
