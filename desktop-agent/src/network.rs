use crate::{constants::PORT, device::Device, logger::Logger};
use std::io::{Read, Write};
use std::net::TcpListener;
use std::process::Command;
use std::fs;
use windows::Win32::UI::Input::KeyboardAndMouse as km;

pub struct Network;
fn get_apps() -> String {
    let mut apps = Vec::new();

    let paths = vec![
        r"C:\ProgramData\Microsoft\Windows\Start Menu\Programs",
    ];

    for path in paths {
        if let Ok(entries) = fs::read_dir(path) {
            for entry in entries.flatten() {
                let path = entry.path();

                if path.is_file() {
                    if let Some(name) = path.file_stem() {
                        let name =
                            name.to_string_lossy();

                        let full =
                            path.to_string_lossy();

                        apps.push(format!(
                            "{}|{}",
                            name,
                            full
                        ));
                    }
                }
            }
        }
    }

    apps.sort();

    apps.join(",")
}
impl Network {
    pub fn start() {
        let address = format!("0.0.0.0:{}", PORT);

        let listener = TcpListener::bind(&address).unwrap();

        Logger::info(&format!("Listening on {}", address));

        for mut stream in listener.incoming().flatten() {
            Logger::info("Client connected.");

            let mut buffer = [0; 1024];

            match stream.read(&mut buffer) {
                Ok(size) => {
                    if size == 0 {
                        continue;
                    }

                    let msg = String::from_utf8_lossy(&buffer[..size]);
                    let msg = msg.trim();

                    match msg {
                        "PING" => {
                            Logger::info("PING RECEIVED");
                        }

                        "DEVICE_INFO" => {
    let device = Device::current();

    let response = format!(
        "{}|{}|{}",
        device.name,
        device.os,
        device.user
    );

    let _ = stream.write_all(
        response.as_bytes()
    );

    let _ = stream.flush();

    Logger::info(
        "Device info sent."
    );
}
"SYSTEM_STATS" => {
    let response = format!(
        "{}|{}|{}|{}|{}",
        "Intel CPU",
        "Unknown GPU",
        "16 GB",
        "512 GB",
        "Unknown"
    );

    let _ = stream.write_all(
        response.as_bytes()
    );

    let _ = stream.flush();

    Logger::info(
        "System stats sent."
    );
}
"PAIR_CODE" => {
    let device = Device::current();

    let pair_code = format!(
        "ENCLAVEDESK|{}|192.168.0.5",
        device.name
    );

    Logger::info(&format!(
        "Pair code requested: {}",
        pair_code
    ));

    let _ = stream.write_all(
        pair_code.as_bytes()
    );

    let _ = stream.flush();
} 
                        "TIME" => {
                            Logger::info("Time command received.");
                        }
                        
                        "LIST_APPS" => {
    Logger::info("Installed apps requested.");

    let apps = get_apps();

    let _ = stream.write_all(
        apps.as_bytes()
    );

    let _ = stream.flush();
}

                        "LOCK" => {
                            Logger::info("Locking PC...");

                            let _ = Command::new("rundll32.exe")
                                .args([
                                    "user32.dll,LockWorkStation"
                                ])
                                .spawn();
                        }

                        "SHUTDOWN" => {
                            Logger::info("Shutting down PC...");

                            let _ = Command::new("shutdown")
                                .args([
                                    "/s",
                                    "/t",
                                    "0"
                                ])
                                .spawn();
                        }
                        "RESTART" => {
    Logger::info("Restarting PC...");

    let _ = Command::new("shutdown")
        .args([
            "/r",
            "/t",
            "0"
        ])
        .spawn();
}

"SIGNOUT" => {
    Logger::info("Signing out...");

    let _ = Command::new("shutdown")
        .args([
            "/l"
        ])
        .spawn();
}

"SLEEP" => {
    Logger::info("Sleeping PC...");

    let _ = Command::new("rundll32.exe")
        .args([
            "powrprof.dll,SetSuspendState",
            "0,1,0"
        ])
        .spawn();
}
"LEFT_CLICK" => {
    Logger::info("Left click.");

    unsafe {
        km::mouse_event(
            km::MOUSEEVENTF_LEFTDOWN,
            0,
            0,
            0,
            0,
        );

        km::mouse_event(
            km::MOUSEEVENTF_LEFTUP,
            0,
            0,
            0,
            0,
        );
    }
}

"RIGHT_CLICK" => {
    Logger::info("Right click.");

    unsafe {
        km::mouse_event(
            km::MOUSEEVENTF_RIGHTDOWN,
            0,
            0,
            0,
            0,
        );

        km::mouse_event(
            km::MOUSEEVENTF_RIGHTUP,
            0,
            0,
            0,
            0,
        );
    }
}
                        msg if msg.starts_with("OPEN_URL:") => {
                            let url =
                                msg.replace("OPEN_URL:", "");

                            Logger::info(&format!(
                                "Opening {}...",
                                url
                            ));

                            let _ = Command::new("cmd")
                                .args([
                                    "/C",
                                    "start",
                                    "",
                                    &url
                                ])
                                .spawn();
                        }

  msg if msg.starts_with("OPEN_PATH:") => {
    let path = msg.replace("OPEN_PATH:", "");

    Logger::info(&format!(
        "Opening path {}...",
        path
    ));

    let _ = Command::new("cmd")
        .args([
            "/C",
            "start",
            "",
            &path,
        ])
        .spawn();
}
                        msg if msg.starts_with("OPEN:") => {
                            let app_name =
                                msg.replace("OPEN:", "");

                            let app = match app_name.as_str() {
                                "cmd" => "cmd.exe",
                                "write" => "write.exe",
                                _ => app_name.as_str(),
                            };

                            Logger::info(&format!(
                                "Opening {}...",
                                app
                            ));

                            match Command::new(app).spawn() {
                                Ok(_) => {}
                                Err(e) => {
                                    Logger::info(&format!(
                                        "Failed: {}",
                                        e
                                    ));
                                }
                            }
                        }

                        msg if msg.starts_with("CLOSE:") => {
                            let app =
                                msg.replace("CLOSE:", "");

                            Logger::info(&format!(
                                "Closing {}...",
                                app
                            ));

                            let _ = Command::new("taskkill")
                                .args([
                                    "/F",
                                    "/IM",
                                    &app
                                ])
                                .spawn();
                        }

                        _ => {
                            Logger::info(&format!(
                                "Unknown command: {}",
                                msg
                            ));
                        }
                    }
                }

                Err(e) => {
                    Logger::info(&format!(
                        "Read error: {}",
                        e
                    ));
                }
            }
        }
    }
}