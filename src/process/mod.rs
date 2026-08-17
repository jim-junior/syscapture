pub struct ProcessInfo {
    pub child_processes: Vec<ProcessInfo>,
    pub pid: u32,
    pub state: String,
    pub cmdline: String,
    pub memory_info: ProcessMemoryInfo,
    pub file_descriptors: Vec<FileDescriptorInfo>,
}

pub struct ProcessMemoryInfo {
    pub rss: u64,
    pub pss: u64,
    pub anonymous: u64,
    pub private_dirty: u64,
}

pub struct FileDescriptorInfo {
    pub fd: i32,
    pub path: String,
}
