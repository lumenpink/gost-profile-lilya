#!/bin/bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== [TEST] Validação do Artefato site/2.1.0/UPGRADE.md (Ticket #26) ==="

check_upgrade_md() {
    local root="$1"
    local failed=0
    local up_file="$root/site/2.1.0/UPGRADE.md"

    # 1. Existência e não-vazio
    if [ ! -f "$up_file" ]; then
        echo "  [FAIL] site/2.1.0/UPGRADE.md não encontrado"
        return 1
    fi

    # 2. Ausência na raiz de site/ (fail-fast, apenas em subdiretório versionado)
    if [ -f "$root/site/UPGRADE.md" ]; then
        echo "  [FAIL] site/UPGRADE.md solto na raiz proibido (deve residir exclusivamente em site/{version}/)"
        failed=1
    fi

    # 3. Validação do Frontmatter YAML estrito
    python3 -c '
import sys
with open("'$up_file'", "r", encoding="utf-8") as f:
    content = f.read()

assert content.startswith("---\n"), "UPGRADE.md deve iniciar com frontmatter delimitado por ---"
parts = content.split("---\n", 2)
assert len(parts) >= 3, "Frontmatter YAML malformado"
fm = parts[1]

assert "standard: \"lilya\"" in fm, "standard deve ser lilya"
assert "tier: \"operational\"" in fm, "tier deve ser operational"
assert "version: \"2.1.0\"" in fm, "version deve ser 2.1.0"
assert "replaces: \"2.0.0\"" in fm, "replaces deve ser 2.0.0"
assert "valid_since: \"2.0.0\"" in fm, "valid_since deve ser 2.0.0"
assert "breaking: true" in fm, "breaking deve ser true"

assert "Quebras de Contrato" in content, "Seção Quebras de Contrato ausente"
assert "Mutação de Regras" in content, "Seção Mutação de Regras ausente"
assert "Ações Manuais" in content, "Seção Ações Manuais ausente"
assert "Ações Automatizáveis" in content, "Seção Ações Automatizáveis ausente"
' || failed=1

    return $failed
}

if check_upgrade_md "$REPO_ROOT"; then
    echo "  [PASS] site/2.1.0/UPGRADE.md está em estrita conformidade normativa!"
else
    echo "❌ [FAIL] Auditoria falhou (comportamento RED esperado na Fase 4)."
    exit 1
fi
