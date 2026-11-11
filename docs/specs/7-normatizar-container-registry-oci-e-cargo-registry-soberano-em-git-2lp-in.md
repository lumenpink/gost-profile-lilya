# Especificação Técnica: Normatização de Container Registry OCI e Cargo Registry Próprio

**Ticket:** #7  
**Fase:** Fase 3 (Spec / Documentação Normativa)  
**Status:** Em Elaboração  
**Autor:** Lumen Pink / Antigravity  

---

## 1. Contexto e Motivação

Com a consolidação da infraestrutura própria na forja autônoma `git.2lp.in` (Forgejo), foram validados os suportes nativos a:
1. **Container Registry OCI/Docker** integrado ao Forgejo, com dados armazenados no storage persistente em `/media/hd1/forgejo/data/packages`.
2. **Cargo Registry (Rust)** para crates internas do ecossistema (`gost`, `cccp`, `baquara`, etc.).

Este documento normatiza formalmente na especificação do perfil Lilya (`profile.md`) as diretrizes operacionais, configurações de autenticação e fluxos de publicação para esses registries autônomos.

---

## 2. Requisitos Normativos

### 2.1 Container Registry OCI / Docker
- **Endpoint Canônico:** `git.2lp.in/<owner>/<image>:<tag>`
- **Autenticação:** Via `docker login git.2lp.in` utilizando Personal Access Token (PAT) com escopo de escrita em pacotes.
- **Diretrizes de Tags:**
  - `stable`: tags SemVer exatas (`x.y.z`).
  - `dev`: tags SemVer completas com timestamp (`x.y.z-dev.{n}+{YYYYMMDD}.{commit}`).
  - Proibição de tags flutuantes não rastreadas em pipelines de produção.
- **Armazenamento:** Persistência no HD1 (`/media/hd1/forgejo/data/packages`), preservando o SSD do nó central.

### 2.2 Cargo Registry (Rust)
- **Registro Local / Próprio:** `git.2lp.in` para distribuição interna de crates entre projetos.
- **Configuração Canônica em `.cargo/config.toml`:**
  ```toml
  [registries.gambi]
  index = "sparse+https://git.2lp.in/api/packages/lumen/cargo/"

  [registry]
  default = "gambi"
  ```
- **Fluxo de Publicação:** `cargo publish --registry gambi` com token canônico.

---

## 3. Árvore de Decisões Arquiteturais (para a Natasha)

1. **Por que adotar registries integrados à forja local em vez de registries públicos externos (Docker Hub, GHCR, crates.io)?**
   - *Alternativa Descartada:* Publicar contêineres no Docker Hub ou GitHub Container Registry.
   - *Motivo do Descarte:* Sujeição a rate limits agressivos, dependência de tráfego de rede externa para nós locais (`obizero`, `obione`, `obitwo`) e quebra de soberania de dados.
   - *Decisão Adotada:* Utilizar o package registry integrado do Forgejo (`git.2lp.in`), garantindo latência de loopback/barramento local, zero rate limits e isolamento seguro de infraestrutura.
2. **Por que persistir no HD1 (`/media/hd1/forgejo/data/packages`)?**
   - *Decisão:* Imagens Docker acumulam dezenas de gigabytes rapidamente. Isolar no disco mecânico HD1 de alta capacidade evita desgaste e esgotamento prematuro do SSD raiz.
3. **Por que purgar terminologia imperialista ("soberano")?**
   - *Decisão:* Em estrito cumprimento às diretrizes éticas e colaborativas do ecossistema, substituímos qualquer jargão imperialista/monárquico por "autônomo" ou "próprio".

---

## 4. Plano de Testes (Fase 4 & Fase 7)
- Script de teste: `tests/test_registries_spec.sh`.
- Asserções no `profile.md`:
  - Presença de seção de Container Registry OCI com endpoint `git.2lp.in`.
  - Presença de seção de Cargo Registry com configuração `.cargo/config.toml`.
  - Ausência total de termos proibidos (como "soberano").
- Mutantes:
  - Omissão de `git.2lp.in` como registry.
  - Inserção de termos proibidos.
