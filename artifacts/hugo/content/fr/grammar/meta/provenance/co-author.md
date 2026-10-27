---
title: "CO-AUTHOR"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CO-AUTHOR est un Meta de provenance qui consigne par un Reference les coauteurs du document (git Co-authored-by)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne les coauteurs du document (git `Co-authored-by`).

## Disposition

```
TAG WORD          0001 1LLL L010 0001      Codec 0x21
[TAG d'extension de Length]
Payload           un enregistrement Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, etc.)
```

- Codec : Meta `0x21`, classe de provenance (`010`)
- Payload : Reference intégré
- Nombre : plusieurs possibles

## Interprétation et validité

- Le Reference n'est pas limité à un Codec. Ce peut être une personne, une organisation, un modèle ou un moteur de règles ([EXTERNAL-ISSUER](/fr/grammar/reference/external-issuer/), [GEUL](/fr/grammar/reference/geul/), [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/), [LOCAL](/fr/grammar/reference/local/), etc.).
- Un document publié sur geul.org ne contient pas de Reference désignant une personne physique ([Issuer et publication](/fr/grammar/issuer/#publication-sur-geulorg)). Il désigne une organisation ou un Issuer. Par exception, désigner une personne physique par [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) est admis.
- Si c'est un LOCAL, la cible est décrite dans le BODY.
