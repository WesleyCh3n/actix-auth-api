use actix_web::{get, post, web, HttpResponse, Responder};

use crate::{auth::UserInfo, model::Station, AppState};

#[post("/auth")]
pub async fn get_auth(user_info: web::Json<UserInfo>) -> impl Responder {
    crate::auth::generate_token(&user_info)
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
        "results": stations.len(),
        "station": stations
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
        "results": stations.len(),
        "station": stations
    });
    HttpResponse::Ok().json(json_rsp)
}
