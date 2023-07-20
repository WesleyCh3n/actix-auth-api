use serde::Serialize;
// use serde_with::{serde_as, NoneAsEmptyString};

#[derive(Serialize, Debug)]
pub struct Station {
    pub id: i64,
    pub name: String,
    pub description: Option<String>,
    pub type_id: i64,
    pub recordmark_id: i64,
}

#[derive(Serialize, Debug)]
pub struct Chip {
    pub id: i64,
    pub name: String,
    pub description: Option<String>,
    pub vendor_id: i64,
    pub type_id: i64,
    pub recordmark_id: i64,
}

// #[serde_as]
#[derive(Serialize, Debug)]
pub struct Api {
    // #[serde_as(as = "NoneAsEmptyString")]
    pub sn: Option<String>,
    pub ppid: String,
    pub code: String,
    pub time: Option<String>,
}
