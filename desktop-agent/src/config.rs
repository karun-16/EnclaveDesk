pub struct Config {
    pub agent_name: String,
    pub version: String,
}

impl Config {
    pub fn load() -> Self {
        Self {
            agent_name: String::from("EnclaveDesk Agent"),
            version: String::from("0.1.0"),
        }
    }
}