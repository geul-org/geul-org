---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST est une Value fixe de 11 WORD qui contient l'intégralité du résultat SHA-1 de 160 bits, à n'employer que pour l'identification, comme les ID d'objets git."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST est une Value de largeur fixe qui contient l'intégralité du résultat de SHA-1. Code direct de Value `0x62`, famille BINARY. Le Payload fait exactement 10 WORD (160 bits) et la troncature (truncation) n'est pas admise.

**À n'employer que pour l'identification.** SHA-1 a perdu sa résistance aux collisions (SHAttered, 2017). Comme fondement d'intégrité ou de signature, on emploie [SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/). Ce format existe pour contenir tels quels les identifiants déjà fixés par SHA-1, typiquement les ID d'objets (ID de commit) d'un dépôt git SHA-1. Par exemple, la Version (ID de commit) de [TRANSFORMED-BY](/fr/grammar/meta/lineage/transformed-by/) se contient en 11 WORD au lieu d'un texte hex (22 WORD).

## Disposition

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interprétation et validité

- Les 20 octets du Payload se lisent dans l'ordre même de la sortie de SHA-1. Dans chaque WORD, l'octet de poids fort vient en premier (même cadrage que SHA-256-DIGEST).
- Si le Payload n'est pas de 10 WORD, ou si le résultat a été tronqué arbitrairement (ID abrégé de git, etc.), on rejette. Il n'y a ni descriptor ni remplissage.
- L'ID d'objet git est la valeur telle que git l'a calculée. Le SHA-1 de git est une variante avec détection de collisions (SHA-1DC), mais pour des entrées qui ne sont pas des attaques par collision, le résultat est celui de SHA-1.

## Fondement normatif

- L'algorithme SHA-1 et son résultat de 160 bits suivent le [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) du NIST.
- Le TAG GEUL et le cadrage en WORD de 16 bits sont des règles ajoutées par ce format.

## Longueur

- Le total est exactement de 11 WORD, soit le TAG de 1 WORD plus le Payload de 10 WORD, avec `LLLL=1010`. Il n'y a pas d'extension de Length.

## Exemple

Commit git `ddc0719974a32aaa7b422ee84221a9721085ce4c` :

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Pages liées

- [Value](/fr/grammar/value/), [SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/fr/grammar/meta/lineage/transformed-by/)
