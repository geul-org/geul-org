---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS est un Meta de politique qui consigne l'étendue de diffusion du document (public, interne, confidentiel) sous forme d'un niveau de 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne l'étendue de diffusion du document.

## Disposition

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[TAG d'extension de Length]
niveau            1 WORD (0 public, 1 interne, 2 confidentiel, autres réservés)
```

- Codec : Meta `0x51`, classe de politique (`101`)
- Payload : valeur brute (niveau, 1 WORD)
- Nombre : au plus un

## Interprétation et validité

- Un document confidentiel n'est pas publié ([Issuer](/fr/grammar/issuer/)).
- Ne modifie pas l'interprétation. Fixe seulement le traitement.

## Problèmes ouverts

- Table des codes de niveau.
