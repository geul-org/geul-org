---
title: "Roles de participantes"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "16 Participants que definen roles semánticos dentro de un evento. Codificación de 4 bits que abarca desde roles esenciales como Agent, Theme y Recipient hasta roles adicionales como Cause y Purpose."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Participant** es un Edge que especifica el **rol semántico** de las entidades involucradas en un evento dentro de una predicación.

```
Event Node (verbo)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## Principios de diseño

### Principio de separación

| Categoría | Pertenencia | Ejemplo |
|-----------|-------------|---------|
| **Participante** | Nivel de evento | Agent, Theme, Recipient |
| **Información pragmática** | Nivel de Context/Claim | Speaker, Listener, Evidentiality |

Speaker (hablante), Listener (oyente) y Source (fuente de información) no son participantes, sino que se procesan en los **[calificadores semánticos](../qualifier/)** o en Context/Claim.

### Codificación

- **4 bits** (0x0~0xF), máximo 16 roles semánticos
- Coincidencia de patrones posible mediante operaciones SIMD de bits

## Lista de roles semánticos (16)

### Participantes esenciales (Core Participants)

| ID | Código | Rol | Definición | Ejemplo |
|----|--------|-----|------------|---------|
| 0x0 | **AGT** | Agent (agente) | Sujeto que realiza la acción intencionalmente | "**Juan** pateó la pelota" |
| 0x1 | **EXP** | Experiencer (experimentante) | Sujeto que experimenta emoción/cognición/percepción | "**María** estaba triste" |
| 0x2 | **THM** | Theme (tema) | Objeto que se mueve o cuyo estado se describe | "Juan pateó **la pelota**" |
| 0x3 | **PAT** | Patient (paciente) | Objeto cuyo estado cambia por la acción | "**El cristal** se rompió" |
| 0x4 | **RCP** | Recipient (receptor) | Destinatario que recibe algo | "Le dio un libro **a María**" |
| 0x5 | **BNF** | Beneficiary (beneficiario) | Quien obtiene beneficio de la acción | "Lo hizo **para el niño**" |

### Instrumentos y medios (Instruments & Means)

| ID | Código | Rol | Definición | Ejemplo |
|----|--------|-----|------------|---------|
| 0x6 | **INS** | Instrument (instrumento) | Herramienta utilizada para realizar la acción | "Clavó el clavo **con el martillo**" |
| 0x7 | **MNR** | Manner (manera) | Forma en que se realiza la acción | "Corrió **rápidamente**" |

### Espacial (Spatial)

| ID | Código | Rol | Definición | Ejemplo |
|----|--------|-----|------------|---------|
| 0x8 | **LOC** | Location (ubicación) | Lugar donde ocurre el evento | "Vivió **en Madrid**" |
| 0x9 | **SRC** | Source (origen) | Punto de partida del movimiento | "Salió **de casa**" |
| 0xA | **DST** | Destination (destino) | Punto de llegada del movimiento | "Fue **al colegio**" |
| 0xB | **PTH** | Path (trayecto) | Punto intermedio del movimiento | "Pasó **por el parque**" |

### Causal (Causal)

| ID | Código | Rol | Definición | Ejemplo |
|----|--------|-----|------------|---------|
| 0xC | **CAU** | Cause (causa) | Causa del evento | "Se canceló **por la lluvia**" |
| 0xD | **PRP** | Purpose (propósito) | Finalidad de la acción | "Fue **a hacer ejercicio**" |

### Otros (Others)

| ID | Código | Rol | Definición | Ejemplo |
|----|--------|-----|------------|---------|
| 0xE | **COM** | Comitative (compañía) | Acompañante | "Fue **con su amigo**" |
| 0xF | **ATR** | Attribute (atributo) | Predicado de estado/propiedad | "El cielo está **azul**" |

## Estructura de Participant Edge

```
PARTICIPANT Edge {
    source:     Event SIDX       // nodo verbal
    target:     Entity SIDX      // nodo de entidad
    role:       4-bit            // rol semántico (0x0~0xF)
    gram_role:  2-bit (optional) // rol gramatical (sujeto/objeto/complemento)
    focus:      4-bit (optional) // grado de énfasis (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // referencia de cuantificador
}
```

| Campo | Bits | Descripción |
|-------|------|-------------|
| role | 4 | Rol semántico (obligatorio) |
| gram_role | 2 | 0=no especificado, 1=sujeto, 2=objeto, 3=complemento |
| focus | 4 | Importancia informativa (0=fondo, 15=énfasis máximo) |
| quant_ref | 16 | TID de cuantificador como "todos", "la mayoría" |

## Theme vs Patient

| Rol | Cambio de estado | Ejemplo |
|-----|-----------------|---------|
| Theme | Ninguno (movimiento/descripción) | "**Lanzó** la pelota" (la pelota permanece igual) |
| Patient | Sí (afectado) | "**Rompió** el cristal" (el cristal cambia de estado) |

En la práctica, se pueden unificar como Theme y distinguir por el significado verbal cuando sea necesario.

## Ejemplos

### Oración simple: "Juan le dio un libro a María"

```
Event: give.v.01
├─ PARTICIPANT (AGT) → Juan
├─ PARTICIPANT (THM) → libro
└─ PARTICIPANT (RCP) → María
```

### Oración compleja: "Por la lluvia, fue corriendo rápido con su amigo desde casa hasta el colegio"

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [hablante]
├─ PARTICIPANT (CAU) → lluvia
├─ PARTICIPANT (COM) → amigo
├─ PARTICIPANT (SRC) → casa
├─ PARTICIPANT (DST) → colegio
└─ PARTICIPANT (MNR) → rápidamente
```

### Descripción de estado: "El cielo está muy azul"

```
Event: be.v.01
├─ PARTICIPANT (THM) → cielo
└─ PARTICIPANT (ATR) → azul (focus=15)
```

## Normalización activa/pasiva

| Forma superficial | Agent | Theme |
|-------------------|-------|-------|
| "Apple adquirió Tesla" | Apple | Tesla |
| "Tesla fue adquirida por Apple" | Apple | Tesla |

Se normaliza en la fase de análisis para procesar con el mismo patrón.
