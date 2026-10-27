---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND es un Edge de afirmación que liga a Subject un nombre con el que casa la máquina (UTF8-TEXT sin idioma) (Codec 0x03)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND es un Edge de afirmación que liga a Subject un nombre con el que casa la máquina. Codec `0x03`.

Es una asignación de nombre. El nombre legible por personas (título por idioma) corresponde a [LABEL](/es/grammar/edge/label/). El mismo registro sirve para el nombre de un símbolo de programa y para el nombre de la dirección de un documento.

## Layout

```
TAG WORD          0001 0LLL L000 0011
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference, o 1 WORD de TAG WORD de Codec
Nombre            1 Value UTF8-TEXT-*
```

## Interpretación y validez

- Subject es exactamente un registro [Reference](/es/grammar/reference/) completo. Si es LOCAL, es un objeto de este documento (un símbolo, etc.); si es un Reference que apunta, es un objeto de otro documento. El propio documento es [DOC-POINTER](/es/grammar/reference/doc-pointer/) y el propio Issuer es [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/).
- O bien Subject es un solo TAG WORD de Codec (solo Kind y Codec, `LLLL = 0`, sin Payload). No es un registro con Payload vacío, sino que designa el propio código directo, es decir, su documento de especificación (documento del Issuer de GEUL `0x000000000000<TAG>`) ([Documento de especificación de Codec](/es/grammar/codec-spec/), [DECLARE](/es/grammar/edge/declare/)). Ejemplo: `1018` es PUBLICATION. En el índice de nombres se usa Subject DOC-POINTER. No se usan Codec de formato Issuer.
- Ningún otro registro (Value, etc.) puede ser Subject. El FIELD del documento de especificación de BIND declara Subject solo con ancho `0` (registro), así que esta restricción es una regla del cuerpo de BIND.
- El nombre es exactamente un Value [UTF8-TEXT](/es/grammar/value/text/utf8-text/). No tiene idioma y no se normaliza. Dos nombres son el mismo solo si sus bytes son iguales.
- El alcance del nombre es el documento que contiene el BIND. En un documento no se liga el mismo nombre a Subject distintos.
- A un Subject se le pueden ligar varios nombres (alias, nombres antiguos). Si el documento no dispone otra cosa, el último BIND es el nombre principal.
- Los demás registros apuntan a un objeto por su ID LOCAL, no por el nombre. El nombre sirve para casar con el exterior (funciones del host, entrada de direcciones, personas).
- Los caracteres permitidos en el nombre dependen de su uso. El nombre para direcciones de documentos sigue la regla de nombres de documento (slug ASCII en minúsculas) ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#nombre-del-documento)).

## Longitud

```
total = 1 + N_len + N_id + N_subject + N_name WORD
```

## Ejemplo (no normativo)

Símbolo de programa: Edge Id `0003`, Subject LOCAL 7, nombre `main`.

- El nombre `main` tiene 4 byte (par), así que son 3 WORD: `0940 6d61 696e`.
- El Edge es TAG 1 + Edge Id 2 + Subject 2 + nombre 3 = 8 WORD, TAG `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

Nombre de documento (dentro del documento de lista de versiones de ese documento `0x0000/0xffff000000000002/versions.geul`): Edge Id `0005`, Subject `DOC-POINTER` (Issuer `0x0000`, documento `0xffff000000000002`, versión `0` = el propio documento), nombre `this-is-sample-doc`.

- Subject es TAG `03B8` + Issuer 1 + ID de documento 4 + ID de versión 2 = 8 WORD.
- El nombre tiene 18 byte (par), así que es TAG `0CC0` + 9 WORD = 10 WORD.
- El Edge es TAG 1 + extensión de Length 1 + Edge Id 2 + Subject 8 + nombre 10 = 22 WORD, así que `LLLL=1110`, TAG `1703`, extensión `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [LABEL](/es/grammar/edge/label/), [PUBLICATION](/es/grammar/edge/publication/) (nombre de documento del documento de lista de versiones)
- [LOCAL](/es/grammar/reference/local/), [DOC-POINTER](/es/grammar/reference/doc-pointer/), [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/)
