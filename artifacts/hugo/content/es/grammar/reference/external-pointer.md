---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER es un Reference que señala el LOCAL ID de un documento importado con el IMPORT-DOC del HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
EXTERNAL-POINTER es un Reference que señala el LOCAL ID de un documento importado con el [IMPORT-DOC](/es/grammar/meta/import/import-doc/) del HEAD.

## Layout

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[TAG de extensión de Length]
IMPORT ID         ancho fijado por WW (00=1, 01=2, 10=4, 11=8 WORD)
ID de destino     todo el resto. El LOCAL ID del documento importado, con el ancho más corto
```

| CCCC | Nombre | Ancho del IMPORT ID |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- Se usa el Codec más estrecho en que quepa el valor del IMPORT ID.
- El IMPORT ID es un valor asignado por el `IMPORT-DOC` de este documento y solo es válido dentro de este documento. En EXTERNAL-POINTER no se anota el Issuer. El Issuer y el ID de documento se obtienen de ese `IMPORT-DOC`. La versión también la fija ese `IMPORT-DOC` (fijada o la última).
- Si es el mismo LOCAL ID del documento importado, es el mismo objeto, ya se escriba como LOCAL dentro de ese documento o como EXTERNAL-POINTER aquí.
- Si es Variable, es una variable LOCAL del documento importado.

## Validez

- Si en este documento no hay un `IMPORT-DOC` que asigne ese IMPORT ID, es invalid.
- Si el IMPORT ID cabe en un Codec más estrecho pero se usa uno más ancho, se rechaza por non-minimal.
- Si el ID de destino es `0`, es invalid. El propio documento importado se señala con [DOC-POINTER](/es/grammar/reference/doc-pointer/).
- Se prohíben WORD `0x0000` iniciales en el ID de destino.

## Ejemplo

| Objeto | Secuencia de WORD |
|---|---|
| LOCAL 5 del IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 del IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 del IMPORT ID 70000 | `01C8 0001 1170 0005` |

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [LOCAL](/es/grammar/reference/local/), [EXTERNAL-ISSUER](/es/grammar/reference/external-issuer/), [DOC-POINTER](/es/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/es/grammar/meta/import/import-doc/)
