use std::time::UNIX_EPOCH;

use actix_web::{error, Error};
use jsonwebtoken::{
    decode, encode, errors::ErrorKind, Algorithm, DecodingKey, EncodingKey,
    Header, Validation,
};
use serde::{Deserialize, Serialize};

const KEY: &[u8; 6] = b"secret";

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    sub: String,
    company: String,
    exp: u64,
}

#[derive(Deserialize)]
pub struct UserInfo {
    pub email: String,
    pub password: String,
}

pub fn validate_token(token: &str) -> Result<(), Error> {
    let validation = Validation::new(Algorithm::HS256);
    let token_data = match decode::<Claims>(
        token,
        &DecodingKey::from_secret(KEY),
        &validation,
    ) {
        Ok(c) => c,
        Err(err) => match *err.kind() {
            ErrorKind::InvalidToken => {
                return Err(error::ErrorUnauthorized("InvalidToken"))
            }
            ErrorKind::InvalidIssuer => {
                return Err(error::ErrorUnauthorized("InvalidIssuer"))
            }
            ErrorKind::InvalidSignature => {
                return Err(error::ErrorUnauthorized("InvalidSignature"));
            }
            _ => return Err(error::ErrorUnauthorized("Other Token Error")),
        },
    };

    let curr = std::time::SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("time smaller then unix epoch")
        .as_secs();
    if curr > token_data.claims.exp {
        return Err(error::ErrorUnauthorized(
            "JWT had expried. Please login again",
        ));
    }
    Ok(())
}

pub fn generate_token(user_info: &UserInfo) -> Result<String, Error> {
    if user_info.email != "wesley@wesley.com" || user_info.password != "1234" {
        return Err(error::ErrorUnauthorized("username or password not found"));
    }

    let curr = std::time::SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("time smaller then unix epoch");

    let my_claims = Claims {
        sub: "wesley@wesley.com".to_owned(),
        company: "ASROCK".to_owned(),
        exp: (curr + std::time::Duration::from_secs(24 * 60 * 60)).as_secs(),
    };

    match encode(
        &Header::default(),
        &my_claims,
        &EncodingKey::from_secret(KEY),
    ) {
        Ok(t) => Ok(t),
        Err(_) => Err(error::ErrorInternalServerError("Create JWT Failed")),
    }
}
