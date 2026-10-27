---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR est un format d'Issuer GEUL qui contient N bits en MSB-first après un nombre de bits N sur 32 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR est une suite de bits brute dont la longueur est indiquée. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, numéro de format `0xC002`, famille BINARY. Les 2 premiers WORD du Payload sont le bit count `N` unsigned sur 32 bits, suivis de `ceil(N/16)` WORD.

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG d'extension de Length] à partir de 15 WORD au total
Issuer            1 WORD  0x0000 (GEUL)
Numéro de format  1 WORD  0xC002
Payload WORD 1er–2ème       Bit Count N (16 bits de poids fort │ 16 bits de poids faible)
Payload WORD 3ème ... Nème  Payload bits, MSB-first
```

## Interprétation et validité

- `N` est la valeur obtenue en lisant les 2 premiers WORD du Payload comme un entier unsigned de 32 bits big-endian.
- Les bits du payload se remplissent à partir du bit de poids le plus fort de chaque WORD.
- Le nombre de WORD du payload est exactement `ceil(N/16)` et les bits de poids faible inutilisés du dernier WORD doivent tous être 0.
- Si `N=0`, il n'y a pas de WORD de payload. Les deux WORD de count constituant déjà le Payload, cela n'entre pas en conflit avec la règle du Payload minimal de 1 WORD.

## Statut du format

- Le bit count unsigned de 32 bits, la disposition MSB-first et le zero padding du dernier WORD ne citent pas de norme industrielle externe : c'est un cadrage propre à GEUL.
- Cette page définit la représentation, y compris les règles de TAG, Length et WORD de 16 bits de GEUL.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'Issuer de 1 WORD, du numéro de format de 1 WORD et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Enregistrement et TAG WORD](/fr/grammar/record/)).

## Exemple

- Un bit vector vide a le count `0000 0000`, pas de payload, 5 WORD au total, `LLLL=0100`.
- La suite de bits `101` a le count `0000 0003`, le payload `a000`, 6 WORD au total, `LLLL=0101`.
