---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD et DOC-4WORD sont des Meta de structure qui ouvrent le document en indiquant son nombre total de WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Enregistrement qui ouvre le document. Son Payload indique le nombre total de WORD du document. `DOC-1WORD` (`0x00`), `DOC-2WORD` (`0x01`) et `DOC-4WORD` (`0x02`) sont traités ensemble dans cette page.

## Disposition

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[TAG d'extension de Length]
Payload           nombre total de WORD. Le Codec fixe la largeur : DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec : Meta `0x00` à `0x02`, classe de structure (`000`)
- Payload : valeur brute (nombre total de WORD du document, non signé)
- Nombre : un par document, tout au début

## Interprétation et validité

- La longueur va du début de l'enregistrement d'ouverture à la fin de [END](/fr/grammar/meta/structure/end/).
- On utilise la plus petite largeur qui contient la valeur. Un encodage dans une largeur plus grande est un encodage non canonique et est rejeté.
- La longueur doit être égale à celle de l'entrée entière. Un document correspond à une entrée.
- Le décodeur peut sauter tout le document grâce à cette longueur. Aucun Codec n'ouvre un document dont la longueur est inconnue.
- Pour calculer le hachage du contenu, on réécrit avec la longueur sans les Meta de la classe de vérification, dans la largeur correspondante ([Hachage du contenu](/fr/grammar/document/#hachage-du-contenu)).

## Exemple

- `0x1880 0x0017` : DOC-1WORD, 23 WORD au total
