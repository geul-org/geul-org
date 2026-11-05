---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Declara la clave pública de un Issuer de emisión propia (16 WORD)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `ISSUER-KEY` (BIND del documento de especificación `ISSUER-KEY`) |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| Documento de especificación | `0x00000000/codecs/0x00001E50/` (destino de DECLARE `1E50`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 5 |
| Kind | Meta · clase: verificación |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Declaración del ID del algoritmo de firma y de la clave pública de un Issuer de emisión propia |
| Lado Hugo | `meta/verification/issuer-key.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | valor en bruto, 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | valor en bruto restante (`0xFFFF`) |  |  |

Declara la clave pública de un Issuer de emisión propia (16 WORD). Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID del algoritmo ‖ clave pública) ([Issuer de 16 WORD](../issuer.md#16-word-issuer)).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[TAG de extensión de Length]
ID del algoritmo  1 WORD (0x0001 = Ed25519)
Clave pública     ancho que fija el algoritmo (Ed25519 16 WORD)
```

- Codec: Meta `0x1E5L`, clase de verificación
- Payload: valor en bruto (ID del algoritmo + clave pública)
- Cantidad: varios posibles (rotación de claves)

## Interpretación y validez {#해석과-유효성}

- Por ser de la clase de verificación, queda fuera del hash de contenido.
- Los Issuer de 2 y 4 WORD usan las claves registradas en geul.org, así que no lo necesitan.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E50/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
