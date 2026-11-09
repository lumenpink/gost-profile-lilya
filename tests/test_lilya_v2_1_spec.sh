#!/bin/bash
set -eo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE="$REPO_DIR/profile.md"
RULES="$REPO_DIR/rules.toml"
LOCALES="$REPO_DIR/locales/pt-br.toml"
VERSION_FILE="$REPO_DIR/VERSION"

echo "=== [TEST] Auditoria de Conformidade Lilya v2.1.0 (Ticket #14) ==="

FAILED=0

# 1. Frontmatter universal e subordinação a Kollontai
if grep -qF 'standard: "lilya"' "$PROFILE" && \
   grep -qF 'tier: "operational"' "$PROFILE" && \
   grep -qF 'standard: "kollontai"' "$PROFILE" && \
   grep -qF 'base_url: "https://kollontai.2lp.in/2.1.0/"' "$PROFILE"; then
    echo "  [PASS] Frontmatter universal com herança de kollontai conforme"
else
    echo "  [FAIL] Frontmatter universal ausente ou incorreto em profile.md"
    FAILED=1
fi

# 2. Ausência total de termos imperialistas proibidos
if grep -rni "soberan" "$PROFILE"; then
    echo "  [FAIL] Termo proibido (imperialismo/soberania) encontrado em profile.md"
    FAILED=1
else
    echo "  [PASS] Ausência de termos imperialistas em profile.md"
fi

# 3. Formalização do Gossnab e banimento de manifestos estáticos
if grep -qi "gossnab" "$PROFILE" && \
   grep -qi "banimento.*catalog\.json" "$PROFILE" && \
   grep -qi "kombinat.*cd" "$PROFILE"; then
    echo "  [PASS] Formalização do Gossnab e segregação CI/CD presentes em profile.md"
else
    echo "  [FAIL] Formalização de Gossnab ou segregação CI/CD ausente em profile.md"
    FAILED=1
fi

# 4. rules.toml presente e estruturado com namespace gost.*
if [ -f "$RULES" ]; then
    if grep -qF "[rules.LILYA-001]" "$RULES" && grep -qF "gost." "$RULES"; then
        echo "  [PASS] rules.toml presente com regras LILYA e namespace gost.*"
    else
        echo "  [FAIL] rules.toml inválido ou sem namespace gost.*"
        FAILED=1
    fi
else
    echo "  [FAIL] rules.toml ausente"
    FAILED=1
fi

# 5. locales/pt-br.toml presente
if [ -f "$LOCALES" ] && grep -qF "[rules.LILYA-001]" "$LOCALES"; then
    echo "  [PASS] locales/pt-br.toml presente com catalogo de mensagens"
else
    echo "  [FAIL] locales/pt-br.toml ausente ou invalido"
    FAILED=1
fi

# 6. VERSION deve ser 2.1.0
if [ -f "$VERSION_FILE" ] && [ "$(cat "$VERSION_FILE" | tr -d '[:space:]')" = "2.1.0" ]; then
    echo "  [PASS] VERSION fixado em 2.1.0"
else
    echo "  [FAIL] VERSION nao e 2.1.0"
    FAILED=1
fi

# 7. Mandato de Conteinerização Universal e Topologia de Rede (#15)
if grep -qF "Mandato de Conteinerização Universal em Stacks" "$PROFILE" && \
   grep -qF "Apenas o Gossnab possui porta pública exposta" "$PROFILE" && \
   grep -qF "O Kombinat opera estritamente confinado na rede privada" "$PROFILE"; then
    echo "  [PASS] Mandato de conteinerização universal e topologia de rede presentes"
else
    echo "  [FAIL] Mandato de conteinerização universal ou topologia de rede ausente"
    FAILED=1
fi

# 8. Escopos Canônicos de Regras Operacionais (#16, #17)
if python3 -c '
import tomllib
with open("'$RULES'", "rb") as f:
    rules = tomllib.load(f).get("rules", {})
for r_id, r_data in rules.items():
    scope = r_data.get("scope")
    assert scope in ["project", "commit-msg", "pre-push", "post-build"], f"Escopo inválido: {scope} em {r_id}"
assert "LILYA-006" in rules, "Regra LILYA-006 ausente em rules.toml"
assert rules["LILYA-006"]["scope"] == "post-build", "LILYA-006 deve ter escopo post-build"
'; then
    echo "  [PASS] Escopos de regras operacionais e LILYA-006 em conformidade com GOST"
else
    echo "  [FAIL] Escopos de regras operacionais inválidos ou LILYA-006 ausente"
    FAILED=1
fi

# 9. LILYA-006 presente em locales/pt-br.toml
if grep -qF "[rules.LILYA-006]" "$LOCALES"; then
    echo "  [PASS] LILYA-006 presente em locales/pt-br.toml"
else
    echo "  [FAIL] LILYA-006 ausente em locales/pt-br.toml"
    FAILED=1
fi


# 7. Verificação de Mutantes
echo "=== [MUTATION] Verificando sensibilidade a mutações ==="
TMP_MUT=$(mktemp)
trap 'rm -f "$TMP_MUT"' EXIT

# Mutante 1: remoção de inherits_from kollontai
grep -v 'standard: "kollontai"' "$PROFILE" > "$TMP_MUT"
if grep -qF 'standard: "kollontai"' "$TMP_MUT"; then
    echo "  [FAIL] Mutante 1 (kollontai ausente) sobreviveu"
    FAILED=1
else
    echo "  [PASS] Mutante 1 (kollontai ausente) detectado"
fi

# Mutante 2: injeção de termo proibido
cat "$PROFILE" > "$TMP_MUT"
echo "soberania total" >> "$TMP_MUT"
if grep -qi "soberan" "$TMP_MUT"; then
    echo "  [PASS] Mutante 2 (termo proibido injetado) detectado"
else
    echo "  [FAIL] Mutante 2 não detectado"
    FAILED=1
fi

# Mutante 3: remoção de isolamento do Kombinat
grep -v 'O Kombinat opera estritamente confinado na rede privada' "$PROFILE" > "$TMP_MUT"
if grep -qF 'O Kombinat opera estritamente confinado na rede privada' "$TMP_MUT"; then
    echo "  [FAIL] Mutante 3 (isolamento do Kombinat ausente) sobreviveu"
    FAILED=1
else
    echo "  [PASS] Mutante 3 (isolamento do Kombinat ausente) detectado"
fi

# Mutante 4: LILYA-006 sem post-build
sed 's/scope = "post-build"/scope = "project"/g' "$RULES" > "$TMP_MUT"
if grep -qF '[rules.LILYA-006]' "$TMP_MUT" && ! grep -A 5 '\[rules.LILYA-006\]' "$TMP_MUT" | grep -qF 'scope = "post-build"'; then
    echo "  [PASS] Mutante 4 (LILYA-006 sem escopo post-build) detectado"
else
    echo "  [FAIL] Mutante 4 nao detectado"
    FAILED=1
fi

if [ $FAILED -ne 0 ]; then
    echo "=== [RESULT] FALHA NA AUDITORIA ==="
    exit 1
fi

echo "=== [RESULT] TODOS OS TESTES PASSARAM COM SUCESSO ==="
exit 0
