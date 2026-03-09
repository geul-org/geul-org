---
title: "Clause Edge"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "Edge fijo de 4 palabras que expresa relaciones lógicas y discursivas entre predicados, eventos y relaciones. Codifica relaciones de causalidad, temporalidad, contraste y argumentación con 16 tipos basados en RST."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge es un tipo de Edge que expresa **relaciones lógicas/discursivas** entre predicados ([Verb Edge](../verb-edge/)), eventos ([Event6 Edge](../event6-edge/)), relaciones ([Triple Edge](../triple-edge/)) u otros Clauses.

Diseñado basándose en las relaciones discursivas de RST (Rhetorical Structure Theory).

## Estructura de paquete (4 palabras, 64 bits)

```
1st WORD (16 bits):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │ Tipo rel.  │ Reserv.│
│       10 bits       │   4 bits   │ 2 bits │
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16 bits)
3rd WORD: TID 1 (16 bits) - primera cláusula
4th WORD: TID 2 (16 bits) - segunda cláusula
```

| Campo | Bits | Descripción |
|-------|------|-------------|
| Prefix | 10 | `1100 000 010` |
| Tipo de relación | 4 | 16 relaciones RST |
| Reservado | 2 | Para extensión futura |
| Edge TID | 16 | Identificador único de este Edge |
| TID 1 | 16 | Referencia a la primera cláusula |
| TID 2 | 16 | Referencia a la segunda cláusula |

## Tipos de relación (4 bits = 16)

### Relaciones causales

| Código | Tipo | Descripción | Ejemplo |
|--------|------|-------------|---------|
| 0000 | CAUSE | Causa→resultado | "Llovió, así que me quedé en casa" |
| 0001 | RESULT | Resultado←causa | "Me quedé en casa, porque llovió" |
| 0010 | CONDITION | Condición→consecuencia | "Si llueve, no voy" |
| 0011 | PURPOSE | Propósito | "Come para vivir" |

### Relaciones temporales/secuenciales

| Código | Tipo | Descripción | Ejemplo |
|--------|------|-------------|---------|
| 0100 | SEQUENCE | Orden cronológico | "Comió y luego durmió" |
| 0101 | PARALLEL | Simultáneo/paralelo | "Habló sonriendo" |

### Relaciones de contraste/concesión

| Código | Tipo | Descripción | Ejemplo |
|--------|------|-------------|---------|
| 0110 | CONTRAST | Contraste | "A es grande y B es pequeño" |
| 0111 | CONCESSION | Concesión | "Aunque fue difícil, lo hizo" |

### Relaciones de elaboración/fondo

| Código | Tipo | Descripción | Ejemplo |
|--------|------|-------------|---------|
| 1000 | ELABORATION | Detalle | "Concretamente hablando" |
| 1001 | BACKGROUND | Información de fondo | "Como referencia, en aquel entonces" |

### Relaciones argumentativas

| Código | Tipo | Descripción | Ejemplo |
|--------|------|-------------|---------|
| 1010 | EVIDENCE | Presentación de evidencia | "Porque... por eso" |
| 1011 | EVALUATION | Evaluación | "Esto es bueno/malo" |

### Otras relaciones

| Código | Tipo | Descripción | Ejemplo |
|--------|------|-------------|---------|
| 1100 | SOLUTIONHOOD | Problema→solución | "El problema es X, la solución es Y" |
| 1101 | ALTERNATIVE | Elección/alternativa | "Ir o no ir" |
| 1110 | MEANS | Medio | "Lo logró haciendo así" |
| 1111 | RESERVED | Reservado | Para extensión futura |

## Reglas de orden de TID

La dirección se determina por el orden de los TID.

| Relación | TID 1 | TID 2 |
|----------|-------|-------|
| CAUSE | Causa | Resultado |
| RESULT | Resultado | Causa |
| CONDITION | Condición | Consecuencia |
| PURPOSE | Acción | Propósito |
| SEQUENCE | Anterior | Posterior |
| EVIDENCE | Evidencia | Afirmación |
| ELABORATION | Núcleo | Detalle |

## Multinuclear vs Nucleus-Satellite

Sigue la distinción de RST.

### Nucleus-Satellite (asimétrico)

| Relación | TID 1 | TID 2 |
|----------|-------|-------|
| CAUSE | Causa (Satellite) | Resultado (Nucleus) |
| CONDITION | Condición (Satellite) | Consecuencia (Nucleus) |
| EVIDENCE | Evidencia (Satellite) | Afirmación (Nucleus) |
| ELABORATION | Núcleo (Nucleus) | Detalle (Satellite) |

### Multinuclear (simétrico)

| Relación | TID 1 | TID 2 |
|----------|-------|-------|
| SEQUENCE | Anterior | Posterior |
| PARALLEL | Primero | Segundo |
| CONTRAST | Primero | Segundo |
| ALTERNATIVE | Primero | Segundo |

En las relaciones simétricas, el orden de TID no indica prioridad semántica.

## Ejemplos

### Causalidad simple: "Llovió, así que me quedé en casa"

```
Verb Edge E01: rain(lluvia) | TID=0x0001
Verb Edge E02: stay(yo, casa) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + Reservado
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (causa: E01)
  4th: [0x0002]                    - TID 2 (resultado: E02)
```

### Clause anidado: "Llovió, así que me quedé en casa, y por eso estudié"

```
Verb Edge E01: rain(lluvia) | TID=0x0001
Verb Edge E02: stay(yo, casa) | TID=0x0002
Verb Edge E03: study(yo) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (referencia TID de Clause)
  4th: [0x0003]                    - E03
```

## Fundamento del diseño

### Por qué basarse en RST

- Más de 30 anos de investigacion acumulada
- Verificado con diversos corpus
- Existen herramientas de parsing discursivo
- Independiente del idioma

### Por qué 4 bits (16 tipos)

- Cubre 12 o mas relaciones nucleares de RST
- Margen para extension
- 3 bits (8 tipos) es insuficiente

### Por qué simplificar a 4 palabras

- Dirección: se determina por orden de TID (no necesita bits adicionales)
- Confianza: se maneja como metadatos separados
- 2 bits reservados: para extensión futura
