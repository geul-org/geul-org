---
title: "Dépôts"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "Dépôts GitHub publics de GEUL : la bibliothèque Go et la CLI geul, le chargement et la conversion de Wikidata, le moteur de recherche SILK, des codebooks antérieurs à la v1 et ce site web."
image: "/images/og-default.webp"
---

Les dépôts publics de GEUL se trouvent dans l'organisation [geul-org](https://github.com/geul-org) sur GitHub. La grammaire normative est la [Grammaire GEUL](/fr/grammar/) de ce site.

Un document GEUL est une suite de WORD de 16 bits. L'unité de données est l'enregistrement, qui commence par un TAG WORD, et les enregistrements sont contenus dans un document. Les documents sont publiés par un Issuer, et chaque version est figée par un hash de contenu. Les dépôts ci-dessous sont des outils pour écrire, lire, convertir et rechercher ces documents.

---

## Bibliothèque

### gogeul

La bibliothèque Go de GEUL et l'outil en ligne de commande `geul`.

Écrit, lit, vérifie et publie des documents GEUL (`.geul`). Ses paquets fournissent la vérification de format, le décodage des enregistrements à l'aide des documents de spécification de Codec, les différences entre versions, la résolution des dépendances IMPORT et le Codec TOULMIN. La CLI `geul` couvre l'édition (`new`, `add`), la publication (`publish`), la consultation (`ls`, `log`, `show`, `diff`, `check`), une visionneuse dans le navigateur (`serve`, `build`) et les archives pack (`pack build`, `pack unpack`). Les archives pack peuvent stocker les enregistrements compressés avec zstd.

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| Langage | Go |
| Licence | CC0 |

---

## Wikidata

### wikigeul

Conversion Wikidata → GEUL (anciennement gogeulwiki).

Lit un dump Wikidata que wikipg a chargé dans PostgreSQL et publie un document GEUL par élément ou propriété, avec les libellés, descriptions, alias, déclarations avec leurs qualificatifs et références, et les liens de sites dans toutes les langues. Tous les documents sont publiés sous l'Issuer `wikidata.geul.org` (`0x00010000`).

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| Langage | Go |
| Licence | CC0 |

### wikipg

Chargement sans perte des dumps JSON de Wikidata dans PostgreSQL.

Stocke entités, libellés, descriptions, alias, déclarations, qualificatifs, références, liens de sites et Lexemes dans l'ordre du dump, et conserve chaque ligne du dump telle quelle. Le dump lui-même (fichier, URL, taille, sommes de contrôle, commit du chargeur) est aussi enregistré. wikipg ne dépend pas de GEUL.

| | |
|---|---|
| GitHub | [geul-org/wikipg](https://github.com/geul-org/wikipg) |
| Langage | Go |
| Licence | CC0 |

---

## Recherche

### silk

[SILK](/fr/projects/silk/) — un moteur d'indexation et de recherche conçu pour GEUL.

Construit des index partitionnés et triés des enregistrements d'une archive pack GEUL et répond à des requêtes comme « quels documents affirment que la profession (P106) de quelqu'un est physicien (Q169470) ? » sans décoder tous les documents. Il délimite les enregistrements et leurs champs à partir des seuls TAG WORD, sans codebook. Il est en début de développement, valide ses algorithmes de recherche, et ses formats peuvent changer avant une première version.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Langage | Go |
| Licence | CC0 |

---

## Codebooks (antérieurs à la v1)

Les deux dépôts ci-dessous ont été conçus avant la grammaire v1 actuelle. Certaines parties ne lui correspondent pas.

### sidx

Recherche sur l'attribution des SIDX (Semantic-aligned Index).

Matériel de recherche pour attribuer les SIDX, une adresse sémantique qui donne des numéros proches à des entités de sens proche, à partir des statistiques d'usage de Wikidata. Il contient l'ancien schéma d'attributs Entity sur 48 bits, des scripts d'encodage et des codebooks ; aucune attribution de SIDX n'a encore été produite. La définition normative des SIDX est [GEUL-SIDX](/fr/grammar/reference/geul-sidx/) dans la grammaire.

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| Langage | Python |
| Licence | CC0 |

### wordnet-verb

Édition provisoire d'un codebook de verbes sur 16 bits fondé sur WordNet 3.0.

Attribue un code de 16 bits à chacun des 13 767 synsets verbaux de WordNet 3.0, avec des codes proches pour des verbes de sens proche. C'est une édition provisoire destinée à être remplacée par un codebook qui n'utilise pas WordNet, et la manière de porter ces codes dans les enregistrements GEUL n'est pas décidée.

Il contient du matériel dérivé de WordNet ; ce n'est donc **pas un produit CC0.** Les parties dérivées de WordNet relèvent de la WordNet 3.0 License ; seules les parties propres au projet GEUL, comme les codes et la classification, sont en CC0.

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| Langage | Python |
| Licence | WordNet 3.0 License (parties dérivées) · CC0 (parties propres) |

---

## Site web

### geul-org

Source de ce site web, geul.org.

Site statique Hugo en 12 langues, déployé avec S3 + CloudFront.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Langage | Hugo |
| Licence | CC0 |

---

## Dépôts liés

Dépôts hors de l'organisation geul-org.

### toulmin

Un moteur de règles fondé sur le modèle d'argumentation de Toulmin (TypeScript, Python, Go, C).

Les règles sont des fonctions, et les exceptions sont des relations d'attaque dans un graphe. L'Edge [TOULMIN](/fr/grammar/edge/toulmin/) de la grammaire GEUL (codes directs `0x60`–`0x7B`) écrit ces graphes de jugement et d'exécution sous forme de documents GEUL.

| | |
|---|---|
| GitHub | [park-jun-woo/toulmin](https://github.com/park-jun-woo/toulmin) |
| Licence | MIT |
