---
title: "Event6 Edge"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "Edge de evento de longitud variable que expresa las 6 preguntas fundamentales (Who, What, Whom, When, Where, Why) de una sola vez. Realiza una estructura variable de 3 a 8 palabras mediante máscara de bits Presence."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge es un tipo de Edge de evento que expresa las **6 preguntas fundamentales** (Who, What, Whom, When, Where, Why) de una sola vez.

## Elementos de las 6 preguntas

| Elemento | Inglés | Bit | Significado | Referencia TID |
|----------|--------|-----|-------------|----------------|
| Quién | Agent | 0 | Agente | [Entity Node](../entity-node/) |
| Qué | Action | 1 | Acción | [Verb Edge](../verb-edge/) |
| A quién | Patient | 2 | Paciente | [Entity Node](../entity-node/) |
| Cuándo | Time | 3 | Tiempo | Quantity/Entity |
| Dónde | Location | 4 | Lugar | [Entity Node](../entity-node/) |
| Por qué | Reason | 5 | Razón/propósito | [Clause Edge](../clause-edge/)/Entity |

## Estructura de paquete

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: TIDs de elementos (en orden de Presence)
```

### Máscara de bits Presence (6 bits)

| Bit | Elemento | Si está presente |
|-----|----------|------------------|
| 0 | Who | Se incluye el TID correspondiente |
| 1 | What | Se incluye el TID correspondiente |
| 2 | Whom | Se incluye el TID correspondiente |
| 3 | When | Se incluye el TID correspondiente |
| 4 | Where | Se incluye el TID correspondiente |
| 5 | Why | Se incluye el TID correspondiente |

Total de palabras = 2 (encabezado + Edge TID) + popcount(Presence). El rango es de 3~8 palabras (48~128 bits).

## Estructura por modo

### Modo mínimo (3 palabras)

```
Ejemplo: "Llovió" (solo What)

1st: [Prefix] + [000010]      - Solo What presente
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### Modo nuclear (5 palabras)

Who + What + Whom. La composición más frecuente.

```
Ejemplo: "Juan golpeó a María"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - Juan
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - María
```

### Modo estándar (6 palabras)

```
Ejemplo: "Juan se encontró con María ayer"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - Juan
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - María
6th: [When TID]               - Ayer
```

### Modo completo (8 palabras)

```
Ejemplo: "Juan, por amor, le dio un regalo a María ayer en el colegio"

1st: [Prefix] + [111111]      - Todos
2nd: [Edge TID]
3rd: [Who TID]                - Juan
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - María
6th: [When TID]               - Ayer
7th: [Where TID]              - Colegio
8th: [Why TID]                - Amor (razón)
```

## Detalle de los elementos

### What (acción)

What referencia el TID de un [Verb Edge](../verb-edge/). El Verb Edge correspondiente contiene la información de calificadores como tiempo y aspecto.

### Why (razón)

Las razones simples se expresan con un TID de Entity ("amor"), y las razones complejas con un TID de [Clause Edge](../clause-edge/) ("porque llovió").

## Comparación Event6 vs Verb Edge

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **Enfoque** | Predicado/acción | Evento completo |
| **Participantes** | Estructura de Participant | TIDs de 6 preguntas |
| **Espacio-tiempo** | Expresión separada | When/Where integrados |
| **Razón** | Clause separado | Why integrado |
| **Palabras** | 2~5 | 3~8 |
| **Uso** | Expresión predicativa | Almacenamiento de eventos |

**Guía de selección:** Verb Edge para análisis de predicados/oraciones, Event6 Edge para almacenamiento de eventos/registros, [Triple Edge](../triple-edge/) para hechos simples.

## Ejemplos

### "Apple adquirió Tesla"

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

Total: 5 palabras
```

### "Yi Sun-sin murió en la batalla de Noryang en 1598"

```
Who:   Yi Sun-sin       → Entity TID 0x0010
What:  die (morir)      → Verb Edge TID 0x0101
When:  1598             → Entity TID 0x0011
Where: Batalla de Noryang → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - Yi Sun-sin
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1598
  6th: [TID: 0x0012]              - Batalla de Noryang

Total: 6 palabras
```

## Análisis (parsing)

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
