---
title: "Repositorios"
date: 2026-02-28T12:00:00+09:00
summary: "Repositorios de GitHub que componen el proyecto GEUL. Diseño del lenguaje, pipeline de codificación, motor de búsqueda y sitio web."
image: "/images/og-default.webp"
---

El proyecto GEUL se compone de cuatro repositorios.

Diseñar el lenguaje (geul), codificar las entidades del mundo en 64 bits (geul-sidx), buscar sobre ese índice (silk) y explicar por qué todo esto es necesario (geul-org).

---

## geul

Un lenguaje artificial semánticamente alineado y formato de flujo binario para IA.

Un sistema lingüístico de 2 bytes (65.536 símbolos) diseñado para la comunicación inequívoca entre humanos e IA. Cada enunciado lleva su fuente, marca temporal y nivel de confianza. Cada entidad tiene un identificador único. El formato de flujo opera en unidades de 16 bits, definiendo 10 tipos de paquetes (Verb Edge, Entity Node, Triple Edge, etc.) bajo un esquema de prefijo de 10 bits.

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| Lenguaje | Go, Python |
| Licencia | MIT |

---

## geul-sidx

Constructor de libros de códigos y pipeline de codificación SIDX (Semantic-aligned Index).

Codifica 108,8 millones de entidades de Wikidata en identificadores estructurados de 64 bits. Define 63 tipos de entidades, diseña esquemas de atributos de 48 bits por tipo, construye libros de códigos y valida los resultados de codificación (VALID). Es el productor de los índices y libros de códigos que SILK consume.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| Lenguaje | Python |
| Licencia | MIT |

---

## silk

SILK (Symbolic Index for LLM Knowledge) — una arquitectura de búsqueda neuro-simbólica.

Busca con enteros de 64 bits. No requiere base de datos vectorial, ni grafo ANN, ni modelo de embeddings. Una sola operación AND bit a bit con NumPy busca en 100 millones de registros, y la afirmación central es que Python solo supera a las búsquedas vectoriales optimizadas en C++/Rust. Proporciona un pipeline de consultas híbrido que combina búsqueda en libros de códigos con asistencia de LLM.

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| Lenguaje | Python |
| Licencia | MIT |

---

## geul-org

El código fuente de este sitio web.

Un generador de sitios estáticos Hugo que soporta 12 idiomas. Desplegado mediante S3 + CloudFront, con una CloudFront Function que gestiona la detección de idioma y URLs limpias.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| Lenguaje | Hugo (Go Templates), CSS |
| Licencia | MIT |
