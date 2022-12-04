use aoc::{get_input, AdventDate};
use std::cmp;

const DATE: AdventDate = AdventDate {
    year: super::YEAR,
    day: 4,
};

fn make_elf(elf: &str) -> (u32, u32) {
    let nums: Vec<u32> = elf.split("-").map(|num| num.parse().unwrap()).collect();
    return (nums[0], nums[1]);
}

fn enclosure(a: (u32, u32), b: (u32, u32)) -> bool {
    let low: u32 = cmp::min(a.0, b.0);
    let high: u32 = cmp::max(a.1, b.1);
    (a.0 == low && a.1 == high) || (b.0 == low && b.1 == high)
}

fn overlap(a: (u32, u32), b: (u32, u32)) -> bool {
    !(a.0 > b.1 || b.0 > a.1)
}

fn part1() {
    let input = get_input(DATE);
    let mut enclosures = 0;
    for line in input.lines() {
        let pair: Vec<(u32, u32)> = line.split(",").map(|elf| make_elf(elf)).collect();
        if enclosure(pair[0], pair[1]) {
            enclosures += 1
        }
    }
    println!("{}", enclosures)
}

fn part2() {
    let input = get_input(DATE);
    let mut overlaps = 0;
    for line in input.lines() {
        let pair: Vec<(u32, u32)> = line.split(",").map(|elf| make_elf(elf)).collect();
        if overlap(pair[0], pair[1]) {
            overlaps += 1;
        }
    }
    println!("{}", overlaps);
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    match part {
        aoc::AnswerPart::One => part1(),
        aoc::AnswerPart::Two => part2(),
    };
}
