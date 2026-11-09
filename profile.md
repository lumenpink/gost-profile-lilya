---
standard: "lilya"
tier: "operational"
version: "2.1.0"
locale: "pt-br"
authority: "Standards Committee"
published_at: "2026-11-08"
inherits_from:
  standard: "kollontai"
  tier: "tactical"
  version: "2.1.0"
  base_url: "https://kollontai.2lp.in/2.1.0/"
---

# Perfil de Implementação GOST: Lilya

> **Sobre este Perfil:**  
> O perfil **Lilya** (anteriormente denominado *Lumen*) é a especialização autoral, pessoal e de infraestrutura do padrão **[GOST](https://gost.2lp.in)**.  
> Ele estende diretamente o perfil base **[Kollontai](https://kollontai.2lp.in)** (`extends: https://kollontai.2lp.in/profile.md`), herdando a autoridade do Maestro **`cccp`**, a matriz de toolchains homologadas e os protocolos de distribuição, aplicando precedência estrita (*deep override*) para a forja canônica em `gambi.2lp.in`, publicação na borda (`*.2lp.in`), catálogo de binários (`banca.2lp.in`), afirmação identitária transfeminista no rodapé e entrega contínua nos servidores `obizero`, `obione` e `obitwo`.

---

## 1. Identidade, Forja Canônica (`gambi.2lp.in`) e Espelhos

### 1.1 Parâmetros Canônicos do Maestro (`.cccprc`)
No perfil Lilya, o Maestro `cccp` opera com os seguintes parâmetros canônicos de infraestrutura:

```ini
agent_var_lang = portuguese

# Forja Primária Canônica (Forgejo em gambi.2lp.in)
primary_forge_type = forgejo
primary_forge_domain = gambi.2lp.in
primary_owner = lumen
primary_repo = <slug>
primary_ssh_url = git@gambi.2lp.in:lumen/<slug>.git

# Espelhos Passivos e Ingestão de Fronteira
mirrors = codeberg,github
mirror_owner = lumenpink
```

### 1.2 Topologia de Repositórios e Push Mirrors Duplos
1. **Forja Primária Canônica:** Hospedada em `https://gambi.2lp.in/lumen/<slug>` (acesso SSH via porta 22 padrão em `git@gambi.2lp.in:lumen/<slug>.git`).
2. **Push Mirrors Automatizados (`sync_on_commit: true`):** A instância `gambi.2lp.in` replica imediatamente todo push recebido na branch `main` (e tags/branches persistentes) para dois espelhos externos de vitrine e preservação:
   - **Espelho FOSS:** Codeberg (`https://codeberg.org/lumenpink/<slug>`)
   - **Espelho Comunitário:** GitHub (`https://github.com/lumenpink/<slug>`)
3. **Remotes Locais e Ingestão de PRs:**
   - O desenvolvedor e os agentes de IA executam `cccp push` exclusivamente para o `origin` (`git@gambi.2lp.in:lumen/<slug>.git`).
   - Os remotes `codeberg` e `github` são mantidos pelo `cccp` com `pushurl = no_push` e refspec `+refs/pull/*/head:refs/remotes/<remote>/pr/*` para ingestão segura na quarentena `inbox/*`.

### 1.3 Allowlist Estrita de Rede na Esteira (`ci.yml`)
Na auditoria da regra `GOST-10-CI-HERMETIC-SINGLE-FILE`, a esteira `.forgejo/workflows/ci.yml` nos runners do ecossistema Lilya **SÓ PODE** referenciar recursos e espelhos internos sob os domínios:
* **`gambi.2lp.in`** (Actions espelhadas internamente ou relativas sem prefixo de servidor).
* **`crates.2lp.in`** (Registry interno e espelho de pacotes).
* **`banca.2lp.in`** (Despacho de artefatos compilados na fila `release`).
* Chamadas a outros domínios de rede pública quebram o `cccp check --strict` imediatamente.

---

## 2. Rodapé Canônico em Duas Linhas (Afirmação Identitária & Autonomia)

O perfil Lilya preenche o template estrutural de rodapé herdado do perfil Kollontai com a afirmação identitária transfeminista sul-americana nas 10 línguas oficiais da norma GOST.

### 2.1 Estrutura HTML Canônica
Todo aplicativo com interface gráfica, TUI/CLI com rodapé formatado, vitrine pública ou documentação estática (`./site`) **DEVE** renderizar as duas linhas rigorosamente nesta estrutura:

```html
<footer class="footer">
  <p>Orgulhosamente produzido por uma <a href="https://travesti.2lp.in/pt/" target="_blank" rel="noopener">travesti latina</a> 🏳️‍⚧️ :)</p>
  <p>{title} v{version_full} • por <a href="https://lumen.pink" target="_blank" rel="noopener">Lumen Pink</a> • Brasil 🇧🇷 • <a href="LICENSE">{license_spdx}</a></p>
</footer>
```

### 2.2 Regras Invioláveis de Renderização do Rodapé
1. **Intraduzibilidade Política do Termo `travesti`:** O substantivo *travesti* permanece rigorosamente sem tradução nos 10 idiomas oficiais, preservando sua singularidade histórica e geopolítica latino-americana. O adjetivo concorda gramaticalmente com o idioma ativo e aponta para `https://travesti.2lp.in/<lang>/`.
2. **Versão Short vs. Versão Long:**
   - Cabeçalhos, títulos de janela e badges no topo da página exibem estritamente a **Versão Short** (`v{MAJOR}.{MINOR}.{PATCH}`, truncada antes do `+`).
   - A Linha 2 do rodapé exibe obrigatoriamente a **Versão Long** (string integral do arquivo `VERSION`, incluindo metadados de build `+YYYYMMDD`, ex: `v0.1.0+20261026`).

### 2.3 Matriz Oficial de Tradução do Rodapé (10 Línguas)

| ISO | Linha 1 (Afirmação Identitária Transfeminista) | Linha 2 (Metadados de Autonomia e Licença) |
|:---:|---|---|
| **`pt`** | Orgulhosamente produzido por uma [travesti latina](https://travesti.2lp.in/pt/) 🏳️‍⚧️ :) | {title} v{ver} • por [Lumen Pink](https://lumen.pink) • Brasil 🇧🇷 • [{lic}](LICENSE) |
| **`en`** | Proudly produced by a [Latin American travesti](https://travesti.2lp.in/en/) 🏳️‍⚧️ :) | {title} v{ver} • by [Lumen Pink](https://lumen.pink) • Brazil 🇧🇷 • [{lic}](LICENSE) |
| **`es`** | Orgullosamente producido por una [travesti latinoamericana](https://travesti.2lp.in/es/) 🏳️‍⚧️ :) | {title} v{ver} • por [Lumen Pink](https://lumen.pink) • Brasil 🇧🇷 • [{lic}](LICENSE) |
| **`fr`** | Fièrement produit par une [travesti latino-américaine](https://travesti.2lp.in/fr/) 🏳️‍⚧️ :) | {title} v{ver} • par [Lumen Pink](https://lumen.pink) • Brésil 🇧🇷 • [{lic}](LICENSE) |
| **`de`** | Mit Stolz entwickelt von einer [lateinamerikanischen Travesti](https://travesti.2lp.in/de/) 🏳️‍⚧️ :) | {title} v{ver} • von [Lumen Pink](https://lumen.pink) • Brasilien 🇧🇷 • [{lic}](LICENSE) |
| **`it`** | Orgogliosamente prodotto da una [travesti latinoamericana](https://travesti.2lp.in/it/) 🏳️‍⚧️ :) | {title} v{ver} • da [Lumen Pink](https://lumen.pink) • Brasile 🇧🇷 • [{lic}](LICENSE) |
| **`ru`** | С гордостью создано [латиноамериканской travesti](https://travesti.2lp.in/ru/) 🏳️‍⚧️ :) | {title} v{ver} • от [Lumen Pink](https://lumen.pink) • Бразилия 🇧🇷 • [{lic}](LICENSE) |
| **`zh`** | 由一位[拉美 travesti](https://travesti.2lp.in/zh/) 自豪制作 🏳️‍⚧️ :) | {title} v{ver} • 来自 [Lumen Pink](https://lumen.pink) • 巴西 🇧🇷 • [{lic}](LICENSE) |
| **`ja`** | [ラテンアメリカの travesti](https://travesti.2lp.in/ja/) によって誇りを持って制作されました 🏳️‍⚧️ :) | {title} v{ver} • 制作: [Lumen Pink](https://lumen.pink) • ブラジル 🇧🇷 • [{lic}](LICENSE) |
| **`ar`** | صُنع بكل فخر بواسطة [travesti أمريكية لاتينية](https://travesti.2lp.in/ar/) 🏳️‍⚧️ :) | {title} v{ver} • بواسطة [Lumen Pink](https://lumen.pink) • البرازيل 🇧🇷 • [{lic}](LICENSE) |

---

## 3. Publicação Web na Borda (`*.2lp.in`) e Empacotamento Dioxus

### 3.1 Hospedagem Estática via Cloudflare Workers (`wrangler.jsonc`)
Toda vitrine pública (`./site`) é publicada sob o domínio `<slug>.2lp.in` através de `wrangler.jsonc` na raiz:

```jsonc
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "name": "<slug>",
  "compatibility_date": "2026-01-01",
  "routes": [
    {
      "pattern": "<slug>.2lp.in",
      "custom_domain": true
    }
  ],
  "assets": {
    "directory": "./site"
  }
}
```

* **Redundância Estática:** A fila `deploy` da esteira publica simultaneamente o snapshot em branch órfã stateless `pages` para o Codeberg Pages (`https://lumenpink.codeberg.page/<slug>/`).

### 3.2 Identificador de Bundle Canônico (`Dioxus.toml`)
Para aplicações gráficas e mobile construídas com Dioxus 0.8, o namespace reverso e o publisher são fixados como:

```toml
[application]
name = "<slug>"
default_platform = "web"

[bundle]
identifier = "in.2lp.<slug>"
publisher = "Lumen Pink"
icon = ["site/assets/icon.png"]
```

---

## 4. Distribuição e Catálogo da Banca (`banca.2lp.in` e Cloudflare R2)

A autoridade central de distribuição de executáveis e pacotes definida na Seção 4 do perfil Kollontai opera sob o modelo **Produtor–Curador Desacoplado** servido via Cloudflare R2 e publicado na borda:

* **Topologia Física de Storage (Cloudflare R2):**
  Todos os artefatos são mantidos sob o prefixo:
  ```text
  banca-artifacts/{app}/{channel}/
  ```
  - Artefatos versionados e hashes: `{app}-{versao}-{target}.{ext}` e `.sha256`.
  - Cópias físicas de aliases sobrescritas: `{app}-latest-{target}.{ext}` (em `stable`) ou `{app}-dev-latest-{target}.{ext}` (em `dev`), juntamente com seus arquivos `.sha256`.
* **Cotas Operacionais e Política de Retenção Estrita:**
  - **Canal `stable` (Versão Recomendada):** Retém estritamente as **5 versões mais recentes** (`x.y.z`), com alias canônico `*-latest.*`.
  - **Canal `dev` (Versão Experimental):** Retém estritamente as **10 versões mais recentes** (`x.y.z-dev.{n}+{YYYYMMDD}.{commit}`), com alias canônico `*-dev-latest.*`.
  - Artefatos e hashes `.sha256` excedentes que ultrapassarem essas cotas são permanentemente purgados do bucket R2 pela esteira da Banca.
* **Transição para o Gossnab e Banimento de Manifestos Estáticos:**
  - **Banimento de `catalog.json` e `kombinat.toml` em Repositórios:** É expressamente banido manter arquivos estáticos de manifesto como `catalog.json` ou `kombinat.toml` dentro de repositórios de código.
  - **SSOT Centralizado Vivo (`gossnab`):** O serviço vivo **`gossnab`** (`https://gossnab.2lp.in/api/v1`) é a Fonte Única da Verdade para metadados de release, canais, inventário de artefatos e versionamento do ecossistema.
  - Durante o período de transição, a Banca gera e sincroniza views de compatibilidade retroativa em `https://banca.2lp.in/downloads/<slug>/index.json` consumindo a API viva do Gossnab.
* **Comando Universal de Instalação e Vitrine:**
  - Vitrine: `https://banca.2lp.in/downloads/#<slug>` (design brutalista/cyberpunk em Vanilla HTML/CSS/JS com cópia rápida de comando `curl` e tabela de hashes SHA-256).
  ```sh
  curl -sSf https://banca.2lp.in/downloads/<slug>/install.sh | sh
  ```
* **Protocolo de Auto-Update XDG:** Os binários CLI consultam diretamente a API viva do Gossnab (`https://gossnab.2lp.in/api/v1/apps/<slug>/update`) para o protocolo de auto-atualização (`<slug> check-update` / `<slug> update`), com fallback para `index.json`.
* **Tolerância Zero a Links Quebrados:** Se qualquer artefato declarado (novo ou histórico ativo nas cotas 5/10) falhar na verificação de rede ou divergência de checksum SHA-256, o deploy na Cloudflare é abortado imediatamente e um ticket automático é aberto na forja do projeto de origem (`POST /api/v1/repos/{repo_slug}/issues`).

---

## 5. Segregação Arquitetural: Gambi (CI) vs. Kombinat (CD)

Para eliminar atritos operacionais e garantir desacoplamento total entre integração contínua e entrega contínua, o perfil Lilya estabelece fronteiras estritas de responsabilidade:

### 5.1 O Papel da Gambi: Integração Contínua (CI)
* **Escopo:** Compilação, execução de testes unitários e de integração, verificação de linters/formatação e empacotamento.
* **Publicação Efêmera de Staging:** A esteira de CI em `gambi.2lp.in` publica artefatos compilados exclusivamente no Generic Package Registry da própria forja via `PUT /api/packages/{owner}/generic/{package_name}/{version}/{filename}`.
* **Isolamento de Produção:** A CI da Gambi **NÃO** efetua conexões SSH em servidores de produção nem realiza uploads diretos para storages externos (Cloudflare R2 / Banca / Pratilera).

### 5.2 O Papel do Kombinat: Entrega Contínua (CD) e Propagação em Cascata
* **Ingestão e Despacho de Binários:** O Kombinat consome os artefatos efêmeros de staging da Gambi, valida assinaturas e hashes SHA-256, e realiza a publicação externa definitiva na Banca (Cloudflare R2) e Pratilera.
* **Purga Imediata de Staging:** Imediatamente após a confirmação do despacho com sucesso, o Kombinat remove os artefatos efêmeros do registro da Gambi emitindo `DELETE /api/packages/{owner}/generic/{package_name}/{version}/{filename}`, mantendo a forja limpa e sem acúmulo de storage.
* **Propagação Automatizada em Cascata:** Ao detectar uma nova versão canônica de desenvolvimento publicada a montante (upstream), o Kombinat orquestra a propagação dos bumps exatos nos manifestos de compilação dos módulos a jusante (downstream). A fixação em versões canônicas exatas é recomendada, sem impor qualquer trava mandatória contra o uso prático de aliases.
* **Entrega Contínua de Servidores (CD):** O Kombinat assume a responsabilidade de acionar as atualizações dos serviços conteinerizados via SSH nos servidores (`obizero`, `obione`, `obitwo`), disparando `docker compose pull && docker compose up -d` e restart de containers.

### 5.3 Webhooks Multi-Forja e Loop de Reconciliação no Gossnab
* **Ingestão Multi-Forja:** Repositórios registrados no Gossnab possuem webhooks ativos apontando para o Gossnab (suportando Forgejo/Gambi, GitHub e SourceHut).
* **Loop de Reconciliação Anti-Drift:** Para mitigar falhas ou perdas de entrega de webhooks sem retentativa nativa, o Gossnab executa uma rotina periódica de conciliação a cada $N$ minutos, utilizando cabeçalhos condicionais HTTP (`ETag` e `If-Modified-Since`) para evitar requisições redundantes e rate limits.

---

## 6. Entrega Contínua de Servidores (CD em `obizero`, `obione` e `obitwo`)

Para serviços conteinerizados autohospedados, o perfil Lilya opera com **Continuous Deployment (CD) Determinístico** orquestrado pelo **Kombinat CD** (eliminando etapas de SSH e deploy direto da esteira de CI), com banimento total do Watchtower.

### 5.1 Padrão de Orquestração e Healthcheck Obrigatório
Todos os serviços residem em `~/stacks/<slug>/compose.yaml` (estritamente com extensão `.yaml`, sendo banida a extensão `.yml`) e declaram probe ativa de saúde:

```yaml
services:
  app:
    image: lumenpink/<slug>:${APP_VERSION:-latest}
    user: "1000:1000"
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "curl -fsS http://127.0.0.1:<port>/healthz || exit 1"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
```

### 5.2 Topologia de Deploy por Nó de Infraestrutura

#### 1. Nó Central de Execução (`obizero` — Deploy Local via Socket)
* O `forgejo-runner` executa no host `obizero` com o socket Docker montado.
* A imagem recém-compilada na fila `build` já reside no daemon local (`lumenpink/<slug>:<version>`).
* O deploy ocorre sem tráfego externo redundante:
  ```sh
  docker compose -f /home/lumen/stacks/<slug>/compose.yaml up -d --no-build <slug>
  ```
* **Verificação Síncrona de Saúde e Rollback Automático (15s):**
  A esteira monitora o status do container por até 15 segundos. Caso o estado não atinja `healthy` (ou `running` estável), a esteira captura `docker logs --tail 50 <slug>`, reverte imediatamente para a tag estável anterior, executa `docker image prune -f` e falha o pipeline com código não-zero.

#### 2. Nós de Borda Remotos (`obione` e `obitwo` — Deploy via Mesh VPN Tailscale)
* Para serviços distribuídos nos nós de borda (acessíveis via rede privada WireGuard/Tailscale ou expostos via Cloudflare Tunnel `cloudflared` em `app.<slug>.2lp.in`):
* A esteira publica a imagem e aciona a atualização remotamente via SSH sobre a malha Tailscale:
  ```sh
  ssh -o StrictHostKeyChecking=accept-new lumen@<no-tailscale> \
    "docker compose -f ~/stacks/<slug>/compose.yaml pull && \
     docker compose -f ~/stacks/<slug>/compose.yaml up -d && \
     docker image prune -f"
  ```

### 6.3 Mandato de Conteinerização Universal em Stacks e Topologia de Rede
1. **Banimento de Daemons no Host:** É estritamente proibido rodar serviços, APIs ou daemons de backend diretamente instalados no sistema operacional hospedeiro dos servidores (`obizero`, `obione`, `obitwo`). Todo serviço roda isolado via `~/stacks/<slug>/compose.yaml`.
2. **Topologia de Segurança e Ingress:**
   - **Ponto Único de Ingress Público:** Apenas o Gossnab possui porta pública exposta (via Cloudflare Tunnel / Gateway reverso) para recepção de webhooks das forjas externas e atendimento à Banca.
   - **Isolamento do Kombinat:** O Kombinat opera estritamente confinado na rede privada interna, sem portas abertas para a internet pública, interagindo como cliente ativo unidirecional para tarefas de orquestração, build, assinatura, publicação externa e deploy via SSH.

---

## 7. Sobreposição de Regras de Conformidade (`lilya_rules.json`)

Quando o `cccp sync` compila as regras para um repositório sob o perfil Lilya, as seguintes parametrizações específicas sobrepõem (*deep merge*) o `rules.json` base da GOST:

```json
{
  "extends": "GOST-2.0.0",
  "profile": "lilya",
  "rules_override": [
    {
      "id": "GOST-09-SITE-SECURITY-HEADERS",
      "require_footer_links": [
        "https://travesti.2lp.in/",
        "https://lumen.pink"
      ]
    },
    {
      "id": "GOST-10-CI-HERMETIC-SINGLE-FILE",
      "allowed_uses_domains": ["gambi.2lp.in"],
      "allowed_run_domains": ["gambi.2lp.in", "crates.2lp.in", "banca.2lp.in"]
    },
    {
      "id": "GOST-25-REMOTES-AND-INBOX-QUARANTINE",
      "required_origin_pattern": "^git@gambi\\.2lp\\.in:lumen/[a-z0-9-]+\\.git$",
      "required_mirrors": {
        "codeberg": "https://codeberg.org/lumenpink/<slug>.git",
        "github": "https://github.com/lumenpink/<slug>.git"
      }
    }
  ]
}
```

---

## 7. Conformidade Operacional de Interfaces CLI (*Post-Build*)

Todo utilitário CLI ou ferramenta de linha de comando voltada a desenvolvedores e usuárias finais, quando submetido à validação no escopo canônico `post-build`, DEVE:
1. **Flag de Ajuda Informativa (`--help`):** Responder com código 0 e texto estruturado de instruções mínimas de operação.
2. **Fidelidade Canônica de Versão (`--version`):** Responder com código 0 e texto contendo a versão exata do manifesto `VERSION` ou `Cargo.toml`.
3. **Ciclo de Vida e Atualização:** Quando aplicável ao canal de distribuição, manter subcomando canônico de verificação ou atualização (`update` / `self-update`) integrado aos canais da Banca.


---

## 8. Portarias Operacionais da Fábrica Tulipa (LILYA-001 a LILYA-009)

O perfil Lilya consolida as regras operacionais idiossincráticas da fábrica de software Tulipa, subordinadas aos decretos da Kollontai e às diretrizes do GOSPLAN:

| ID | Nome Canônico | Escopo | Descrição Sumária |
| :--- | :--- | :--- | :--- |
| **LILYA-001** | `VERSION-NO-V-PREFIX` | `project` | Proíbe estritamente o uso do prefixo 'v' no arquivo canônico `VERSION`. |
| **LILYA-002** | `TRANSFEMINIST-IDENTITY-REQUIRED` | `project` | Exige a afirmação de identidade transfeminista (`travesti`, `lumen.pink`) na documentação ou site. |
| **LILYA-003** | `PRIMARY-FORGE-GAMBI-CANONICAL` | `project` | Declaração mandatória da forja canônica Tulipa `gambi.2lp.in` em `.cccprc`. |
| **LILYA-004** | `CCCPRC-FILE-REQUIRED` | `project` | Presença e configuração obrigatória do arquivo `.cccprc` na raiz do repositório. |
| **LILYA-005** | `STATIC-MANIFESTS-PROHIBITED` | `project` | Proibição estrita de manifestos estáticos `catalog.json` e `kombinat.toml`. |
| **LILYA-006** | `STRICT-COMPOSE-YAML-EXTENSION` | `project` | Proibição de `.yml` e `docker-compose.yml`, exigindo estritamente `compose.yaml`. |
| **LILYA-007** | `METADATA-MANIFEST-SCHEMA` | `project` | Validação de schema do manifesto canônico de metadados Gossnab `.gost/metadata.json`. |
| **LILYA-008** | `CLI-HELP-INFORMATIVE-POST-BUILD` | `post-build` | Validação pós-compilação de texto informativo e estruturado via flag `--help`. |
| **LILYA-009** | `CLI-VERSION-METADATA-PARITY-POST-BUILD` | `post-build` | Validação pós-compilação de paridade exata da saída de `--version` com o arquivo `VERSION`. |
