---
title: "CO-AUTHOR"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CO-AUTHOR es un Meta de procedencia que anota con un Reference la entidad que escribió el documento junto con otras (git Co-authored-by)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota la entidad que escribió el documento junto con otras (git `Co-authored-by`).

## Layout

```
TAG WORD          0001 1LLL L010 0001      Codec 0x21
[TAG de extensión de Length]
Payload           un registro Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, etc.)
```

- Codec: Meta `0x21`, clase de procedencia (`010`)
- Payload: Reference incorporado
- Cantidad: puede haber varios

## Interpretación y validez

- El Reference no distingue por Codec. Puede ser una persona, una organización, un modelo o un motor de reglas ([EXTERNAL-ISSUER](/es/grammar/reference/external-issuer/), [GEUL](/es/grammar/reference/geul/), [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/), [LOCAL](/es/grammar/reference/local/), etc.).
- En los documentos publicados en geul.org no se pone un Reference que apunte a una persona física ([Issuer y publicación](/es/grammar/issuer/#publicación-en-geulorg)). Se apunta a una organización o a un Issuer. Como excepción, se permite apuntar a una persona física con [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/).
- Si es un LOCAL, ese objeto se describe en el BODY.
