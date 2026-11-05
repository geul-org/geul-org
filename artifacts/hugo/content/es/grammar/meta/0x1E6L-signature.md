---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Es la firma del hash de contenido del documento (commit y tag firmados de git)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `SIGNATURE` (BIND del documento de especificación `SIGNATURE`) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| Documento de especificación | `0x00000000/codecs/0x00001E60/` (destino de DECLARE `1E60`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 6 |
| Kind | Meta · clase: verificación |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Firma de un objetivo. La firma de un documento firma el hash de contenido (commit y tag firmados de git) |
| Lado Hugo | `meta/verification/signature.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | valor en bruto, 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | registro | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | valor en bruto restante (`0xFFFF`) |  |  |

Es la firma del hash de contenido del documento (commit y tag firmados de git).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[TAG de extensión de Length]
ID del algoritmo  1 WORD (0x0001 = Ed25519)
Firmante          registro Reference ISSUER-POINTER (Issuer)
Firma             todo el resto. El ancho lo fija el algoritmo (Ed25519 32 WORD)
```

- Codec: Meta `0x1E6L`, clase de verificación
- Payload: ID del algoritmo (valor en bruto de 1 WORD) + firmante (Reference incorporado) + firma (valor en bruto, el resto)
- Cantidad: varios posibles

## Interpretación y validez {#해석과-유효성}

- El objetivo de la firma es el hash de contenido. No se firma solo el BODY ([firma](../issuer.md#서명)).
- Por ser de la clase de verificación, queda fuera del hash de contenido. Añadir una firma no cambia el hash.
- Se verifica no como «si hay firma, se comprueba» sino como «debe haber una firma de la clave fijada».
- El documento de la lista de versiones lo firma quien publica.
- El firmante es un [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) (Issuer) que señala al propio Issuer. Al ser un registro Reference, termina con su propio Length, de modo que el layout queda determinado aunque el ancho de la firma varíe según el algoritmo (campo restante de [DECLARE](../edge/0x0BBL-declare.md)).
- Si el número de WORD de la firma difiere del ancho que fija el algoritmo, es invalid.

## Problemas abiertos {#열린-문제}

- Si se firma también el momento de la firma.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E60/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
