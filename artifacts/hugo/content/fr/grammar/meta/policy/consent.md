---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT est un Meta de politique qui consigne par un Reference ou un texte l'étendue et le fondement du consentement."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne l'étendue et le fondement du consentement.

## Disposition

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[TAG d'extension de Length]
Payload           Reference ou texte désignant le fondement du consentement
```

- Codec : Meta `0x54`, classe de politique (`101`)
- Payload : Reference ou Value intégré
- Nombre : plusieurs possibles

## Problèmes ouverts

- Structure de l'expression de l'étendue (finalité, durée, communication à des tiers).
