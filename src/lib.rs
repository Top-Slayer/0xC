pub mod adapters;
pub mod core;
pub mod ports;

pub type DynError = Box<dyn std::error::Error + Send + Sync>;
