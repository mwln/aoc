use aoc::{get_input, AdventDate};
use std::collections::VecDeque;

const DATE: AdventDate = AdventDate {
    year: super::YEAR,
    day: 1,
};

fn part1() {
    let input = get_input(DATE);
    let mut elves = Vec::new();
    let mut cals: u32 = 0;
    for line in input.lines() {
        if line.is_empty() {
            elves.push(cals);
            cals = 0;
        } else {
            cals += u32::from_str_radix(line, 10).unwrap();
        }
    }
    println!("part 1, most calories: {:?}", elves.iter().max().unwrap());
}

fn part2() {
    let input = get_input(DATE);
    let mut top_3: VecDeque<u32> = VecDeque::from([0, 0, 0]);
    let mut cals = 0;
    for line in input.lines() {
        if line.is_empty() {
            if cals >= top_3[0] {
                top_3.push_front(cals);
                top_3.pop_back();
            } else if cals >= top_3[1] {
                top_3.insert(1, cals);
                top_3.pop_back();
            } else if cals >= top_3[2] {
                top_3.insert(2, cals);
                top_3.pop_back();
            }
            cals = 0;
        } else {
            cals += u32::from_str_radix(line, 10).unwrap();
        }
    }
    let top_3_total: u32 = top_3.iter().sum();
    println!("part 2, top 3 cumulative calories: {:?}", top_3_total);
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    match part {
        aoc::AnswerPart::One => part1(),
        aoc::AnswerPart::Two => part2(),
    };
}
