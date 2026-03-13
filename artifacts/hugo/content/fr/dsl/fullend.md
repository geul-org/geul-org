---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "Un CLI qui valide la coherence croisee de 10 SSOT et genere le code. Combler les fissures du vibe coding par la structure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — un CLI qui verifie la coherence de 10 SSOT en une seule passe et genere le code.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Dépôt GitHub</a>

## Les fissures du vibe coding

Avec la democratisation du vibe coding, un schema recurrent est apparu.

On demande a l'AI : « Cree une fonction de reservation » — c'est fait. « Ajoute l'annulation » — c'est ajoute. A la cinquieme fonctionnalite, la deuxieme se casse. On a modifie le schema API sans mettre a jour le frontend. On a ajoute une colonne en base de donnees sans que la couche service ne le sache.

La cause est simple : l'AI ne peut pas garder l'ensemble du code en memoire.

Ce que font les gens : quand ils decouvrent un dysfonctionnement, ils disent a l'AI « Corrige ca aussi ». La correction casse autre chose. « Corrige ca aussi. » La boucle se repete. Plus le projet grandit, plus la boucle s'allonge, jusqu'au moment ou « tout recommencer serait plus rapide ».

## Pourquoi le code grossit

Le code melange deux choses.

**Les decisions** : quoi afficher, quel API appeler, dans quel ordre traiter, quoi stocker.
**Le cablage** : le code qui implemente ces decisions dans un framework specifique.

Prenons un systeme de reservation.

```
Decision : "Lors de l'annulation d'une reservation : verification des droits → consultation → validation de la transition d'etat → calcul du remboursement → changement d'etat → reponse"
```

Cette decision d'une seule ligne se disperse entre les hooks React, les handlers Go, les requetes SQL, les schemas API et les ressources Terraform. Chacun est emballe dans la syntaxe de son framework, augmente de la gestion d'erreurs et des conversions de types.

Sur 100 000 lignes de code, les decisions representent 12 500 lignes. Les 87 500 restantes sont du cablage.

La fenetre de contexte d'un agent AI est finie. Quand il ajoute la dixieme fonctionnalite, il ne se souvient plus des neuf precedentes — parce qu'il ne peut pas lire 100 000 lignes d'un coup.

En isolant uniquement les decisions : 12 500 lignes. Soit 55 % d'un contexte de 200K tokens. Une taille que l'AI peut lire en une seule fois.

## Les 10 SSOT

Fullend separe toutes les decisions d'un logiciel en 10 specifications declaratives. Chaque specification devient la source unique de verite (SSOT) pour son domaine de responsabilite.

| Domaine | SSOT | Ce qui est declare |
|---|---|---|
| Configuration projet | fullend.yaml | Stack technique, middlewares, chemins des modules |
| Interface | [STML](/fr/dsl/stml/) (HTML5 + data-*) | Quoi afficher et quoi faire |
| Contrat API | OpenAPI 3.x | Quelles requetes accepter et quelles reponses renvoyer |
| Flux de service | [SSaC](/fr/dsl/ssac/) (.ssac DSL) | Dans quel ordre traiter |
| Structure de donnees | SQL DDL + sqlc | Quoi stocker |
| Fonctions externes | Func Spec (Go) | Interface et implementation de la logique personnalisee |
| Transitions d'etat | Mermaid stateDiagram | Quels etats traverse une ressource |
| Politique d'autorisation | OPA Rego | Qui peut faire quoi |
| Scenarios | Gherkin (.feature) | Validation des flux metier inter-endpoints |
| Infrastructure | Terraform HCL | Ou executer |

OpenAPI, SQL DDL et Terraform sont des standards de l'industrie. Les autres domaines n'avaient pas de DSL SSOT correspondant. Le flux de service etait disperse dans les handlers Go, les decisions d'interface noyees dans les hooks React, les transitions d'etat cachees dans des branches if-else, les autorisations codees en dur dans les middlewares. C'est pourquoi STML, SSaC, Func Spec, l'integration stateDiagram, l'integration OPA et l'integration Gherkin ont ete concus.

```
specs/my-project/
├── fullend.yaml             → Configuration projet
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + requetes sqlc
├── service/**/*.ssac        → SSaC (extension .ssac)
├── model/*.go               → Structs Go (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` est la verite. `artifacts/` peut etre regenere a tout moment.

## La validation individuelle existe deja

Les outils de verification pour plusieurs couches existent deja.

- sqlc verifie la coherence entre DDL et requetes.
- Le validateur OpenAPI verifie la validite du schema.
- Terraform verifie la syntaxe et les dependances du HCL.

Des validateurs integres ont egalement ete crees pour STML et SSaC. SSaC verifie la coherence interne des flux de service ; STML verifie la correspondance entre les declarations UI et OpenAPI.

Chaque SSOT peut etre verifie individuellement. Le probleme survient **entre** eux.

Le frontend affiche un champ avec `data-bind="memo"`, mais le schema de reponse API ne contient pas `memo`. SSaC appelle `@delete Reservation.SoftDelete(request.ReservationID)`, mais la methode `SoftDelete` n'existe pas dans les requetes sqlc. Le diagramme d'etats definit une transition `PublishCourse`, mais il n'y a pas de fonction correspondante dans SSaC. La politique OPA interroge la propriete de la ressource `course` via `courses.instructor_id`, mais la colonne n'existe pas dans le DDL.

Chaque outil ne voit que sa propre couche. Les fissures entre les couches restent invisibles.

## Masquer la structure

« Mais il faut quand meme apprendre 10 DSL ? »

C'est vrai. Mais la structure n'a pas besoin d'etre exposee a l'utilisateur.

Si le prompt systeme de l'agent contient deja la stack technique et les regles SSOT, l'utilisateur n'a qu'a dire « Cree une reservation ». L'agent ajoute automatiquement un endpoint dans OpenAPI, cree une table dans le DDL, declare un flux de service dans SSaC, dessine le diagramme d'etats, redige la politique OPA, dessine l'ecran dans STML et execute `fullend validate` pour verifier la coherence.

L'utilisateur ne voit que le resultat. La structure est consommee par l'agent, pas apprise par l'utilisateur.

L'experience du vibe coding reste intacte. Ce qui change : en coulisses, plus rien ne se casse.

## Le role de Fullend

Fullend est un validateur croise. Il ne reinvente pas les outils existants. Il appelle chacun d'eux et inspecte les frontieres entre les SSOT.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

Valide chacun des 10 SSOT individuellement, puis effectue la validation croisee entre eux. Func n'est valide que lorsqu'un repertoire `func/` existe. Utilisez `--skip` pour exclure des SSOT specifiques.

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

Si une verification echoue :

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

Si la validation passe, le code est genere. L'option `--skip` fonctionne de la meme maniere que pour validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc genere les modeles de base de donnees, oapi-codegen les types API, SSaC les handlers gin, STML les composants React, le package de machine a etats et l'OPA Authorizer sont generes, les tests Hurl sont generes a partir des Gherkin, et Fullend genere le code de liaison qui les relie.

### gen-model

Genere un fichier modele Go (interface + types + client HTTP) a partir d'un document OpenAPI externe. Accepte un chemin de fichier local ou une URL.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

Trace tous les noeuds SSOT connectes a une seule operation API. Un operationId en entree, une carte complete fichier:ligne inter-couches en sortie.

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

Affiche un resume des SSOT detectes et leurs statistiques.

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

## Fonctions et modeles integres

Fullend est livre avec des implementations de fonctions courantes et des interfaces de modeles. Ils peuvent etre invoques via `@call` dans SSaC.

### Fonctions par defaut (pkg/)

| Package | Fonction | Description |
|---|---|---|
| `auth` | `hashPassword` | Hachage de mot de passe bcrypt |
| `auth` | `verifyPassword` | Verification de mot de passe bcrypt |
| `auth` | `issueToken` | Generation de token d'acces JWT (24h) |
| `auth` | `verifyToken` | Verification de token JWT + extraction des claims |
| `auth` | `refreshToken` | Generation de refresh token (7 jours) |
| `auth` | `generateResetToken` | Token hexadecimal aleatoire pour la reinitialisation du mot de passe |
| `crypto` | `encrypt` | Chiffrement symetrique AES-256-GCM |
| `crypto` | `decrypt` | Dechiffrement AES-256-GCM |
| `crypto` | `generateOTP` | Secret TOTP + URL de provisionnement QR |
| `crypto` | `verifyOTP` | Verification de code TOTP |
| `storage` | `uploadFile` | Upload de fichier compatible S3 |
| `storage` | `deleteFile` | Suppression de fichier compatible S3 |
| `storage` | `presignURL` | URL de telechargement presignee S3 |
| `mail` | `sendEmail` | Email texte brut via SMTP |
| `mail` | `sendTemplateEmail` | Email HTML via template Go par SMTP |
| `text` | `generateSlug` | Unicode vers slug URL-safe |
| `text` | `sanitizeHTML` | Assainissement HTML pour la prevention XSS |
| `text` | `truncateText` | Troncature de texte respectant Unicode |
| `image` | `ogImage` | Generation d'image OG (1200x630, PNG) |
| `image` | `thumbnail` | Generation de miniature (200x200, PNG) |

Les projets peuvent remplacer ces fonctions en fournissant des implementations personnalisees dans `specs/<project>/func/<pkg>/`.

### Modeles integres (pkg/)

Interfaces @model a prefixe de package pour les E/S non-DDL. Configures via `fullend.yaml`.

| Package | Interface | Backends | Utilisation SSaC |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (genere)

Fullend genere un fichier `internal/middleware/bearerauth.go` specifique au projet a partir de la configuration des claims dans `fullend.yaml`.

| Middleware | Declencheur | Description |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | Extrait le JWT → definit `*model.CurrentUser` dans le contexte gin |

Le regroupement des routes est determine par le champ `security` d'OpenAPI. Les operations avec `security: [{bearerAuth: []}]` vont dans le groupe authentifie ; les operations sans vont dans le groupe public.

## Regles de validation croisee

La valeur distinctive de Fullend reside dans la validation croisee. Apres que chaque outil a valide sa propre couche, Fullend detecte les incoherences entre les SSOT.

**fullend.yaml ↔ OpenAPI**
| Cible | Regle |
|---|---|
| Nom du middleware | Correspond-il a une cle securitySchemes ? |

**OpenAPI ↔ DDL**
| Cible | Regle |
|---|---|
| x-sort.allowed | La colonne existe-t-elle dans la table ? |
| x-sort ↔ DDL index | La colonne a-t-elle un index ? (WARNING) |
| x-filter.allowed | La colonne existe-t-elle dans la table ? |
| x-include.allowed | La table est-elle connectee par une FK ? |

**SSaC ↔ DDL**
| Cible | Regle |
|---|---|
| Model.Method | La methode existe-t-elle dans les requetes sqlc ? |
| @result Type | Le type correspond-il a celui derive de la table DDL ? |
| Champs des arguments | Peuvent-ils etre mappes aux colonnes DDL ? |

**SSaC ↔ OpenAPI**
| Cible | Regle |
|---|---|
| Nom de fonction | Correspond-il a un operationId ? |
| Arguments request | Le champ existe-t-il dans le schema de requete ? |
| Champs @response | Le champ existe-t-il dans le schema de reponse ? |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**
| Cible | Regle |
|---|---|
| Evenement de transition | Correspond-il au nom de fonction SSaC ? |
| Evenement de transition | Correspond-il a un operationId OpenAPI ? |
| SSaC @state | Le stateDiagram reference existe-t-il ? |
| Champ @state | Existe-t-il comme colonne DDL ? |

**Policy ↔ SSaC ↔ DDL ↔ States**
| Cible | Regle |
|---|---|
| allow (action, resource) | Correspond-il au @auth SSaC ? |
| @ownership table.column | Existe-t-il dans le DDL ? |
| @ownership via join | La FK de la table de jointure existe-t-elle dans le DDL ? |
| Evenement de transition d'etat | Existe-t-il une regle Rego correspondante pour les transitions avec @auth ? |

**Func ↔ SSaC**
| Cible | Regle |
|---|---|
| Reference @call | Une implementation Func correspondante existe-t-elle ? |
| Nombre d'arguments | Les arguments @call correspondent-ils au nombre de champs Request ? |
| Types d'arguments | Les types positionnels correspondent-ils via DDL/OpenAPI ? |
| Resultat/reponse | Le resultat/la reponse sont-ils coherents ? |
| Corps de la fonction | N'est-ce pas un stub TODO ? (WARNING) |

**Scenario ↔ OpenAPI ↔ States**
| Cible | Regle |
|---|---|
| operationId | Existe-t-il dans OpenAPI ? |
| Methode HTTP | Correspond-elle a la methode OpenAPI ? |
| Champs JSON | Existent-ils dans le schema de requete ? |
| Ordre des etapes | Respecte-t-il les regles de transition d'etat ? |

**Queue (Pub/Sub)**
| Cible | Regle |
|---|---|
| @publish topic | Existe-t-il une fonction @subscribe correspondante ? |
| Champs payload/message | Sont-ils coherents ? |
| Configuration Queue | fullend.yaml contient-il la configuration de la file ? |

**STML ↔ SSaC** — les deux referent le meme operationId OpenAPI. Si les deux validations passent, la correspondance entre l'API appelee par le frontend et l'API traitee par le backend est automatiquement garantie.

## Tests a l'execution

`fullend gen` genere des tests [Hurl](https://hurl.dev) a partir des specs OpenAPI et des scenarios Gherkin.

```bash
# Demarrez votre serveur, puis :
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

Tests generes :
- **smoke.hurl** — Tests smoke des endpoints OpenAPI (generes automatiquement)
- **scenario-*.hurl** — Tests de scenarios metier (a partir des fichiers .feature)
- **invariant-*.hurl** — Tests d'invariants inter-endpoints (a partir des fichiers .feature)

## Concu pour les agents

Fullend a ete concu pour les agents AI.

Pour qu'un agent puisse ecrire des specs, il doit connaitre les 10 types de sequences SSaC, les attributs data-* de STML, les extensions OpenAPI x-, les regles stateDiagram, les patterns de politique OPA, la syntaxe des scenarios Gherkin, les regles Func Spec et les regles de correspondance des noms. Un manuel AI d'environ 830 lignes est fourni a cet effet. Il suffit de l'inserer une fois dans le prompt systeme de l'agent.

La boucle de validation apres l'ecriture des specs est simple.

```
Workflow de l'agent :
1. Modifier specs/
2. fullend validate specs/my-project
3. S'il y a des erreurs → corriger le SSOT concerne → retour a l'etape 2
4. Zero erreur → fullend gen specs/my-project artifacts/my-project
```

Pas besoin de comprendre l'ensemble du systeme. Il suffit de corriger ce que validate indique pour restaurer la coherence. Un modele performant reussit du premier coup, un petit modele en trois tentatives. Le resultat est le meme.

## Taille des SSOT selon l'echelle

| Echelle | Exemple | SSOT | Code d'implementation | Occupation du contexte |
|---|---|---|---|---|
| Petit | Reservations salon de coiffure | ~1 500 lignes | ~10 000 lignes | ~8 % |
| Moyen | Niveau Jira/Notion | ~12 500 lignes | ~100 000 lignes | ~55 % |
| Grand | Niveau Shopify | ~30 000 lignes | ~300 000 lignes | ~90 % |

Base : contexte de 200K tokens. Jusqu'au SaaS moyen, l'agent peut lire l'architecture complete en une seule fois.

## Transformer les exceptions en patterns

Ce que les 10 types de sequences ne couvrent pas passe par `@call`. Ce que les attributs data-* ne couvrent pas passe par `custom.ts`. Si ces echappatoires depassent 20 % du total, la structuration perd son sens.

Cependant, une exception isolee devient observable. Quand de nombreux projets seront structures avec Fullend, des patterns recurrents apparaitront dans `@call` et `custom.ts`.

Les 10 types de sequences SSaC n'ont pas ete concus des le depart. Ils ont converge vers dix apres l'observation de centaines d'exemples de code de service. Le meme principe se repetera avec les echappatoires. Les patterns `@call` frequents deviendront de nouveaux types de sequences ; les patterns `custom.ts` frequents deviendront de nouveaux attributs data-*.

Les exceptions ne diminuent pas — la structure nait des exceptions.

## Extension de la stack technique

Actuellement, Fullend est fixe sur Go (gin) + React + PostgreSQL + Terraform. C'est intentionnel. Au stade du PoC, traverser une seule stack de bout en bout est prioritaire.

Cependant, une grande partie des 10 SSOT (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) est deja independante du langage. Les 10 types de sequences SSaC sont des patterns non lies a un langage — ils sont simplement exprimes en commentaires Go. STML utilise des attributs HTML5 data-*, independants du framework.

L'extension revient a ajouter des backends de generation de code. La logique de validation et les regles de validation croisee restent inchangees.

## Relation avec GEUL

Les 10 SSOT constituent l'ensemble des decisions d'un logiciel. Un SSOT est constitue de donnees structurees. Les donnees structurees forment un graphe. Un graphe peut etre encode en GEUL.

Le `data-fetch="ListReservations"` dans STML est une relation entre entites. Le `@get → @empty → @state → @call → @put → @response` dans SSaC est une sequence d'evenements. Les transitions d'un stateDiagram forment un graphe d'etats. Les politiques OPA sont des relations d'autorisation. La definition d'un endpoint dans OpenAPI est un contrat. Ce sont toutes des structures semantiques exprimables par les aretes triples, les aretes event6 et les noeuds entite de GEUL.

La maniere dont Fullend effectue la validation croisee des 10 SSOT — correspondance symbolique, verification de coherence des types, controle de l'integrite referentielle — repose sur le meme principe que la verification mecanique dans un flux GEUL.

## Licence

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Dépôt GitHub</a>
