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
port: 8000
password: ""
enable_commercial_detection: true
```

## Recordings directory

The add-on sets `RECORDINGS_DIR=/data/recordings`. This path is persisted across
restarts by the add-on data store. Database files are stored in `/data/db`.

## Attribution

This add-on wraps and redistributes the upstream project:
https://github.com/swapplications/uhf-server-dist

