#!/usr/bin/env bash
# Claude Skills Vault - Installer
# Installs 1,326+ Antigravity Awesome Skills into Claude Code
# Usage: bash install.sh [--all | --category <name> | --skill <name> | --list]

set -e

REPO_URL="https://github.com/lucaspmarie-a11y/claude-skills-vault.git"
SKILLS_DIR="$HOME/.claude/skills"
TEMP_DIR=$(mktemp -d)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Detect OS for skills path
detect_skills_dir() {
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
        SKILLS_DIR="$(cygpath -u "$USERPROFILE")/.claude/skills"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        SKILLS_DIR="$HOME/.claude/skills"
    else
        SKILLS_DIR="$HOME/.claude/skills"
    fi
}

cleanup() {
    rm -rf "$TEMP_DIR"
}

clone_repo() {
    info "Cloning skills repository..."
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR/claude-skills-vault" 2>/dev/null || \
        error "Failed to clone repository. Check your internet connection."
    ok "Repository cloned"
}

# Categories with skill lists
declare -A CATEGORIES
CATEGORIES[security]="007 pentest-checklist pentest-commands security-audit security-auditor security-bluebook-builder security-compliance-compliance-check security-requirement-extraction security-scanning-security-dependencies security-scanning-security-hardening security-scanning-security-sast active-directory-attacks aws-penetration-testing cloud-penetration-testing broken-authentication ethical-hacking-methodology file-path-traversal html-injection-testing idor-testing linux-privilege-escalation metasploit-framework privilege-escalation-methods protocol-reverse-engineering red-team-tactics red-team-tools scanning-tools shodan-reconnaissance smtp-penetration-testing sql-injection-testing sqlmap-database-pentesting ssh-penetration-testing vulnerability-scanner web-security-testing windows-privilege-escalation xss-html-injection"
CATEGORIES[frontend]="react-patterns react-best-practices react-component-performance react-state-management react-ui-patterns react-native-architecture react-nextjs-development react-modernization nextjs-best-practices nextjs-app-router-patterns nextjs-supabase-auth tailwind-patterns tailwind-design-system shadcn angular angular-best-practices angular-migration angular-state-management angular-ui-patterns sveltekit hono frontend-design frontend-dev-guidelines frontend-developer frontend-slides frontend-ui-dark-ts frontend-security-coder frontend-mobile-development-component-scaffold frontend-mobile-security-xss-scan progressive-web-app threejs-fundamentals threejs-animation threejs-geometry threejs-lighting threejs-materials threejs-postprocessing threejs-shaders threejs-textures threejs-interaction threejs-loaders threejs-skills spline-3d-integration"
CATEGORIES[backend]="python-pro python-patterns python-performance-optimization python-testing-patterns python-packaging fastapi-pro fastapi-router-py fastapi-templates nodejs-backend-patterns nodejs-best-practices golang-pro go-concurrency-patterns rust-pro rust-async-patterns csharp-pro dotnet-architect dotnet-backend dotnet-backend-patterns java-pro scala-pro elixir-pro haskell-pro cpp-pro c-pro php-pro laravel-expert laravel-security-audit django-pro django-access-review django-perf-review postgresql postgresql-optimization database-design database-migration database-optimizer nosql-expert sql-pro sql-optimization-patterns drizzle-orm-expert neon-postgres claimable-postgres prisma-expert"
CATEGORIES[devops]="docker-expert kubernetes-architect kubernetes-deployment terraform-skill terraform-specialist terraform-aws-modules terraform-infrastructure terraform-module-library cloudformation-best-practices cdk-patterns aws-serverless aws-cost-optimizer aws-cost-cleanup gcp-cloud-run cicd-automation-workflow-automate circleci-automation gitlab-ci-patterns gitlab-automation github-actions-templates devops-deploy devops-troubleshooter deployment-engineer deployment-pipeline-design deployment-procedures deployment-validation-config-validate helm-chart-scaffolding k8s-manifest-generator k8s-security-policies istio-traffic-management linkerd-patterns service-mesh-expert service-mesh-observability observability-engineer prometheus-configuration grafana-dashboards datadog-automation sentry-automation"
CATEGORIES[ai-ml]="rag-engineer rag-implementation llm-app-patterns llm-application-dev-ai-assistant llm-application-dev-langchain-agent llm-application-dev-prompt-optimize llm-evaluation llm-ops llm-prompt-optimizer llm-structured-output prompt-engineering prompt-engineering-patterns prompt-library agent-evaluation agent-framework-azure-ai-py agent-orchestrator agent-orchestration-improve-agent agent-orchestration-multi-agent-optimize agent-memory-systems agent-memory-mcp multi-agent-patterns autonomous-agent-patterns autonomous-agents computer-use-agents pydantic-ai langchain-architecture langgraph hugging-face-cli hugging-face-datasets hugging-face-evaluation hugging-face-gradio hugging-face-model-trainer hugging-face-papers embedding-strategies vector-database-engineer vector-index-tuning similarity-search-patterns"
CATEGORIES[cloud]="azure-ai-projects-py azure-ai-projects-ts azure-ai-projects-dotnet azure-ai-projects-java azure-cosmos-py azure-cosmos-ts azure-functions azure-identity-py azure-keyvault-py azure-storage-blob-py azure-storage-blob-ts azure-eventhub-py azure-eventhub-ts azure-servicebus-py azure-servicebus-ts cloudflare-workers-expert vercel-deployment vercel-automation vercel-ai-sdk-expert neon-postgres firebase supabase-automation convex trigger-dev upstash-qstash render-automation"
CATEGORIES[testing]="tdd-workflow tdd-workflows-tdd-cycle tdd-workflows-tdd-green tdd-workflows-tdd-red tdd-workflows-tdd-refactor tdd-orchestrator e2e-testing e2e-testing-patterns testing-patterns testing-qa test-automator test-fixing unit-testing-test-generate playwright-skill playwright-java bats-testing-patterns k6-load-testing burp-suite-testing ffuf-claude-skill ffuf-web-fuzzing sast-configuration semgrep-rule-creator semgrep-rule-variant-creator code-review-ai-ai-review code-review-checklist code-review-excellence code-reviewer codebase-audit-pre-push"
CATEGORIES[mobile]="flutter-expert swiftui-expert-skill swiftui-performance-audit swiftui-ui-patterns swiftui-view-refactor swiftui-liquid-glass swift-concurrency-expert android-jetpack-compose-expert react-native-architecture expo-deployment expo-dev-client expo-cicd-workflows expo-api-routes expo-tailwind-setup expo-ui-jetpack-compose expo-ui-swift-ui"
CATEGORIES[data]="data-engineer data-scientist data-storytelling data-quality-frameworks data-structure-protocol polars scikit-learn statsmodels matplotlib plotly seaborn networkx astropy sympy cirq qiskit biopython"
CATEGORIES[automation]="n8n-workflow-patterns n8n-code-javascript n8n-code-python n8n-expression-syntax n8n-node-configuration n8n-validation-expert n8n-mcp-tools-expert zapier-make-patterns github-automation github-actions-templates gitlab-automation bitbucket-automation jira-automation linear-automation trello-automation asana-automation clickup-automation monday-automation notion-automation slack-automation discord-automation telegram-automation whatsapp-automation gmail-automation google-sheets-automation google-calendar-automation google-drive-automation shopify-automation hubspot-automation salesforce-automation mailchimp-automation stripe-automation"

list_skills() {
    echo -e "${CYAN}Available categories:${NC}"
    for cat in security frontend backend devops ai-ml cloud testing mobile data automation; do
        count=$(echo "${CATEGORIES[$cat]}" | wc -w)
        echo -e "  ${GREEN}$cat${NC} ($count skills)"
    done
    echo ""
    echo -e "Usage: bash install.sh --category <name>   # Install one category"
    echo -e "       bash install.sh --all                 # Install everything"
    echo -e "       bash install.sh --skill <name>         # Install a specific skill"
    echo -e "       bash install.sh --list                # List all categories"
}

install_all() {
    info "Installing ALL 1,326+ skills..."
    mkdir -p "$SKILLS_DIR"
    clone_repo

    local src="$TEMP_DIR/claude-skills-vault/skills"
    local count=0

    for skill_dir in "$src"/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            if [ ! -d "$SKILLS_DIR/$skill_name" ]; then
                cp -r "$skill_dir" "$SKILLS_DIR/"
                ((count++))
            else
                warn "Skill '$skill_name' already installed, skipping"
            fi
        fi
    done

    ok "$count new skills installed (total: $(ls "$SKILLS_DIR" | wc -l))"
    cleanup
}

install_category() {
    local cat="$1"
    if [[ -z "${CATEGORIES[$cat]}" ]]; then
        error "Unknown category '$cat'. Run --list to see available categories."
    fi

    info "Installing category: $cat"
    mkdir -p "$SKILLS_DIR"
    clone_repo

    local src="$TEMP_DIR/claude-skills-vault/skills"
    local count=0

    for skill in ${CATEGORIES[$cat]}; do
        if [ -d "$src/$skill" ]; then
            cp -r "$src/$skill" "$SKILLS_DIR/"
            ((count++))
        else
            warn "Skill '$skill' not found in repository"
        fi
    done

    ok "$count skills from '$cat' installed"
    cleanup
}

install_skill() {
    local skill="$1"
    mkdir -p "$SKILLS_DIR"
    clone_repo

    local src="$TEMP_DIR/claude-skills-vault/skills/$skill"
    if [ -d "$src" ]; then
        cp -r "$src" "$SKILLS_DIR/"
        ok "Skill '$skill' installed"
    else
        error "Skill '$skill' not found. Check the name with --list"
    fi
    cleanup
}

# Main
detect_skills_dir

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║   Claude Skills Vault - Installer v1.0   ║"
echo "║   1,326+ Skills for Claude Code          ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

case "${1:-}" in
    --all|-a)
        install_all
        echo ""
        echo -e "${GREEN}Done!${NC} Restart Claude Code and type /<skill-name> to use any skill."
        ;;
    --category|-c)
        if [ -z "${2:-}" ]; then
            error "Specify a category. Run --list to see available categories."
        fi
        install_category "$2"
        echo ""
        echo -e "${GREEN}Done!${NC} Restart Claude Code and type /<skill-name> to use any skill."
        ;;
    --skill|-s)
        if [ -z "${2:-}" ]; then
            error "Specify a skill name."
        fi
        install_skill "$2"
        ;;
    --list|-l)
        list_skills
        ;;
    --uninstall|-u)
        info "Removing installed skills..."
        read -p "Remove ALL skills from $SKILLS_DIR? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf "$SKILLS_DIR"/*
            ok "All skills removed"
        else
            info "Cancelled"
        fi
        ;;
    *)
        echo "Usage: bash install.sh [OPTION]"
        echo ""
        echo "Options:"
        echo "  --all, -a          Install all 1,326+ skills"
        echo "  --category, -c CAT Install a specific category"
        echo "  --skill, -s NAME   Install a specific skill"
        echo "  --list, -l          List available categories"
        echo "  --uninstall, -u    Remove all installed skills"
        echo ""
        echo "Examples:"
        echo "  bash install.sh --all"
        echo "  bash install.sh --category security"
        echo "  bash install.sh --skill react-patterns"
        echo "  bash install.sh --list"
        ;;
esac