---
title: "Documents de spécification de Codec"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "La composition du Payload d'un Codec est fixée par le livre de codes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La composition du Payload d'un Codec est fixée par le livre de codes. Le livre de codes de GEUL n'est pas un format à part mais un **document GEUL**. Un document de spécification par Codec.

## Emplacement des documents de spécification {#규격-문서의-위치}

Les documents de spécification des codes directs sont publiés par l'Issuer GEUL (`0x00000000`). Un document de spécification est un document de Codec et n'a pas d'ID de document. L'ID de Codec est le TAG WORD du Codec (seulement la section et l'emplacement Codec `C`, avec Length à 0) écrit sur 32 bits.

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<ID de version>.geul
```

| Codec | TAG | Document de spécification |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

Le décodeur construit l'adresse du document de spécification à partir du seul TAG WORD. Devant un Codec inconnu, il lui suffit de récupérer et lire ce document.

- `<TAG>` est le TAG WORD cible en 4 chiffres hexadécimaux (majuscules). L'emplacement Length vaut `0000`. Il y a un document de Codec par code. Le système Reference 5Q a lui aussi un document distinct par code de quantification (LOCAL Identified `0050`, LOCAL Generic `0060`). Les codes directs et les Codecs d'Issuer suivent la même règle d'adresse `<Issuer>/codecs/<ID de Codec>/` ([adresse de publication et liste des versions](publishing.md#공표-주소)).
- Les [marqueurs d'emplacement](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`) ont eux aussi un document de spécification. Sans Payload, ils ne comportent que DECLARE et pas de FIELD. Le sens des marqueurs et les règles d'acceptation sont intégrés au décodeur ([couche 0](publishing.md#층)). Un Codec dont la disposition n'est pas encore fixée commence aussi par un document de spécification ne contenant que DECLARE.
- Un document de spécification place comme `DOC-ID` un [CODEC-POINTER](reference/0x042L-codec-pointer.md) (`0x00000000`, `0x0000<TAG>`, `0`). Les enregistrements de la liste des versions utilisent aussi ce CODEC-POINTER.
- Les règles de version, d'adresse canonique et de signature sont les mêmes que pour les documents publiés ordinaires.

### Livre de codes et édition de la spécification {#코덱북과-명세-판}

- Un document de Codec peut aussi être importé par [IMPORT-DOC](meta/0x1E4L-import-doc.md). Dans ce cas, à l'emplacement du document, on utilise un [CODEC-POINTER](reference/0x042L-codec-pointer.md) au lieu d'un DOC-POINTER. Le [SPEC-VERSION](meta/0x1C5L-spec-version.md) du HEAD du document indique quel livre de codes il suit.
- Tout décodeur intègre le livre de codes de base ou le récupère à cette adresse.
- Lorsqu'une proposition (Prefix `000`) est adoptée comme standard, la disposition reste inchangée et seul le Prefix passe à `001` ([Vue d'ensemble](_index.md#영역-구조)). Le TAG WORD cible changeant, la version adoptée devient un nouveau document de spécification avec un autre ID de Codec, et le document de proposition reste immuable.

## Quatre vocabulaires {#네-어휘}

| Edge | Codec | Rôle |
|---|---|---|
| DECLARE | `0x0BBL` | Déclare la composition du Payload d'un Codec. TAG WORD cible : 1 WORD |
| FIELD | `0x0BCL` | Un champ du Payload. Le DECLARE auquel il appartient et sa largeur |
| ENUM | `0x0BDL` | Donne un sens à une valeur de code d'un champ en valeur brute |
| CODEC | `0x0BEL` | Désigne un Kind ou un Codec accepté par un champ |

- Les dispositions des quatre Edge sont intégrées au décodeur ([couche 0](publishing.md#층)), car un document de spécification doit pouvoir être lu sans livre de codes. Lire un document de spécification ne requiert aucun autre document de spécification.
- Tous les noms (nom de Codec, nom de champ, nom de valeur de code) sont liés par BIND.

### FIELD {#field}

```
Edge Id           LOCAL
DECLARE           LOCAL (le DECLARE auquel ce champ appartient)
largeur           1 WORD : 0 = enregistrement, n = valeur brute de n WORD, 0xFFFF = valeur brute restante
```

- L'**ordre dans le document** des FIELD qui pointent vers le même DECLARE est l'ordre des champs du Payload.
- Un champ enregistrement commence par un TAG WORD et lit autant de WORD que son Length.
- Un champ en valeur brute est un entier non signé lu sur le nombre de WORD indiqué. Une valeur qui demande interprétation, comme un signe, une partie décimale ou une date, se place dans un enregistrement Value et non en valeur brute.
- La valeur brute restante (`0xFFFF`) ne peut apparaître qu'une fois, et seules des valeurs brutes de largeur fixe peuvent la suivre.
- L'Edge Id d'un Edge n'est pas déclaré par un FIELD. Étant le premier élément de tout Edge, il est implicite. EDGE-ISSUER est le premier élément après l'Issuer et le numéro de Codec ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)).
- La position atteinte après lecture successive des champs doit coïncider exactement avec la fin de l'enregistrement.

### CODEC {#codec}

Désigne le format accepté par un champ. Le WORD cible reprend tel quel l'emplacement Codec du TAG WORD (section `KKKK` et `C`).

| Emplacement Length | Sens | Exemple |
|---|---|---|
| `0000` | Codec exact | `0680` SIGNED-DECIMAL, `0050` LOCAL |
| `1111` | Joker : quelle que soit la valeur de `C`, toute la section `KKKK` (32 cases). On recommande la première case de la section (`C = 0`) | `000F` toute la section 0, `060F` toute la section 3 |

- Quand un Kind s'étend sur plusieurs sections, on énumère un CODEC par section. N'importe quel Reference : `000F`, `020F`, `040F` ; n'importe quelle Value : `060F`, `080F`.
- Pour un groupe ou une quantification indifférente, on énumère les Codecs exacts. Le QID Wikidata (quantification indifférente) correspond à cinq codes : `0140`, `0150`, `0160`, `0170`, `0180`.

- Sans CODEC, un champ enregistrement accepte n'importe quel enregistrement (hors marqueurs d'emplacement). Avec un ou plusieurs CODEC, l'enregistrement doit être l'un d'eux (liste fermée).
- Si l'on place un CODEC sur un champ en valeur brute, cette valeur brute est interprétée comme cette Value sans TAG.

### Champs facultatifs et marqueurs d'emplacement {#선택-필드와-자리-표지}

Les [marqueurs d'emplacement](slot-marker.md) forment un groupe d'enregistrements de 1 WORD attribués aux trois premières cases `0x000L~0x002L` de la section 0 de Reference. Ils ne peuvent figurer à un emplacement que si la liste des CODEC du champ désigne ce WORD comme cible exacte.

| Cible CODEC | Marqueur | Le champ |
|---|---|---|
| `0000` | ABSENT, non renseigné | est un **champ facultatif**. Il peut être omis |
| `0010` | UNKNOWN-VALUE, inconnu | accepte l'assertion qu'une valeur existe mais qu'on ignore laquelle |
| `0020` | NO-VALUE, aucune valeur | accepte l'assertion qu'il n'y a pas de valeur |

- **Règle d'acceptation :** un marqueur n'est valide que si la liste des CODEC du champ contient le même WORD comme cible exacte. Les jokers (`000F`, `060F` …) et les champs sans CODEC (« n'importe quel enregistrement ») n'acceptent pas de marqueur. Aux emplacements d'enregistrement du HEAD et du BODY et à l'emplacement de l'Edge Id, il est invalid.
- Pour omettre un champ facultatif, on écrit à son emplacement un seul WORD `0x0000` (ABSENT). Un champ facultatif occupe toujours son emplacement. Ainsi un enregistrement a une seule notation, et sa décomposition ne dépend que des positions.
- Un marqueur a son propre code Reference et ne chevauche aucun autre enregistrement ; un décodeur qui ne connaît pas la spécification le saute comme un enregistrement de 1 WORD.
- Les trois marqueurs disent des choses différentes. ABSENT porte sur le document (cet emplacement n'a pas été rempli) et n'affirme donc rien sur le monde. UNKNOWN-VALUE affirme qu'une valeur existe (`∃x`), NO-VALUE qu'il n'y en a pas (`¬∃x`, dans une condition de restriction). Omettre, c'est « ne pas renseigner », non « aucune valeur ».
- Ce que signifie un marqueur est fixé par la spécification du Codec qui l'accepte ([TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md)).

## Exemple : document de spécification de TRIPLE {#예-triple-규격-문서}

C'est le BODY de `0x00000000/codecs/0x00000AA0`.

| Edge | Contenu | Nom (BIND) |
|---|---|---|
| #1 DECLARE | cible `0AA0` | `TRIPLE` |
| #2 FIELD | champ de #1, enregistrement | `predicate` |
| #3 FIELD | champ de #1, enregistrement | `subject` |
| #4 FIELD | champ de #1, enregistrement | `object` |
| #5 FIELD | champ de #1, valeur brute de 1 WORD | `rank` |
| #6~#8 ENUM | valeurs de code 0, 1, 2 de #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 est interprété comme UNSIGNED-INTEGER (`0620`) | |
| #18, #22, #23, #19, #24 CODEC | #4 est n'importe quel Reference (`000F`·`020F`·`040F`) ou n'importe quelle Value (`060F`·`080F`) | |
| #20, #21 CODEC | #4 accepte aussi UNKNOWN-VALUE (`0010`) et NO-VALUE (`0020`) | |
| #25~#27 CODEC | #2 est n'importe quel Reference (`000F`·`020F`·`040F`) | |
| #28~#30 CODEC | #3 est n'importe quel Reference (`000F`·`020F`·`040F`) | |

Ce seul document permet au décodeur de découper un enregistrement TRIPLE en champs, de l'afficher avec les noms de champs et de vérifier la conformité des formats.

## Exemple : document de spécification de QUANTITY {#예-quantity-규격-문서}

Dans Value QUANTITY (`0660`), les quatre champs sont tous des enregistrements.

| Champ | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT (valeurs finies seulement), `0670` FRACTION, `0680` SIGNED-DECIMAL, `0690` UNSIGNED-DECIMAL |
| `unit` | `000F`·`020F`·`040F` n'importe quel Reference, `0000` facultatif |
| `lower` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (comme amount), `0000` facultatif |
| `upper` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (comme amount), `0000` facultatif |

## Règles {#규칙}

- Un document de spécification ne comporte qu'un DECLARE. La cible du DECLARE est identique au TAG WORD de l'ID de Codec.
- On ne déclare pas deux fois la même cible dans un document.
- Une variante dont la composition des champs diffère ne s'écrit pas comme une branche. On déclare chaque Codec séparément.
- On ne peut pas déclarer une disposition comportant plusieurs valeurs brutes variables, ou dont la largeur d'une valeur brute dépend d'une autre valeur. On enveloppe cette partie dans un enregistrement.
- Un document de spécification est publié par versions comme les autres documents. En revanche, la disposition binaire d'un Codec n'est pas révisée. Pour la changer, on attribue un nouveau Codec.

## Problèmes ouverts {#열린-문제}

- La correspondance entre la valeur de `SPEC-VERSION` (`0x0001` pour la v1) et la version du document de livre de codes. Un Meta de lignée reliant la version adoptée et la proposition.
