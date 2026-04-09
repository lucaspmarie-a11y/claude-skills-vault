# Claude Skills Vault - PowerShell Installer
# Run: .\install.ps1 -All | -Category <name> | -Skill <name> | -List | -Uninstall

param(
    [switch]$All,
    [string]$Category = "",
    [string]$Skill = "",
    [switch]$List,
    [switch]$Uninstall
)

$RepoUrl = "https://github.com/lucaspmarie-a11y/claude-skills-vault.git"
$SkillsDir = "$env:USERPROFILE\.claude\skills"
$TempDir = Join-Path $env:TEMP "claude-skills-install-$(Get-Random)"

function Write-Color($text, $color) { Write-Host $text -ForegroundColor $color }

# Category definitions
$Categories = @{
    security    = @("007","pentest-checklist","security-audit","security-auditor","security-bluebook-builder",
                    "security-compliance-compliance-check","security-requirement-extraction","security-scanning-security-dependencies",
                    "security-scanning-security-hardening","security-scanning-security-sast","active-directory-attacks",
                    "aws-penetration-testing","cloud-penetration-testing","broken-authentication","ethical-hacking-methodology",
                    "file-path-traversal","html-injection-testing","idor-testing","linux-privilege-escalation",
                    "metasploit-framework","privilege-escalation-methods","protocol-reverse-engineering","red-team-tactics",
                    "red-team-tools","scanning-tools","shodan-reconnaissance","smtp-penetration-testing",
                    "sql-injection-testing","sqlmap-database-pentesting","ssh-penetration-testing","vulnerability-scanner",
                    "web-security-testing","windows-privilege-escalation","xss-html-injection")
    frontend    = @("react-patterns","react-best-practices","react-component-performance","react-state-management",
                    "react-ui-patterns","react-native-architecture","react-nextjs-development","react-modernization",
                    "nextjs-best-practices","nextjs-app-router-patterns","nextjs-supabase-auth","tailwind-patterns",
                    "tailwind-design-system","shadcn","angular","angular-best-practices","angular-migration",
                    "angular-state-management","angular-ui-patterns","sveltekit","hono","frontend-design",
                    "frontend-dev-guidelines","frontend-developer","threejs-skills","spline-3d-integration")
    backend     = @("python-pro","python-patterns","python-performance-optimization","python-testing-patterns",
                    "python-packaging","fastapi-pro","fastapi-router-py","fastapi-templates","nodejs-backend-patterns",
                    "nodejs-best-practices","golang-pro","go-concurrency-patterns","rust-pro","rust-async-patterns",
                    "csharp-pro","dotnet-architect","dotnet-backend","java-pro","scala-pro","elixir-pro",
                    "django-pro","django-access-review","django-perf-review","postgresql","postgresql-optimization",
                    "database-design","database-migration","database-optimizer","sql-pro","drizzle-orm-expert",
                    "neon-postgres","claimable-postgres","prisma-expert")
    devops      = @("docker-expert","kubernetes-architect","kubernetes-deployment","terraform-skill",
                    "terraform-specialist","terraform-aws-modules","cloudformation-best-practices","cdk-patterns",
                    "aws-serverless","aws-cost-optimizer","gcp-cloud-run","cicd-automation-workflow-automate",
                    "github-actions-templates","devops-deploy","devops-troubleshooter","deployment-engineer",
                    "deployment-pipeline-design","helm-chart-scaffolding","k8s-manifest-generator","k8s-security-policies",
                    "observability-engineer","prometheus-configuration","grafana-dashboards","datadog-automation",
                    "sentry-automation")
    ai-ml       = @("rag-engineer","rag-implementation","llm-app-patterns","llm-application-dev-ai-assistant",
                    "llm-application-dev-langchain-agent","llm-application-dev-prompt-optimize","llm-evaluation",
                    "llm-ops","llm-prompt-optimizer","llm-structured-output","prompt-engineering",
                    "prompt-engineering-patterns","prompt-library","agent-evaluation","agent-framework-azure-ai-py",
                    "agent-orchestrator","agent-memory-systems","agent-memory-mcp","multi-agent-patterns",
                    "autonomous-agent-patterns","autonomous-agents","computer-use-agents","pydantic-ai",
                    "langchain-architecture","langgraph","hugging-face-cli","embedding-strategies",
                    "vector-database-engineer","vector-index-tuning","similarity-search-patterns")
    cloud       = @("azure-ai-projects-py","azure-ai-projects-ts","azure-ai-projects-dotnet","azure-ai-projects-java",
                    "azure-cosmos-py","azure-cosmos-ts","azure-functions","azure-identity-py","azure-keyvault-py",
                    "azure-storage-blob-py","azure-storage-blob-ts","azure-eventhub-py","azure-eventhub-ts",
                    "azure-servicebus-py","azure-servicebus-ts","cloudflare-workers-expert",
                    "vercel-deployment","vercel-automation","vercel-ai-sdk-expert","neon-postgres","firebase",
                    "supabase-automation","convex","trigger-dev","upstash-qstash","render-automation")
    testing     = @("tdd-workflow","tdd-workflows-tdd-cycle","tdd-workflows-tdd-green","tdd-workflows-tdd-red",
                    "tdd-workflows-tdd-refactor","tdd-orchestrator","e2e-testing","e2e-testing-patterns",
                    "testing-patterns","testing-qa","test-automator","test-fixing","unit-testing-test-generate",
                    "playwright-skill","playwright-java","k6-load-testing","burp-suite-testing",
                    "ffuf-claude-skill","ffuf-web-fuzzing","sast-configuration","semgrep-rule-creator",
                    "code-review-excellence","code-reviewer","codebase-audit-pre-push")
    mobile      = @("flutter-expert","swiftui-expert-skill","swiftui-performance-audit","swiftui-ui-patterns",
                    "swiftui-view-refactor","swiftui-liquid-glass","swift-concurrency-expert",
                    "android-jetpack-compose-expert","react-native-architecture","expo-deployment",
                    "expo-dev-client","expo-cicd-workflows","expo-api-routes","expo-tailwind-setup",
                    "expo-ui-jetpack-compose","expo-ui-swift-ui")
    data        = @("data-engineer","data-scientist","data-storytelling","data-quality-frameworks",
                    "data-structure-protocol","polars","scikit-learn","statsmodels","matplotlib","plotly",
                    "seaborn","networkx","astropy","sympy","cirq","qiskit","biopython")
    automation  = @("n8n-workflow-patterns","n8n-code-javascript","n8n-code-python","n8n-expression-syntax",
                    "n8n-node-configuration","n8n-validation-expert","n8n-mcp-tools-expert",
                    "zapier-make-patterns","github-automation","github-actions-templates","gitlab-automation",
                    "bitbucket-automation","jira-automation","linear-automation","trello-automation",
                    "asana-automation","clickup-automation","monday-automation","notion-automation",
                    "slack-automation","discord-automation","telegram-automation","whatsapp-automation",
                    "gmail-automation","google-sheets-automation","google-calendar-automation",
                    "google-drive-automation","shopify-automation","hubspot-automation",
                    "salesforce-automation","mailchimp-automation","stripe-automation")
}

if ($List) {
    Write-Color "`nAvailable categories:`n" Cyan
    foreach ($key in $Categories.Keys | Sort-Object) {
        $count = $Categories[$key].Count
        Write-Color "  $key ($count skills)" Green
    }
    Write-Color "`nUsage: .\install.ps1 -Category <name>`n" Yellow
    exit 0
}

if ($Uninstall) {
    $confirm = Read-Host "Remove ALL skills from $SkillsDir? [y/N]"
    if ($confirm -match '^[Yy]') {
        Remove-Item "$SkillsDir\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Color "All skills removed" Green
    } else {
        Write-Color "Cancelled" Yellow
    }
    exit 0
}

# Clone repo
Write-Color "[INFO] Cloning skills repository..." Blue
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
git clone --depth 1 $RepoUrl "$TempDir\claude-skills-vault" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Color "[ERROR] Failed to clone repository" Red
    exit 1
}
Write-Color "[OK] Repository cloned" Green

$SkillsSrc = "$TempDir\claude-skills-vault\skills"
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null

if ($All) {
    Write-Color "[INFO] Installing ALL skills..." Blue
    $count = 0
    Get-ChildItem -Directory $SkillsSrc | ForEach-Object {
        $name = $_.Name
        if (-not (Test-Path "$SkillsDir\$name")) {
            Copy-Item -Recurse $_.FullName "$SkillsDir\$name"
            $count++
        }
    }
    $total = (Get-ChildItem -Directory $SkillsDir).Count
    Write-Color "[OK] $count new skills installed (total: $total)" Green
}
elseif ($Category -ne "") {
    if (-not $Categories.ContainsKey($Category)) {
        Write-Color "[ERROR] Unknown category '$Category'. Run -List to see available categories." Red
        exit 1
    }
    Write-Color "[INFO] Installing category: $Category" Blue
    $count = 0
    foreach ($skill in $Categories[$Category]) {
        if (Test-Path "$SkillsSrc\$skill") {
            Copy-Item -Recurse "$SkillsSrc\$skill" "$SkillsDir\$skill"
            $count++
        }
    }
    Write-Color "[OK] $count skills from '$Category' installed" Green
}
elseif ($Skill -ne "") {
    if (Test-Path "$SkillsSrc\$Skill") {
        Copy-Item -Recurse "$SkillsSrc\$Skill" "$SkillsDir\$Skill"
        Write-Color "[OK] Skill '$Skill' installed" Green
    } else {
        Write-Color "[ERROR] Skill '$Skill' not found" Red
        exit 1
    }
}
else {
    Write-Color "`nUsage: .\install.ps1 [OPTION]`n" Yellow
    Write-Host "  -All              Install all 1,326+ skills"
    Write-Host "  -Category <name>  Install a specific category"
    Write-Host "  -Skill <name>     Install a specific skill"
    Write-Host "  -List             List available categories"
    Write-Host "  -Uninstall        Remove all installed skills`n"
    Write-Host "Examples:"
    Write-Host "  .\install.ps1 -All"
    Write-Host "  .\install.ps1 -Category security"
    Write-Host "  .\install.ps1 -Skill react-patterns"
    Write-Host "  .\install.ps1 -List"
}

# Cleanup
Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
Write-Color "`nDone! Restart Claude Code and type /<skill-name> to use any skill." Green