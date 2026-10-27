---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY est un Meta de politique qui consigne en 1 WORD le niveau de données personnelles du document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne le niveau de données personnelles du document.

## Disposition

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[TAG d'extension de Length]
niveau            1 WORD
```

- Codec : Meta `0x52`, classe de politique (`101`)
- Payload : valeur brute (niveau, 1 WORD)
- Nombre : au plus un

## Interprétation et validité

- Ne modifie pas l'interprétation. Fixe seulement le traitement.

## Problèmes ouverts

- Table des codes de niveau (correspondance avec les classifications de la loi sur la protection des données personnelles).
