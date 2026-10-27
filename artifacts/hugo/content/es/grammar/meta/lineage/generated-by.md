---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY es un Meta de linaje que anota la entidad que generó el documento (persona, modelo, motor de reglas) y su versión."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota la entidad que generó el documento. Puede ser una persona, un modelo o un motor de reglas.

## Layout

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[TAG de extensión de Length]
Entidad generadora  Reference (persona, modelo, motor de reglas)
Versión             Value UTF8-TEXT, o marcador de omisión 0x0000 (campo opcional)
```

- Codec: Meta `0x32`, clase de linaje (`011`)
- Payload: Reference incorporado + texto de versión (opcional)
- Cantidad: puede haber varios

## Interpretación y validez

- Si es un modelo, se anota también la versión del modelo.
- Si no se conoce la versión o no se pone, se omite esa posición y se escribe ABSENT (`0x0000`) ([CODEC](/es/grammar/edge/codec/), campo opcional). La especificación `0x1832` de geul.org tiene dos campos de registro: agent (sin CODEC) y version (`0840`, `0841`, `0000`).
- Para la versión del código fuente de un programa (commit), el formato de [TRANSFORMED-BY](/es/grammar/meta/lineage/transformed-by/) (digest, obligatorio) es más preciso. La versión de GENERATED-BY se anota como texto para lo que no es un ID de commit, como el nombre y la versión de un modelo.
- En los documentos publicados en geul.org no se pone un Reference que apunte a una persona física ([Issuer y publicación](/es/grammar/issuer/#publicación-en-geulorg)). Se apunta a una organización o a un Issuer. Como excepción, se permite apuntar a una persona física con [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/).
