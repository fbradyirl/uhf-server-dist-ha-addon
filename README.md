This is a Home Assistant Add-on wrapper for the **uhf-server-dist** project located at https://github.com/swapplications/uhf-server-dist.

It clones the upstream repo each time the add-on starts and runs the UHF Server
listening on port 8000.

## Installation

1. Add this repository to your Home Assistant add-on store.
2. Install the add-on.
3. Start the add-on.

## Configuration

The wrapper attempts to auto-detect an entrypoint in the upstream repository.
If the upstream repo changes or the auto-detection fails, set a custom command:

```yaml
command: "./run.sh"
```

## Recordings directory

The add-on sets `RECORDINGS_DIR=/data/recordings`. This path is persisted across
restarts by the add-on data store.

## Attribution

This add-on wraps and redistributes the upstream project:
https://github.com/swapplications/uhf-server-dist

