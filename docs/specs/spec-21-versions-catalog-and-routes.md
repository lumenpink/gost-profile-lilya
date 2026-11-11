# Especificação do Ticket #21: Catálogo versions.json e Rotas Versionadas da Norma Lilya

**Ticket:** #21  
**Fase:** Fase 3 (Spec)  
**Status:** Em Elaboração  
**Autor:** Lumen Pink / Antigravity  

---

## 1. Contexto e Motivação

Para desacoplar as ferramentas operacionais de governança (como o Maestro `cccp`) dos perfis e normas técnicas concretos, estabelece-se a arquitetura universal baseada em `.rules/`. Nesse modelo, qualquer repositório pode consumir uma norma apontando exclusivamente para sua URL canônica base (ex.: `https://lilya.2lp.in`), cabendo ao servidor da norma expor:
1. Um catálogo estático de versões (`versions.json`) na raiz do domínio.
2. Endpoints versionados determinísticos contendo a norma (`RULES.md`) e suas regras declarativas (`RULES.toml`).

---

## 2. Requisitos Técnicos

### 2.1 Catálogo Estático `site/versions.json`
O arquivo `site/versions.json` deve ser servido na rota raiz (`https://lilya.2lp.in/versions.json`) com a estrutura:
```json
{
  "standard": "lilya",
  "tier": "operational",
  "latest": "2.1.0",
  "versions": [
    "2.1.0"
  ]
}
```

### 2.2 Rotas e Arquivos Canônicos da Norma
1. **Padrão Agnóstico Moderno:**
   - Raiz: `site/RULES.md` (idêntico a `profile.md`) e `site/RULES.toml` (idêntico a `rules.toml`).
   - Versionado: `site/2.1.0/RULES.md` e `site/2.1.0/RULES.toml`.
2. **Preservação Retrocompatível:**
   - Manter `site/profile.md` e `site/rules.toml` para que ferramentas em transição continuem funcionando sem atrito.
   - Disponibilizar também `site/2.1.0/profile.md` e `site/2.1.0/rules.toml`.

---

## 3. Árvore de Decisões Arquiteturais (para a Natasha)

1. **Por que expor catálogo JSON estático em vez de API dinâmica?**
   - *Decisão:* O site do perfil é servido como assets estáticos em Cloudflare Workers via Wrangler (`site/`). Um arquivo JSON estático tem disponibilidade de 100%, latência mínima de borda e elimina necessidade de backend ou banco de dados para descoberta de versões.
2. **Por que criar o subdiretório `site/2.1.0/`?**
   - *Decisão:* Permite que clientes façam download determinístico e imutável de `https://lilya.2lp.in/2.1.0/RULES.md` e `RULES.toml`. Mesmo quando a norma avançar para 2.2.0 ou 3.0.0, repositórios fixados na 2.1.0 continuarão reproduzindo exatamente as mesmas regras.
3. **Por que duplicar em `RULES.{md,toml}` e `profile.md / rules.toml`?**
   - *Decisão:* Transição suave. Evita que ferramentas antigas quebrem durante a migração do ecossistema.

---

## 4. Plano de Validação
- **Fase 4 (Red Test):** Script `tests/test_versions_catalog_spec.sh` atestando presença e validade de `site/versions.json`, rotas `RULES.md`, `RULES.toml` e subdiretório `site/2.1.0/`.
- **Fase 5 (Green Implement):** Criação dos arquivos e links em `site/`.
- **Fase 7 (Mutation Test):** Mutação na chave `latest` e na rota versionada.
- **Fase 8 (Quality Gate):** Execução de toda a suíte de conformidade de perfil.
