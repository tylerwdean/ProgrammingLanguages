use rand::prelude::*;
use std::thread;
use std::sync::Arc;
use std::sync::mpsc;

fn main() {
    let v = initialize_vector();
    let thread_count = 10;
    let v_arc = Arc::new(v);    //for sharing v as read only

    let (tx, rx) = mpsc::channel();
    let mut handles = vec![];


    for i in 0..thread_count {
        let tx_clone = tx.clone();
        let v_reference = v_arc.clone();

        handles.push(thread::spawn(move || {
            println!("Starting thread {}", i);
            let range = 1_000_000/thread_count;
            let sum = sum_vector(&*v_reference, i*range, (i+1)*range);
            tx_clone.send(sum).unwrap();
            println!("Closing thread {}", i);
        }))
    }

    drop(tx);

    let mut sum: i64 = 0;
    for received in rx {
        sum += received;
        println!("Adding results together, sum is: {}", sum);
    }
    println!("Program completed");
}

fn sum_vector(v: &Vec<i32>, start: usize, end: usize) -> i64{
    
    let mut sum: i64 = 0;

    for i in start..end {
        sum += i64::from(v[i]);
    }

    return sum;
}

fn initialize_vector() -> Vec<i32>{

    println!("Starting vector initialization");
    let mut v = vec![];
    let mut rng = rand::rng();

    for i in 0..1_000_000 {
        //v.push((rng.random::<i32>() % 1_000_000).abs());  //this generates a random value array, which has different results each time
        v.push(i)   //this generates the same value each time, but demonstrates that the sum from threads are different
    }
    v.shuffle(&mut rng);    //makes it randomly distributed
    println!("Vector initialized");
    return v;
}