---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM est un Meta de lignée qui consigne le document ou la ressource d'une autre lignée dont ce document est dérivé."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne que ce document est dérivé d'un document ou d'une ressource d'une autre lignée.

## Disposition

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[TAG d'extension de Length]
Payload           Reference, ou SHA-256-DIGEST (hachage du contenu), ou Value URI
```

- Codec : Meta `0x31`, classe de lignée (`011`)
- Payload : Reference ou Value intégré
- Nombre : plusieurs possibles

## Interprétation et validité

- Si la dérivation vient d'un document GEUL, on place son hachage du contenu ([SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/)) ; si c'est une ressource externe, un [URI](/fr/grammar/value/text/uri/). Pour figer par un hachage la version d'une ressource externe, on joint au [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du HEAD un QUALIFIER de hachage du texte d'origine (P4092).
- L'origine au niveau d'un enregistrement relève de l'Edge de fondement [SOURCE](/fr/grammar/edge/source/) ; l'ancien enregistrement avant un déplacement, une scission ou une fusion relève du QUALIFIER P1365 de l'Edge cible (la valeur est l'ancien Edge Id).
