---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE est un Meta de politique qui consigne des restrictions d'usage, comme l'interdiction d'entraînement ou l'interdiction d'usage commercial."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne les restrictions d'usage (par exemple interdiction d'entraînement, interdiction d'usage commercial).

## Disposition

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[TAG d'extension de Length]
Payload           texte ou Reference exprimant la restriction d'usage
```

- Codec : Meta `0x55`, classe de politique (`101`)
- Payload : Value ou Reference intégré
- Nombre : plusieurs possibles

## Problèmes ouverts

- Table des codes de types de restriction.
