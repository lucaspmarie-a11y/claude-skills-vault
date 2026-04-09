# Claude Skills Vault

1,326+ Claude Code skills from the Antigravity Awesome Skills library — security, frontend, backend, DevOps, AI/ML, cloud, and more.

## Quick Install

### Option 1: One-liner (all skills)

```bash
# Clone and copy everything to Claude Code
git clone https://github.com/lucaspmarie-a11y/claude-skills-vault.git
cp -r claude-skills-vault/skills/* ~/.claude/skills/
rm -rf claude-skills-vault  # clean up
```

### Option 2: Install specific categories only

```bash
git clone https://github.com/lucaspmarie-a11y/claude-skills-vault.git
cd claude-skills-vault/skills

# Security skills
cp -r 007 pentest-checklist security-audit ~/.claude/skills/

# Frontend skills
cp -r react-patterns nextjs-best-practices tailwind-patterns ~/.claude/skills/

# Backend skills
cp -r python-pro fastapi-pro nodejs-backend-patterns ~/.claude/skills/

# DevOps skills
cp -r docker-expert terraform-skill kubernetes-architect ~/.claude/skills/

# AI/ML skills
cp -r rag-engineer llm-app-patterns hugging-face-cli ~/.claude/skills/
```

### Option 3: From Antigravity (if installed)

If you have Antigravity IDE installed, the skills are already at:

```
%USERPROFILE%\.gemini\antigravity\skills\plugins\antigravity-awesome-skills-claude\skills\
```

Just copy them over:

```powershell
cp -r "$env:USERPROFILE\.gemini\antigravity\skills\plugins\antigravity-awesome-skills-claude\skills\*" "$env:USERPROFILE\.claude\skills\"
```

### Option 4: Graphify integration

After installing, build a knowledge graph to query your skills:

```bash
pip install graphifyy
cd ~/.claude/skills
/graphify .
```

Then query with:
```
/graphify query "what skill for security audit?"
/graphify query "React patterns"
```

## Windows Users

```powershell
git clone https://github.com/lucaspmarie-a11y/claude-skills-vault.git
Copy-Item -Recurse -Force "claude-skills-vault\skills\*" "$env:USERPROFILE\.claude\skills\"
Remove-Item -Recurse -Force claude-skills-vault
```

## Verify Installation

```bash
# Check installed skills count
ls ~/.claude/skills/ | wc -l

# Should show 1375+ (including existing skills)
```

In Claude Code, type `/` followed by a skill name to invoke it.

## Popular Skills

| Category | Skills |
|----------|--------|
| **Security** | `007`, `pentest-checklist`, `security-audit`, `red-team-tactics`, `api-security-testing` |
| **Frontend** | `react-patterns`, `nextjs-best-practices`, `tailwind-patterns`, `shadcn`, `threejs-skills` |
| **Backend** | `python-pro`, `fastapi-pro`, `nodejs-backend-patterns`, `golang-pro`, `rust-pro` |
| **DevOps** | `docker-expert`, `terraform-skill`, `kubernetes-architect`, `aws-serverless` |
| **AI/ML** | `rag-engineer`, `llm-app-patterns`, `langchain-architecture`, `langgraph`, `pydantic-ai` |
| **Cloud** | `azure-ai-projects-py`, `cloudflare-workers-expert`, `neon-postgres`, `vercel-deployment` |
| **Database** | `postgresql-optimization`, `database-design`, `claimable-postgres`, `drizzle-orm-expert` |
| **Testing** | `tdd-workflow`, `playwright-skill`, `e2e-testing-patterns`, `k6-load-testing` |
| **Mobile** | `flutter-expert`, `swiftui-expert-skill`, `react-native-architecture`, `expo-deployment` |
| **Data** | `data-engineer`, `data-scientist`, `polars`, `scikit-learn`, `networkx` |

## Categories

Browse `skills_index.json` for a searchable index, or check `skill_categorization/` for category groupings.

## Quick Search

```bash
# Find a skill by keyword
ls ~/.claude/skills/ | grep -i "security"
ls ~/.claude/skills/ | grep -i "react"
ls ~/.claude/skills/ | grep -i "azure"
ls ~/.claude/skills/ | grep -i "python"
```

## Usage

In Claude Code, invoke a skill by name:

```
/007                    # Security audit (OWASP, STRIDE/PASTA)
/react-patterns         # React design patterns
/python-pro             # Python expert
/tdd-workflow           # TDD cycle
/docker-expert          # Docker expert
/azure-ai-projects-py   # Azure AI Python
/langchain-architecture # LangChain patterns
```

## Stats

- **1,326+ skills** across all categories
- **Compatible with**: Claude Code, Antigravity, Cursor, Gemini CLI, Codex CLI
- **Format**: SKILL.md with YAML frontmatter

## License

Individual skills may have their own licenses. See `LICENSE` and `LICENSE-CONTENT` for details.