---
title: "Slot-Marker"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "Slot-Marker sind eine Gruppe von 1-WORD-Records im reservierten Reference-Codec 0000. 0x0000 ABSENT (nicht angegeben), 0x0001 UNKNOWN-VALUE (unbekannt) und 0x0002 NO-VALUE (kein Wert) füllen die Stelle eines Record-Feldes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Ein Slot-Marker ist ein 1-WORD-Record, der die Stelle eines Record-Feldes füllt. Er verweist auf nichts. Er liegt im reservierten Reference-Codec `0000`.

An der Stelle eines Wertes kann dreierlei stehen: Der Wert wurde nicht angegeben; es gibt einen Wert, aber er ist unbekannt; es gibt keinen Wert. Das sind drei verschiedene Dinge. Der Slot-Marker schreibt sie als drei benachbarte WORD.

## Layout

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = Markernummer
```

| WORD | Name | Bedeutung | Notation |
|---|---|---|---|
| `0x0000` | ABSENT | Nicht angegeben | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | Unbekannt: Es gibt einen Wert. Welchen, ist unbekannt | `UNKNOWN` |
| `0x0002` | NO-VALUE | Kein Wert: Es gibt keinen Wert | `NONE` |
| `0x0003`~`0x0007` | Reserviert | | |
| CCCC `0000`, LLLL ≥ `0001` | Reserviert | Marker mit Payload werden später festgelegt | |

- Die unteren 3 Bit `MMM` sind **nicht der Quantifier, sondern die Markernummer**. Sie liegen an der Stelle des `QQQ` anderer Reference-Codecs, sind aber nur dem Namen nach dasselbe und bedeutungsmäßig nicht verbunden (Quantifier-Ausnahme in [Reference](/de/grammar/reference/)).
- Es gibt keinen Payload und keine Ziel-ID.
- Auch ein Decoder ohne Codebook erkennt allein am TAG WORD Kind Reference und 1 WORD und überspringt ihn. „Ein WORD-Wert von `0`~`7` ist ein Slot-Marker“ erkennt man mit einer einzigen Bitprüfung (`w & 0xFFF8 == 0`).
- Die Notationen `ABSENT`, `UNKNOWN` und `NONE` sind die Textnotation von `geul show` und `geul add`.

## Drei Unterscheidungen

| | Nicht angegeben (ABSENT) | Unbekannt (UNKNOWN-VALUE) | Kein Wert (NO-VALUE) |
|---|---|---|---|
| Worüber es etwas sagt | **Dokument**: Diese Stelle wurde nicht ausgefüllt | **Welt**: Es gibt einen Wert. Welchen, ist unbekannt | **Welt**: Es gibt keinen Wert |
| Logik | Behauptet nichts | `∃x. P(s, x)`, x ist nicht identifiziert | `¬∃x. P(s, x)` |
| Weltannahme | Offene Welt (keine Information) | Existenz geschlossen, Identität offen | Geschlossene Welt bezüglich (s, P, einschränkende Bedingung) |
| Wikidata | Der entsprechende Snak fehlt | `somevalue` | `novalue` |
| Wo verwendet | Optionales Feld mit CODEC-Ziel `0000` (SOURCE Origin usw.) | Feld mit CODEC-Ziel `0001` (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | Feld mit CODEC-Ziel `0002` (TRIPLE Object, QUALIFIER Value) |
| „Wie viele Kinder (P40)?“ | Unbekannt | Mindestens 1 | 0 |
| „Gibt es einen Endzeitpunkt (P582)?“ | Unbekannt → unbekannt, ob es noch gilt | Beendet. Wann, ist unbekannt | Nicht beendet (Behauptung) |

Dieselbe Unterscheidung gilt auch auf Ebene der Proposition. **Ein TRIPLE, das im Dokument fehlt**, ist „nicht angegeben“. Ein GEUL-Dokument ist eine offene Welt, daher bedeutet das Fehlen einer Aussage nicht, dass die Tatsache nicht besteht. „Es gibt keinen“ lässt sich nur sagen, indem man es **mit NO-VALUE hinschreibt**.

## Akzeptanzregel

- Ein Slot-Marker ist nur gültig, wenn die [CODEC](/de/grammar/edge/codec/)-Liste des Feldes **dasselbe WORD als exaktes Ziel enthält**. Das Ziel `0000` bedeutet „optionales Feld“, `0001` „akzeptiert unbekannt“, `0002` „akzeptiert kein Wert“.
- Wildcards (`0780`, `0781`, `0F80` usw.) akzeptieren keine Marker. Auch Reference-Wildcards überschneiden sich nicht mit dem Codec `0000`.
- Auch Record-Felder ohne CODEC („beliebiger Record“) akzeptieren keine Marker.
- Ein Marker an Stellen für HEAD-/BODY-Records und an Stellen für Edge Ids ist invalid.
- Bei Rohwert-Feldern kann kein Marker verwendet werden. Ein Rohwert hat kein TAG, daher gibt es keine Stelle für einen 1-WORD-Marker.
- Eine CODEC-Liste, die nur Marker-Ziele enthält (immer ein Marker), ist invalid.
- Die Bedeutung eines Markers (was vorhanden ist und was nicht) legt die Edge-Spezifikation fest, die ihn akzeptiert. Das entspricht dem Grundsatz, dass Quantifizierung und Negation nicht das Reference, sondern das Edge bestimmt.
- Für Slot-Marker gibt es kein Codec-Spezifikationsdokument. Sie gehören zu [Ebene 0](/de/grammar/publishing/#ebenen) (im Decoder eingebaut). Das Reference-Ziel eines DECLARE lässt die Quantifier-Stelle auf 0, daher lässt sich für `0x0001` und `0x0002` kein Spezifikationsdokument anlegen; da alle drei keinen Payload haben, entstehen auch keine Einbaukosten.

## Pflichten des Lesers

1. **UNKNOWN-VALUE ist keine Wertangabe, sondern eine Existenzbehauptung.** Er ist keinem anderen Wert gleich und auch nicht ungleich (Vergleichsergebnis unbestimmt). Auch zwei UNKNOWN-VALUE gelten nicht als derselbe Wert. Jedes Auftreten ist eine unabhängige Existenzquantifizierung (wie ein leerer Knoten in Wikidata).
   - Deshalb sind zwei bytegleiche TRIPLEs (`P40 Q… UNKNOWN` ×2) kein Duplikat. Es können zwei Kinder sein oder eines. TRIPLEs mit UNKNOWN-VALUE werden nicht als Duplikate zusammengeführt.
   - Wird die Identität später bekannt, gibt man eine neue Version mit korrigiertem TRIPLE heraus. Auf UNKNOWN-VALUE kann man nicht verweisen. Braucht man Koreferenz, verwendet man eine LOCAL-Variable ([Reference](/de/grammar/reference/), Variable).
2. **NO-VALUE ist innerhalb der einschränkenden Bedingungen der Proposition geschlossen.** Mit angehängten QUALIFIER ist er nur in diesem Bereich geschlossen. Q30 P1304 NO-VALUE (P580 1811, P582 1816) bedeutet, dass es nur in den Jahren 1811~1816 keine Zentralbank gab, und widerspricht dem Wert-TRIPLE derselben Eigenschaft (Federal Reserve, preferred) nicht.
   - Stehen für dasselbe Subject und Predicate ein NO-VALUE und ein Wert-TRIPLE mit gleichem rank zusammen, ohne dass sich ihre einschränkenden Bedingungen unterscheiden, ist das ein Widerspruch. Der Prüfer gibt eine Warnung aus. Er lehnt nicht ab. Dieser Zustand kommt auch in Wikidata vor, und der Leser wählt über den rank.
3. **Der rank gilt unverändert.** Bei der Wahl des Hauptwerts (truthy) sind auch TRIPLEs mit UNKNOWN-VALUE und NO-VALUE Kandidaten. Gibt es preferred, bleibt nur preferred übrig.
4. **Als QUALIFIER-Wert verwendet, ändert er die Bedeutung dieser Einschränkung.** `P582 = UNKNOWN` bedeutet beendet, Zeitpunkt unbekannt. Die Proposition wird nicht als noch gültig gelesen. `P582 = NONE` behauptet, dass es nicht beendet ist. Fehlt ein QUALIFIER P582 ganz, ist unbekannt, ob es beendet ist.
5. **ABSENT sagt nichts über die Welt aus.** Er wird nicht als UNKNOWN-VALUE oder NO-VALUE gelesen. Umgekehrt ist es verboten, dass ein Konverter einen Wert, den er nicht übertragen konnte (im Original vorhanden), als UNKNOWN-VALUE schreibt, denn im Original ist der Wert bekannt. Auch Stellen, zu denen das Original nichts sagt (z. B. Origin eines [SOURCE](/de/grammar/edge/source/) einer Quelle ohne Beschreibung), schreibt der Konverter als ABSENT. UNKNOWN-VALUE ist die Behauptung „es gibt ihn“ und wird nur verwendet, wenn das Original das so sagt.

## Unterschied zu anderen Formen von „kein“

- Die Codec-Regel, die [LOCAL](/de/grammar/reference/local/) `0` als „kein“ verwendet (TOULMIN REF usw. in [TOULMIN](/de/grammar/edge/toulmin/)), ist eine Vereinbarung innerhalb dieses Codecs. Sie unterscheidet sich vom Slot-Marker.
- Ein Identified LOCAL wird nicht als null oder Sentinel verwendet. Um Unbekanntes oder Abwesendes zu schreiben, verwendet man in einem Feld, das Marker akzeptiert, einen Marker.

## Beispiel

Grenze zwischen Q30 (USA) und Q34266 (Russisches Kaiserreich), Endzeitpunkt unbekannt. Die Edge Ids dienen nur der Erläuterung.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Zentralbank von Q30, in den Jahren 1811~1816 gab es keine.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- Die Marker-Stelle ist 1 WORD. Das TRIPLE hat 9 WORD (`140A`), der QUALIFIER 8 WORD (`138B`).
- In einfacher Form ist „keine Kinder (P40)“ `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [CODEC](/de/grammar/edge/codec/), [Codec-Spezifikationsdokument](/de/grammar/codec-spec/)
- [TRIPLE](/de/grammar/edge/triple/), [QUALIFIER](/de/grammar/edge/qualifier/), [TOULMIN](/de/grammar/edge/toulmin/)
