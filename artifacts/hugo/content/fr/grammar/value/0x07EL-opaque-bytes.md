---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES est une suite d'octets quelconque dont ce format ne fixe lui-même ni le sens ni la forme."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES est une suite d'octets quelconque dont ce format ne fixe lui-même ni le sens ni la forme. Ce sont les codes directs de Value `0x07EL` (octets pairs) et `0x07FL` (octets impairs), famille BINARY. Le nombre d'octets est déterminé par le bit de poids faible du Codec et par le nombre de WORD du Payload. Il vaut `2 × nombre de WORD du Payload − bit de poids faible`, et il n'y a pas de Byte Count ([Value](_index.md)).

| Élément | Valeur |
|---|---|
| Nom | `OPAQUE-BYTES` (groupe pair/impair. Le nom de chaque code figure dans le tableau des membres ci-dessous) |
| TAG ID | `0x07EL`·`0x07FL` |
| Section | 3 `0011` (Value), décalage dans la section C = 30~31 |
| Kind | Value · famille : BINARY |
| Description de l'index | Suite d'octets de sens et de forme inconnus. Octets pairs·impairs |
| Côté Hugo | `value/binary/opaque-bytes.md` |

## Membres {#구성원}

Cette page traite ensemble deux codes formant une paire pair/impair. Le code pair correspond à un nombre d'octets pair, le code impair à un nombre d'octets impair ([Enregistrement et TAG WORD](../record.md#가변-길이-바이트열)). Il y a un document de Codec par code. Les champs des deux documents de Codec sont identiques ; seuls la cible de DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Nombre d'octets | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | pair | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | impair | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | reste de valeur brute (`0xFFFF`) |  |  |

## Disposition {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[TAG d'extension Length] si le total atteint 15 WORD ou plus
Payload WORD 1st ... Nth   octets / zero padding final
```

## Interprétation et validité {#해석과-유효성}

- On lit dans le Payload autant d'octets que le nombre d'octets, dans l'ordre. Dans un WORD, l'octet de poids fort vient en premier.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, on rejette si l'octet de poids faible du dernier WORD n'est pas `00`.
- On rejette si le code pair/impair, le nombre de WORD du Payload et le zero padding ne concordent pas.

## Statut du format {#형식-지위}

- La paire de codes pair/impair (`0x07EL` pair, `0x07FL` impair), la disposition du Payload et le zero padding du dernier WORD ne citent aucune norme industrielle externe ; c'est un framing propre à GEUL.

## Longueur {#길이}

- Le total est le nombre de WORD : TAG 1 WORD, plus le TAG d'extension Length (s'il existe) et le Payload. Jusqu'à 14 WORD, la longueur est directe ; à partir de 15 WORD, on utilise la longueur étendue `1110`·`1111`, et le TAG d'extension est aussi compté dans le total ([Enregistrement et TAG WORD](../record.md)).
- 0 octet s'écrit comme un enregistrement de 1 WORD (TAG WORD seul) du code pair (`0x07EL`) ([Value](_index.md)).

## Exemple {#예시}

Les octets `AB CD EF` font 3 octets (impair), c'est donc `OPAQUE-BYTES-ODD` (`0x07FL`), Payload `ABCD EF00`. Le total fait 3 WORD, donc `LLLL=0010`.

```
07F2 ABCD EF00
```

La suite d'octets vide est `07E0` (`OPAQUE-BYTES-EVEN`, TAG WORD seul), soit 1 WORD.

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000007E0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

Ce qui précède est le document de Codec de `OPAQUE-BYTES-EVEN` (`0x07EL`). Le document de Codec de l'autre membre (`OPAQUE-BYTES-ODD`) ne diffère que par le Codec ID dans le DOC-ID, la cible de DECLARE et le nom lié en `#1` (BIND).
