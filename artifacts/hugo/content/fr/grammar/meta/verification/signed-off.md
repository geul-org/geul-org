---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF est un Meta de vérification qui consigne par un Reference la confirmation du droit de contribuer (Signed-off-by de git, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Confirmation du droit de contribuer (`Signed-off-by` de git, DCO).

## Disposition

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[TAG d'extension de Length]
Payload           un Reference
```

- Codec : Meta `0x42`, classe de vérification (`100`)
- Payload : Reference intégré
- Nombre : plusieurs possibles

## Interprétation et validité

- Un document publié sur geul.org ne contient pas de Reference désignant une personne physique ([Issuer et publication](/fr/grammar/issuer/#publication-sur-geulorg)). Il désigne une organisation ou un Issuer. Par exception, désigner une personne physique par [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) est admis.
