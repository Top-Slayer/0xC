use _0xC::adapters::fs_notify::NotifyFileWatcher;
use _0xC::adapters::neovim::NvimAdapter;
use _0xC::core::watch_changed_files_use_case::WatchChangedFilesUseCase;

#[tokio::main]
async fn main() {
    let repository = NvimAdapter::new_from_env();
    let commander = NvimAdapter::new_from_env();
    let watcher = match NotifyFileWatcher::new() {
        Ok(w) => w,
        Err(err) => {
            eprintln!("failed to initialize watcher: {err}");
            return;
        }
    };

    let use_case = WatchChangedFilesUseCase::new(repository, commander, watcher);
    if let Err(e) = use_case.run().await {
        eprintln!("service error: {e}");
    }
}
