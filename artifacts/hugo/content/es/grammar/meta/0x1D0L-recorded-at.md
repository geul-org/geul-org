---
title: "RECORDED-AT (0x1D0L)"
weight: 464
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Indica el momento en que se registró el documento (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `RECORDED-AT` (BIND del documento de especificación `RECORDED-AT`) |
| TAG ID | `0x1D0L` |
| Codec ID | `0x00001D00` |
| Documento de especificación | `0x00000000/codecs/0x00001D00/` (destino de DECLARE `1D00`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 16 |
| Kind | Meta · clase: procedencia |
| TAG WORD | `0001 1101 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Momento de registro. Value TIME (git commit date) |
| Lado Hugo | `meta/provenance/recorded-at.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Indica el momento en que se registró el documento (git commit date).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0000 LLLL      Codec 0x1D0L
[TAG de extensión de Length]
Payload           un Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec: Meta `0x1D0L`, clase de procedencia
- Payload: Value incorporado (familia TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md), etc.)
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- El formato se elige entre los Value de la familia TIME. Si se necesita precisión, se usa el formato de nanosegundos definido por un Issuer (por ejemplo, [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

- La lista de versiones ([PUBLICATION](../edge/0x0B8L-publication.md)) usa este valor como momento de publicación, de obsolescencia (deprecate) o de eliminación.

## Problemas abiertos {#열린-문제}

- El Meta de procedencia entra en el hash de contenido. Si se admite que el mismo contenido registrado en otro momento dé un hash distinto.

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001D00/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D0000000000
BODY
#1 DECLARE 0x1D00
#2 FIELD #1 record
#3 BIND #1 "RECORDED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
