---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL est une Value fixe de 2 WORD qui contient les valeurs logiques false et true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL est une Value qui représente les valeurs logiques false et true. Code direct de Value `0x00`, famille NUMERIC. C'est un type différent de SIGNED-INTEGER et UNSIGNED-INTEGER, qui contiennent les nombres 0 et 1.

## Disposition

```
TAG WORD          0x0880 (0000 1000 1000 0000)  2 WORD au total
Payload           1 WORD  Boolean Code
```

## Interprétation et validité

- Le Payload `0000` est false, `0001` est true.
- Il n'y a ni remplissage ni descriptor.
- Le Payload est exactement `0000` ou `0001`. Toute autre valeur de 16 bits est rejetée comme invalid.
- Toute autre expression de Length est rejetée comme invalid.

## Longueur

- Le total est exactement de 2 WORD, soit le TAG de 1 WORD plus le Payload de 1 WORD, avec la longueur directe `LLLL=0001`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 1 WORD, on rejette.

## Exemple

| Enregistrement complet (TAG + Payload) | Payload | Verdict |
|---|---|---|
| `0880 0000` | `0000` | false, canonique |
| `0880 0001` | `0001` | true, canonique |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| TAG dont la Length n'est pas `0001` + `0000` ou `0001` | `0000` ou `0001` | invalid |

## Statut du format

- Cette expression, qui associe le code de 16 bits `0000`/`0001` et le TAG GEUL, est un profil de scalaire propre à GEUL.
- La valeur logique elle-même est universelle, mais on ne prétend pas qu'il existe une norme industrielle unique correspondant à cette expression sur 1 WORD.
