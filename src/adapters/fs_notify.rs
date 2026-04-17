use notify::{Config, Event, RecommendedWatcher, RecursiveMode, Watcher};
use tokio::sync::mpsc;

use crate::ports::{BoxFuture, FileWatchPort};
use crate::DynError;
use std::path::PathBuf;

pub struct NotifyFileWatcher {
    watcher: RecommendedWatcher,
    rx: mpsc::UnboundedReceiver<notify::Result<Event>>,
}

impl NotifyFileWatcher {
    pub fn new() -> Result<Self, DynError> {
        let (tx, rx) = mpsc::unbounded_channel();
        let watcher = RecommendedWatcher::new(
            move |res| {
                let _ = tx.send(res);
            },
            Config::default(),
        )?;

        Ok(Self { watcher, rx })
    }
}

impl FileWatchPort for NotifyFileWatcher {
    fn watch_paths(&mut self, roots: &[PathBuf]) -> Result<(), DynError> {
        for root in roots {
            self.watcher.watch(root, RecursiveMode::Recursive)?;
        }
        Ok(())
    }

    fn next_event<'a>(&'a mut self) -> BoxFuture<'a, Option<Result<Vec<PathBuf>, DynError>>> {
        Box::pin(async move {
            let event = self.rx.recv().await?;
            match event {
                Ok(ok_event) => Some(Ok(ok_event.paths)),
                Err(err) => Some(Err(Box::new(err) as crate::DynError)),
            }
        })
    }
}
