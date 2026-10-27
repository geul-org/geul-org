---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER es un Edge de afirmación que añade una condición que acota la proposición de otro Edge (sobre todo TRIPLE) (Codec 0x0B). En Value, en lugar de un valor se puede usar desconocido (UNKNOWN-VALUE) o sin valor (NO-VALUE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER es un Edge de afirmación que añade una condición que acota la proposición contenida en otro Edge (sobre todo [TRIPLE](/es/grammar/edge/triple/)). Codec `0x0B`.

Equivale a un qualifier (snak) de Wikidata: una propiedad y un valor.

## Layout

```
TAG WORD          0001 0LLL L000 1011
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Property          registro Reference (WIKIDATA-PID, etc.)
Target            registro Reference LOCAL (el Edge Id del Edge que se acota)
Value             registro Reference o Value, o marcador de posición 0x0001 UNKNOWN-VALUE · 0x0002 NO-VALUE
```

- El orden de los componentes es el mismo que en TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). El decodificador los lee por la misma vía. Los roles los fija el Codec.

## Interpretación y validez

- Property y Target son cada uno exactamente un registro Reference completo, y Target es un Reference LOCAL. El documento de especificación de geul.org pone en Target el [CODEC](/es/grammar/edge/codec/) LOCAL (`0008`). Value es exactamente un registro Reference o Value completo, o 1 WORD de [marcador de posición](/es/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) o `0x0002` (NO-VALUE). El documento de especificación pone en Value los CODEC `0780`, `0F80`, `0001`, `0002`. No acepta ABSENT (`0x0000`). Property y Target no aceptan marcadores de posición. El cursor tras leer Value debe coincidir con el final del Edge.
- Target es un Edge Id dentro del mismo documento. QUALIFIER se pone en el mismo documento que el Edge que acota.
- Si Target es el [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del HEAD (la fuente del documento entero), el QUALIFIER también va en el HEAD, después de ese SOURCE. Los demás QUALIFIER van en el BODY. Si un QUALIFIER que tiene como Target un SOURCE del HEAD está en el BODY, es invalid.
- Target puede ser otro Edge además de TRIPLE. Un QUALIFIER añadido a [SOURCE](/es/grammar/edge/source/) acota el acto de cita (fecha de consulta, posición dentro de la fuente, etc.). El significado de SOURCE también es el conjunto de todos los QUALIFIER que apuntan a él.
- **QUALIFIER es parte de la proposición.** No es una aserción aparte sobre la proposición, sino que acota las condiciones en que la proposición es verdadera. El significado del TRIPLE destino es el conjunto de todos los QUALIFIER que apuntan a él.
  - La procedencia de una proposición se escribe con [SOURCE](/es/grammar/edge/source/). Los atributos del nodo de la fuente (título, autor, etc.) se escriben con un TRIPLE que tenga la fuente como Subject.
- Un mismo Target puede tener varios QUALIFIER con la misma Property. El orden de los QUALIFIER de un mismo Target es el orden dentro del documento (excepción en que el orden de los Edge tiene significado).

## Desconocido y sin valor

Si el Value de QUALIFIER es un marcador de posición, cambia el sentido de esa acotación. Se toma como ejemplo el momento de fin (P582).

| Lo añadido al TRIPLE destino | Significado | ¿Sigue siendo una proposición vigente? |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | Terminó en 1974 | No |
| `QUALIFIER P582 #n UNKNOWN` | Terminó. No se sabe cuándo (`somevalue` de Wikidata) | No |
| `QUALIFIER P582 #n NONE` | Se afirma que no terminó (`novalue` de Wikidata) | Sí |
| Sin QUALIFIER P582 | No se sabe si terminó (mundo abierto) | Se desconoce |

- Si se descartan `somevalue` y `novalue` de los qualifier de Wikidata, la proposición se ensancha. Un TRIPLE de frontera al que se le descartó el somevalue del momento de fin se lee como "frontera aún vigente". Por eso, al trasladar, se pasan como marcadores.
- Dos UNKNOWN-VALUE no se consideran el mismo valor. El resultado de la comparación queda indeterminado.

## Ejemplo (no normativo)

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value es [EDTF](/es/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

Frontera (P47) entre Q30 (Estados Unidos) y Q34266 (Imperio ruso), con momento de fin desconocido. Edge Id `2060` y `3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge, 8 WORD, Codec `0x0B`. TAG 1 + Edge Id 2 + Property P582 (`00A8 0246`) 2 + Target #2060 (`0088 080C`) 2 + marcador 1.

Al TRIPLE NO-VALUE `#3161` del banco central (P1304) de Q30 se le añade un periodo. Solo faltó entre 1811 y 1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [TRIPLE](/es/grammar/edge/triple/), [SOURCE](/es/grammar/edge/source/), [WIKIDATA-PID](/es/grammar/reference/wikidata-pid/), [EDTF](/es/grammar/value/time/edtf/), [Marcador de posición](/es/grammar/reference/slot-marker/)
