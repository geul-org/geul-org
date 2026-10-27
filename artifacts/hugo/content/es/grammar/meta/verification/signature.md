---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE es un Meta de verificación que anota la firma del hash de contenido del documento con un ID de algoritmo, el firmante y la firma."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Es la firma del hash de contenido del documento (commits y tags firmados de git).

## Layout

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[TAG de extensión de Length]
ID del algoritmo  1 WORD (0x0001 = Ed25519)
Firmante          registro Reference ISSUER-POINTER (Issuer)
Firma             todo el resto. El ancho lo fija el algoritmo (Ed25519: 32 WORD)
```

- Codec: Meta `0x41`, clase de verificación (`100`)
- Payload: ID del algoritmo (valor en bruto de 1 WORD) + firmante (Reference incorporado) + firma (valor en bruto, el resto)
- Cantidad: puede haber varios

## Interpretación y validez

- Lo que se firma es el hash de contenido. No se firma solo el BODY ([Firma](/es/grammar/issuer/#firma)).
- Por ser de la clase de verificación, se excluye del hash de contenido. Añadir firmas deja el hash igual.
- Se verifica no con "si hay firma, se comprueba" sino con "debe haber una firma de la clave establecida".
- El documento de lista de versiones lo firma el lugar de publicación.
- El firmante es [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/) (Issuer), que apunta al propio Issuer. Como es un registro Reference, termina con su propio Length, así que aunque el ancho de la firma varíe según el algoritmo, el layout queda determinado de forma única (campo restante de [DECLARE](/es/grammar/edge/declare/)).
- Si el número de WORD de la firma es distinto del ancho que fija el algoritmo, es invalid.

## Problemas abiertos

- Si firmar también el momento de la firma.
