---
title: "Visión general"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1 es una secuencia de registros formados por palabras de 16 bits. Los registros son de cuatro tipos (Reference, Value, Edge y Meta) y se agrupan en un documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL (General Encoding Unified Language) es un lenguaje artificial y un formato binario para que personas e IA se comuniquen sin ambigüedad. Este documento define la gramática de GEUL v1.

## De un vistazo

- Todos los datos son una secuencia de **palabras de 16 bits (WORD)**. Se escriben en big endian.
- La unidad de los datos es el **registro**. Un registro empieza con un TAG WORD, y ese TAG WORD dice el tipo y la longitud del registro.
- Hay cuatro tipos de registro (**Kind**).

| Kind | Qué hace | Ejemplo |
|---|---|---|
| Reference | Apunta a un objeto | Q42 de Wikidata, #7 de este documento |
| Value | Contiene un valor en sí | Una fecha, una cantidad, un texto con idioma |
| Edge | Enlaza otros registros para formular una afirmación | "Q42 es una persona", "El nombre en inglés de Q42 es Douglas Adams" |
| Meta | Habla sobre el documento | Versión de la especificación, ID del documento, autor, firma |

- Los registros se agrupan en un **documento**. Como en HTML, un documento se divide en HEAD (Meta, y la procedencia del documento entero: SOURCE y sus QUALIFIER) y BODY (Reference, Value, Edge).
- El documento lo emite un **Issuer** (entidad emisora), y cada versión queda fijada por su hash de contenido. Una versión publicada no se modifica.

## Principios de diseño

1. **Se puede saltar sin libro de códigos.** El tipo y la longitud de un registro están en los 16 bits del TAG WORD. Un decodificador que no conozca el método de interpretación (el libro de códigos) puede contar y saltar registros.
2. **Contiene afirmaciones, no hechos.** El documento anota con Meta y Edge de fundamento quién hizo la afirmación, cuándo y a partir de qué.
3. **La identificación se hace con Reference.** Se apunta con un ID, no con un nombre. Los nombres se añaden con Edge.
4. **Lo publicado no se modifica.** Lo corregido se emite como una nueva versión. Los ID dentro de un documento apuntan al mismo objeto a lo largo de las versiones.
5. **Se deja espacio vacío.** La mayor parte del espacio de bits se deja para el futuro. Los códigos directos no se pueden recuperar, así que solo se asignan los de frecuencia confirmada.

## Estructura de regiones

Los bits superiores del TAG WORD dividen las regiones.

| Prefix | Región | Proporción | Definición |
|---|---|---|---|
| `1` | Futuro lejano | 50% | Reservada para un futuro lejano. No se usa |
| `01` | Futuro | 25% | Reservada para un futuro cercano. No se usa |
| `001` | Estándar | 12,5% | Gramática adoptada oficialmente y en operación |
| `000` | Libre·propuesta | 12,5% | Gramática actual. Cuando se adopte, el layout se deja igual y solo el Prefix pasa a `001` |

Toda la gramática actual está en la región `000`. Todos los TAG WORD de esta especificación empiezan por `000`.

- El decodificador v1 rechaza un TAG WORD cuyo Prefix no sea `000`. Las demás regiones las fijarán versiones posteriores.
- La región `000` es un espacio de propuestas. Por ahora no se aplica registro ni protección. Sin embargo, el layout de formato Issuer se reserva presuponiendo el sistema de registro posterior al lanzamiento del estándar oficial.

## Qué se puede saber sin libro de códigos

| Información | Sin libro de códigos | Base |
|---|---|---|
| Kind | Se sabe | TAG WORD |
| Longitud total del registro, posición del siguiente registro | Se sabe | Length del TAG WORD |
| Número de Codec | Se sabe | TAG WORD (en formato Issuer, el Issuer y el número de formato del TAG de extensión) |
| Familia·clase | Se sabe | Bits superiores del número de Codec o del número de formato |
| Edge Id de un Edge | Se sabe | El primer componente de un Edge es siempre un Reference LOCAL |
| Marcador de posición (no declarado·desconocido·sin valor) | Se sabe | El valor del WORD es `0`~`7` (Reference Codec `0000`, 1 WORD). [Marcador de posición](/es/grammar/reference/slot-marker/) |
| Longitud del TAG propio de cada Codec, posición de inicio del Payload | No se sabe | Libro de códigos |
| Interpretación del Payload, rol de los componentes de un Edge | No se sabe | Libro de códigos |

- Un decodificador sin libro de códigos puede saltar registros y contarlos por Kind y Codec, pero no puede recorrer la estructura del grafo.
- Todos los decodificadores deben procesar las clases de Meta de estructura, definición e IMPORT. Esos Codec pertenecen al libro de códigos central de GEUL ([Meta](/es/grammar/meta/)).

El libro de códigos se publica como documentos GEUL ([Documento de especificación de Codec](/es/grammar/codec-spec/)). Por eso, el decodificador solo necesita descargar y leer los documentos de especificación que necesite.

## Documentos subordinados

| Documento | Contenido |
|---|---|
| [Registro y TAG WORD](/es/grammar/record/) | Layout del TAG WORD, Length, Codec, TAG de extensión |
| [Documento](/es/grammar/document/) | DOC, HEAD, BODY, END, ID de documento, hash de contenido, versión y revisión |
| [Reference](/es/grammar/reference/) | Identificación de objetos, LOCAL, referencias externas, Quantifier, marcador de posición |
| [Value](/es/grammar/value/) | Familias de valores, códigos directos, texto·cantidad·fecha |
| [Edge](/es/grammar/edge/) | Familias de afirmación, fundamento, ejecución y TOULMIN; TRIPLE, QUALIFIER, LABEL |
| [Meta](/es/grammar/meta/) | Estructura, definición, procedencia, linaje, verificación, política, IMPORT |
| [Issuer y publicación](/es/grammar/issuer/) | Grados de Issuer, tabla de asignación de 1 WORD, modo de divulgación, firma, clave de verificación |
| [Direcciones de publicación y lista de versiones](/es/grammar/publishing/) | Notación de ID, dirección de publicación, designación de formato, índice de nombres, lista de versiones, capas de confianza |
| [Documento de especificación de Codec](/es/grammar/codec-spec/) | Libro de códigos escrito con DECLARE·FIELD·ENUM·CODEC |
| [Ejemplo: un elemento de Wikidata](/es/grammar/example/) | Leer un documento WORD por WORD |

## Problemas abiertos

- El Kind de los casos límite. Casos en que no está claro si colocar algo en Reference, Value, Edge o Meta, como una afirmación sobre otra afirmación.
