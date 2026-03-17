---
title: "Repositorios"
date: 2026-02-28T12:00:00+09:00
summary: "Repositorios de GitHub que componen el proyecto GEUL. Especificación del lenguaje, libros de códigos gramaticales, búsqueda y sitio web."
image: "/images/og-default.webp"
---

Todos los repositorios se encuentran en la organización [geul-org](https://github.com/geul-org) de GitHub.

---

## Lenguaje

### geul

Un lenguaje artificial semánticamente alineado y formato de flujo binario para IA.

Un sistema lingüístico de 2 bytes (65.536 símbolos) diseñado para la comunicación inequívoca entre humanos e IA. Cada enunciado lleva su fuente, marca temporal y nivel de confianza. Cada entidad tiene un identificador único. El formato de flujo opera en unidades de 16 bits, definiendo 10 tipos de paquetes (Verb Edge, Entity Node, Triple Edge, etc.) bajo un esquema de prefijo de 10 bits.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| Lenguaje | Go, Python |
| Licencia | MIT |

---

## Gramática

### geul-verb

Libro de códigos de verbos SIDX de 16 bits (basado en WordNet).

Mapea los synsets de verbos de WordNet a códigos de 16 bits para su uso en paquetes GEUL Verb Edge. Proporciona el vocabulario verbal que consume el formato de flujo.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| Lenguaje | Python |
| Licencia | MIT |

### geul-entity

Libro de códigos de entidades SIDX de 48 bits (basado en Wikidata).

Codifica entidades de Wikidata en identificadores estructurados de 48 bits. Define tipos de entidades, diseña esquemas de atributos por tipo y construye los libros de códigos que SILK consume.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| Lenguaje | Python |
| Licencia | MIT |

### geul-quantities

Libro de códigos de nodos de cantidad.

Define el esquema de codificación para valores de cantidad — números con unidades, rangos y precisión — utilizados en paquetes GEUL Quantity Node.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| Lenguaje | Python |
| Licencia | MIT |

### geul-ast

Libro de códigos de bordes AST.

Define el esquema de codificación para bordes de árboles de sintaxis abstracta, permitiendo la representación estructurada de código dentro del formato de flujo GEUL.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| Lenguaje | Python |
| Licencia | MIT |

---

## Búsqueda

### silk

SILK (Symbolic Index for LLM Knowledge) — una arquitectura de búsqueda neuro-simbólica.

Busca con enteros de 64 bits. No requiere base de datos vectorial, ni grafo ANN, ni modelo de embeddings. Una sola operación AND bit a bit con NumPy busca en 100 millones de registros, y la afirmación central es que Python solo supera a las búsquedas vectoriales optimizadas en C++/Rust. Proporciona un pipeline de consultas híbrido que combina búsqueda en libros de códigos con asistencia de LLM.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Lenguaje | Python |
| Licencia | MIT |

---

## Sitio web

### geul-org

El código fuente de este sitio web.

Un generador de sitios estáticos Hugo que soporta 12 idiomas. Desplegado mediante S3 + CloudFront, con una CloudFront Function que gestiona la detección de idioma y URLs limpias.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Lenguaje | Hugo (Go Templates), CSS |
| Licencia | MIT |
