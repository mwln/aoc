use aoc::{get_input, AdventDate};

const DATE: AdventDate = AdventDate {
    year: super::YEAR,
    day: 3,
};

const ALPHABET: &str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

fn part1() {
    let input = get_input(DATE);
    let mut score = 0;
    for line in input.lines() {
        let ruck_size = line.len() / 2;
        let (part_one, part_two) = line.split_at(ruck_size);
        let dupe = part_one.chars()
            .find(|c| part_two.contains(&c.to_string()))
            .unwrap()
            .to_string();
        score += ALPHABET.rfind(&dupe).unwrap() as i32 + 1;
    }
    println!("{}", score);
}

fn part2() {
    let input = get_input(DATE);
    let mut elves: Vec<&str> = Vec::new();
    let mut score = 0;
    
    for line in input.lines() {
        if elves.len() < 2 {
            elves.push(line);
        } else {
            elves.push(line);
            let common = elves[0].chars()
                .find(|c| elves[1].contains(&c.to_string()) && elves[2].contains(&c.to_string()))
                .unwrap()
                .to_string();  
            score += ALPHABET.rfind(&common).unwrap() as i32 + 1;
            elves.clear();
        }
    }
    println!("{}", score);
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    match part {
        aoc::AnswerPart::One => part1(),
        aoc::AnswerPart::Two => part2(),
    };
}
