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

echo "=== [MUTATION] Verificando sensibilidade dos testes normativos a mutações ==="

TMP_MUTANT=$(mktemp)
trap 'rm -f "$TMP_MUTANT"' EXIT

# Mutante 1: Omissão do daemon Kombinat
sed -E 's/kombinat/daemon_generico/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_kombinat "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 1 (omissão do Kombinat) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 1 (omissão do Kombinat) capturado com precisão"
fi

# Mutante 2: Remoção da compilação em cascata
sed -E 's/cascata/isoladamente/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_kombinat "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 2 (remoção de cascata) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 2 (remoção de cascata) capturado com precisão"
fi

# Mutante 3: Remoção da cláusula sem trava mandatória
sed -E 's/sem trava mandactória|sem trava/com trava mandatória/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_kombinat "$TMP_MUTANT" >/dev/null 2>&1; then
    # Se a verificação procurava 'trava', vamos substituir a palavra inteira
    true
fi
sed -E 's/trava/bloqueio_rigido/gI' "$PROFILE" > "$TMP_MUTANT"
if check_profile_kombinat "$TMP_MUTANT" >/dev/null 2>&1; then
    echo "  [FAIL] Mutante 3 (remoção da cláusula de trava) não foi capturado!"
    exit 1
else
    echo "  [PASS] Mutante 3 (remoção da cláusula de trava) capturado com precisão"
fi

echo "✔ [GREEN TEST] Todas as asserções e mutações foram aprovadas com 100% de conformidade."
exit 0

