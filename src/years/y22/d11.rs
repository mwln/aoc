use aoc;
use itertools::Itertools;

fn solve(part: aoc::AnswerPart) {
    let input = aoc::get_input(aoc::AdventDate {
        year: 2022,
        day: 11,
    });
    let rounds = match &part {
        aoc::AnswerPart::One => 20,
        aoc::AnswerPart::Two => 10000,
    };

    let mut monkeys: Vec<Monkey> = Vec::new();
    for (id, monkey) in input.split("\n\n").enumerate() {
        monkeys.insert(id, Monkey::from(monkey));
    }

    let lcm: i64 = monkeys.iter().map(|m| m.test_by).product();

    for _ in 0..rounds {
        for idx in 0..monkeys.len() {
            monkeys.get_mut(idx).unwrap().do_operations(&part, &lcm);
            for _ in 0..monkeys[idx].num_items() {
                let inspected_item = monkeys[idx].items[0].clone();
                let throw_to_idx = (monkeys[idx].test)(&inspected_item);
                monkeys[throw_to_idx].items.push(inspected_item);
                monkeys[idx].items.remove(0);
            }
        }
    }
    println!(
        "part {part:#?} {}",
        monkeys
            .iter()
            .map(|monkey| monkey.items_inspected)
            .sorted()
            .rev()
            .take(2)
            .reduce(|accum, item| accum * item)
            .unwrap()
    );
}

enum Operation {
    Add(Option<i64>),
    Multiply(Option<i64>),
    Subtract(Option<i64>),
    None,
}

struct Monkey {
    id: usize,
    items: Vec<i64>,
    operation: Operation,
    test: Box<dyn Fn(&i64) -> usize>,
    items_inspected: usize,
    test_by: i64,
}

impl Monkey {
    fn from(monkey: &str) -> Self {
        let monkey_info = monkey
            .lines()
            .filter(|line| !line.trim().is_empty())
            .collect_vec();
        let id = monkey_info[0]
            .split_once(" ")
            .unwrap()
            .1
            .trim_end_matches(":")
            .parse::<usize>()
            .unwrap();
        let items = monkey_info[1]
            .trim()
            .split_once(": ")
            .unwrap()
            .1
            .trim()
            .split(", ")
            .map(|value| value.trim().parse::<i64>().unwrap())
            .collect_vec();

        let operation = Monkey::build_operation(monkey_info[2]);
        let test = Monkey::build_test(monkey_info[3..6].to_vec());
        let test_by = Monkey::get_test_val(monkey_info[3]);
        Self {
            id,
            items,
            items_inspected: 0,
            operation,
            test,
            test_by,
        }
    }

    fn num_items(&self) -> usize {
        self.items.len()
    }

    fn build_operation(op_line: &str) -> Operation {
        let (_, rhs_str) = op_line
            .split_once("=")
            .expect("Unexpected operation syntax.");
        let rhs = rhs_str.split_whitespace().collect_vec();
        let op = rhs[1];
        if let Ok(val) = rhs[2].parse::<i64>() {
            match op {
                "*" => Operation::Multiply(Some(val)),
                "-" => Operation::Subtract(Some(val)),
                "+" => Operation::Add(Some(val)),
                _ => Operation::None,
            }
        } else {
            match op {
                "*" => Operation::Multiply(None),
                "-" => Operation::Subtract(None),
                "+" => Operation::Add(None),
                _ => Operation::None,
            }
        }
    }

    fn get_test_val(test_line: &str) -> i64 {
        test_line
            .split_once("by ")
            .unwrap()
            .1
            .trim()
            .parse::<i64>()
            .expect("Could not parse test value.")
    }

    fn build_test(test_lines: Vec<&str>) -> Box<dyn Fn(&i64) -> usize> {
        let div_by = test_lines
            .get(0)
            .unwrap()
            .split_once("by ")
            .unwrap()
            .1
            .trim()
            .parse::<i64>()
            .expect("Could not parse test value.");
        let throw_to_ok = test_lines
            .get(1)
            .unwrap()
            .split_once("monkey")
            .unwrap()
            .1
            .trim()
            .parse::<usize>()
            .expect("Could not parse monkey index to throw to ok.");
        let throw_to_else = test_lines
            .get(2)
            .unwrap()
            .split_once("monkey")
            .unwrap()
            .1
            .trim()
            .parse::<usize>()
            .expect("Could not parse monkey index to throw to else.");

        return Box::new(move |x| {
            if x % &div_by == 0 {
                throw_to_ok
            } else {
                throw_to_else
            }
        });
    }

    fn do_operations(&mut self, part: &aoc::AnswerPart, lcm: &i64) {
        for item in &mut self.items {
            match &self.operation {
                Operation::Add(val) => {
                    if let Some(op_by) = val {
                        *item += op_by;
                    } else {
                        *item += item.clone();
                    }
                }
                Operation::Subtract(val) => {
                    if let Some(op_by) = val {
                        *item -= op_by;
                    } else {
                        *item -= item.clone();
                    }
                }
                Operation::Multiply(val) => {
                    if let Some(op_by) = val {
                        *item *= op_by;
                    } else {
                        *item *= item.clone();
                    }
                }
                Operation::None => (),
            }
            match part {
                aoc::AnswerPart::One => *item /= 3,
                aoc::AnswerPart::Two => *item = *item % lcm,
            }
            self.items_inspected += 1;
        }
    }
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    solve(part);
}
