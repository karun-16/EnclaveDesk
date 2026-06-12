use crate::logger::Logger;
use std::net::UdpSocket;
use std::thread;

pub struct Discovery;

impl Discovery {
    pub fn start() {
        thread::spawn(|| {
            let socket =
                UdpSocket::bind("0.0.0.0:7879")
                    .unwrap();

            Logger::info(
                "Discovery listening on UDP 7879",
            );

            let mut buf = [0; 1024];

            loop {
                if let Ok((size, src)) =
                    socket.recv_from(&mut buf)
                {
                    let msg =
                        String::from_utf8_lossy(
                            &buf[..size],
                        );

                    Logger::info(
                        &format!(
                            "Discovery: {}",
                            msg
                        ),
                    );

                    if msg.trim()
                        == "ENCLAVEDESK_DISCOVER"
                    {
                        let response =
                            "ENCLAVEDESK|ACER|192.168.0.5|7878";

                        let _ = socket.send_to(
                            response.as_bytes(),
                            src,
                        );

                        Logger::info(
                            "Discovery response sent.",
                        );
                    }
                }
            }
        });
    }
}