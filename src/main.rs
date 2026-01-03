use std::fs;
use std::path::PathBuf;

fn main() {
    use std::env::consts::{ARCH, FAMILY, OS};

    println!("OS   : {OS}");
    println!("ARCH : {ARCH}");
    println!("FAMILY: {FAMILY}");

    if OS == "linux" {
        if let Ok(data) = fs::read_to_string("/etc/os-release") {
            for line in data.lines() {
                if let Some(id) = line.strip_prefix("ID=").map(|s| s.trim_matches('"')) {
                    println!("Distro ID: {id}");
                }
                if let Some(name) = line.strip_prefix("NAME=").map(|s| s.trim_matches('"')) {
                    println!("Distro Name: {name}");
                }
            }
        }
    }

    let mut path: PathBuf = dirs::home_dir()
        .expect("Failed to get home directory")  // or handle properly
        .join(".0xC")
        .join("local")
        .join("config");

    fs::create_dir_all(&path).expect("Failed to create config directories");
    dbg!(path);

    // symlink(
    //     pwd.join("target/debug/_0xC"), 
    //     Path::new(&env::var("HOME").unwrap().join(".local/"))
    //     ).unwrap();

    // unsafe {
    //     env::set_var("XDG_CONFIG_HOME", pwd.join("config"));
    //     env::set_var("XDG_DATA_HOME",   pwd.join("local/share"));
    //     env::set_var("XDG_STATE_HOME",  pwd.join("local/state"));
    //     env::set_var("XDG_CACHE_HOME",  pwd.join("local/cache"));
    // }
    //
    // let args: Vec<_> = env::args().skip(1).collect();
    // Command::new("nvim").args(args).status().unwrap();
}
