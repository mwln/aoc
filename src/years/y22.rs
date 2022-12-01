use aoc::AnswerPart;

mod d1;

pub fn get_solution(day: u32, part: AnswerPart ) {
    match day {
        1 => d1::solution(part),
        _ => (),
    };
}