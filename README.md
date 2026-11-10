# gost-profile-lilya

Perfil de Implementação Lilya (anteriormente Lumen) para a norma GOST 2.0.0 (estende o perfil Kollontai 2.0.0).

## 📋 Metadados do Perfil

- **ID do Perfil:** `lilya`
- **Herança (`extends`):** [`https://kollontai.2lp.in/profile.md`](https://kollontai.2lp.in)
- **Norma Base:** GOST `2.0.0`
- **URL Canônica:** [`https://lilya.2lp.in/profile.md`](https://lilya.2lp.in/profile.md)
- **Vitrine Web:** [`https://lilya.2lp.in`](https://lilya.2lp.in)
- **Licença:** [CC-BY-SA-4.0](./LICENSE)
- **Forja Canônica:** [Forgejo em Gambi](https://gambi.2lp.in/lumen/gost-profile-lilya)
- **Espelho FOSS:** [Codeberg](https://codeberg.org/lumenpink/gost-profile-lilya)

## 🎯 Especializações do Perfil Lilya

1. **Forja Primária e Push Mirrors:** Hospedado em `gambi.2lp.in` com espelhamento duplo para Codeberg e GitHub (`pushurl = no_push` nos PR remotes).
2. **Exibição Estrita de Versão:**
   - **Short (v{MAJOR}.{MINOR}.{PATCH}):** Exibida em títulos, tags e badges.
   - **Long (Conteúdo Integral de `VERSION`):** Exibida obrigatoriamente no rodapé canônico.
3. **Rodapé Canônico Transfeminista em 2 Linhas:**
   - **Linha 1:** `Orgulhosamente produzido por uma travesti latina 🏳️‍⚧️ :)` (termo *travesti* intraduzível em 10 línguas).
   - **Linha 2:** `{App} v{LongVersion} • por Lumen Pink • Brasil 🇧🇷 • [{Licença}](LICENSE)`.
4. **Distribuição na Banca (`banca.2lp.in`):** Vitrine interativa, comando `install.sh` universal e retenção 5/10 no Cloudflare R2.
5. **Continuous Deployment Desacoplado:** Orquestração em `compose.yaml` (banido `.yml`), probe de healthcheck e rollback automático de 15s no nó `obizero`; nós `obione` e `obitwo` via Tailscale. Sem Watchtower.
6. **Banners & Open Graph (Padrão KokoroSim):** 1200x630 com Safe Zone 4:3 central e simulador em [`site/card_preview.html`](site/card_preview.html).

## 🚀 Verificação de Conformidade

```bash
# Validar conformidade estrita GOST
./tests/audit_profile.sh
cccp check --strict
```

## 📄 Licença

Distribuído sob a licença [Creative Commons Attribution-ShareAlike 4.0 International (CC-BY-SA-4.0)](./LICENSE).
