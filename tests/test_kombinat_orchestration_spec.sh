#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROFILE="$REPO_ROOT/profile.md"

echo "=== [TEST] Auditoria de Orquestração Contínua via Kombinat (Ticket #12) ==="

check_profile_kombinat() {
    local target="$1"
    local failed=0

    # 1. Menção ao daemon Kombinat e orquestração de dependências
    if grep -qi "kombinat" "$target" && grep -qi "orquestra" "$target"; then
        true
    else
        echo "  [FAIL] Cláusula do daemon Kombinat como orquestrador contínuo ausente"
        failed=1
    fi

    # 2. Monitoramento de registro e propagação em cascata
    if grep -qi "cascata" "$target" && grep -qi "propagação" "$target"; then
        true
    else
        echo "  [FAIL] Diretiva de propagação de versões e compilação em cascata ausente"
        failed=1
    fi

    # 3. Fixação canônica como recomendação (sem trava mandatória ao uso de aliases)
    if grep -qi "versões canônicas" "$target" && grep -qi "recomenda" "$target" && grep -qi "trava" "$target"; then
        true
    else
        echo "  [FAIL] Cláusula de recomendação sem trava mandatória para versões canônicas ausente"
        failed=1
    fi

    return $failed
}

if check_profile_kombinat "$PROFILE"; then
    echo "  [PASS] Todas as cláusulas de orquestração via Kombinat estão presentes!"
else
    echo "❌ [FAIL] Auditoria falhou no perfil oficial."
    exit 1
fi
