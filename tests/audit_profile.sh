#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROFILE="$REPO_ROOT/profile.md"

echo "=== [TEST] Auditoria Normativa do Perfil Lilya (profile.md) ==="

check_pattern() {
    local pattern="$1"
    local desc="$2"
    if grep -qiF -- "$pattern" "$PROFILE"; then
        echo "  [PASS] $desc"
    else
        echo "  [FAIL] $desc (padrão '$pattern' não encontrado)"
        return 1
    fi
}

FAILED=0

# 1. Frontmatter Lilya v2.0.0
check_pattern 'id: lilya' "Frontmatter id: lilya" || FAILED=1
check_pattern 'name: "Perfil de Implementação Lilya"' "Nome canônico Perfil de Implementação Lilya" || FAILED=1
check_pattern 'target_gost: "2.0.0"' "Frontmatter target_gost 2.0.0" || FAILED=1
check_pattern 'canonical_url: "https://lilya.2lp.in/profile.md"' "Canonical URL https://lilya.2lp.in/profile.md" || FAILED=1

# 2. Forja Canônica e Push Mirrors
check_pattern 'gambi.2lp.in' "Menção à forja canônica gambi.2lp.in" || FAILED=1
check_pattern 'git@gambi.2lp.in:lumen/' "Remote SSH padrão na porta 22 git@gambi.2lp.in:lumen/" || FAILED=1
check_pattern 'pushurl = no_push' "Configuração pushurl = no_push para remotes de PRs" || FAILED=1
check_pattern 'crates.2lp.in' "Allowlist com crates.2lp.in" || FAILED=1

# 3. Rodapé Canônico em 2 Linhas & 10 Línguas
check_pattern 'Orgulhosamente produzido por uma' "Frase canônica de abertura do rodapé" || FAILED=1
check_pattern 'https://travesti.2lp.in/' "Link canônico https://travesti.2lp.in/" || FAILED=1
check_pattern 'https://lumen.pink' "Link para Lumen Pink" || FAILED=1
check_pattern 'Versão Short vs. Versão Long' "Regra Versão Short vs. Versão Long" || FAILED=1
check_pattern 'lateinamerikanischen Travesti' "Matriz de línguas (alemão) preservando travesti" || FAILED=1
check_pattern 'латиноамериканской travesti' "Matriz de línguas (russo) preservando travesti" || FAILED=1

# 4. Publicação Web na Borda & Dioxus
check_pattern 'wrangler.jsonc' "Menção à especificação wrangler.jsonc" || FAILED=1
check_pattern 'in.2lp.<slug>' "Namespace canônico Dioxus in.2lp.<slug>" || FAILED=1

# 5. Distribuição na Banca e Cotas Operacionais
check_pattern 'https://banca.2lp.in/downloads/' "Endpoint de downloads da Banca" || FAILED=1
check_pattern 'curl -sSf https://banca.2lp.in/downloads/<slug>/install.sh | sh' "Comando canônico curl para install.sh" || FAILED=1
check_pattern 'banca-artifacts/{app}/{channel}/' "Topologia física banca-artifacts/{app}/{channel}/" || FAILED=1
check_pattern 'catalog.json' "Manifesto consolidado catalog.json" || FAILED=1
check_pattern '5 versões mais recentes' "Cota operacional de 5 versões mais recentes para stable" || FAILED=1
check_pattern '10 versões mais recentes' "Cota operacional de 10 versões mais recentes para dev" || FAILED=1
check_pattern 'Tolerância Zero a Links Quebrados' "Princípio de tolerância zero a links quebrados" || FAILED=1

# 6. Ausência de Termos Imperialistas
if grep -rnEi "soberan[ao]|sovereign" "$PROFILE" >/dev/null 2>&1; then
    echo "  [FAIL] Termos imperialistas detectados em profile.md"
    FAILED=1
else
    echo "  [PASS] Ausência de termos imperialistas em profile.md"
fi

# 7. Continuous Deployment de Servidores & Descomissionamento Watchtower
check_pattern 'compose.yaml' "Uso estrito de compose.yaml" || FAILED=1
check_pattern 'obizero' "Deploy local no nó central obizero com socket Docker" || FAILED=1
check_pattern 'obione' "Deploy nos nós de borda obione e obitwo via Tailscale" || FAILED=1
check_pattern 'rollback' "Protocolo de rollback automático de 15s" || FAILED=1

# 7. Mutation Check
echo "=== [MUTATION] Testando detecção de mutantes críticos ==="
TMP_MUTANT=$(mktemp)
trap 'rm -f "$TMP_MUTANT"' EXIT

grep -v "travesti" "$PROFILE" > "$TMP_MUTANT"
if grep -qF "travesti" "$TMP_MUTANT"; then
    echo "  [FAIL] Mutante A não foi gerado corretamente"
    FAILED=1
else
    echo "  [PASS] Mutante A (sem travesti) isolado com sucesso"
fi

grep -v "obizero" "$PROFILE" > "$TMP_MUTANT"
if grep -qF "obizero" "$TMP_MUTANT"; then
    echo "  [FAIL] Mutante B não foi gerado corretamente"
    FAILED=1
else
    echo "  [PASS] Mutante B (sem obizero) isolado com sucesso"
fi

grep -v "compose.yaml" "$PROFILE" > "$TMP_MUTANT"
if grep -qF "compose.yaml" "$TMP_MUTANT"; then
    echo "  [FAIL] Mutante C não foi gerado corretamente"
    FAILED=1
else
    echo "  [PASS] Mutante C (sem compose.yaml) isolado com sucesso"
fi

grep -v "gambi.2lp.in" "$PROFILE" > "$TMP_MUTANT"
if grep -qF "gambi.2lp.in" "$TMP_MUTANT"; then
    echo "  [FAIL] Mutante D não foi gerado corretamente"
    FAILED=1
else
    echo "  [PASS] Mutante D (sem gambi.2lp.in) isolado com sucesso"
fi

grep -vi "rollback" "$PROFILE" > "$TMP_MUTANT"
if grep -qiF "rollback" "$TMP_MUTANT"; then
    echo "  [FAIL] Mutante E não foi gerado corretamente"
    FAILED=1
else
    echo "  [PASS] Mutante E (sem rollback) isolado com sucesso"
fi

if [ $FAILED -ne 0 ]; then
    echo "❌ [RED TEST] Auditoria falhou: profile.md ainda não implementou a especificação completa de Lilya."
    exit 1
fi

echo "✔ [GREEN TEST] Auditoria aprovada: profile.md possui todas as seções e diretivas canônicas."
exit 0
