---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS es un Meta de política que anota con un grado de 1 WORD el ámbito de divulgación del documento (público, interno, confidencial)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el ámbito de divulgación del documento.

## Layout

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[TAG de extensión de Length]
Grado             1 WORD (0 público, 1 interno, 2 confidencial, los demás reservados)
```

- Codec: Meta `0x51`, clase de política (`101`)
- Payload: valor en bruto (grado de 1 WORD)
- Cantidad: como máximo uno

## Interpretación y validez

- Los documentos confidenciales no se publican ([Issuer](/es/grammar/issuer/)).
- No cambia la interpretación. Solo fija el tratamiento.

## Problemas abiertos

- Tabla de códigos de grado.
