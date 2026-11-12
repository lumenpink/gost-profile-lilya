# Especificação Técnica — Ticket #4: Continuous Deployment Canônico de Containers & Descomissionamento do Watchtower

**Norma de Referência:** GOST 1.5.0  
**Perfil:** Lilya (`https://lilya.2lp.in/profile.md`)  
**Data:** 2026-10-20  
**Status:** Aprovado / Em Implementação  

---

## 1. Contexto & Motivação

Historicamente, a atualização de containers em ambientes autohospedados recorria ao **Watchtower**, disparado via polling cronometrado ou webhooks cegos (`WATCHTOWER_WEBHOOK_URL`). Esse modelo revelou fragilidades operacionais críticas:
1. **Caixa-Preta & Ausência de Feedback:** O workflow de CI terminava com sucesso após o webhook, sem reportar se o container subiu corretamente, se a imagem foi puxada ou se quebrou em *CrashLoopBackOff*.
2. **Inexistência de Rollback Automático:** Caso a imagem atualizada falhasse no boot, o serviço permanecia inoperante até intervenção manual.
3. **Tráfego Redundante e Latência:** O nó central de compilação (`obizero`), que executa o `forgejo-runner` com o socket do Docker montado, enviava a imagem para o Docker Hub pela internet apenas para o Watchtower baixá-la novamente para a mesma máquina.
4. **Vulnerabilidade de Portas Administrativas:** Exposição de endpoints HTTP para webhooks de atualização nos nós.

---

## 2. Diretrizes Normativas de Continuous Deployment (CD)

### 2.1 Descomissionamento Compulsório do Watchtower
1. É **expressamente vedado** o uso do Watchtower ou de agentes opacos de auto-atualização sem feedback de integridade.
2. Todos os serviços nos arquivos Docker Compose **DEVEM** remover a label `com.centurylinklabs.watchtower.enable`.
3. Os workflows de CI/CD **NÃO DEVEM** conter etapas de disparo de webhook do Watchtower.

---

### 2.2 Tipologia de Alvos de Deploy

#### 1. Nó Central de Execução (`obizero` / Deploy Local Imediato)
- Como o `forgejo-runner` opera no próprio nó `obizero` com o socket Docker montado (`docker_host: "automount"`):
- O build da imagem (`docker build`) registra as novas camadas diretamente no Docker daemon local do host (`lumenpink/<app>:latest` e `:<version>`).
- O deploy ocorre **sem qualquer download da internet** através de recriação do container:
  ```bash
  docker compose -f /home/lumen/stacks/<app>/compose.yml up -d --no-build <app>
  ```
- **Validação de Integridade (Healthcheck Ativo):**
  A esteira de CI DEVE sondar ativamente o status de saúde por até 15 segundos:
  ```bash
  for i in $(seq 1 15); do
    STATUS=$(docker inspect --format='{{.State.Health.Status}}' <app> 2>/dev/null || echo "running")
    if [ "$STATUS" = "healthy" ] || [ "$STATUS" = "running" ]; then
      echo "✅ Container <app> operacional em produção!"
      break
    fi
    sleep 1
  done
  ```
- **Protocolo de Rollback em Falha:**
  Caso o container não atinja estado saudável no prazo estipulado:
  1. A esteira emite os últimos logs de erro (`docker logs --tail 50 <app>`);
  2. Executa a restauração da versão anterior;
  3. Aborta o workflow com falha visível no painel da CI.
- **Higienização de Armazenamento:**
  Após o reload com sucesso, o runner executa `docker image prune -f` para descartar camadas antigas sem tag.

#### 2. Nós de Borda Remotos (`obione` e `obitwo` / Deploy via Tailscale)
- Para aplicações hospedadas em nós de borda (como `tatupeba` e `fuxico` no `obitwo`, ou `dns` e `infra` no `obione`):
- O runner realiza o push da imagem com tag versionada para o registry público (`lumenpink/<app>:latest`).
- O job de CD aciona a atualização remota via SSH pela malha segura da VPN Tailscale:
  ```bash
  ssh -o StrictHostKeyChecking=accept-new lumen@<no-tailscale> \
    "docker compose -f ~/stacks/<app>/compose.yml pull && \
     docker compose -f ~/stacks/<app>/compose.yml up -d && \
     docker image prune -f"
  ```
- O job só termina com sucesso após o comando SSH retornar código de saída `0`.

---

### 2.3 Contrato de Probes de Saúde (Healthchecks)

Todo serviço publicado como container no ecossistema Lumen DEVE declarar parâmetros de saúde:
- No `Dockerfile`: diretiva `HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -f http://localhost:<port>/health || exit 1`
- Ou no `compose.yml`:
  ```yaml
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost:<port>/health || exit 1"]
    interval: 30s
    timeout: 3s
    retries: 3
    start_period: 10s
  ```
