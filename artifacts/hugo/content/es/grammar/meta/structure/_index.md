---
title: "Meta — estructura"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "La clase de estructura de Meta (3 bits superiores `000`, `0x00`~`0x0F`) fija los límites y la longitud del documento. Se abre con DOC-1WORD/2WORD/4WORD, el HEAD termina con BODY y se cierra con END."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La clase de estructura de Meta (3 bits superiores `000`, Codec `0x00`~`0x0F`) fija los límites y la longitud del documento. La unidad de los datos GEUL es un documento.

```
DOC-*                  ← inicio del HEAD
  Meta de definición, procedencia, linaje, verificación, política, IMPORT
  SOURCE del documento entero y sus QUALIFIER
BODY                   ← inicio del BODY
  Reference, Value, Edge
END                    ← cierra el documento
```

- Todo documento se abre indicando la longitud total con `DOC-1WORD/2WORD/4WORD`. El decodificador puede saltar el documento entero de una vez con esta longitud.
- `BODY` y `END` son registros de 1 WORD sin Payload. `END` es obligatorio.
- Los documentos no se anidan. Otros documentos se señalan con IMPORT.
- Si el HEAD (Meta, y el SOURCE del documento entero con sus QUALIFIER) está vacío, se omite `BODY`. `BODY` solo puede colocarse una vez por documento.

La estructura completa del documento está en [Documento](/es/grammar/document/).
