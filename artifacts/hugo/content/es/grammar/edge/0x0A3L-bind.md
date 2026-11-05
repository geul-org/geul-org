---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND es un Edge de enunciado que liga a Subject un nombre con el que casa la máquina."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Elemento | Valor |
|---|---|
| Nombre | `BIND` (BIND del documento de especificación `BIND`) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| Documento de especificación | `0x00000000/codecs/0x00000A30/` (destino de DECLARE `0A30`) |
| Sección | 5 `0101` (enunciado de Edge), desplazamiento dentro de la sección C = 3 |
| Kind | Edge · familia: enunciado, grupo: señalamiento y nombre |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | Liga a Subject un nombre con el que casa la máquina (`UTF8-TEXT-*`). Es único dentro de su ámbito, debe coincidir exactamente y no tiene idioma |
| Lado Hugo | `edge/bind.md` |

## Campos (documento de especificación) {#필드-규격-문서}

El orden de los FIELD dentro del documento es el orden de los campos del Payload ([documento de especificación de Codec](../codec-spec.md)). El Edge Id de un Edge no se declara con FIELD.

| Orden | Campo (BIND) | FIELD | Ancho | Formato que acepta (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | cualquier registro (excepto marcadores de posición) |  |
| 2 | `name` | #3 | registro | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

BIND es un Edge de enunciado que liga a Subject un nombre con el que casa la máquina. Codec `0x0A3L`.

Es una denominación. El nombre legible por personas (título por idioma) lo asume [LABEL](0x0A4L-label.md). Se usa el mismo registro para el nombre de un símbolo de programa y para el nombre de dominio de la lista de Issuer.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference, o 1 WORD de TAG WORD de codec
nombre            1 Value UTF8-TEXT-*
```

## Interpretación y validez {#해석과-유효성}

- Subject es exactamente un registro [Reference](../reference/_index.md) completo. Si es LOCAL, es un objeto de este documento (un símbolo, etc.); si es una Reference de señalamiento, es un objeto de otro documento. El propio documento es [DOC-POINTER](../reference/0x041L-doc-pointer.md) y el propio Issuer es [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- O bien Subject es un solo TAG WORD de codec (solo Kind·Codec, `LLLL = 0`, sin Payload). Esto no es un registro con Payload vacío, sino que señala el propio código directo, es decir, su documento de especificación (codec del Issuer GEUL `0x0000<TAG>`) ([documento de especificación de Codec](../codec-spec.md), [DECLARE](0x0BBL-declare.md)). Ejemplo: `0B80` es PUBLICATION. Un codec de formato Issuer no se señala de esta forma.
- Ningún otro registro (Value, etc.) puede ser Subject. Como el FIELD del documento de especificación de BIND declara Subject solo con ancho `0` (registro), esta restricción es una regla del cuerpo de BIND.
- El nombre es exactamente un Value [UTF8-TEXT](../value/0x072L-utf8-text.md). No tiene idioma y no se normaliza. Los nombres son iguales solo si los bytes son iguales.
- El ámbito del nombre es el documento que contiene el BIND. En un documento no se liga el mismo nombre a Subject distintos.
- A un Subject se le pueden ligar varios nombres (alias, nombres antiguos). Si el documento no fija otra cosa, el último BIND es el nombre representativo.
- Los demás registros señalan el objeto por LOCAL ID, no por nombre. El nombre sirve para casar con el exterior (funciones del host, entrada de direcciones, personas).
- Los caracteres que puede usar el nombre los fija el uso. El nombre de dominio de la lista de Issuer sigue las reglas de dominio (minúsculas, IDNA) ([dirección de publicación y lista de versiones](../publishing.md#issuer-목록)).
- En la lista de versiones no se pone BIND. No existe dirección por nombre de documento ([dirección de publicación y lista de versiones](../publishing.md#문서-이름)).

## Longitud {#길이}

```
total = 1 + N_len + N_id + N_subject + N_name WORD
```

## Ejemplo (no normativo) {#예시-비규범}

Símbolo de programa: Edge Id `0003`, Subject LOCAL 7, nombre `main`.

- El nombre `main` son 4 bytes (par), es decir `0722 6D61 696E`, 3 WORD.
- El Edge es TAG 1 + Edge Id 2 + Subject 2 + nombre 3 = 8 WORD, TAG `0A37`.

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [dirección de publicación y lista de versiones](../publishing.md#issuer-목록) (nombre de dominio de la lista de Issuer)
- [LOCAL](../reference/0x005L-local.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00000A30/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
