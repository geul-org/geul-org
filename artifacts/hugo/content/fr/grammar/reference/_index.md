---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference est un enregistrement qui désigne une cible."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference est un enregistrement qui désigne une cible. La cible peut être une entité, un concept, un document ou un autre Edge. On désigne par un ID, non par un nom.

## Disposition {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      sections 0~2 (0x000L~0x05FL)
[TAG d'extension de Length]
[IMPORT ID]       pour EXTERNAL-POINTER (1/2/4 WORD)
[Issuer]          pour EXTERNAL-ISSUER (2/4/16 WORD)
[ID de document]  pour EXTERNAL-ISSUER (4 WORD)
ID de cible       tout le reste
```

- `LLLL` est le nombre total de WORD, TAG WORD compris, moins 1 ([enregistrement et TAG WORD](../record.md)).
- Reference occupe les sections 0~2 (`w < 0x0600`), soit 96 places. Section 0, entités : `0x000L~0x01FL` ; section 1, EXTERNAL : `0x020L~0x03FL` ; section 2, divers : `0x040L~0x05FL`.
- Les Codec s'écrivent selon la table de codes (tableau ci-dessous). Dans le système 5Q, un seul code porte à la fois le système d'identification et la quantification. La quantification de REFERENCE-ISSUER est fixée par le document de l'Issuer.
- L'ID de cible est un entier non signé big-endian, écrit sur la **largeur la plus courte**. La largeur est ce qui reste de Length une fois retirés les champs précédents.
- L'ID de cible `0` s'écrit en 1 WORD `0x0000`. Dans les autres cas, on ne place pas de WORD `0x0000` devant.
- Si la valeur entière est égale, c'est le même ID. La largeur ne fait pas partie de l'ID.
- Tous les Codec utilisent la largeur la plus courte. Un Codec ne fixe pas la largeur de l'ID de cible.
- [ISSUER-POINTER](0x040L-issuer-pointer.md), [DOC-POINTER](0x041L-doc-pointer.md) et [CODEC-POINTER](0x042L-codec-pointer.md) ne suivent pas cette disposition. Ils n'ont pas d'ID de cible ; ils ne comportent que l'Issuer (avec l'ID de document, le Codec ID et l'ID de version).
- [REFERENCE-ISSUER](#reference-issuer) ne suit pas non plus cette disposition. Il comprend le TAG, l'Issuer, le numéro de Codec sur 2 WORD, et le Payload. Le Payload est fixé par le document de Codec publié par l'Issuer.

## Codec {#codec}

| TAG ID | Nom | Classification | Cible |
|---|---|---|---|
| `0x000L~0x002L` | [marqueur d'emplacement](../slot-marker.md) | marqueur d'emplacement | Ne désigne aucune cible. On n'emploie que le marqueur de 1 WORD : `0x0000` ABSENT (non renseigné), `0x0010` UNKNOWN-VALUE (inconnu), `0x0020` NO-VALUE (aucune valeur) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | déclaration | ID émis par ce document |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | déclaration | Entité émise par geul.org |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | déclaration | Identifiant aligné sur le sens, dont les bits portent du sens |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | déclaration | Élément Wikidata. Entier après `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | déclaration | Propriété Wikidata. Entier après `P` |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | désignation | LOCAL ID d'un document importé par IMPORT |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | désignation-déclaration | LOCAL ID d'un document publié par un Issuer |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | désignation-déclaration | L'Issuer lui-même |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | désignation-déclaration | Une version d'un document publié par un Issuer |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | désignation-déclaration | Une version d'un Codec publié par un Issuer |
| `0x043L~0x044L` | [TOKEN-0·TOKEN-1](0x043L-token.md) | déclaration | Une entrée du vocabulaire de tokens de GEUL. ID de token de 1 WORD, 2 WORD au total |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | format d'Issuer | Défini par l'Issuer. La classification et la place de l'ID de cible sont fixées par le document de l'Issuer |

- Reserved : `0x003L~0x004L`, `0x01EL~0x01FL` (section 0), `0x03EL~0x03FL` (section 1), `0x045L~0x05CL` (section 2, places pour de nouveaux systèmes d'identification).
- Le numéro de système se lit à partir de l'offset dans la section `C`. En section 0, si `5 <= C < 30`, c'est le système `C / 5` (1~5) ; en section 1, si `C < 30`, c'est le système `6 + C / 5` (6~11).

| Système | Nom | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- La **déclaration** identifie directement la cible par un ID fixé par l'entité qui l'attribue.
- La **désignation** désigne un LOCAL d'un document importé par IMPORT ID. La largeur de l'IMPORT ID est fixée par le système : si système − 6 vaut 0, 1, 2, c'est 1, 2, 4 WORD.
- La **désignation-déclaration** désigne un autre document et une cible qu'il contient en un seul enregistrement, sans IMPORT. La largeur de l'Issuer d'EXTERNAL-ISSUER est, si système − 9 vaut 0, 1, 2, de 2, 4, 16 WORD.
- `0x020L~0x03DL` (section 1, systèmes 6~11) désignent un LOCAL d'un autre document. Les autres systèmes de déclaration identifient directement la cible (LOCAL de ce document, ID émis). Les pointeurs (section 2, `0x040L~0x042L`) désignent l'Issuer, le document ou le Codec eux-mêmes. REFERENCE-ISSUER est en dehors de cette distinction.
- `0x000L~0x002L` sont des codes attribués aux marqueurs d'emplacement et ne servent pas de Reference désignant une cible. Les WORD `0x0000`, `0x0010` et `0x0020` (L 0, 1 WORD) sont des [marqueurs d'emplacement](../slot-marker.md) (`0x0000` ABSENT, `0x0010` UNKNOWN-VALUE, `0x0020` NO-VALUE). Un marqueur n'est valide qu'à la place d'un champ d'enregistrement dont la cible CODEC est exactement ce WORD. Les jokers et les champs sans CODEC ne l'acceptent pas, et il est invalid à la place d'un enregistrement HEAD ou BODY et à la place d'un Edge Id. Une forme de TAG avec Payload (L ≥ 1) pour C 0~2 est Reserved.
- Seuls les codes directs fournis par geul.org et les publications sont sous CC0. On ne place pas en code direct un système d'identification qui n'est pas sous CC0 (WordNet, etc.). La licence d'un format d'Issuer est fixée par cet Issuer.

### TAG courants {#자주-쓰는-tag}

| Enregistrement | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5 (humain) | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (instance of) | `0191 001F` |
| marqueur d'emplacement ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL est un ID émis par ce document.

- **Il est unique.** Dans un document, un LOCAL ID ne désigne qu'une seule cible.
- **0 n'est pas attribué.** Les ID de cible sont attribués à partir de 1.
- **On recommande d'attribuer en incrémentant** (auto increment). La grandeur de l'ID n'a pas de sens.
- Il désigne la même cible d'une version à l'autre. Un ID supprimé n'est pas réutilisé (révision du [document](../document.md)).
- Pour le désigner depuis l'extérieur du document, le document doit avoir un `DOC-ID`.
- Que deux LOCAL ID soient différents ne signifie pas que ce sont des cibles différentes dans la réalité. S'ils sont identiques, on les relie par `SAME-NODE` ; s'ils sont différents, par `DIFFERENT-NODE`.

### Edge Id {#edge-id}

Tout Edge place une Reference LOCAL en premier élément de son Payload. Ce LOCAL ID est l'**Edge Id**.

- On peut lire l'Edge Id sans connaître le livre de codes.
- Le LOCAL à la place de l'Edge Id est une déclaration ; le LOCAL à une autre place de l'Edge est une mention.
- Pour déclarer un Edge Id, on n'emploie que le LOCAL Identified (`0x005L`).
- On désigne un autre Edge par son Edge Id. Un Edge de ce document se désigne par LOCAL, un Edge d'un autre document par une Reference de désignation.

## Désigner un autre document {#다른-문서-가리키기}

| Quoi | Comment |
|---|---|
| L'Issuer lui-même | `ISSUER-POINTER` (Issuer) |
| Une version de document | `DOC-POINTER` (Issuer, ID de document 4 WORD, ID de version 2 WORD). La version `0` est la plus récente |
| Une version de Codec | `CODEC-POINTER` (Issuer, Codec ID 2 WORD, ID de version 2 WORD). La version `0` est la plus récente |
| Une cible dans un document publié (la plus récente) | `EXTERNAL-ISSUER-*` (Issuer, ID de document, LOCAL ID) |
| Une cible dans un document importé (édition fixée) | On attribue un IMPORT ID par le Meta `IMPORT-DOC` et l'on utilise `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- Un document lui-même, de l'intérieur comme de l'extérieur, ne se désigne que par un DOC-POINTER. Il se désigne lui-même par le DOC-POINTER de son propre `DOC-ID`. Un document de Codec fait exception : il se désigne par CODEC-POINTER (son `DOC-ID` est aussi un CODEC-POINTER).
- EXTERNAL-ISSUER suit la version la plus récente. Pour fixer l'édition, on utilise IMPORT.
- L'Issuer s'écrit sur la plus courte largeur où la valeur tient (2/4/16 WORD), et l'on choisit le Codec de cette largeur. C'est identique pour EXTERNAL-ISSUER et REFERENCE-ISSUER.
- L'ID de document `0` de chaque Issuer est réservé au document d'index des termes définis par cet Issuer (outils, rôles, etc.). Le document d'index est recommandé pour tout Issuer et n'est pas obligatoire ([Issuer et publication](../issuer.md#용어-정의-문서)).

Exemple : LOCAL 7 dans le document `0x0000000000000002` de l'Issuer `0x00000002`

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | Nom | Sens | Exemple |
|---|---|---|---|
| `0` | Identified | Une entité identifiée | Elon Musk, la Corée du Sud |
| `1` | Generic | Énoncé général sur toute une espèce. Admet des exceptions | Les soldats obéissent aux ordres |
| `2` | Free-choice | N'importe quelle cible satisfaisant la condition | N'importe quel soldat |
| `3` | Universal | Toutes les cibles dans la portée | Tous les soldats |
| `4` | Variable | Variable de discours | cette personne, cette femme |

- **La quantification ne se lit que dans le système 5Q (systèmes 1~11).** Avec l'offset dans la section `C`, la quantification est `C % 5` en section 0 si `5 <= C < 30`, et en section 1 si `C < 30`. Une section compte 32 places ; si l'on divisait par 5 la place de Codec sur 9 bits (`w >> 4`), la section 1 serait décalée. Les marqueurs (section 0, `C < 3`) et la section 2 (pointeurs, REFERENCE-ISSUER) n'ont pas de quantification. Le marqueur `0x0010` UNKNOWN-VALUE n'est pas Generic. La quantification de REFERENCE-ISSUER est fixée par le document de Codec publié par l'Issuer.
- Generic, contrairement à Universal, ne signifie pas que l'énoncé s'applique sans exception à chaque cible individuelle. Une expression définitoire comme `qu'est-ce qu'un soldat` peut s'écrire en Generic. Si une définition stricte de concept ou de classification est nécessaire, on la concrétise par une relation distincte.
- La portée de la quantification et sa négation sont fixées non par Reference mais par l'Edge qui l'emploie.
- **Variable** est une cible de discours dont on connaît l'espèce mais qui n'est pas encore identifiée.
  - Une variable nommée s'obtient en attachant Variable à un LOCAL. Le même LOCAL ID est la même variable. On relie l'espèce par un Edge.
  - Une variable anonyme s'obtient en attachant Variable à un Codec de déclaration qui désigne l'espèce (GEUL, WIKIDATA-*) (par exemple « président » de Wikidata + Variable). On ne suit pas la coréférence et on ne peut pas la désigner de nouveau. Deux variables anonymes ne sont pas considérées comme la même variable.
  - Quand la cible est confirmée plus tard, on relie la variable à cette cible par `SAME-NODE`. Toutes les expressions qui désignent la même variable sont alors interprétées ensemble comme cette cible.
  - Que deux variables soient différentes ne signifie pas que leurs cibles réelles sont différentes. S'ils sont identiques, on les relie par `SAME-NODE` ; s'ils sont différents, par `DIFFERENT-NODE`.
  - Le Variable des Codec de désignation externe (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) est une variable LOCAL du document désigné.
  - Exemple : dans `le président a prononcé un discours`, si la personne n'est pas déterminée, on emploie Variable « président ». Pour le mentionner de nouveau, on place un LOCAL Variable et l'on relie l'espèce « président » par un Edge. Si l'on confirme plus tard qu'il s'agit d'Obama, on relie cette variable à Obama Identified par `SAME-NODE`. Toutes les expressions qui désignent la même variable sont alors interprétées ensemble comme Obama.
- Exemple : employer Q5 (humain) de Wikidata en Generic donne `0151 0005` (« l'être humain est … »).

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER est un format de Reference défini par l'Issuer. Il occupe les trois dernières places de la zone Reference. Sa disposition est la même que celle de ISSUER de Value et d'Edge ([enregistrement et TAG WORD](../record.md#issuer-형식-레코드)).

### Disposition {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = largeur de l'Issuer : 01 2, 10 4, 11 16 WORD)
[TAG d'extension de Length]
Issuer            2/4/16 WORD (la largeur est fixée par le Codec)
Numéro de Codec   2 WORD. Défini par l'Issuer
Payload           Fixé par le document de Codec publié par l'Issuer
```

| Codec | Nom | Largeur de l'Issuer |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- Chaque code a sa page : [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md).
- Le document de Codec de l'Issuer GEUL est unique par code et comporte trois FIELD : Issuer (2·4·16 WORD), numéro de Codec (2 WORD), Payload (fixé par le Codec de l'Issuer).

### Interprétation et validité {#해석과-유효성}

- GEUL ne connaît que la frontière du Payload, donnée par Length. On n'interprète pas le Payload sans le livre de codes.
- Le sens du numéro de Codec et la quantification sont fixés par l'Issuer. Ce qui est désigné est aussi fixé par le document de Codec publié par l'Issuer.
- Les règles communes des Reference ne s'appliquent pas : largeur minimale de l'ID de cible, notation en 1 WORD de l'ID de cible `0`, Quantifier, lecture de la quantification et du système selon l'offset dans la section, classification en déclaration ou désignation, cible désignée.
- Le numéro de Codec sur 2 WORD est le même que pour ISSUER de Value et d'Edge. S'il manque de numéros, on se fait émettre un Issuer supplémentaire.
- Un décodeur qui ne connaît pas le format lit jusqu'au Kind, à Length, à l'Issuer et au numéro de Codec, puis saute selon Length.
- La licence d'un format d'Issuer est fixée par cet Issuer ([Issuer et publication](../issuer.md#라이선스)).

### Pages liées {#관련-페이지}

- [enregistrement et TAG WORD](../record.md), [Issuer et publication](../issuer.md)
