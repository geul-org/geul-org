---
title: "Gramática de GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Especificación de la gramática de GEUL v1. Define los registros sobre palabras de 16 bits, los cuatro Kind, la estructura del documento, los Issuer y las reglas de publicación."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL (General Encoding Unified Language) es un lenguaje artificial y un formato binario para que personas e IA se comuniquen sin ambigüedad.

Estos documentos definen la gramática de GEUL v1. La edición actual es un borrador previo a la publicación y puede cambiar. La especificación se libera bajo [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## Vista general {#한눈에-보기}

- Todos los datos son una secuencia de **palabras de 16 bits (WORD)**, escritas en big endian.
- La unidad de datos es el **registro**. Un registro empieza con un TAG WORD, y ese TAG WORD indica el tipo y la longitud del registro.
- Hay cuatro tipos de registro (**Kind**).

| Kind | Qué hace | Ejemplo |
|---|---|---|
| Reference | Apunta a un objeto | Q42 de Wikidata, #7 dentro de este documento |
| Value | Contiene el valor mismo | fecha, cantidad, texto con idioma |
| Edge | Une otros registros para enunciar algo | «Q42 es una persona», «El nombre en inglés de Q42 es Douglas Adams» |
| Meta | Habla sobre el documento | versión de la especificación, ID del documento, autor, firma |

- Los registros se guardan en un **documento**. Como en HTML, un documento se divide en HEAD (Meta, más el SOURCE de todo el documento y su QUALIFIER) y BODY (Reference, Value, Edge).
- El documento lo emite un **Issuer** (entidad emisora), y cada versión queda fijada por un hash de contenido. Una versión publicada no se modifica.

## Principios de diseño {#설계-원칙}

1. **Se puede saltar sin codebook.** El tipo y la longitud de un registro están en los 16 bits del TAG WORD. Un decodificador que no conozca el método de interpretación (el codebook) puede contar y saltar registros.
2. **Se guardan enunciados, no hechos.** El documento anota, mediante Meta y Edge de fundamento, quién enunció algo, cuándo y a partir de qué.
3. **La identificación se hace con Reference.** Se apunta por ID, no por nombre. Los nombres se asignan con un Edge.
4. **Lo publicado no se modifica.** Las correcciones se emiten como una versión nueva. Un ID dentro del documento apunta al mismo objeto en todas las versiones.
5. **Se deja espacio vacío.** La mayor parte del espacio de bits se reserva para el futuro. Los códigos directos no se pueden recuperar, así que solo se asignan los de frecuencia confirmada.

## Documentos subordinados {#하위-문서}

Si es la primera vez que lee esto, siga la tabla de arriba abajo.

| Documento | Contenido |
|---|---|
| [Estructura del registro](record.md) | Disposición del TAG WORD, Length, Codec, TAG extendida |
| [Issuer y publicación](issuer.md) | Niveles de Issuer, tabla de asignación de 2 WORD, modo de divulgación, firma, clave de verificación |
| [Direcciones de publicación y lista de versiones](publishing.md) | Notación de ID, direcciones de publicación, especificación de formato, lista de Issuer, lista de versiones, capas de confianza |
| [Documento de especificación de Codec](codec-spec.md) | Codebook escrito con DECLARE, FIELD, ENUM y CODEC |
| [Documento general](document.md) | DOC, HEAD, BODY, END, ID del documento, hash de contenido, versiones y revisiones |
| [Índice de códigos](codec-index.md) | Las 227 casillas asignadas, tablas de Codec por Kind y familia |
| [Disposición de secciones](layout.md) | 16 secciones y disposición de casillas, rangos asignados y Reservados |
| [Marcador de posición](slot-marker.md) | ABSENT, UNKNOWN-VALUE, NO-VALUE, reglas de aceptación |
| [Reference](reference/_index.md) | Identificación de objetos, LOCAL, referencias externas, Quantifier, marcadores de posición |
| [Value](value/_index.md) | Familias de valores, códigos directos, texto, cantidad, fecha |
| [Meta](meta/_index.md) | Estructura, definición, procedencia, linaje, verificación, política, IMPORT |
| [Edge](edge/_index.md) | Familias de enunciado, fundamento, ejecución y TOULMIN; TRIPLE, QUALIFIER, LABEL |
| [TOULMIN](toulmin/_index.md) | Familia de grafos de veredicto y ejecución; disposición de NODE, LINK, SOURCE |
| [Ejemplo: un elemento de Wikidata](example.md) | Lectura de un documento palabra por palabra |

## Qué se sabe sin codebook {#코덱북-없이-알-수-있는-것}

| Información | Sin codebook | Fundamento |
|---|---|---|
| Kind | Se sabe | Rango de la sección del TAG WORD, `w >> 9` (Reference 0~2, Value 3·4, Edge 5~13, Meta 14·15) |
| Longitud total del registro, posición del siguiente registro | Se sabe | Length del TAG WORD |
| Número de Codec | Se sabe | TAG WORD (en formato Issuer, el Issuer y el número de Codec de la TAG extendida) |
| Familia y clase | Se sabe en parte | Solo la familia de los códigos directos de Edge se sabe por los bits. La familia de los códigos directos de Value y del formato Issuer, y la clase de Meta, no se saben por los bits. En el formato Issuer se saben el Issuer y el número de Codec. La clase de verificación de Meta se sabe por `C >= 5` de la sección 15 (`w >= 0x1E50`) |
| Edge Id de un Edge | Se sabe | El primer componente de un Edge (secciones 5~13) es siempre una Reference LOCAL |
| Marcadores de posición (no anotado, desconocido, inexistente) | Se sabe | El valor del WORD es `0x0000`, `0x0010`, `0x0020` (Reference, C < 3, L 0). [Marcador de posición](slot-marker.md) |
| Quantifier | Se sabe | Por el desplazamiento `C` dentro de la sección: `C % 5` si `5 <= C < 30` en la sección 0, o `C < 30` en la sección 1 |
| Longitud del TAG por Codec, posición de inicio del Payload | No se sabe | Codebook |
| Interpretación del Payload, función de los componentes del Edge | No se sabe | Codebook |

- Un decodificador sin codebook puede saltar registros y contarlos por Kind y Codec, pero no puede seguir la estructura del grafo.
- Todo decodificador debe procesar las clases de estructura, definición e IMPORT de Meta. Estos Codec pertenecen al codebook central de GEUL, y el decodificador los conoce por una tabla de números incorporada ([Meta](meta/_index.md)).

El codebook se publica como un documento GEUL ([Documento de especificación de Codec](codec-spec.md)). Así, el decodificador solo tiene que obtener y leer el documento de especificación que necesite.

## Estructura de regiones {#영역-구조}

Los bits superiores del TAG WORD dividen las regiones.

| Prefix | Región | Proporción | Definición |
|---|---|---|---|
| `1` | Futuro lejano | 50% | Reservado (futuro lejano). No se usa |
| `01` | Futuro | 25% | Reservado (futuro cercano). No se usa |
| `001` | Estándar | 12.5% | Gramática adoptada oficialmente y en operación |
| `000` | Libre y propuestas | 12.5% | Gramática actual. Si se adopta, la disposición se mantiene y solo el Prefix pasa a `001` |

Toda la gramática actual está en la región `000`. Todos los TAG WORD de esta especificación empiezan por `000`.

- Un decodificador v1 rechaza los TAG WORD cuyo Prefix no sea `000`. Las demás regiones las determinarán ediciones posteriores.
- La región `000` es un espacio de propuestas. Por ahora no se aplica registro ni protección.
