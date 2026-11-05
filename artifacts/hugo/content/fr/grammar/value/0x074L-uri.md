---
title: "URI (0x074L·0x075L)"
weight: 116
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI est un Value qui contient une suite d'octets ASCII suivant la grammaire des URI de la RFC 3986 (URI absolu avec scheme)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI est un Value qui contient une suite d'octets ASCII suivant la grammaire des URI de la RFC 3986 (URI absolu avec scheme). Il utilise la paire de codes d'octets pairs·impairs 0x074L/0x075L.

| Élément | Valeur |
|---|---|
| Nom | `URI` (groupe pair/impair. Le nom de chaque code figure dans le tableau des membres ci-dessous) |
| TAG ID | `0x074L`·`0x075L` |
| Section | 3 `0011` (Value), décalage dans la section C = 20~21 |
| Kind | Value · famille : TEXT |
| Description de l'index | Octets ASCII de la production `URI` de la RFC 3986. Octets pairs·impairs |
| Côté Hugo | `value/text/uri.md` |

## Membres {#구성원}

Cette page traite ensemble deux codes formant une paire pair/impair. Le code pair correspond à un nombre d'octets pair, le code impair à un nombre d'octets impair ([Enregistrement et TAG WORD](../record.md#가변-길이-바이트열)). Il y a un document de Codec par code. Les champs des deux documents de Codec sont identiques ; seuls la cible de DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Nombre d'octets | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x074L` | `URI-EVEN` | pair | `0x00000740` | `0x00000000/codecs/0x00000740/` | `0000 0111 0100 LLLL` |
| `0x075L` | `URI-ODD` | impair | `0x00000750` | `0x00000000/codecs/0x00000750/` | `0000 0111 0101 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | reste de valeur brute (`0xFFFF`) |  |  |

URI est un Value qui contient une suite d'octets ASCII suivant la grammaire `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` de la RFC 3986. Comme il comporte un scheme, son interprétation n'exige pas de base URI.

## Disposition {#레이아웃}

- Code : codes directs de Value `0x074L` (octets pairs) · `0x075L` (octets impairs). Famille TEXT.
- Le nombre d'octets est déterminé par le bit de poids faible du Codec et par le nombre de WORD du Payload. Il vaut `2 × nombre de WORD du Payload − bit de poids faible`, et il n'y a pas de Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 010P LLLL      Codec 0x074L/0x075L
[TAG d'extension Length] si le total atteint 15 WORD ou plus
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interprétation et validité {#해석과-유효성}

- La suite d'octets doit respecter la grammaire `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` de la RFC 3986. Elle peut comporter query et fragment.
- Les terminals de la grammaire URI sont des caractères US-ASCII. Les caractères ASCII autorisés sont stockés tels quels, et lorsqu'un octet est codé en percent-encoding, on utilise la forme `pct-encoded = "%" HEXDIG HEXDIG`. On ne doit pas insérer directement de caractères non ASCII comme literal byte.
- `scheme` et `:` sont obligatoires. Pour une référence relative, on utilise [URI-RELATIVE-REF](ietf.geul.org/uri-relative-ref.md) (numéros de Codec IETF `0x00008000`·`0x00008001`).
- La production URI de la RFC 3986 n'admet pas la chaîne vide. Un enregistrement de 0 octet n'est pas valide.
- Dans un WORD, l'octet de poids fort vient en premier. Si le nombre d'octets est impair (code impair), l'octet de poids faible inutilisé du dernier WORD doit être `00`.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, on rejette si l'octet de poids faible du dernier WORD n'est pas `00`.

## Fondement normatif {#표준-근거}

- `URI`, les caractères d'URI et la grammaire du percent-encoding suivent la [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- La paire de codes pair/impair, le zero padding, ainsi que le TAG/Length de GEUL et la disposition en WORD de 16 bits sont les règles de framing de ce format.

## Longueur {#길이}

- Le total est le nombre de WORD : TAG 1 WORD, plus le TAG d'extension Length (s'il existe) et le Payload. Jusqu'à 14 WORD, la longueur est directe ; à partir de 15 WORD, on utilise la longueur étendue `1110`·`1111`, et le TAG d'extension est aussi compté dans le total ([Length](../record.md)).

## Exemple {#예시}

- `https://example.com/` fait 20 octets ASCII (pair), c'est donc `URI-EVEN` (`0x074L`).
- Le Payload est de 10 WORD : `6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.
- TAG 1 WORD plus Payload 10 WORD font un total de 11 WORD, donc `LLLL=1010`. Le total est `074A 6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.

## GEUL Archive URI {#geul-archive-uri}

`archive.geul.org` est conçu comme un dépôt de contenu immuable pour référencer, depuis GEUL, des contenus volumineux tels que des binaires et documents externes ; il n'est pas encore en service. Le format d'adresse recommandé est `https://archive.geul.org/sha256/{digest}`. Les mêmes octets doivent avoir le même URI, et une fois publié, il ne faut pas modifier les octets d'un même URI.

Le Value URI ne fait que représenter l'emplacement ou la chaîne d'adresse d'un contenu externe ; il ne garantit ni l'identité ni l'immuabilité de la cible elle-même. Les binaires et textes dépassant la portée maximale d'un Value en ligne peuvent être référencés par un archive URI. Les métadonnées de l'objet stocké doivent consigner les éléments suivants.

- URI d'origine et heure de collecte
- SHA-256 et Byte Length
- MIME type
- license identifier et version
- auteur, source et mentions
- URI du fondement de la licence et, si nécessaire, copie du fondement au moment de la collecte

On juge de la possibilité de collecte non pas selon que l'accès est gratuit, mais selon que le droit de redistribution est explicitement confirmé. Il faut respecter les conditions de licence applicables, telles que l'attribution, l'usage non commercial, l'interdiction de modification et le partage dans les mêmes conditions. Pour les documents et contenus, on consigne une licence explicite comme Creative Commons ; pour les logiciels, on utilise si possible le SPDX License ID.

Même si l'on cesse de fournir un contenu pour une question de droits ou une correction, il ne faut pas placer d'autres octets sous l'URI existant. Cet URI doit renvoyer un tombstone contenant le motif et l'heure de l'interruption, et conserver le digest d'origine et les journaux d'audit. Toutefois, si une obligation légale interdit la conservation des journaux d'audit, cette obligation prévaut.

L'archive URI fournit à la fois l'emplacement d'accès et le digest du contenu. Cette règle de content-address et d'immuabilité est une politique du profil GEUL Archive ; la grammaire générale du Value URI ne dépend pas de `archive.geul.org`.

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00000740/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000074000000000
BODY
#1 DECLARE 0x0740
#2 FIELD #1 rest
#3 BIND #1 "URI-EVEN"
#4 BIND #2 "bytes"
```

Ce qui précède est le document de Codec de `URI-EVEN` (`0x074L`). Le document de Codec de l'autre membre (`URI-ODD`) ne diffère que par le Codec ID dans le DOC-ID, la cible de DECLARE et le nom lié en `#1` (BIND).
