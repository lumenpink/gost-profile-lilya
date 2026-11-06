# Especificação Técnica — Ticket #5: Suporte a Auto-Update Transparente & Configurável

**Norma de Referência:** GOST 1.5.0  
**Perfil:** Lumen (`https://gostlumen.2lp.in/profile.md`)  
**Data:** 2026-10-20  
**Status:** Aprovado / Em Implementação  

---

## 1. Contexto & Motivação

Além da checagem periódica com avisos informativos em `stderr` (`auto_check = true`), usuários e administradores de quiosques, servidores ou estações de desenvolvimento necessitam de uma opção declarativa para manter seus binários sempre na última versão do canal desejado sem intervenção manual interativa.

Essa capacidade é regulada pelo parâmetro `auto_update` no esquema de configuração OpenDesktop (`config.toml`), respeitando rigorosamente a autonomia do usuário por meio de três princípios:
1. **Desabilitado por Padrão:** O valor padrão é estritamente `auto_update = false`. Nenhuma máquina sofre atualizações sem consentimento explícito.
2. **Respeito Absoluto a Pinning:** Se `pinned = true` ou se houver versão travada em `pin`, o mecanismo de auto-update é **sumariamente desativado**, impedindo upgrades indesejados.
3. **Substituição Atômica Não-Destrutiva:** No Linux, o processo em execução na RAM permanece intacto; o novo binário é descarregado para um arquivo temporário no mesmo sistema de arquivos e renomeado atomicamente para o destino canônico (`~/.local/bin/<app>`), passando a valer para a próxima inicialização.

---

## 2. Esquema de Configuração (`config.toml`)

```toml
[update]
# Canal de distribuição: "stable" ou "nightly" (padrão: "stable")
channel = "stable"

# Trava de versão: impede atualizações manuais e automáticas (padrão: false)
pinned = false
pin = ""

# Verificação periódica de versões e aviso em stderr (padrão: true)
auto_check = true
check_interval_hours = 24

# Auto-atualização transparente em background (padrão: false)
auto_update = false
```

---

## 3. Contrato de Interface de Linha de Comando (CLI)

Todo aplicativo deve expor o comando dedicado:
- `<app> config set-auto-update <true|false>`

Quando ativado (`auto_update = true`) e uma versão superior for identificada:
- A aplicação emite aviso amigável em `stderr`:
  ```text
  ✨ [<app>] Atualização automática aplicada: vX.Y.Z -> vA.B.C.
     A nova versão estará ativa na sua próxima execução.
  ```
