---
title: "Aperçu"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1 est une suite d'enregistrements faits de mots de 16 bits. Il existe quatre sortes d'enregistrements : Reference, Value, Edge et Meta, tous réunis dans un document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL (General Encoding Unified Language) est un langage artificiel et un format binaire qui permet aux humains et à l'IA de communiquer sans ambiguïté. Ce document définit la grammaire de GEUL v1.

## En un coup d'œil

- Toutes les données sont une suite de **mots de 16 bits (WORD)**, écrits en big-endian.
- L'unité de données est l'**enregistrement**. Un enregistrement commence par un TAG WORD, qui indique son genre et sa longueur.
- Il y a quatre sortes d'enregistrements (**Kind**).

| Kind | Rôle | Exemple |
|---|---|---|
| Reference | Désigne une cible | Q42 de Wikidata, #7 dans ce document |
| Value | Contient une valeur | Date, quantité, texte accompagné d'une langue |
| Edge | Relie d'autres enregistrements pour les décrire | « Q42 est un être humain », « Le nom anglais de Q42 est Douglas Adams » |
| Meta | Parle du document | Édition de la spécification, ID du document, auteur, signature |

- Les enregistrements sont réunis dans un **document**. Comme en HTML, un document se divise en HEAD (Meta, ainsi que le SOURCE d'origine du document entier et ses QUALIFIER) et BODY (Reference, Value, Edge).
- Un document est émis par un **Issuer** (l'entité émettrice) et chaque version est figée par son hachage du contenu. Une version publiée ne change pas.

## Principes de conception

1. **On peut sauter les enregistrements sans livre de codes.** Le genre et la longueur d'un enregistrement sont dans les 16 bits du TAG WORD. Un décodeur qui ignore la méthode d'interprétation (le livre de codes) peut quand même compter et sauter les enregistrements.
2. **On consigne des descriptions, pas des faits.** Un document indique, par des Meta et des Edge de fondement, qui a écrit la description, quand et à partir de quoi.
3. **L'identification passe par Reference.** On désigne par ID, non par nom. Les noms se rattachent par des Edge.
4. **Ce qui est publié ne change pas.** Une correction paraît comme une nouvelle version. Les ID dans un document désignent la même cible d'une version à l'autre.
5. **On laisse du vide.** La majeure partie de l'espace de bits est laissée à l'avenir. Les codes directs ne peuvent pas être repris : on n'attribue que ceux dont la fréquence est avérée.

## Structure des zones

Les bits de poids fort du TAG WORD divisent l'espace en zones.

| Prefix | Zone | Part | Définition |
|---|---|---|---|
| `1` | Futur lointain | 50 % | Réservé pour le futur lointain. Ne pas utiliser |
| `01` | Futur | 25 % | Réservé pour le futur proche. Ne pas utiliser |
| `001` | Standard | 12,5 % | Grammaire officiellement adoptée et en exploitation |
| `000` | Libre · proposition | 12,5 % | Grammaire actuelle. Une fois adoptée, la disposition reste telle quelle et seul le Prefix passe à `001` |

Toute la grammaire actuelle se trouve dans la zone `000`. Tous les TAG WORD de cette spécification commencent par `000`.

- Un décodeur v1 rejette les TAG WORD dont le Prefix n'est pas `000`. Les autres zones seront fixées par les éditions ultérieures.
- La zone `000` est un espace de proposition. Aucun enregistrement ni aucune protection ne s'y applique pour l'instant. Toutefois, la disposition des formats d'Issuer est réservée dans la perspective d'un système d'enregistrement après le lancement d'une norme officielle.

## Ce que l'on sait sans livre de codes

| Information | Sans livre de codes | Fondement |
|---|---|---|
| Kind | On le sait | TAG WORD |
| Longueur totale de l'enregistrement, position du suivant | On le sait | Length du TAG WORD |
| Numéro de Codec | On le sait | TAG WORD (pour un format d'Issuer, l'Issuer et le numéro de format du TAG d'extension) |
| Famille, classe | On le sait | Bits de poids fort du numéro de Codec ou du numéro de format |
| Edge Id d'un Edge | On le sait | Le premier composant d'un Edge est toujours une Reference LOCAL |
| Marqueurs d'emplacement (non renseigné, inconnu, aucune valeur) | On le sait | Valeur de WORD `0`~`7` (Codec de Reference `0000`, 1 WORD). [Marqueur d'emplacement](/fr/grammar/reference/slot-marker/) |
| Longueur des TAG propres au Codec, début du Payload | On ne le sait pas | Livre de codes |
| Interprétation du Payload, rôle des composants d'un Edge | On ne le sait pas | Livre de codes |

- Un décodeur sans livre de codes peut sauter les enregistrements et les compter par Kind et par Codec, mais il ne peut pas suivre la structure du graphe.
- Tout décodeur doit traiter les classes Meta de structure, de définition et d'IMPORT. Ces Codec font partie du livre de codes central de GEUL ([Meta](/fr/grammar/meta/)).

Le livre de codes est publié sous forme de documents GEUL ([Documents de spécification de Codec](/fr/grammar/codec-spec/)). Un décodeur n'a donc qu'à récupérer et lire les documents de spécification dont il a besoin.

## Pages liées

| Document | Contenu |
|---|---|
| [Enregistrement et TAG WORD](/fr/grammar/record/) | Disposition du TAG WORD, Length, Codec, TAG d'extension |
| [Document](/fr/grammar/document/) | DOC, HEAD, BODY, END, ID de document, hachage du contenu, versions et révisions |
| [Reference](/fr/grammar/reference/) | Identification des cibles, LOCAL, références externes, Quantifier, marqueurs d'emplacement |
| [Value](/fr/grammar/value/) | Familles de valeurs, codes directs, texte, quantités, dates |
| [Edge](/fr/grammar/edge/) | Familles description, fondement, exécution, TOULMIN ; TRIPLE, QUALIFIER, LABEL |
| [Meta](/fr/grammar/meta/) | Structure, définition, source, lignée, vérification, politique, IMPORT |
| [Issuer et publication](/fr/grammar/issuer/) | Niveaux d'Issuer, table des 1 WORD, mode de publication, signature, clé de vérification |
| [Adresse de publication et liste des versions](/fr/grammar/publishing/) | Notation des ID, adresse de publication, spécification de format, index des noms, liste des versions, niveaux de confiance |
| [Documents de spécification de Codec](/fr/grammar/codec-spec/) | Le livre de codes écrit avec DECLARE, FIELD, ENUM et CODEC |
| [Exemple : un élément Wikidata](/fr/grammar/example/) | Lire un document mot par mot |

## Problèmes ouverts

- Kind des cas limites. Cas où l'on hésite entre Reference, Value, Edge et Meta, comme une affirmation portant sur une affirmation.
