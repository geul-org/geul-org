---
title: "Context Edge"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "Edge ligero de 3 palabras que expresa 'en qué cosmovisión/contexto esta afirmación es verdadera'. Codifica las condiciones de verdad con 64 tipos incluyendo fuente, cosmovisión, ficción y perspectiva."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge expresa **"en qué cosmovisión/contexto este Claim es verdadero"**.

Es un concepto que corresponde a los mundos posibles de la Modal Logic: para un mismo Subject, pueden existir hechos diferentes según la cosmovisión.

```
Context "Realidad":           (Tierra, edad, 4600 millones de años)
Context "Tierra joven":       (Tierra, edad, 6000 años)
Context "Harry Potter":       (magia, exists, true)
```

## Estructura de paquete (3 palabras, 48 bits)

```
1st WORD (16 bits):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10 bits       │     6 bits      │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16 bits)
3rd WORD: Target TID (16 bits)
```

| Campo | Bits | Descripción |
|-------|------|-------------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=no especificado, 1~62=tipo, 63=extensión (reservado) |
| Context TID | 16 | Identificador unico de este Context |
| Target TID | 16 | Claim destino ([Triple](../triple-edge/)/[Verb](../verb-edge/)/[Event6](../event6-edge/)/[Clause](../clause-edge/) TID) |

## Context Type (6 bits = 64)

### Fuente (Source) -- Code 1~20

| Code | Tipo | Descripcion | Ejemplo |
|------|------|-------------|---------|
| 1 | SYSTEM | Generado automaticamente por sistema | Sincronizacion Wikidata |
| 2 | USER | Entrada directa del usuario | Creacion manual |
| 3 | DOCUMENT | Documento general | PDF, Word |
| 4 | NEWS | Articulo de noticias | Reuters, AP |
| 5 | ACADEMIC | Articulo academico | arXiv, Nature |
| 6 | GOVERNMENT | Gobierno/organismo publico | SEC, INE |
| 7 | WIKI | Wikipedia/Wikidata | Q42, P31 |
| 8 | API | API externa | Finanzas, clima |
| 9 | ORG | Comunicado de organizacion | IR empresarial |
| 10 | BOOK | Libro | Basado en ISBN |
| 11 | INTERVIEW | Entrevista/testimonio | Cita directa |
| 12 | DATASET | Conjunto de datos | Kaggle |
| 13 | SOCIAL | Redes sociales | Twitter |
| 14 | LEGAL | Leyes/jurisprudencia | Sentencia judicial |
| 15 | ARCHIVE | Archivo | archive.org |
| 16 | MULTIMEDIA | Video/audio | YouTube |
| 17 | DATABASE | Base de datos | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | Enciclopedia | Britannica |
| 19 | MANUAL | Manual/guia | Documentacion tecnica |
| 20 | STANDARD | Documento estandar | ISO, RFC |

### Derivado/inferencia (Derived) -- Code 21~30

| Code | Tipo | Descripcion | Ejemplo |
|------|------|-------------|---------|
| 21 | MODEL | Generado por modelo IA | GPT, Claude |
| 22 | INFERENCE | Inferencia logica | Basada en reglas |
| 23 | AGGREGATION | Agregacion/integracion | Sintesis de multiples fuentes |
| 24 | CALCULATION | Resultado de calculo | Aplicacion de formula |
| 25 | TRANSLATION | Traduccion | Original → traduccion |
| 26 | EXTRACTION | Extraccion | NER, RE |
| 27 | CORRECTION | Correccion | Correccion de errores |
| 28 | HEARSAY | Rumor | No confirmado |
| 29 | ESTIMATION | Estimacion | Valor aproximado |
| 30 | PREDICTION | Prediccion | Perspectiva futura |

### Cosmovision/creencia (Worldview) -- Code 31~45

| Code | Tipo | Descripcion | Ejemplo |
|------|------|-------------|---------|
| 31 | RELIGION | Cosmovision religiosa | Protestantismo, budismo |
| 32 | PHILOSOPHY | Perspectiva filosofica | Existencialismo |
| 33 | SCIENCE | Consenso cientifico | Fisica moderna |
| 34 | POLITICS | Perspectiva politica | Conservador, progresista |
| 35 | CULTURE | Perspectiva cultural | Oriental, occidental |
| 36 | MYTHOLOGY | Sistema mitologico | Mitologia griega |
| 37 | FOLKLORE | Folclore/tradicion oral | Leyendas locales |
| 38 | IDEOLOGY | Sistema ideologico | Capitalismo |
| 39 | THEORY | Teoria | Relatividad |
| 40 | HYPOTHESIS | Hipotesis | Pre-verificacion |
| 41 | TRADITION | Tradicion/costumbre | Tradicion confuciana |
| 42 | CONSENSUS | Consenso/doctrina aceptada | Doctrina academica |
| 43 | MAINSTREAM | Opinion mayoritaria | Opinion de la mayoria |
| 44 | ALTERNATIVE | Opinion alternativa | Opinion minoritaria |
| 45 | FRINGE | Marginal/heterodoxo | Pseudociencia |

### Ficcion/creacion (Fiction) -- Code 46~55

| Code | Tipo | Descripcion | Ejemplo |
|------|------|-------------|---------|
| 46 | NOVEL | Mundo de novela | El Senor de los Anillos |
| 47 | FILM | Mundo de pelicula | MCU |
| 48 | GAME | Mundo de videojuego | Zelda |
| 49 | COMICS | Mundo de comics | Universo DC |
| 50 | ANIMATION | Mundo de animacion | Ghibli |
| 51 | DRAMA | Mundo de drama/serie | Juego de Tronos |
| 52 | THEATER | Mundo teatral | Hamlet |
| 53 | FANFIC | Creacion de fans | Fanfiction |
| 54 | LEGEND | Leyenda | Rey Arturo |
| 55 | FAIRYTALE | Cuento de hadas | Cenicienta |

### Perspectiva/narrador (Perspective) -- Code 56~62

| Code | Tipo | Descripcion | Ejemplo |
|------|------|-------------|---------|
| 56 | NARRATOR | Perspectiva del narrador | Narrador omnisciente |
| 57 | PROTAGONIST | Perspectiva del protagonista | Punto de vista del heroe |
| 58 | ANTAGONIST | Perspectiva del antagonista | Punto de vista del villano |
| 59 | AUTHOR | Intencion del autor | Comentario del escritor |
| 60 | EXPERT | Opinion de experto | Opinion de academico |
| 61 | LAYMAN | Percepcion del publico general | Percepcion popular |
| 62 | SATIRICAL | Satira/ironia | Expresion ironica |

Code 0 es UNSPECIFIED (no especificado), Code 63 es EXTENDED (extension, reservado).

## Extension de metadatos

La informacion adicional sobre el Context (fuente, confiabilidad, nombre del mundo) se expresa mediante [Triple Edge](../triple-edge/).

```
(Context TID, P:source_entity, Reuters_Entity)  - Organizacion fuente
(Context TID, P:confidence, 0.95)               - Confiabilidad
(Context TID, P:universe_name, "Harry Potter")  - Nombre del mundo
(Context TID, P:perspective_holder, Villano_Entity)  - Sujeto de la perspectiva
```

## Ejemplos

### Fuente: "Segun Reuters"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple adquirio Tesla"

Triple adicionales:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### Ficcion: "Mundo de Harry Potter"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "Hogwarts es_un colegio"

Triple adicionales:
  (0x0302, P:universe_name, "Harry Potter")
  (0x0302, P:author, J.K. Rowling)
```

### Inferencia IA: "Claude infiere"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causa Y"

Triple adicionales:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## Fundamento del diseño

- **Context Edge como tipo independiente**: La cosmovision es una capa meta diferente de Triple/Clause. Corresponde al G (Graph) del RDF Quad.
- **6 bits de Context Type**: Permite clasificacion inmediata sin Triples separados. 62 tipos cubren la mayoria de los casos.
- **Estructura ligera de 3 palabras**: Las conexiones de Context se generan en masa, por lo que se asegura la eficiencia de almacenamiento con el tamano minimo.
