---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC ist ein Beschreibungs-Edge (Codec 0x1E), das ein Kind/Codec festlegt, das ein FIELD akzeptiert. Auch Wildcards und Slot-Marker (0x0000 nicht angegeben, 0x0001 unbekannt, 0x0002 kein Wert) werden damit deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC ist ein Beschreibungs-Edge, das ein Kind/Codec festlegt, das ein [FIELD](/de/grammar/edge/field/) akzeptiert. Codec `0x1E`.

So wie [ENUM](/de/grammar/edge/enum/) einem Codewert eines Rohwert-Feldes eine Bedeutung gibt, hängt CODEC dem Feld ein Format an. Da es je Edge eines ist, lassen sich mehrere festlegen. Das Layout ist im Decoder eingebaut ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1110
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Feld              LOCAL-Reference-Record, der auf ein FIELD-Edge verweist
Ziel              1 WORD. 000K KLLL LCCC CCCC (LLLL = 0000 exakt, 1111 Wildcard)
```

## Ziel-WORD

- Die Stellen für Kind (`KK`) und Codec (`CCCCCCC`) des TAG WORD werden unverändert übernommen. Die oberen 3 Bit sind 0. `LLLL` ist `0000` (exakt) oder `1111` (Wildcard), andere Werte sind invalid.
- Ein exaktes Ziel (`LLLL = 0000`) hat denselben Wert wie die ID des Codec-Spezifikationsdokuments (z. B. LOCAL `0x0008`, COORDINATE-EARTH `0x0804`, UTF8-LANGUAGE-TEXT `0x084A`). Das Ziel verweist also zugleich auf das Spezifikationsdokument dieses Codecs.
- Auch gerade/ungerade Codepaare (Text, Bytefolge) werden mit exakten Codes festgelegt. Um gerade wie ungerade zu akzeptieren, setzt man beide. Eine Regel, Paare zusammen zu interpretieren, gibt es nicht (es gibt benachbarte Codes, die kein Paar sind, wie NUMERIC `0x04`/`0x05`).

### Wildcard (`LLLL = 1111`)

- Das Kind muss gleich sein, und **eine Codec-Bitgruppe, die 0 ist, passt auf alles**. Bei Reference sind `CCCC` (Codec) und `QQQ` (Quantifier) getrennte Gruppen, bei den anderen Kinds sind alle 7 Bit eine Gruppe.

| Ziel | Bedeutung |
|---|---|
| `0780` | beliebiges Reference |
| `07A0` | WIKIDATA-QID, unabhängig vom Quantifier |
| `0781` | beliebiger Reference-Codec, Quantifier Generic (`001`) |
| `0F80` | beliebiger Value |
| `1780`, `1F80` | beliebiger Edge, beliebiges Meta |

- Eine Wildcard, die nichts abgleichen kann, ist invalid. Bei Value, Edge und Meta muss der Codec 0 sein, bei Reference muss `CCCC` oder `QQQ` 0 sein. Der Reference-`CCCC = 0000` (Slot-Marker) ist ein reservierter Codec und **passt auf keine Wildcard** (`0780` akzeptiert weder ABSENT noch UNKNOWN-VALUE noch NO-VALUE). Bei Kinds, deren Codec 0 vergeben ist, wie Value `0x00` (BOOL) und Edge `0x00` (REFERENCE-NODE), schließt die Wildcard dagegen diese ein (um nur BOOL zu akzeptieren, verwendet man `LLLL = 0000`).
- Eine Wildcard verweist nicht auf ein Spezifikationsdokument.
- Einen Ausdruck, der nur eine nicht-0-Gruppe festlegt und die 0-Gruppe fixiert, wie „beliebiges Reference nur mit Identified“, gibt es nicht. Solche Listen zählen die exakten Ziele auf.
- Die 7 Codec-Bit eines Reference enthalten den Quantifier (`QQQ`). Das Ziel legt auch den Quantifier exakt fest. Um mehrere Quantifier zu akzeptieren, setzt man mehrere CODEC.

### Slot-Marker (Ziel `0000`~`0002`)

[Slot-Marker](/de/grammar/reference/slot-marker/) sind eine Gruppe von 1-WORD-Records des reservierten Reference-Codecs `0000`. Die unteren 3 Bit sind die Markernummer (nicht der Quantifier).

| Ziel | Marker | Bedeutung |
|---|---|---|
| `0000` | ABSENT | Nicht angegeben. Dieses Feld ist ein optionales Feld |
| `0001` | UNKNOWN-VALUE | Unbekannt. Akzeptiert die Behauptung, dass es einen Wert gibt |
| `0002` | NO-VALUE | Kein Wert. Akzeptiert die Behauptung, dass es keinen Wert gibt |
| `0003`~`0007` | Reserviert | |

- **Akzeptanzregel:** Ein Marker ist nur gültig, wenn dasselbe WORD in der CODEC-Liste des Feldes als exaktes Ziel steht. Wildcards und Record-Felder ohne CODEC („beliebiger Record“) akzeptieren keine Marker. Ein Marker an Stellen für HEAD-/BODY-Records und für Edge Ids ist invalid.
- Eine Liste, die nur Marker-Ziele enthält (immer ein Marker), ist invalid (Verallgemeinerung der Regel für eine Liste nur mit `0000`). Man verwendet sie zusammen mit einer Wildcard oder einem exakten Ziel (`0780` + `0000` = beliebiges Reference oder ausgelassen).
- Bei Rohwert-Feldern kann man keine Marker-Ziele setzen. Ein Rohwert hat kein TAG und eine feste Breite, daher gibt es keine Stelle für einen 1-WORD-Marker.
- Was ein Marker bedeutet, legt die Spezifikation des Codecs fest, der ihn akzeptiert.

### Optionale Felder (Ziel `0000`)

- Setzt man in der CODEC-Liste eines Record-Feldes das Ziel `0000`, ist dieses Feld ein **optionales Feld**. Wird es ausgelassen, schreibt man an dessen Stelle 1 WORD `0x0000`. Dieser 1-WORD-Record ist der Slot-Marker ABSENT (nicht angegeben).
- `0x0000` ist Reference-Codec `0000` (reserviert), Markernummer `000`, `LLLL = 0000` (insgesamt 1 WORD). Er überschneidet sich nicht mit anderen Records, und auch ein Decoder, der die Spezifikation nicht kennt, überspringt ihn als 1-WORD-Record.
- Auch ein optionales Feld belegt immer seine Stelle. Bei Auslassung schreibt man stets `0x0000` und lässt die Stelle nicht frei (auch bei hinteren Feldern). Dadurch hat jeder Record genau eine Schreibweise, und die Zerlegung ergibt sich allein aus der Position. Für Position und Anzahl optionaler Felder und für Überschneidungen der Listen mit anderen Feldern gibt es keine Einschränkung.
- ABSENT ist nur an der Stelle eines optionalen Feldes gültig. Ein `0x0000` an Stellen für HEAD-/BODY-Records, an Pflichtfeldern und an Stellen für Edge Ids ist invalid.
- Auslassen bedeutet nicht „kein Wert“, sondern „nicht angegeben“. Es wird nichts über die Welt behauptet. „Es gibt keinen Wert“ schreibt man mit NO-VALUE (`0002`). Was eine Auslassung bedeutet (z. B. wenn das Ziel von TAG fehlt, diese Version), legt die Spezifikation jedes Formats fest.

## Interpretation und Gültigkeit

- Das Feld ist ein FIELD-Edge desselben Dokuments. Dasselbe Ziel wird bei einem Feld nicht zweimal gesetzt.
- **Record-Feld (Breite 0)**: Ohne CODEC akzeptiert es jeden Record außer Slot-Markern. Mit einem oder mehreren CODEC ist es eine geschlossene Liste. Kind und Codec des Records dieses Feldes (bei Reference einschließlich Quantifier) müssen einer aus der Liste sein, sonst folgt dieser Record nicht der Spezifikation. Das unterscheidet sich von ENUM, einer offenen Liste.
- **Rohwert-Feld (Breite n ≥ 1 oder restlich `0xFFFF`)**: Bei CODEC steht nur ein exaktes Ziel (keine Wildcard). Dieser Rohwert ist der Payload dieses Value ohne TAG. Kind und Codec gibt CODEC, die Length gibt die Breite des FIELD. Bei geraden/ungeraden Codes bestimmt der angegebene Code die Parität der Bytezahl. Folgt der Rohwert nicht den Regeln dieses Value (einschließlich Länge), folgt der Record nicht der Spezifikation.
- Slot-Marker werden nur mit exakten Zielen der Liste abgeglichen. Steht an der Stelle eines optionalen Feldes (Ziel `0000`) `0x0000`, ist es eine Auslassung. Alle anderen Records werden mit der Liste ohne Marker-Ziele abgeglichen.
- Bei einem Rohwert-Feld können CODEC und ENUM zusammen stehen. CODEC ist das Format, ENUM der Name der Codewerte (z. B. rank als UNSIGNED-INTEGER und 0, 1, 2 als ENUM).
- An die Edge Id von CODEC kann man per BIND einen Namen hängen, das ist aber nicht verpflichtend.
- Ein Feld „Reference oder Value“ schreibt man mit zwei CODEC (`0780`, `0F80`).

## Länge

```
Gesamt = 1 + N_len + N_id + N_field + 1 WORD   (6 WORD, wenn Edge Id und Feld ein LOCAL mit 1 WORD ID sind)
```

## Beispiel

Im Spezifikationsdokument `geul.org/label` von LABEL akzeptiert das Object-Feld (FIELD #3) UTF8-LANGUAGE-TEXT (gerade/ungerade) und LOCAL. Edge Ids 7~9.

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E` (Edge, Codec `0x1E`, `LLLL = 0101`, 6 WORD), Edge Id `0088 0007`, Feld `0088 0003`, Ziel `084A`.

## Verwandte Seiten

- [FIELD](/de/grammar/edge/field/), [ENUM](/de/grammar/edge/enum/), [DECLARE](/de/grammar/edge/declare/), [BIND](/de/grammar/edge/bind/)
- [Codec-Spezifikationsdokument](/de/grammar/codec-spec/), [LABEL](/de/grammar/edge/label/)
