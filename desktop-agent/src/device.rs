pub struct Device {
    pub name: String,
    pub os: String,
}

impl Device {
    pub fn current() -> Self {
        Self {
            name: std::env::var("COMPUTERNAME")
                .unwrap_or("Unknown PC".to_string()),
            os: std::env::consts::OS.to_string(),
        }
    }
}