---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT es un Meta de política que anota con un Reference o un texto el ámbito y el fundamento del consentimiento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Anota el ámbito y el fundamento del consentimiento.

## Layout

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[TAG de extensión de Length]
Payload           Reference que apunta al fundamento del consentimiento, o texto
```

- Codec: Meta `0x54`, clase de política (`101`)
- Payload: Reference o Value incorporado
- Cantidad: puede haber varios

## Problemas abiertos

- Estructura de la expresión del ámbito (finalidad, periodo, cesión a terceros).
