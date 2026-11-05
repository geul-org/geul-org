---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Marca que este archivo de versión no es una instantánea sino un diff respecto de una versión base del mismo documento (delta de git packfile)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `DELTA-BASE` (BIND del documento de especificación `DELTA-BASE`) |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| Documento de especificación | `0x00000000/codecs/0x00001DB0/` (destino de DECLARE `1DB0`) |
| Sección | 14 `1110` (Meta), desplazamiento C dentro de la sección = 27 |
| Kind | Meta · clase: linaje |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Este archivo de versión es un diff respecto de una versión base del mismo documento (ID de versión de 2 WORD) (git packfile delta) |
| Lado Hugo | `meta/lineage/delta-base.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | valor en bruto, 2 WORD | `0620` UNSIGNED-INTEGER |  |

Marca que este archivo de versión no es una instantánea sino un **diff** respecto de una versión base del mismo documento (delta de git packfile). La versión en sí sigue definiéndose como instantánea. El hash de contenido, la lista de versiones y la firma se basan todos en la instantánea restaurada al aplicar el diff ([almacenamiento de diff](../document.md#diff-저장)).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
ID de versión     unsigned de 2 WORD (versión base del mismo documento)
```

- Codec: Meta `0x1DBL`, clase de linaje
- Payload: ID de versión de 2 WORD (valor en bruto)
- Cantidad: como máximo uno

## Interpretación y validez {#해석과-유효성}

- Solo se usa en documentos con [DOC-ID](0x1C7L-doc-id.md). La lista de versiones `versions.geul`, que no lleva `DOC-ID`, los documentos de lista (versiones de `issuers/`) y los documentos sin nombre no llevan diff.
- La versión base es una versión publicada del mismo `DOC-ID` y anterior a esta versión. `0` (sin versión) es invalid.
- El hash de contenido de la instantánea restaurada debe ser igual al hash de esta versión en la lista de versiones ([PUBLICATION](../edge/0x0B8L-publication.md)). Si no, este diff es invalid. Por eso el hash resultante no se escribe aparte dentro del diff.
- Solo puede ser diff un documento cuyos registros del BODY sean todos Edge (registros con Edge Id), porque la unidad del diff es el LOCAL ID (Edge Id).
- Las reglas de restauración de la instantánea siguen el [almacenamiento de diff](../document.md#diff-저장). La eliminación la asume [DELTA-REMOVE](0x1DCL-delta-remove.md).
- No hay una marca aparte de adición o revisión. Si el Edge Id del BODY del diff está en la base, es una revisión; si no, una adición. Las adiciones reciben su numeración a partir de [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) de la lista de versiones. Reutilizar un LOCAL ID eliminado es invalid ([revisión](../document.md#개정)).

## Ejemplo {#예시}

Diff respecto de la versión base 3:

```
1DB2 0000 0003
```

- TAG `1DB2` (Meta `0x1DBL`, `LLLL=0010`, 3 WORD), ID de versión `0000 0003`.

## Problemas abiertos {#열린-문제}

1. Intervalo de instantáneas: cada cuántas versiones se pone una instantánea completa (longitud de la cadena de diff frente al coste de restauración).
2. Si se limita la versión base a la versión inmediatamente anterior.
3. Dónde se guarda el archivo de diff: si en el lugar del archivo de versión (`<ID de versión>.geul`), y su relación con la dirección por hash de contenido `<Issuer>/hashes/` (`hashes/` se busca por el hash de contenido de la instantánea).

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001DB0/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
