---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Un Edge est un enregistrement qui décrit en reliant d'autres enregistrements comme composants."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Un Edge est un enregistrement qui décrit en reliant d'autres enregistrements comme composants. Une description comme « Q42 est un être humain » ou « Le nom anglais de Q42 est Douglas Adams » est un Edge.

## Disposition {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      sections 5~13 (0x0A0L~0x1BFL)
[TAG d'extension de Length]
[TAG d'extension de Codec]  pour un format d'Issuer
Edge Id           enregistrement Reference LOCAL
composants        dans l'ordre fixé par le Codec
```

- `LLLL` est le nombre total de WORD, TAG WORD compris, moins 1. Le décodeur saute à l'enregistrement suivant avec la seule Length, sans connaître le Codec.
- **Le premier composant est toujours l'Edge Id (Reference LOCAL).** Comme c'est une Reference LOCAL (`0051` + ID, Identified `0x005L`), on peut lire l'Edge Id sans connaître le codec.
- Chaque composant trouve ses limites grâce à sa propre Length. La position atteinte après lecture du dernier composant doit coïncider exactement avec la fin de l'Edge.
- La composition (Payload) des composants est fixée par le document de chaque Codec d'Edge.
- Pour un Codec ayant des sous-formats (WORLD, TIMELINE, SCENE), 1 WORD de TAG propre au Codec indique le sous-format.
- L'ordre entre enregistrements Edge n'a pas de sens (sauf si le Codec en décide autrement, par ex. le document [TOULMIN](../toulmin/_index.md)).
- Un autre Edge est désigné par son Edge Id. Les Edge de ce document sont désignés en LOCAL, ceux d'un autre document par une Reference de désignation (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Familles {#계열}

La zone Edge est `0x0A0L~0x1BFL`. La famille d'un code direct est `(code − 0xA0) >> 5` (le code est constitué des trois premiers chiffres du TAG ID). Les familles ont 32 cases chacune et valent la section `w >> 9` moins 5. Les Edge occupent les sections 5 à 13.

| Section | Famille | Code direct | Rôle |
|---|---|---|---|
| 5 | énoncé | `0x0A0L~0x0BFL` | Compose le contenu relatif au monde et aux événements |
| 6 | fondement | `0x0C0L~0x0DFL` | D'où viennent les enregistrements et les documents ([SOURCE](0x0C0L-source.md)) |
| 7 | exécution | `0x0E0L~0x0FFL` | Structure de programme exécutable (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | Graphe d'argumentation : affirmations, réfutations, exceptions, relations d'attaque, exécution, résultats de verdict |
| 9 | format [TOULMIN](../toulmin/_index.md) | `0x120L~0x134L` | Texte source, divisions, nœuds auxiliaires et relations d'un document TOULMIN |

- Les codes directs attribués sont ces cinq familles. `0x11CL~0x11FL` est Reserved, et `0x135L~0x1BCL` est Reserved (les sections 10 à 12 sont entièrement Reserved).
- `0x1BDL~0x1BFL` (les trois dernières cases de la section 13) sont EDGE-ISSUER (voir Edge au format Issuer ci-dessous). Le format Issuer n'a pas de règle de famille.

## Edge d'énoncé {#서술-edge}

| Codec | Nom | Composants |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | Liaison orientée : Subject (Reference) désigne Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | Deux Reference désignent le même objet |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | Deux Reference désignent des objets différents |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | Lie à Subject un nom pour machine (UTF8-TEXT) |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | Nom de Subject par langue (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | Autre nom de Subject. Disposition identique à LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | Description de Subject par langue. Disposition identique à LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | Énoncé verbal |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | Une proposition (Predicate, Subject, Object) et rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | Une condition qui qualifie la proposition d'un autre Edge |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | Vision du monde, ordre des événements, structure de scène |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | Publication, recommandation de dépréciation et suppression d'une version de document ([adresse de publication et liste des versions](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | Vocabulaire pour écrire une spécification de Codec ([document de spécification de Codec](../codec-spec.md)) |

- Les formes `-SHORT` et générales sont groupées en paire pair/impair (VERB-SHORT `0x0A8L` / VERB `0x0A9L`). LABEL reçoit la langue dans un enregistrement de langue à l'intérieur d'Object (UTF8-LANGUAGE-TEXT), d'où un seul `0x0A4L`.
- PUBLICATION, DEPRECATION et TOMBSTONE servent au document de liste des versions. Comme la liste des versions doit être lisible sans codebook, ils sont intégrés au décodeur (couche 0 de l'[adresse de publication et liste des versions](../publishing.md#층)).
- DECLARE, FIELD, ENUM et CODEC sont le vocabulaire pour écrire une spécification de Codec. Comme le document de spécification doit être lisible sans codebook, leur disposition est intégrée au décodeur (couche 0). Chaque document de spécification de Codec écrit avec ce vocabulaire est un document ordinaire.

### TRIPLE {#triple}

En détail : [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[TAG d'extension de Length]
Edge Id           Reference LOCAL
Predicate         Reference (propriété Wikidata, etc.)
Subject           Reference
Object            Reference ou Value
Rank              1 WORD
```

| Rank | Nom | Sens |
|---|---|---|
| `0` | normal | par défaut |
| `1` | preferred | valeur actuelle, faisant le plus autorité |
| `2` | deprecated | valeur jugée fausse ou périmée mais conservée à titre d'archive |

- Rank est identique au statement rank de Wikidata. Une source qui n'attribue pas de rank utilise `0`.
- **Le sens d'un TRIPLE est l'ensemble de tous les QUALIFIER qui désignent son Edge Id.** Le lecteur rassemble les QUALIFIER avant d'interpréter le TRIPLE.

Exemple : Q42 — P31 (instance of) — Q5 (être humain), normal, Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

En détail : [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[TAG d'extension de Length]
Edge Id           Reference LOCAL
Property          Reference
Target            Reference LOCAL (Edge Id de l'Edge qualifié)
Value             Reference ou Value
```

- QUALIFIER fait partie de la proposition. Ce n'est pas une affirmation distincte à propos de la proposition : il qualifie la condition (instants de début et de fin, portée d'application, etc.) dans laquelle la proposition est vraie.
- Une affirmation distincte à propos de la proposition (par ex. qui l'a affirmée) s'écrit en TRIPLE.
- Target est un Edge du même document. L'ordre des QUALIFIER de même Target est leur ordre dans le document.

Exemple : Q42 — P69 (educated at) — Q691283, début (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

En détail : [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[TAG d'extension de Length]
Edge Id           Reference LOCAL
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- Le nom et la langue tiennent dans un seul Object (UTF8-LANGUAGE-TEXT).
- Il y a au plus un LABEL par Subject et par langue. Les autres noms s'écrivent en ALIAS.
- Un nom pour machine sans langue s'écrit en BIND. LABEL exige une langue.

### BIND {#bind}

En détail : [BIND](0x0A3L-bind.md)

- Lie à Subject un nom (UTF8-TEXT) auquel la machine se conforme. Il n'a pas de langue et n'est pas normalisé. Les noms sont identiques si leurs octets le sont.
- La portée du nom est le document qui contient BIND. Dans un même document, on ne lie pas le même nom à des Subject différents.
- Les autres enregistrements désignent par ID LOCAL, non par nom. Le nom sert à s'accorder avec l'extérieur (fonctions de l'hôte, saisie d'adresse, humains).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

En détail : [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE est l'identité : deux Reference désignent le même objet. Elle est réflexive, symétrique et transitive.
- DIFFERENT-NODE est la non-identité : deux Reference désignent des objets différents.
- REFERENCE-NODE est une liaison orientée qui définit par Object ce qu'est Subject (Reference). Ce n'est pas une affirmation d'identité. Exemple : définir l'URI désignée par un nœud LOCAL.

## Edge de fondement {#근거-edge}

Il attache un fondement à un enregistrement individuel dans BODY, ou à l'ensemble du document (HEAD). Le seul code direct de la famille fondement est [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | Nom | Composants |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (Edge Id de l'Edge BODY auquel on attache le fondement ; dans HEAD, `0` = l'ensemble du document), Origin (Reference d'origine, ABSENT ou UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- Les propriétés de l'origine elle-même (URL, titre, auteur, date de publication …) s'écrivent en TRIPLE ayant l'origine pour Subject ; celles de la citation (date de consultation, position dans l'origine …) en QUALIFIER ayant l'Edge Id de SOURCE pour Target.
- L'origine de l'ensemble du document s'écrit dans HEAD en SOURCE de Target `0`, et le QUALIFIER qui l'a pour Target se place aussi dans HEAD. Ce sont les seuls Edge présents dans HEAD, et les Edge Id de HEAD et de BODY partagent un seul espace de numéros ([provenance de l'ensemble du document](0x0C0L-source.md#문서-전체의-출처)).
- Les autres fondements (portée du texte source, auteur, fiabilité, période d'application par article, anciens enregistrements) s'écrivent en QUALIFIER, et la première version où ils sont entrés se calcule à partir de l'historique des versions ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- Le résultat de jugement par enregistrement relève de `VERDICT` de TOULMIN.

### SOURCE {#source}

En détail : [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[TAG d'extension de Length]
Edge Id           Reference LOCAL
Target            Reference LOCAL (Edge Id de l'Edge BODY auquel on attache le fondement ; dans HEAD, 0 = l'ensemble du document)
Origin            Reference ou marqueur d'emplacement 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

Exemple : origine du TRIPLE `#178` Q42 P19, Britannica (Q5375741), identifiant P1417 à l'intérieur

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge d'exécution {#실행-edge}

Structure de programme non liée à un langage de programmation particulier. Les composants sont désignés par les ID LOCAL de ce document.

| Groupe | Codec |
|---|---|
| déclaration | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| expression | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| instruction | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| erreur | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- Ce n'est pas un format qui contient tel quel le code d'un langage externe. Le code d'un langage externe se place au format Issuer.
- Les composants sont désignés par l'ID LOCAL (REF) de ce document. À l'emplacement d'une expression, on place un Edge d'expression ou un symbole. REF `0` signifie absence.
- Une expression produit une valeur, une instruction non. Une expression peut se placer à l'emplacement d'instruction d'un BLOCK (la valeur est écartée).
- Le `for` de style C s'écrit en BLOCK (initialisation, WHILE), et `else if` en IF à l'emplacement faux.
- Un symbole est un ID LOCAL, et son nom est lié par BIND. Les autres enregistrements désignent un symbole par ID LOCAL, non par nom. Même si les noms sont identiques, des ID LOCAL différents sont des symboles différents.
- Ce qu'est un symbole (variable, paramètre, fonction, type) est fixé par l'enregistrement qui le désigne. Un symbole sans définition dans le document est fourni par l'extérieur (l'hôte) ; s'il est la cible d'un CALL, c'est une fonction de l'hôte.

Problèmes ouverts : codes d'opérateur, représentation des types, disposition du Payload de chaque Codec.

## Edge TOULMIN {#toulmin-edge}

Il écrit un graphe de jugement et d'exécution avec le modèle d'argumentation de Toulmin. Les codes directs sont `0x100L~0x11BL`, et les enregistrements auxiliaires appartiennent à la famille de format TOULMIN `0x120L~0x134L`. En détail : [TOULMIN](../toulmin/_index.md)

## Edge au format Issuer {#issuer-형식-edge}

Un Issuer peut définir et utiliser ses propres formats d'Edge ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md), [4WORD](0x1BEL-edge-issuer-4word.md), [16WORD](0x1BFL-edge-issuer-16word.md), Codec `0x1BDL`~`0x1BFL`). Ce sont les trois dernières cases de la zone Edge. Le TAG d'extension de Codec contient 2 WORD : l'Issuer et le numéro de codec. L'Edge Id est le premier élément du Payload qui suit (TAG, Issuer, numéro de codec, Edge Id, reste du Payload). Le numéro de codec est fixé par l'Issuer et n'a pas de règle de famille. Quel que soit le Kind, il n'est pas dupliqué dans le `codecs/` de cet Issuer. Le document du codec se place sous le `codecs/` de cet Issuer, sous le numéro de codec de l'enregistrement ([adresse de publication et liste des versions](../publishing.md)).

- Il n'y a actuellement aucun format Edge ISSUER répertorié.
