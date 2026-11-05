---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF est une Value qui contient une suite d'octets ASCII conforme à la grammaire `relative-ref` de la RFC 3986. Le base URI et le résultat résolu ne sont pas placés dans le Payload."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


URI-RELATIVE-REF est une Value qui contient une suite d'octets ASCII conforme à la grammaire `relative-ref` de la RFC 3986. Le base URI et le résultat résolu ne sont pas placés dans le Payload.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, numéro de Codec `0x00008000` (nombre pair d'octets) ou `0x00008001` (nombre impair d'octets). Famille TEXT.
- Le nombre d'octets est déterminé par le bit de poids faible du numéro de Codec et par le nombre de WORD du Payload : `2 × nombre de WORD du Payload − bit de poids faible`. Il n'y a pas de Byte Count ([Value](../_index.md)).

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG d'extension de Length] si 15 WORD ou plus au total
Issuer            2 WORD  0x00000007 (IETF)
Numéro de Codec   2 WORD  0x00008000/0x00008001
Payload WORD 1er ... Nème         relative-ref bytes / final zero padding
```

## Interprétation et validité {#해석과-유효성}

- La suite d'octets doit être conforme à la grammaire `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` de la RFC 3986.
- Les terminals de la grammaire URI sont des caractères US-ASCII. Les caractères ASCII autorisés sont stockés tels quels, et lorsqu'un octet est encodé en percent-encoding, on utilise la forme `pct-encoded = "%" HEXDIG HEXDIG`. On ne doit pas insérer directement de caractères non ASCII comme octets littéraux.
- `relative-part` pouvant être `path-empty`, une suite d'octets vide est elle aussi un `relative-ref` grammaticalement valide.
- Le base URI, le contexte de résolution et le résultat de la résolution relèvent d'un contexte extérieur à ce format.
- Dans un WORD, l'octet de poids fort vient en premier. Si le nombre d'octets est impair (code impair), l'octet de poids faible inutilisé du dernier WORD doit valoir `00`.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Si le code est impair et que l'octet de poids faible du dernier WORD n'est pas `00`, on rejette.

## Référence normative {#표준-근거}

- La grammaire de `relative-ref`, des caractères URI et du percent-encoding suit la [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- La paire de codes pair/impair, le zero padding, le TAG et la Length de GEUL et la disposition en WORD de 16 bits sont les règles de framing de ce format. Le base URI et le résultat de l'interprétation de la référence relèvent du contexte de la RFC, mais ne sont pas placés dans le Payload.

## Length {#길이}

- Le total est le nombre de WORD obtenu en additionnant TAG 1 WORD, TAG d'extension de Length (s'il existe), Issuer 2 WORD, numéro de Codec 2 WORD et Payload. Jusqu'à 14 WORD, on utilise la longueur directe ; à partir de 15 WORD, la longueur étendue `1110`·`1111`, et le TAG d'extension est compté dans le total ([Length](../../record.md)).
- 0 octet est sémantiquement permis comme `relative-ref` vide, et il n'y a alors aucun WORD de Payload. Sa disposition physique est le problème ouvert ci-dessous.

## Exemple {#예시}

- `a/b?x=1` fait 7 octets (impair) ; le numéro de Codec est donc `0x00008001` et le Payload `612F 623F 783D 3100`. Le total étant de 9 WORD, `LLLL=1000`. L'ensemble est `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## Problèmes ouverts {#열린-문제}

- Disposition physique d'un `relative-ref` vide (0 octet). Un enregistrement sans Payload ne s'accorde pas avec la règle du « Payload minimal de 1 WORD », et elle n'est donc pas encore fixée.
