# Especificação Técnica: Subordinação do Perfil Lilya a Kollontai e Formalização da Transição para o Gossnab (Ticket #14)

## 1. Contexto e Motivação
A norma operacional Lilya define a parametrização de infraestrutura concreta, identidade transfeminista e fluxos de distribuição do ecossistema.
Esta especificação consolida a integração de Lilya à Tríade Normativa Fechada como camada operacional (`tier: operational`), subordinada a Kollontai v2.1.0 (`tier: tactical`).

## 2. Requisitos Mandatórios

### 2.1 Frontmatter Universal em Inglês
```yaml
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
```

### 2.2 Purga de Terminologias Proibidas
Substituição terminante de qualquer referência imperialista (como "soberania" ou "soberana") por termos normativos legítimos como "Autoridade Normativa", "Centralidade da Forja Primária" ou "Autonomia Operacional".

### 2.3 Gossnab como SSOT Vivo e Eliminação de Manifestos Estáticos
1. **Banimento de Manifestos Estáticos em Repositórios:** É expressamente proibida a manutenção de `kombinat.toml` e `catalog.json` estáticos nos repositórios de código.
2. **SSOT Centralizado:** O serviço vivo `gossnab` (`https://gossnab.2lp.in/api/v1`) assume como Fonte Única da Verdade para catálogo de aplicações, canais, versões ativas, inventário de repositórios e nós de infraestrutura.
3. **Webhooks Multi-Forja e Loop de Reconciliação:** Repositórios cadastrados no Gossnab têm webhooks automáticos configurados para envio de eventos de push e release (Forgejo, GitHub, SourceHut). O Gossnab mantém um loop assíncrono de reconciliação periódica com verificação condicional (`ETag` / `If-Modified-Since`) contra perda de webhooks e limites de requisição.

### 2.4 Segregação Estrita de CI (Gambi) e CD (Kombinat)
1. **Papel da Gambi (CI):** Executa testes herméticos, compilação de binários e publicação de artefatos efêmeros no registro de pacotes genéricos da forja (`PUT /api/packages/{owner}/generic/{package_name}/{version}/{filename}`). A CI nunca publica diretamente em R2/Banca nem efetua conexões SSH em produção.
2. **Papel do Kombinat (CD):** Monitora eventos do Gossnab, descarrega artefatos efêmeros do registro de pacotes da Gambi, valida assinaturas e checksums SHA-256, publica na Banca (Cloudflare R2) e Pratilera, e imediatamente remove os pacotes efêmeros de staging da Gambi (`DELETE /api/packages/{owner}/generic/{package_name}/{version}/{filename}`).
3. **Entrega Contínua de Servidores:** O Kombinat orquestra atualizações de serviços conteinerizados via SSH nos nós de infraestrutura (`obizero`, `obione`, `obitwo`), acionando `docker compose pull` e restart do container.

### 2.5 Catálogo Declarativo de Regras Tridigitais (`rules.toml`)
- `LILYA-001`: Proibição de arquivos estáticos legados `catalog.json` e `kombinat.toml` na raiz do repositório.
- `LILYA-002`: Conformidade do `.cccprc` com a forja primária canônica `gambi.2lp.in`.
- `LILYA-003`: Declaração de identidade transfeminista canônica no rodapé da documentação.
- `LILYA-004`: Uso estrito de `compose.yaml` (banimento de extensão `.yml`) para serviços conteinerizados.
- `LILYA-005`: Ausência de termos proibidos imperialistas na documentação e especificações.
