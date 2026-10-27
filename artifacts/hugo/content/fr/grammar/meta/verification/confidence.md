---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE est un Meta de vérification qui consigne la fiabilité de l'ensemble du document sous forme de Value décimale comprise entre 0 et 1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne la fiabilité de l'ensemble du document. La fiabilité au niveau d'un enregistrement s'écrit avec un QUALIFIER attaché à l'Edge cible (la propriété n'est pas encore fixée, [SOURCE](/fr/grammar/edge/source/#expression-des-autres-fondements)).

## Disposition

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[TAG d'extension de Length]
Payload           Value UNSIGNED-DECIMAL, de 0 à 1 inclus
```

- Codec : Meta `0x43`, classe de vérification (`100`)
- Payload : Value intégré ([UNSIGNED-DECIMAL](/fr/grammar/value/decimal/unsigned-decimal/))
- Nombre : au plus un

## Interprétation et validité

- Qui a attribué la valeur est consigné en parallèle, par exemple avec [GENERATED-BY](/fr/grammar/meta/lineage/generated-by/).

## Problèmes ouverts

- Échelle (0 à 1) et relation avec le verdict TOULMIN.
