---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T20:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN est une Reference de 2 WORD qui désigne une entrée du vocabulaire de tokens de GEUL. En mettant bout à bout les octets des enregistrements TOKEN consécutifs, on retrouve le texte d'origine."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | TOKEN-0 | TOKEN-1 |
|---|---|---|
| Nom | `TOKEN-0` (BIND `TOKEN-0` du document de spécification) | `TOKEN-1` (BIND `TOKEN-1` du document de spécification) |
| TAG ID | `0x043L` | `0x044L` |
| Codec ID | `0x00000430` | `0x00000440` |
| Document de spécification | `0x00000000/codecs/0x00000430/` (cible DECLARE `0430`) | `0x00000000/codecs/0x00000440/` (cible DECLARE `0440`) |
| Section | 2 `0010` (Reference divers), offset dans la section C = 3 | 2 `0010`, C = 4 |
| Kind | Reference · classification : déclaration | Reference · classification : déclaration |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| ID de token | `0`~`65 535` | `65 536`~`131 071` |
| Côté Hugo | `reference/token.md` | `reference/token.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `token-id` | #2 | valeur brute de 1 WORD |  | 60 536 ENUM (ID de token `0x0000`~`0xEC77`). Ex. : `0x0000` `<0x00>`, `0x021B` 가, `0x2DE5` ` the`, `0xE75E` 한국 … |

TOKEN est une Reference qui désigne une entrée du vocabulaire de tokens de GEUL. Le vocabulaire est un vocabulaire BPE (Byte Pair Encoding) entraîné sur le coréen et l'anglais, et une entrée est une suite d'octets. En mettant bout à bout, dans l'ordre, les suites d'octets des enregistrements TOKEN consécutifs, on obtient les octets du texte d'origine.

- Si le vocabulaire tient dans 65 536 entrées, on n'utilise que TOKEN-0. S'il grandit au-delà, les entrées excédentaires vont dans TOKEN-1. Même si TOKEN-1 n'est pas utilisé, le nom du premier Codec est TOKEN-0.
- Chaque token s'écrit en un enregistrement. La taille étant fixée à 2 WORD, le k-ième enregistrement d'une suite de tokens se trouve à 4k octets du début.

## Disposition {#레이아웃}

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, total 2 WORD
Payload WORD 1st (16 bits)           ID de token (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, total 2 WORD
Payload WORD 1st (16 bits)           ID de token − 65 536 (uint16)
```

- Code : codes directs de Reference `0x043L`·`0x044L` (section 2).
- Le Payload est l'ID de cible. Selon la [disposition commune de Reference](_index.md), c'est un entier non signé big-endian écrit sur la largeur la plus courte ; comme l'ID de cible est toujours `0`~`65 535`, le Payload fait toujours 1 WORD (`0` s'écrit `0x0000`).
- Il n'y a pas de quantification (la quantification ne se lit que dans le système 5Q).

## Interprétation et validité {#해석과-유효성}

- L'ID de cible de chaque Codec est la valeur du Payload. L'ID de token dans l'ensemble du vocabulaire est l'ID de cible pour TOKEN-0, et 65 536 + l'ID de cible pour TOKEN-1.
- La représentation officielle d'un token est le document de spécification de son Codec. Pour chaque ID de token, il y a un [ENUM](../edge/0x0BDL-enum.md) sur le FIELD `token-id`, et le nom lié par [BIND](../edge/0x0A3L-bind.md) à cet Edge Id de l'ENUM est la suite d'octets du token. La valeur de code ENUM de TOKEN-1 est la valeur du Payload (ID de token − 65 536).
- Le vocabulaire est une liste fermée. Un ID de token sans ENUM dans le document de spécification est invalid. Cette règle du Codec prime sur la règle générale d'ENUM (« une valeur de code non déclarée n'est pas une erreur »).
- **Tokens d'octet :** Les ID de token `0`~`255` sont un octet unique. L'ID de token est la valeur de l'octet elle-même. Pour un caractère absent du vocabulaire, comme ceux qui ne sont ni coréens ni anglais, on écrit ses octets UTF-8 sous forme de tokens d'octet. Le nom BIND d'un token d'octet est le nom machine `<0x00>`~`<0xFF>`, et son sens est fixé par cette règle.
- **Autres tokens :** La suite d'octets est de l'UTF-8 valide, et le nom BIND est cette suite d'octets telle quelle.
- **Décodage :** On lit la suite d'enregistrements TOKEN depuis le début et l'on met bout à bout les suites d'octets de chaque token. Les caractères UTF-8 formés par des tokens d'octet consécutifs sont eux aussi restitués par cette jonction. Le résultat est identique, octet pour octet, au texte avant encodage.
- **Encodage :** La façon de découper le texte en suite de tokens (la règle de découpage et l'ordre de fusion) relève de l'édition du vocabulaire. Un même texte peut donner une suite de tokens différente selon l'édition du vocabulaire. Le résultat du décodage est le même quelle que soit l'édition.
- **Édition :** L'édition du vocabulaire est la version du document de spécification. Chaque édition consigne les hachages du fichier de vocabulaire et du journal d'entraînement comme [SOURCE](../edge/0x0C0L-source.md) du HEAD du document de spécification. Quand il faut indiquer l'édition qui a produit une suite de tokens, on laisse avec elle sa version ([CODEC-POINTER](0x042L-codec-pointer.md) (`0x00000000`, `0x00000430`, ID de version `n`)).
- **Ajout uniquement :** Une nouvelle édition ne fait qu'ajouter des ENUM et des BIND à la fin. La suite d'octets d'un ID de token déjà attribué n'est ni modifiée, ni supprimée, ni réécrite. Ainsi, toute édition est un sur-ensemble de la précédente, et une suite de tokens produite avec une édition antérieure se décode de la même façon avec une édition postérieure. Si le vocabulaire est ré-entraîné depuis zéro et que les sens changent, on n'utilise pas ce Codec : on reçoit un nouveau numéro de Codec.
- Un token étant une Reference, il peut être sujet de [BIND](../edge/0x0A3L-bind.md), [LABEL](../edge/0x0A4L-label.md) et [TRIPLE](../edge/0x0AAL-triple.md) (par exemple la fréquence d'apparition d'un token, la langue).

## Longueur {#길이}

- Le total est exactement 2 WORD, TAG 1 WORD plus Payload 1 WORD, avec la longueur directe `LLLL=0001`. Il n'y a ni TAG d'extension Length, ni TAG d'extension Codec, ni TAG propre au Codec.
- Si le Payload ne fait pas exactement 1 WORD, l'enregistrement est rejeté.

## Exemple {#예시}

Numéros de l'édition 1 du vocabulaire (document de spécification `0x00000000/codecs/0x00000430` version 1). 60 536 tokens ont été attribués : octets 256, caractères de base 283 (espace·saut de ligne·tabulation, ASCII, jamo du hangul, symboles), syllabes hangul 11 172 (`0x021B` 가 ~ `0x2DBE` 힣), fusions 48 825. `0xEC78`~`0xFFFF` est laissé vide pour des ajouts.

| Token (suite d'octets) | ID de token | WORD complets |
|---|---|---|
| octet `0xE3` | `0x00E3` | `0431 00E3` |
| `가` | `0x021B` | `0431 021B` |
| ` the` (précédé d'une espace) | `0x2DE5` | `0431 2DE5` |
| ` GEUL` (précédé d'une espace) | `0x377F` | `0431 377F` |
| `한국어` | `0xD0B8` | `0431 D0B8` |

- Dans le document de spécification, ` the` est `ENUM #2 0x2DE5` et le `BIND " the"` lié à son Edge Id.
- L'espace se colle au mot qui suit. Ainsi ` the` et `the` (`0x328D`) sont des tokens différents.

## Problèmes ouverts {#열린-문제}

- Format pour porter une suite de tokens dans un document. On n'a pas décidé quel champ d'Edge ou de Value reçoit une suite d'enregistrements TOKEN.
- Forme canonique de l'encodage. Comment écrire dans le document de spécification la règle de découpage et l'ordre de fusion, et s'il faut fixer une suite de tokens unique pour un même texte.
- Interprétation entre éditions. Quand le lecteur rencontre un ID de token plus récent que l'édition qu'il possède, s'il le rejette comme invalid ou s'il conserve la valeur brute et le traite comme « token inconnu ».

## Pages liées {#관련-페이지}

- [Reference](_index.md), [CODEC-POINTER](0x042L-codec-pointer.md)
- [Document de spécification de Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)
- Registry de même forme : [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## Texte source du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00000430/latest.geul` lu avec `geul show` (hexadécimal en majuscules). Les deux SOURCE du HEAD sont le SHA-256 du fichier de vocabulaire et celui du journal d'entraînement.

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000043000000000
#121077 SOURCE #0 ABSENT
#121078 QUALIFIER P4092 #121077 SHA-256-DIGEST(0xE4DEEA8BA9FE74BEAAD836FEBE06CF4DAC32B30D1E9A85308D0A6E0A9CB6A417)
#121079 SOURCE #0 ABSENT
#121080 QUALIFIER P4092 #121079 SHA-256-DIGEST(0x5B2C82701BCFFD3589DC9640B398B3F07F0AC7F18E483486AF5221C3D30D4D9C)
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "token-id"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
#7 ENUM #2 0x0001
#8 BIND #7 "<0x01>"
… (121 064 lignes ENUM·BIND omises)
#121073 ENUM #2 0xEC76
#121074 BIND #121073 "etap"
#121075 ENUM #2 0xEC77
#121076 BIND #121075 " Aman"
```
