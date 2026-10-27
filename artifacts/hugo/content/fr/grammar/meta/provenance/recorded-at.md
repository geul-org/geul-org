---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT est un Meta de provenance qui consigne sous forme de Value TIME l'instant d'enregistrement du document (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne l'instant d'enregistrement du document (git commit date).

## Disposition

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[TAG d'extension de Length]
Payload           une Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec : Meta `0x25`, classe de provenance (`010`)
- Payload : Value intégré (famille TIME : [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/fr/grammar/value/time/posix-timestamp-seconds/), etc.)
- Nombre : au plus un

## Interprétation et validité

- Le format se choisit parmi les Value de la famille TIME. Si une précision est nécessaire, on utilise un format en nanosecondes défini par l'Issuer (par exemple [POSIX-TIMESTAMP-NANOSECONDS](/fr/grammar/value/time/posix-timestamp-nanoseconds/)).
- Le document de liste de versions ([PUBLICATION](/fr/grammar/edge/publication/)) utilise cette valeur comme instant de publication, de dépréciation (deprecate) et de suppression.

## Problèmes ouverts

- Les Meta de provenance entrent dans le hachage du contenu. Faut-il admettre que le même contenu enregistré à un autre instant donne un hachage différent.
