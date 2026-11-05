---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Es la confirmación del derecho de contribución (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SIGNED-OFF` (BIND del documento de especificación `SIGNED-OFF`) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| Documento de especificación | `0x00000000/codecs/0x00001E70/` (destino de DECLARE `1E70`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 7 |
| Kind | Meta · clase: verificación |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Confirmación del derecho de contribución. Reference (git `Signed-off-by`, DCO) |
| Lado Hugo | `meta/verification/signed-off.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | registro | cualquier registro (excepto marcador de posición) |  |

Es la confirmación del derecho de contribución (git `Signed-off-by`, DCO).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[TAG de extensión de Length]
Payload           un Reference
```

- Codec: Meta `0x1E7L`, clase de verificación
- Payload: Reference incorporado
- Cantidad: varios posibles

## Interpretación y validez {#해석과-유효성}

- En los documentos publicados en geul.org no se pone un Reference que señale a una persona física ([Issuer y publicación](../issuer.md#geulorg-공표)). Se señala una organización o un Issuer. Como excepción, se permite señalar a una persona física con [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E70/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
