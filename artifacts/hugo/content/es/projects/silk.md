---
title: "SILK — Motor de indexación y búsqueda para GEUL"
weight: 1
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SILK", "búsqueda", "índice", "GEUL", "Go"]
summary: "Motor que indexa y consulta archivos GEUL pack registro a registro. Como los datos se estructuran al escribirlos, la búsqueda se reduce a comparaciones de enteros y recorridos por rangos. Consultas de 0,1–4 ms sobre Wikidata Q1–Q10000."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
aliases:
  - /es/silk/
---

SILK es un **motor de indexación y búsqueda específico para GEUL**. Sin decodificar documentos GEUL completos, responde solo con índices de registros a consultas como "¿qué documentos afirman que la ocupación (P106) es físico (Q169470)?".

| | |
|---|---|
| Estado | Desarrollo inicial. Se están validando los algoritmos de búsqueda y los formatos pueden cambiar antes de la primera versión |
| Lenguaje | Go |
| Entrada | Archivos GEUL pack (sin compresión) |
| Licencia | CC0 |
| Repositorio | <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a> |

## Tesis central

Lo difícil no era buscar: **el problema eran los datos sin estructura**.

```
Enfoque habitual: escribir primero → inferir la estructura después (tokenización, embeddings, análisis)
GEUL:             estructurar al escribir → buscar es solo comparar enteros y recorrer rangos
```

Un registro GEUL ya contiene campos como sujeto, predicado, objeto e idioma en posiciones fijas y como ID enteros. SILK se limita a extraer esos campos y mantenerlos ordenados.

## Por qué encaja con GEUL

| Propiedad de GEUL | Lo que obtiene SILK |
|---|---|
| Un solo TAG WORD de 16 bits contiene el tipo (Kind, Codec) y la longitud | Filtra y salta registros sin necesidad de un libro de códigos |
| Los campos de un Edge son registros en posiciones fijas | Extrae las claves por posición. No hacen falta reglas de análisis aparte |
| El vocabulario controlado son ID enteros (Q, P, idioma) | Compara igualdad con enteros, sin normalizar cadenas |
| Un pack se compone de objetos inmutables y generaciones | El índice también se construye con segmentos inmutables y generaciones, así que las instantáneas son seguras |
| La conversión es determinista | La misma entrada produce el mismo índice. El resultado incremental puede compararse byte a byte con un índice construido desde cero |

Los documentos GEUL nunca se reordenan. El índice es solo una **vista (view)** ordenada; los bytes publicados, los hashes de contenido y las firmas no cambian.

## Arquitectura

### Entrada

Lee archivos GEUL pack mediante [gogeul](https://github.com/geul-org/gogeul). Como el índice apunta a posiciones de bytes dentro de los data pack, el conjunto debe guardar los registros sin comprimir (`GEULCOMPRESS=none`). La compresión zstd es para distribución y archivo; la capa de búsqueda usa packs sin compresión.

### Especificación de particiones

Para cada tipo de TAG se declaran una **clave de partición** y una **clave de ordenación** como campos de posición fija del registro. Nada como predicados o idiomas está codificado de forma fija; la tabla siguiente muestra los valores por defecto para documentos de Wikidata.

| TAG | Clave de partición | Clave de ordenación |
|---|---|---|
| TRIPLE | Predicado (Predicate) | Objeto (Object) |
| QUALIFIER | Propiedad (Property) | Valor (Value) |
| LABEL·ALIAS·DESCRIPTION | Idioma | Sujeto (Subject) |
| SOURCE | ninguna | Origen (Origin) |
| REFERENCE-NODE | ninguna | Objeto (Object) |

- Una clave son los primeros bytes (una ranura) del registro de campo. Si el registro cabe en la ranura, la igualdad es exacta; si es más largo, solo selecciona candidatos.
- La validación de la especificación rechaza como clave de partición los campos cuya posición requiere un libro de códigos y los de longitud ilimitada.
- La especificación se identifica por su hash de contenido. Si cambia, solo se reconstruye ese TAG.

### Runs, incrementos y fusión

| Elemento | Función |
|---|---|
| Run ordenado | Segmento inmutable ordenado por (clave de ordenación, documento, desplazamiento) en cada partición. Se busca por bisección |
| Segmento añadido | Contiene solo las revisiones nuevas de una actualización incremental (`silk index update`). Se recorre secuencialmente |
| Mapa de bits de revisiones vivas | Marca como muertas las revisiones antiguas de los documentos modificados en lugar de borrarlas |
| Fusión por niveles de tamaño | Fusiona runs del mismo nivel de tamaño con una mezcla O(n) y, si hay muchas filas muertas, fusiona hasta el run base |
| Generación | La generación del manifiesto se sustituye de forma atómica. Los lectores fijan una generación, así que la instantánea se mantiene incluso durante una fusión |

La fusión puede limitarse a los momentos de inactividad (`-idle`, dejando libre el 30 % de la CPU y la memoria). Se detiene en los límites de partición y se reanuda desde un punto de control.

### Consultas

1. **Condición de igualdad**: se localiza la partición y se hace búsqueda binaria en los runs ordenados.
2. **Varias condiciones**: se hace una unión por mezcla (merge join) sobre el documento (sujeto). Todas las condiciones deben cumplirse dentro de un mismo documento.
3. **Verificación precisa**: se decodifican los registros candidatos con gogeul, se comparan campo a campo y se lee el Edge Id.

```sh
silk query -triple P106=Q169470 ARCHIVE
silk query -count -triple P31=Q5 -triple P106=Q169470 ARCHIVE
silk query -label ko -match LABEL:1=Q42 ARCHIVE
```

## Mediciones

Medido sobre Wikidata Q1–Q10000 y 16.696 documentos de propiedades (271 MB, 7,07 millones de registros de índice). 8 hilos, mejor de 7 ejecuciones, sin contar el arranque del proceso.

### Consultas

| Consulta | Documentos resultantes | Método anterior (recorrido completo) | Índice SILK |
|---|---:|---:|---:|
| P106=Q169470 (ocupación = físico) | 55 | ~20ms | 0,12ms |
| P31=Q5 (ser humano) | 1.579 | ~19ms | ~1ms |
| ser humano + físico | 54 | ~38ms | ~1ms |
| LABEL ko | 9.746 | (no posible) | ~4ms |

- El método anterior recorría por completo el mapa de registros TRIPLE.
- En LABEL ko, la mayor parte del tiempo se va en leer 9.746 registros del pack para la verificación precisa.

### Tamaño, construcción e incrementos

| Elemento | Valor |
|---|---|
| Tamaño del índice | 113MB (15,7B por registro de media) |
| Construcción | ~3 segundos (análisis de documentos en un solo hilo) |
| Actualización incremental (4.217 revisiones modificadas) | 1,8 segundos |
| Resultado incremental | Tras 2 actualizaciones, 2 fusiones y una interrupción con reanudación, los resultados de consulta son idénticos byte a byte a los de un índice construido desde cero |
| Amplificación de escritura | 1,31 acumulada (1,71 si se reconstruye cada vez) |

- Extrapolado a todo Wikidata (unos 7.500 millones de registros), el índice ocuparía unos 110 GB (**estimación**).
- El coste es el tamaño: unas 4 veces más que un mapa simple de 4 B por registro. Reducir el ancho de ranura y las firmas de entidad son lo siguiente que se estudiará.

### Escaneo de firmas (medición previa para firmas de entidad)

Tiempo, convertido a escala, de escanear 100 millones de firmas de 128 bits con máscara y patrón (i7-14700K, AVX2).

| Implementación | Tiempo |
|---|---:|
| NumPy, 1 hilo | ~1s |
| Go, 1 hilo | ~134ms |
| Go, 8 hilos | ~27ms |
| Go, 16–20 hilos | ~23ms (límite del ancho de banda de memoria) |

La diferencia no la marca el lenguaje, sino **los bucles fusionados sin arreglos intermedios y el uso de varios hilos**.

## Relación con la búsqueda vectorial

No es un reemplazo, sino un reparto de funciones.

| | SILK | Búsqueda vectorial |
|---|---|---|
| Consultas que atiende | Consultas estructuradas (condiciones de predicado, objeto, idioma, entidad) | Similitud semántica difícil de expresar como estructura |
| Resultado | El conjunto que cumple las condiciones (exacto) | Un ranking de similitud (aproximado) |
| Requisito | Los datos deben estar estructurados en GEUL | Basta con el texto original o los embeddings |

Para consultas que buscan hechos expresados en GEUL, SILK es exacto y barato. Para texto original sin estructura o para buscar "algo parecido", la búsqueda vectorial es mejor opción.

## Posición y próximos pasos

SILK es **la tecnología de búsqueda que usa WMS (el coordinador de almacenamiento y recuperación de GEUL)**. Juzgar si una afirmación encontrada es correcta corresponde a un motor de evaluación aparte.

| Próximo paso | Contenido |
|---|---|
| Firmas de entidad | Una cadena de bits de ancho fijo de 16–128 bits por entidad. El usuario declara los campos (enumeración, one-hot, Bloom, prefijo, rango). Es un primer filtro aproximado seguido de verificación precisa. Actualmente en fase de planificación (solo una parte está en la biblioteca y aún no en el índice) |
| Especificación como documento GEUL | Declarar la especificación JSON como documento GEUL y leer la disposición desde los documentos de especificación de códecs (DECLARE, FIELD) |
| Índice de ensamblaje de afirmaciones | Índice Target que encuentra directamente el TRIPLE al que apunta un QUALIFIER o un SOURCE |
| Preparación para gran escala | Límites de memoria en construcción y fusión, paralelización del análisis en la construcción |

La idea inicial (2026-03) era un diseño en Python y NumPy que escaneaba identificadores de entidad de 64 bits con AND bit a bit. Hoy es un motor en Go que indexa directamente los registros GEUL.

## Repositorio y licencia

- Repositorio: <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a>
- Instalación: `go install github.com/geul-org/silk/cmd/silk@latest`
- Licencia: nuestra obra es CC0 1.0. Los componentes de terceros siguen sus propias licencias (NOTICE del repositorio).
