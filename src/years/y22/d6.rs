use aoc;
use std::collections::HashSet;

fn solve(part: aoc::AnswerPart) {
    let input = aoc::get_input(aoc::AdventDate { year: 2022, day: 6 });
    let end = match part {
        aoc::AnswerPart::One => 4,
        aoc::AnswerPart::Two => 14,
    } as usize; 
    'subroutine: for start in 0..input.len() - 4 {
        let stream = &input[start..start+end];
        let mut unique = HashSet::new();
        if stream.chars().all(|x| unique.insert(x)) {
            println!("{}", start + end);
            break 'subroutine;
        }
    }
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    solve(part);
}
