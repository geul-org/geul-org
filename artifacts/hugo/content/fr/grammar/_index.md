---
title: "Grammaire GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Spécification de la grammaire GEUL v1. Elle définit les enregistrements sur des mots de 16 bits, les quatre Kind, la structure du document, l'Issuer et les règles de publication."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL (General Encoding Unified Language) est un langage artificiel et un format binaire permettant aux humains et à l'IA de communiquer sans ambiguïté.

Ces documents définissent la grammaire GEUL v1. La version actuelle est un brouillon antérieur à la publication et peut changer. La spécification est publiée sous [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## Vue d'ensemble {#한눈에-보기}

- Toutes les données sont une suite de **mots de 16 bits (WORD)**, écrits en big-endian.
- L'unité de données est l'**enregistrement**. Un enregistrement commence par un seul TAG WORD, et ce TAG WORD indique le type et la longueur de l'enregistrement.
- Il existe quatre types d'enregistrement (**Kind**).

| Kind | Rôle | Exemple |
|---|---|---|
| Reference | Désigne une cible | Wikidata Q42, #7 dans ce document |
| Value | Contient une valeur en tant que telle | date, quantité, texte accompagné d'une langue |
| Edge | Relie d'autres enregistrements pour énoncer quelque chose | « Q42 est une personne », « Le nom anglais de Q42 est Douglas Adams » |
| Meta | Parle du document | version de la spécification, ID du document, auteur, signature |

- Les enregistrements sont contenus dans un **document**. Comme en HTML, un document se divise en HEAD (Meta, ainsi que la provenance SOURCE de l'ensemble du document et son QUALIFIER) et BODY (Reference, Value, Edge).
- Un document est émis par un **Issuer** (l'entité émettrice) et chaque version est figée par un hachage du contenu. Une version publiée ne change pas.

## Principes de conception {#설계-원칙}

1. **On peut sauter les enregistrements sans codebook.** Le type et la longueur d'un enregistrement sont dans les 16 bits du TAG WORD. Un décodeur qui ne connaît pas la méthode d'interprétation (le codebook) peut quand même compter les enregistrements et les sauter.
2. **On consigne des énoncés, non des faits.** Un document note, avec Meta et des Edge de fondement, qui a énoncé quoi, quand et à partir de quoi.
3. **L'identification se fait par Reference.** On désigne par ID, non par nom. Le nom est attaché par un Edge.
4. **Ce qui est publié ne change pas.** Une correction paraît dans une nouvelle version. Un ID à l'intérieur d'un document désigne la même cible d'une version à l'autre.
5. **On laisse du vide.** On réserve à l'avenir la plus grande partie de l'espace de bits. Les codes directs ne peuvent pas être repris, on n'attribue donc que ceux dont la fréquence est établie.

## Documents subordonnés {#하위-문서}

Pour une première lecture, suivez le tableau de haut en bas.

| Document | Contenu |
|---|---|
| [Structure d'un enregistrement](record.md) | disposition du TAG WORD, Length, Codec, TAG d'extension |
| [Issuer et publication](issuer.md) | niveaux d'Issuer, table d'attribution des 2 WORD, mode de publication, signature, clé de vérification |
| [Adresse de publication et liste des versions](publishing.md) | notation des ID, adresse de publication, spécification de format, liste des Issuer, liste des versions, niveaux de confiance |
| [Documents de spécification de Codec](codec-spec.md) | codebook écrit avec DECLARE, FIELD, ENUM, CODEC |
| [Document ordinaire](document.md) | DOC, HEAD, BODY, END, ID du document, hachage du contenu, versions et révisions |
| [Index des codes](codec-index.md) | les 227 cases attribuées, tableaux de Codec par Kind et par famille |
| [Disposition des sections](layout.md) | 16 sections et disposition des cases, plages attribuées et Reserved |
| [Marqueur d'emplacement](slot-marker.md) | ABSENT, UNKNOWN-VALUE, NO-VALUE, règles d'acceptation |
| [Reference](reference/_index.md) | identification de la cible, LOCAL, références externes, Quantifier, marqueurs d'emplacement |
| [Value](value/_index.md) | familles de valeurs, codes directs, texte, quantité, date |
| [Meta](meta/_index.md) | structure, définition, provenance, lignée, vérification, politique, IMPORT |
| [Edge](edge/_index.md) | familles d'énoncé, de fondement, d'exécution et TOULMIN, TRIPLE, QUALIFIER, LABEL |
| [TOULMIN](toulmin/_index.md) | famille des graphes de verdict et d'exécution, dispositions NODE, LINK, SOURCE |
| [Exemple : un élément Wikidata](example.md) | lecture d'un document mot par mot |

## Ce que l'on sait sans codebook {#코덱북-없이-알-수-있는-것}

| Information | Sans codebook | Fondement |
|---|---|---|
| Kind | connu | plage de la section `w >> 9` du TAG WORD (Reference 0~2, Value 3 et 4, Edge 5~13, Meta 14 et 15) |
| Longueur totale de l'enregistrement, position du suivant | connues | Length du TAG WORD |
| Numéro de Codec | connu | TAG WORD (en format Issuer, l'Issuer et le numéro de Codec du TAG d'extension) |
| Famille, classe | en partie connues | Pour les codes directs d'Edge, seule la famille est connue par les bits. La famille des codes directs de Value et du format Issuer, ainsi que la classe de Meta, ne sont pas connues par les bits. En format Issuer, on connaît l'Issuer et le numéro de Codec. La classe de vérification de Meta est connue par `C >= 5` (`w >= 0x1E50`) de la section 15 |
| Edge Id d'un Edge | connu | le premier composant d'un Edge (sections 5~13) est toujours une Reference LOCAL |
| Marqueur d'emplacement (non noté, inconnu, aucun) | connu | le WORD vaut `0x0000`, `0x0010`, `0x0020` (Reference, C < 3, L 0). [Marqueur d'emplacement](slot-marker.md) |
| Quantifier | connu | par le décalage `C` dans la section : si `5 <= C < 30` en section 0, ou `C < 30` en section 1, alors `C % 5` |
| Longueur du TAG par Codec, début du Payload | inconnus | codebook |
| Interprétation du Payload, rôle des composants d'un Edge | inconnus | codebook |

- Un décodeur sans codebook peut sauter les enregistrements et les compter par Kind et par Codec, mais il ne peut pas suivre la structure du graphe.
- Tout décodeur doit traiter les classes structure, définition et IMPORT de Meta. Ces Codec appartiennent au codebook central de GEUL, et le décodeur les connaît par une table de numéros intégrée ([Meta](meta/_index.md)).

Les codebooks sont publiés sous forme de documents GEUL ([Documents de spécification de Codec](codec-spec.md)). Un décodeur n'a donc qu'à récupérer et lire le document de spécification dont il a besoin.

## Structure des zones {#영역-구조}

Les bits de poids fort du TAG WORD divisent les zones.

| Prefix | Zone | Part | Définition |
|---|---|---|---|
| `1` | Futur lointain | 50 % | Reserved (futur lointain). Non utilisé |
| `01` | Futur | 25 % | Reserved (futur proche). Non utilisé |
| `001` | Standard | 12,5 % | grammaire officiellement adoptée et en exploitation |
| `000` | Libre / proposition | 12,5 % | grammaire actuelle. Une fois adoptée, la disposition reste telle quelle et seul le Prefix passe à `001` |

Toute la grammaire actuelle se trouve dans la zone `000`. Tous les TAG WORD de cette spécification commencent par `000`.

- Un décodeur v1 rejette les TAG WORD dont le Prefix n'est pas `000`. Les autres zones seront fixées par les versions ultérieures.
- La zone `000` est un espace de proposition. Aucune inscription ni aucune protection n'y est appliquée pour l'instant.
