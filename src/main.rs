use clap::{Parser, Subcommand};

pub mod host;
pub mod utils;

#[derive(Parser)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    HostInfo,
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Commands::HostInfo => {
            host::fetch_host_info();
        }
    }
}
