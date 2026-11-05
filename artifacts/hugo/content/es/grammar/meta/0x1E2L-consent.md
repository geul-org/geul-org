---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indica el alcance del consentimiento y su fundamento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `CONSENT` (BIND del documento de especificación `CONSENT`) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| Documento de especificación | `0x00000000/codecs/0x00001E20/` (destino de DECLARE `1E20`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 2 |
| Kind | Meta · clase: política |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Alcance del consentimiento y su fundamento |
| Lado Hugo | `meta/policy/consent.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | registro | `000F` toda la sección 0 (comodín, Reference), `020F` toda la sección 1 (comodín, Reference), `040F` toda la sección 2 (comodín, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Indica el alcance del consentimiento y su fundamento.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[TAG de extensión de Length]
Payload           Reference que señala el fundamento del consentimiento, o texto
```

- Codec: Meta `0x1E2L`, clase de política
- Payload: Reference o Value incorporado
- Cantidad: varios posibles

## Problemas abiertos {#열린-문제}

- Estructura de la expresión del alcance (finalidad, plazo, cesión a terceros).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E20/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
