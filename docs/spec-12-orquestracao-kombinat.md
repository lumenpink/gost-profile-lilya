# Especificação Técnica — Ticket #12: Orquestração Contínua de Dependências e Propagação de Versões via Kombinat

**Norma de Referência:** GOST 2.0.0  
**Perfil:** Lilya (`https://lilya.2lp.in/profile.md`)  
**Data:** 2026-11-06  
**Status:** Aprovado / Em Implementação (Fase 3 DD-TDD)  

---

## 1. Contexto & Motivação

No perfil Lilya, projetos e submódulos interdependentes (como as bibliotecas satélites e o motor central do ecossistema Joaju) possuem lançamentos contínuos no canal de desenvolvimento e dependências cruzadas registradas no registro interno (`gambi.2lp.in` / `crates.2lp.in`) e no armazenamento de pacotes genéricos/staticlibs.

Para manter a integridade, rastreabilidade e evitar quebras automáticas dispersas ao longo da cadeia de compilação, a sincronização manual de versões torna-se inviável. Faz-se necessária a definição formal do papel do daemon **Kombinat** como o componente orquestrador de versões em cascata.

Adicionalmente, alinhado à Seção 4 do perfil base Kollontai, a amarra estrita de versões canônicas deve ser tratada como **recomendação arquitetural**, sem a imposição de travas sintáticas que impeçam desenvolvedores e projetos de consumirem aliases de desenvolvimento (`latest-dev`, `X.Y.Z-dev`) quando for conveniente.

---

## 2. Requisitos Técnicos

### 2.1 O Papel do Daemon Kombinat
1. **Monitoramento Contínuo:**
   - O daemon Kombinat atua como o orquestrador automatizado de dependências no ecossistema Lilya.
   - Monitora eventos de publicação e novos registros de pacotes (`cargo`, `generic`) na forja primária (`gambi.2lp.in`) e no registro interno (`crates.2lp.in`).
2. **Propagação Automatizada em Cascata:**
   - Ao detectar uma nova versão canônica de desenvolvimento publicada por um módulo upstream (ex.: `dev.XX`), o Kombinat atualiza de forma autônoma e controlada os manifestos (`Cargo.toml`, etc.) dos módulos consumidores a jusante.
   - Executa a suíte de testes de integração e aciona a compilação em cascata garantindo que a cadeia se mantenha sincronizada e íntegra.

### 2.2 Recomendação Sem Trava Obrigatória
1. **Recomendação de Boas Práticas (*SHOULD* / *DEVERIA*):**
   - O perfil Lilya recomenda formalmente a fixação em versões canônicas exatas (`=`) para garantir reprodutibilidade determinística e previsibilidade total nos builds em cascata controlados pelo Kombinat.
2. **Preservação do Uso Flexível de Aliases:**
   - Nem mesmo no perfil Lilya é imposta trava ou bloqueio de linter contra o consumo de aliases de desenvolvimento (`latest-dev`, `X.Y.Z-dev`).
   - Os aliases existem expressamente para permitir consumo flexível e simplificado durante prototipação, integração local ou testes preliminares.

---

## 3. Plano de Testes (DD-TDD)

- **Fase 4 (Red Test)**: Criar `tests/test_kombinat_orchestration_spec.sh` auditando `profile.md` quanto à presença:
  - Do papel e diretrizes do daemon Kombinat na orquestração contínua.
  - Do monitoramento de registros e compilação em cascata.
  - Da natureza recomendada (sem trava sintática) da fixação de versões canônicas.
  Evidenciar a falha do teste contra o arquivo atual.
- **Fase 5 (Green Implement)**: Atualizar `profile.md` com a nova Seção 5, atualizar `site/profile.md` e registrar em `CHANGELOG.md`.
- **Fase 6 (Refactor)**: Ajustes de formatação e estilo.
- **Fase 7 (Mutation Test)**: Adicionar validações de mutantes sintéticos em `tests/test_kombinat_orchestration_spec.sh`.
- **Fase 8 (Quality Gate)**: Executar todas as suítes de testes (`./tests/audit_profile.sh`, `./tests/test_kombinat_orchestration_spec.sh`) e `cccp check --strict`.
- **Fase 9 (Finish & Close)**: Fechamento com Laudo Textual de Resolução e integração.

---

## 4. Registro de Execução das Fases

- **Fase 3 (Spec)**: Especificação formal versionada.
- **Fase 4 (Red Test)**: Criado `tests/test_kombinat_orchestration_spec.sh` com falha comprovada.
- **Fase 5 (Green Implement)**: Inserida Seção 5 no `profile.md`, sincronizado `site/profile.md` e atualizado `CHANGELOG.md`.
- **Fase 6 (Refactor)**: Asserções de teste modularizadas.
- **Fase 7 (Mutation Test)**: Implementados 3 mutantes sintéticos em `tests/test_kombinat_orchestration_spec.sh` (omissão do Kombinat, remoção de compilação em cascata e alteração da cláusula sem trava). Todos os mutantes foram eliminados com 100% de precisão.
- **Fase 8 (Quality Gate)**: Execução com êxito de todas as suítes de testes (`./tests/audit_profile.sh` e `./tests/test_kombinat_orchestration_spec.sh`) e verificação estrita de conformidade via `cccp check --strict`, alcançando Índice de Conformidade Gosplan de 100% (13/13 verificações aprovadas).

