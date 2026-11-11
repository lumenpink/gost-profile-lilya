#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROFILE="$REPO_ROOT/profile.md"

echo "=== [TEST] Auditoria de Registries Autônomos OCI e Cargo (Ticket #7) ==="

check_profile_registries() {
    local target="$1"
    local failed=0

    # 1. Container Registry OCI em git.2lp.in
    if grep -qi "Container Registry OCI" "$target" && grep -qi "git.2lp.in/<owner>/<image>" "$target"; then
        true
    else
        echo "  [FAIL] Cláusula do Container Registry OCI em git.2lp.in ausente"
        failed=1
    fi

    # 2. Cargo Registry em git.2lp.in
    if grep -qi "Cargo Registry" "$target" && grep -qi "sparse+https://git.2lp.in/api/packages" "$target"; then
        true
    else
        echo "  [FAIL] Cláusula do Cargo Registry autônomo ausente"
        failed=1
    fi

    # 3. Armazenamento persistente no HD1
    if grep -qi "/media/hd1/forgejo/data/packages" "$target"; then
        true
    else
        echo "  [FAIL] Cláusula de persistência de pacotes no HD1 ausente"
        failed=1
    fi

    # 4. Ausência de termos imperialistas
    if grep -qi -E "soberan|mestre|slave" "$target"; then
        echo "  [FAIL] Termos proibidos encontrados no documento"
        failed=1
    fi

    return $failed
}

if check_profile_registries "$PROFILE"; then
    echo "  [PASS] Cláusulas de registries autônomos presentes no perfil!"
else
    echo "❌ [FAIL] Auditoria falhou no perfil oficial (comportamento RED esperado)."
    exit 1
fi

echo "=== [MUTATION] Verificando sensibilidade dos testes normativos a mutações ==="

TMP_MUTANT=$(mktemp)
trap 'rm -f "$TMP_MUTANT"' EXIT

# Mutante 1: Omissão de Container Registry OCI
sed -E 's/Container Registry OCI/Container Registry Publico/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_registries "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 1 (omissão de Container Registry OCI) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 1 (omissão de Container Registry OCI) capturado com precisão"
fi

# Mutante 2: Omissão de Cargo Registry
sed -E 's/Cargo Registry/Rust Registry Publico/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_registries "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 2 (omissão de Cargo Registry) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 2 (omissão de Cargo Registry) capturado com precisão"
fi

# Mutante 3: Injeção de termo imperialista
sed -E 's/registries autônomos/registries soberanos/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_registries "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 3 (injeção de termo proibido) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 3 (injeção de termo proibido) capturado com precisão"
fi

echo "✔ [GREEN TEST] Todas as asserções e mutações foram aprovadas com 100% de conformidade."
exit 0
