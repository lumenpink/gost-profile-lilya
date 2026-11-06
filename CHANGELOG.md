# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **spec(kombinat):** definir orquestração contínua via Kombinat para propagação de versões canônicas e compilação em cascata com recomendação flexível (#12)


## [2.0.0] - 2026-10-26

### Added
- **profile:** renomeação oficial do perfil para Lilya (`id: lilya`, `name: "Perfil de Implementação Lilya"`).
- **spec:** alinhamento normativo integral com GOST 2.0.0 e extensão do perfil Kollontai 2.0.0.
- **spec:** nova URL canônica de documentação: `https://lilya.2lp.in/profile.md`.
- **forge:** consagração da forja primária soberana em `gambi.2lp.in` com push mirrors duplos (Codeberg e GitHub).
- **spec:** afirmação identitária transfeminista no rodapé em duas linhas nas 10 línguas oficiais.
- **spec:** diferenciação entre Versão Short no topo e Versão Long no rodapé.
- **web:** padronização de publicação na borda via Cloudflare Workers em `wrangler.jsonc` (`lilya.2lp.in`) e Dioxus (`in.2lp.<slug>`).
- **banca:** catálogo soberano da Banca (`banca.2lp.in`), retention de 5 estáveis / 10 nightlies e auto-update XDG.
- **cd:** continuous deployment de containers em `compose.yaml` (banido `.yml`) com rollback de 15s em `obizero` e deploy via Tailscale em `obione`/`obitwo` sem Watchtower.
- **rules:** manifesto de sobreposição de regras `lilya_rules.json` para deep merge pelo Maestro `cccp`.

### Fixed
- **ci:** remover step obsoleto de deploy para pages (closes #9)

### Added
- **spec:** normatizar flag e mecanismo de auto_update configuravel (closes #5)
- **spec:** normatizar continuous deployment soberano de containers e descomissionar watchtower (closes #4)
- **spec:** normatizar protocolo opendesktop xdg de auto-atualizacao e distribuicao banca (closes #3)
- Inicialização do repositório em conformidade com o padrão GOST.
