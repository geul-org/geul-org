---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC est un Edge de description (Codec 0x1E) qui désigne un Kind·Codec admis par un FIELD. Les jokers et les marqueurs d'emplacement (0x0000 non renseigné, 0x0001 inconnu, 0x0002 aucune valeur) se déclarent aussi par lui."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC est un Edge de description qui désigne un Kind·Codec admis par un [FIELD](/fr/grammar/edge/field/). Codec `0x1E`.

De même que [ENUM](/fr/grammar/edge/enum/) donne un sens à une valeur de code d'un champ en valeur brute, CODEC attache un format à un champ. Comme il y en a un par Edge, on peut en désigner plusieurs. Sa disposition est intégrée au décodeur ([Documents de spécification de Codec](/fr/grammar/codec-spec/)).

## Disposition

```
TAG WORD          0001 0LLL L001 1110
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Champ             enregistrement Reference LOCAL désignant un Edge FIELD
Cible             1 WORD. 000K KLLL LCCC CCCC (LLLL = 0000 exact, 1111 joker)
```

## WORD cible

- On garde tels quels les emplacements Kind (`KK`) et Codec (`CCCCCCC`) du TAG WORD. Les 3 bits de poids fort valent 0. `LLLL` vaut `0000` (exact) ou `1111` (joker) ; toute autre valeur est invalid.
- Une cible exacte (`LLLL = 0000`) a la même valeur que l'ID du document de spécification du Codec (par ex. LOCAL `0x0008`, COORDINATE-EARTH `0x0804`, UTF8-LANGUAGE-TEXT `0x084A`). La cible désigne donc directement le document de spécification de ce Codec.
- Les paires de codes pair/impair (texte, suites d'octets) se désignent aussi par des codes exacts. Pour accepter le pair et l'impair, on met les deux. Il n'y a pas de règle d'interprétation groupant les paires (il existe des codes adjacents qui ne sont pas des paires, comme NUMERIC `0x04`/`0x05`).

### Joker (`LLLL = 1111`)

- Le Kind doit être le même, et **les groupes de bits de Codec à 0 acceptent n'importe quoi**. Pour Reference, `CCCC` (Codec) et `QQQ` (Quantifier) sont des groupes distincts ; pour les autres Kind, les 7 bits forment un seul groupe.

| Cible | Sens |
|---|---|
| `0780` | Toute Reference |
| `07A0` | WIKIDATA-QID, quel que soit le Quantifier |
| `0781` | Tout Codec de Reference, Quantifier Generic (`001`) |
| `0F80` | Toute Value |
| `1780`, `1F80` | Tout Edge, tout Meta |

- Un joker qui n'a rien à faire correspondre est invalid. Pour Value, Edge et Meta, le Codec doit être 0, et pour Reference, `CCCC` ou `QQQ` doit être 0. Le Codec de Reference `CCCC = 0000` (marqueurs d'emplacement) étant réservé, **aucun joker ne lui correspond** (`0780` n'admet ni ABSENT, ni UNKNOWN-VALUE, ni NO-VALUE). En revanche, pour les Kind dont le Codec 0 est attribué, comme Value `0x00` (BOOL) et Edge `0x00` (REFERENCE-NODE), le joker les inclut (pour n'accepter que BOOL, `LLLL = 0000`).
- Un joker ne désigne pas de document de spécification.
- Il n'existe pas d'expression qui fixe un seul groupe non nul en laissant les groupes à 0 fixés, comme « toute Reference d'Identified seulement ». Une telle liste énumère des cibles exactes.
- Les 7 bits de Codec de Reference contiennent le Quantifier (`QQQ`). La cible précise le Quantifier exactement. Pour accepter plusieurs Quantifier, on place plusieurs CODEC.

### Marqueur d'emplacement (cible `0000`~`0002`)

Les [marqueurs d'emplacement](/fr/grammar/reference/slot-marker/) sont un lot d'enregistrements de 1 WORD du Codec de Reference réservé `0000`. Les 3 bits de poids faible sont le numéro du marqueur (et non un Quantifier).

| Cible | Marqueur | Sens |
|---|---|---|
| `0000` | ABSENT | Non renseigné. Ce champ est un champ facultatif |
| `0001` | UNKNOWN-VALUE | Inconnu. Reçoit l'affirmation qu'une valeur existe |
| `0002` | NO-VALUE | Aucune valeur. Reçoit l'affirmation qu'il n'y a pas de valeur |
| `0003`~`0007` | Réservé | |

- **Règle d'admission :** un marqueur n'est valide que si la liste CODEC du champ comprend le même WORD comme cible exacte. Les jokers et les champs d'enregistrement sans CODEC (« n'importe quel enregistrement ») ne reçoivent pas de marqueur. Un marqueur sur une place d'enregistrement du HEAD ou du BODY ou sur une place d'Edge Id est invalid.
- Une liste ne contenant que des cibles de marqueur (toujours des marqueurs) est invalid (généralisation de la règle de la liste ne contenant que `0000`). On l'emploie avec un joker ou une cible exacte (`0780` + `0000` = toute Reference, ou omission).
- On ne peut pas placer de cible de marqueur sur un champ en valeur brute. Une valeur brute n'a pas de TAG et sa largeur est fixée : il n'y a pas de place pour un marqueur de 1 WORD.
- Le sens d'un marqueur est fixé par la spécification du Codec qui le reçoit.

### Champ facultatif (cible `0000`)

- Si l'on place la cible `0000` dans la liste CODEC d'un champ d'enregistrement, ce champ est un **champ facultatif**. Pour l'omettre, on écrit à sa place 1 WORD `0x0000`. Cet enregistrement de 1 WORD est le marqueur d'emplacement ABSENT (non renseigné).
- `0x0000` est le Codec de Reference `0000` (réservé), numéro de marqueur `000`, `LLLL = 0000` (1 WORD au total). Il ne se confond avec aucun autre enregistrement, et un décodeur qui ignore la spécification le saute comme enregistrement de 1 WORD.
- Un champ facultatif occupe toujours sa place. Pour l'omettre, il faut obligatoirement écrire `0x0000` sans laisser la place vide (même pour un champ final). Il n'y a ainsi qu'une notation par enregistrement et la décomposition ne dépend que de la position. Aucune contrainte sur la position et le nombre de champs facultatifs, ni sur le recouvrement des listes avec d'autres champs.
- ABSENT n'est valide qu'à la place d'un champ facultatif. `0x0000` sur une place d'enregistrement du HEAD ou du BODY, sur la place d'un champ obligatoire ou sur la place d'un Edge Id est invalid.
- Omettre, c'est « non renseigné », non « aucune valeur ». Cela n'affirme rien sur le monde. « Il n'y a pas de valeur » s'écrit NO-VALUE (`0002`). Ce que signifie l'omission (par ex. s'il n'y a pas de cible du TAG, c'est cette version) est fixé par la spécification de chaque format.

## Interprétation et validité

- Le champ est un Edge FIELD du même document. On ne place pas deux fois la même cible sur un champ.
- **Champ d'enregistrement (largeur 0)** : sans CODEC, il reçoit n'importe quel enregistrement hors marqueurs d'emplacement. Avec un ou plusieurs, c'est une liste fermée. L'enregistrement de ce champ doit avoir un Kind·Codec (Quantifier compris pour Reference) figurant dans la liste, sinon cet enregistrement ne suit pas la spécification. Cela diffère d'ENUM, qui est une liste ouverte.
- **Champ en valeur brute (largeur n ≥ 1, ou reste `0xFFFF`)** : on ne place qu'une seule cible exacte dans CODEC (joker impossible). Cette valeur brute est le Payload de cette Value privée de son TAG. Le Kind·Codec vient de CODEC, la Length de la largeur du FIELD. Pour les codes pair/impair, le code désigné fixe la parité du nombre d'octets. Si la valeur brute ne suit pas les règles de cette Value (longueur comprise), cet enregistrement ne suit pas la spécification.
- Les marqueurs d'emplacement ne se confrontent qu'aux cibles exactes de la liste. Si `0x0000` apparaît à la place d'un champ facultatif (cible `0000`), c'est une omission. Les autres enregistrements sont confrontés à la liste privée des cibles de marqueur.
- Sur un champ en valeur brute, on peut placer ensemble CODEC et ENUM. CODEC est le format, ENUM le nom de la valeur de code (par ex. rank en UNSIGNED-INTEGER, et 0, 1, 2 en ENUM).
- On peut nommer l'Edge Id d'un CODEC par BIND, mais ce n'est pas obligatoire.
- Un champ « Reference ou Value » s'écrit avec 2 CODEC (`0780`, `0F80`).

## Longueur

```
Total = 1 + N_len + N_id + N_field + 1 WORD   (6 WORD si l'Edge Id et le champ sont des LOCAL ID de 1 WORD)
```

## Exemple

Dans le document de spécification de LABEL `geul.org/label`, le champ Object (FIELD #3) reçoit UTF8-LANGUAGE-TEXT (pair et impair) et LOCAL. Edge Id 7 à 9.

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E` (Edge, Codec `0x1E`, `LLLL = 0101`, 6 WORD), Edge Id `0088 0007`, champ `0088 0003`, cible `084A`.

## Pages liées

- [FIELD](/fr/grammar/edge/field/), [ENUM](/fr/grammar/edge/enum/), [DECLARE](/fr/grammar/edge/declare/), [BIND](/fr/grammar/edge/bind/)
- [Documents de spécification de Codec](/fr/grammar/codec-spec/), [LABEL](/fr/grammar/edge/label/)
