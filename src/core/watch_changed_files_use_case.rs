use std::collections::HashSet;
use std::path::PathBuf;

use crate::ports::{FileWatchPort, NvimCommandPort, SessionRepository};
use crate::DynError;

pub struct WatchChangedFilesUseCase<R, C, W>
where
    R: SessionRepository,
    C: NvimCommandPort,
    W: FileWatchPort,
{
    repository: R,
    commander: C,
    watcher: W,
}

impl<R, C, W> WatchChangedFilesUseCase<R, C, W>
where
    R: SessionRepository,
    C: NvimCommandPort,
    W: FileWatchPort,
{
    pub fn new(repository: R, commander: C, watcher: W) -> Self {
        Self {
            repository,
            commander,
            watcher,
        }
    }

    pub async fn run(mut self) -> Result<(), DynError> {
        let sessions = self.repository.list_sessions().await?;
        if sessions.is_empty() {
            eprintln!("No active Neovim sockets found.");
            return Ok(());
        }

        let mut roots_set = HashSet::<PathBuf>::new();
        for session in &sessions {
            roots_set.insert(session.working_dir.clone());
        }

        let roots = roots_set.into_iter().collect::<Vec<_>>();
        self.watcher.watch_paths(&roots)?;

        loop {
            let Some(event) = self.watcher.next_event().await else {
                break;
            };

            let _paths = match event {
                Ok(paths) => paths,
                Err(err) => {
                    eprintln!("watch error: {err}");
                    continue;
                }
            };

            for session in &sessions {
                if let Err(err) = self.commander.send_checktime(&session.socket).await {
                    eprintln!(
                        "failed to send checktime to {}: {err}",
                        session.socket.display()
                    );
                }
            }
        }

        Ok(())
    }
}
