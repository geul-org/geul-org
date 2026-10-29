---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT es un texto con idioma que contiene en un solo Value un registro Value de idioma y texto UTF-8 (Codec 0x4A/0x4B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
UTF8-LANGUAGE-TEXT es un texto con idioma. Contiene en un solo Value un registro Value de idioma y los bytes UTF-8.

[UTF8-TEXT](/es/grammar/value/text/utf8-text/) es una cadena sin idioma (identificadores, códigos, nombres de archivo, bytes del original), y este formato es un texto con idioma (nombres, títulos, lemas, frases). Aunque tengan los mismos bytes, son valores distintos. "Paris" (cadena) y "Paris" (francés) no son iguales. Es lo mismo que RDF separa `xsd:string` de `rdf:langString`.

## Layout

- Código: código directo de Value `0x4A` (texto de bytes pares) y `0x4B` (texto de bytes impares). Familia TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = el texto tiene un número impar de bytes)
[TAG de extensión de Length] si el total es de 15 WORD o más
Language          1 registro Value LANGUAGE-SHORT-CODE o LANGUAGE-BCP47-CODE (con TAG)
Text WORD 1.º ... N-ésimo             bytes UTF-8 / si es impar, el último 0x00
```

## Interpretación y validez

- El Payload empieza con el registro de idioma. El primer WORD del Payload se lee como TAG, y su Length es el del registro de idioma; el resto son los bytes del texto. El registro de idioma es obligatorio. Si no hay idioma, no se usa este formato sino UTF8-TEXT.
- El registro de idioma es exactamente un registro completo [LANGUAGE-SHORT-CODE](/es/grammar/value/text/language-short-code/) (`0x48`) o [LANGUAGE-BCP47-CODE](/es/grammar/value/text/language-bcp47-code/) (`0x46`·`0x47`). Si es otro Codec o está incompleto, es invalid. La validez del registro de idioma sigue las reglas de ese formato.
- Se pueden usar ambos formatos de idioma. La regla para comparar si es el mismo idioma es la misma que la de [LABEL](/es/grammar/edge/label/). Un SHORT-CODE y la tag BCP 47 que el registro liga a su número son el mismo idioma.
- `zxx` (sin contenido lingüístico) no se usa. Tal cadena es UTF8-TEXT. `und` (idioma sin determinar) y `mul` (varios idiomas) son textos con idioma, así que se pueden usar.
- Los bytes del texto siguen las mismas reglas que UTF8-TEXT. Deben ser UTF-8 well-formed, se permite un U+FEFF inicial como carácter, no se impone normalización y se conserva tal cual el original. Quien compara o indexa lo equipara en NFC para comparar.
- El número de bytes del texto es `2 × (número de WORD del Payload − número de WORD del registro de idioma) − P`. P (el bit menos significativo del Codec) indica solo la paridad de los bytes del texto. Si es impar, el byte inferior del último WORD debe ser `00`.
- Un texto vacío (0 bytes) lleva solo el registro de idioma, con el código par.

## Dónde se usa

- Valores monolingualtext de Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` pasa a ser un solo Value de este formato. Entra tal cual como Object de [TRIPLE](/es/grammar/edge/triple/) y Value de [QUALIFIER](/es/grammar/edge/qualifier/). La propiedad, el rank y los qualifier los lleva el TRIPLE.
- El Object de [LABEL](/es/grammar/edge/label/) y [ALIAS](/es/grammar/edge/alias/). Este único valor contiene el nombre y el idioma.
- Textos con idioma fijado, como los títulos de leyes y artículos.

## Correspondencia de códigos de idioma (Wikidata)

- No todos los códigos de idioma de Wikidata y Wikimedia son BCP 47 (ejemplo: `simple`, `map-bms`). Se trasladan a tags BCP 47 mediante una tabla de correspondencia. Los códigos que no se pueden trasladar se tratan de forma distinta según el uso.
  - Valores (monolingualtext): se conserva el original del datavalue como UTF8-TEXT. El valor es parte de la proposición, y si se descarta la proposición cambia.
  - Etiquetas, descripciones y alias: se saltan y se dejan en el informe. Estos Edge solo se sostienen con idioma (un texto sin idioma es invalid), y el original permanece en los datos de origen.
- Si la tag resultante tiene número en el GEUL Language Registry, se usa LANGUAGE-SHORT-CODE; si no, LANGUAGE-BCP47-CODE.

## Longitud

- El total es el número de WORD que suman el TAG de 1 WORD, el TAG de extensión de Length (si lo hay), el registro de idioma y los WORD del texto. Hasta 14 WORD se usa longitud directa y desde 15 WORD longitud extendida ([Length](/es/grammar/record/)).
- El registro de idioma son 2 WORD si es SHORT-CODE y `ceil(bytes de la tag/2) + 1` WORD si es BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## Ejemplo

Todos los idiomas son ejemplos del formato LANGUAGE-BCP47-CODE. `fr`, `ko` y `de` tienen número en el registro, así que también pueden escribirse como SHORT-CODE (2 WORD).

| Valor | Bytes del texto | WORD en total |
|---|---|---|
| "Paris" (fr) | 5 (impar) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (par) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0ACB` (Codec `0x4B`, `LLLL=0101`, 6 WORD en total), idioma `08C6 6672` (BCP 47 `fr`), texto `5061 7269 7300` (5 bytes, `00` final).
- El tercero son 17 WORD en total, por lo que usa longitud extendida (`LLLL=1110` de `0F4A`, TAG de extensión `0011`).

## Base estándar

- Language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und` y `mul` son códigos special del IANA Language Subtag Registry.
- Texto: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Distinción entre cadena y texto con idioma: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Problemas abiertos

- La comprobación de la gramática de la tag BCP 47 en el schema. Por ahora solo se comprueba que sea ASCII y no esté vacía.

## Páginas relacionadas

- [Value](/es/grammar/value/), [UTF8-TEXT](/es/grammar/value/text/utf8-text/), [LANGUAGE-SHORT-CODE](/es/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/es/grammar/value/text/language-bcp47-code/), [LABEL](/es/grammar/edge/label/)
