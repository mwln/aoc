use aoc::{get_input, AdventDate};

const DATE: AdventDate = AdventDate {
    year: 2022,
    day: 1,
};

fn part1() {
    let input = get_input(aoc::DecideDate::Choose(DATE));
    for line in input.lines() {
        println!("{}", line)
    }
}

fn part2() {
    let input = get_input(aoc::DecideDate::Choose(DATE));
    for line in input.lines() {
        println!("{}", line)
    }
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    match part {
        aoc::AnswerPart::One => part1(),
        aoc::AnswerPart::Two => part2(),
    };
}