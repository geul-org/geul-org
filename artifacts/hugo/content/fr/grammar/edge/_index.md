---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Un Edge est un enregistrement qui relie des Reference, des Value et d'autres Edge pour les décrire. Son premier composant est toujours l'Edge Id, et les 2 bits de poids fort du Codec forment la famille (description, fondement, exécution, TOULMIN)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Un Edge est un enregistrement qui relie d'autres enregistrements comme composants pour les décrire. Une description comme « Q42 est un être humain » ou « Le nom anglais de Q42 est Douglas Adams » est un Edge.

## Disposition

```
TAG WORD          0001 0LLL LCCC CCCC
[TAG d'extension de Length]
[TAG d'extension de Codec]  pour un format d'Issuer
Edge Id           enregistrement Reference LOCAL
Composants        dans l'ordre fixé par le Codec
```

- `LLLL` est le nombre total de WORD, TAG WORD compris, moins 1. Le décodeur saute à l'enregistrement suivant avec la seule Length, sans connaître le Codec.
- **Le premier composant est toujours l'Edge Id (Reference LOCAL).** C'est une Reference LOCAL (`0088` + ID, Quantifier `000`), on peut donc lire l'Edge Id sans connaître le codec.
- Chaque composant trouve ses limites grâce à sa propre Length. La position atteinte après lecture du dernier composant doit coïncider exactement avec la fin de l'Edge.
- La composition (Payload) des composants est fixée par le document de chaque Codec d'Edge.
- Pour un Codec ayant des sous-formats (WORLD, TIMELINE, SCENE), 1 WORD de TAG propre au Codec indique le sous-format.
- L'ordre entre enregistrements Edge n'a pas de sens (sauf si le Codec en décide autrement, par ex. les documents [TOULMIN](/fr/grammar/edge/toulmin/)).
- Un autre Edge se désigne par son Edge Id. Les Edge de ce document par LOCAL, ceux d'un autre document par une Reference de pointeur (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Familles

| 2 bits de poids fort | Famille | Code direct | Rôle |
|---|---|---|---|
| `00` | Description | `0x00`~`0x1F` | Compose les contenus sur le monde et les événements |
| `01` | Fondement | `0x20`~`0x3F` | D'où viennent les enregistrements et les documents ([SOURCE](/fr/grammar/edge/source/)) |
| `10` | Exécution | `0x40`~`0x5F` | Structure de programme exécutable (AST) |
| `11` | [TOULMIN](/fr/grammar/edge/toulmin/) | `0x60`~`0x7B` | Graphe d'argumentation : assertions, réfutations, exceptions, relations d'attaque, exécution, résultats de jugement |

## Edge de description

| Codec | Nom | Composants |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/fr/grammar/edge/reference-node/) | Liaison orientée : le Subject (Reference) désigne l'Object |
| `0x01` | [SAME-NODE](/fr/grammar/edge/same-node/) | Deux Reference désignent la même cible |
| `0x02` | [DIFFERENT-NODE](/fr/grammar/edge/different-node/) | Deux Reference désignent des cibles différentes |
| `0x03` | [BIND](/fr/grammar/edge/bind/) | Lie au Subject un nom pour la machine (UTF8-TEXT) |
| `0x04` | [LABEL](/fr/grammar/edge/label/) | Nom du Subject par langue (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/fr/grammar/edge/alias/) | Autre nom du Subject. Disposition identique à LABEL |
| `0x06` | [DESCRIPTION](/fr/grammar/edge/description/) | Description du Subject par langue. Disposition identique à LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | Description verbale |
| `0x0A` | [TRIPLE](/fr/grammar/edge/triple/) | Une proposition (Predicate, Subject, Object) et rank |
| `0x0B` | [QUALIFIER](/fr/grammar/edge/qualifier/) | Une condition qui restreint la proposition d'un autre Edge |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | Vision du monde, ordre des événements, structure de scène |
| `0x18`~`0x1A` | [PUBLICATION](/fr/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | Publication, recommandation d'abandon et suppression d'une version de document ([Adresse de publication et liste des versions](/fr/grammar/publishing/#liste-des-versions)) |
| `0x1B`~`0x1E` | [DECLARE](/fr/grammar/edge/declare/) / [FIELD](/fr/grammar/edge/field/) / [ENUM](/fr/grammar/edge/enum/) / [CODEC](/fr/grammar/edge/codec/) | Vocabulaire pour écrire les spécifications de Codec ([Documents de spécification de Codec](/fr/grammar/codec-spec/)) |

- La forme `-SHORT` et la forme ordinaire sont placées en paire paire/impaire (VERB-SHORT `0x08` / VERB `0x09`). LABEL reçoit la langue dans un enregistrement de langue de l'Object (UTF8-LANGUAGE-TEXT), donc n'emploie que `0x04`.
- PUBLICATION, DEPRECATION et TOMBSTONE sont employés par les documents de liste des versions. Comme la liste des versions doit pouvoir se lire sans livre de codes, ils sont intégrés au décodeur (couche 0 de [Adresse de publication et liste des versions](/fr/grammar/publishing/#couches)).
- DECLARE, FIELD, ENUM et CODEC sont le vocabulaire pour écrire les spécifications de Codec. Comme il faut pouvoir lire les documents de spécification sans livre de codes, leur disposition est intégrée au décodeur (couche 0). Chaque document de spécification de Codec écrit avec ce vocabulaire est un document ordinaire.

### TRIPLE

Détails : [TRIPLE](/fr/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[TAG d'extension de Length]
Edge Id           Reference LOCAL
Predicate         Reference (propriété Wikidata, etc.)
Subject           Reference
Object            Reference ou Value
Rank              1 WORD
```

| Rank | Nom | Sens |
|---|---|---|
| `0` | normal | Par défaut |
| `1` | preferred | Valeur actuelle, la plus autorisée |
| `2` | deprecated | Valeur jugée fausse ou périmée mais conservée comme trace |

- Rank est identique au statement rank de Wikidata. Pour une source qui n'attribue pas de rank, on emploie `0`.
- **Le sens d'un TRIPLE est l'ensemble de tous les QUALIFIER qui désignent son Edge Id.** Avant d'interpréter un TRIPLE, le lecteur rassemble les QUALIFIER.

Exemple : Q42 — P31 (instance of) — Q5 (être humain), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

Détails : [QUALIFIER](/fr/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[TAG d'extension de Length]
Edge Id           Reference LOCAL
Property          Reference
Target            Reference LOCAL (Edge Id de l'Edge restreint)
Value             Reference ou Value
```

- Un QUALIFIER fait partie de la proposition. Ce n'est pas une affirmation séparée sur la proposition, mais une restriction des conditions où elle est vraie (date de début ou de fin, étendue d'application, etc.).
- Une affirmation séparée sur la proposition (qui l'a affirmée, etc.) s'écrit par un TRIPLE.
- Le Target est un Edge du même document. L'ordre des QUALIFIER d'un même Target est leur ordre dans le document.

Exemple : Q42 — P69 (educated at) — Q691283, début (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

Détails : [LABEL](/fr/grammar/edge/label/), [ALIAS](/fr/grammar/edge/alias/), [DESCRIPTION](/fr/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[TAG d'extension de Length]
Edge Id           Reference LOCAL
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- Le nom et la langue tiennent dans un seul Object (UTF8-LANGUAGE-TEXT).
- Il y a au plus un LABEL par Subject et par langue. Les autres noms s'écrivent par ALIAS.
- Un nom pour la machine, sans langue, s'écrit par BIND. LABEL doit avoir une langue.

### BIND

Détails : [BIND](/fr/grammar/edge/bind/)

- Lie au Subject un nom (UTF8-TEXT) auquel la machine se conforme. Sans langue ni normalisation. Deux noms ne sont les mêmes que si leurs octets sont identiques.
- La portée d'un nom est le document qui contient le BIND. Dans un document, on ne lie pas le même nom à un autre Subject.
- Les autres enregistrements désignent par LOCAL ID, non par nom. Le nom sert à s'accorder avec l'extérieur (fonctions hôtes, saisie d'adresses, humains).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

Détails : [SAME-NODE](/fr/grammar/edge/same-node/), [DIFFERENT-NODE](/fr/grammar/edge/different-node/), [REFERENCE-NODE](/fr/grammar/edge/reference-node/)

- SAME-NODE est l'identité : deux Reference désignent la même cible. Elle est réflexive, symétrique et transitive.
- DIFFERENT-NODE est la non-identité : deux Reference désignent des cibles différentes.
- REFERENCE-NODE est une liaison orientée qui définit par l'Object ce qu'est le Subject (Reference). Ce n'est pas une affirmation d'identité. Exemple : définir l'URI que désigne un nœud LOCAL.

## Edge de fondement

Attache un fondement à un enregistrement individuel du BODY, ou au document entier (HEAD). Le seul code direct de la famille fondement est [SOURCE](/fr/grammar/edge/source/) (`0x20`).

| Codec | Nom | Composants |
|---|---|---|
| `0x20` | [SOURCE](/fr/grammar/edge/source/) | Target (Edge Id de l'Edge du BODY auquel on attache le fondement ; dans le HEAD, `0` = document entier), Origin (Reference d'origine, ABSENT ou UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- Les propriétés de l'origine elle-même (URL, titre, auteur, date de publication …) s'écrivent par un TRIPLE dont l'origine est le Subject, celles de la citation (date de consultation, emplacement dans l'origine …) par un QUALIFIER ayant l'Edge Id du SOURCE pour Target.
- L'origine du document entier s'écrit dans le HEAD par un SOURCE de Target `0`, et le QUALIFIER qui l'a pour Target se place aussi dans le HEAD. Ce sont les seuls Edge admis dans le HEAD, et les Edge Id du HEAD et du BODY partagent un seul espace de numéros ([Origine du document entier](/fr/grammar/edge/source/#origine-du-document-entier)).
- Les autres fondements (étendue dans le texte d'origine, auteur, confiance, période d'application par article, anciens enregistrements) s'écrivent par QUALIFIER, et la version d'entrée initiale se calcule à partir de l'historique des versions ([SOURCE](/fr/grammar/edge/source/#expression-des-autres-fondements)).
- Le résultat de jugement par enregistrement relève de TOULMIN `VERDICT`.

### SOURCE

Détails : [SOURCE](/fr/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[TAG d'extension de Length]
Edge Id           Reference LOCAL
Target            Reference LOCAL (Edge Id de l'Edge du BODY auquel on attache le fondement ; dans le HEAD, 0 = document entier)
Origin            Reference ou marqueur d'emplacement 0x0000 ABSENT, 0x0001 UNKNOWN-VALUE
```

Exemple : origine du TRIPLE `#178` de Q42 P19, l'Encyclopædia Britannica (Q5375741), et son identifiant P1417 dans celle-ci

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge d'exécution

Structure de programme non liée à un langage de programmation particulier. Les composants se désignent par les LOCAL ID de ce document.

| Groupe | Codec |
|---|---|
| Déclarations | FUNCTION-DECLARE, TYPE-DECLARE |
| Expressions | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| Instructions | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| Erreurs | RAISE, TRY |

- Ce n'est pas un format qui contient tel quel du code d'un langage externe. Le code d'un langage externe se place en format d'Issuer.
- Les composants se désignent par les LOCAL ID (REF) de ce document. À une place d'expression, on met un Edge d'expression ou un symbole. REF `0` signifie aucun.
- Une expression produit une valeur, une instruction non. Une expression peut se placer à une place d'instruction d'un BLOCK (la valeur est jetée).
- Le `for` du C s'écrit par BLOCK (initialisation, WHILE), et `else if` par un IF à la place du faux.
- Un symbole est un LOCAL ID, et son nom se lie par BIND. Les autres enregistrements désignent un symbole par LOCAL ID, non par nom. Deux symboles de même nom mais de LOCAL ID différents sont différents.
- Ce qu'est un symbole (variable, paramètre, fonction, type) est fixé par l'enregistrement qui le désigne. Un symbole sans définition dans le document est fourni par l'extérieur (l'hôte), et s'il est la cible d'un CALL, c'est une fonction hôte.

Problèmes ouverts : codes d'opérateurs, représentation des types, disposition du Payload de chaque Codec.

## Edge TOULMIN

Détails : [TOULMIN](/fr/grammar/edge/toulmin/)

Écrit des graphes de jugement et d'exécution selon le modèle d'argumentation de Toulmin. C'est la famille centrale qui permet à GEUL de décrire ses propres règles en GEUL et de se corriger lui-même.

| Groupe | Codec |
|---|---|
| Déclarations | CASE-DECLARE (cas), [PREDICATE-DECLARE](/fr/grammar/edge/toulmin/expr/) (prédicat), SPEC-DECLARE (critère de jugement), RULE-DECLARE (assertion), COUNTER-DECLARE (réfutation), EXCEPT-DECLARE (exception) — [NODE](/fr/grammar/edge/toulmin/node/) |
| Relations | ATTACKS (attaque), SUPERSEDES (exclusion) — [LINK](/fr/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN (chaîne de priorité, disposition non fixée) |
| Exécution | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/fr/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/fr/grammar/edge/toulmin/node/) |
| Résultats | VERDICT (résultat de jugement : Pass, Review, Fail), EVIDENCE (preuve du jugement) — disposition non fixée |

- Le texte original, les sections, les nœuds auxiliaires et les relations sont des formats ISSUER de l'Issuer GEUL (`0xC000`~`0xC029`) ([SOURCE et sections](/fr/grammar/edge/toulmin/source/)).
- Le résultat de jugement se place dans un autre document que la cible du jugement. Le document de résultat importe et désigne le document cible. Juger ne change donc pas le hachage du contenu du document cible.

## Edge de format d'Issuer

Un Issuer peut définir et employer ses propres formats d'Edge (Codec `0x7C`~`0x7F`). Les codes directs `0x7C`~`0x7F` sont dans la plage TOULMIN mais sont des codes ISSUER communs, et la famille se fixe par les 2 bits de poids fort du numéro de format.

| Issuer | Numéro de format | Nom | Famille |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/fr/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/fr/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/fr/grammar/edge/toulmin/link/) | TOULMIN |
