#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROFILE="$REPO_ROOT/profile.md"

echo "=== [TEST] Auditoria de Cascata Determinística e Anti-Latest (Ticket #11) ==="

check_profile_cascade() {
    local target="$1"
    local failed=0

    # 1. Eliminação de tags :latest em builds determinísticos
    if grep -qi "eliminação de tags mutáveis" "$target" && grep -qi "build determinístico" "$target"; then
        true
    else
        echo "  [FAIL] Cláusula de eliminação de tags mutáveis em builds determinísticos ausente"
        failed=1
    fi

    # 2. Contrato FFI / C-ABI de Versão
    if grep -qi "Contrato Universal de FFI" "$target" && grep -qi "pub const VERSION" "$target" && grep -qi "_version()" "$target"; then
        true
    else
        echo "  [FAIL] Cláusula do Contrato FFI / C-ABI de Versão ausente"
        failed=1
    fi

    # 3. Inspeção canônica CLI (--version --all e --json)
    if grep -qi -- "--version --all" "$target" && grep -qi -- "--version --json" "$target"; then
        true
    else
        echo "  [FAIL] Cláusula de inspeção CLI com --version --all e --json ausente"
        failed=1
    fi

    # 4. Ausência de termos imperialistas
    if grep -qi -E "soberan|mestre|slave" "$target"; then
        echo "  [FAIL] Termos proibidos encontrados no documento"
        failed=1
    fi

    return $failed
}

if check_profile_cascade "$PROFILE"; then
    echo "  [PASS] Cláusulas de cascata determinística presentes no perfil!"
else
    echo "❌ [FAIL] Auditoria falhou no perfil oficial (comportamento RED esperado)."
    exit 1
fi

echo "=== [MUTATION] Verificando sensibilidade dos testes normativos a mutações ==="

TMP_MUTANT=$(mktemp)
trap 'rm -f "$TMP_MUTANT"' EXIT

# Mutante 1: Omissão de anti-latest
sed -E 's/eliminação de tags mutáveis/aceitação de tags dinâmicas/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_cascade "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 1 (omissão de anti-latest) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 1 (omissão de anti-latest) capturado com precisão"
fi

# Mutante 2: Omissão do Contrato FFI
sed -E 's/Contrato Universal de FFI/Convenção opcional de FFI/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_cascade "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 2 (omissão do contrato FFI) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 2 (omissão do contrato FFI) capturado com precisão"
fi

# Mutante 3: Omissão da inspeção CLI
sed -E 's/--version --all/--version --full/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_cascade "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 3 (omissão de --version --all) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 3 (omissão de --version --all) capturado com precisão"
fi

# Mutante 4: Injeção de termo proibido
sed -E 's/forja autônoma/forja soberana/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_cascade "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 4 (injeção de termo proibido) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 4 (injeção de termo proibido) capturado com precisão"
fi

echo "✔ [GREEN TEST] Todas as asserções e mutações foram aprovadas com 100% de conformidade."
exit 0
