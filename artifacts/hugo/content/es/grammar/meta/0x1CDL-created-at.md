---
title: "CREATED-AT (0x1CDL)"
weight: 461
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Indica el momento en que se redactó el documento (git author date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `CREATED-AT` (BIND del documento de especificación `CREATED-AT`) |
| TAG ID | `0x1CDL` |
| Codec ID | `0x00001CD0` |
| Documento de especificación | `0x00000000/codecs/0x00001CD0/` (destino de DECLARE `1CD0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 13 |
| Kind | Meta · clase: procedencia |
| TAG WORD | `0001 1100 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Momento de redacción. Value TIME (git author date) |
| Lado Hugo | `meta/provenance/created-at.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | registro | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

Indica el momento en que se redactó el documento (git author date).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1101 LLLL      Codec 0x1CDL
[TAG de extensión de Length]
Payload           un Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, etc.)
```

- Codec: Meta `0x1CDL`, clase de procedencia
- Payload: Value incorporado (familia TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md), etc.)
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- El formato se elige entre los Value de la familia TIME. Si se necesita precisión, se usa el formato de nanosegundos definido por un Issuer (por ejemplo, [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001CD0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CD000000000
BODY
#1 DECLARE 0x1CD0
#2 FIELD #1 record
#3 BIND #1 "CREATED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
