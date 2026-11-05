---
title: "Repositorios"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
summary: "Repositorios públicos de GEUL en GitHub: la biblioteca Go y la CLI geul, carga y conversión de Wikidata, el motor de búsqueda SILK, estadísticas de archivos, un analizador de texto coreano, codebooks anteriores a v1 y este sitio web."
image: "/images/og-default.webp"
---

Los repositorios públicos de GEUL se encuentran en la organización [geul-org](https://github.com/geul-org) de GitHub. La gramática normativa es la [Gramática de GEUL](/es/grammar/) de este sitio.

Un documento GEUL es una secuencia de WORD de 16 bits. La unidad de datos es el registro, que empieza con un TAG WORD, y los registros se guardan en un documento. Los documentos los publica un Issuer, y cada versión queda fijada por un hash de contenido. Los repositorios siguientes son herramientas para escribir, leer, convertir, buscar y contar estos documentos, además de un analizador de texto coreano.

---

## Biblioteca

### gogeul

La biblioteca Go de GEUL y la herramienta de línea de comandos `geul`.

Escribe, lee, verifica y publica documentos GEUL (`.geul`). Sus paquetes ofrecen verificación de formato, decodificación de registros mediante documentos de especificación de Codec, diferencias entre versiones, resolución de dependencias IMPORT y el Codec TOULMIN. La CLI `geul` cubre la edición (`new`, `add`), la publicación (`publish`), la consulta (`ls`, `log`, `show`, `diff`, `check`), un visor en el navegador (`serve`, `build`) y los archivos pack (`pack build`, `pack unpack`). Los archivos pack pueden guardar registros comprimidos con zstd.

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| Lenguaje | Go |
| Licencia | CC0 |

---

## Wikidata

### wikigeul

Conversión Wikidata → GEUL (antes llamada gogeulwiki).

Lee directamente los volcados JSON de Wikidata y genera un documento GEUL por cada elemento o propiedad, con etiquetas, descripciones, alias, declaraciones con sus calificadores y referencias, y enlaces a sitios en todos los idiomas. Todos los documentos se publican bajo el Issuer `wikidata.geul.org` (`0x00000001`).

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| Lenguaje | Go |
| Licencia | CC0 |

### wikipg

Carga sin pérdidas de volcados JSON de Wikidata en PostgreSQL. Obsoleto (deprecated) desde 2026-11-03; use [wikigeul](#wikigeul), que lee los volcados directamente.

Guarda entidades, etiquetas, descripciones, alias, declaraciones, calificadores, referencias, enlaces a sitios y Lexemes en el orden del volcado, y conserva literalmente cada línea del volcado. También registra el propio volcado (archivo, URL, tamaño, sumas de verificación, commit del cargador). wikipg no depende de GEUL.

| | |
|---|---|
| GitHub | [geul-org/wikipgeul](https://github.com/geul-org/wikipgeul) |
| Lenguaje | Go |
| Licencia | CC0 |

---

## Búsqueda

### silk

[SILK](/es/projects/silk/) — un motor de indexación y búsqueda hecho para GEUL.

Construye índices particionados y ordenados de los registros de un archivo pack de GEUL y responde consultas como "¿qué documentos afirman que la ocupación (P106) de alguien es físico (Q169470)?" sin decodificar todos los documentos. Delimita los registros y sus campos solo con los TAG WORD, sin codebook. Está en desarrollo temprano, validando sus algoritmos de búsqueda, y sus formatos pueden cambiar antes de la primera versión.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Lenguaje | Go |
| Licencia | CC0 |

---

## Estadísticas

### statistics

Cuenta el uso de TAG en archivos pack de GEUL, por Issuer.

Cuenta los registros de cada código de 9 bits que queda al quitar el Length de un TAG WORD (TAG ID `0x000L`–`0x1FFL`). Si se le dan varias carpetas de archivo o de conjuntos pack, las cuenta juntas.

| | |
|---|---|
| GitHub | [geul-org/statistics](https://github.com/geul-org/statistics) |
| Lenguaje | Go |
| Licencia | CC0 |

---

## Coreano

### koparse

Un analizador de texto coreano.

Empieza separando los sustantivos de las partículas y terminaciones unidas a ellos en las palabras coreanas (eojeol), y crecerá hasta ser un analizador morfológico si hace falta. Se construye desde cero, sin recurrir a analizadores morfológicos ni diccionarios existentes, y su diccionario usa solo fuentes CC0 (etiquetas y Lexemes de Wikidata) y datos generados por el propio proyecto. Está en desarrollo temprano.

| | |
|---|---|
| GitHub | [geul-org/koparse](https://github.com/geul-org/koparse) |
| Lenguaje | Go |
| Licencia | CC0 |

---

## Codebooks (anteriores a v1)

Los dos repositorios siguientes se diseñaron antes de la gramática v1 actual. Algunas partes no coinciden con ella.

### sidx

Investigación sobre la asignación de SIDX (Semantic-aligned Index).

Material de investigación para asignar SIDX, una dirección semántica que da números cercanos a entidades de significado cercano, a partir de estadísticas de uso de Wikidata. Contiene el antiguo esquema de atributos de Entity de 48 bits, scripts codificadores y codebooks; todavía no se ha producido ninguna asignación de SIDX. La definición normativa de SIDX es [GEUL-SIDX](/es/grammar/reference/geul-sidx/) en la gramática.

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| Lenguaje | Python |
| Licencia | CC0 |

### wordnet-verb

Edición provisional de un codebook de verbos de 16 bits basado en WordNet 3.0.

Asigna un código de 16 bits a cada uno de los 13.767 synsets verbales de WordNet 3.0, con códigos cercanos para verbos de significado cercano. Es una edición provisional que se sustituirá por un codebook que no use WordNet, y aún no se ha decidido cómo se llevarían los códigos en los registros GEUL.

Contiene material derivado de WordNet, por lo que **no es un producto CC0.** Las partes derivadas de WordNet siguen la WordNet 3.0 License; solo las partes propias del proyecto GEUL, como los códigos y la clasificación, son CC0.

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| Lenguaje | Python |
| Licencia | WordNet 3.0 License (partes derivadas) · CC0 (partes propias) |

---

## Sitio web

### geul-org

Código fuente de este sitio web, geul.org.

Sitio estático Hugo en 12 idiomas, desplegado con S3 + CloudFront.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Lenguaje | Hugo |
| Licencia | CC0 |
