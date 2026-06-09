pub struct Logger;

impl Logger {
    pub fn info(message: &str) {
        println!("[INFO] {}", message);
    }
}