---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM est un Meta de définition qui déclare, sous forme de Value de date ou d'horodatage, la date d'entrée en vigueur de cette version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Déclare la date d'entrée en vigueur de cette version. Elle diffère de l'instant de publication ([Révision](/fr/grammar/document/#révision)).

## Disposition

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[TAG d'extension de Length]
Payload           une Value TIME
```

- Codec : Meta `0x13`, classe de définition (`001`)
- Payload : Value intégré ([GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/) ou [POSIX-TIMESTAMP-SECONDS](/fr/grammar/value/time/posix-timestamp-seconds/))
- Nombre : au plus un

## Interprétation et validité

- S'il est absent, la version entre en vigueur à l'instant de publication.
- S'il existe un [EFFECTIVE-UNTIL](/fr/grammar/meta/declaration/effective-until/), cette valeur doit lui être antérieure.
- Si la date d'entrée en vigueur diffère selon l'article, elle est notée séparément dans l'Edge de l'article par un QUALIFIER P580 (début) et P582 (fin) ([SOURCE](/fr/grammar/edge/source/#expression-des-autres-fondements)).
- Cette valeur est lue lorsque le document est interprété à un instant donné.

## Exemple

- Entrée en vigueur le 1970-01-02 : `0x1993 0x0920 0x0000 0x0001`
