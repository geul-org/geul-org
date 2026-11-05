---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST est un Value de largeur fixe qui contient l'intégralité du résultat de SHA-1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `SHA1-DIGEST` (BIND `SHA1-DIGEST` du document de spécification) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| Document de spécification | `0x00000000/codecs/0x000007D0/` (cible de DECLARE `07D0`) |
| Section | 3 `0011` (Value), décalage dans la section C = 29 |
| Kind | Value · famille : BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description de l'index | Résultat de SHA-1, Payload fixe de 10 WORD. Uniquement à des fins d'identification, comme un ID d'objet git |
| Côté Hugo | `value/binary/sha1-digest.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | valeur brute de 10 WORD |  |  |

SHA1-DIGEST est un Value de largeur fixe qui contient l'intégralité du résultat de SHA-1. C'est le code direct de Value `0x07DL`, famille BINARY. Le Payload fait exactement 10 WORD (160 bits) et la troncature (truncation) n'est pas admise.

**À n'utiliser qu'à des fins d'identification.** La résistance aux collisions de SHA-1 est brisée (SHAttered, 2017). Comme fondement d'intégrité ou de signature, on utilise [SHA-256-DIGEST](0x07CL-sha-256-digest.md). Ce format existe pour contenir tel quel un identifiant déjà fixé par SHA-1, typiquement l'ID d'objet (ID de commit) d'un dépôt git en SHA-1. Par exemple, il contient la Version (ID de commit) de [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) en 11 WORD au lieu d'un texte hex (22 WORD).

## Disposition {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interprétation et validité {#해석과-유효성}

- On lit les 20 octets du Payload dans l'ordre même de la sortie de SHA-1. Dans chaque WORD, l'octet de poids fort vient en premier (même framing que SHA-256-DIGEST).
- On rejette un Payload qui n'est pas de 10 WORD, ou une représentation dont le résultat a été tronqué arbitrairement (ID abrégé de git, etc.). Il n'y a ni descriptor ni padding.
- L'ID d'objet git est la valeur calculée par git, telle quelle. Le SHA-1 de git est une variante avec détection de collision (SHA-1DC), mais pour des entrées qui ne sont pas une attaque par collision, le résultat est identique à SHA-1.

## Fondement normatif {#표준-근거}

- L'algorithme SHA-1 et son résultat de 160 bits suivent la norme NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- Le TAG de GEUL et le framing en WORD de 16 bits sont des règles ajoutées par ce format.

## Longueur {#길이}

- Le total est exactement 11 WORD, TAG 1 WORD plus Payload 10 WORD, avec `LLLL=1010`. Il n'y a pas d'extension Length.

## Exemple {#예시}

Commit git `ddc0719974a32aaa7b422ee84221a9721085ce4c` :

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Pages liées {#관련-페이지}

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000007D0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
