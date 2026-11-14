# Especificação Técnica — Ticket #26: Publicar Artefato UPGRADE.md da Versão 2.1.0

- **Ticket:** [#26](https://gambi.2lp.in/lumen/gost-profile-lilya/issues/26)
- **Branch:** `docs/26-publicar-artefato-upgrade-md-da-versao-2-1-0`
- **Autoridade Normativa:** GOST v3.0.0 (`tier: fundamental`, Seção 2.2)

---

## 1. Contexto & Motivação

O Princípio do Encadeamento Linear de Migração (GOST v3.0.0, Seção 2.2) estabelece que toda versão imutável de norma ou perfil deve expor o artefato canônico `UPGRADE.md` em sua raiz pública versionada (`{base_url}/{version}/UPGRADE.md`).

O perfil operacional Lilya encontra-se na versão `2.1.0` (estendendo Kollontai e subordinado à Metanorma GOST v3.0.0). Para viabilizar a transição segura dos repositórios regulados a partir da versão `2.0.0`, faz-se imperativo publicar `site/2.1.0/UPGRADE.md` detalhando as quebras contratuais e mutações de regras.

---

## 2. Decisão Arquitetural

### 2.1 Frontmatter Canônico do UPGRADE.md
O arquivo `site/2.1.0/UPGRADE.md` deve conter Frontmatter YAML em conformidade com o padrão GOST v3.0.0:

```yaml
---
standard: "lilya"
tier: "operational"
version: "2.1.0"
replaces: "2.0.0"
valid_since: "2.0.0"
breaking: true
---
```

### 2.2 Estrutura do Delta de Migração (2.0.0 ➔ 2.1.0)
O corpo do artefato estrutura-se nas quatro seções normatizadas:
1. **Quebras de Contrato (*Breaking Changes*):**
   - Purga de manifestos estáticos locais (`catalog.json` e `kombinat.toml`).
   - Obrigatoriedade de extensão `.yaml` para compose (banimento de `.yml`).
   - Obrigatoriedade do manifesto `.gost/metadata.json` com `schema_version`.
   - Requisitos de conformidade post-build (`--help` e `--version`).
2. **Mutação de Regras Declarativas:**
   - Adicionadas: `LILYA-005`, `LILYA-006`, `LILYA-007`, `LILYA-008`, `LILYA-009`.
   - Modificadas: `LILYA-002` (afirmação transfeminista), `LILYA-003` (forja canônica `gambi.2lp.in`).
3. **Ações Manuais Necessárias:**
   - Exclusão de manifestos estáticos residuais.
   - Renomeação de arquivos de orquestração.
   - Ajuste do arquivo `.cccprc`.
4. **Ações Automatizáveis via Ferramenta:**
   - Montagem de regras via `cccp profile assemble`.

### 2.3 Postura Fail-Fast Estrita
Em conformidade com as diretrizes de governança, rejeita-se qualquer camada de retrocompatibilidade em `site/` (como `site/profile.md` ou `site/rules.toml`). Toda requisição a endpoints legados deve falhar com `404 Not Found`, forçando os repositórios regulados a adotar as rotas versionadas canônicas (`site/2.1.0/RULES.md`, `RULES.toml`, `UPGRADE.md`).

---

## 3. Árvore de Decisões e Alternativas Descartadas (Para a Natasha)

- **Alternativa Descartada 1: Manter rotas desversionadas de retrocompatibilidade (`site/profile.md`).**
  - *Motivo do Descarte:* Fere o princípio fail-fast. Cria duplicidade de fontes da verdade e atrasa a detecção de dívida técnica nos repositórios clientes.
- **Alternativa Descartada 2: Omitir o campo `valid_since`.**
  - *Motivo do Descarte:* Faria repositórios legados tentarem buscas na rede de versões que nunca foram geradas, falhando com timeouts ou erros de CDN.
- **Alternativa Descartada 3: Documentar o delta de forma genérica em prosa.**
  - *Motivo do Descarte:* Impede a extração automatizada de instruções pelo Maestro local e dificulta o checklist de migração da desenvolvedora.

---

## 4. Critérios de Aceite e Matriz de Testes (Fase 4 - Red Test)

1. `test_upgrade_file_existence`:
   - Verifica se `site/2.1.0/UPGRADE.md` existe e é não-vazio.
2. `test_upgrade_frontmatter_schema`:
   - Valida `standard: "lilya"`, `tier: "operational"`, `version: "2.1.0"`, `replaces: "2.0.0"`, `valid_since: "2.0.0"` e `breaking: true`.
3. `test_upgrade_sections_structure`:
   - Valida a presença das quatro seções normatizadas (Quebras de Contrato, Mutação de Regras, Ações Manuais e Ações Automatizáveis).

---

## 5. Resultados de Validação (Quality Gate)
- **Suíte Normativa:** Todas as 7 suítes de teste em `tests/*.sh` executadas com 100% de sucesso.
- **Cobertura de Mutações:** 4 mutantes eliminados em `test_upgrade_md_spec.sh` e 5 mutantes eliminados em `test_versions_catalog_spec.sh`.
- **Artefato Canônico:** `site/2.1.0/UPGRADE.md` publicado e auditado contra o contrato GOST v3.0.0.
