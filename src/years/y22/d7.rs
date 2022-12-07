use aoc;

struct Node {
    value: usize,
    parent: Option<usize>,
    children: Vec<usize>,
}

impl Node {
    fn is_directory(&self) -> bool {
        self.children.len() > 0
    }
}

struct Tree {
    files: Vec<Node>,
}

impl Tree {
    fn insert(&mut self, value: usize, parent: Option<usize>) -> Option<usize> {
        let index = self.files.len();
        if let Some(parent) = parent {
            self.files[parent].children.push(index);
            self.update_size(Some(parent), value);
        }
        self.files.push(Node {
            value,
            parent,
            children: vec![],
        });
        Some(index)
    }

    fn node(&self, index: Option<usize>) -> &Node {
        match index {
            Some(index) => &self.files[index],
            None => panic!("Trying to access a non-existing node"),
        }
    }

    fn update_size(&mut self, index: Option<usize>, size: usize) {
        let mut current = index;
        while let Some(index) = current {
            let node = &mut self.files[index];
            node.value += size;
            current = node.parent;
        }
    }
}

const MAX_DIR_SIZE: usize = 100000;
const TOTAL_DISK_SIZE: usize = 70000000;
const UPDATE_SIZE: usize = 30000000;

fn solve(part: aoc::AnswerPart) {
    let mut file_tree = Tree { files: vec![] };
    let mut current: Option<usize> = None;
    let input = aoc::get_input(aoc::AdventDate { year: 2022, day: 7 });
    input.lines().for_each(|cmd| {
        let cmd_split: Vec<&str> = cmd.split(" ").collect();
        match cmd_split[0] {
            "$" => match cmd_split[1] {
                "cd" => match cmd_split[2] {
                    ".." => {
                        current = file_tree.node(current).parent;
                    }
                    _ => {
                        current = file_tree.insert(0, current);
                    }
                },
                _ => {}
            },
            "dir" => {}
            _ => {
                file_tree.insert(cmd_split[0].parse::<usize>().unwrap_or_default(), current);
            }
        }
    });
    let directories: Vec<&Node> = file_tree
        .files
        .iter()
        .filter(|node| node.is_directory())
        .collect();

    let to_delete_size = UPDATE_SIZE - (TOTAL_DISK_SIZE - file_tree.files[0].value);

    match part {
        aoc::AnswerPart::One => println!(
            "part 1 {}",
            directories
                .iter()
                .filter(|node| node.value <= MAX_DIR_SIZE)
                .map(|node| node.value)
                .sum::<usize>()
        ),
        aoc::AnswerPart::Two => println!(
            "part 2 {}",
            directories
                .iter()
                .filter(|node| node.value >= to_delete_size)
                .map(|node| node.value)
                .min()
                .unwrap_or_default()
        ),
    }
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    solve(part);
}
