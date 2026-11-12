# Especificação Técnica — Ticket #3: Protocolo OpenDesktop XDG de Auto-Atualização & Distribuição na Banca

**Norma de Referência:** GOST 1.5.0  
**Perfil:** Lilya (`https://lilya.2lp.in/profile.md`)  
**Data:** 2026-10-20  
**Status:** Aprovado / Em Implementação  

---

## 1. Contexto & Motivação

Todas as aplicações de usuário final desenvolvidas sob o perfil Lilya do ecossistema dissidente compartilham da mesma infraestrutura canônica:
1. **Eliminação Integral de Binários Pesados no Codeberg / Git:** O Git armazena estritamente código-fonte, especificações e testes. Binários executáveis não são adicionados a commits nem aos anexos de releases do Codeberg.
2. **Compilação Exclusiva na Nuvem/CI:** Todo binário é construído hermeticamente na esteira de CI/CD (Forgejo Runner com `capacity: 1`), preservando os limites e a responsividade da estação de trabalho local.
3. **Distribuição Canônica na Banca (`https://banca.2lp.in/`):** Binários compilados são publicados diretamente no Cloudflare R2 da Banca com rotação automatizada e manifesto unificado `catalog.json`.
4. **Conformidade com a Especificação OpenDesktop (XDG Base Directory):** Configurações e estados de execução devem respeitar as diretrizes freedesktop.org, permitindo gerenciamento declarativo de canais, pinning de versão e checagem periódica não-bloqueante no arranque com avisos em `stderr`.

---

## 2. Protocolo OpenDesktop / XDG Base Directory

### 2.1 Resolução de Caminhos do Sistema de Arquivos

Toda aplicação CLI ou desktop sob o perfil Lilya DEVE resolver seus diretórios conforme a especificação XDG:

- **Arquivo de Configuração do Usuário:**
  - Resolução: `${XDG_CONFIG_HOME:-~/.config}/<app>/config.toml`
  - Fallback: `~/.config/<app>/config.toml`
  - Permissões: O diretório pai deve ser criado com modo `0755` ou `0700`.

- **Arquivo de Estado de Runtime / Cache de Checagem:**
  - Resolução: `${XDG_STATE_HOME:-~/.local/state}/<app>/update_check.json`
  - Fallback: `~/.local/state/<app>/update_check.json`
  - Permissões: Isolamento completo das configurações permanentes do usuário.

---

### 2.2 Esquema de Configuração Declarativa (`config.toml`)

O arquivo de configuração DEVE conter a seção `[update]` com os campos:

```toml
[update]
# Canal ativo: "stable" ou "nightly" (padrão: "stable")
channel = "stable"

# Travar a versão atual para evitar updates indesejados (padrão: false)
pinned = false

# Versão específica travada se pinned = true (ex: "0.5.0")
# Se vazio e pinned = true, assume a versão atualmente instalada
pin = ""

# Verificação periódica automática de novas versões ao executar o app (padrão: true)
auto_check = true

# Intervalo mínimo em horas entre checagens remotas de rede (padrão: 24 horas)
check_interval_hours = 24
```

#### Precedência de Resolução de Canal:
1. Flag explícita de CLI (`--channel <c>`)
2. Variável de ambiente `<APP>_CHANNEL` (ex: `NAVALHA_CHANNEL`, `LAUDA_CHANNEL`, `LACRAIA_CHANNEL`)
3. Arquivo de configuração `$XDG_CONFIG_HOME/<app>/config.toml` (`update.channel`)
4. Padrão imutável: `"stable"`

---

### 2.3 Esquema de Estado de Verificação (`update_check.json`)

Registrado em `$XDG_STATE_HOME/<app>/update_check.json`:

```json
{
  "last_check_timestamp": 1729411200,
  "latest_remote_version": "0.5.1",
  "channel": "stable"
}
```

---

### 2.4 Ciclo de Vida da Verificação no Arranque & Notificação em `stderr`

Ao executar qualquer comando da CLI ou abrir a aplicação:

1. **Short-Circuit:** Se `update.auto_check == false` ou `update.pinned == true`, encerra a checagem imediatamente sem qualquer chamada de rede.
2. **Fast Cache Check (Aviso Imediato):**
   - Se `update_check.json` indicar que `latest_remote_version > current_version` (conforme SemVer 2.0.0):
   - A aplicação DEVE imprimir uma notificação sutil exclusivamente no canal **`stderr`**:
     ```text
     💡 [<app>] Nova versão disponível: vX.Y.Z (atual: vA.B.C).
        Execute '<app> update' para atualizar.
     ```
3. **Disparo de Checagem Remota Não-Bloqueante:**
   - Se `(agora - last_check_timestamp) >= check_interval_hours * 3600`:
   - Uma consulta HTTP ao endpoint `https://banca.2lp.in/downloads/<app>/<channel>-latest.version` é disparada de forma assíncrona ou com timeout síncrono ultra-curto ($\le 1$ segundo).
   - Se bem-sucedida, atualiza `update_check.json`.
   - Se falhar por timeout ou indisponibilidade de rede, a falha é absorvida silenciosamente, apenas postergando o `last_check_timestamp` para a próxima janela.

---

### 2.5 Política de Travamento de Versão (Pinning)

1. Quando `pinned = true` ou `pin` contém uma versão fixada:
   - `<app> check-update` informa: `📌 Versão pinada em v<ver>. Atualizações automáticas ignoradas.`
   - `<app> update` bloqueia a substituição a menos que a flag `--force` seja fornecida.
   - O aviso periódico no arranque permanece silencioso.

---

### 2.6 Interface de Linha de Comando (CLI)

Todo aplicativo DEVE expor:

- `<app> update`:
  - Flags: `--channel <c>`, `--pin <v>`, `--force`, `--dry-run`
- `<app> check-update`:
  - Flags: `--channel <c>`
- `<app> config`:
  - `show` / `get`: Exibe caminhos XDG e configurações ativas.
  - `set-channel <stable|nightly>`: Salva o canal padrão no `config.toml`.
  - `pin [<version>]`: Ativa o pin na versão fornecida (ou na versão atual caso omitida).
  - `unpin`: Desativa o pin (`pinned = false`).
  - `set-auto-check <true|false>`: Ativa ou desativa a checagem periódica automática.

---

## 3. Arquitetura de Distribuição Canônica na Banca (`banca.2lp.in`)

### 3.1 Topologia de URLs e Endpoints Canônicos

Servidos na raiz `https://banca.2lp.in/downloads/<app>/`:

- `install.sh`: Instalador autônomo em POSIX sh com verificação SHA-256 e destino padrão em `~/.local/bin/`.
- `catalog.json`: Manifesto unificado de todo o ecossistema (`https://banca.2lp.in/downloads/catalog.json`).
- `stable-latest`: Binário do release estável mais recente.
- `dev-latest`: Binário da compilação contínua mais recente.
- `index.json`: Manifesto de compatibilidade estruturado com histórico de versões, checksums SHA-256 e tamanhos em bytes.
- `<app>-<version>-linux-x86_64`: Binário versionado imutável.

---

### 3.2 Política de Retenção e Expurgos (Cloudflare R2)
- Retenção estrita de **5 versões estáveis** no canal `stable`.
- Retenção estrita de **10 compilações** no canal `dev`.

A automação da Banca executa o script `scripts/rotate-downloads.py` mantendo:
- **Canal Estável (`stable`):** estritamente as **5 versões mais recentes**.
- **Canal Noturno (`nightly`):** estritamente as **10 versões mais recentes**.
- Versões obsoletas são removidas fisicamente do bucket R2 e expurgadas de `index.json`.

---

### 3.3 Vitrine Web de Downloads (`site/downloads/`)

- Interface em Vanilla HTML5/CSS/JS sem frameworks pesados.
- Seletor rápido de aplicações com dropdown e deep linking via hash `#<app>`.
- Botões interativos com cópia de comando `curl` em um clique.
- Tabela de histórico de versões com checksums SHA-256 auditáveis.
- Rodapé canônico de duas linhas (identidade travesti latina e licença).

---

### 3.4 Veto Absoluto a Binários no Codeberg / Git

1. Nenhum executável ou tarball compilado pode ser armazenado no Git ou anexado a releases do Codeberg.
2. Apenas código-fonte legível, testes e especificações habitam o repositório Git.
