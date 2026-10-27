---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE es un Edge de afirmación que contiene una proposición (Predicate, Subject, Object) y su grado (rank) (Codec 0x0A). En Object, en lugar de un valor se puede usar desconocido (UNKNOWN-VALUE) o sin valor (NO-VALUE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE es un Edge de afirmación que contiene una proposición (Predicate, Subject, Object) y su grado (rank). Codec `0x0A`.

Las condiciones que acotan la proposición (momento de inicio y fin, ámbito de aplicación, etc.) se añaden con un [QUALIFIER](/es/grammar/edge/qualifier/) que apunta al Edge Id del TRIPLE. La procedencia (las references de Wikidata) se añade con el Edge de fundamento [SOURCE](/es/grammar/edge/source/) que apunta al Edge Id del TRIPLE.

## Layout

```
TAG WORD          0001 0LLL L000 1010
[TAG de extensión de Length]
Edge Id           registro Reference LOCAL
Predicate         registro Reference (WIKIDATA-PID, etc.)
Subject           registro Reference
Object            registro Reference o Value, o marcador de posición 0x0001 UNKNOWN-VALUE · 0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| Código | Nombre | Significado |
|---|---|---|
| `0` | normal | Por defecto |
| `1` | preferred | Valor actual, el más autorizado |
| `2` | deprecated | Valor que se juzgó erróneo u obsoleto pero se conserva como registro |

- Es igual al statement rank de Wikidata. El valor representativo (truthy de Wikidata) es, entre los de un mismo Subject y Predicate, el preferred si lo hay y, si no, el normal.
- Las fuentes que no asignan rank usan `0` (normal).
- Cualquier otro código es invalid.

## Interpretación y validez

- Predicate y Subject son cada uno exactamente un registro Reference completo.
- Object es exactamente un registro Reference o Value completo, o 1 WORD de [marcador de posición](/es/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) o `0x0002` (NO-VALUE). No acepta ABSENT (`0x0000`). Object no es un campo opcional.
- Tras leer Object debe quedar exactamente 1 WORD (Rank).
- El documento de especificación de geul.org pone en el campo de valor en bruto Rank el [CODEC](/es/grammar/edge/codec/) UNSIGNED-INTEGER (`0802`) y el [ENUM](/es/grammar/edge/enum/) 0·1·2. En el campo Object pone los CODEC `0780` (cualquier Reference), `0F80` (cualquier Value), `0001` (UNKNOWN-VALUE) y `0002` (NO-VALUE). Predicate y Subject no aceptan marcadores de posición.
- **El significado de un TRIPLE es la suma de todos los QUALIFIER que apuntan a su Edge Id en el mismo documento.** Quien lee reúne los QUALIFIER antes de interpretar el TRIPLE. Un TRIPLE leído sin QUALIFIER puede ser una proposición a la que le falta la acotación (ejemplo: "jefe del ejecutivo" sin la acotación temporal).

## Desconocido y sin valor

Un marcador de posición en la posición de Object no es un valor sino una aserción sobre la proposición.

| Object | Significado | Lógica |
|---|---|---|
| Valor v | Uno de los valores del Predicate del Subject es v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | Hay un valor. Se ignora cuál (`somevalue` de Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | No hay valor (`novalue` de Wikidata) | `¬∃x. P(s, x)` |
| Sin TRIPLE | No se afirma nada (mundo abierto) | |

- **Se lee dentro de las condiciones que acotan.** El alcance de `∃` y `¬∃` lo fijan los QUALIFIER que apuntan a ese TRIPLE. Si se añade un QUALIFIER, solo se cierra dentro de ese alcance. "Entre 1811 y 1816 no hubo banco central" se escribe añadiendo QUALIFIER P580·P582 a un TRIPLE NO-VALUE. No contradice los TRIPLE de valor del mismo Predicate de otras épocas.
- **El rank se aplica igual.** Al elegir el valor representativo (truthy), los TRIPLE UNKNOWN-VALUE y NO-VALUE también son candidatos. Si hay un preferred, solo queda el preferred.
- **Dos UNKNOWN-VALUE no son iguales.** UNKNOWN-VALUE no es igual ni distinto de ningún valor (el resultado de la comparación es indeterminado), y dos UNKNOWN-VALUE tampoco se consideran el mismo valor. Es una cuantificación existencial independiente en cada aparición. Por eso, dos TRIPLE UNKNOWN-VALUE con los mismos bytes no son duplicados y no se fusionan (puede haber dos hijos o uno solo).
- Si, con el mismo Subject, Predicate y rank, coexisten un TRIPLE NO-VALUE y un TRIPLE de valor (o UNKNOWN-VALUE) sin que se distingan las condiciones acotadoras, hay contradicción. El verificador avisa. No rechaza (es un estado que también existe en Wikidata).
- Un valor que no se pudo trasladar (el material de origen sí tiene valor) no se escribe como UNKNOWN-VALUE.

## Ejemplo (no normativo)

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. El TAG es `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (Estados Unidos) P1304 (banco central) NO-VALUE, normal. Entre 1811 y 1816 no hubo banco central (los QUALIFIER P580·P582 están en el ejemplo de [QUALIFIER](/es/grammar/edge/qualifier/)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. El TAG es `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "Sin hijos (P40)" es `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Problemas abiertos

- scope (contexto de la aserción: mundo, punto de vista): se fijará cuando haya usos.
- Forma abreviada que pliega TRIPLE y QUALIFIER en un solo registro: después de que exista la declaración de campos repetidos (problema abierto de [DECLARE](/es/grammar/edge/declare/)).

## Páginas relacionadas

- [Edge](/es/grammar/edge/), [QUALIFIER](/es/grammar/edge/qualifier/), [SOURCE](/es/grammar/edge/source/), [LABEL](/es/grammar/edge/label/), [ALIAS](/es/grammar/edge/alias/), [Marcador de posición](/es/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/es/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/)
