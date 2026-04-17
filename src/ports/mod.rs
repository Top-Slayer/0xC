use std::future::Future;
use std::path::{Path, PathBuf};
use std::pin::Pin;

use crate::core::nvim_session::NvimSession;
use crate::DynError;

pub type BoxFuture<'a, T> = Pin<Box<dyn Future<Output = T> + Send + 'a>>;

pub trait SessionRepository {
    fn list_sessions<'a>(&'a self) -> BoxFuture<'a, Result<Vec<NvimSession>, DynError>>;
}

pub trait NvimCommandPort {
    fn send_checktime<'a>(&'a self, socket: &'a Path) -> BoxFuture<'a, Result<(), DynError>>;
}

pub trait FileWatchPort {
    fn watch_paths(&mut self, roots: &[PathBuf]) -> Result<(), DynError>;
    fn next_event<'a>(&'a mut self) -> BoxFuture<'a, Option<Result<Vec<PathBuf>, DynError>>>;
}
