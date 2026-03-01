---
title: "Group Edge"
weight: 90
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "group", "set", "logic"]
summary: "Edge de longitud variable que agrupa múltiples Nodes en 7 tipos: AND, OR, LIST, SET, etc. Soporta miembros ilimitados mediante Prefix de 13 bits y marcador de terminación (0x0000)."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Group Edge es un tipo de Edge que **agrupa múltiples Nodes en un solo grupo** para su expresión.

## Estructura de paquete

```
1st WORD (16 bits)
┌───────────────────────┬───────────┐
│        Prefix         │ GroupType │
│        13 bits        │   3 bits  │
└───────────────────────┴───────────┘
  [1100 000 111 000]       [TTT]

2nd WORD: Edge TID (16 bits)
3rd+ WORD: TIDs de miembros (variable)
Última WORD: Marcador de terminación (0x0000)
```

| Campo | Bits | Descripción |
|-------|------|-------------|
| Prefix | 13 | `1100 000 111 000` |
| GroupType | 3 | Tipo de grupo (8 tipos) |
| Edge TID | 16 | Identificador único de este Edge |
| TIDs de miembros | 16×N | Referencias a miembros del grupo |
| Marcador de terminación | 16 | `0x0000` |

Mínimo 4 palabras (1 miembro), general 5~6 palabras (2~3 miembros), máximo sin límite.

## GroupType (3 bits = 8)

| Código | Tipo | Significado | Miembros |
|--------|------|-------------|----------|
| 000 | **AND** | Conjunción lógica | 2+ |
| 001 | **OR** | Disyunción lógica | 2+ |
| 010 | **XOR** | Selección exclusiva | 2+ |
| 011 | **LIST** | Lista ordenada | 1+ |
| 100 | **SET** | Conjunto sin orden | 1+ |
| 101 | **RANGE** | Rango (inicio~fin) | Exactamente 2 |
| 110 | **PAIR** | Par ordenado | Exactamente 2 |
| 111 | Extensión | Extensión futura | - |

## Detalle de GroupType

### AND

Todos los miembros participan simultáneamente. Ejemplo: "Juan **y** María **y** Pedro se reunieron"

### OR

Uno o más de los miembros aplican (or inclusivo). Ejemplo: "Pida café **o** té"

### XOR

Exactamente uno de los miembros aplica (or exclusivo). Ejemplo: "Aprobado o reprobado (uno de los dos)"

### LIST

Lista donde el orden es significativo. Se usa para rankings y secuencias. Ejemplo: "1.º Juan, 2.º María, 3.º Pedro"

### SET

Conjunto donde el orden no importa. Solo importa la pertenencia. Ejemplo: "Asistentes: Juan, María, Pedro"

### RANGE

Rango continuo que incluye valores intermedios. Exactamente 2 miembros (inicio, fin). Ejemplo: "del 1 al 10"

### PAIR

Par ordenado simple. Exactamente 2 miembros. Se usa para coordenadas, key-value, etc. Ejemplo: "coordenada (3, 5)"

### RANGE vs PAIR

| Tipo | Significado | Valores intermedios |
|------|-------------|---------------------|
| RANGE | Rango continuo | Incluidos |
| PAIR | Par simple | No hay |

`RANGE [1, 5]` → 1, 2, 3, 4, 5 (existen valores intermedios). `PAIR [1, 5]` → (1, 5) (solo dos valores).

## Ejemplos

### "Juan y María se encontraron"

```
1. Entity Node: Juan (TID=0x0001)
2. Entity Node: María (TID=0x0002)
3. Group Edge: AND (TID=0x0100)
   1st: [1100 000 111 000] [000] = Prefix + AND
   2nd: [0x0100]                 = Edge TID
   3rd: [0x0001]                 = Juan
   4th: [0x0002]                 = María
   5th: [0x0000]                 = Terminación

4. Verb Edge: meet
   Subject: 0x0100 (referencia de grupo)

Total: 5 palabras
```

### "Coordenada (3, 5)"

```
1. Quantity Node: 3 (TID=0x0001)
2. Quantity Node: 5 (TID=0x0002)
3. Group Edge: PAIR (TID=0x0100)
   1st: [1100 000 111 000] [110] = Prefix + PAIR
   2nd: [0x0100]
   3rd: [0x0001]                 = Primero (x)
   4th: [0x0002]                 = Segundo (y)
   5th: [0x0000]

Total: 5 palabras
```

## Restricciones

| GroupType | Mínimo | Máximo |
|-----------|--------|--------|
| AND / OR / XOR | 2 | sin límite |
| LIST / SET | 1 | sin límite |
| RANGE / PAIR | 2 | 2 |

- Los TIDs de miembros deben referenciar Nodes/Edges ya declarados
- No se permite autorreferencia (ciclos)
- TID=0x0000 está reservado como marcador de terminación
