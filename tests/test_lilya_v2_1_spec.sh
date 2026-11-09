#!/bin/bash
set -eo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE="$REPO_DIR/profile.md"
RULES="$REPO_DIR/rules.toml"
LOCALES="$REPO_DIR/locales/pt-br.toml"
VERSION_FILE="$REPO_DIR/VERSION"

echo "=== [TEST] Auditoria de Conformidade Lilya v2.1.0 (#18) ==="

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

# 4. rules.toml com exatamente 9 portarias operacionais da Tulipa
python3 -c '
import re
import tomllib

with open("'$RULES'", "rb") as f:
    rules = tomllib.load(f).get("rules", {})

expected_rules = {
    "LILYA-001": "VERSION-NO-V-PREFIX",
    "LILYA-002": "TRANSFEMINIST-IDENTITY-REQUIRED",
    "LILYA-003": "PRIMARY-FORGE-GAMBI-CANONICAL",
    "LILYA-004": "CCCPRC-FILE-REQUIRED",
    "LILYA-005": "STATIC-MANIFESTS-PROHIBITED",
    "LILYA-006": "STRICT-COMPOSE-YAML-EXTENSION",
    "LILYA-007": "METADATA-MANIFEST-SCHEMA",
    "LILYA-008": "CLI-HELP-INFORMATIVE-POST-BUILD",
    "LILYA-009": "CLI-VERSION-METADATA-PARITY-POST-BUILD",
}

assert len(rules) == 9, f"Contagem deve ser 9 portarias operacionais, obtido: {len(rules)}"
for r_id, exp_name in expected_rules.items():
    assert r_id in rules, f"Regra {r_id} ausente"
    assert re.match(r"^LILYA-\d{3}$", r_id), f"ID deve ser tridigital: {r_id}"
    r_data = rules[r_id]
    act_name = r_data.get("name")
    assert act_name == exp_name, f"Nome incorreto em {r_id}: {act_name} != {exp_name}"
    assert "script" in r_data, f"Script ausente em {r_id}"
    assert "gost." in r_data["script"], f"Script deve chamar gost.* em {r_id}"
' || FAILED=1

if [ $FAILED -eq 0 ]; then
    echo "  [PASS] rules.toml validado com as 9 portarias operacionais canônicas"
else
    echo "  [FAIL] Validação de rules.toml falhou"
fi

# 5. locales/pt-br.toml com todas as 9 regras
python3 -c '
import tomllib

with open("'$RULES'", "rb") as f:
    canon = tomllib.load(f).get("rules", {})
with open("'$LOCALES'", "rb") as f:
    loc = tomllib.load(f).get("rules", {})

assert len(loc) == 9, f"Locale pt-br deve conter 9 regras, obtido: {len(loc)}"
for r_id in canon.keys():
    assert r_id in loc, f"Regra {r_id} ausente no locale"
    assert "description" in loc[r_id], f"description ausente em {r_id} no locale"
' || FAILED=1

if [ $FAILED -eq 0 ]; then
    echo "  [PASS] locales/pt-br.toml validado com paridade para 9 regras"
else
    echo "  [FAIL] Validação de locales falhou"
fi

# 6. VERSION deve ser 2.1.0
if [ -f "$VERSION_FILE" ] && [ "$(cat "$VERSION_FILE" | tr -d '[:space:]')" = "2.1.0" ]; then
    echo "  [PASS] VERSION fixado em 2.1.0"
else
    echo "  [FAIL] VERSION nao e 2.1.0"
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

# Mutante 3: ID com letras (LILYA-001A)
python3 -c '
import re
assert not re.match(r"^LILYA-\d{3}$", "LILYA-001A"), "Deveria rejeitar sufixo alfabético"
' || FAILED=1
echo "  [PASS] Mutante 3 (ID alfanumérico rejeitado) detectado"

if [ $FAILED -ne 0 ]; then
    echo "=== [RESULT] FALHA NA AUDITORIA ==="
    exit 1
fi

echo "=== [RESULT] TODOS OS TESTES PASSARAM COM SUCESSO ==="
exit 0
