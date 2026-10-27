---
title: "Ejemplo: un elemento de Wikidata"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Se lee de principio a fin un documento GEUL de 63 WORD que contiene un nombre, dos proposiciones y una condición acotadora de Q42 (Douglas Adams) de Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Leamos de principio a fin un pequeño documento sobre el elemento Q42 (Douglas Adams) de Wikidata. Contiene lo siguiente.

- Nombre en inglés: Douglas Adams
- Q42 es una instancia de persona (Q5) (P31).
- Q42 se educó en St John's College (Q691283) (P69). El momento de inicio (P580) es 1971.

El documento es del Issuer `0x00010000`, tiene el ID de documento `0x510000000000002a` y ocupa 63 WORD en total (126 bytes).

## Completo

```
1880 003f 1890 0001 1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
180e
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
180f
```

## HEAD

```
1880 003f
```

`1880` es Meta (`11`), Length de 2 WORD, Codec `0x00` (DOC-1WORD). El valor `003f` (63) es el número total de WORD del documento. El decodificador conoce el final del documento de antemano gracias a este valor.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. Es la versión de la especificación que sigue este documento. En v1 es `0001`.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID, 10 WORD en total. El Payload es un único Reference DOC-POINTER.

| WORD | Significado |
|---|---|
| `0438` | Reference, 9 WORD, Codec `0111` (DOC-POINTER), Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | ID de documento `0x510000000000002a` |
| `0000 0000` | Versión `0` (a sí mismo) |

```
180e
```

BODY. Termina el HEAD y comienza el BODY.

## BODY

### #1 LABEL — nombre en inglés

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | Significado |
|---|---|
| `1704` | Edge, Length `1110` (extendido), Codec `0x04` LABEL |
| `0010` | Longitud extendida: 16 WORD en total |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: Q42 de Wikidata |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT, 10 WORD, número impar de bytes (`0x4B`) |
| `08c6 656e` | Idioma: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13 bytes + relleno `00` |

### #2 TRIPLE — Q42 es una persona

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | Significado |
|---|---|
| `148a` | Edge, 10 WORD, Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (persona) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 se educó en St John's College

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | Significado |
|---|---|
| `150a` | Edge, 11 WORD, TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283. El valor supera los 16 bits, por lo que es un Reference de 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — momento de inicio, 1971

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | Significado |
|---|---|
| `148b` | Edge, 10 WORD, Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (el TRIPLE de arriba) |
| `0924 3139 3731` | Value: EDTF `1971` (precisión de año, así que es EDTF y no GREGORIAN-DATE) |

El significado de #3 es la suma de #3 mismo y de todos los QUALIFIER que apuntan a #3: "Q42 se educó en St John's College desde 1971."

```
180f
```

END. Hasta aquí son 63 WORD.

## Leído sin libro de códigos

Un decodificador que no conozca el libro de códigos también sabe lo siguiente.

- El documento tiene 63 WORD, con 2 Meta en el HEAD y 4 Edge en el BODY.
- El Codec de cada Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) y su Edge Id (1, 2, 3, 4).
- La posición del siguiente registro de cada registro.

El rol de los componentes (Predicate, Subject, Object, Rank) solo se conoce leyendo el [documento de especificación](/es/grammar/codec-spec/) de cada Codec.

## Hash de contenido

El hash de contenido (SHA-256) de este documento es el siguiente. Al publicarlo, este hash se registra en la lista de versiones junto con el ID de versión.

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
