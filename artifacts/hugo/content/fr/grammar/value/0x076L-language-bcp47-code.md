---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE est un Value qui contient un language tag BCP 47 complet sous forme de suite d'octets ASCII."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE est un Value qui contient un language tag BCP 47 complet sous forme de suite d'octets ASCII. Il utilise la paire de codes d'octets pairs·impairs 0x076L/0x077L.

| Élément | Valeur |
|---|---|
| Nom | `LANGUAGE-BCP47-CODE` (groupe pair/impair. Le nom de chaque code figure dans le tableau des membres ci-dessous) |
| TAG ID | `0x076L`·`0x077L` |
| Section | 3 `0011` (Value), décalage dans la section C = 22~23 |
| Kind | Value · famille : TEXT |
| Description de l'index | Octets ASCII d'un language tag BCP 47 complet en canonical casing. Octets pairs·impairs |
| Côté Hugo | `value/text/language-bcp47-code.md` |

## Membres {#구성원}

Cette page traite ensemble deux codes formant une paire pair/impair. Le code pair correspond à un nombre d'octets pair, le code impair à un nombre d'octets impair ([Enregistrement et TAG WORD](../record.md#가변-길이-바이트열)). Il y a un document de Codec par code. Les champs des deux documents de Codec sont identiques ; seuls la cible de DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Nombre d'octets | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | pair | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | impair | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | reste de valeur brute (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE est un Value qui contient un language tag BCP 47 complet. Il sert à noter une langue avec précision, jusqu'au script, à la region et au variant.

## Disposition {#레이아웃}

- Code : codes directs de Value `0x076L` (octets pairs) · `0x077L` (octets impairs). Famille TEXT.
- Le nombre d'octets est déterminé par le bit de poids faible du Codec et par le nombre de WORD du Payload. Il vaut `2 × nombre de WORD du Payload − bit de poids faible`, et il n'y a pas de Byte Count ([Value](_index.md)).
- Le Payload n'est pas du texte UTF-8 mais la suite d'octets ASCII du tag BCP 47.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[TAG d'extension Length] si le total atteint 15 WORD ou plus
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interprétation et validité {#해석과-유효성}

- La suite d'octets doit être un language tag BCP 47 well-formed au sens de la RFC 5646. La chaîne vide n'est pas admise.
- Le Payload n'utilise que des lettres ASCII, des chiffres et le hyphen-minus `-`. Le séparateur est obligatoirement l'ASCII `-` ; `_`, l'espace et les caractères non ASCII ne sont pas admis.
- La comparaison des tags BCP 47 ne distingue pas la casse. Le canonical profile de GEUL utilise `-` pour tous les séparateurs et sérialise les subtags language/extlang/variant/extension/private-use en minuscules, le script en Titlecase et la region en majuscules.
- Le simple fait d'être well-formed ne suffit pas. La validité des registered subtag et des grandfathered tag est jugée sur la base d'un snapshot précis de l'IANA Language Subtag Registry, et la date de ce snapshot ou la version du registry doit être conservée avec elle.
- Les private-use tag et private-use subtag sont admis s'ils sont well-formed selon la grammaire de la RFC 5646. Toutefois, leur sens dépend d'un accord entre les parties et n'est pas défini par le registry IANA ; l'interopérabilité publique n'est donc pas garantie.
- Si, dans le même snapshot, un deprecated subtag ou un grandfathered tag a un Preferred-Value, la forme GEUL canonical écrit cette valeur de remplacement en canonical casing. Un tag laissé en notation deprecated peut être interprété en entrée, mais n'est pas la forme de stockage canonical.
- BCP 47 étant un ASCII profile, l'exigence de Unicode normalization comme l'UTF-8 NFC ne s'applique pas.
- Dans un WORD, l'octet de poids fort vient en premier. Si le nombre d'octets est impair (code impair), l'octet de poids faible inutilisé du dernier WORD doit être `00`.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, on rejette si l'octet de poids faible du dernier WORD n'est pas `00`.

## Fondement normatif {#표준-근거}

- La grammaire des language tag, l'interprétation insensible à la casse et la notion de deprecated/Preferred-Value suivent la [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Le registry qui juge de la validité d'un tag est l'[IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- La paire de codes pair/impair, le zero padding, la politique de stockage en canonical casing et le calcul de Length sont des règles de framing de GEUL.

## Longueur {#길이}

- Le total est le nombre de WORD : TAG 1 WORD, plus le TAG d'extension Length (s'il existe) et le Payload. Jusqu'à 14 WORD, la longueur est directe ; à partir de 15 WORD, on utilise la longueur étendue `1110`·`1111`, et le TAG d'extension est aussi compté dans le total ([Length](../record.md)).

## Relation avec LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- Un tag qui a un numéro dans le GEUL Language Registry peut s'écrire en 1 WORD avec [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md).
- Un tag sans numéro dans le registry (y compris un tag contenant extension·private-use) s'écrit en LANGUAGE-BCP47-CODE. LANGUAGE-BCP47-CODE s'emploie aussi lorsqu'il faut conserver le texte d'origine du full tag.
- Le SHORT-CODE `n` et le LANGUAGE-BCP47-CODE du tag que le registry lie à `n` (sans tenir compte de la casse) désignent la même langue.

## Exemple {#예시}

- `ko-KR` fait 5 octets ASCII (impair), c'est donc `LANGUAGE-BCP47-CODE-ODD` (`0x077L`), et le Payload est `6B6F 2D4B 5200`.
- Avec TAG 1 WORD et Payload 3 WORD, le total est de 4 WORD et `LLLL=0011`. Le total est `0773 6B6F 2D4B 5200`.

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00000760/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

Ce qui précède est le document de Codec de `LANGUAGE-BCP47-CODE-EVEN` (`0x076L`). Le document de Codec de l'autre membre (`LANGUAGE-BCP47-CODE-ODD`) ne diffère que par le Codec ID dans le DOC-ID, la cible de DECLARE et le nom lié en `#1` (BIND).
