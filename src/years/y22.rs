use aoc::AnswerPart;

mod d1;

pub const YEAR: i32 = 2022;

pub fn get_solution(day: u32, part: AnswerPart ) {
    match day {
        1 => d1::solution(part),
        _ => (),
    };
}