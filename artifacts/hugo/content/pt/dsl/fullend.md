---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "CLI que valida a consistência cruzada de 10 SSOTs e gera código. Preenche as fissuras do vibe coding com estrutura."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — CLI que valida a consistência de 10 SSOTs de uma só vez e gera código.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Repositório no GitHub</a>

## As fissuras do vibe coding

Com a popularização do vibe coding, padrões começaram a surgir.

Você diz à IA "crie a funcionalidade de reserva" e ela cria. Diz "adicione a funcionalidade de cancelamento" e ela adiciona. Ao adicionar a quinta funcionalidade, a segunda quebra. Você altera o esquema da API, mas o frontend não é atualizado. Adiciona uma coluna no banco de dados, mas a camada de serviço não fica sabendo.

A causa é simples: a IA não consegue lembrar de todo o código.

Então o que as pessoas fazem: descobrem a parte quebrada e dizem à IA "corrija isso também". Corrige, mas outra parte quebra. "Corrija aquilo também." Esse loop se repete. Quanto maior o projeto, mais longo o loop, até que em algum momento "recomeçar do zero seria mais rápido".

## Por que o código cresce?

No código, duas coisas se misturam:

**Decisões**: o que exibir, qual API chamar, em que ordem processar, o que armazenar.
**Fiação**: o código que implementa essas decisões em um framework específico.

Suponha que estamos construindo um sistema de reservas.

```
Decisão: "Ao cancelar uma reserva, verificar permissão → consultar → validar transição de estado → calcular reembolso → alterar estado → responder"
```

Essa única linha de decisão se espalha por React hooks, Go handlers, queries SQL, esquemas de API e recursos Terraform. Cada parte é envolta na sintaxe do seu framework, com tratamento de erros e conversão de tipos adicionados.

De 100.000 linhas de código, as decisões são 12.500 linhas. As outras 87.500 linhas são fiação.

Agentes de IA têm uma janela de contexto finita. Ao adicionar a décima funcionalidade, não lembram das nove anteriores, porque não conseguem ler 100.000 linhas de uma vez.

Se separarmos apenas as decisões, são 12.500 linhas — 55% de um contexto de 200K tokens. Um tamanho que a IA consegue ler de uma vez.

## 10 SSOTs

O Fullend separa todas as decisões do software em 10 especificações declarativas. Cada especificação se torna a fonte única da verdade (SSOT) para a sua área de interesse.

| Área de interesse | SSOT | O que declara |
|---|---|---|
| Configuração do projeto | fullend.yaml | Stack tecnológica, middlewares, caminhos dos módulos |
| Interface | [STML](/pt/dsl/stml/) (HTML5 + data-*) | O que exibir e o que fazer |
| Contrato API | OpenAPI 3.x | Quais requisições aceitar e quais respostas retornar |
| Fluxo de serviço | [SSaC](/pt/dsl/ssac/) (Go comment DSL) | Em que ordem processar |
| Estrutura de dados | SQL DDL + sqlc | O que armazenar |
| Funções externas | Func Spec (Go) | Interface e implementação de lógica customizada |
| Transição de estado | Mermaid stateDiagram | Quais estados um recurso percorre |
| Política de permissão | OPA Rego | Quem pode fazer o quê |
| Cenários | Gherkin (.feature) | Validação de fluxos de negócio entre endpoints |
| Infraestrutura | Terraform HCL | Onde executar |

OpenAPI, SQL DDL e Terraform são padrões da indústria. Para as demais áreas de interesse, não existia uma DSL equivalente como SSOT. Os fluxos de serviço ficavam dispersos nos Go handlers, as decisões de frontend enterradas nos React hooks, as transições de estado escondidas em ramificações if-else e as permissões hardcoded em middlewares. Por isso projetamos STML, SSaC, Func Spec, integração com stateDiagram, integração com OPA e integração com Gherkin. São as DSLs e integrações criadas por este projeto.

```
specs/my-project/
├── fullend.yaml           → Configuração do projeto
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
├── func/<pkg>/*.go        → Func Spec
├── states/*.md            → Mermaid stateDiagram
├── policy/*.rego          → OPA Rego
├── scenario/*.feature     → Gherkin
└── terraform/*.tf         → HCL
```

`specs/` é a verdade. `artifacts/` pode ser regenerado a qualquer momento.

## A validação individual já existe

Ferramentas de validação para diversas camadas já existem:

- O sqlc verifica a consistência entre DDL e queries.
- Validadores de OpenAPI verificam a validade dos esquemas.
- O Terraform verifica a sintaxe e dependências do HCL.

Também criamos validadores embutidos para STML e SSaC. O SSaC verifica a consistência interna dos fluxos de serviço, e o STML verifica a correspondência entre declarações da interface e o OpenAPI.

Cada SSOT pode se validar internamente. O problema ocorre **entre** eles.

O frontend exibe um campo com `data-bind="memo"`, mas o esquema de resposta da API não contém `memo`. O SSaC chama `@delete Reservation.SoftDelete(request.ReservationID)`, mas as queries do sqlc não têm o método `SoftDelete`. O diagrama de estados define a transição `PublishCourse`, mas não existe função correspondente no SSaC. A política OPA consulta a propriedade do recurso `course` por `courses.instructor_id`, mas a coluna não existe no DDL.

Ferramentas individuais enxergam apenas sua camada. As fissuras entre camadas permanecem invisíveis.

## Escondendo a estrutura

"Mas não é preciso aprender 10 DSLs?"

Sim. Mas a estrutura não precisa ser exposta ao usuário.

Se colocarmos a stack tecnológica e as regras SSOT previamente no prompt de sistema do agente, o usuário só precisa dizer "crie a funcionalidade de reserva". O agente automaticamente adiciona um endpoint no OpenAPI, cria uma tabela no DDL, declara o fluxo de serviço no SSaC, desenha o diagrama de estados, escreve a política OPA, cria a interface no STML e executa `fullend validate` para verificar a consistência.

O que o usuário vê é apenas o resultado. A estrutura é consumida pelo agente, não é algo que o usuário precise aprender.

A experiência do vibe coding permanece a mesma. O que muda é que nada quebra por trás.

## O papel do Fullend

O Fullend é um validador cruzado. Não reinventa ferramentas individuais. Chama cada ferramenta e inspeciona as fronteiras entre os SSOTs.

```bash
fullend validate specs/my-project
```

```
✓ Config       fullend.yaml valid
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✓ SSaC         7 service functions
✓ STML         4 pages, 6 bindings
✓ States       2 diagrams
✓ Policy       3 rules
✓ Scenario     2 features
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

Quando a validação passa, o código é gerado.

```bash
fullend gen specs/my-project artifacts/my-project
```

O sqlc gera os modelos do banco de dados, o oapi-codegen gera os tipos da API, o SSaC gera os handlers gin, o STML gera os componentes React, o pacote de máquina de estados e o OPA Authorizer são gerados, os testes Hurl são gerados a partir do Gherkin, e o Fullend gera o código de cola que os conecta.

## Regras de validação cruzada

O valor central do Fullend está na validação cruzada. Após cada ferramenta individual validar sua camada, o Fullend detecta inconsistências entre os SSOTs.

**OpenAPI ↔ DDL**

| Alvo da validação | Regra |
|---|---|
| x-sort.allowed | A coluna correspondente existe na tabela? |
| x-sort ↔ DDL index | A coluna possui índice? (WARNING) |
| x-filter.allowed | A coluna correspondente existe na tabela? |
| x-include.allowed | É uma tabela conectada por relação FK? |

**SSaC ↔ DDL**

| Alvo da validação | Regra |
|---|---|
| Model.Method | O método correspondente existe nas queries do sqlc? |
| @result Type | Corresponde ao tipo derivado da tabela DDL? |
| Campos dos argumentos | Podem ser convertidos em colunas DDL? |

**SSaC ↔ OpenAPI**

| Alvo da validação | Regra |
|---|---|
| Nome da função | Corresponde ao operationId? |
| Argumento request | O campo existe no esquema da requisição? |
| Campo @response | O campo existe no esquema da resposta? |

**States ↔ SSaC ↔ OpenAPI**

| Alvo da validação | Regra |
|---|---|
| Evento de transição | Corresponde ao nome da função SSaC? |
| Evento de transição | Corresponde ao operationId do OpenAPI? |
| SSaC @state | O stateDiagram referenciado existe? |
| Campo @state | Existe como coluna DDL? |

**Policy ↔ SSaC ↔ DDL**

| Alvo da validação | Regra |
|---|---|
| allow (action, resource) | Corresponde ao @auth do SSaC? |
| @ownership table.column | Existe no DDL? |
| @ownership via join | A FK da tabela de junção existe no DDL? |

**Func ↔ SSaC**

| Alvo da validação | Regra |
|---|---|
| Referência @call | Existe implementação Func correspondente? |
| Quantidade/tipo dos argumentos | Os argumentos de @call correspondem aos campos de Request? |
| Corpo da função | Não é um stub TODO? (WARNING) |

**Scenario ↔ OpenAPI**

| Alvo da validação | Regra |
|---|---|
| operationId | Existe no OpenAPI? |
| HTTP method | Corresponde ao método do OpenAPI? |
| Campos JSON | Existem no esquema da requisição? |

**STML ↔ SSaC** — Ambos referenciam o mesmo operationId do OpenAPI. Quando a validação de ambos passa, a correspondência entre a API chamada pelo frontend e a API processada pelo backend é automaticamente garantida.

## Projetado para agentes

O Fullend foi projetado para agentes de IA.

Para que o agente escreva specs, ele precisa conhecer os 10 tipos de sequência do SSaC, os atributos data-* do STML, as extensões x- do OpenAPI, as regras de stateDiagram, os padrões de política OPA, a sintaxe de cenários Gherkin, as regras de Func Spec e as regras de correspondência de nomes. Para isso, fornecemos um manual para IA com cerca de 830 linhas. Basta adicioná-lo uma vez ao prompt de sistema do agente.

O loop de validação após a escrita das specs é simples:

```
Workflow do agente:
1. Modificar specs/
2. fullend validate specs/my-project
3. Se houver erros → corrigir o SSOT correspondente → voltar ao 2
4. Zero erros → fullend gen specs/my-project artifacts/my-project
```

Não é preciso entender o sistema inteiro. Basta corrigir o que o validate aponta para restaurar a consistência. Modelos inteligentes acertam de primeira, modelos menores acertam na terceira tentativa. O resultado é o mesmo.

## Tamanho do SSOT por escala

| Escala | Exemplo | SSOT | Código de implementação | Ocupação do contexto |
|---|---|---|---|---|
| Pequeno | Agendamento de salão de beleza | ~1.500 linhas | ~10.000 linhas | ~8% |
| Médio | Nível Jira ou Notion | ~12.500 linhas | ~100.000 linhas | ~55% |
| Grande | Nível Shopify | ~30.000 linhas | ~300.000 linhas | ~90% |

Com base em contexto de 200K tokens. Até SaaS de médio porte, o agente consegue ler todo o design de uma vez.

## Padronização das exceções

O que não pode ser expresso com os 10 tipos de sequência vai para `@call`. O que não pode ser expresso com atributos data-* vai para `custom.ts`. Se essas válvulas de escape ultrapassarem 20% do total, a estruturação perde seu sentido.

Porém, a exceção, no momento em que é isolada, torna-se observável. Quando muitos projetos forem estruturados com Fullend, padrões recorrentes aparecerão em `@call` e `custom.ts`.

Os 10 tipos de sequência do SSaC não foram projetados desde o início. Convergiram para 10 após a observação de centenas de códigos de serviço. Esperamos que o mesmo princípio se repita nas válvulas de escape. Padrões frequentes de `@call` se tornam novos tipos de sequência, e padrões frequentes de `custom.ts` se tornam novos atributos data-*.

As exceções não diminuem — a estrutura cresce a partir delas.

## Expansão da stack tecnológica

Atualmente, o Fullend é fixo em Go (gin) + React + PostgreSQL + Terraform. Isso é intencional. Na fase de prova de conceito, a prioridade é atravessar uma stack de ponta a ponta.

Porém, muitos dos 10 SSOTs (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) já são independentes de linguagem. Os 10 tipos de sequência do SSaC são padrões não vinculados a nenhuma linguagem — apenas expressos como comentários Go. O STML usa atributos HTML5 data-*, sendo independente de framework.

A expansão é uma questão de adicionar backends de geração de código. A lógica de validação e as regras de validação cruzada permanecem inalteradas.

## Relação com GEUL

Os 10 SSOTs compõem todas as decisões do software. SSOT são dados estruturados. Dados estruturados são grafos. Grafos podem ser codificados em GEUL.

O `data-fetch="ListReservations"` do STML é uma relação entre entidades. O `@get → @empty → @state → @call → @put → @response` do SSaC é uma sequência de eventos. As transições do stateDiagram são um grafo de estados. As políticas OPA são relações de permissão. A definição de endpoint do OpenAPI é um contrato. Todos são estruturas semânticas expressáveis com triple edges, event6 edges e entity nodes do GEUL.

A forma como o Fullend realiza a validação cruzada entre 10 SSOTs — correspondência simbólica, verificação de consistência de tipos, verificação de integridade referencial — é o mesmo princípio da verificação mecânica em streams GEUL.

## Licença

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Repositório no GitHub</a>
