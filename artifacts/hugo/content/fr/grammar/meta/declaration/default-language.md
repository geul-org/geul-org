---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE est un Meta de définition qui déclare, sous forme de Value de langue, la langue par défaut des textes du document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Déclare la langue par défaut des textes du document. Un texte dont la langue n'est pas indiquée est dans cette langue.

## Disposition

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[TAG d'extension de Length]
Payload           une Value de langue
```

- Codec : Meta `0x16`, classe de définition (`001`)
- Payload : Value intégré ([LANGUAGE-BCP47-CODE](/fr/grammar/value/text/language-bcp47-code/) ou [LANGUAGE-SHORT-CODE](/fr/grammar/value/text/language-short-code/))
- Nombre : au plus un

## Interprétation et validité

- Un document TANGEUL indique la locale de rédaction (par exemple `en`, `ko`).

## Exemple

- `en` : `0x1916 0x08C6 0x656E`
