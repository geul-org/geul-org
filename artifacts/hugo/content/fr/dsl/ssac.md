---
title: "SSaC — Service Sequences as Code"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Déclare la logique de service dans les commentaires Go et génère le code d'implémentation. 10 types de séquence fixes couvrent toutes les opérations de contrat binaire dans la couche de service."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — génère du code de service à partir d'un DSL de commentaires Go.

La logique de service est une série de décisions : quel modèle interroger, contre quoi se protéger, quand rejeter, quoi retourner. Ces décisions appartiennent à celui qui comprend le métier — mais elles sont enterrées dans le boilerplate, dispersées entre les couches et perdues lors des réécritures.

SSaC préserve ces décisions comme une spécification déclarative. Vous déclarez **ce qui** se passe et **dans quel ordre**. L'outil génère l'implémentation.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## Idée Centrale

Chaque fonction de service est une séquence d'étapes. Chaque étape suit un contrat binaire : **succès → ligne suivante, échec → return**. Ce n'est pas une abstraction inventée — c'est ainsi que la logique de service fonctionne déjà. SSaC rend cela explicite.

10 types de séquence fixes couvrent toutes les opérations de la couche de service suivant ce contrat. Ce qui ne convient pas est délégué à `call`. L'ensemble est fermé par conception.

Pas de LLM, pas d'inférence — codegen symbolique pur depuis des templates. La spécification est la source de vérité.

## Exemple

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

Cette déclaration de 10 lignes génère le code suivant :

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

## Types de Séquence (10)

| Type | Rôle |
|---|---|
| `authorize` | Vérification des permissions (OPA, etc.) |
| `get` | Recherche de ressource |
| `guard nil` | Sortir si null |
| `guard exists` | Sortir si existe |
| `post` | Création de ressource |
| `put` | Mise à jour de ressource |
| `delete` | Suppression de ressource |
| `password` | Comparaison de mot de passe |
| `call` | Appel externe (@component / @func) |
| `response` | Retourner la réponse (json) |

## Fonctions de Codegen

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

## Licence

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
