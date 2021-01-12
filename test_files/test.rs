use std::mem::{needs_drop, replace};

struct Gus {
    a: String,
}

impl Gus {
    fn do_it(&self) {}
}

struct Example {
    number: i32,
}

impl Example {
    fn boo() {
        println!("boo! Example::boo() was called!");
    }

    fn answer(&mut self) {
        self.number += 42;
    }

    fn get_number(&self) -> i32 {
        self.number
    }
}

fn main() {
    let s = "gus".to_string();
    let g = Gus {
        a: "gus".to_string(),
    };
    println!("TEST DONE");
}
