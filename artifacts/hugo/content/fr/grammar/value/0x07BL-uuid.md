---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID est un Value de largeur fixe qui contient la valeur de 128 bits d'un UUID de la RFC 9562."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `UUID` (BIND `UUID` du document de spécification) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| Document de spécification | `0x00000000/codecs/0x000007B0/` (cible de DECLARE `07B0`) |
| Section | 3 `0011` (Value), décalage dans la section C = 27 |
| Kind | Value · famille : BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description de l'index | UUID de la RFC 9562 sur 128 bits, Payload fixe de 8 WORD |
| Côté Hugo | `value/binary/uuid.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | valeur brute de 8 WORD |  |  |

UUID est un Value de largeur fixe qui contient la valeur de 128 bits d'un UUID de la RFC 9562. C'est le code direct de Value `0x07BL`, famille BINARY. Le Payload fait exactement 8 WORD (16 octets, 128 bits).

## Disposition {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  total 9 WORD
Payload           8 WORD (128 bits)  octet 0 → octet 15 de l'UUID
```

## Interprétation et validité {#해석과-유효성}

- On groupe deux par deux, dans l'ordre, les octets canoniques de l'UUID de la RFC 9562, de l'octet 0 à l'octet 15. L'octet qui vient en premier est celui des 8 bits de poids fort du WORD. Les field, version bit et variant bit de l'UUID ne sont ni réordonnés ni réencodés.
- La chaîne hex-and-dash `8-4-4-4-12` n'est qu'une représentation d'entrée/sortie. La casse et les tirets n'entrent pas dans le Payload ; seuls les 16 octets issus de l'analyse sont stockés.
- Ce Value UUID conserve sans perte le motif de 128 bits. Pour le variant RFC 9562 `10xx`, les versions 1, 3, 4, 5, 6 et 7 ont une layout standard et la version 8 est un format d'UUID personnalisé. La version 2 est réservée à DCE Security et la RFC n'en fixe pas la layout ; la version 0 est unused, et les versions 9–15 sont réservées à de futures définitions. Les autres variants sont eux aussi réservés à la compatibilité ou à une définition future.
- Nil UUID est la valeur spéciale dont les 128 bits sont tous à zéro, et Max UUID celle dont les 128 bits sont tous à un. Les motifs de 128 bits comportant des version/variant réservés ou unused ne sont pas non plus exclus structurellement ; le sens et l'interopérabilité de ces motifs se jugent selon la norme applicable et le contexte externe.
- L'identité d'un UUID se juge à l'égalité de la valeur de 128 bits du Payload. Le fait que deux valeurs soient égales ne garantit ni l'authentification, ni la propriété, ni l'existence actuelle, ni la résolubilité, ni le droit d'accès de la cible.
- Pour stocker un GUID COM de Microsoft, on ne copie pas tel quel sa représentation mixed-endian en mémoire ou sérialisée. On la convertit d'abord en 16 octets dans l'ordre canonique de field/octet de la RFC 9562.
- On rejette si le Payload n'est pas exactement 8 WORD.

## Fondement normatif {#표준-근거}

- La [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) définit l'UUID comme 16 octets (128 bits) et encode les field most-significant-byte-first, de sorte que le format binaire les enchaîne dans l'ordre des field big-endian. Le variant se trouve dans les bits de poids fort de l'octet 8 et la version dans les 4 bits de poids fort de l'octet 6 ; ce format conserve ces positions telles quelles.
- Les sections 4.1–5.10 de la RFC 9562 distinguent variant, versions 1–8, Nil, Max et plages réservées. La RFC 9562 remplace la RFC 4122, donc la norme en vigueur pour ce format est la RFC 9562.
- L'ABNF hex-and-dash de la RFC 9562 est une représentation textuelle, et la réserve sur le little-endian des GUID COM y est signalée à part. GEUL ne place dans le Payload que les 16 octets canoniques de l'UUID de la RFC.
- Le TAG de GEUL, la Length directe et le framing en WORD de 16 bits ne font pas partie de la RFC 9562 ; ce sont des règles ajoutées par ce format.

## Longueur {#길이}

- Le total est exactement 9 WORD, TAG 1 WORD plus Payload 8 WORD, avec la longueur directe `LLLL=1000`. Il n'y a ni TAG d'extension Length, ni descriptor, ni padding.
- On rejette si le Payload n'est pas exactement 8 WORD.

## Exemple {#예시}

Le test vector UUIDv7 de la RFC 9562, Appendix A.6, `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` :

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`, Payload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`.

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000007B0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
