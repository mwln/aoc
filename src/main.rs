use aoc::get_input;

fn main() {
    let date= aoc::AdventDate { year: 2021, day: 1 };
    let input: aoc::DecideDate = aoc::DecideDate::Choose(date);
    let d1_2021 = get_input(input);
    for line in d1_2021.lines() {
        println!("{}", line);
    }
}
