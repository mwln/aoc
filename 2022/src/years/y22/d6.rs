use aoc;
use itertools::Itertools;

fn solve(part: aoc::AnswerPart) {
    let input = aoc::get_input(aoc::AdventDate { year: 2022, day: 6 });
    let size = match part {
        aoc::AnswerPart::One => 4,
        aoc::AnswerPart::Two => 14,
    } as usize;
    println!(
        "{}",
        input
            .as_bytes()
            .windows(size)
            .position(|b| b.iter().unique().count() == size)
            .unwrap()
            + size,
    );
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    solve(part);
}
