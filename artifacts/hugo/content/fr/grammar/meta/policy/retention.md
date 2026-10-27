---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION est un Meta de politique qui consigne la durée de conservation du document sous forme de Value d'instant d'expiration ou de durée."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne la durée de conservation du document.

## Disposition

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[TAG d'extension de Length]
Payload           instant d'expiration (GREGORIAN-DATE, etc.) ou durée (DURATION-SECONDS)
```

- Codec : Meta `0x53`, classe de politique (`101`)
- Payload : Value intégré (famille TIME : [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/), etc., ou [DURATION-SECONDS](/fr/grammar/value/time/duration-seconds/))
- Nombre : au plus un

## Interprétation et validité

- S'il s'agit d'une durée, elle se compte à partir de [RECORDED-AT](/fr/grammar/meta/provenance/recorded-at/).
