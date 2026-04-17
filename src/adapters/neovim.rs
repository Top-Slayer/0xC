use nvim_rs::{create::tokio as create, rpc::handler::Dummy};
use std::env;
use std::fs;
use std::io;
use std::os::unix::fs::FileTypeExt;
use std::path::{Path, PathBuf};

use crate::core::nvim_session::NvimSession;
use crate::ports::{BoxFuture, NvimCommandPort, SessionRepository};
use crate::DynError;

pub struct NvimAdapter {
    runtime_dir: PathBuf,
}

impl NvimAdapter {
    pub fn new_from_env() -> Self {
        let runtime_dir = env::var("XDG_RUNTIME_DIR")
            .map(PathBuf::from)
            .unwrap_or_else(|_| PathBuf::from(format!("/run/user/{}", unsafe { libc::getuid() })));

        Self { runtime_dir }
    }

    fn list_nvim_sockets(&self) -> Result<Vec<PathBuf>, DynError> {
        let mut results = Vec::new();
        let entries = fs::read_dir(&self.runtime_dir)?;

        for entry in entries.flatten() {
            let path = entry.path();
            if let Ok(meta) = entry.metadata() {
                if meta.file_type().is_socket()
                    && path
                        .file_name()
                        .and_then(|s| s.to_str())
                        .map(|name| name.starts_with("nvim"))
                        .unwrap_or(false)
                {
                    results.push(path);
                }
            }
        }

        Ok(results)
    }

    async fn get_root_working_dir(&self, socket: &Path) -> Result<PathBuf, DynError> {
        let (nvim, io_handler) = create::new_path(socket, Dummy::new()).await?;
        let value = nvim
            .exec_lua(
                r#"
                    local bufname = vim.api.nvim_buf_get_name(0)
                    local start = (bufname ~= "" and vim.fn.fnamemodify(bufname, ":p:h")) or vim.loop.cwd()
                    local git = vim.fs.find(".git", { upward = true, path = start })[1]
                    if git then
                        return vim.fn.fnamemodify(git, ":h")
                    end
                    return vim.fn.getcwd()
                "#,
                vec![],
            )
            .await?;

        io_handler.abort();

        let root = value.as_str().ok_or_else(|| {
            io::Error::new(io::ErrorKind::InvalidData, "working directory is not a string")
        })?;
        Ok(PathBuf::from(root))
    }
}

impl SessionRepository for NvimAdapter {
    fn list_sessions<'a>(&'a self) -> BoxFuture<'a, Result<Vec<NvimSession>, DynError>> {
        Box::pin(async move {
            let sockets = self.list_nvim_sockets()?;
            let mut sessions = Vec::new();

            for socket in sockets {
                let working_dir = self.get_root_working_dir(&socket).await?;
                sessions.push(NvimSession {
                    socket,
                    working_dir,
                });
            }

            Ok(sessions)
        })
    }
}

impl NvimCommandPort for NvimAdapter {
    fn send_checktime<'a>(&'a self, socket: &'a Path) -> BoxFuture<'a, Result<(), DynError>> {
        Box::pin(async move {
            let (nvim, io_handler) = create::new_path(socket, Dummy::new()).await?;
            nvim.command("silent! checktime").await?;
            io_handler.abort();
            Ok(())
        })
    }
}
