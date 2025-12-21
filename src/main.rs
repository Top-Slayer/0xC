use std::{env, fs};


fn main() {
    println!("OS     : {}", std::env::consts::OS);
    println!("ARCH   : {}", std::env::consts::ARCH);
    println!("FAMILY : {}", std::env::consts::FAMILY);

    if std::env::consts::OS == "linux" {
        if let Ok(data) = fs::read_to_string("/etc/os-release") {
            for line in data.lines() {
                if line.starts_with("ID=") {
                    println!("Distro ID: {}", line.trim_start_matches("ID=").trim_matches('"'));
                }
                if line.starts_with("NAME=") {
                    println!("Distro Name: {}", line.trim_start_matches("NAME=").trim_matches('"'));
                }
            }
        }
    }


    let mut path = env::home_dir().unwrap().join(".0xC");
    path.push("local");
    path.push("config");

    fs::create_dir_all(&path).unwrap();

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
