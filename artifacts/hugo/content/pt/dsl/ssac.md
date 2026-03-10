---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Um único comentário Go é uma sequência. 10 tipos de sequência fixos cobrem todas as bifurcações binárias na camada de serviço, e o codegen simbólico produz handlers gin."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — um único comentário Go é uma sequência. Declare e um handler gin é gerado.

A lógica de serviço é uma série de decisões: qual modelo consultar, contra o que proteger, quando rejeitar, o que retornar. Essas decisões pertencem a quem entende o negócio — mas ficam enterradas em boilerplate, espalhadas entre camadas e perdidas em reescritas.

O SSaC preserva essas decisões como uma especificação declarativa. Declare **o que** acontece e **em que ordem**, uma linha de cada vez, e a ferramenta gera a implementação.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (comentário DSL)      (validação)      (codegen)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Repositório no GitHub</a>

## Ideia Central

Toda função de serviço é uma sequência de passos. Cada passo segue um contrato binário: **sucesso → próxima linha, falha → return**. Isso não é uma abstração inventada — é como a lógica de serviço já funciona. O SSaC torna isso explícito.

10 tipos de sequência fixos cobrem todas as operações da camada de serviço que seguem este contrato. O que não se encaixar é delegado ao `@call`. O conjunto é fechado por design.

Sem LLM, sem inferência — codegen simbólico puro baseado em templates. A especificação é a fonte única de verdade.

## Sintaxe — Uma Linha, Uma Sequência

A partir do v2, cada sequência é uma única linha de comentário. Apenas `@response` usa um bloco multilinha.

**CRUD — Operações de Modelo**

```go
// @get Type var = Model.Method(args...)        — leitura (resultado obrigatório)
// @post Type var = Model.Method(args...)       — criação (resultado obrigatório)
// @put Model.Method(args...)                   — atualização (sem resultado)
// @delete Model.Method(args...)                — exclusão (sem resultado)
```

Formato dos argumentos: `source.Field` ou `"literal"`

- `request.CourseID` — da requisição HTTP
- `course.InstructorID` — de uma variável de resultado anterior
- `currentUser.ID` — do contexto de autenticação
- `"cancelled"` — literal de string

**Guardas**

```go
// @empty target "message"                      — falha se nil/zero (404)
// @exists target "message"                     — falha se não nil/zero (409)
```

Alvo: uma variável (`course`) ou variável.campo (`course.InstructorID`)

**Transições de Estado**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**Verificação de Autorização — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**Chamadas Externas**

```go
// @call Type var = package.Func(args...)       — com resultado
// @call package.Func(args...)                  — sem resultado
```

**Resposta — Bloco de Mapeamento de Campos**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## Exemplo

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "não autorizado"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "reserva não encontrada"
// @state reservation {status: reservation.Status} "cancel" "não é possível cancelar"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

Declaração de 10 linhas. Cada linha é uma sequência, executada de cima para baixo em ordem. Autorização → leitura → guarda → transição de estado → chamada externa → atualização → releitura → resposta.

## Tipos de Sequência (10)

| Tipo | Papel |
|---|---|
| `@auth` | Verificação de autorização (política OPA) |
| `@get` | Leitura de recurso |
| `@empty` | Encerrar se nil/zero (404) |
| `@exists` | Encerrar se não nil/zero (409) |
| `@post` | Criação de recurso |
| `@put` | Atualização de recurso |
| `@delete` | Exclusão de recurso |
| `@state` | Validação de transição de estado |
| `@call` | Chamada de função de pacote externo |
| `@response` | Retornar resposta (mapeamento de campos) |

## Validação

Validação interna (sempre):
- Argumentos obrigatórios ausentes por tipo
- Formato `Model.Method`
- Fluxo de variáveis (referência antes da declaração)

Validação cruzada com SSOT externo (quando a estrutura do projeto é detectada):
- Existência de modelo/método (queries sqlc, interfaces Go)
- Existência de campos de request/response (OpenAPI)
- Existência de pacote/função (interfaces Go)
- Aviso de dados obsoletos: response após put/delete sem releitura (WARNING)
- Existência de diagrama de estado e validade da transição
- Existência de arquivo de política OPA

## Funcionalidades de Codegen

Quando o SSOT externo (tabelas de símbolos) está disponível, `ssac gen` oferece funcionalidades adicionais. O código gerado usa o framework gin.

- **Conversão de tipos**: tipos de coluna DDL → `strconv.ParseInt`, `time.Parse`, retorno antecipado 400 Bad Request
- **Tipos de valor de guarda**: verificação de zero com reconhecimento de tipo (`int` → `== 0`/`> 0`, ponteiro → `== nil`/`!= nil`)
- **Derivação de interface de modelo**: cruzamento de 3 fontes SSOT → `<outDir>/model/models_gen.go`
- **Codegen @state**: chamada a `CanTransition` do pacote de diagrama de estado
- **Codegen @auth**: chamada a `authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **Codegen @call**: estilo guarda (401) sem resultado, estilo valor (500) com resultado
- **Estrutura de pastas por domínio**: `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## Extensões x- do OpenAPI

Parâmetros de infraestrutura (paginação, ordenação, filtragem, inclusão de relações) são declarados nas extensões `x-` do OpenAPI. Apenas parâmetros de negócio são declarados nas especificações SSaC. O gerador de código lê as extensões `x-` e constrói automaticamente o `QueryOpts`.

```yaml
/api/reservations:
  get:
    operationId: ListReservations
    x-pagination:
      style: offset
      defaultLimit: 20
      maxLimit: 100
    x-sort:
      allowed: [start_at, created_at]
      default: start_at
      direction: desc
    x-filter:
      allowed: [status, room_id]
    x-include:
      allowed: [room_id:rooms.id, user_id:users.id]
```

## Licença

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Repositório no GitHub</a>
