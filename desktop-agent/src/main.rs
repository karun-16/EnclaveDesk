mod agent;
mod logger;
mod state;
mod config;
mod service;
mod services;
mod device;
mod heartbeat;
mod constants;
mod network;

use agent::Agent;
use logger::Logger;
use config::Config;
use service::ServiceManager;
use device::Device;
use heartbeat::Heartbeat;
use network::Network;

use std::{thread, time::Duration};
#[tokio::main]
async fn main() {
    let config = Config::load();
    let device = Device::current();

Logger::info(
    &format!(
        "{} v{}",
        config.agent_name,
        config.version
    )
);
    Logger::info(
    &format!(
        "Device: {} ({})",
        device.name,
        device.os
    )
);
    let mut agent = Agent::new();

    agent.start();
    ServiceManager::start();
    Heartbeat::start().await; 
    
    Logger::info("Agent is running.");
    Logger::info("Press Ctrl+C to stop.");
    Network::start();

    loop {
        thread::sleep(Duration::from_secs(1));
    }
}