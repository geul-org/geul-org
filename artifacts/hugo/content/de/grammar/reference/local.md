---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL ist ein Deklarations-Reference, das mit einer von diesem Dokument vergebenen ID auf ein Objekt verweist. Auch die Edge Id ist ein LOCAL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL ist ein Deklarations-Reference, das mit einer von diesem Dokument vergebenen ID auf ein Objekt verweist. Es verweist ohne externen Issuer auf Objekte im Dokument und hat außerhalb des Dokuments keine Bedeutung. Um von außen darauf zu verweisen, setzt man im Dokument das Meta [DOC-ID](/de/grammar/meta/declaration/doc-id/), und andere Dokumente verweisen mit einem Zeiger-Reference.

## Layout

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[Length-Erweiterungs-TAG]
LOCAL ID          vorzeichenloses Big-Endian in der kürzesten Breite
```

| LOCAL ID | Gesamt | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- Das TAG WORD lautet `0000 0 LLLL 0001 QQQ`. Bei Identified (`000`) sind die unteren 7 Bit `0x08`.
- Es folgt der allgemeinen Reference-Regel, die Ziel-ID mit der kleinsten WORD-Zahl zu schreiben.

## Edge Id

- Das LOCAL als erstes Element des Edge-Payloads ist die Deklaration der Edge Id dieses Edge ([Edge](/de/grammar/edge/)). Das LOCAL, das eine Edge Id deklariert, verwendet nur den Quantifier `000`.
- LOCAL an anderen Stellen des Edge-Payloads sind Erwähnungen. Objekte dieses Dokuments werden bei jeder Erwähnung als LOCAL geschrieben. Einen eigenen Zeiger-Code für Objekte dieses Dokuments gibt es nicht.

## Vergabe von Kennungen

- IDs sind Ganzzahlen und werden vom Encoder vergeben. Größe und Vergabereihenfolge der Zahl haben außer der Gleichheit keine Bedeutung.
- **UNIQUE (verpflichtend).** In einem Dokument verweist eine LOCAL ID auf genau ein Objekt. Eine Edge Id wird je Dokument nur einmal deklariert (HEAD-Edges und BODY-Edges teilen sich einen Nummernraum). Deklarieren zwei oder mehr Edges dieselbe Edge Id, ist das invalid.
- **AUTO INCREMENT (Empfehlung).** Eine neue ID wird als Maximum der bisher in diesem Dokument vergebenen IDs + 1 vergeben und steigt in der Dokumentreihenfolge. Das gilt auch über Versionen hinweg (neu angelegt wird mit einem Wert, der größer ist als eine gestrichene ID). Es ist nur eine Empfehlung und keine Gültigkeitsbedingung; auch ein Dokument, dessen IDs nicht steigen, ist valid. Der Decoder verlässt sich nicht auf Größe oder Lückenlosigkeit der IDs.
- Die ID `0` wird nicht vergeben. Sie verweist auf kein Objekt und wird auch nicht als Edge Id verwendet. Ziel-IDs werden ab `1` vergeben.
- Ein Dokument wird, innerhalb wie außerhalb des Dokuments, nur mit einem einzigen [DOC-POINTER](/de/grammar/reference/doc-pointer/) angesprochen (es selbst ist der DOC-POINTER seiner `DOC-ID`). Auch an ein Dokument kann man `BIND`, `LABEL` und Urteils-Edges anhängen.
- Den Issuer selbst spricht man mit [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) an. Die Dokument-ID `0` ist das Begriffsdefinitions-Indexdokument des Issuers.
- Codecs, die der `0` an einer Komponentenstelle eine Bedeutung geben ([TOULMIN](/de/grammar/edge/toulmin/) REF, „kein“ bei Ausführungs-Edges; „gesamtes Dokument“ beim Target des HEAD-[SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments)), folgen den Regeln dieses Codecs. Das ist eine Vereinbarung innerhalb dieses Codecs, anders als der [Slot-Marker](/de/grammar/reference/slot-marker/).
- Eine einmal vergebene ID wird im selben Dokument nicht wiederverwendet.
- Es wird stets die kleinste Breite verwendet, die den Wert darstellen kann.

## Identität und Geltungsbereich

- Im selben Dokument ist derselbe ganzzahlige Wert der LOCAL ID dasselbe Objekt. Die Kodierungsbreite ist nicht Teil der Identität.
- Ein Identified LOCAL steht für ein identifiziertes Objekt. Es wird nicht für anonyme, unbestimmte, null- oder Sentinel-Zwecke verwendet. Dass es einen Wert gibt, er aber unbekannt ist (UNKNOWN-VALUE), oder dass es keinen Wert gibt (NO-VALUE), schreibt man in einem Feld, das den Marker akzeptiert, als [Slot-Marker](/de/grammar/reference/slot-marker/).
- Verschiedene LOCAL IDs sind nur verschiedene Reference und bedeuten nicht, dass auch die Objekte in der Wirklichkeit verschieden sind.
- Die Identität eines LOCAL wird nicht über das Dokument hinaus erweitert. Dieselbe Zahl in einem anderen Dokument ist unabhängig.
- Ein Variable-LOCAL (`100`) ist eine benannte Diskursvariable ([Reference](/de/grammar/reference/), Variable).

## Zusammenführung

Beim Zusammenführen mehrerer Dokumente erstellt man für jedes Ausgangsdokument eine Zuordnungstabelle `old ID → new ID`, vergibt alle LOCAL IDs mit den IDs des neuen Dokuments neu und ersetzt alle Verweise.

- IDs, die im selben Ausgangsdokument gleich waren, müssen auch nach der Zusammenführung gleich sein.
- Dieselbe Zahl aus verschiedenen Ausgangsdokumenten ist unabhängig und wird nicht automatisch zu einem Reference zusammengeführt.
- Bleibt auch nur ein LOCAL, das nicht ersetzt werden konnte, wird die Zusammenführung abgelehnt.

## Gültigkeit

Folgende Kodierungen oder Vergaben sind invalid.

- Nicht-minimale Kodierung mit führendem WORD `0x0000` (Ausnahme: 1 WORD `0x0000` für den Wert 0)
- Der Quantifier an der Stelle der Edge-Id-Deklaration ist nicht `000`, oder die ID ist `0`
- Eine ID wird im selben Dokument überlappend an verschiedene Objekte vergeben
- Dieselbe Edge Id wird im selben Dokument zwei- oder mehrmals deklariert

## Beispiel

| LOCAL ID | WORD-Folge |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1, Variable | `008C 0001` |

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [DOC-POINTER](/de/grammar/reference/doc-pointer/), [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/de/grammar/reference/external-pointer/)
- [Edge](/de/grammar/edge/)
