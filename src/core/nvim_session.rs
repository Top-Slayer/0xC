use std::path::PathBuf;

#[derive(Clone, Debug)]
pub struct NvimSession {
    pub socket: PathBuf,
    pub working_dir: PathBuf,
}
