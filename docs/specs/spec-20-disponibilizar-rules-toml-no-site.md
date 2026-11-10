# Spec #20: Disponibilizar rules.toml em site/rules.toml

## 1. Contexto e Motivação
O deploy estático no Cloudflare Workers publica o diretório `./site/`.
Para que o `cccp` em ambientes desacoplados (CI/CD) consiga obter o catálogo declarativo de regras via `https://lilya.2lp.in/rules.toml`, o arquivo `rules.toml` deve estar presente e sincronizado em `site/rules.toml`.

## 2. Escopo
1. Copiar e sincronizar `rules.toml` para `site/rules.toml`.
2. Adicionar asserção em `tests/test_lilya_v2_1_spec.sh` para garantir paridade contínua de `site/rules.toml` com `rules.toml`.
