use aoc::AnswerPart;

mod d1;
mod d2;
mod d3;
mod d4;

pub const YEAR: i32 = 2022;

pub fn get_solution(day: u32, part: AnswerPart ) {
    match day {
        1 => d1::solution(part),
        2 => d2::solution(part),
        3 => d3::solution(part),
        4 => d4::solution(part),
        _ => (),
    };
}