---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES est un format d'Issuer GEUL qui contient une suite d'octets quelconque dont il ne fixe lui-même ni le sens ni le format."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES est une suite d'octets quelconque dont ce format ne fixe lui-même ni le sens ni le format. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, numéros de format `0xC000` et `0xC001` (nombre d'octets pair et impair), famille BINARY. Le nombre d'octets est fixé par le bit de poids faible du numéro de format et le nombre de WORD du Payload. C'est `2 × nombre de WORD du Payload − bit de poids faible`, sans Byte Count ([Value](/fr/grammar/value/)).

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG d'extension de Length] à partir de 15 WORD au total
Issuer            1 WORD  0x0000 (GEUL)
Numéro de format  1 WORD  0xC000/0xC001
Payload WORD 1er ... Nème   octets / zero padding final
```

## Interprétation et validité

- On lit dans l'ordre, dans le Payload, autant d'octets que le nombre d'octets. Dans un WORD, l'octet de poids fort vient en premier.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, si l'octet de poids faible du dernier WORD n'est pas `00`, on rejette.
- Si le code pair/impair, le nombre de WORD du Payload et le zero padding ne concordent pas, on rejette.

## Statut du format

- La paire de codes pair/impair, la disposition du payload et le zero padding du dernier WORD ne citent pas de norme industrielle externe : c'est un cadrage propre à GEUL.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'Issuer de 1 WORD, du numéro de format de 1 WORD et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Enregistrement et TAG WORD](/fr/grammar/record/)).
- 0 octet s'écrit comme un enregistrement de 3 WORD sans Payload (TAG, Issuer, numéro de format) sous le numéro de format pair (`0xC000`).

## Exemple

Les octets `ab cd ef` font 3 octets (impair), donc numéro de format `0xC001`, Payload `abcd ef00`. Avec 5 WORD au total, `LLLL=0100`.

```
0A7C 0000 C001 abcd ef00
```
