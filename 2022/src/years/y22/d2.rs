use aoc::{get_input, AdventDate};

const DATE: AdventDate = AdventDate {
    year: super::YEAR,
    day: 2,
};

const WIN: u32 = 6;
const LOSS: u32 = 0;
const DRAW: u32 = 3;

const ROCK: (char, u32) = ('A', 1);
const PAPER: (char, u32) = ('B', 2);
const SCISSORS: (char, u32) = ('C', 3);

const NEED_WIN: char = 'Z';
const NEED_LOSS: char = 'X';

fn part1() {
    let input = get_input(DATE);
    let mut score: u32 = 0;
    for line in input.lines() {
        let elf: char = line.as_bytes()[0] as char;
        let me: char = line.as_bytes()[2] as char;
        println!("{}", elf);
        if elf == 'A' {
            match me {
                'X' => score += DRAW + ROCK.1,
                'Y' => score += WIN + PAPER.1,
                'Z' => score += LOSS + SCISSORS.1,
                _ => (),
            }
        } else if elf == 'B' {
            match me {
                'X' => score += LOSS + ROCK.1,
                'Y' => score += DRAW + PAPER.1,
                'Z' => score += WIN + SCISSORS.1,
                _ => (),
            }
        } else {
            match me {
                'X' => score += WIN + ROCK.1,
                'Y' => score += LOSS + PAPER.1,
                'Z' => score += DRAW + SCISSORS.1,
                _ => (),
            }
        }
    }
    println!("{}", score);
}

fn part2() {
    let input = get_input(DATE);
    let mut score: u32 = 0;
    for line in input.lines() {
        let elf: char = line.as_bytes()[0] as char;
        let me: char = line.as_bytes()[2] as char;
        if me == NEED_WIN {
            match elf {
                'A' => score += PAPER.1 + WIN,
                'B' => score += SCISSORS.1 + WIN,
                'C' => score += ROCK.1 + WIN,
                _ => (),
            }
        } else if me == NEED_LOSS {
            match elf {
                'A' => score += SCISSORS.1 + LOSS,
                'B' => score += ROCK.1 + LOSS,
                'C' => score += PAPER.1 + LOSS,
                _ => (),
            }
        } else {
            match elf {
                'A' => score += ROCK.1 + DRAW,
                'B' => score += PAPER.1 + DRAW,
                'C' => score += SCISSORS.1 + DRAW,
                _ => (),
            }
        }
    }
    println!("{}", score)
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    match part {
        aoc::AnswerPart::One => part1(),
        aoc::AnswerPart::Two => part2(),
    };
}
