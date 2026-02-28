---
title: "Dépôts"
date: 2026-02-28T12:00:00+09:00
summary: "Les dépôts GitHub qui composent le projet GEUL. Conception du langage, pipeline d'encodage, moteur de recherche et site web."
image: "/images/og-default.webp"
---

Le projet GEUL se compose de quatre dépôts.

Concevoir le langage (geul), encoder les entités du monde en 64 bits (geul-sidx), rechercher dans cet index (silk), et expliquer pourquoi tout cela est nécessaire (geul-org).

---

## geul

Un langage artificiel sémantiquement aligné et un format de flux binaire pour l'IA.

Un système linguistique de 2 octets (65 536 symboles) conçu pour une communication sans ambiguïté entre humains et IA. Chaque énoncé porte sa source, son horodatage et son niveau de confiance. Chaque entité a un identifiant unique. Le format de flux opère en unités de 16 bits, définissant 10 types de paquets (Verb Edge, Entity Node, Triple Edge, etc.) sous un schéma de préfixe de 10 bits.

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| Langage | Go, Python |
| Licence | MIT |

---

## geul-sidx

Constructeur de livres de codes et pipeline d'encodage SIDX (Semantic-aligned Index).

Encode 108,8 millions d'entités Wikidata en identifiants structurés de 64 bits. Définit 63 types d'entités, conçoit des schémas d'attributs de 48 bits par type, construit des livres de codes et valide les résultats d'encodage (VALID). Le producteur des index et livres de codes consommés par SILK.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| Langage | Python |
| Licence | MIT |

---

## silk

SILK (Symbolic Index for LLM Knowledge) — une architecture de recherche neuro-symbolique.

Recherche avec des entiers de 64 bits. Pas besoin de base de données vectorielle, de graphe ANN ou de modèle d'embeddings. Une seule opération AND bit à bit NumPy recherche dans 100 millions d'enregistrements, et l'affirmation centrale est que Python seul surpasse la recherche vectorielle optimisée en C++/Rust. Fournit un pipeline de requêtes hybride combinant la recherche dans les livres de codes avec l'assistance d'un LLM.

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| Langage | Python |
| Licence | MIT |

---

## geul-org

Le code source de ce site web.

Un générateur de sites statiques Hugo prenant en charge 12 langues. Déployé via S3 + CloudFront, avec une CloudFront Function pour la détection de la langue et les URL propres.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| Langage | Hugo (Go Templates), CSS |
| Licence | MIT |
