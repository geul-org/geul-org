---
title: "Meta — definición"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "La clase de definición de Meta (3 bits superiores `001`, `0x10`~`0x1F`) son declaraciones de interpretación. Fija la versión de la especificación, el perfil, el ID de documento, el periodo de vigencia y el idioma por defecto."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La clase de definición de Meta (3 bits superiores `001`, Codec `0x10`~`0x1F`) son declaraciones de interpretación. Como las declaraciones cambian las reglas de interpretación, todos los decodificadores deben procesarlas. El alcance de una declaración es ese documento.

- `SPEC-VERSION` fija cómo se leen los demás registros, por lo que lleva solo un entero, sin Value incorporado. GEUL v1 es `0x0001` (registro `1890 0001`).
- `DOC-ID` es el `DOC-POINTER` (Issuer, ID de documento, versión `0`) que apunta al propio documento. Si falta, es un documento sin nombre y solo se puede apuntar a él por su hash de contenido.
- El nombre de dirección de un documento no se pone como Meta. Lo añade como `BIND` de afirmación el índice de nombres del Issuer `documents.geul`, y el título legible por personas se añade con `LABEL` ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#nombre-del-documento)).
