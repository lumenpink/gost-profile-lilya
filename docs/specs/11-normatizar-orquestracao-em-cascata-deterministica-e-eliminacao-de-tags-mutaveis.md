# Especificação Técnica: Orquestração em Cascata Determinística, Contrato FFI/C-ABI e Eliminação de Tags Mutáveis

**Ticket:** #11  
**Fase:** Fase 3 (Spec / Documentação Normativa)  
**Status:** Em Elaboração  
**Autor:** Lumen Pink / Antigravity  

---

## 1. Contexto e Motivação Sistêmica

Em ecossistemas modulares compostos por dezenas de crates, motores estáticos e aplicações de ponta (como a malha `joaju-* ➔ joaju ➔ mandu / joaju-web`), surgem fragilidades estruturais quando não há governança estrita de propagação:
1. **Fragilidade de Tags Mutáveis (`:latest`):** A utilização de tags mutáveis em contêineres e pacotes compromete a reprodutibilidade determinística. Dois builds no mesmo commit podem gerar comportamentos divergentes.
2. **Fratura de Rastreabilidade FFI (C-ABI Oculta):** Quando bibliotecas estáticas (`.a`) são embutidas em binários finais sem exportação canônica de símbolos de versão, torna-se impossível determinar em tempo de execução quais subcomponentes estão linkados no binário distribuído.
3. **Assincronia Manual de Dependências:** O atraso manual na atualização de dependências downstream após um release upstream fragmenta o ecossistema.

---

## 2. Requisitos Normativos

### 2.1 Eliminação Estrita de Tags Mutáveis no Build Determinístico
- **Proibição de `:latest` em Pipelines:** É estritamente proibido o consumo ou referência a tags flutuantes como `:latest` em scripts de build, dependências de compilação ou imagens de base para tarefas determinísticas de CI/CD.
- **Fixação Canônica:** Toda dependência de imagem ou pacote em esteiras de compilação e deploy determinístico deve referenciar uma tag SemVer imutável (`x.y.z` ou `x.y.z-dev.{n}+{YYYYMMDD}.{commit}`).
- **Exceção Limitada de Vitrine:** Aliases de conveniência (`*-latest.*`) são mantidos exclusivamente como links de consumo e vitrine externa na Banca / R2 para facilidade de download humano, nunca como âncora de build interno.

### 2.2 Contrato Universal de FFI / C-ABI de Versão
- **Constante SemVer Canônica:** Toda crate Rust do ecossistema deve exportar em seu arquivo raiz (`src/lib.rs`):
  ```rust
  pub const VERSION: &str = env!("CARGO_PKG_VERSION");
  ```
- **Símbolo FFI Exportado para Staticlibs:** Para qualquer componente compilado com `crate-type = ["staticlib"]` (ex.: bindings C/C++ ou FFI consumidos por outras linguagens), é obrigatória a exportação de um símbolo com visibilidade externa e convenção C:
  ```rust
  #[no_mangle]
  pub extern "C" fn <crate_name>_version() -> *const std::os::raw::c_char;
  ```

### 2.3 Inspeção Canônica de Ecossistema no CLI
- Binários de ponta com interface de linha de comando devem fornecer inspeção granular:
  - `<bin> --version`: emite a versão canônica do binário principal.
  - `<bin> --version --all`: emite a árvore completa de submódulos e bibliotecas estáticas C-ABI embutidas com suas respectivas versões compiladas.
  - `<bin> --version --json`: emite o diagnóstico estruturado em JSON legível por máquina para auditoria automatizada do Kombinat.

### 2.4 Orquestração em Cascata Contínua (Kombinat)
- O daemon Kombinat media a propagação automatizada de dependências no Grafo Acíclico Dirigido (DAG).
- Ao detectar um release upstream, o Kombinat orquestra um ciclo DD-TDD completo no repositório downstream (Ticket ➔ Branch ➔ Bump ➔ Test ➔ Quality Gate ➔ Merge).

---

## 3. Árvore de Decisões Arquiteturais (para a Natasha)

1. **Por que banir `:latest` dentro de scripts de build determinístico?**
   - *Decisão:* Builds reproduzíveis exigem garantia matemática de que um commit no passado compilará exatamente os mesmos bytes hoje. O uso de `:latest` destrói o determinismo ao injetar artefatos mutáveis sem histórico no Git.
2. **Por que padronizar o símbolo FFI `<crate>_version()`?**
   - *Decisão:* Sem um símbolo exportado na C-ABI, bibliotecas estáticas `.a` embutidas tornam-se "caixas-pretas" no binário final. Um executável compilado pode conter vulnerabilidades ou bugs de versões antigas sem que nenhuma ferramenta de introspecção consiga verificar.
3. **Por que suportar `--version --all` e `--json`?**
   - *Decisão:* Permite ao Kombinat e a auditores automatizados inspecionar todo o grafo empacotado no binário sem precisar de símbolos de depuração ou engenharia reversa.

---

## 4. Plano de Testes (Fase 4 & Fase 7)
- Script de teste: `tests/test_cascade_deterministic_spec.sh`.
- Asserções no `profile.md`:
  - Diretiva de eliminação de tags `:latest` em builds determinísticos.
  - Contrato FFI/C-ABI de versão (`pub const VERSION` e `<crate>_version()`).
  - Inspeção canônica CLI (`--version --all` e `--json`).
- Mutantes:
  - Omissão de cláusula anti-latest.
  - Omissão do contrato FFI.
  - Omissão da inspeção `--version --all`.
