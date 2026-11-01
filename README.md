# NeNe Summit

An autonomous mountain-climbing platformer for your terminal.

**Planning / documentation bootstrap. No playable application or release exists yet.**

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

These commands need Git, Make and Python 3.10+. At this stage they check documentation
and the documentation checker only. They do not build or test a game.
Swift selection and full product gates are the first implementation milestone.

## Project policies

[Contributing](CONTRIBUTING.md) · [Security](SECURITY.md) · [Privacy](docs/PRIVACY.md) ·
[Original assets](docs/ASSET_POLICY.md) · [MIT license](LICENSE)
