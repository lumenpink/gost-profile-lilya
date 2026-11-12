# Especificação Técnica — Ticket #24: Alinhar Chamadas Operacionais Concretas no Perfil Lilya

## 1. Contexto & Motivação
O perfil Lilya é o nível operacional e concreto da Fábrica Tulipa sob o ecossistema GOST. Conforme a regra de hierarquia normativa, nomes específicos de ferramentas, daemons e serviços concretos pertencem unicamente a este nível, onde os contratos genéricos de engenharia definidos no nível tático (Kollontai) são materializados em binários reais.

## 2. Decisão Arquitetural
- **Formalização da Seção 1 (Amarração Operacional de Binários Concretos):**
  - Mapeia o papel de *Maestro Local* ao binário concreto **`cccp`** (`git.2lp.in/lumen/cccp`, `cccp.2lp.in`).
  - Mapeia o papel de *Autoridade de Forja e Abastecimento* ao binário/daemon **`gossnab`** (`git.2lp.in/lumen/gossnab`, API `gossnab.2lp.in/api/v1`).
  - Mapeia o papel de *Motor de Avaliação Normativa* ao binário **`lunokhod`** (`lk`) (`git.2lp.in/lumen/lunokhod`, `lunokhod.2lp.in`).
- **Mapeamento de Comandos Concretos da Fábrica Tulipa:**
  - Ciclo Local: `cccp start`, `cccp commit`, `cccp mutate`, `cccp hygiene`, `cccp close`, `cccp merge`, `cccp push`, `cccp release`.
  - Forjas/Abastecimento: `gossnab ticket <create|list|comment|close|sync>`, `gossnab divan`, `gossnab new`, `gossnab catalog scan/list`, `gossnab batch push`.
  - Auditoria: `lunokhod check --strict --lang pt-br [--scope <scope>] [--json]`, `lunokhod test`, `lunokhod eval`.

## 3. Alternativas Descartadas (Para a Natasha)
- **Alternativa Descartada 1: Espalhar nomes de ferramentas pelas camadas estratégicas ou táticas.**
  *Motivo do Descarte:* Vola o princípio de separação de responsabilidades e impede que outras organizações adotem a norma sem os binários da Tulipa.
- **Alternativa Descartada 2: Manter `cccp` assumindo forjas e lua sem citar `gossnab` e `lunokhod`.**
  *Motivo do Descarte:* Desatualizaria a documentação operacional frente aos tickets #168, #169 e #170 que alijaram essas tarefas do `cccp`.

## 4. Verificação
- Verificação da integridade das seções numeradas (1 a 10) em `profile.md`.
- Checagem dos endpoints canônicos de infraestrutura Tulipa.
