---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF est une Value qui contient une suite d'octets ASCII de la grammaire relative-ref de la RFC 3986. Elle emploie les numéros de format 0x8000/0x8001 de l'Issuer IETF."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF est une Value qui contient une suite d'octets ASCII de la grammaire `relative-ref` de la RFC 3986. L'URI de base et le résultat de la résolution ne se mettent pas dans le Payload.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, numéro de format `0x8000` (nombre d'octets pair) et `0x8001` (impair). Famille TEXT.
- Le nombre d'octets est fixé par le bit de poids faible du numéro de format et le nombre de WORD du Payload. C'est `2 × nombre de WORD du Payload − bit de poids faible`, sans Byte Count ([Value](/fr/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG d'extension de Length] à partir de 15 WORD au total
Issuer            1 WORD  0x0020 (IETF)
Numéro de format  1 WORD  0x8000/0x8001
Payload WORD 1er ... Nème          relative-ref bytes / final zero padding
```

## Interprétation et validité

- La suite d'octets doit être conforme à la grammaire `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` de la RFC 3986.
- Les terminaux de la grammaire URI sont des caractères US-ASCII. Les caractères ASCII admis sont stockés tels quels, et pour encoder un octet en pourcentage on emploie la forme `pct-encoded = "%" HEXDIG HEXDIG`. On ne doit pas mettre directement de caractères non ASCII comme octets littéraux.
- `relative-part` pouvant être `path-empty`, une suite d'octets vide est elle aussi un `relative-ref` grammaticalement valide.
- L'URI de base, le contexte de résolution et le résultat de la résolution relèvent d'un contexte extérieur à ce format.
- Dans un WORD, l'octet de poids fort vient en premier. Si le nombre d'octets est impair (code impair), l'octet de poids faible inutilisé du dernier WORD doit être `00`.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, si l'octet de poids faible du dernier WORD n'est pas `00`, on rejette.

## Fondement normatif

- La grammaire de `relative-ref`, des caractères d'URI et du codage en pourcentage suit la [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- La paire de codes pair/impair, le zero padding, le TAG et la Length de GEUL et la disposition en WORD de 16 bits sont les règles de cadrage de ce format. L'URI de base et le résultat de l'interprétation de la référence relèvent du contexte de la RFC mais ne se mettent pas dans le Payload.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'Issuer de 1 WORD, du numéro de format de 1 WORD et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Length](/fr/grammar/record/)).
- 0 octet est admis par le sens comme `relative-ref` vide et n'a pas de WORD de Payload. Sa disposition physique est un problème ouvert ci-dessous.

## Exemple

- `a/b?x=1` fait 7 octets (impair), donc numéro de format `0x8001`, Payload `612f 623f 783d 3100`. Avec 7 WORD au total, `LLLL=0110`. L'ensemble est `0B7C 0020 8001 612f 623f 783d 3100`.

## Problèmes ouverts

- Disposition physique du `relative-ref` vide (0 octet). Un enregistrement sans Payload ne cadre pas avec la règle du « Payload minimal de 1 WORD », donc elle n'est pas encore fixée.
