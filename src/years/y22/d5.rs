use aoc::{get_input, AdventDate};
use std::collections::{HashMap, LinkedList};

const DATE: AdventDate = AdventDate {
    year: super::YEAR,
    day: 5,
};

fn fix_stack_index(i: usize) -> usize {
    (i - 1) / 4 + 1
}

fn end_of_stack(stacks: HashMap<usize, LinkedList<char>>) {
    for i in 0..stacks.len() {
        print!(
            "{}",
            stacks
                .get(&(i + 1))
                .expect("No key found in stack.")
                .back()
                .unwrap()
        );
    }
    println!();
}

fn create_stacks(input_stack_map: &str) -> HashMap<usize, LinkedList<char>> {
    let mut stacks: HashMap<usize, LinkedList<char>> = HashMap::new();
    input_stack_map.split("\n").for_each(|s| {
        s.chars()
            .enumerate()
            .filter(|(_, c)| c.is_alphabetic())
            .for_each(|(i, c)| {
                stacks
                    .entry(fix_stack_index(i))
                    .and_modify(|list| list.push_front(c))
                    .or_insert(LinkedList::from([c]));
            });
    });
    return stacks;
}

fn process_action(
    action: &Vec<usize>,
    stacks: &mut HashMap<usize, LinkedList<char>>,
    part: &aoc::AnswerPart,
) {
    let mut from = stacks.get(&action[1]).unwrap().clone();
    let mut to = stacks.get(&action[2]).unwrap().clone();
    let amount = if action[0] > from.len() {
        from.len()
    } else {
        action[0]
    };
    match part {
        aoc::AnswerPart::One => {
            for _ in 0..amount {
                to.push_back(from.pop_back().unwrap());
            }
        }
        aoc::AnswerPart::Two => {
            to.append(&mut from.split_off(from.len() - amount));
        }
    };
    stacks.insert(action[1], from);
    stacks.insert(action[2], to);
}

fn solve(part: &aoc::AnswerPart) {
    let input = get_input(DATE);
    let input_fixed: Vec<&str> = input.split("\n\n").collect();
    let mut stacks = create_stacks(input_fixed[0]);
    for action in input_fixed[1].lines() {
        let action_items: Vec<usize> = action
            .split_whitespace()
            .into_iter()
            .filter(|s| s.chars().all(char::is_numeric))
            .map(|s| s.parse::<usize>().unwrap())
            .collect();
        process_action(&action_items, &mut stacks, part);
    }
    end_of_stack(stacks);
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    match part {
        aoc::AnswerPart::One => solve(&aoc::AnswerPart::One),
        aoc::AnswerPart::Two => solve(&aoc::AnswerPart::Two),
    };
}
