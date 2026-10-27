---
title: "Meta — linaje"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "La clase de linaje de Meta (3 bits superiores `011`, `0x30`~`0x3F`) anota con el modelo de commits de git de qué y cómo salió el documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La clase de linaje de Meta (3 bits superiores `011`, Codec `0x30`~`0x3F`) anota de qué y cómo salió el documento. El linaje sigue el modelo de commits de git, y la unidad que corresponde a un commit es el documento.

- El **hash de contenido** señala un ejemplar del documento (git commit id). Es el SHA-256 desde el registro de apertura (`DOC-*`) hasta justo antes de `END`, y los registros de la clase de verificación (`100`) se excluyen del cálculo.
- El **ID de versión** es un entero de 2 WORD que se numera desde 1 en el orden de publicación dentro de un documento con nombre. `0` significa que no se anotó la versión.
- Los Meta de linaje señalan las versiones por su hash de contenido. Como el `PARENT` del documento también entra en el hash, el hash de contenido forma una cadena de hashes que enlaza todo el historial.
- El historial no se borra. Lo corregido se emite como una nueva versión. Los punteros mutables, como branch, no se colocan en el documento.
- `DELTA-BASE` y `DELTA-REMOVE` son el formato para guardar una versión como diff respecto de una versión base. Una versión siempre se define como snapshot.

Las reglas de revisión están en [Documento](/es/grammar/document/).
