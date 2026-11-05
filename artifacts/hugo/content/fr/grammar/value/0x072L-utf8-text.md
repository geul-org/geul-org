---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT est un Value qui contient une chaîne UTF-8 sans langue."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT est un Value qui contient une chaîne UTF-8 sans langue. Il utilise la paire de codes d'octets pairs·impairs 0x072L/0x073L.

| Élément | Valeur |
|---|---|
| Nom | `UTF8-TEXT` (groupe pair/impair. Le nom de chaque code figure dans le tableau des membres ci-dessous) |
| TAG ID | `0x072L`·`0x073L` |
| Section | 3 `0011` (Value), décalage dans la section C = 18~19 |
| Kind | Value · famille : TEXT |
| Description de l'index | Suite d'octets UTF-8 valid n'impliquant aucune normalisation. Octets pairs·impairs |
| Côté Hugo | `value/text/utf8-text.md` |

## Membres {#구성원}

Cette page traite ensemble deux codes formant une paire pair/impair. Le code pair correspond à un nombre d'octets pair, le code impair à un nombre d'octets impair ([Enregistrement et TAG WORD](../record.md#가변-길이-바이트열)). Il y a un document de Codec par code. Les champs des deux documents de Codec sont identiques ; seuls la cible de DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Nombre d'octets | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | pair | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | impair | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | reste de valeur brute (`0xFFFF`) |  |  |

UTF8-TEXT est un Value qui contient une suite d'octets UTF-8 valid au sens de la RFC 3629. Il sert pour les chaînes sans langue, telles que identifiants, codes et noms de fichiers.

## Disposition {#레이아웃}

- Code : codes directs de Value `0x072L` (octets pairs) · `0x073L` (octets impairs). Famille TEXT.
- Le nombre d'octets est déterminé par le bit de poids faible du Codec et par le nombre de WORD du Payload. Il vaut `2 × nombre de WORD du Payload − bit de poids faible`, et il n'y a pas de Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[TAG d'extension Length] si le total atteint 15 WORD ou plus
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interprétation et validité {#해석과-유효성}

- La suite d'octets doit être de l'UTF-8 well-formed shortest-form conforme à la grammaire de la RFC 3629. Le résultat du décodage ne contient que des Unicode scalar value dans la plage `U+0000..U+10FFFF`, et pas la plage des surrogates `U+D800..U+DFFF`.
- Un U+FEFF en tête de Payload (suite d'octets UTF-8 `EF BB BF`) est lui aussi considéré comme le même caractère qu'un U+FEFF à toute autre position, et il est admis. Le traitement de la signature (BOM) U+FEFF initiale décrit par la RFC 3629 n'est pas appliqué. Il n'est ni retiré ni interprété comme une signature, mais conservé tel quel.
- La Unicode normalization n'est pas imposée. La scalar sequence d'origine décodée est conservée telle quelle.
- La suite d'octets UTF-8 valide est placée dans le Payload sans conversion. Dans un WORD, l'octet de poids fort vient en premier. Si le nombre d'octets est impair (code impair), l'octet de poids faible inutilisé du dernier WORD doit être `00`.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, on rejette si l'octet de poids faible du dernier WORD n'est pas `00`.

## Fondement normatif {#표준-근거}

- La plage des scalar et les suites d'octets well-formed d'UTF-8 suivent la [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- La paire de codes pair/impair, le zero padding, ainsi que le TAG/Length de GEUL et la disposition en WORD de 16 bits sont les règles de canonical framing de ce format.

## Longueur {#길이}

- Le total est le nombre de WORD : TAG 1 WORD, plus le TAG d'extension Length (s'il existe) et le Payload. Jusqu'à 14 WORD, la longueur est directe ; à partir de 15 WORD, on utilise la longueur étendue `1110`·`1111`, et le TAG d'extension est aussi compté dans le total ([Length](../record.md)).
- Une chaîne de 0 octet s'écrit comme un enregistrement de 1 WORD (TAG WORD seul) du code pair ([Value](_index.md)).

## Exemple {#예시}

- `A` (`41`) fait 1 octet (impair), donc `UTF8-TEXT-ODD` (`0x073L`), Payload `4100`, total 2 WORD, `LLLL=0001`. Le total est `0731 4100`.
- La chaîne vide est `0720` (`UTF8-TEXT-EVEN`, TAG WORD seul), soit 1 WORD.

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00000720/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

Ce qui précède est le document de Codec de `UTF8-TEXT-EVEN` (`0x072L`). Le document de Codec de l'autre membre (`UTF8-TEXT-ODD`) ne diffère que par le Codec ID dans le DOC-ID, la cible de DECLARE et le nom lié en `#1` (BIND).
