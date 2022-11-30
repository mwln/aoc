use reqwest::blocking::Client;
use reqwest::header::{HeaderMap, HeaderValue, CONTENT_TYPE, COOKIE};
use reqwest::redirect::Policy;
use std::env;
use dotenv::dotenv;

fn main() -> Result<(), String>{
    dotenv().ok();
    
    let day = 1;
    let year = 2021;
    let url = format!("https://adventofcode.com/{}/day/{}/input", year, day);

    let puzzle_input = build_client()?
        .get(&url)
        .send()
        .and_then(|response| response.error_for_status())
        .and_then(|response| response.text())
        .map_err(|err| err.to_string())?;

    for line in puzzle_input.lines() {
        println!("line here {}", line);
    }
 
    Ok(())
}

fn build_client() -> Result<Client, String> {
    let session_cookie = env::var("SESSION").expect("Must set .env variable SESSION.");
    let input_type: &str = "text/plain";

    let cookie_header =
        HeaderValue::from_str(&format!("session={}", session_cookie.trim()))
            .map_err(|err| format!("Invalid session cookie: {}", err))?;
    
            let content_type_header = HeaderValue::from_str(input_type).unwrap();

    let mut headers = HeaderMap::new();
    headers.insert(COOKIE, cookie_header);
    headers.insert(CONTENT_TYPE, content_type_header);

    Client::builder()
        .default_headers(headers)
        .redirect(Policy::none())
        .build()
        .map_err(|err| err.to_string())
}