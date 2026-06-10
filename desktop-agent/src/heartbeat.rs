use crate::logger::Logger;
use tokio::time::{sleep, Duration};

pub struct Heartbeat;

impl Heartbeat {
    pub async fn start() {
        Logger::info("Heartbeat active.");

        tokio::spawn(async {
            loop {
                sleep(Duration::from_secs(30)).await;
                Logger::info("Heartbeat OK");
            }
        });
    }
}