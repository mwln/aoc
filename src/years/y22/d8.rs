use aoc;

struct TreeMap {
    map: Vec<Vec<u32>>,
    visible_trees: usize,
    scenic_scores: Vec<Vec<u32>>,
}

struct Visibility {
    pub blocked: bool,
    pub trees_in_view: u32,
}

impl TreeMap {
    fn from(input: String) -> Self {
        let map: Vec<Vec<u32>> = input
            .lines()
            .map(|row| row.chars().filter_map(|c| c.to_digit(10)).collect())
            .collect();
        Self {
            map,
            visible_trees: 0,
            scenic_scores: Vec::new(),
        }
    }

    fn calculate_visibility(&mut self) {
        for row in 1..self.map_height() - 1 {
            for col in 1..self.map_width() - 1 {
                self.check_visibility(row, col);
            }
        }
    }

    fn calculate_scenic_scores(&mut self) {
        self.scenic_scores = vec![vec![0; self.map_width()]; self.map_height()];
        for row in 1..self.map_height() - 1 {
            for col in 1..self.map_width() - 1 {
                self.scenic_scores[row][col] = self.scenic_score(row, col);
            }
        }
    }

    fn best_scenic_score(&self) -> u32 {
        *self
            .scenic_scores
            .iter()
            .filter_map(|row| row.iter().max())
            .max()
            .expect("No max value found.")
    }

    fn map_width(&self) -> usize {
        self.map[0].len()
    }

    fn map_height(&self) -> usize {
        self.map.len()
    }

    fn tree_size(&self, row: usize, col: usize) -> u32 {
        self.map[row][col]
    }

    fn perimeter_trees(&self) -> usize {
        (self.map_height() + self.map_width()) * 2 - 4
    }

    fn visible_trees(&self) -> usize {
        self.visible_trees
    }

    fn check_visibility(&mut self, row: usize, col: usize) {
        if !self.up_visibility(row, col).blocked
            || !self.down_visibility(row, col).blocked
            || !self.left_visibility(row, col).blocked
            || !self.right_visibility(row, col).blocked
        {
            self.visible_trees += 1;
        }
    }

    fn scenic_score(&self, row: usize, col: usize) -> u32 {
        self.up_visibility(row, col).trees_in_view
            * self.down_visibility(row, col).trees_in_view
            * self.right_visibility(row, col).trees_in_view
            * self.left_visibility(row, col).trees_in_view
    }

    fn up_visibility(&self, row: usize, col: usize) -> Visibility {
        let mut trees_in_view: u32 = 1;
        for i in (0..row).rev() {
            if self.tree_size(row, col) <= self.tree_size(i, col) {
                return Visibility {
                    blocked: true,
                    trees_in_view,
                };
            }
            trees_in_view += 1;
        }
        trees_in_view -= 1;
        Visibility {
            blocked: false,
            trees_in_view,
        }
    }
    fn left_visibility(&self, row: usize, col: usize) -> Visibility {
        let mut trees_in_view: u32 = 1;
        for j in (0..col).rev() {
            if self.tree_size(row, col) <= self.tree_size(row, j) {
                return Visibility {
                    blocked: true,
                    trees_in_view,
                };
            }
            trees_in_view += 1;
        }
        trees_in_view -= 1;
        Visibility {
            blocked: false,
            trees_in_view,
        }
    }
    fn down_visibility(&self, row: usize, col: usize) -> Visibility {
        let mut trees_in_view: u32 = 1;
        for i in row + 1..self.map_height() {
            if self.tree_size(row, col) <= self.tree_size(i, col) {
                return Visibility {
                    blocked: true,
                    trees_in_view,
                };
            }
            trees_in_view += 1;
        }
        trees_in_view -= 1;
        Visibility {
            blocked: false,
            trees_in_view,
        }
    }
    fn right_visibility(&self, row: usize, col: usize) -> Visibility {
        let mut trees_in_view: u32 = 1;
        for j in col + 1..self.map_width() {
            if self.tree_size(row, col) <= self.tree_size(row, j) {
                return Visibility {
                    blocked: true,
                    trees_in_view,
                };
            }
            trees_in_view += 1
        }
        trees_in_view -= 1;
        Visibility {
            blocked: false,
            trees_in_view,
        }
    }
}

fn solve(part: aoc::AnswerPart) {
    let input = aoc::get_input(aoc::AdventDate { year: 2022, day: 8 });
    let mut tree_map = TreeMap::from(input);
    tree_map.calculate_visibility();
    tree_map.calculate_scenic_scores();
    println!(
        "part 1 {}",
        tree_map.perimeter_trees() + tree_map.visible_trees()
    );
    println!("part 2 {}", tree_map.best_scenic_score())
}

pub(crate) fn solution(part: aoc::AnswerPart) {
    solve(part);
}
