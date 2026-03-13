---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "CLI que valida cruzadamente 10 SSOTs e gera código. Preenche as fissuras do vibe coding com estrutura."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — CLI que valida cruzadamente 10 SSOTs de uma só vez e gera código.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Repositório no GitHub</a>

## As fissuras do vibe coding

Com a popularização do vibe coding, um padrão surgiu.

Você pede à IA "crie a funcionalidade de reserva" e ela cria. Diz "adicione a funcionalidade de cancelamento" e ela adiciona. Na quinta funcionalidade, a segunda quebra. Você altera o esquema da API, mas esquece o frontend. Adiciona uma coluna no banco de dados, mas a camada de serviço não fica sabendo.

A causa é simples: a IA não consegue lembrar de todo o código.

Então o que as pessoas fazem: quando algo quebra, dizem à IA "corrija isso também". Corrige, e outra coisa quebra. "Corrija aquilo também." O loop se repete. Quanto maior o projeto, mais longo o loop, até que eventualmente "recomeçar do zero seria mais rápido".

## Por que o código cresce tanto?

No código, duas coisas se misturam.

**Decisões**: o que exibir, qual API chamar, em que ordem processar, o que armazenar.
**Fiação**: o código que implementa essas decisões em um framework específico.

Suponha que estamos construindo um sistema de reservas.

```
Decisão: "Ao cancelar uma reserva: verificar permissão → consultar → validar transição de estado → calcular reembolso → alterar status → responder"
```

Essa única decisão se espalha por React hooks, Go handlers, queries SQL, esquemas de API e recursos Terraform. Cada parte é envolta na sintaxe do seu framework, com tratamento de erros e conversão de tipos adicionados.

De 100.000 linhas de código, as decisões são 12.500 linhas. As outras 87.500 linhas são fiação.

Agentes de IA têm uma janela de contexto finita. Ao adicionar a décima funcionalidade, não lembram das nove anteriores. Não conseguem ler 100.000 linhas de uma vez.

Separando apenas as decisões, temos 12.500 linhas — 55% de um contexto de 200K tokens. Um tamanho que a IA consegue ler de uma só vez.

## 10 SSOTs

O Fullend separa todas as decisões do software em 10 especificações declarativas. Cada especificação se torna a fonte única da verdade (SSOT) para a sua área de interesse.

| Área de interesse | SSOT | O que declara |
|---|---|---|
| Configuração do projeto | fullend.yaml | Stack tecnológica, middlewares, caminhos dos módulos |
| Interface | [STML](/pt/dsl/stml/) (HTML5 + data-*) | O que exibir e o que fazer |
| Contrato de API | OpenAPI 3.x | Quais requisições aceitar e quais respostas retornar |
| Fluxo de serviço | [SSaC](/pt/dsl/ssac/) (.ssac DSL) | Em que ordem processar |
| Estrutura de dados | SQL DDL + sqlc | O que armazenar |
| Funções externas | Func Spec (Go) | Interface e implementação de lógica customizada |
| Transições de estado | Mermaid stateDiagram | Quais estados um recurso percorre |
| Política de autorização | OPA Rego | Quem pode fazer o quê |
| Cenários | Gherkin (.feature) | Verificação de fluxos de negócio entre endpoints |
| Infraestrutura | Terraform HCL | Onde executar |

OpenAPI, SQL DDL e Terraform são padrões da indústria. Para as demais áreas de interesse, não existia uma DSL equivalente como SSOT. Os fluxos de serviço ficavam dispersos nos Go handlers, as decisões de UI enterradas nos React hooks, as transições de estado escondidas em ramificações if-else e as permissões hardcoded nos middlewares. Por isso foram projetados STML, SSaC, Func Spec, integração com stateDiagram, integração com OPA e integração com Gherkin. São as DSLs e integrações criadas neste projeto.

```
specs/my-project/
├── fullend.yaml             → Configuração do projeto
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc queries
├── service/**/*.ssac        → SSaC (extensão .ssac)
├── model/*.go               → Go structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` é a verdade. `artifacts/` pode ser regenerado a qualquer momento.

## A validação individual já existe

Ferramentas de validação para diversas camadas já existem.

- O sqlc verifica a consistência entre DDL e queries.
- Validadores de OpenAPI verificam a validade dos esquemas.
- O Terraform verifica a sintaxe e dependências do HCL.

Também foram criados validadores embutidos para STML e SSaC. O SSaC verifica a consistência interna dos fluxos de serviço; o STML verifica o alinhamento entre declarações da interface e o OpenAPI.

Cada SSOT pode ser validado por conta própria. O problema ocorre **entre** eles.

O frontend exibe um campo com `data-bind="memo"`, mas o esquema de resposta da API não contém `memo`. O SSaC chama `@delete Reservation.SoftDelete(request.ReservationID)`, mas as queries do sqlc não têm o método `SoftDelete`. O diagrama de estados define a transição `PublishCourse`, mas não existe função correspondente no SSaC. A política OPA consulta a propriedade do recurso `course` por `courses.instructor_id`, mas a coluna não existe no DDL.

Ferramentas individuais enxergam apenas sua própria camada. As fissuras entre camadas permanecem invisíveis.

## Escondendo a estrutura

"Mas não é preciso aprender 10 DSLs?"

Sim. Mas a estrutura não precisa ser exposta ao usuário.

Se incorporarmos a stack tecnológica e as regras SSOT no prompt de sistema do agente, o usuário só precisa dizer "crie a funcionalidade de reserva". O agente adiciona o endpoint no OpenAPI, cria a tabela no DDL, declara o fluxo de serviço no SSaC, desenha o diagrama de estados, escreve a política OPA, monta a tela no STML e executa `fullend validate` para verificar a consistência.

O usuário vê apenas os resultados. A estrutura é consumida pelo agente, não é algo que o usuário precise aprender.

A experiência do vibe coding permanece a mesma. O que muda é que as coisas param de quebrar por trás.

## O que o Fullend faz

O Fullend é um validador cruzado. Não reinventa ferramentas individuais. Chama cada ferramenta e inspeciona as fronteiras entre os SSOTs.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

Valida cada um dos 10 SSOTs individualmente e depois faz a validação cruzada entre eles. O Func só é validado quando o diretório `func/` existe. Use `--skip` para excluir SSOTs específicos.

```
✓ Config       my-project, go/gin, typescript/react
✓ OpenAPI      7 endpoints
✓ DDL          3 tables, 18 columns
✓ SSaC         7 service functions
✓ Model        3 files
✓ STML         4 pages, 6 bindings
✓ States       1 diagrams, 3 transitions
✓ Policy       1 files, 5 rules, 3 ownership mappings
✓ Scenario     4 features, 5 scenarios
✓ Func         3 funcs
✓ Terraform    2 files
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

Se qualquer verificação falhar:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

Quando a validação passa, o código é gerado. A opção `--skip` funciona da mesma forma que no validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

O sqlc gera modelos do banco de dados, o oapi-codegen gera tipos da API, o SSaC gera handlers gin, o STML gera componentes React, pacotes de máquina de estados e OPA Authorizer são gerados, testes Hurl são gerados a partir do Gherkin, e o Fullend gera o código de cola que conecta tudo.

### gen-model

Gera um arquivo de modelo Go (interface + tipos + cliente HTTP) a partir de um documento OpenAPI externo. Aceita um caminho de arquivo local ou URL.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

Rastreia todos os nós SSOT conectados a uma única operação de API. Recebe um operationId e retorna o mapa completo de arquivo:linha entre camadas.

```bash
fullend chain <operationId> <specs-dir>
```

```
── Feature Chain: AcceptProposal ──

  OpenAPI    api/openapi.yaml:296                          POST /proposals/{id}/accept
  SSaC       service/proposal/accept_proposal.ssac:19      @get @empty @auth @state @put @call @post @response
  DDL        db/gigs.sql:1                                 CREATE TABLE gigs
  DDL        db/proposals.sql:1                            CREATE TABLE proposals
  DDL        db/transactions.sql:1                         CREATE TABLE transactions
  Rego       policy/authz.rego:3                           resource: gig
  StateDiag  states/gig.md:7                               diagram: gig → AcceptProposal
  StateDiag  states/proposal.md:6                          diagram: proposal → AcceptProposal
  FuncSpec   func/billing/hold_escrow.go:8                 @func billing.HoldEscrow
  Gherkin    scenario/gig_lifecycle.feature:4              Scenario: Happy Path - Full Gig Lifecycle
```

### status

Exibe um resumo dos SSOTs detectados e suas estatísticas.

```bash
fullend status <specs-dir>
```

```
SSOT Status:
  OpenAPI      api/openapi.yaml               7 endpoints
  DDL          db                             3 tables, 18 columns
  SSaC         service                        7 functions
  STML         frontend                       4 pages
  States       states                         1 diagrams, 3 transitions
  Policy       policy                         1 files, 5 rules
  Scenario     scenario                       4 features, 5 scenarios
  Func         func                           3 funcs
```

## Funções e modelos embutidos

O Fullend inclui implementações de funções comuns e interfaces de modelos. Podem ser invocados via `@call` no SSaC.

### Funções padrão (pkg/)

| Pacote | Função | Descrição |
|---|---|---|
| `auth` | `hashPassword` | Hash de senha com bcrypt |
| `auth` | `verifyPassword` | Verificação de senha com bcrypt |
| `auth` | `issueToken` | Geração de access token JWT (24h) |
| `auth` | `verifyToken` | Verificação de token JWT + extração de claims |
| `auth` | `refreshToken` | Geração de refresh token (7 dias) |
| `auth` | `generateResetToken` | Token hex aleatório para redefinição de senha |
| `crypto` | `encrypt` | Criptografia simétrica AES-256-GCM |
| `crypto` | `decrypt` | Descriptografia AES-256-GCM |
| `crypto` | `generateOTP` | Segredo TOTP + URL de provisionamento QR |
| `crypto` | `verifyOTP` | Verificação de código TOTP |
| `storage` | `uploadFile` | Upload de arquivo compatível com S3 |
| `storage` | `deleteFile` | Exclusão de arquivo compatível com S3 |
| `storage` | `presignURL` | URL de download pré-assinada do S3 |
| `mail` | `sendEmail` | E-mail em texto simples via SMTP |
| `mail` | `sendTemplateEmail` | E-mail HTML com template Go via SMTP |
| `text` | `generateSlug` | Unicode para slug seguro para URL |
| `text` | `sanitizeHTML` | Sanitização de HTML contra XSS |
| `text` | `truncateText` | Truncamento de texto seguro para Unicode |
| `image` | `ogImage` | Geração de imagem OG (1200x630, PNG) |
| `image` | `thumbnail` | Geração de miniatura (200x200, PNG) |

Projetos podem sobrescrever essas funções fornecendo implementações customizadas em `specs/<project>/func/<pkg>/`.

### Modelos embutidos (pkg/)

Interfaces @model com prefixo de pacote para I/O não relacional. Configurados via `fullend.yaml`.

| Pacote | Interface | Backends | Uso no SSaC |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (gerado)

O Fullend gera o arquivo `internal/middleware/bearerauth.go` específico do projeto a partir da configuração de claims em `fullend.yaml`.

| Middleware | Gatilho | Descrição |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | Extrai JWT e define `*model.CurrentUser` no contexto do gin |

O agrupamento de rotas é determinado pelo campo `security` do OpenAPI. Operações com `security: [{bearerAuth: []}]` vão para o grupo autenticado; operações sem vão para o grupo público.

## Regras de validação cruzada

O valor único do Fullend está na validação cruzada. Após cada ferramenta individual validar sua própria camada, o Fullend detecta inconsistências entre os SSOTs.

**fullend.yaml ↔ OpenAPI**

| Alvo | Regra |
|---|---|
| Nome do middleware | Corresponde a uma chave de securitySchemes? |

**OpenAPI ↔ DDL**

| Alvo | Regra |
|---|---|
| x-sort.allowed | A coluna existe na tabela? |
| x-sort ↔ DDL index | A coluna possui índice? (WARNING) |
| x-filter.allowed | A coluna existe na tabela? |
| x-include.allowed | É uma tabela conectada por FK? |

**SSaC ↔ DDL**

| Alvo | Regra |
|---|---|
| Model.Method | O método existe nas queries do sqlc? |
| @result Type | Corresponde ao tipo derivado da tabela DDL? |
| Campos dos argumentos | Podem ser mapeados para colunas DDL? |

**SSaC ↔ OpenAPI**

| Alvo | Regra |
|---|---|
| Nome da função | Corresponde a um operationId? |
| Argumentos request | O campo existe no esquema da requisição? |
| Campos @response | O campo existe no esquema da resposta? |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**

| Alvo | Regra |
|---|---|
| Evento de transição | Corresponde ao nome de uma função SSaC? |
| Evento de transição | Corresponde a um operationId do OpenAPI? |
| SSaC @state | O stateDiagram referenciado existe? |
| Campo @state | Existe como coluna DDL? |

**Policy ↔ SSaC ↔ DDL ↔ States**

| Alvo | Regra |
|---|---|
| allow (action, resource) | Corresponde ao @auth do SSaC? |
| @ownership table.column | Existe no DDL? |
| @ownership via join | A FK da tabela de junção existe no DDL? |
| Evento de transição de estado | Existe uma regra Rego correspondente para transições com @auth? |

**Func ↔ SSaC**

| Alvo | Regra |
|---|---|
| Referência @call | Existe implementação Func correspondente? |
| Quantidade de argumentos | Os argumentos de @call correspondem à quantidade de campos Request? |
| Tipos dos argumentos | Os tipos posicionais correspondem via DDL/OpenAPI? |
| Result/response | Result/response são consistentes? |
| Corpo da função | Não é um stub TODO? (WARNING) |

**Scenario ↔ OpenAPI ↔ States**

| Alvo | Regra |
|---|---|
| operationId | Existe no OpenAPI? |
| Método HTTP | Corresponde ao método do OpenAPI? |
| Campos JSON | Existem no esquema da requisição? |
| Ordem dos passos | Segue as regras de transição de estado? |

**Queue (Pub/Sub)**

| Alvo | Regra |
|---|---|
| @publish topic | Existe uma função @subscribe correspondente? |
| Campos payload/message | São consistentes? |
| Configuração de queue | O fullend.yaml possui configuração de queue? |

**STML ↔ SSaC** — Ambos referenciam o mesmo operationId do OpenAPI. Se a validação de ambos passa, a consistência entre a API chamada pelo frontend e a API processada pelo backend é automaticamente garantida.

## Testes em tempo de execução

O `fullend gen` gera testes [Hurl](https://hurl.dev) a partir de specs OpenAPI e cenários Gherkin.

```bash
# Após iniciar o servidor:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

Testes gerados:

- **smoke.hurl** — Testes de fumaça dos endpoints OpenAPI (gerados automaticamente)
- **scenario-*.hurl** — Testes de cenários de negócio (gerados a partir de arquivos .feature)
- **invariant-*.hurl** — Testes de invariantes entre endpoints (gerados a partir de arquivos .feature)

## Projetado para agentes

O Fullend foi projetado para agentes de IA.

Para que o agente escreva specs, ele precisa conhecer os 10 tipos de sequência do SSaC, os atributos data-* do STML, as extensões x- do OpenAPI, as regras de stateDiagram, os padrões de política OPA, a sintaxe de cenários Gherkin, as regras de Func Spec e as regras de correspondência de nomes. Para isso, é fornecido um manual para IA com aproximadamente 830 linhas. Basta adicioná-lo uma vez ao prompt de sistema do agente.

O loop de validação após a escrita das specs é direto.

```
Fluxo de trabalho do agente:
1. Modificar specs/
2. fullend validate specs/my-project
3. Se houver erros → corrigir o SSOT correspondente → voltar ao 2
4. Zero erros → fullend gen specs/my-project artifacts/my-project
```

Não é preciso entender o sistema inteiro. Basta corrigir o que o validate aponta e a consistência é restaurada. Um modelo inteligente acerta de primeira; um modelo menor acerta na terceira tentativa. O resultado é o mesmo.

## Tamanho do SSOT por escala

| Escala | Exemplo | SSOT | Código de implementação | Uso do contexto |
|---|---|---|---|---|
| Pequeno | Agendamento de salão | ~1.500 linhas | ~10K linhas | ~8% |
| Médio | Nível Jira/Notion | ~12.500 linhas | ~100K linhas | ~55% |
| Grande | Nível Shopify | ~30.000 linhas | ~300K linhas | ~90% |

Com base em um contexto de 200K tokens. Até um SaaS de médio porte, o agente consegue ler todo o design de uma só vez.

## Transformando exceções em padrões

O que os 10 tipos de sequência não conseguem lidar vai para `@call`. O que os atributos data-* não conseguem lidar vai para `custom.ts`. Se essas válvulas de escape ultrapassarem 20% do total, a estruturação perde seu sentido.

Porém, as exceções se tornam observáveis no momento em que são isoladas. Conforme mais projetos adotam o Fullend, padrões recorrentes aparecerão em `@call` e `custom.ts`.

Os 10 tipos de sequência do SSaC não foram projetados do zero. Convergiram para 10 após a observação de centenas de códigos de serviço. Espera-se que o mesmo princípio se repita nas válvulas de escape. Padrões frequentes de `@call` se tornam novos tipos de sequência; padrões frequentes de `custom.ts` se tornam novos atributos data-*.

As exceções não diminuem — a estrutura cresce a partir delas.

## Expansão da stack tecnológica

Atualmente, o Fullend é fixo em Go(gin) + React + PostgreSQL + Terraform. Isso é intencional. Na fase de PoC, a prioridade é penetrar uma stack por completo.

Porém, muitos dos 10 SSOTs (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) já são independentes de linguagem. Os 10 tipos de sequência do SSaC são padrões agnósticos de linguagem — são apenas expressos como comentários Go. O STML usa atributos HTML5 data-* e é independente de framework.

A expansão é uma questão de adicionar backends de geração de código. A lógica de validação e as regras de validação cruzada permanecem inalteradas.

## Relação com GEUL

Os 10 SSOTs compõem todas as decisões do software. Um SSOT é dado estruturado. Dado estruturado é um grafo. Um grafo pode ser codificado em GEUL.

O `data-fetch="ListReservations"` do STML é uma relação entre entidades. O `@get → @empty → @state → @call → @put → @response` do SSaC é uma sequência de eventos. As transições do stateDiagram são grafos de estados. As políticas OPA são relações de autorização. As definições de endpoint do OpenAPI são contratos. Todas são estruturas semânticas que podem ser expressas com triple edges, event6 edges e entity nodes do GEUL.

A forma como o Fullend realiza a validação cruzada entre 10 SSOTs — correspondência simbólica, verificação de consistência de tipos, verificação de integridade referencial — opera com o mesmo princípio da verificação mecânica em streams GEUL.

## Licença

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Repositório no GitHub</a>
