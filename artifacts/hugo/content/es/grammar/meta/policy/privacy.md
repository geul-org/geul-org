---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY es un Meta de política que anota en 1 WORD el grado de datos personales del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el grado de datos personales del documento.

## Layout

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[TAG de extensión de Length]
Grado             1 WORD
```

- Codec: Meta `0x52`, clase de política (`101`)
- Payload: valor en bruto (grado de 1 WORD)
- Cantidad: como máximo uno

## Interpretación y validez

- No cambia la interpretación. Solo fija el tratamiento.

## Problemas abiertos

- Tabla de códigos de grado (correspondencia con la clasificación de la ley de protección de datos personales).
