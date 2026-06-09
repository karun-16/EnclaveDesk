use crate::{constants::PORT, logger::Logger};
use std::net::TcpListener;

pub struct Network;

impl Network {
    pub fn start() {
        let address = format!("0.0.0.0:{}", PORT);

        let listener = match TcpListener::bind(&address) {
            Ok(listener) => {
                Logger::info(
                    &format!("Listening on {}", address)
                );
                listener
            }

            Err(e) => {
                Logger::info(
                    &format!("Failed: {}", e)
                );
                return;
            }
        };

        for stream in listener.incoming() {
            match stream {
                Ok(_) => {
                    Logger::info("Client connected.");
                }

                Err(e) => {
                    Logger::info(
                        &format!("Connection error: {}", e)
                    );
                }
            }
        }
    }
}