---
title: "Formato de flujo"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "El flujo GEUL es una secuencia de paquetes que comienza y termina con un Meta Node. Define el alcance de TID, las referencias directas y las reglas de orden de paquetes."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

El flujo GEUL es una **secuencia de paquetes que comienza y termina con un Meta Node**, constituyendo un documento GEUL completo.

## Características principales

- **Límites explícitos:** STREAM_START / STREAM_END (Meta Node)
- **Alcance de TID:** Válido solo dentro del flujo
- **Referencia directa:** Solo se pueden referenciar TIDs ya declarados
- **Big Endian:** Network Byte Order

## Estructura del flujo

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← Obligatorio (Meta Node)
│          (declaración de ancho TID) │     0xC000 (TID de 16 bits)
├─────────────────────────────────────┤
│          Metadatos (opcional)       │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          Paquetes del cuerpo        │
│          - Entity Node              │
│          - Quantity Node            │
│          - Verb Edge                │
│          - Triple Edge              │
│          - Event6 Edge              │
│          - Clause Edge              │
│          - Context Edge             │
│          - Group Edge               │
│          - Faber Edge               │
├─────────────────────────────────────┤
│          STREAM_END                 │  ← Opcional (recomendado)
└─────────────────────────────────────┘
```

El flujo mínimo es `STREAM_START`(1 palabra) + `STREAM_END`(1 palabra) = 2 palabras (4 bytes); incluso un flujo vacío es válido.

## Principios de asignación de TID

| Regla | Descripción |
|-------|-------------|
| **Obligatoriedad** | Cada Edge/Node en el flujo tiene un TID |
| **Unicidad** | Los TIDs son únicos dentro del flujo |
| **Alcance** | Los TIDs solo son válidos dentro de su flujo |
| **Dirección directa** | Solo se pueden referenciar TIDs ya declarados en el momento de la referencia |

### Posición de TID

| Tipo | Posición del TID | Posición de referencia |
|------|-----------------|----------------------|
| **Meta Node** | No tiene | No tiene |
| **Entity Node** | Última palabra | No tiene |
| **Quantity Node** | Última palabra | No tiene |
| **Tiny Verb Edge** | No tiene | No tiene (inline) |
| **Verb Edge** | Área de Header | Después del Payload |
| **Triple Edge** | Área de Header | Después del Payload |
| **Event6 Edge** | Área de Header | Después del Payload |
| **Clause Edge** | Área de Header | Después del Payload |
| **Context Edge** | Área de Header | Después del Payload |
| **Group Edge** | 2da palabra | 3ra+ palabra |

Los **Nodes** solo se definen a sí mismos, por lo que el TID va al final; los **Edges** referencian otros TIDs, por lo que el TID va antes que las referencias.

### TIDs reservados

| TID | Uso |
|-----|-----|
| 0x0000 | **Marcador de terminación** ([Group Edge](../group-edge/), etc.) |
| 0xFFFF | Reservado (base de 16 bits) |

## Reglas de orden de paquetes

### Orden declaración-referencia

```
Correcto:
  [Entity: Juan, TID=0x0001]
  [Entity: María, TID=0x0002]
  [Verb Edge: encontrarse, Subject=0x0001, Object=0x0002]

Incorrecto:
  [Verb Edge: encontrarse, Subject=0x0001, Object=0x0002]  ← 0x0001 no declarado
  [Entity: Juan, TID=0x0001]
  [Entity: María, TID=0x0002]
```

### Orden recomendado

```
1. STREAM_START
2. Metadatos (VERSION, CREATED_AT, CREATOR)
3. Entity Nodes (declaración de entidades)
4. Quantity Nodes (cantidades/literales)
5. Group Edges (definición de grupos)
6. Tiny Verb Edges (predicados inline)
7. Verb Edges (predicados generales)
8. Triple Edges (propiedades/relaciones)
9. Event6 Edges (eventos)
10. Clause Edges (relaciones discursivas)
11. Context Edges (contexto)
12. Faber Edges (código/AST)
13. STREAM_END
```

Es solo el orden recomendado; se pueden organizar libremente mientras se respete la regla de declaración-referencia.

### Prohibición de referencias circulares

Las referencias circulares de tipo A → B → A no son posibles. Si se necesitan relaciones circulares, se expresan con Edges separados.

```
Posible:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## Ejemplo de flujo

### "Juan se encontró con María"

```
1. STREAM_START (TID 16 bits)
   0xC0 0x00

2. Entity: Juan (TID=0x0001)
   [Paquete Entity...] 0x00 0x01

3. Entity: María (TID=0x0002)
   [Paquete Entity...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "Juan y María se encontraron en el colegio"

```
1. STREAM_START
   0xC0 0x00

2. Entity: Juan (TID=0x0001)
3. Entity: María (TID=0x0002)
4. Entity: Colegio (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Miembros: 0x0001, 0x0002, 0x0000 (terminación)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (grupo)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## Validación de flujo

### Validación obligatoria

| Elemento | Verificación |
|----------|-------------|
| Inicio | ¿Comienza con STREAM_START? |
| Unicidad de TID | ¿No hay TIDs duplicados? |
| Validez de referencia | ¿Todos los TIDs referenciados están declarados? |
| Dirección directa | ¿Los TIDs estaban declarados en el momento de la referencia? |

### Código de validación

```python
def validate_stream(packets: list) -> dict:
    """Validación del flujo"""
    errors = []
    declared_tids = set()

    # Validación de inicio
    if not packets or packets[0].type != "STREAM_START":
        errors.append("El flujo no comienza con STREAM_START")

    for packet in packets:
        # Validación de unicidad de TID
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"TID duplicado: {packet.tid}")
            declared_tids.add(packet.tid)

        # Validación de referencias
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"Referencia a TID no declarado: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## Flujos múltiples

Cada flujo es independiente, y el alcance de TID está separado por flujo. El TID=0x0001 del Flujo A y el TID=0x0001 del Flujo B son entidades diferentes.

Las referencias cruzadas entre flujos (Cross-reference) no están soportadas actualmente; se podrán extender en el futuro con la introducción de IDs de flujo y mecanismos de Import/Export.
