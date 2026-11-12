# Especificação Técnica — Ticket #25: Incorporar Kombinat e Kontur e Purgar Perfil Lumen

## 1. Contexto & Motivação
O perfil Lilya é o nível operacional concreto da Fábrica Tulipa sob a norma GOST. Com a formalização dos 5 pilares do ecossistema, os binários de *Entrega Contínua (CD)* (`kombinat`) e de *Controlador de Fronteira e Sincronia* (`kontur`) devem ser explicitamente amarrados à tabela de binários concretos homologados da Seção 1. Simultaneamente, devem ser purgadas todas as referências residuais à nomenclatura legada "perfil Lumen".

## 2. Decisão Arquitetural
- **Incorporação Operacional na Tabela de Binários:**
  - *Agente de Entrega e Orquestração Contínua (CD):* **`kombinat`** (`git.2lp.in/lumen/kombinat`, `kombinat.2lp.in`), responsável pelo despacho a storages de distribuição, purga de staging e deploy SSH conteinerizado com rollback.
  - *Controlador de Fronteira e Sincronia:* **`kontur`** (`kt`) (`git.2lp.in/lumen/kontur`, `kontur.2lp.in`), responsável pela sincronização de espelhos públicos (`pushurl = no_push`), reconciliação anti-drift e quarentena de PRs em `inbox/*`.
- **Expurgo Rigoroso de "Perfil Lumen":**
  - Remoção de `(anteriormente denominado *Lumen*)` e de todas as ocorrências de `perfil Lumen` no `profile.md`, `site/index.html`, `site/card_preview.html`, `site/2.1.0/RULES.md`, `scripts/generate_og_image.py` e especificações históricas em `docs/`.

## 3. Alternativas Descartadas (Para a Natasha)
- **Alternativa Descartada 1: Deixar `kombinat` e `kontur` fora da tabela de binários concretos.**
  *Motivo do Descarte:* Faria a camada operacional incompleta, obrigando desenvolvedoras a deduzirem implicitamente quais ferramentas operam o CD e a fronteira.
- **Alternativa Descartada 2: Manter referências duplas "Lilya (Lumen)".**
  *Motivo do Descarte:* Gera confusão de URLs e quebra a autoridade do novo domínio canônico `lilya.2lp.in`.

## 4. Verificação
- Verificação de ausência de "perfil lumen" e "gost-profile-lumen" no repositório.
- Sincronização entre `profile.md` e `site/2.1.0/RULES.md`.
