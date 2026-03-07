---
title: "Pourquoi les annotations doivent être des index"
weight: 20
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["index", "annotation", "code", "AST", "patron-de-conception"]
summary: "Les annotations sont écrites pour les humains. Mais quand il y a 10 000 fonctions, les machines doivent aussi les lire. Si l'on transforme les annotations de récit en index, le scan complet devient une recherche instantanée."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Les annotations sont écrites pour les humains.

```go
// GetUser retrieves a user by ID from the database.
func GetUser(id string) (*User, error) {
```

Cette annotation est utile quand un humain la lit. Mais quand une machine la lit, elle ne comprend rien. Elle ne sait pas si "retrieves" signifie Read ou Search. Elle ne sait pas quel type d'entité est "user". Elle ne sait pas si cette fonction suit le pattern Service ou Repository.

Parce que l'annotation est un récit.

---

## Quand il y a 10 000 fonctions

Quand il y a 10 fonctions, cela n'a pas d'importance. Un humain peut tout lire.

Quand il y a 10 000 fonctions, c'est différent. Quand on dit « montre-moi toutes les fonctions liées au paiement », ni l'humain ni la machine ne les trouvent. On ne trouve que celles qui contiennent "payment" dans leur nom. Si ce n'est pas dans le nom, on passe à côté.

C'est la même chose quand un agent IA modifie du code. Si vous dites à Claude Code « corrige le traitement de l'erreur PaymentFailed », l'agent relit tout le code. À chaque fois. Il analyse les 10 000 fonctions depuis le début, à chaque fois. Le code lu hier est relu aujourd'hui. Même avec des annotations, c'est pareil. Parce que les annotations sont des récits pour humains. Pour qu'une machine extraie du sens d'un récit, il faut de l'inférence. C'est coûteux.

---

## Si l'annotation est un index

```go
// CreateOrder processes a new order creation.
//
// # Pattern: Service, Transactional
// # Entity: Order
// # Action: Create
// # Input: CreateOrderRequest {items:[]Item, userID:string}
//          pre: items>0 userID!=''
// # Output: *OrderResponse, error
//          errs: [StockInsufficient, PaymentFailed]
// # Deps: InventorySvc, PaymentGateway
func (s *OrderService) CreateOrder(req CreateOrderRequest) (*OrderResponse, error) {
```

Cette annotation est lisible par les humains et par les machines.

« Toutes les fonctions du pattern Service » → recherche sur le champ Pattern. Instantané.
« Toutes les fonctions liées à l'entité Order » → recherche sur le champ Entity. Instantané.
« Les fonctions qui déclenchent PaymentFailed » → recherche sur le champ errs. Instantané.

Le scan complet devient une recherche par index. O(n) devient O(1).

---

## L'humain n'a rien à écrire

Cet index n'a pas besoin d'être écrit par un humain.

Quand le code est modifié, la détection est automatique. Surveillance de fichiers.
La fonction modifiée est isolée par l'AST. Mécanique.
Le corps de la fonction est envoyé à un petit LLM. « Détermine le pattern, l'entité et l'action de cette fonction. »
Le résultat est inséré dans un format prédéfini. Mécanique.

L'humain ne fait rien. Il suffit d'écrire du code. L'index se met à jour automatiquement.

Dans tout le pipeline, le LLM n'intervient qu'en un seul point — juger la sémantique de la fonction. Le reste est entièrement du code déterministe.

---

## De l'inférence à la règle

On va encore un cran plus loin.

Quand un petit LLM attribue de manière répétée le même index au même pattern — on détecte cette répétition. Si « Service suffix avec receiver method donne Pattern:Service » s'est répété 100 fois, on le cristallise en règle. Le LLM n'est plus appelé. La règle prend le relais.

Les appels au LLM diminuent progressivement. Les règles augmentent progressivement. Le coût converge vers zéro.

L'annotation passe du récit à l'index,
l'index passe du manuel à l'automatique,
l'automatique passe de l'inférence à la règle.

---

## Pourquoi c'est possible : les design patterns comme codebook

Il y a une raison pour laquelle cela fonctionne.

La programmation dispose déjà d'un vocabulaire sémantique standardisé. Ce sont les design patterns.

Singleton, Factory, Observer, MVC, Service. Depuis que le GoF a formalisé 23 patterns en 1994, l'industrie du logiciel a étendu et standardisé ce vocabulaire pendant 30 ans.

Les 23 patterns du GoF. Enterprise Application Patterns. Cloud Design Patterns. Go Concurrency Patterns. Tout est déjà répertorié.

Ce vocabulaire n'est pas ambigu. Singleton est Singleton. Les développeurs ne l'interprètent pas différemment. La définition est consensuelle, les conditions d'implémentation sont claires, et toute violation est détectée en revue de code.

Ce système de vocabulaire devient le codebook de l'index. Pas besoin d'en créer un nouveau. Il existe déjà.

Le langage naturel n'a pas cet avantage. « Grand » a une définition dans le dictionnaire, mais chaque personne l'utilise différemment. Dans le code, Service n'est pas utilisé différemment selon les développeurs.

---

## Pourquoi le code est le domaine le plus facile

Le pipeline de contexte de GEUL — [clarification](/fr/why/clarification/), [indexation](/fr/why/semantically-aligned-index/), [vérification](/fr/why/mechanical-verification/), [filtrage](/fr/why/filter/), [cohérence](/fr/why/consistency-check/), [exploration](/fr/why/exploration/) — est difficile à appliquer au langage naturel. L'appliquer au code est facile.

Clarification : le langage naturel est ambigu. Le code, si le compilateur l'a accepté, a un sens déterminé.
Indexation : les entités du langage naturel nécessitent le contexte. Les entités du code sont déjà parsées par l'AST.
Vérification : la validité du langage naturel ne peut pas être définie. La validité du code est jugée par le compilateur.
Filtrage : la pertinence du langage naturel doit être jugée par un LLM. La pertinence du code peut être déterminée mécaniquement par le graphe d'appels.
Cohérence : les contradictions du langage naturel ne se découvrent que par inférence. Les contradictions du code sont détectées par le système de types et les tests.
Exploration : la connaissance en langage naturel est plate. Le code a déjà une structure hiérarchique : package → fichier → type → méthode.

Le même pipeline fonctionne à un coût bien moindre dans le domaine du code. Prouver d'abord là où c'est le plus facile, puis étendre vers le plus difficile. C'est cela, l'ingénierie.

---

## Résumé

Les annotations étaient faites pour les humains.
Désormais, elles doivent aussi être faites pour les machines.
Des annotations lisibles par les humains, interrogeables par les machines.
Des annotations qui sont à la fois récit et index.

Le code a déjà du sens, déjà une structure, déjà un vocabulaire.
Ce qui manque, c'est l'index.
Il suffit que les annotations deviennent cet index.
