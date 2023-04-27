mod auth;
mod handlers;

use actix_web::dev::ServiceRequest;
use actix_web::{middleware, web, App, Error, HttpServer};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use actix_web_httpauth::middleware::HttpAuthentication;
use sqlx::postgres::PgPoolOptions;

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
    let pool = PgPoolOptions::new()
        .connect("postgres://postgres:password@localhost/test")
        .await?;
    HttpServer::new(move || {
        let auth = HttpAuthentication::bearer(validator);
        App::new()
            .wrap(middleware::Logger::default())
            .service(handlers::get_auth)
            .service(
                web::scope("/api")
                    .wrap(auth)
                    .service(handlers::get_station)
                    .service(handlers::get_station_by_id),
            )
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
