---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY est un Meta de structure de 1 WORD qui termine le HEAD du document et commence le BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Enregistrement qui termine le HEAD et commence le BODY.

## Disposition

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[TAG d'extension de Length]
```

- Codec : Meta `0x0E`, classe de structure (`000`)
- Payload : aucun (1 WORD)
- Nombre : au plus un par document

## Interprétation et validité

- Omis si le HEAD est vide. Dans un document sans `BODY`, tout est BODY. On le place si le HEAD contient des Meta ou des Edge de HEAD (le [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du document entier et ses QUALIFIER).
- Pas de Payload. Le total est de 1 WORD.

## Exemple

- `0x180E`
