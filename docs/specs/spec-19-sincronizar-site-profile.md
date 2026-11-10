# Spec #19: Sincronização de site/profile.md e Expurgo de Termos Proibidos

## 1. Contexto e Motivação
A publicação do perfil Lilya via Cloudflare Workers utiliza o diretório `./site/` como raiz de distribuição.
O arquivo `site/profile.md` e o documento `site/index.html` mantinham termos imperialistas ("soberania") e versão desatualizada, propagando desvios normativos durante a montagem em cascata pelo `cccp` em ambientes de CI desacoplados de checkout local.

## 2. Escopo
1. Sincronizar integralmente `site/profile.md` com o arquivo canônico `profile.md` v2.1.0.
2. Substituir ocorrências de "Soberania" por "Autonomia" em `site/index.html`.
3. Expandir os testes normativos de conformidade para auditar o diretório `site/` contra termos proibidos.
