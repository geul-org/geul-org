---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST est un Value de largeur fixe qui contient l'intégralité du résultat de SHA-256, de la famille SHA-2."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `SHA-256-DIGEST` (BIND `SHA-256-DIGEST` du document de spécification) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| Document de spécification | `0x00000000/codecs/0x000007C0/` (cible de DECLARE `07C0`) |
| Section | 3 `0011` (Value), décalage dans la section C = 28 |
| Kind | Value · famille : BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description de l'index | Résultat de SHA-256, Payload fixe de 16 WORD |
| Côté Hugo | `value/binary/sha-256-digest.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | valeur brute de 16 WORD |  |  |

SHA-256-DIGEST est un Value de largeur fixe qui contient l'intégralité du résultat de SHA-256, de la famille SHA-2. C'est le code direct de Value `0x07CL`, famille BINARY. Le Payload fait exactement 16 WORD (256 bits) et la troncature (truncation) n'est pas admise.

## Disposition {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
TAG d'extension Length   1 WORD  0x0012 (total 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## Interprétation et validité {#해석과-유효성}

- On lit les 32 octets du Payload dans l'ordre même de la sortie de SHA-256. Dans chaque WORD, l'octet de poids fort vient en premier.
- Aucune conversion d'endian propre à GEUL n'est appliquée au digest bit string. On se contente de grouper la suite d'octets de sortie deux par deux, dans l'ordre, pour la framer en WORD big-endian de 16 bits.
- On rejette un Payload qui n'est pas de 16 WORD, ou une représentation dont le résultat a été tronqué arbitrairement. Il n'y a ni descriptor ni padding.

## Fondement normatif {#표준-근거}

- L'algorithme SHA-256 et son résultat de 256 bits suivent la norme NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- Le TAG, la Length et le framing en WORD de 16 bits de GEUL sont des règles ajoutées par ce format et ne font pas partie de l'algorithme SHA-2.

## Longueur {#길이}

- Le total est exactement 18 WORD, somme de TAG 1 WORD, TAG d'extension Length 1 WORD et Payload 16 WORD, avec `LLLL=1110`. Il n'y a ni descriptor ni padding.
- On rejette si le Payload n'est pas exactement 16 WORD.

## Exemple {#예시}

- Les octets du digest `d[0]` à `d[31]` se placent dans l'ordre en WORD du Payload, de `(d[0]<<8)|d[1]` à `(d[30]<<8)|d[31]`. La Length totale est toujours de 18 WORD.

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000007C0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
