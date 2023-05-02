use actix_web::{cookie, delete, get, post, web, HttpResponse, Responder};

use crate::{
    auth::UserInfo,
    model::{Chip, Station},
    AppState,
};

#[post("/auth")]
pub async fn get_auth(user_info: web::Json<UserInfo>) -> impl Responder {
    let token = match crate::auth::generate_token(&user_info) {
        Ok(token) => token,
        Err(e) => return HttpResponse::from(e),
    };
    let cookie = cookie::Cookie::build("jwt", &token)
        .http_only(true)
        .max_age(cookie::time::Duration::days(1))
        .finish();
    let json_rsp = serde_json::json!({
        "status": "success",
        "user": user_info.email,
        "jwt-token": token,
    });
    HttpResponse::Ok().cookie(cookie).json(json_rsp)
}

#[delete("/auth")]
pub async fn remove_auth() -> impl Responder {
    let cookie = cookie::Cookie::build("jwt", "")
        .http_only(true)
        .max_age(cookie::time::Duration::days(-1))
        .finish();
    HttpResponse::Ok().cookie(cookie).finish()
}

#[get("/station")]
pub async fn get_station(data: web::Data<AppState>) -> impl Responder {
    let stations: Vec<Station> =
        sqlx::query_as!(Station, "select * from tbl_station")
            .fetch_all(&data.db)
            .await
            .unwrap();
    let json_rsp = serde_json::json!({
        "status": "success",
        "length": stations.len(),
        "results": stations
    });
    HttpResponse::Ok().json(json_rsp)
}

#[get("/station/{id}")]
pub async fn get_station_by_id(
    id: web::Path<i64>,
    data: web::Data<AppState>,
) -> impl Responder {
    let stations: Vec<Station> = sqlx::query_as!(
        Station,
        "
select *
from tbl_station
where id = $1",
        id.into_inner()
    )
    .fetch_all(&data.db)
    .await
    .unwrap();
    let json_rsp = serde_json::json!({
        "status": "success",
        "length": stations.len(),
        "results": stations
    });
    HttpResponse::Ok().json(json_rsp)
}

#[get("/chip")]
pub async fn get_chip(data: web::Data<AppState>) -> impl Responder {
    let chip: Vec<Chip> = sqlx::query_as!(Chip, "select * from tbl_chip")
        .fetch_all(&data.db)
        .await
        .unwrap();
    let json_rsp = serde_json::json!({
        "status": "success",
        "length": chip.len(),
        "results": chip
    });
    HttpResponse::Ok().json(json_rsp)
}
