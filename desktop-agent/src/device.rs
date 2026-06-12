pub struct Device {
    pub name: String,
    pub os: String,
    pub user: String,
}

impl Device {
    pub fn current() -> Self {
        Self {
            name: std::env::var("COMPUTERNAME")
                .unwrap_or(
                    "Unknown PC".to_string(),
                ),

            os: std::env::consts::OS
                .to_string(),

            user: std::env::var("USERNAME")
                .unwrap_or(
                    "Unknown User"
                        .to_string(),
                ),
        }
    }
}