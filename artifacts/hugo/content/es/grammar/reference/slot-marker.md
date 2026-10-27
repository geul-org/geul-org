---
title: "Marcador de posición"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "Los marcadores de posición son un conjunto de registros de 1 WORD del Codec de Reference reservado 0000. 0x0000 ABSENT (no declarado), 0x0001 UNKNOWN-VALUE (desconocido) y 0x0002 NO-VALUE (sin valor) rellenan la posición de un campo del registro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Un marcador de posición (slot marker) es un registro de 1 WORD que rellena la posición de un campo del registro. No apunta a nada. Está en el Codec de Reference reservado `0000`.

En la posición de un valor se pueden decir tres cosas. No se ha escrito el valor, hay un valor pero se ignora cuál, no hay valor. Las tres son distintas. Los marcadores de posición las separan en tres WORD contiguos.

## Layout

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = número de marcador
```

| WORD | Nombre | Significado | Notación |
|---|---|---|---|
| `0x0000` | ABSENT | No declarado | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | Desconocido: hay un valor. Se ignora cuál | `UNKNOWN` |
| `0x0002` | NO-VALUE | Sin valor: no hay valor | `NONE` |
| `0x0003`~`0x0007` | Reservado | | |
| CCCC `0000`, LLLL ≥ `0001` | Reservado | Los marcadores con Payload se fijarán más adelante | |

- Los 3 bits inferiores `MMM` son el **número de marcador, no un Quantifier**. Solo coinciden en el nombre con el `QQQ` de los demás Codec de Reference y su sentido no se corresponde (excepción de Quantifier en [Reference](/es/grammar/reference/)).
- No tiene Payload. Tampoco ID de destino.
- Un decodificador sin libro de códigos sabe solo por el TAG WORD que es Kind Reference y de 1 WORD, y lo salta. Saber que "si el valor del WORD es `0`~`7`, es un marcador de posición" requiere una sola comprobación de bits (`w & 0xFFF8 == 0`).
- La notación `ABSENT`, `UNKNOWN` y `NONE` es la notación de texto de `geul show` y `geul add`.

## Tres distinciones

| | No declarado (ABSENT) | Desconocido (UNKNOWN-VALUE) | Sin valor (NO-VALUE) |
|---|---|---|---|
| Sobre qué habla | **Documento**: no se rellenó esta posición | **Mundo**: hay un valor. Se ignora cuál | **Mundo**: no hay valor |
| Lógica | No afirma nada | `∃x. P(s, x)`, x no identificado | `¬∃x. P(s, x)` |
| Supuesto de mundo | Mundo abierto (sin información) | Existencia cerrada, identidad abierta | Mundo cerrado para (s, P, condiciones que acotan) |
| Wikidata | No hay ese snak | `somevalue` | `novalue` |
| Dónde se usa | Campo opcional que tiene el destino CODEC `0000` (Origin de SOURCE, etc.) | Campo que tiene el destino CODEC `0001` (Object de TRIPLE, Value de QUALIFIER, Origin de SOURCE) | Campo que tiene el destino CODEC `0002` (Object de TRIPLE, Value de QUALIFIER) |
| "¿Cuántos hijos (P40)?" | Se desconoce | Uno o más | 0 |
| "¿Hay momento de fin (P582)?" | Se desconoce → no se sabe si sigue vigente | Terminó. No se sabe cuándo | No terminó (aserción) |

La misma distinción rige también a nivel de proposición. **Que el TRIPLE no esté en el documento** es no declarado. Los documentos GEUL son de mundo abierto, así que la ausencia de una afirmación no significa que el hecho no exista. "No hay" solo se puede decir **escribiéndolo** como NO-VALUE.

## Reglas de aceptación

- Un marcador de posición es válido **solo cuando el mismo WORD figura como destino exacto** en la lista [CODEC](/es/grammar/edge/codec/) de ese campo. El destino `0000` significa "campo opcional", `0001` "acepta desconocido" y `0002` "acepta sin valor".
- Los comodines (`0780`, `0781`, `0F80`, etc.) no aceptan marcadores. El comodín de Reference tampoco se solapa con el Codec `0000`.
- Los campos de registro sin CODEC ("cualquier registro") tampoco aceptan marcadores.
- Un marcador en la posición de registro de HEAD·BODY o en la posición de Edge Id es invalid.
- En los campos de valor en bruto no se pueden usar marcadores. Un valor en bruto no tiene TAG y no hay lugar para un marcador de 1 WORD.
- Una lista CODEC que solo tenga destinos de marcador (siempre marcador) es invalid.
- El significado del marcador (qué hay y qué no hay) lo fija la especificación del Edge que lo acepta. Es el mismo principio de que la cuantificación y la negación las fija el Edge y no el Reference.
- Los marcadores de posición no tienen documento de especificación de Codec. Son de la [capa 0](/es/grammar/publishing/#capas) (incorporados en el decodificador). El destino Reference de DECLARE deja en 0 la posición del Quantifier, así que no se puede crear un documento de especificación para `0x0001`·`0x0002`, y como los tres carecen de Payload, incorporarlos no cuesta nada.

## Obligaciones de quien lee

1. **UNKNOWN-VALUE no es un valor sino una aserción de existencia.** No es igual a ningún otro valor ni distinto de él (el resultado de la comparación es indeterminado). Dos UNKNOWN-VALUE tampoco se consideran el mismo valor. Es una cuantificación existencial independiente en cada aparición (igual que un nodo en blanco de Wikidata).
   - Por eso, dos TRIPLE con los mismos bytes (`P40 Q… UNKNOWN` ×2) no son duplicados. Puede haber dos hijos o uno solo. Los TRIPLE que contienen UNKNOWN-VALUE no se fusionan como duplicados.
   - Si más tarde se descubre la identidad, se emite una nueva versión con ese TRIPLE corregido. A UNKNOWN-VALUE no se puede apuntar. Si hace falta correferencia, se usa una Variable LOCAL (Variable de [Reference](/es/grammar/reference/)).
2. **NO-VALUE se cierra dentro de las condiciones que acotan esa proposición.** Si se añade un QUALIFIER, solo se cierra dentro de ese alcance. Q30 P1304 NO-VALUE (P580 1811, P582 1816) significa que solo entre 1811 y 1816 no hubo banco central, y no contradice un TRIPLE de valor de la misma propiedad (Reserva Federal, preferred).
   - Si, con el mismo Subject y Predicate, coexisten un TRIPLE NO-VALUE y un TRIPLE de valor con el mismo rank sin que se distingan las condiciones acotadoras, hay contradicción. El verificador emite un aviso. No rechaza. Es un estado que también existe en Wikidata, y quien lee elige por rank.
3. **El rank se aplica igual.** Al elegir el valor representativo (truthy), los TRIPLE UNKNOWN-VALUE y NO-VALUE también son candidatos. Si hay un preferred, solo queda el preferred.
4. **Si se usa como valor de un QUALIFIER, cambia el sentido de esa acotación.** Con `P582 = UNKNOWN`, terminó y no se sabe cuándo. No se lee como una proposición aún vigente. Con `P582 = NONE`, se afirma que no terminó. Si no hay ningún QUALIFIER P582, no se sabe si terminó.
5. **ABSENT no dice nada sobre el mundo.** No se lee como UNKNOWN-VALUE ni como NO-VALUE. A la inversa, se prohíbe que un conversor escriba como UNKNOWN-VALUE un valor que no pudo trasladar (un valor que el material de origen sí tiene), porque en el origen sí se conoce el valor. Para una posición que el origen no dice (ejemplo: el Origin de un [SOURCE](/es/grammar/edge/source/) de una procedencia que no describe la fuente), el conversor también escribe ABSENT. UNKNOWN-VALUE es la aserción de que "hay", así que solo se usa cuando el origen lo dice.

## Diferencia con otras «ausencias»

- La regla de un Codec que usa [LOCAL](/es/grammar/reference/local/) `0` como «ausencia» (REF de [TOULMIN](/es/grammar/edge/toulmin/), etc.) es un acuerdo interno de ese Codec. Es distinta de los marcadores de posición.
- Un LOCAL Identified no se usa como null ni como sentinel. Para anotar lo desconocido o lo ausente se usa un marcador en un campo que acepte marcadores.

## Ejemplo

Frontera entre Q30 (Estados Unidos) y Q34266 (Imperio ruso), con el momento de fin desconocido. Los Edge Id son ilustrativos.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Banco central de Q30: no existió entre 1811 y 1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- La posición del marcador es de 1 WORD. El TRIPLE pasa a 9 WORD (`140A`) y el QUALIFIER a 8 WORD (`138B`).
- En su forma sencilla, "sin hijos (P40)" es `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Páginas relacionadas

- [Reference](/es/grammar/reference/), [CODEC](/es/grammar/edge/codec/), [Documento de especificación de Codec](/es/grammar/codec-spec/)
- [TRIPLE](/es/grammar/edge/triple/), [QUALIFIER](/es/grammar/edge/qualifier/), [TOULMIN](/es/grammar/edge/toulmin/)
