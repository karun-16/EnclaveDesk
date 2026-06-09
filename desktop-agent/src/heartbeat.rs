use crate::logger::Logger;

pub struct Heartbeat;

impl Heartbeat {
    pub fn start() {
        Logger::info("Heartbeat active.");
    }
}