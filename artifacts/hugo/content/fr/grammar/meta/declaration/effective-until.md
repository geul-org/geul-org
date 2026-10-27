---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL est un Meta de définition qui déclare, sous forme de Value de date ou d'horodatage, la fin de la période de validité de cette version (loi temporaire)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Déclare la fin de la période de validité de cette version (loi temporaire). À partir de cet instant, cette version n'est plus en vigueur.

## Disposition

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[TAG d'extension de Length]
Payload           une Value TIME
```

- Codec : Meta `0x14`, classe de définition (`001`)
- Payload : Value intégré ([GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/) ou [POSIX-TIMESTAMP-SECONDS](/fr/grammar/value/time/posix-timestamp-seconds/))
- Nombre : au plus un

## Interprétation et validité

- S'il est absent, la version reste valide jusqu'à l'entrée en vigueur de la version suivante.
- Une fois la période de validité écoulée, aucune édition n'est en vigueur. Les anciennes éditions ne reprennent pas effet.
