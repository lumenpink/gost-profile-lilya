# Especificação: Transição para git.2lp.in como Forja Canônica e Push Mirrors Duplos

- **ID do Ticket:** #6
- **Status:** Aprovado
- **Autor:** Lumen
- **Alinhamento:** GOST 1.5.0 (Perfil Lumen)

## 1. Contexto & Motivação
A infraestrutura canônica do ecossistema evoluiu com a disponibilização da instância própria Forgejo v17 em `https://git.2lp.in`, hospedada localmente no nó `obizero` / `baquara` e com acesso SSH nativo na porta 22 padrão.

Para garantir imunidade a instabilidades externas e manter ao mesmo tempo visibilidade e redundância pública internacional, a especificação normativa do Perfil Lumen deve ser atualizada para consagrar o modelo de **Forja Canônica Upstream com Espelhamento Duplo Automático (Push Mirrors)**.

## 2. Requisitos Normativos
1. **Identificação da Forja Primária:**
   - **Instância Canônica:** `https://git.2lp.in`
   - **Remote Git SSH:** `git@git.2lp.in:lumen/<repo>.git` (Porta 22 padrão via SSH shim do host).
   - O `origin` local do desenvolvedor aponta exclusivamente para `git.2lp.in`.
2. **Duplo Espelhamento Automático (Vitrine Aberta):**
   - Todo repositório público hospedado no `git.2lp.in` DEVE possuir dois *Push Mirrors* automáticos (`sync_on_commit: true`):
     - **Espelho FOSS:** Codeberg (`https://codeberg.org/lumenpink/<repo>`)
     - **Espelho Comunitário:** GitHub (`https://github.com/lumenpink/<repo>`)
   - O desenvolvedor faz push apenas para o upstream local; o Forgejo propaga as alterações para ambos os espelhos.
3. **Veto a Binários no Git:**
   - O veto absoluto a binários pesados e releases com artefatos compilados no Git é mantido e estendido para todas as forjas (Forgejo, Codeberg, GitHub). Binários são distribuídos estritamente via **Banca** (`https://banca.2lp.in/downloads/`).
4. **Reconciliação em Lote:**
   - O arquivo compilado `.gost/GOST.md` de todos os repositórios do ecossistema deve ser remontado via `cccp profile assemble --all` para refletir as novas diretrizes.
