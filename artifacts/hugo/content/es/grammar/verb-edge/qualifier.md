---
title: "Calificadores semánticos"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "qualifier", "tense", "aspect"]
summary: "Calificadores semánticos del Verb Edge. Codifican información gramatical y pragmática del predicado en 14 categorías: evidencialidad, modo, modalidad, tiempo, aspecto, cortesía, polaridad, intencionalidad, confianza e iteratividad."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge codifica diversos calificadores semánticos además del cuerpo verbal. Junto con los [participantes](../semantic-role/), constituyen el significado completo del predicado.

## Lista de calificadores

| Categoría | Nombre en inglés | Tipo de datos | Mapeo de valores |
|-----------|-----------------|---------------|------------------|
| Verbo central | Core Verb | Identificador | Identificador absoluto de alineación semántica |
| Lista de [participantes](../semantic-role/) | Participant List | Lista de tipo compuesto | {entidad, rol gramatical, rol semántico} |
| Hablante | Speaker | Referencia | Sujeto del predicado (obligatorio) |
| Oyente | Listener | Referencia | Destinatario del predicado (nullable) |
| Evidencialidad | Evidentiality | Float [-1.0~1.0] | -1=inferencia, 0=experiencia directa, 1=testimonio |
| Modo | Mood | Float [-1.0~1.0] | -1=hipotético, 0=declarativo, 1=imperativo |
| Modalidad | Modality | Float [0.0~1.0] | Grado de voluntad |
| Tiempo | Tense | Float [-1.0~1.0] | -1=pasado, 0=presente, 1=futuro |
| Aspecto | Aspect | Máscara de bits | 1:progresivo, 2:perfectivo, 4:resultativo |
| Cortesía | Politeness | Float [-1.0~1.0] | -1=informal, 0=neutro, 1=formal |
| Polaridad | Polarity | Float [-1.0~1.0] | -1=negativo, 0=indeterminado, 1=positivo |
| Intencionalidad | Volitionality | Float [-1.0~1.0] | -1=no intencional, 0=indeterminado, 1=intencional |
| Confianza | Confidence | Float [-1.0~1.0] | -1=especulación, 0=indeterminado, 1=certeza |
| Iteratividad | Iterativity | Entero | 0=indeterminado, 1=una vez, MAX=infinito |

## Evidencialidad (Evidentiality)

Expresa la fuente de la información.

| Valor | Significado | Ejemplo |
|-------|-------------|---------|
| -1.0 | Inferencia | "parece que ~" |
| 0.0 | Experiencia directa | "~hizo" |
| 1.0 | Testimonio | "dicen que ~" |

## Modo (Mood)

Expresa la función del enunciado.

| Valor | Significado | Ejemplo |
|-------|-------------|---------|
| -1.0 | Hipotético/contrafactual | "si hubiera ~" |
| 0.0 | Declarativo/factual | "~es" |
| 1.0 | Imperativo/petición | "¡haz ~!" |

## Tiempo (Tense)

Expresa la ubicación temporal del evento.

| Valor | Significado | Ejemplo |
|-------|-------------|---------|
| -1.0 | Pasado | "~hizo" |
| 0.0 | Presente | "~hace" |
| 1.0 | Futuro | "~hará" |

## Aspecto (Aspect)

Expresa la estructura temporal interna del evento mediante una máscara de bits.

| Bits | Significado | Ejemplo |
|------|-------------|---------|
| 001 | Progresivo | "está ~ndo" |
| 010 | Perfectivo | "ha ~do" |
| 100 | Resultativo | "tiene ~do" |
| 011 | Progresivo+perfectivo | "ha estado ~ndo" |

## Cortesía (Politeness)

Expresa la relación social entre hablante y oyente.

| Valor | Significado | Ejemplo |
|-------|-------------|---------|
| -1.0 | Informal/coloquial | "haz eso" |
| 0.0 | Neutro | "haga eso" |
| 1.0 | Formal/respetuoso | "tenga la bondad de hacer eso" |

## Principios de diseño

- **Valores continuos:** Se expresan como Float en lugar de clasificación discreta, permitiendo representar gradaciones
- **Bipolar:** La mayoría utiliza el rango [-1.0, 1.0] para expresar ambos extremos
- **Indeterminado:** 0.0 puede significar tanto "neutro" como "indeterminado" (Polarity, Volitionality, Confidence)
- **Combinación:** Representación de significados complejos mediante la mezcla de máscara de bits (Aspect) + Float
