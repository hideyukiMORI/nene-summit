# NeNe Summit

An autonomous mountain-climbing platformer for your terminal.

**One room is playable in the terminal. There is no installer or release yet.**

[日本語](README.ja.md) · [Documentation](docs/README.md) · [Cursor handoff](docs/CURSOR_HANDOFF.md)

A climber runs, jumps, wall-jumps and air-dashes through original mountain rooms.
The intended screensaver watches an AI attempt the climb, retry and start another expedition.
Swift / ANSI terminal architecture follows [NeNe Bolt](https://github.com/hideyukiMORI/nene-bolt)
and [NeNe Swarm](https://github.com/hideyukiMORI/nene-swarm).
Detailed mechanics remain design proposals; see [requirements](docs/REQUIREMENTS.md).

## Start development

Open this repository root in Cursor. Read [AGENTS.md](AGENTS.md), then
[the handoff](docs/CURSOR_HANDOFF.md). Project rules live in `.cursor/rules/`.

```sh
make bootstrap
make check
swift run nene-summit
```

These commands need Git, Make, Python 3.10+, and the Swift toolchain named in `.swift-version`.
`make check` checks documents, commit messages, conformance, formatting, and lint,
then builds and tests in debug and release, and starts the game in a PTY until `q`.
Format and lint configurations stay strict.

Move with the arrow keys or `a` / `d`. `w` and `s` aim up and down.
`space` jumps, `k` dashes, `q` quits. The jump stays low.
A held key keeps moving until release. Terminals that never send release keep it while the key repeats.
Keys pressed together share one tick. Jump and dash fire on the press, not for the whole hold.
With no keys, a guide climbs and then retries the same room.
A title, a dash mark, and the keys sit under the mountain.
Speeds live in `MotionPolicy`. The pause and the give-up live in `Watch`. Both are design choices.

## Project policies

[Contributing](CONTRIBUTING.md) · [Security](SECURITY.md) · [Privacy](docs/PRIVACY.md) ·
[Original assets](docs/ASSET_POLICY.md) · [MIT license](LICENSE)
