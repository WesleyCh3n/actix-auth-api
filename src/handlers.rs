use actix_web::{get, post, web, Responder};

use crate::auth::UserInfo;

#[post("/auth")]
pub async fn get_auth(user_info: web::Json<UserInfo>) -> impl Responder {
    crate::auth::generate_token(&user_info)
}

#[get("/station")]
pub async fn get_station() -> impl Responder {
    "get_station called"
}

#[get("/station/{id}")]
pub async fn get_station_by_id() -> impl Responder {
    "get_station_by_id called"
}
