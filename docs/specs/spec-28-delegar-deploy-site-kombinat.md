# Especificação do Ticket #28: Delegar Deploy do Site ao Kombinat via Generic Packages

## 1. Contexto e Motivação
O workflow `.forgejo/workflows/ci.yml` publicava diretamente no Cloudflare Workers (`npx wrangler deploy`). Com o Kombinat orquestrando entregas a partir dos hooks da Gambi, a CI deve publicar `site/` no Generic Package Registry da forja.

## 2. Requisitos
1. Substituir `npx wrangler deploy` por `cccp package upload site` em `.forgejo/workflows/ci.yml` usando `gambi.2lp.in/lumen/gost-ci-shell:latest`.
2. Corrigir chave `directory` para `dir = "site"` em `.gost/delivery.toml` conforme o schema de `kombinat/src/cd/delivery.rs`.

## 3. Árvore de Decisões (para a Natasha)
- **Alinhamento de Schema:** `kombinat` desserializa `dir` (não `directory`) em `[sites]`.
