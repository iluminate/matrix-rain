# matrix-rain

A Matrix-style digital rain animation written in pure Bash. No dependencies, no compiled binaries — just drop it in your terminal and run.

[![demo](https://asciinema.org/a/kKaa1yx23j68CLS1.svg)](https://asciinema.org/a/kKaa1yx23j68CLS1)

## Features

- Katakana characters, authentic to the film
- Per-column variable speed and length
- 4-level green gradient with smooth fade
- Flicker-free single-buffer rendering
- Runs on any terminal with ANSI support

## Requirements

| Tool | Purpose |
|------|---------|
| `bash` ≥ 4.0 | Associative arrays |
| `tput` | Terminal dimensions |

Both are preinstalled on Linux and macOS.

## Install

```bash
git clone https://github.com/iluminate/matrix-rain.git
cd matrix-rain
chmod +x matrix.sh
```

## Usage

```bash
./matrix.sh
```

Press `Ctrl+C` to exit. The terminal is fully restored on exit.

## Customization

| Variable | Location | Effect |
|----------|----------|--------|
| `RANDOM % 8 + 20` | `LEN` init | Column length (default 20–28) |
| `RANDOM % 3 + 2` | `SPD` init | Speed in frames per step (higher = slower) |
| `RANDOM % 10 + 8` | `CR` init | Char mutation rate (higher = slower) |
| `sleep 0.025` | main loop | Target framerate (~40 FPS) |

## Compatibility

Tested on:

- Ubuntu 22.04 / 24.04
- Debian 12
- macOS 13+ (with bash 5 via Homebrew)
- Arch Linux
- WSL2 (Windows Terminal)

## License

MIT