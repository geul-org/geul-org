---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Importa un documento externo mediante un IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `IMPORT-DOC` (BIND del documento de especificación `IMPORT-DOC`) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| Documento de especificación | `0x00000000/codecs/0x00001E40/` (destino de DECLARE `1E40`) |
| Sección | 15 `1111` (Meta), desplazamiento C dentro de la sección = 4 |
| Kind | Meta · clase: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Importa un documento externo mediante un IMPORT ID. Reference incorporado `DOC-POINTER` (`CODEC-POINTER` para un documento de Codec) + IMPORT ID |
| Lado Hugo | `meta/import/import-doc.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)).

| Orden | Campo (BIND) | FIELD | Ancho | Formato receptor (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | registro | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | valor en bruto restante (`0xFFFF`) |  |  |

Importa un documento externo mediante un IMPORT ID. El documento que se importa lo señala [DOC-POINTER](../reference/0x041L-doc-pointer.md), que también contiene el ancho del Issuer.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[TAG de extensión de Length]
Documento         registro Reference DOC-POINTER (Issuer, ID de documento, ID de versión. Con versión 0, la última). Un documento de Codec usa CODEC-POINTER
IMPORT ID         todo el resto. unsigned del ancho más corto
```

- Codec: Meta `0x1E4L`, clase IMPORT
- Payload: Reference incorporado `DOC-POINTER` (Issuer, ID de documento, ID de versión) + valor en bruto IMPORT ID
- Cantidad: varios posibles (uno por IMPORT ID)

## Interpretación y validez {#해석과-유효성}

- El documento es exactamente un registro DOC-POINTER. Al importar un documento de Codec es un registro [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID de versión). Termina con su propio Length y el resto es el IMPORT ID.
- El IMPORT ID es de 1 WORD o más, del ancho más corto. El ancho del IMPORT ID aquí lo fija la longitud del registro, y en [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) lo fija el Codec.
- En un documento no se asigna dos veces el mismo IMPORT ID.
- Si se escribe un ID de versión, se vincula a esa edición; con `0`, a la última edición en el momento de la interpretación (o a la que esté en vigor en el momento indicado) ([revisión](../document.md#개정)).
- Un [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) del BODY señala un LOCAL del documento importado con el IMPORT ID. El propio documento importado se señala con DOC-POINTER.
- No se importa el HEAD del documento importado. Los objetivos de ese documento se interpretan según las declaraciones de ese documento.
- Con el IMPORT ID no se puede buscar entre documentos. Un almacén que carga varios documentos guarda el IMPORT ID resuelto a la ruta completa (Issuer, ID de documento, ID de versión, LOCAL ID).

## Ejemplo {#예시}

- IMPORT ID 1, Issuer `0x00000002`, documento `0x…0002`, la última: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (TAG de Meta 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## Texto original del documento de especificación {#규격-문서-원문}

Es el documento de especificación `0x00000000/codecs/0x00001E40/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
