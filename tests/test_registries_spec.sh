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
