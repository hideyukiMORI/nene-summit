# NeNe Summit

An autonomous mountain-climbing platformer for your terminal.

**Toolchain and a minimal Core module are in the tree. No playable climb or release exists yet.**

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
```

These commands need Git, Make, Python 3.10+, and the Swift toolchain named in `.swift-version`.
`make check` checks documents, commit messages, conformance, formatting, and lint,
then builds and tests Core in debug and release.
Passing it does not mean the climb exists. Format and lint configurations stay strict.

## Project policies

[Contributing](CONTRIBUTING.md) · [Security](SECURITY.md) · [Privacy](docs/PRIVACY.md) ·
[Original assets](docs/ASSET_POLICY.md) · [MIT license](LICENSE)
