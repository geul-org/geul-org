---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM ist ein Beschreibungs-Edge (Codec 0x1D), das einem Codewert eines Rohwert-Feldes eine Bedeutung gibt. Der Name wird per BIND gebunden."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM ist ein Beschreibungs-Edge, das einem Codewert eines Rohwert-Feldes eine Bedeutung gibt. Codec `0x1D`.

Zusammen mit [FIELD](/de/grammar/edge/field/) ist es das Vokabular zum Schreiben von Codec-Spezifikationen. Das Layout ist im Decoder eingebaut ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1101
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Feld              LOCAL-Reference-Record, der auf ein FIELD-Edge verweist
Codewert          Rohwert. So viele WORD wie die Breite dieses FIELD
```

## Interpretation und Gültigkeit

- Das Feld muss ein Rohwert-FIELD sein (Breite `n ≥ 1`). An Record-Felder wird kein ENUM angehängt. Die Bedeutung eines Records sagt der Codec dieses Records.
- Der Codewert hat genau die Breite dieses FIELD. Die Grenze prüft man über die Length des ENUM-Records.
- Derselbe Codewert wird in einem Feld nicht zweimal deklariert.
- Der Name des Codewerts wird per [BIND](/de/grammar/edge/bind/) an die Edge Id des ENUM gebunden. UTF8-TEXT für DECLARE, FIELD, ENUM und CODEC wird stets per BIND angehängt, nicht über LABEL oder andere Edges.
- Ein nicht deklarierter Codewert ist kein Fehler. Der Viewer zeigt den Rohwert unverändert an. Ob die zulässigen Werte geschlossen werden, ist Sache der Codec-Spezifikation; im jetzigen Vokabular gibt es keine Kennzeichnung zum Schließen.

## Länge

```
Gesamt = 1 + N_len + N_id + N_field + n WORD
```

## Beispiel (nicht normativ)

Im Rohwert-Feld Begründungskategorie (FIELD #4, Rohwert 1 WORD) des Spezifikationsdokuments von TOMBSTONE wird der Code `0x0001` deklariert. Edge Id 10. Der Name wird gesondert per BIND gebunden. Die Codetabelle der Begründungskategorie steht noch nicht fest, daher ist der Codewert ein Beispiel.

- TAG 1 + Edge Id 2 + Feld 2 + Codewert 1 = 6 WORD, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

Das Spezifikationsdokument von TRIPLE setzt beim Rank-Feld (FIELD #5) drei ENUM (`0`, `1`, `2`) und bindet sie per BIND an `normal`, `preferred` und `deprecated` ([TRIPLE](/de/grammar/edge/triple/)).

## Verwandte Seiten

- [DECLARE](/de/grammar/edge/declare/), [FIELD](/de/grammar/edge/field/), [CODEC](/de/grammar/edge/codec/), [BIND](/de/grammar/edge/bind/)
- [Codec-Spezifikationsdokument](/de/grammar/codec-spec/)
