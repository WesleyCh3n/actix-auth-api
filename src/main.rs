mod auth;
mod handler;
mod model;

use std::env;

use actix_web::dev::ServiceRequest;
use actix_web::{middleware, web, App, Error, HttpServer};
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

    let pool = PgPoolOptions::new().connect(uri).await.expect("pool");
    HttpServer::new(move || {
        let auth = HttpAuthentication::bearer(validator);
        App::new()
            .app_data(web::Data::new(AppState { db: pool.clone() }))
            .wrap(middleware::Logger::default())
            .service(handler::get_auth)
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
