use crate::state::AgentState;
use std::{thread, time::Duration};

pub struct Agent {
    pub state: AgentState,
}

impl Agent {
    pub fn new() -> Self {
        Self {
            state: AgentState::Starting,
        }
    }

    pub fn start(&mut self) {
        println!("{:?}", self.state);
        thread::sleep(Duration::from_secs(1));

        self.state = AgentState::Initializing;
        println!("{:?}", self.state);
        thread::sleep(Duration::from_secs(1));

        self.state = AgentState::Ready;
        println!("{:?}", self.state);
    }
}