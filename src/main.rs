use clap::{Parser, Subcommand};

pub mod host;
pub mod process;
pub mod utils;

#[derive(Parser)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    HostInfo,

    Capture {
        #[arg(short, long)]
        pid: u32,
    },
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Commands::HostInfo => {
            host::fetch_host_info();
        }
        Commands::Capture { pid } => {
            println!("Capturing process with PID: {}", pid);
        }
    }
}
