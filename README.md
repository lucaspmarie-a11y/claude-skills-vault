# Claude Skills Vault

Personal collection of 1,326+ Claude Code skills from the Antigravity Awesome Skills library, ready to use with Claude Code CLI.

## Installation

Skills are located in the `skills/` directory. To install them in Claude Code:

```bash
# Copy all skills to your Claude Code skills directory
cp -r skills/* ~/.claude/skills/

# Or install individually
cp -r skills/007 ~/.claude/skills/
```

## Categories

Skills are organized by category. Browse the `skills_index.json` for a searchable index, or check `skill_categorization/` for category groupings.

## Quick Search

```bash
# Find a skill by keyword
ls skills/ | grep -i "security"
ls skills/ | grep -i "react"
ls skills/ | grep -i "azure"
```

## Usage

In Claude Code, invoke a skill by name:

```
/007                    # Security audit
/react-patterns         # React design patterns
/python-pro             # Python expert
/tdd-workflow           # TDD cycle
```

## Stats

- **1,326+ skills** across all categories
- **Categories**: Security, Frontend, Backend, DevOps, AI/ML, Cloud, Mobile, Database, Testing, and more
- **Compatible with**: Claude Code, Antigravity, Cursor, Gemini CLI, Codex CLI

## License

Individual skills may have their own licenses. See `LICENSE` and `LICENSE-CONTENT` for details.