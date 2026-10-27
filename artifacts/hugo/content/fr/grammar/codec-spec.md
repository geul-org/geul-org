---
title: "Documents de spécification de Codec"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "Le livre de codes est lui aussi un document GEUL. Quatre Edge (DECLARE, FIELD, ENUM, CODEC) déclarent la composition du Payload d'un Codec, et ce seul document sert à la fois à valider, décomposer et afficher."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

C'est le livre de codes qui fixe comment un Codec compose son Payload. Le livre de codes de GEUL n'est pas un format à part mais un **document GEUL**. Un document de spécification par Codec.

## Emplacement des documents de spécification

Les documents de spécification des codes directs sont publiés par l'Issuer GEUL (`0x0000`). L'ID de document est le TAG WORD du Codec (seulement les emplacements Kind et Codec, avec Length à 0) étendu à 4 WORD.

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | Document de spécification |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

Le décodeur construit l'adresse du document de spécification à partir du seul TAG WORD. Devant un Codec inconnu, il lui suffit de récupérer et lire ce document.

- `<TAG>` est le hex sur 4 chiffres du TAG WORD cible. L'emplacement Length vaut `0000` et, pour Reference, les bits de Quantifier sont à `000` (LOCAL : `0008`).
- Le Codec de Reference `0000` étant réservé, aucun document de spécification n'a `0x0000` pour TAG WORD cible. Les documents de spécification ne se confondent donc pas avec le document d'index des définitions de termes de l'Issuer GEUL (ID de document `0`, [Issuer et publication](/fr/grammar/issuer/#document-de-définition-de-terme)). Les [marqueurs d'emplacement](/fr/grammar/reference/slot-marker/) du Codec `0000` (`0x0000`~`0x0002`) n'ont pas non plus de document de spécification. Ils sont intégrés au décodeur ([couche 0](/fr/grammar/publishing/#couches)).
- Le document de spécification porte en `DOC-ID` un DOC-POINTER (`0x0000`, `0x000000000000<TAG>`, `0`). Les enregistrements de la liste des versions utilisent aussi ce DOC-POINTER.
- Comme les autres documents, le document de spécification a un nom en minuscules (slug) lié dans l'index des noms `0x0000/documents.geul` de l'Issuer GEUL. Par ex. `publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/` ([Adresse de publication et liste des versions](/fr/grammar/publishing/#nom-du-document)).
- Les règles de version, d'adresse canonique et de signature sont celles des documents publiés ordinaires.

### ID de document de l'Issuer GEUL

| ID de document | Usage |
|---|---|
| `0x0000000000000000` | Document d'index des définitions de termes |
| `0x00000000 0000xxxx` | Document de spécification de Codec. `xxxx` est le TAG WORD cible |
| `0x0001xxxx xxxxxxxx` | Document de définition de terme de geul.org. Un document par terme ([Issuer et publication](/fr/grammar/issuer/#document-de-définition-de-terme)) |

- `0x00000000 0000xxxx` est réservé aux documents de spécification de Codec. Les autres documents de l'Issuer GEUL (par ex. documents de formats ISSUER propres à GEUL, placés quand les codes directs manquent) n'utilisent pas cette plage.

### Livre de codes et édition de la spécification

- Les documents du livre de codes ne s'importent pas par `IMPORT-DOC`. C'est le [SPEC-VERSION](/fr/grammar/meta/declaration/spec-version/) du HEAD du document qui fixe quel livre de codes est suivi.
- Tout décodeur intègre le livre de codes central ou le récupère à cette adresse.
- Quand une proposition (Prefix `000`) est adoptée comme standard, la disposition reste telle quelle et seul le Prefix passe à `001` ([Aperçu](/fr/grammar/overview/#structure-des-zones)). Le TAG WORD cible changeant, la version adoptée devient un nouveau document de spécification d'un autre ID de document, et le document de la proposition reste immuable.

## Les quatre termes

| Edge | Codec | Rôle |
|---|---|---|
| DECLARE | `0x1B` | Déclare la composition du Payload d'un Codec. TAG WORD cible sur 1 WORD |
| FIELD | `0x1C` | Un champ du Payload. DECLARE d'appartenance et largeur |
| ENUM | `0x1D` | Donne un sens à une valeur de code d'un champ en valeur brute |
| CODEC | `0x1E` | Indique un Kind·Codec admis par un champ |

- La disposition des quatre Edge est intégrée au décodeur ([couche 0](/fr/grammar/publishing/#couches)), car il faut pouvoir lire les documents de spécification sans livre de codes. Lire un document de spécification n'exige aucun autre document de spécification.
- Les noms (nom de Codec, nom de champ, nom de valeur de code) se lient tous par BIND.

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (le DECLARE auquel ce champ appartient)
Largeur           1 WORD : 0 = enregistrement, n = valeur brute de n WORD, 0xFFFF = reste en valeur brute
```

- L'**ordre dans le document** des FIELD qui désignent un même DECLARE est l'ordre des champs du Payload.
- Un champ d'enregistrement commence par un TAG WORD et se lit sur sa Length.
- Un champ en valeur brute est un entier non signé lu sur le nombre de WORD indiqué. Les valeurs qui demandent interprétation (signe, décimales, dates) ne sont pas des valeurs brutes mais des enregistrements Value.
- Le reste en valeur brute (`0xFFFF`) ne peut figurer qu'une fois, et seules des valeurs brutes de largeur fixe peuvent le suivre.
- L'Edge Id d'un Edge ne se déclare pas par FIELD. Premier élément de tout Edge, il est implicite.
- La position atteinte après lecture successive des champs doit coïncider exactement avec la fin de l'enregistrement.

### CODEC

Il indique le format que reçoit un champ. Le WORD cible reprend tel quel les emplacements Kind et Codec du TAG WORD.

| Emplacement Length | Sens | Exemple |
|---|---|---|
| `0000` | Codec exact | `0810` SIGNED-DECIMAL, `0008` LOCAL |
| `1111` | Joker : les bits de Codec à 0 acceptent n'importe quoi | `0780` toute Reference, `0F80` toute Value, `07A0` QID Wikidata (quel que soit le Quantifier) |

- Un champ d'enregistrement sans CODEC reçoit n'importe quel enregistrement (hors marqueurs d'emplacement). S'il en a un ou plusieurs, ce doit être l'un d'eux (liste fermée).
- Si l'on place un CODEC sur un champ en valeur brute, cette valeur brute est interprétée comme cette Value sans TAG.

### Champs facultatifs et marqueurs d'emplacement

Les [marqueurs d'emplacement](/fr/grammar/reference/slot-marker/) sont un lot d'enregistrements de 1 WORD du Codec de Reference réservé `0000`. Ils ne peuvent venir à cet emplacement que si la liste CODEC du champ admet ce WORD comme cible exacte.

| Cible CODEC | Marqueur | Ce champ |
|---|---|---|
| `0000` | ABSENT, non renseigné | est un **champ facultatif**. Il peut être omis |
| `0001` | UNKNOWN-VALUE, inconnu | reçoit l'affirmation qu'une valeur existe mais qu'on ne sait pas laquelle |
| `0002` | NO-VALUE, aucune valeur | reçoit l'affirmation qu'il n'y a pas de valeur |

- **Règle d'admission :** un marqueur n'est valide que si la liste CODEC du champ comprend le même WORD comme cible exacte. Les jokers (`0780`, `0781`, `0F80` …) et les champs sans CODEC (« n'importe quel enregistrement ») ne reçoivent pas de marqueur. Sur une place d'enregistrement du HEAD ou du BODY ou une place d'Edge Id, il est invalid.
- Pour omettre un champ facultatif, on écrit à sa place un seul WORD `0x0000` (ABSENT). Un champ facultatif occupe toujours sa place. Il n'y a donc qu'une notation par enregistrement et la décomposition ne dépend que de la position.
- Les marqueurs étant un Codec de Reference réservé, ils ne se confondent pas avec d'autres enregistrements, et un décodeur qui ignore la spécification les saute comme enregistrements de 1 WORD.
- Les trois marqueurs disent des choses différentes. ABSENT parle du document (cet emplacement n'a pas été rempli) et n'affirme donc rien sur le monde. UNKNOWN-VALUE affirme qu'une valeur existe (`∃x`), NO-VALUE qu'il n'y en a pas (`¬∃x`, dans les conditions restrictives). Omettre, c'est « non renseigné », non « aucune valeur ».
- Le sens d'un marqueur est fixé par la spécification du Codec qui le reçoit ([TRIPLE](/fr/grammar/edge/triple/), [QUALIFIER](/fr/grammar/edge/qualifier/)).

## Exemple : le document de spécification de TRIPLE

C'est le BODY de `0x0000/0x000000000000100A`.

| Edge | Contenu | Nom (BIND) |
|---|---|---|
| #1 DECLARE | cible `100A` | `TRIPLE` |
| #2 FIELD | champ de #1, enregistrement | `predicate` |
| #3 FIELD | champ de #1, enregistrement | `subject` |
| #4 FIELD | champ de #1, enregistrement | `object` |
| #5 FIELD | champ de #1, valeur brute de 1 WORD | `rank` |
| #6~#8 ENUM | valeurs de code 0, 1, 2 de #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 s'interprète comme UNSIGNED-INTEGER (`0802`) | |
| #18, #19 CODEC | #4 : toute Reference (`0780`) ou toute Value (`0F80`) | |
| #20, #21 CODEC | #4 reçoit aussi UNKNOWN-VALUE (`0001`) et NO-VALUE (`0002`) | |

Avec ce seul document, le décodeur divise un enregistrement TRIPLE en champs, l'affiche avec les noms des champs et vérifie que le format est correct.

## Exemple : le document de spécification de QUANTITY

Dans la Value QUANTITY (`0806`), les quatre champs sont tous des enregistrements.

| Champ | CODEC |
|---|---|
| `amount` | `0801` SIGNED-INTEGER, `0802` UNSIGNED-INTEGER, `0803` BINARY-FLOAT (valeurs finies uniquement), `0807` FRACTION, `0810` SIGNED-DECIMAL, `0811` UNSIGNED-DECIMAL |
| `unit` | `0780` toute Reference, `0000` facultatif |
| `lower` | `0801`·`0802`·`0803`·`0807`·`0810`·`0811` (comme amount), `0000` facultatif |
| `upper` | `0801`·`0802`·`0803`·`0807`·`0810`·`0811` (comme amount), `0000` facultatif |

## Règles

- Un document de spécification ne contient qu'un DECLARE. La cible du DECLARE est égale au TAG WORD de l'ID de document.
- On ne déclare pas deux fois la même cible dans un document.
- Les variantes de composition de champs ne s'emploient pas comme branches. On déclare chaque Codec séparément.
- On ne peut pas déclarer une disposition où il y a plus d'une valeur brute variable ou où la largeur d'une valeur brute dépend d'une autre valeur. Une telle partie s'enveloppe dans un enregistrement.
- Un document de spécification est publié par versions comme les autres documents. Toutefois, on ne révise pas la disposition binaire d'un Codec. Pour la changer, on attribue un nouveau Codec.

## Problèmes ouverts

- Correspondance entre la valeur de `SPEC-VERSION` (v1 : `0x0001`) et la version du document du livre de codes. Meta de lignée reliant version adoptée et version proposée.
