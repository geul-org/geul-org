---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Un seul commentaire Go est une séquence. 10 types de séquence fixes couvrent toutes les branches binaires de la couche de service, et le codegen symbolique produit des handlers gin."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — un seul commentaire Go est une séquence. Déclarez-la et un handler gin est généré.

La logique de service est une série de décisions : quel modèle interroger, contre quoi se protéger, quand rejeter, quoi retourner. Ces décisions appartiennent à celui qui comprend le métier — mais elles sont enterrées dans le boilerplate, dispersées entre les couches et perdues lors des réécritures.

SSaC préserve ces décisions comme une spécification déclarative. Déclarez **ce qui** se passe et **dans quel ordre**, une ligne à la fois, et l'outil génère l'implémentation.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (commentaire DSL)     (validation)      (codegen)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Dépôt GitHub</a>

## Idée centrale

Chaque fonction de service est une séquence d'étapes. Chaque étape suit un contrat binaire : **succès → ligne suivante, échec → return**. Ce n'est pas une abstraction que nous avons inventée — c'est ainsi que la logique de service fonctionne déjà. SSaC rend cela explicite.

10 types de séquence fixes couvrent toutes les opérations de la couche de service suivant ce contrat. Ce qui ne convient pas est délégué à `@call`. L'ensemble est fermé par conception.

Pas de LLM, pas d'inférence — codegen symbolique pur basé sur des templates. La spécification est la source unique de vérité.

## Syntaxe — une ligne, une séquence

À partir de la v2, chaque séquence est un commentaire sur une seule ligne. Seul `@response` utilise un bloc multi-lignes.

**CRUD — Opérations sur les modèles**

```go
// @get Type var = Model.Method(args...)        — lecture (résultat requis)
// @post Type var = Model.Method(args...)       — création (résultat requis)
// @put Model.Method(args...)                   — mise à jour (sans résultat)
// @delete Model.Method(args...)                — suppression (sans résultat)
```

Format des arguments : `source.Field` ou `"littéral"`

- `request.CourseID` — depuis la requête HTTP
- `course.InstructorID` — depuis une variable de résultat précédente
- `currentUser.ID` — depuis le contexte d'authentification
- `"cancelled"` — littéral de chaîne

**Gardes**

```go
// @empty target "message"                      — échec si nil/zero (404)
// @exists target "message"                     — échec si non nil/zero (409)
```

Cible : une variable (`course`) ou variable.champ (`course.InstructorID`)

**Transitions d'état**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**Vérification des permissions — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**Appels externes**

```go
// @call Type var = package.Func(args...)       — avec résultat
// @call package.Func(args...)                  — sans résultat
```

**Réponse — bloc de mapping de champs**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## Exemple

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "non autorisé"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "réservation introuvable"
// @state reservation {status: reservation.Status} "cancel" "annulation impossible"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

Déclaration en 10 lignes. Chaque ligne est une séquence, exécutée de haut en bas dans l'ordre. Autorisation → lecture → garde → transition d'état → appel externe → mise à jour → relecture → réponse.

## Types de séquence (10)

| Type | Rôle |
|---|---|
| `@auth` | Vérification des permissions (politique OPA) |
| `@get` | Lecture de ressource |
| `@empty` | Terminer si nil/zero (404) |
| `@exists` | Terminer si non nil/zero (409) |
| `@post` | Création de ressource |
| `@put` | Mise à jour de ressource |
| `@delete` | Suppression de ressource |
| `@state` | Validation de transition d'état |
| `@call` | Appel de fonction de package externe |
| `@response` | Retourner la réponse (mapping de champs) |

## Validation

Validation interne (toujours) :
- Arguments requis manquants par type
- Format `Model.Method`
- Flux de variables (référence avant déclaration)

Validation croisée SSOT externe (lorsque la structure du projet est détectée) :
- Existence des modèles/méthodes (requêtes sqlc, interfaces Go)
- Existence des champs requête/réponse (OpenAPI)
- Existence des packages/fonctions (interfaces Go)
- Avertissement de données obsolètes : réponse après put/delete sans relecture (WARNING)
- Existence du diagramme d'état et validité des transitions
- Existence du fichier de politique OPA

## Fonctionnalités de codegen

Lorsque les SSOT externes (tables de symboles) sont disponibles, `ssac gen` fournit des fonctionnalités supplémentaires. Le code généré utilise le framework gin.

- **Conversion de types** : types de colonnes DDL → `strconv.ParseInt`, `time.Parse`, retour anticipé 400 Bad Request
- **Types de valeur de garde** : vérification de zéro selon le type (`int` → `== 0`/`> 0`, pointeur → `== nil`/`!= nil`)
- **Dérivation d'interface de modèle** : croisement de 3 sources SSOT → `<outDir>/model/models_gen.go`
- **Codegen @state** : appel de `CanTransition` depuis le package de diagramme d'état
- **Codegen @auth** : appel de `authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **Codegen @call** : style garde (401) sans résultat, style valeur (500) avec résultat
- **Structure de dossiers par domaine** : `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## Extensions x- OpenAPI

Les paramètres d'infrastructure (pagination, tri, filtrage, inclusion de relations) sont déclarés dans les extensions `x-` d'OpenAPI. Seuls les paramètres métier sont déclarés dans les spécifications SSaC. Le générateur de code lit les extensions `x-` et construit automatiquement `QueryOpts`.

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

## Licence

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Dépôt GitHub</a>
