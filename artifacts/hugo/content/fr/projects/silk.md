---
title: "SILK — Moteur d'indexation et de recherche pour GEUL"
weight: 1
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SILK", "recherche", "index", "GEUL", "Go"]
summary: "Moteur qui indexe et interroge les archives GEUL pack enregistrement par enregistrement. Les données étant structurées dès l'écriture, la recherche se réduit à des comparaisons d'entiers et à des parcours d'intervalles. Requêtes de 0,1 à 4 ms sur Wikidata Q1–Q10000."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
aliases:
  - /fr/silk/
---

SILK est un **moteur d'indexation et de recherche dédié à GEUL**. Sans décoder entièrement les documents GEUL, il répond à l'aide des seuls index d'enregistrements à des requêtes comme « quels documents affirment que l'occupation (P106) est physicien (Q169470) ? ».

| | |
|---|---|
| État | Développement initial. Les algorithmes de recherche sont en cours de validation, et les formats peuvent changer avant la première version |
| Langage | Go |
| Entrée | Archives GEUL pack (non compressées) |
| Licence | CC0 |
| Dépôt | <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a> |

## Thèse centrale

Ce n'est pas la recherche qui est difficile : **le problème, ce sont les données sans structure**.

```
Approche classique : écrire d'abord → deviner la structure ensuite (tokenisation, embeddings, analyse)
GEUL :               structurer à l'écriture → la recherche se réduit à comparer des entiers et parcourir des intervalles
```

Un enregistrement GEUL contient déjà des champs comme le sujet, le prédicat, l'objet et la langue, sous forme d'ID entiers à des positions fixes. SILK se contente d'extraire ces champs et de les garder triés.

## Pourquoi cela convient à GEUL

| Propriété de GEUL | Ce que SILK y gagne |
|---|---|
| Un seul TAG WORD de 16 bits porte le type (Kind, Codec) et la longueur | Filtrer et sauter des enregistrements sans livre de codes |
| Les champs d'un Edge sont des enregistrements à positions fixes | Extraire les clés par position, sans règles d'analyse supplémentaires |
| Le vocabulaire contrôlé est fait d'ID entiers (Q, P, langue) | Tester l'égalité sur des entiers, sans normalisation de chaînes |
| Un pack se compose d'objets immuables et de générations | L'index est lui aussi bâti sur des segments immuables et des générations, d'où des instantanés sûrs |
| La conversion est déterministe | Une même entrée donne un même index. Le résultat incrémental peut être comparé octet par octet à un index construit de zéro |

Les documents GEUL ne sont jamais retriés. L'index n'est qu'une **vue (view)** triée ; les octets publiés, les hachages de contenu et les signatures restent inchangés.

## Architecture

### Entrée

Les archives GEUL pack sont lues via [gogeul](https://github.com/geul-org/gogeul). Comme l'index pointe vers des positions d'octets dans les data packs, le jeu doit stocker les enregistrements sans compression (`GEULCOMPRESS=none`). La compression zstd sert à la distribution et à l'archivage ; la couche de recherche utilise des packs non compressés.

### Spécification des partitions

Pour chaque type de TAG, une **clé de partition** et une **clé de tri** sont déclarées comme champs à position fixe de l'enregistrement. Rien n'est codé en dur, ni prédicat ni langue ; le tableau ci-dessous donne les valeurs par défaut pour les documents Wikidata.

| TAG | Clé de partition | Clé de tri |
|---|---|---|
| TRIPLE | Prédicat (Predicate) | Objet (Object) |
| QUALIFIER | Propriété (Property) | Valeur (Value) |
| LABEL·ALIAS·DESCRIPTION | Langue | Sujet (Subject) |
| SOURCE | aucune | Origine (Origin) |
| REFERENCE-NODE | aucune | Objet (Object) |

- Une clé correspond aux premiers octets (un slot) de l'enregistrement de champ. Si l'enregistrement tient dans le slot, l'égalité est exacte ; s'il est plus long, la clé ne fait que sélectionner des candidats.
- La validation de la spécification refuse comme clé de partition un champ dont la position nécessite un livre de codes, ou un champ de longueur illimitée.
- Une spécification est identifiée par le hachage de son contenu. Si elle change, seul le TAG concerné est reconstruit.

### Runs, incréments et fusion

| Élément | Rôle |
|---|---|
| Run trié | Segment immuable trié par (clé de tri, document, décalage) dans chaque partition. Interrogé par recherche dichotomique |
| Segment ajouté | Ne contient que les nouvelles révisions issues d'une mise à jour incrémentale (`silk index update`). Parcouru séquentiellement |
| Bitmap des révisions vivantes | Marque comme mortes les anciennes révisions des documents modifiés au lieu de les supprimer |
| Fusion par paliers de taille | Fusionne les runs d'un même palier de taille par une fusion en O(n) et, si les lignes mortes s'accumulent, fusionne jusqu'au run de base |
| Génération | La génération du manifeste est remplacée de façon atomique. Les lecteurs figent une génération, si bien que l'instantané tient même pendant une fusion |

La fusion peut être limitée aux périodes d'inactivité (`-idle`, en laissant 30 % du CPU et de la mémoire libres). Elle s'arrête aux frontières de partition et reprend à partir d'un point de contrôle.

### Requêtes

1. **Condition d'égalité** : trouver la partition, puis faire une recherche dichotomique dans les runs triés.
2. **Conditions multiples** : jointure par fusion (merge join) sur le document (sujet). Toutes les conditions doivent être vérifiées au sein d'un même document.
3. **Vérification précise** : décoder les enregistrements candidats avec gogeul, les comparer champ par champ et lire l'Edge Id.

```sh
silk query -triple P106=Q169470 ARCHIVE
silk query -count -triple P31=Q5 -triple P106=Q169470 ARCHIVE
silk query -label ko -match LABEL:1=Q42 ARCHIVE
```

## Mesures

Mesuré sur Wikidata Q1–Q10000 et 16 696 documents de propriétés (271 Mo, 7,07 millions d'enregistrements d'index). 8 threads, meilleur résultat sur 7 exécutions, hors temps de démarrage du processus.

### Requêtes

| Requête | Documents trouvés | Méthode précédente (parcours complet) | Index SILK |
|---|---:|---:|---:|
| P106=Q169470 (occupation = physicien) | 55 | ~20ms | 0,12ms |
| P31=Q5 (être humain) | 1 579 | ~19ms | ~1ms |
| être humain + physicien | 54 | ~38ms | ~1ms |
| LABEL ko | 9 746 | (impossible) | ~4ms |

- La méthode précédente parcourait entièrement la table des enregistrements TRIPLE.
- Pour LABEL ko, l'essentiel du temps sert à lire les 9 746 enregistrements dans le pack pour la vérification précise.

### Taille, construction et incréments

| Élément | Valeur |
|---|---|
| Taille de l'index | 113MB (15,7B par enregistrement en moyenne) |
| Construction | ~3 secondes (analyse des documents sur un seul thread) |
| Mise à jour incrémentale (4 217 révisions modifiées) | 1,8 seconde |
| Résultat incrémental | Après 2 mises à jour, 2 fusions et une interruption suivie d'une reprise, les résultats des requêtes sont identiques octet par octet à ceux d'un index construit de zéro |
| Amplification d'écriture | 1,31 en cumulé (1,71 en reconstruisant à chaque fois) |

- Extrapolé à l'ensemble de Wikidata (environ 7,5 milliards d'enregistrements), l'index ferait environ 110 Go (**estimation**).
- Le coût, c'est la taille : environ 4 fois celle d'une simple table à 4 o par enregistrement. La réduction de la largeur des slots et les signatures d'entités sont les prochains sujets d'étude.

### Balayage de signatures (mesure préalable pour les signatures d'entités)

Temps ramené au balayage de 100 millions de signatures de 128 bits avec masque et motif (i7-14700K, AVX2).

| Implémentation | Temps |
|---|---:|
| NumPy, 1 thread | ~1 s |
| Go, 1 thread | ~134ms |
| Go, 8 threads | ~27ms |
| Go, 16–20 threads | ~23ms (limite de bande passante mémoire) |

Ce qui fait la différence, ce n'est pas le langage, mais **des boucles fusionnées sans tableaux intermédiaires, et le multithreading**.

## Rapport avec la recherche vectorielle

Il s'agit d'une répartition des rôles, pas d'un remplacement.

| | SILK | Recherche vectorielle |
|---|---|---|
| Requêtes traitées | Requêtes structurées (conditions sur prédicat, objet, langue, entité) | Similarité sémantique difficile à exprimer par une structure |
| Résultat | L'ensemble qui satisfait les conditions (exact) | Un classement par similarité (approché) |
| Prérequis | Les données doivent être structurées en GEUL | Le texte source ou des embeddings suffisent |

Pour les requêtes qui cherchent des faits exprimés en GEUL, SILK est exact et peu coûteux. Pour du texte source non structuré ou pour trouver « quelque chose de similaire », la recherche vectorielle convient mieux.

## Positionnement et prochaines étapes

SILK est **la technologie de recherche utilisée par le WMS (le coordinateur de stockage et de restitution de GEUL)**. Juger si une affirmation retrouvée est correcte relève d'un moteur d'évaluation distinct.

| Prochaine étape | Contenu |
|---|---|
| Signatures d'entités | Une chaîne de bits de largeur fixe de 16 à 128 bits par entité. L'utilisateur déclare les champs (énumération, one-hot, Bloom, préfixe, intervalle). C'est un premier filtre approché, suivi d'une vérification précise. Actuellement au stade de la planification (en partie dans la bibliothèque, pas encore dans l'index) |
| Spécification sous forme de document GEUL | Déclarer la spécification JSON comme document GEUL et lire la disposition dans les documents de spécification de codec (DECLARE, FIELD) |
| Index d'assemblage des affirmations | Index Target qui retrouve directement le TRIPLE désigné par un QUALIFIER ou un SOURCE |
| Préparation au passage à l'échelle | Plafonds mémoire pour la construction et la fusion, parallélisation de l'analyse lors de la construction |

La conception initiale (2026-03) reposait sur Python et NumPy et balayait des identifiants d'entités de 64 bits par un ET bit à bit. C'est désormais un moteur Go qui indexe directement les enregistrements GEUL.

## Dépôt et licence

- Dépôt : <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a>
- Installation : `go install github.com/geul-org/silk/cmd/silk@latest`
- Licence : notre propre travail est sous CC0 1.0. Les composants tiers suivent leurs propres licences (NOTICE du dépôt).
