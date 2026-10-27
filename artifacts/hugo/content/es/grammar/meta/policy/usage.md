---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE es un Meta de política que anota restricciones de uso como la prohibición de entrenamiento o de uso comercial."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota restricciones de uso (ejemplo: prohibición de entrenamiento, prohibición de uso comercial).

## Layout

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[TAG de extensión de Length]
Payload           texto o Reference que expresa la restricción de uso
```

- Codec: Meta `0x55`, clase de política (`101`)
- Payload: Value o Reference incorporado
- Cantidad: puede haber varios

## Problemas abiertos

- Tabla de códigos de los tipos de restricción.
