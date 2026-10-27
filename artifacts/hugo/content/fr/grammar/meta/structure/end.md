---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END est un Meta de structure de 1 WORD qui ferme le document. Il est obligatoire dans tout document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Enregistrement qui ferme le document.

## Disposition

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[TAG d'extension de Length]
```

- Codec : Meta `0x0F`, classe de structure (`000`)
- Payload : aucun (1 WORD)
- Nombre : un par document, tout à la fin

## Interprétation et validité

- Obligatoire. Sa position est contrôlée par la longueur de [DOC](/fr/grammar/meta/structure/doc/) (`DOC-*`).
- Si l'entrée se termine sans END, le document est tronqué. La validité du contenu d'un document tronqué relève de la politique du décodeur.
- Rien ne vient après.

## Exemple

- `0x180F`
