use crate::utils::files;
use std::process::Command;

pub fn fetch_host_info() {
    let load = get_load_avg();
    let uptime = get_uptime();
    let hostname = get_hostname();
    let arch = get_arch();
    let cpu_count = get_cpu_count();
    let kernel_version = get_kernel_version();

    // ==== PRINT OUTPUT ====
    print!("Hostname:        {}", hostname);
    print!("Architecture:    {}", arch);
    print!("CPU Count:       {}\n", cpu_count);
    print!("Kernel Version:  {}", kernel_version);
    print!("Uptime:          {}\n", uptime);
    print!("Load:            {}", load)
}

fn get_load_avg() -> String {
    let loadavg = files::readfile("/proc/loadavg").expect("Failed to fetch Load");

    return loadavg;
}

fn get_hostname() -> String {
    let hostname = files::readfile("/etc/hostname").expect("Failed to fetch hostname");

    return hostname;
}

fn get_arch() -> String {
    let output = Command::new("uname")
        .arg("-m")
        .output()
        .expect("Failed to execute `uname` command");

    let stdout = String::from_utf8_lossy(&output.stdout);

    return stdout.to_string();
}

fn get_uptime() -> String {
    let uptime_raw = files::readfile("/proc/uptime").expect("Failed to fetch Uptime");

    // Split the string by whitespace and take the first item
    let uptime_str = uptime_raw
        .split_whitespace()
        .next()
        .expect("Uptime file was empty");

    let float_uptime_secs: f64 = uptime_str.parse::<f64>().expect("Failed to parse uptime");

    let hours: i32 = (float_uptime_secs / 3600.0) as i32;

    let minutes: i32 = (float_uptime_secs / 60.0) as i32 % 60;

    let seconds: i32 = float_uptime_secs as i32 % 60;

    return format!("{}h {}m {}s", hours, minutes, seconds);
}

fn get_cpu_count() -> String {
    let cpuinfo = files::readfile("/proc/cpuinfo").expect("Failed to fetch CPU info");

    let cpu_count = cpuinfo.matches("processor").count();

    return cpu_count.to_string();
}

fn get_kernel_version() -> String {
    let output = Command::new("uname")
        .arg("-r")
        .output()
        .expect("Failed to execute `uname` command");

    let stdout = String::from_utf8_lossy(&output.stdout);

    return stdout.to_string();
}
