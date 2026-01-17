This is a Home Assistant Add-on wrapper for the **uhf-server-dist** project
located at https://github.com/swapplications/uhf-server-dist.

It runs the UHF Server (from the upstream Docker image) listening on port 8000.

## Installation

1. Add this repository to your Home Assistant add-on store.
2. Install the add-on.
3. Start the add-on.

## Configuration

The wrapper runs `uhf-server` by default. You can override the command if needed:

```yaml
command: "uhf-server --port 8000 --recordings-dir /data/recordings"
```

Optional settings:

```yaml
host: "0.0.0.0"
port: 8000
password: ""
enable_commercial_detection: true
extra_args: ""
ffmpeg_path: ""
comskip_path: ""
db_path: ""
log_level: "INFO"
```

## Recordings directory

The add-on sets `RECORDINGS_DIR=/data/recordings`. This path is persisted across
restarts by the add-on data store. Database files are stored in `/data/db`.

## Recording errors (HTTP 458)

Some providers block direct ffmpeg requests unless a specific user agent or
headers are set. If you see HTTP 4xx probe errors from ffmpeg, try passing extra
arguments to `uhf-server` using `extra_args` (only if the upstream binary
supports those flags), or use a different source URL. The upstream help output
does not list user-agent or header flags, so those may not be supported.

## Attribution

This add-on wraps and redistributes the upstream project:
https://github.com/swapplications/uhf-server-dist

