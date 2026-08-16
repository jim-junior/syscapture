use crate::utils::files;
use std::process::Command;

pub fn fetch_host_info() {
    let load = get_load_avg();
    let uptime = get_uptime();
    let hostname = get_hostname();
    let arch = get_arch();
    let cpu_count = get_cpu_count();
    let kernel_version = get_kernel_version();
    let mem_metrics = get_mem_metrics();

    // ==== PRINT OUTPUT ====
    print!("Hostname:            {}", hostname);
    print!("Architecture:        {}", arch);
    print!("CPU Count:           {}\n", cpu_count);
    print!("Kernel Version:      {}", kernel_version);
    print!("Memory Total:        {} kB\n", mem_metrics.mem_total);
    print!("Memory Free:         {} kB\n", mem_metrics.mem_free);
    print!("Memory Available:    {} kB\n", mem_metrics.mem_available);
    print!("Buffers:             {} kB\n", mem_metrics.buffers);
    print!("Cached:              {} kB\n", mem_metrics.cached);
    print!("Swap Total:          {} kB\n", mem_metrics.swap_total);
    print!("Swap Free:           {} kB\n", mem_metrics.swap_free);
    print!("Slab:                {} kB\n", mem_metrics.slab);
    print!("Uptime:              {}\n", uptime);
    print!("Load:                {}", load)
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

#[derive(Debug, Default)]
pub struct MemMetrics {
    pub mem_total: u64,
    pub mem_free: u64,
    pub mem_available: u64,
    pub buffers: u64,
    pub cached: u64,
    pub swap_total: u64,
    pub swap_free: u64,
    pub slab: u64,
}

fn get_mem_metrics() -> MemMetrics {
    // Read the entire file into a String
    let content = files::readfile("/proc/meminfo").expect("Failed to fetch memory info");

    // Initialize our struct with default values (0)
    let mut metrics = MemMetrics::default();

    for line in content.lines() {
        // Split each line into a key and a value at the first colon
        // e.g., "MemTotal" and "       15165512 kB"
        if let Some((key, value_str)) = line.split_once(':') {
            // Extract just the first word of the value string (the number)
            // This safely ignores the "kB" and any extra whitespace
            if let Some(num_str) = value_str.split_whitespace().next() {
                // Parse the string into a u64
                if let Ok(value) = num_str.parse::<u64>() {
                    // Match the key to our struct fields
                    match key.trim() {
                        "MemTotal" => metrics.mem_total = value,
                        "MemFree" => metrics.mem_free = value,
                        "MemAvailable" => metrics.mem_available = value,
                        "Buffers" => metrics.buffers = value,
                        "Cached" => metrics.cached = value,
                        "SwapTotal" => metrics.swap_total = value,
                        "SwapFree" => metrics.swap_free = value,
                        "Slab" => metrics.slab = value,
                        _ => {} // Ignore all other keys in the file
                    }
                }
            }
        }
    }

    metrics
}
