use dotenv::dotenv;
use reqwest::blocking::Client;
use reqwest::header::{HeaderMap, HeaderValue, CONTENT_TYPE, COOKIE};
use reqwest::redirect::Policy;
use std::env;
use std::fs;
use std::path::Path;

#[derive(Debug)]
pub enum AnswerPart {
    One,
    Two,
}

pub struct AdventDate {
    pub year: i32,
    pub day: u32,
}

pub fn get_input(date: AdventDate) -> String {
    let (year, day) = (date.year, date.day);
    let input_file_path = format!("assets/{}/{}.txt", year, day);
    let year_path = format!("assets/{}", year);
    if year_asset_exists(year) {
        if input_asset_exists(year, day) {
            return fs::read_to_string(&input_file_path).unwrap();
        } else {
            _ = download_input(year, day);
            return fs::read_to_string(&input_file_path).unwrap();
        }
    } else {
        _ = fs::create_dir(&year_path);
        _ = download_input(year, day);
        return fs::read_to_string(&input_file_path).unwrap();
    }
}

fn download_input(year: i32, day: u32) -> Result<(), String> {
    let url = format!("https://adventofcode.com/{}/day/{}/input", year, day);
    let filename = format!("assets/{}/{}.txt", year, day);

    let puzzle_input = build_client()?
        .get(&url)
        .send()
        .and_then(|response| response.error_for_status())
        .and_then(|response| response.text())
        .map_err(|err| err.to_string())?;

    fs::write(filename, puzzle_input).map_err(|err| err.to_string())?;

    Ok(())
}

fn year_asset_exists(year: i32) -> bool {
    let relative_dir = format!("assets/{}", year);
    Path::new(&relative_dir).exists()
}

fn input_asset_exists(year: i32, day: u32) -> bool {
    let relative_dir = format!("assets/{}/{}.txt", year, day);
    Path::new(&relative_dir).exists()
}

fn build_client() -> Result<Client, String> {
    dotenv().ok();
    let session_cookie = env::var("SESSION").expect("Must set .env variable SESSION.");
    let input_type: &str = "text/plain";

    let cookie_header = HeaderValue::from_str(&format!("session={}", session_cookie.trim()))
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
