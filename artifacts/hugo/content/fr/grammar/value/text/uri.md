---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI est une Value qui contient une suite d'octets ASCII de la grammaire URI de la RFC 3986 (URI absolu avec scheme). Elle emploie la paire de codes d'octets pair/impair 0x44/0x45."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI est une Value qui contient une suite d'octets ASCII de la grammaire `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` de la RFC 3986. Comme elle contient le scheme, son interprétation n'a pas besoin d'URI de base.

## Disposition

- Code : code direct de Value `0x44` (nombre d'octets pair) et `0x45` (impair). Famille TEXT.
- Le nombre d'octets est fixé par le bit de poids faible du Codec et le nombre de WORD du Payload. C'est `2 × nombre de WORD du Payload − bit de poids faible`, sans Byte Count ([Value](/fr/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er ... Nème          URI bytes / final zero padding
```

## Interprétation et validité

- La suite d'octets doit être conforme à la grammaire `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` de la RFC 3986. Elle peut contenir query et fragment.
- Les terminaux de la grammaire URI sont des caractères US-ASCII. Les caractères ASCII admis sont stockés tels quels, et pour encoder un octet en pourcentage on emploie la forme `pct-encoded = "%" HEXDIG HEXDIG`. On ne doit pas mettre directement de caractères non ASCII comme octets littéraux.
- Elle contient obligatoirement le `scheme` et `:`. Les références relatives emploient [URI-RELATIVE-REF](/fr/grammar/value/text/uri-relative-ref/) (numéros de format IETF `0x8000` et `0x8001`).
- La production URI de la RFC 3986 n'admet pas la chaîne vide. Un enregistrement de 0 octet n'est pas valide.
- Dans un WORD, l'octet de poids fort vient en premier. Si le nombre d'octets est impair (code impair), l'octet de poids faible inutilisé du dernier WORD doit être `00`.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, si l'octet de poids faible du dernier WORD n'est pas `00`, on rejette.

## Fondement normatif

- La grammaire de `URI`, des caractères d'URI et du codage en pourcentage suit la [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- La paire de codes pair/impair, le zero padding, le TAG et la Length de GEUL et la disposition en WORD de 16 bits sont les règles de cadrage de ce format.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Length](/fr/grammar/record/)).

## Exemple

- `https://example.com/` fait 20 octets ASCII (pair), donc `URI-EVEN` (`0x44`).
- Le Payload fait 10 WORD : `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.
- Avec le TAG de 1 WORD et le Payload de 10 WORD, on a 11 WORD au total, donc `LLLL=1010`. L'ensemble est `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.

## GEUL Archive URI

`archive.geul.org` est un dépôt de contenu immuable prévu pour permettre à GEUL de référencer de gros contenus comme des binaires ou documents externes. Il n'est pas encore en service. Le format d'adresse recommandé est `https://archive.geul.org/sha256/{digest}`. Une même suite d'octets doit avoir le même URI et, une fois publiée, les octets d'un même URI ne doivent pas être changés.

La Value URI ne fait que représenter la localisation ou la chaîne d'adresse d'un contenu externe, et ne garantit ni l'identité ni l'immuabilité de la cible elle-même. Les binaires et textes dépassant l'étendue maximale d'une Value en ligne peuvent être référencés par un URI d'archive. Les métadonnées de l'objet stocké doivent consigner les éléments suivants.

- L'URI d'origine et l'instant de collecte
- Le SHA-256 et la Byte Length
- Le MIME type
- Le license identifier et sa version
- L'auteur, la provenance et les mentions
- L'URI du fondement de la licence et, si nécessaire, une copie de ce fondement au moment de la collecte

La possibilité de collecter se juge non sur la gratuité de l'accès mais sur la confirmation explicite du droit de redistribution. Il faut respecter les conditions de licence applicables (attribution, non commercial, pas de modification, partage dans les mêmes conditions, etc.). Pour les documents et contenus, on consigne une licence explicite comme Creative Commons ; pour les logiciels, on emploie si possible un SPDX License ID.

Même si l'on cesse de fournir un contenu pour une question de droits ou une correction, on ne doit pas placer d'autres octets sous l'URI existant. Cet URI renvoie une tombstone contenant le motif et l'instant de l'arrêt, et le digest d'origine et le journal d'audit doivent être conservés. Toutefois, si une obligation légale interdit la conservation du journal d'audit, cette obligation prime.

L'URI d'archive fournit à la fois la localisation d'accès et le digest du contenu. Cette règle d'adressage par contenu et d'immuabilité est une politique du profil GEUL Archive, et la grammaire générale de la Value URI ne dépend pas de `archive.geul.org`.
