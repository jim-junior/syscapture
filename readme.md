# syscapture

`syscapture` is a small Linux incident-diagnostics CLI for taking a quick,
human-readable snapshot of a running process. It reads live process information
from `/proc` (and uses `ps` when available) and writes the result as Markdown,
making it easy to save, share, and compare diagnostic reports.

> [!NOTE]
> This project is under active development. Process metadata and open file
> descriptors are currently implemented. The `watch` command and broader host,
> memory, network, filesystem, and kernel collection are not implemented yet.

## What it captures

For a supplied process ID (PID), the current report includes:

- process state;
- parent process ID;
- kernel wait channel;
- program command;
- total number of open file descriptors, including standard input, output, and
  error; and
- a table of non-standard file descriptors, their targets, and whether the
  target has been deleted.

The report is printed to standard output, so it can be viewed in the terminal or
redirected to a `.md` file.

## Requirements

The capture tool is designed for Linux and requires:

- Bash;
- a mounted `/proc` filesystem;
- common command-line utilities: `awk`, `grep`, `ls`, `readlink`, and `wc`; and
- optionally, `ps` (usually supplied by `procps`). If `ps` is unavailable,
  `syscapture` falls back to reading process metadata directly from `/proc`.

Building the included diagnostic workloads additionally requires GNU Make and a
C compiler such as GCC.

## Quick start

No installation step is required. Clone the repository, enter its directory,
and capture a running process:

```bash
./main.sh capture <PID>
```

For example, capture the current shell and save the Markdown report:

```bash
./main.sh capture "$$" > diagnosis.md
```

You can then inspect `diagnosis.md` in a text editor or any Markdown viewer.

Permissions matter: Linux only exposes process details that the current user is
allowed to inspect. Run `syscapture` as the same user as the target process, or
use appropriately elevated privileges when required by the system's `/proc`
security settings.

## Command reference

```text
./main.sh <command> <PID>
```

### `capture`

Takes a one-time snapshot of a live process and writes a Markdown report to
standard output.

```bash
./main.sh capture 1234
./main.sh capture 1234 > process-1234.md
```

The command exits with an error if `/proc/<PID>` does not exist when collection
starts. A process can still exit during collection, so captures of short-lived
processes may be incomplete or fail.

### `watch`

```bash
./main.sh watch <PID>
```

`watch` is currently a placeholder: it prints `Watching...`, waits ten seconds,
and exits. It does not yet collect repeated snapshots.

## Example report

Output varies by process and by the permissions of the user running the tool.
A report has the following general shape:

```markdown
# Diagnosis Report

Report for Process 1234 at Wed Sep 23 14:30:00 EAT 2026

## Process Details

Process runtime stats

- State: S
- Parent Process PID: 1000
- Wait Channel: hrtimer_nanosleep
- Program Command: `/usr/bin/example`

### Open File list

Process 1234 has 4 Open File descriptors, this includes the standard streams

| File Descriptor | File Location       | File Deleted |
|-----------------|---------------------|--------------|
| 3               | `/var/log/app.log`  | NO           |
```

## Diagnostic workloads

The repository contains small C programs for creating reproducible process
conditions while developing or testing collectors. Build all of them with:

```bash
make
```

This creates the following executables in `bin/`:

| Executable | Purpose | Usage |
| --- | --- | --- |
| `bin/memory` | Allocates and touches a requested amount of memory, then sleeps. | `bin/memory <size_mb> <seconds>` |
| `bin/openfiles` | Opens each supplied file plus an unlinked temporary file, then sleeps for 120 seconds. | `bin/openfiles <file> [file ...]` |
| `bin/zombie` | Exercises child and grandchild process creation and waiting behavior. | `bin/zombie <count>` |

### Capture the memory workload

Start the workload in one terminal:

```bash
bin/memory 100 60
```

Copy the PID printed by the program, then capture it from another terminal:

```bash
./main.sh capture <PRINTED_PID> > memory-report.md
```

### Capture open files

```bash
bin/openfiles /etc/hosts /etc/resolv.conf
```

While it is sleeping, use the printed PID with `capture`. The report should show
the supplied files and the workload's deleted temporary file.

Remove generated workload binaries with:

```bash
make clean
```

## Project structure

```text
.
├── main.sh                    # CLI entry point and argument dispatch
├── lib/
│   ├── main.sh                # Capture orchestration and report header
│   └── collector/
│       ├── host.sh            # Placeholder for host-level collectors
│       └── process.sh         # Process metadata and file-descriptor collectors
├── workloads/
│   ├── memory/main.c          # Memory-allocation workload
│   ├── open_files/main.c      # Open/deleted-file workload
│   └── zombie/main.c          # Process-tree workload
└── Makefile                   # Builds workloads into bin/
```

The CLI sources `lib/main.sh`, which in turn loads the individual collectors.
Collectors write Markdown directly to standard output. This simple composition
model makes it straightforward to add a collector and call it from `capture`.

## Development

Check the Bash files for syntax errors:

```bash
bash -n main.sh lib/main.sh lib/collector/*.sh
```

Build the C workloads with compiler warnings enabled:

```bash
make clean && make
```

When changing collectors, test against both a normal long-running process and
the included workloads. Keep diagnostic output on standard output so redirection
continues to produce a self-contained Markdown report.

## Current limitations

- Linux is required because collection depends on `/proc`.
- Only one PID is accepted per invocation.
- `capture` is a point-in-time report; it does not monitor changes over time.
- `watch` and host-level collection are placeholders.
- Process and descriptor data can change while a report is being generated.
- Access to processes owned by another user may be restricted.
- There is not yet an automated test suite or packaged installer.

Reports may contain command names and sensitive filesystem paths. Review them
before posting them in an issue, chat, or other public location.

## Contributing

Issues and pull requests are welcome. Keep changes focused, run the Bash syntax
check, rebuild the workloads, and include a representative capture when adding
or modifying a collector.

## License

No license file is currently included. Until a license is added, the repository
owner retains all rights to the source code.
