# Coding harnesses

Machine-specific installation and runtime configuration for coding agents. This
repository complements, but does not replace,
[pirafrank/skills](https://github.com/pirafrank/skills).

## Separation of concerns

| Repository | Owns | Does not own |
| --- | --- | --- |
| [pirafrank/skills](https://github.com/pirafrank/skills) | Portable Agent Skills, shared `AGENTS.md`, policies, roles, language/domain profiles, workflow templates, and schemas. | Machine credentials, runtime state, or installation side effects. |
| `dotfiles/harnesses` | Runtime installation and discovery links for machine-specific coding harnesses. | Portable engineering behavior or duplicated skills, roles, and policies. |

Change reusable agent guidance in `pirafrank/skills`; change a specific harness
or machine integration here. The installer reads the skills checkout from
`~/.local/share/skills` by default and exposes authored skills through links in
the selected harness directory. Set `SKILLS_SRC` to use a different checkout.

## Installation

Run from this directory:

```bash
./install.sh --target codex
```

Supported targets are `codex`, `pi`, `jcode`, `opencode`, and `universal`. With
no target, the script prompts on a terminal and chooses `universal` when run
non-interactively. Use `--uninstall` with a target to remove links owned by this
installer. It refuses to replace non-symlink destinations and does not clone or
pull repositories.

For Pi installation, package syncing, verification, and runtime details, see
[`pi/README.md`](pi/README.md). The root installer delegates Pi installation and
uninstallation to [`pi/install.sh`](pi/install.sh).
