---
title: "Gramática de GEUL"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "SIDX", "specification"]
summary: "Especificación del formato de flujo binario basado en el identificador semántico global de 64 bits SIDX. Define los principios de diseño, el sistema de Prefix, los 9 tipos de paquetes y las reglas de codificación."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

La gramática de GEUL es un formato de flujo binario basado en SIDX (Semantic-aligned Index), un identificador semántico global de 64 bits.

## Principios de diseño

1. **Extensibilidad a largo plazo:** No se asignan usos temporales a los bits reservados. Se preserva el espacio para las generaciones futuras.
2. **Permanencia semántica:** El significado de un patrón de bits definido no se modifica. Si se necesita un nuevo significado, se asigna un nuevo patrón.
3. **Compatibilidad retroactiva:** Cualquier versión de GEUL debe poder interpretar completamente todas las versiones anteriores.
4. **Complejidad lineal:** El procesamiento simbólico de GEUL mantiene O(n) respecto a la longitud.

## Resumen de SIDX

SIDX es un identificador semántico global de 64 bits. Se ramifica secuencialmente desde el bit más significativo para determinar la región.

| Prefix | Región | Proporción | Uso |
|--------|--------|------------|-----|
| `1` | Far Future | 50% | Reservado para el futuro lejano |
| `01` | Future | 25% | Reservado para el futuro cercano |
| `001` | Standard | 12.5% | Región estándar oficial |
| `000` | Free | 12.5% | Completamente libre |

`0001` es el espacio convencional utilizado por esta propuesta dentro de la región libre (000).

## Sistema de Prefix

```
bit1
├─ 1: Far Future
│
└─ 0
    └─ bit2
        ├─ 1 (01): Future
        │
        └─ 0
            └─ bit3
                ├─ 1 (001): Standard
                │     └─ bit4~
                │         ├─ 1           (001 1)        → Tiny Verb Edge
                │         ├─ 01          (001 01)       → Verb Edge
                │         ├─ 001         (001 001)      → Entity Node
                │         └─ 000         (001 000)      → Región unificada de 9 bits
                │
                └─ 0 (000): Free
                      └─ 0001: Proposal (espejo de Standard)
```

## Tipos de paquetes

El flujo GEUL consta de 9 tipos de paquetes. Se enumeran en orden de asignación de bits de Prefix (= prioridad).

| Tipo | Prefix | Palabras | Descripción |
|------|--------|----------|-------------|
| Tiny Verb Edge | `0001 1` | 2 | Predicados simples de alta frecuencia |
| [Verb Edge](../verb-edge/) | `0001 01` | 3~5 | 559 raíces → 13,767 verbos WordNet |
| [Entity Node](../entity-node/) | `0001 001` | 4 | 64 EntityType, 48 bits de atributos |
| [Triple Edge](../triple-edge/) | `0001 000 110` | 4~5 | Propiedades/relaciones, Top63 + extensión |
| [Clause Edge](../clause-edge/) | `0001 000 101` | 4 | 16 relaciones discursivas/lógicas basadas en RST |
| [Event6 Edge](../event6-edge/) | `0001 000 100` | 3~8 | Evento de las 6 preguntas fundamentales |
| [Context Edge](../context-edge/) | `0001 000 011` | 3 | 64 tipos de cosmovisión/contexto |
| [Quantity Node](../quantity-node/) | `0001 000 010` | 4~7 | 64 códigos de unidad, SI/moneda/timestamp |
| [AST Edge](../ast-edge/) | `0001 000 001` | 3+ | 64 lenguajes de programación, 256 tipos de nodo AST |
| [Group Edge](../group-edge/) | `0001 000 000 111` | 4+ | 7 tipos de conjunto/grupo |

### Especificaciones comunes

| Documento | Descripción |
|-----------|-------------|
| [Formato de flujo](../stream-format/) | Reglas de formato de flujo, alcance de TID, orden de paquetes |

## Reglas de codificación

| Elemento | Regla |
|----------|-------|
| Orden de bytes | Big Endian |
| Orden de bits | MSB First (bit1 = MSB) |
| Tamaño de palabra | 16 bits (2 bytes) |

Todos los campos se alinean en límites de palabra de 16 bits, y el tamaño de paquete siempre es en unidades de palabra (múltiplos de 2 bytes). Si se necesita relleno, se completa con 0x00.
