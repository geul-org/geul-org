---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD ist ein Beschreibungs-Edge (Codec 0x1C), das ein Feld des Codec-Payloads deklariert. Es hält das zugehörige DECLARE und die Breite fest (Record, Rohwert n WORD, restlicher Rohwert)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD ist ein Beschreibungs-Edge, das ein Feld des Codec-Payloads deklariert. Codec `0x1C`.

Das FIELD verweist auf sein [DECLARE](/de/grammar/edge/declare/). Die FIELDs, die auf dasselbe DECLARE verweisen, bauen den Payload in der Reihenfolge im Dokument auf. Das Layout ist im Decoder eingebaut ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1100
Edge Id           LOCAL-Reference-Record
DECLARE           LOCAL-Reference-Record. Das DECLARE-Edge, zu dem dieses Feld gehört
Breite            1 WORD. 0 = Record, n (1~65534) = Rohwert n WORD, 0xFFFF = restlicher Rohwert
```

## Interpretation und Gültigkeit

- Das DECLARE verweist auf ein DECLARE-Edge desselben Dokuments. Ein FIELD gehört nur zu einem DECLARE. Eine Reihenfolge wird nicht eigens angegeben; es ist die Reihenfolge, in der die FIELD-Records im Dokument stehen.
- Das Spezifikationsdokument von FIELD deklariert DECLARE als Feld der Breite `0` (Record) mit CODEC `0008` (LOCAL). Deshalb wird es im Viewer-Graphen als Verbindung FIELD → DECLARE gezeichnet.
- Die Breite `0` ist ein Record-Feld. Es beginnt mit einem TAG WORD und wird in der Length dieses TAG gelesen (Interpretationsregeln bei [DECLARE](/de/grammar/edge/declare/)).
- Die Breite `n` (1~65534) ist ein Rohwert-Feld. Es sind stets genau n WORD.
- Die Breite `0xFFFF` ist der restliche Rohwert. Er steht nur einmal im DECLARE und kann vorn, in der Mitte oder am Ende stehen. Die Breite ist die verbleibende WORD-Zahl, die die TAG-Length des umgebenden Records festlegt, abzüglich der Breiten der nachfolgenden Felder. Deshalb müssen alle Felder nach dem restlichen Feld Rohwerte fester Breite sein (einen Record kann man erst von vorn lesend zu Ende erkennen). Er kann 0 WORD haben. Ein ENUM wird nicht angehängt.
- Das vom Feld akzeptierte Kind/Codec legt man mit [CODEC](/de/grammar/edge/codec/) fest. Ein Record-Feld akzeptiert ohne CODEC jeden Record, mit CODEC muss es einer davon sein. Setzt man bei einem Rohwert-Feld ein CODEC, wird dieser Rohwert als dieser Value ohne TAG interpretiert.
- Der Feldname wird per [BIND](/de/grammar/edge/bind/) an die Edge Id des FIELD gebunden (z. B. `doc`, `hash`). UTF8-TEXT für DECLARE, FIELD, ENUM und CODEC wird stets per BIND angehängt, nicht über LABEL oder andere Edges.
- Die Bedeutung von Codewerten eines Rohwert-Feldes hängt man mit [ENUM](/de/grammar/edge/enum/) an.
- Felder, die im Graphen auf andere Knoten verweisen, werden nicht eigens gekennzeichnet. Ist ein Record-Feld ein Reference, ist das die Verbindung.

## Länge

```
Gesamt = 1 + 2 + 2 + 1 WORD   (wenn Edge Id und DECLARE ein LOCAL mit 1 WORD ID sind)
```

## Beispiel (nicht normativ)

- Record-Feld: Edge Id 7, DECLARE #1, Breite `0`. TAG 1 + Edge Id 2 + DECLARE 2 + Breite 1 = 6 WORD. Wie man erreicht, dass nur LOCAL akzeptiert wird, siehe das Beispiel bei [CODEC](/de/grammar/edge/codec/).

```
129C 0088 0007 0088 0001 0000
```

- Ein Rohwert-Feld wie der Inhaltshash steht im Beispiel bei [DECLARE](/de/grammar/edge/declare/).

## Verwandte Seiten

- [DECLARE](/de/grammar/edge/declare/), [ENUM](/de/grammar/edge/enum/), [CODEC](/de/grammar/edge/codec/), [BIND](/de/grammar/edge/bind/)
- [Codec-Spezifikationsdokument](/de/grammar/codec-spec/)
