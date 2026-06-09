use crate::logger::Logger;

pub struct Services;

impl Services {
    pub fn start() {
        Logger::info("Starting Connection Service...");
        Logger::info("Starting Presence Service...");
        Logger::info("Starting System Service...");
    }
}