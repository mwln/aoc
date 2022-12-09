use aoc;
use std::cmp::Ordering::*;
use std::collections::HashSet;

struct Motion {
    direction: String,
    steps: isize,
}

impl Motion {
    fn from(input_line: &str) -> Self {
        let new_line: Vec<&str> = input_line.split_whitespace().collect();
        let direction = new_line[0].to_string();
        let steps = new_line[1]
            .parse::<isize>()
            .expect("Expected valid number.");
        Self { direction, steps }
    }
}

fn part1() {
    let input = aoc::get_input(aoc::AdventDate { year: 2022, day: 9 });
    let mut visited = HashSet::new();
    let mut head = [0; 2];
    let mut tail = [0; 2];
    visited.insert(tail);

    for motion in input.lines().map(|line| Motion::from(line)) {
        match motion.direction.as_str() {
            "D" => head[0] -= motion.steps,
            "U" => head[0] += motion.steps,
            "L" => head[1] -= motion.steps,
            "R" => head[1] += motion.steps,
            _ => panic!(),
        };
        while tail
            .iter()
            .zip(&head)
            .any(|(&t, &h)| t < h - 1 || t > h + 1)
        {
            for (t, h) in tail.iter_mut().zip(&head) {
                match (*t).cmp(h) {
                    Greater => *t -= 1,
                    Less => *t += 1,
                    Equal => (),
                }
            }
            visited.insert(tail);
        }
    }
    println!("part 1: {}", visited.len())
}

const ROPE_LENGTH: usize = 10;

fn part2() {
    let input = aoc::get_input(aoc::AdventDate { year: 2022, day: 9 });
    let mut visited = std::collections::HashSet::new();
    let mut rope = [[0i16; 2]; ROPE_LENGTH];
    visited.insert(*rope.last().unwrap());

    for motion in input.lines().map(|line| Motion::from(line)) {
        for _ in 0..motion.steps {
            match motion.direction.as_str() {
                "L" => rope[0][0] -= 1,
                "R" => rope[0][0] += 1,
                "D" => rope[0][1] -= 1,
                "U" => rope[0][1] += 1,
                _ => panic!(),
            }

            for knot in 1..rope.len() {
                let (front, back) = rope.split_at_mut(knot);
                if back
                    .first()
                    .unwrap()
                    .iter()
                    .zip(front.last().unwrap())
                    .any(|(&t, &h)| t < h - 1 || t > h + 1)
                {
                    for (t, h) in back
                        .first_mut()
                        .unwrap()
                        .iter_mut()
                        .zip(front.last().unwrap())
                    {
                        match (*t).cmp(h) {
                            Greater => *t -= 1,
                            Less => *t += 1,
                            Equal => {}
                        }
                    }
                    if knot == ROPE_LENGTH - 1 {
                        visited.insert(*back.first().unwrap());
                    }
                }
            }
        }
    }
    println!("{}", visited.len())
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    match part {
        aoc::AnswerPart::One => part1(),
        aoc::AnswerPart::Two => part2(),
    }
}
