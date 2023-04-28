use serde::Serialize;

#[derive(Serialize, Debug)]
pub struct Station {
    pub id: i64,
    pub name: String,
    pub description: Option<String>,
    pub type_id: i64,
    pub recordmark_id: i64,
}
