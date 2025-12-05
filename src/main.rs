use std::fs;

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
}
