---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT est un Meta de vérification qui consigne en 1 WORD le verdict sur l'ensemble du document (Pass, Review, Fail)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne le verdict sur l'ensemble du document. Le verdict au niveau d'un nœud ou d'un enregistrement relève de `VERDICT` de [TOULMIN](/fr/grammar/edge/toulmin/) (Edge `0x78`).

## Disposition

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[TAG d'extension de Length]
verdict           1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec : Meta `0x44`, classe de vérification (`100`)
- Payload : valeur brute (verdict, 1 WORD)
- Nombre : au plus un

## Interprétation et validité

- Classe de vérification : exclu du hachage du contenu.
- Un verdict portant sur un autre document se place dans le BODY d'un document distinct de celui qui est jugé.

## Problèmes ouverts

- Faut-il consigner aussi l'auteur du verdict et son fondement.
