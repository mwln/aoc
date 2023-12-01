use aoc;

fn part1() {
    let input = aoc::get_input(aoc::AdventDate {
        year: 2022,
        day: 10,
    });
    let mut reg_x = 1;
    let mut cycle = 1;
    let mut signal_cycle = 1;
    let mut signal_strengths = 0;
    for line in input.lines() {
        let mut add_value: i32 = 0;
        if let Some(cmd) = line.split_once(" ") {
            add_value = cmd.1.parse::<i32>().expect("Expected number here.");
            cycle += 1;
        }
        if (cycle + 20) / 40 >= signal_cycle {
            signal_strengths += reg_x * (signal_cycle * 40 - 20);
            signal_cycle += 1;
        }
        reg_x += add_value;
        cycle += 1;
    }
    println!("signal strengths: {}", signal_strengths);
}

fn print_crt(crt: Vec<Vec<char>>) {
    for line in crt.iter() {
        for c in line.iter() {
            if *c != '.' {
                print!("{c}");
            } else {
                print!(" ");
            }
        }
        print!("\n");
    }
}

fn sprite_overlaps_crt(sprite_cursor: i32, crt_cursor: usize) -> bool {
    for i in -1..2 {
        if sprite_cursor + i == crt_cursor as i32 {
            return true;
        }
    }
    false
}

fn fix_crt_cursors(crt_cursor: &mut usize, crt_row: &mut usize) {
    *crt_cursor += 1;
    if *crt_cursor % 40 == 0 {
        *crt_row += 1;
        *crt_cursor = 0;
    }
}

fn part2() {
    let input = aoc::get_input(aoc::AdventDate {
        year: 2022,
        day: 10,
    });
    let mut crt: Vec<Vec<char>> = vec![vec!['.'; 40]; 6];
    let mut crt_cursor: usize = 0;
    let mut crt_row = 0;
    let mut sprite_cursor = 1;

    for line in input.lines() {
        let mut add_value: i32 = 0;
        if sprite_overlaps_crt(sprite_cursor, crt_cursor) {
            crt[crt_row][crt_cursor] = '#';
        }
        if let Some(cmd) = line.split_once(" ") {
            add_value = cmd.1.parse::<i32>().expect("Expected number here.");
            fix_crt_cursors(&mut crt_cursor, &mut crt_row);
            if sprite_overlaps_crt(sprite_cursor, crt_cursor) {
                crt[crt_row][crt_cursor] = '#';
            }
        }
        sprite_cursor += add_value;
        fix_crt_cursors(&mut crt_cursor, &mut crt_row);
    }
    print_crt(crt);
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    match part {
        aoc::AnswerPart::One => part1(),
        aoc::AnswerPart::Two => part2(),
    }
}
