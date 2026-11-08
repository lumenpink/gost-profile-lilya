# Especificação Técnica — Ticket #15
## Reforço do Mandato de Conteinerização Universal e Topologia de Redes (Lilya v2.1.0)

### 1. Escopo e Propósito
Formalizar no perfil operacional Lilya a garantia estrita de execução de stacks conteinerizadas em `obizero`, `obione` e `obitwo`:
1. **Banimento Absoluto de Daemons no Host:** Nenhum binário de serviço pode ser mantido ou iniciado diretamente no sistema operacional dos hosts. Todo serviço deve residir em `~/stacks/<slug>/compose.yaml`.
2. **Topologia de Segurança e Ingress:**
   - Apenas o **Gossnab** possui porta pública exposta à internet para ingestão de webhooks multi-forja e consultas públicas da Banca.
   - O **Kombinat** opera isolado na rede privada local, atuando exclusivamente como cliente unidirecional (puxa tarefas, assina, despacha artefatos e orquestra deploys).
