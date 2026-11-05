---
title: "Ejemplo: un elemento de Wikidata"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Lectura de principio a fin de un documento pequeño sobre el elemento Q42 (Douglas Adams) de Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Leamos de principio a fin un documento pequeño sobre el elemento Q42 (Douglas Adams) de Wikidata. Su contenido es el siguiente.

- Nombre en inglés: Douglas Adams
- Q42 es una instancia de persona (Q5) (P31).
- Q42 se educó en St John's College (Q691283) (P69). El momento de inicio (P580) es 1971.

El documento es el documento `0x510000000000002A` del Issuer `0x00000001`, y ocupa 63 WORD en total (126 bytes).

## Completo {#전체}

```
1C01 003F 1C51 0001 1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
1C30
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
1C40
```

## HEAD {#head}

```
1C01 003F
```

`1C01` es Meta (sección 14), Codec `0x1C0L` (DOC-1WORD), Length de 2 WORD. El valor `003F` (63) es el número total de WORD del documento. El decodificador conoce así de antemano el final del documento.

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION. Es la edición de la especificación que sigue este documento. v1 es `0001`.

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID, 10 WORD en total. El Payload es una Reference DOC-POINTER.

| WORD | Significado |
|---|---|
| `0418` | Reference, Codec `0x041L` (DOC-POINTER), 9 WORD |
| `0000 0001` | Issuer `0x00000001` (2 WORD) |
| `5100 0000 0000 002A` | ID del documento `0x510000000000002A` |
| `0000 0000` | Versión `0` (la propia) |

```
1C30
```

BODY. Termina el HEAD y empieza el BODY.

## BODY {#body}

### #1 LABEL — nombre en inglés {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | Significado |
|---|---|
| `0A4E` | Edge, Codec `0x0A4L` LABEL, Length `1110` (extendido) |
| `0010` | Longitud extendida: 16 WORD en total |
| `0051 0001` | Edge Id: LOCAL 1 |
| `0141 002A` | Subject: Q42 de Wikidata |
| `0799` | Object: UTF8-LANGUAGE-TEXT, número impar de bytes (`0x079L`), 10 WORD |
| `0761 656E` | Idioma: BCP 47 `en` |
| `446F … 7300` | `Douglas Adams` 13 bytes + relleno `00` |

### #2 TRIPLE — Q42 es una persona {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | Significado |
|---|---|
| `0AA9` | Edge, Codec `0x0AAL` TRIPLE, 10 WORD |
| `0051 0002` | Edge Id: LOCAL 2 |
| `0191 001F` | Predicate: P31 (instance of) |
| `0141 002A` | Subject: Q42 |
| `0141 0005` | Object: Q5 (persona) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 se educó en St John's College {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | Significado |
|---|---|
| `0AAA` | Edge, TRIPLE, 11 WORD |
| `0051 0003` | Edge Id: LOCAL 3 |
| `0191 0045` | Predicate: P69 (educated at) |
| `0141 002A` | Subject: Q42 |
| `0142 000A 8C53` | Object: Q691283. El valor excede los 16 bits, así que es una Reference de 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — momento de inicio, 1971 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | Significado |
|---|---|
| `0AB9` | Edge, Codec `0x0ABL` QUALIFIER, 10 WORD |
| `0051 0004` | Edge Id: LOCAL 4 |
| `0191 0244` | Property: P580 (start time) |
| `0051 0003` | Target: #3 (el TRIPLE anterior) |
| `06E2 3139 3731` | Value: EDTF `1971` (con precisión de año, se usa EDTF y no GREGORIAN-DATE) |

El significado de #3 es la suma de #3 mismo y de todos los QUALIFIER que apuntan a él: «Q42 se educó en St John's College desde 1971.»

```
1C40
```

END. Hasta aquí son 63 WORD.

## Lectura sin codebook {#코덱북-없이-읽으면}

Un decodificador que no conozca el codebook también sabe lo siguiente.

- El documento tiene 63 WORD, con 2 Meta en el HEAD y 4 Edge en el BODY.
- El Codec de cada Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) y su Edge Id (1, 2, 3, 4).
- La posición del siguiente registro de cada registro.

El papel de los componentes (Predicate, Subject, Object, Rank) solo se sabe leyendo el [documento de especificación](codec-spec.md) de cada Codec.

## Hash de contenido {#내용-해시}

El hash de contenido (SHA-256) de este documento es el siguiente. Al publicarlo, este hash queda registrado en la lista de versiones junto con el ID de versión.

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
