---
title: "Triple Edge"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "Tipo de Edge que expresa relaciones y propiedades en formato (Subject, Property, Object). Estructura dual con modo básico de 4 palabras y modo extendido de 5 palabras que optimiza las Top 63 propiedades de alta frecuencia."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge es un tipo de Edge que expresa **relaciones/propiedades** en formato `(Subject, Property, Object)`.

## Diseño de modo dual

- **Modo básico (4 palabras):** PropCode 0~62 (Top 63 propiedades)
- **Modo extendido (5 palabras):** Si PropCode=63, cubre todo el P-ID (16 bits de alineación semántica)

## Modo básico (4 palabras = 64 bits)

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16 bits)
3rd WORD: Subject TID (16 bits)
4th WORD: Object TID (16 bits)
```

| Campo | Bits | Descripción |
|-------|------|-------------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 propiedades, 63: modo extendido |
| Edge TID | 16 | TID de este Edge |
| Subject TID | 16 | TID de Entity/Node sujeto |
| Object TID | 16 | TID de Entity/Node/Quantity objeto |

## Modo extendido (5 palabras = 80 bits)

Si PropCode es 63, se agrega un P-ID de 16 bits en la 3ra palabra.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 bits)
3rd WORD: P-ID alineación semántica (16 bits)
4th WORD: Subject TID (16 bits)
5th WORD: Object TID (16 bits)
```

## Top 63 propiedades (PropCode 0~62)

Propiedades seleccionadas según la frecuencia de uso en Wikidata.

### Clasificación/tipo (Code 0~7)

| Code | P-ID | Propiedad | Descripción |
|------|------|-----------|-------------|
| 0 | P31 | instance of | Instancia de ~ |
| 1 | P279 | subclass of | Subclase de ~ |
| 2 | P361 | part of | Parte de ~ |
| 3 | P527 | has part | Contiene ~ |
| 4 | P1552 | has quality | Propiedad/característica |
| 5 | P460 | same as | Igual |
| 6 | P1889 | different from | Diferente |
| 7 | P156 | followed by | Siguiente |

### Espacio/ubicación (Code 8~15)

| Code | P-ID | Propiedad | Descripción |
|------|------|-----------|-------------|
| 8 | P17 | country | País |
| 9 | P131 | located in | Ubicación (división administrativa) |
| 10 | P276 | location | Ubicación (lugar) |
| 11 | P625 | coordinate | Coordenadas |
| 12 | P30 | continent | Continente |
| 13 | P36 | capital | Capital |
| 14 | P150 | contains | Contiene (región) |
| 15 | P206 | located next to | Cuerpo de agua adyacente |

### Tiempo (Code 16~23)

| Code | P-ID | Propiedad | Descripción |
|------|------|-----------|-------------|
| 16 | P569 | date of birth | Fecha de nacimiento |
| 17 | P570 | date of death | Fecha de fallecimiento |
| 18 | P571 | inception | Fecha de fundación |
| 19 | P576 | dissolved | Fecha de disolución |
| 20 | P577 | publication date | Fecha de publicación |
| 21 | P580 | start time | Momento de inicio |
| 22 | P582 | end time | Momento de fin |
| 23 | P585 | point in time | Momento específico |

### Información personal (Code 24~31)

| Code | P-ID | Propiedad | Descripción |
|------|------|-----------|-------------|
| 24 | P19 | place of birth | Lugar de nacimiento |
| 25 | P20 | place of death | Lugar de fallecimiento |
| 26 | P21 | sex or gender | Sexo o género |
| 27 | P27 | citizenship | Ciudadanía |
| 28 | P735 | given name | Nombre de pila |
| 29 | P734 | family name | Apellido |
| 30 | P1559 | name in native language | Nombre nativo |
| 31 | P742 | pseudonym | Seudónimo |

### Relaciones/pertenencia (Code 32~39)

| Code | P-ID | Propiedad | Descripción |
|------|------|-----------|-------------|
| 32 | P22 | father | Padre |
| 33 | P25 | mother | Madre |
| 34 | P26 | spouse | Cónyuge |
| 35 | P40 | child | Hijo/a |
| 36 | P3373 | sibling | Hermano/a |
| 37 | P463 | member of | Miembro de |
| 38 | P108 | employer | Empleador |
| 39 | P1027 | conferred by | Otorgado por |

### Ocupación/actividad (Code 40~47)

| Code | P-ID | Propiedad | Descripción |
|------|------|-----------|-------------|
| 40 | P106 | occupation | Ocupación |
| 41 | P39 | position held | Cargo |
| 42 | P69 | educated at | Educación |
| 43 | P101 | field of work | Campo de trabajo |
| 44 | P1344 | participant in | Participación (evento) |
| 45 | P166 | award received | Premio recibido |
| 46 | P800 | notable work | Obra notable |
| 47 | P1412 | languages spoken | Idiomas hablados |

### Medios/identificación (Code 48~55)

| Code | P-ID | Propiedad | Descripción |
|------|------|-----------|-------------|
| 48 | P18 | image | Imagen |
| 49 | P154 | logo | Logo |
| 50 | P41 | flag image | Bandera |
| 51 | P373 | Commons category | Wikimedia |
| 52 | P856 | official website | Sitio web oficial |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### Obras/creación (Code 56~62)

| Code | P-ID | Propiedad | Descripción |
|------|------|-----------|-------------|
| 56 | P50 | author | Autor |
| 57 | P57 | director | Director |
| 58 | P86 | composer | Compositor |
| 59 | P175 | performer | Intérprete |
| 60 | P136 | genre | Género |
| 61 | P364 | original language | Idioma original |
| 62 | P123 | publisher | Editorial |

Code 63 está reservado como **indicador de modo extendido**.

## Resumen de PropCode

```
┌─────────────────────────────────────────────┐
│  0~7:   Clasificación/tipo (P31, P279, ...) │
│  8~15:  Espacio/ubicación (P17, P131, ...)  │
│  16~23: Tiempo (P569, P570, ...)            │
│  24~31: Info. personal (P19, P20, ...)      │
│  32~39: Relaciones/pertenencia (P22, P25, ..)│
│  40~47: Ocupación/actividad (P106, P39, ..) │
│  48~55: Medios/identificación (P18, P856, ..)│
│  56~62: Obras/creación (P50, P57, ...)      │
├─────────────────────────────────────────────┤
│  63: Indicador de modo extendido            │
└─────────────────────────────────────────────┘
```

## Ejemplos

### Modo básico: "Apple es una empresa"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - Empresa (Object)

Total: 4 palabras
```

### Modo extendido: "La altura de la Torre Eiffel es 330m"

```
P2048 (height) → Fuera del Top 63 → Modo extendido

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 alineación semántica
  4th: [TID: 0x0030]              - Torre Eiffel (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

Total: 5 palabras
```

## Análisis (parsing)

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # Modo básico (4 palabras)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # Modo extendido (5 palabras)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
