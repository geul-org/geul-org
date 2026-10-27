---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY est un Meta de lignée qui consigne l'auteur de la génération du document (personne, modèle, moteur de règles) et sa version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne l'auteur de la génération du document. Il peut s'agir d'une personne, d'un modèle ou d'un moteur de règles.

## Disposition

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[TAG d'extension de Length]
auteur de la génération    Reference (personne, modèle, moteur de règles)
version                    Value UTF8-TEXT, ou marqueur d'omission 0x0000 (champ facultatif)
```

- Codec : Meta `0x32`, classe de lignée (`011`)
- Payload : Reference intégré + texte de version (facultatif)
- Nombre : plusieurs possibles

## Interprétation et validité

- S'il s'agit d'un modèle, on consigne aussi sa version.
- Si la version est inconnue ou omise, on omet cette position et on écrit ABSENT (`0x0000`) (champ facultatif de [CODEC](/fr/grammar/edge/codec/)). La spécification geul.org `0x1832` comporte deux champs-enregistrements : agent (sans CODEC) et version (`0840`, `0841`, `0000`).
- Pour la version source (commit) d'un programme, le format de [TRANSFORMED-BY](/fr/grammar/meta/lineage/transformed-by/) (digest, obligatoire) est plus précis. La version de GENERATED-BY consigne en texte ce qui n'est pas un ID de commit, comme le nom et la version d'un modèle.
- Un document publié sur geul.org ne contient pas de Reference désignant une personne physique ([Issuer et publication](/fr/grammar/issuer/#publication-sur-geulorg)). Il désigne une organisation ou un Issuer. Par exception, désigner une personne physique par [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) est admis.
