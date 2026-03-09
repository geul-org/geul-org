---
title: "Dépôts"
date: 2026-02-28T12:00:00+09:00
summary: "Les dépôts GitHub qui composent le projet GEUL. Spécification du langage, livres de codes grammaticaux, recherche, DSL et site web."
image: "/images/og-default.webp"
---

Tous les dépôts se trouvent dans l'organisation [geul-org](https://github.com/geul-org) sur GitHub.

---

## Langage

### geul

Un langage artificiel sémantiquement aligné et un format de flux binaire pour l'IA.

Un système linguistique de 2 octets (65 536 symboles) conçu pour une communication sans ambiguïté entre humains et IA. Chaque énoncé porte sa source, son horodatage et son niveau de confiance. Chaque entité a un identifiant unique. Le format de flux opère en unités de 16 bits, définissant 10 types de paquets (Verb Edge, Entity Node, Triple Edge, etc.) sous un schéma de préfixe de 10 bits.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| Langage | Go, Python |
| Licence | MIT |

---

## Grammaire

### geul-verb

Livre de codes des verbes SIDX 16 bits (basé sur WordNet).

Associe les synsets de verbes WordNet à des codes de 16 bits pour utilisation dans les paquets GEUL Verb Edge. Fournit le vocabulaire verbal consommé par le format de flux.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| Langage | Python |
| Licence | MIT |

### geul-entity

Livre de codes des entités SIDX 48 bits (basé sur Wikidata).

Encode les entités Wikidata en identifiants structurés de 48 bits. Définit les types d'entités, conçoit des schémas d'attributs par type et construit les livres de codes consommés par SILK.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| Langage | Python |
| Licence | MIT |

### geul-quantities

Livre de codes des nœuds de quantité.

Définit le schéma d'encodage pour les valeurs de quantité — nombres avec unités, intervalles et précision — utilisés dans les paquets GEUL Quantity Node.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| Langage | Python |
| Licence | MIT |

### geul-ast

Livre de codes des arêtes AST.

Définit le schéma d'encodage pour les arêtes d'arbres de syntaxe abstraite, permettant la représentation structurée de code au sein du format de flux GEUL.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| Langage | Python |
| Licence | MIT |

---

## Recherche

### silk

SILK (Symbolic Index for LLM Knowledge) — une architecture de recherche neuro-symbolique.

Recherche avec des entiers de 64 bits. Pas besoin de base de données vectorielle, de graphe ANN ou de modèle d'embeddings. Une seule opération AND bit à bit NumPy recherche dans 100 millions d'enregistrements, et l'affirmation centrale est que Python seul surpasse la recherche vectorielle optimisée en C++/Rust. Fournit un pipeline de requêtes hybride combinant la recherche dans les livres de codes avec l'assistance d'un LLM.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Langage | Python |
| Licence | MIT |

---

## DSL

### fullend

Full-stack SSOT Orchestrator — valide la cohérence entre 5 sources SSOT (STML, OpenAPI, SSaC, SQL DDL, Terraform) et génère du code à partir d'elles.

Appelle les outils de validation individuels de chaque couche, puis effectue une validation croisée des frontières entre couches. Après validation, orchestre la génération de code depuis sqlc, oapi-codegen, SSaC et STML, et produit le code de liaison.

| | |
|---|---|
| GitHub | [geul-org/fullend](https://github.com/geul-org/fullend) |
| Langage | Go |
| Licence | MIT |

### ssac

Service Sequences as Code — analyse la logique de service déclarative dans les commentaires Go et génère le code d'implémentation Go via CLI.

Définit les flux de service comme des commentaires structurés dans les fichiers source Go. Le CLI lit ces déclarations et génère le code d'implémentation correspondant, éliminant le code répétitif tout en gardant la logique lisible et sous contrôle de version.

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| Langage | Go |
| Licence | MIT |

### stml

SSOT Template Markup Language — liaison déclarative UI-API avec des attributs HTML5 data-*, validation symbolique contre OpenAPI et génération de code React.

Lie les templates UI aux schémas API via les attributs HTML5 data. Valide symboliquement par rapport aux spécifications OpenAPI au moment du build, puis génère des composants React typés. Une seule source de vérité du schéma à l'écran.

| | |
|---|---|
| GitHub | [geul-org/stml](https://github.com/geul-org/stml) |
| Langage | TypeScript |
| Licence | MIT |

---

## Site web

### geul-org

Le code source de ce site web.

Un générateur de sites statiques Hugo prenant en charge 12 langues. Déployé via S3 + CloudFront, avec une CloudFront Function pour la détection de la langue et les URL propres.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Langage | Hugo (Go Templates), CSS |
| Licence | MIT |
