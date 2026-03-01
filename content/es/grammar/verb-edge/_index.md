---
title: "Verb Edge"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "huffman", "WordNet"]
summary: "Clasifica 13,767 verbos de WordNet en 10 Primitives → 68 Sub-primitives y genera un libro de códigos de 16 bits mediante codificación Huffman. Logra una compresión promedio de 2.16 palabras con 3 tipos de paquetes: Tiny (2), Short (3) y Full (5)."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge es el tipo de Edge que expresa predicados/acciones en el flujo GEUL. Clasifica 13,767 verbos de WordNet en 10 Primitives → 68 Sub-primitives y genera un libro de códigos de 16 bits mediante **codificación Huffman a nivel de Sub-primitive**.

## Documentos secundarios

| Documento | Descripción |
|-----------|-------------|
| [Roles de participantes](./semantic-role/) | 16 Semantic Roles (codificación de 4 bits) |
| [Calificadores semánticos](./qualifier/) | 14 calificadores: evidencialidad, modo, tiempo, aspecto, etc. |

## Jerarquía verbal

```
10 Primitive (categorías semánticas superiores)
 ├── BE          ├── PERCEIVE    ├── FEEL
 ├── THINK       ├── CHANGE      ├── CAUSE
 ├── MOVE        ├── COMMUNICATE ├── TRANSFER
 └── SOCIAL
  → 68 Sub-primitive (clasificación intermedia)
    → 559 Root Verb (verbos raíz)
      → 13,767 Leaf Verb (todos los verbos de WordNet)
```

- Los Primitives (categorías principales) solo se encargan del **agrupamiento conceptual** sin asignación de bits
- Se asignan **códigos de longitud variable basados en frecuencia** a los 68 Sub-primitives
- Los grupos de verbos más frecuentes obtienen códigos más cortos (4 a 8 bits)

## Tipos de paquetes de Verb Edge

Los 3 tipos de paquetes Tiny/Short/Full comparten los mismos **16 bits de cuerpo verbal** en la última palabra.

| | Tiny | Short | Full |
|--|------|-------|------|
| Palabras | 2 (32bit) | 3 (48bit) | 5 (80bit) |
| Participantes | 16 patrones | 512 patrones | 19bit flags |
| Calificadores | 7 patrones | 3,640 patrones | 27bit |
| Cuerpo verbal | 16bit | 16bit | 16bit |
| Proporción esperada | 90% | 7% | 3% |

**Tamaño promedio de paquete:** 0.9x2 + 0.07x3 + 0.03x5 = **2.16 palabras**

### Tiny Verb Edge (2 palabras)

```
1st WORD:  [Prefix 5bit] [Target×patrón 11bit]
2nd WORD:  [Cuerpo verbal 16bit]
```

- Target×patrón: 18 Target × 113 patrones = 2,034 combinaciones
- Participantes 16 patrones × calificadores 7 patrones = 112 + 1 reservado = 113
- Cobertura ~90%

### Short Verb Edge (3 palabras)

```
1st WORD:  [Prefix 6bit] [Type 1bit=0] [Patrón participantes 9bit]
2nd WORD:  [Target×Patrón calificadores 16bit]
3rd WORD:  [Cuerpo verbal 16bit]
```

### Full Verb Edge (5 palabras)

```
1st WORD:  [Prefix 6bit] [Type 1bit=1] [Target participantes 5bit] [Flags participantes 4bit]
2nd+3rd:   [Flags participantes 15bit] [Calificadores 17bit]
4th WORD:  [Calificadores 10bit] [Reservado 6bit]
5th WORD:  [Cuerpo verbal 16bit]
```

## Cuerpo verbal de 16 bits

```
┌─────────────────────────┬────────────────────────────┐
│   sub_primitive code    │     Índice DFS en árbol    │
│   (4-8 bits, Huffman)   │     (8-12 bits)            │
└─────────────────────────┴────────────────────────────┘
```

- **sub_primitive code:** 4~8 bits variable (código Huffman)
- **DFS index:** identificación de verbos individuales dentro del sub_primitive

### Distribución de longitud de códigos

| Longitud | Cantidad | Verbos totales | Proporción |
|----------|----------|----------------|------------|
| 4 bits | 4 | 6,388 | 46.4% |
| 5 bits | 4 | 2,479 | 18.0% |
| 6 bits | 8 | 2,321 | 16.9% |
| 7 bits | 16 | 1,786 | 13.0% |
| 8 bits | 36 | 813 | 5.9% |

### Cálculo de bits del DFS index

| Verbos del sub_primitive | Bits necesarios |
|--------------------------|-----------------|
| 1~256 | 8 bits |
| 257~512 | 9 bits |
| 513~1024 | 10 bits |
| 1025~2048 | 11 bits |
| 2049~4096 | 12 bits |

Ejemplo: CHANGE-TRANSFORM = `0000`(4 bits) + 3,063 verbos (12 bits) = 16 bits.

### Longitud promedio de código

```
Promedio = Σ(longitud de código × número de verbos) / total de verbos ≈ 5.14 bits
```

| Método | Bits promedio |
|--------|---------------|
| Fijo 7 bits (68) | 7.00 |
| Codificación Huffman | 5.14 |
| **Ahorro** | **1.86 bits (27%)** |

## Primitives - categorías principales (10)

| Primitive | Significado | Sub-primitives | Verbos |
|-----------|-------------|----------------|--------|
| BE | Estado/existencia | 8 | 899 |
| PERCEIVE | Percepción/cognición | 4 | 218 |
| FEEL | Emoción | 6 | 204 |
| THINK | Pensamiento | 6 | 769 |
| CHANGE | Cambio | 8 | 3,358 |
| CAUSE | Causación/acción | 14 | 3,739 |
| MOVE | Movimiento | 6 | 2,182 |
| COMMUNICATE | Comunicación | 6 | 586 |
| TRANSFER | Transferencia | 4 | 530 |
| SOCIAL | Acción social | 6 | 387 |

## Sub-primitives de mayor frecuencia (código de 4 bits)

| Sub-primitive | Código | Verbos | Proporción | Ejemplo |
|---------------|--------|--------|------------|---------|
| CHANGE-TRANSFORM | `0000` | 3,063 | 22.2% | "cambiar", "convertirse" |
| CAUSE-USE | `0001` | 1,358 | 9.9% | "usar", "utilizar" |
| MOVE-DISPLACE | `0010` | 1,025 | 7.4% | "desplazar" |
| MOVE-GO | `0011` | 942 | 6.8% | "ir" |

Los 4 Sub-primitives superiores representan el 46.4% del total.

## Filosofía de diseño

### Razón de elegir codificación Huffman

- CHANGE-TRANSFORM (22.2%) tiene una frecuencia abrumadoramente alta
- **Ahorro del 27% en bits promedio** respecto a la asignación fija
- Los 4 sub_primitives superiores representan el 46.4% del total

### Razón de eliminar los bits de Primitive

- Anterior: Primitive 3 bits + Sub_primitive 4 bits = 7 bits fijos
- Nuevo: Codificación directa de Sub_primitive = 4~8 bits variable
- **Ahorro de hasta 4 bits** en verbos de alta frecuencia

### Mantenimiento del agrupamiento semántico

La clasificación por Primitives se mantiene para la legibilidad humana y como pistas de agrupamiento semántico durante el entrenamiento de LLMs.
