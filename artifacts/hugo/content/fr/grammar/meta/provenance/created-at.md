---
title: "CREATED-AT"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CREATED-AT est un Meta de provenance qui consigne sous forme de Value TIME l'instant de rédaction du document (git author date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne l'instant de rédaction du document (git author date).

## Disposition

```
TAG WORD          0001 1LLL L010 0010      Codec 0x22
[TAG d'extension de Length]
Payload           une Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec : Meta `0x22`, classe de provenance (`010`)
- Payload : Value intégré (famille TIME : [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/fr/grammar/value/time/posix-timestamp-seconds/), etc.)
- Nombre : au plus un

## Interprétation et validité

- Le format se choisit parmi les Value de la famille TIME. Si une précision est nécessaire, on utilise un format en nanosecondes défini par l'Issuer (par exemple [POSIX-TIMESTAMP-NANOSECONDS](/fr/grammar/value/time/posix-timestamp-nanoseconds/)).
