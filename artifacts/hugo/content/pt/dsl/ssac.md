---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Declara lógica de serviço em comentários Go e gera código de implementação. 10 tipos de sequência fixos cobrem todas as operações de contrato binário na camada de serviço."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — gera código de serviço a partir de um DSL de comentários Go.

A lógica de serviço é uma série de decisões: qual modelo consultar, contra o que proteger, quando rejeitar, o que retornar. Essas decisões pertencem a quem entende o negócio — mas ficam enterradas em boilerplate, espalhadas entre camadas e perdidas em reescritas.

O SSaC preserva essas decisões como uma especificação declarativa. Você declara **o que** acontece e **em que ordem**. A ferramenta gera a implementação.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## Ideia Central

Toda função de serviço é uma sequência de passos. Cada passo segue um contrato binário: **sucesso → próxima linha, falha → return**. Não é uma abstração inventada — é como a lógica de serviço já funciona. O SSaC torna isso explícito.

10 tipos de sequência fixos cobrem todas as operações da camada de serviço que seguem este contrato. O que não se encaixar, delegue ao `call`. O conjunto é fechado por design.

Sem LLM, sem inferência — codegen simbólico puro a partir de templates. A especificação é a fonte de verdade.

## Exemplo

```go
// @sequence get
// @model Project.FindByID
// @param ProjectID request
// @result project Project

// @sequence guard nil project
// @message "project not found"

// @sequence post
// @model Session.Create
// @param ProjectID request
// @param Command request
// @result session Session

// @sequence response json
// @var session
func CreateSession(w http.ResponseWriter, r *http.Request) {}
```

Esta declaração de 10 linhas gera o seguinte código:

```go
func CreateSession(w http.ResponseWriter, r *http.Request) {
    projectID := r.FormValue("ProjectID")
    command := r.FormValue("Command")

    project, err := projectModel.FindByID(projectID)
    if err != nil {
        http.Error(w, "Project lookup failed", http.StatusInternalServerError)
        return
    }

    if project == nil {
        http.Error(w, "project not found", http.StatusNotFound)
        return
    }

    session, err := sessionModel.Create(projectID, command)
    if err != nil {
        http.Error(w, "Session creation failed", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "session": session,
    })
}
```

## Tipos de Sequência (10)

| Tipo | Papel |
|---|---|
| `authorize` | Verificação de permissão (OPA, etc.) |
| `get` | Busca de recurso |
| `guard nil` | Sair se nulo |
| `guard exists` | Sair se existir |
| `post` | Criação de recurso |
| `put` | Atualização de recurso |
| `delete` | Exclusão de recurso |
| `password` | Comparação de senha |
| `call` | Chamada externa (@component / @func) |
| `response` | Retornar resposta (json) |

## Recursos de Codegen

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
      allowed: [room, user]
```

## Licença

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
