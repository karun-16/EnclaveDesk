use crate::{
    logger::Logger,
    services::Services,
};

pub struct ServiceManager;

impl ServiceManager {
    pub fn start() {
        Logger::info("Loading services...");

        Services::start();

        Logger::info("Services started.");
    }
}