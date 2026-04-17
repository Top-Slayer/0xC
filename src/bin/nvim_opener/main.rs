use std::env;
use std::error::Error;
use std::process::Command;
use std::os::unix::process::CommandExt;
use std::fs::OpenOptions;
use std::io::Write;

use libc;

fn save_log(message: String) {
    let home = env::var("HOME").unwrap_or_else(|_| ".".into());
    let log_path = format!("{}/opener.log", home);

    if let Ok(mut file) = OpenOptions::new()
        .create(true)
        .append(true)
        .open(log_path)
    {
        let uid = unsafe { libc::getuid() };
        let _ = writeln!(
            file,
            "[ERROR] {} | UID: {:?}, USER {:?}, PATH {:?}, HOME: {:?}, SHELL: {:?}",
            message, uid, std::env::var("USER"), std::env::var("PATH"), std::env::var("HOME"), std::env::var("SHELL")
        );
    }
}


fn main() -> Result<(), Box<dyn Error>> {
    save_log("Nvim opener start...".to_string());
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        let msg = "Usage: nvim_opener nvim://path/to/file:line".to_string();
        eprintln!("{}", msg);
        save_log(msg);
        std::process::exit(1);
    }

    let url = &args[1];

    if let Some(u) = url.strip_prefix("nvim://") {
        if let Some((path, line)) = u.rsplit_once(':') {
            let mut cmd = Command::new("nvim"); 
            cmd.arg(format!("+{}", line)).arg(path);

            let err = cmd.exec();

            let err_msg = format!(
                "Neovim failed to launch at [{}:{}:{}] -> {}",
                file!(), line!(), column!(), err
            );
            
            eprintln!("{}", err_msg);
            save_log(err_msg);
            std::process::exit(1);
        }
    } else {
        let err_msg = format!(
            "Invalid protocol. Expected nvim://... [{}:{}:{}]",
            file!(), line!(), column!()
        );
        eprintln!("{}", err_msg);
        save_log(err_msg);
        std::process::exit(1);
    }

    Ok(())
}
