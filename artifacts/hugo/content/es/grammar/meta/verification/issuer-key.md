---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY es un Meta de verificación que declara el ID del algoritmo de firma y la clave pública de un Issuer de autoemisión (16 WORD)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Declara la clave pública de un Issuer de autoemisión (16 WORD). El ID de Issuer = SHA-256("GEUL-ISSUER-v1" ‖ ID del algoritmo ‖ clave pública) ([Issuer de 16 WORD](/es/grammar/issuer/#issuer-de-16-word)).

## Layout

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[TAG de extensión de Length]
ID del algoritmo  1 WORD (0x0001 = Ed25519)
Clave pública     ancho fijado por el algoritmo (Ed25519: 16 WORD)
```

- Codec: Meta `0x40`, clase de verificación (`100`)
- Payload: valor en bruto (ID del algoritmo + clave pública)
- Cantidad: puede haber varios (cambio de clave)

## Interpretación y validez

- Por ser de la clase de verificación, se excluye del hash de contenido.
- Los Issuer de 1·2·4 WORD usan la clave registrada en geul.org, por lo que no hace falta.
