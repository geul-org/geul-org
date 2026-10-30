---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TOULMIN-Edges (Codec 0x60~0x7B) schreiben Urteils- und Ausführungsgraphen mit dem Toulmin-Argumentationsmodell. Diese Seite legt die TOULMIN-Dokumentregeln, gemeinsame Felder, Codetabellen, numerische Regeln und den festen Kern der Selbstrevision fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edges der TOULMIN-Familie (obere 2 Bit des Codec `11`, direkte Codes `0x60`~`0x7B`) schreiben Urteils- und Ausführungsgraphen mit dem Toulmin-Argumentationsmodell. Deklaration von Behauptung, Gegenbehauptung und Ausnahme, Angriffs- und Verdrängungsbeziehungen, Ausführungsverbindungen und Urteilsergebnisse sind alle Edges. Ein TANGEUL-Dokument (die Regelsprache der toulmin-Engine) wird zu einem GEUL-Dokument. Die Dateiendung ist wie bei anderen Dokumenten `.geul`.

Was diese Seite nicht festlegt, folgt den gemeinsamen Regeln von [Edge](/de/grammar/edge/) und [Record und TAG WORD](/de/grammar/record/).

## Metakognition und Selbstrevision

TOULMIN ist ein GEUL-Codec, damit GEUL sich selbst metakognitiv erfassen kann. Nur wenn auch die Urteils- und Ausführungsregeln in GEUL beschrieben sind, kann TOULMIN diese Regeln zum Gegenstand nehmen und sich selbst korrigieren. Deshalb ist TOULMIN kein Anwendungsprofil, sondern der Kern des GEUL-Betriebs und liegt im direkten Codebereich der Edges (`0x60`~`0x7B`).

- Selbstbeschreibung ermöglicht Selbstverbesserung, birgt aber die Gefahr zirkulärer Fehler. Beurteilt eine Regel ihre eigene Revision selbst, kann auch eine Revision durchgehen, die die Beurteilungskriterien aufweicht (die Bestehensquote steigt, die tatsächliche Genauigkeit sinkt).
- Die Zirkularität wird als Gefahr akzeptiert, aber durch Struktur durchbrochen.
  - **Fester Kern**: Die Bedeutung des Urteils (Pass, Review, Fail, Angriff, Verdrängung, Vorrang, die 3-Werte-Auswertung und U → Review unter [Urteilen auf unbekannter Grundlage](#urteilen-auf-unbekannter-grundlage)) ist in dieser Spezifikation festgelegt. Sie lässt sich nicht in TOULMIN-Dokumente umwandeln. Das ist dieselbe Stelle wie bei den im Decoder eingebauten Regeln ([Ebene 0](/de/grammar/publishing/#ebenen) in der Veröffentlichungsadresse und Versionsliste).
  - **Trennung der Fassungen**: Die Revision v(n) eines Regeldokuments wird mit den Regeln von v(n−1) und einer externen Prüfung beurteilt. Eine Regel beurteilt sich nicht selbst. Das Urteilsergebnis steht in einem anderen Dokument als der Urteilsgegenstand (der Inhaltshash des Gegenstands ändert sich nicht).
  - **Unveränderliche Historie**: Revisionen sammeln sich als neue Versionen (`PARENT`, Inhaltshash, Signatur). Da alte Versionen erhalten bleiben, lassen sich zirkuläre Fehler nachträglich finden und zurücknehmen. Das Sicherheitsnetz der Selbstrevision ist das Fassungsmodell von GEUL ([Dokument](/de/grammar/document/#revision)).
  - **Externer Maßstab**: Man hält eine Sammlung von Testfällen bereit, die der Revisionspfad nicht anfassen kann. Die Übernahme einer Revision wird anhand des Ergebnisses dieser Sammlung bestätigt.
- Widerlegungstest: Man pflanzt absichtlich eine falsche Regel ein. Korrigiert das System sie und steigt die Punktzahl im externen Maßstab, funktioniert die Selbstverbesserung. Steigt nur die Bestehensquote und sinkt die Punktzahl im externen Maßstab, ist es ein zirkulärer Fehler.

## Codes

TOULMIN-Records verwenden eines von drei Layouts. Das Layout legt der Codec (oder die Formatnummer) fest.

| Layout | Verwendung | Seite |
|---|---|---|
| NODE | Graphknoten wie Fall, Regel, Definition, Einstiegspunkt | [NODE](/de/grammar/edge/toulmin/node/) |
| LINK | Beziehungen zwischen Knoten (Angriff, Verdrängung, Ausführung, Definition) | [LINK](/de/grammar/edge/toulmin/link/) |
| EXPR | Bedingungsausdruck (Prädikat) | [EXPR](/de/grammar/edge/toulmin/expr/) |

Originaltext- und Gliederungs-Records (SOURCE, TEXT, SECTION, CASE-BEGIN/CASE-END, PROSE) legt [SOURCE und Gliederung](/de/grammar/edge/toulmin/source/) fest.

### Direkte Codes

| Codec | Name | Layout | TANGEUL | Bedeutung |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/de/grammar/edge/toulmin/node/) | NODE | `in case of` | Fall-Deklaration. Ein Urteilsgraph aus Knoten und Beziehungen |
| `0x61` | [PREDICATE-DECLARE](/de/grammar/edge/toulmin/expr/) | EXPR | Bedingungsausdruck der Rules | Prädikat-Deklaration. Urteilsausdruck |
| `0x62` | [SPEC-DECLARE](/de/grammar/edge/toulmin/node/) | NODE | Eintrag der Definitions | Deklaration eines Beurteilungskriteriums (Backing). Die role-Bits bestimmen die Art der Definition |
| `0x63` | [RULE-DECLARE](/de/grammar/edge/toulmin/node/) | NODE | general rule, Regelname der Rules | Deklaration einer Behauptung (Warrant). Kann angegriffen werden |
| `0x64` | [COUNTER-DECLARE](/de/grammar/edge/toulmin/node/) | NODE | counter rule | Deklaration einer Gegenbehauptung. Greift mit eigener Schlussfolgerung an. Standard-Level ist Fail |
| `0x65` | [EXCEPT-DECLARE](/de/grammar/edge/toulmin/node/) | NODE | except rule | Deklaration einer Ausnahme. Greift ohne eigene Schlussfolgerung an. Standard-Level ist Review |
| `0x68` | [ATTACKS](/de/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | Angriffsbeziehung. Das Urteil des Angreifers mindert das Urteil des Ziels schrittweise nach der Angriffskraft (0~1, Standard 1) |
| `0x69` | [SUPERSEDES](/de/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | Verdrängungsbeziehung. Ist der Angreifer Active, nimmt er das Ziel endgültig aus der Aggregation. Eine Kette (`A > B > C`) wird paarweise je einmal geschrieben |
| `0x6A` | SUPERSEDE-CHAIN | — | | Vorrangkette `A > B > C`. Kurzform paarweiser SUPERSEDES. Nur der Code ist vergeben, ein Layout gibt es noch nicht |
| `0x70` | [RUN](/de/grammar/edge/toulmin/link/) | LINK | `run c when n` | Ausführungskomposition. Ist der Knoten Active, wird der untergeordnete Fall ausgeführt (DAG) |
| `0x71` | [DO](/de/grammar/edge/toulmin/link/) | LINK | `do fn when n` | Aktion, die ausgeführt wird, wenn der Knoten Active ist |
| `0x72` | [DO-ONCE](/de/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | Aktion, die auch bei Wiederholungen nur einmal ausgeführt wird |
| `0x73` | [UNDO](/de/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | Kompensationsaktion zu DO (Saga). Schlägt ein späterer Schritt fehl, wird sie in umgekehrter Reihenfolge ausgeführt |
| `0x74` | [CHECKING](/de/grammar/edge/toulmin/link/) | LINK | `checking c` | Verbindung, die ohne Nebenwirkung nur urteilt |
| `0x75` | [ENTRY](/de/grammar/edge/toulmin/node/) | NODE | `provides x` | Externer Einstiegspunkt. Führt einen Fall aus oder beurteilt ihn |
| `0x76` | [TRIGGER](/de/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | Ereignis- oder periodischer Einstiegspunkt ohne externen Aufruf |
| `0x78` | VERDICT | — | | Urteilsergebnis eines Knotens oder Records. Ergebnis (Pass, Review, Fail), Urteilswert, Activated, Excluded, Level. Nur der Code ist vergeben, ein Layout gibt es noch nicht |
| `0x79` | EVIDENCE | — | | Beweis eines Urteils. Stelle, erwarteter Wert, tatsächlicher Wert (Fact). Nur der Code ist vergeben, ein Layout gibt es noch nicht |
| `0x7C`~`0x7F` | ISSUER-* | | | Vom Issuer definiertes Format. Siehe unten ISSUER-Formate |

- Direkte Codes, die nicht in der Tabelle stehen (`0x66`/`0x67`, `0x6B`~`0x6F`, `0x77`, `0x7A`/`0x7B`), sind reserviert.
- Die oberen 2 Bit der unteren 5 Bit des Codec bilden die Gruppe: `00` Deklaration, `01` Beziehung, `10` Ausführung, `11` Ergebnis (`0x7C`~`0x7F` sind ISSUER).
- Das Urteil über das gesamte Dokument übernimmt das Meta [VERDICT](/de/grammar/meta/verification/verdict/) (`0x44`), das Urteil über Knoten und Records das TOULMIN-`VERDICT` (Edge `0x78`). Das sind getrennte Codecs mit verschiedenem Kind.

### ISSUER-Formate

TOULMIN-Records, für die die direkten Codes nicht reichen, werden als `ISSUER-1WORD` (`0x7C`) unter einer Formatnummer des Issuers `0x0000` (GEUL) abgelegt. Die Formatnummer gehört zur TOULMIN-Familie (`0xC000`~`0xFFFF`, obere 2 Bit `11`).

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[Length-Erweiterungs-TAG]
Issuer            0x0000
Formatnummer      0xC000~0xC029
Edge Id           LOCAL-Reference-Record
Komponenten       vom Format festgelegtes Layout
```

| Formatnummer | Name | Layout | Bedeutung |
|---|---|---|---|
| `0xC000` | [SOURCE](/de/grammar/edge/toulmin/source/) | ID, SPAN-Breite WORD, UTF8-Value | Verfasster Originaltext |
| `0xC001` | [TEXT](/de/grammar/edge/toulmin/source/) | ID, UTF8-Value | Name/Zeichenkette |
| `0xC002` | [SECTION](/de/grammar/edge/toulmin/source/) | ID, Abschnittscode 1 WORD | Abschnittsbeginn |
| `0xC003` | [CASE-BEGIN](/de/grammar/edge/toulmin/source/) | ID, REF (Fall) | Beginn eines Fallbereichs |
| `0xC004` | [CASE-END](/de/grammar/edge/toulmin/source/) | ID, REF (Fall) | Ende eines Fallbereichs |
| `0xC005` | [PROSE](/de/grammar/edge/toulmin/source/) | ID, SPAN | Beschreibender Absatz |
| `0xC010` | [NAMESPACE](/de/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/de/grammar/edge/toulmin/node/) | NODE | Funktionsreferenz |
| `0xC012` | [FIELD](/de/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/de/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/de/grammar/edge/toulmin/node/) | NODE | Geordnete Ausführungsgruppe |
| `0xC020` | [REQUIRES](/de/grammar/edge/toulmin/link/) | LINK | Fall → Feld |
| `0xC021` | [MEANS](/de/grammar/edge/toulmin/link/) | LINK | Definitionseintrag → Wert/Typ |
| `0xC022` | [HAS](/de/grammar/edge/toulmin/link/) | LINK | Definitionseintrag → Feld |
| `0xC023` | [RUNS](/de/grammar/edge/toulmin/link/) | LINK | Einstiegspunkt → Fall, Ausführung |
| `0xC024` | [EVALUATES](/de/grammar/edge/toulmin/link/) | LINK | Einstiegspunkt → Fall, Beurteilung |
| `0xC025` | [TRIGGERS](/de/grammar/edge/toulmin/link/) | LINK | Trigger → Fall |
| `0xC026` | [UNTIL](/de/grammar/edge/toulmin/link/) | LINK | Trigger → Fall (`every … until`) |
| `0xC027` | [SAME-AS](/de/grammar/edge/toulmin/link/) | LINK | Knoten → globale Kennung |
| `0xC028` | [IMPORTED-FROM](/de/grammar/edge/toulmin/link/) | LINK | Alias → Pfad (TEXT) |
| `0xC029` | [LABEL](/de/grammar/edge/toulmin/link/) | LINK | Knoten → TEXT, Namensangabe |

- Der Formatnummernraum ist für jedes Kind getrennt. Das GEUL-Format `0xC000` des Value (OPAQUE-BYTES-EVEN) und `0xC000` des Edge (SOURCE) sind verschiedene Formate.
- Formatnummern werden nur hinzugefügt. Eine vergebene Nummer wird für kein anderes Format wiederverwendet.

## Dokument

Eine `.geul`-Datei ist ein DOC. Außerhalb des DOC stehen keine weiteren Bytes.

```
DOC-1WORD/2WORD/4WORD     Gesamtlänge
  SPEC-VERSION            0x0001 (v1, Ganzzahl ohne eingebetteten Value)
  PROFILE                 UTF8-Value "tangeul-<major>.<minor>". Derzeit "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE-Value. Locale der Abfassung ("en", "ko")
BODY
  SOURCE                  Verfasster Originaltext. Erster Record des BODY
  Satz-Records …           in der Deklarationsreihenfolge des Dokuments
END
```

- HEAD: [SPEC-VERSION](/de/grammar/meta/declaration/spec-version/), [PROFILE](/de/grammar/meta/declaration/profile/), optional [DEFAULT-LANGUAGE](/de/grammar/meta/declaration/default-language/).
- Ein Decoder lehnt ab, wenn SPEC-VERSION abweicht oder das major des PROFILE abweicht. Bei abweichendem minor wird trotzdem gelesen.
- Der erste Record des BODY ist das SOURCE. Alle SPAN sind Bereiche in diesem Originaltext.
- Die Reihenfolge der Satz-Records entspricht der Deklarationsreihenfolge des Dokuments. Die Ausführungsreihenfolge (`do`/`run`-Auslösung, umgekehrte Kompensation durch `undo`) stützt sich auf diese Reihenfolge. In TOULMIN-Dokumenten hat die Edge-Reihenfolge Bedeutung (Ausnahme zur Reihenfolgeregel in [Edge](/de/grammar/edge/)).
- Alle Records des BODY sind Edges. Eigenständige Value-Records gibt es nicht. Werte werden in den Edge-Payload eingebettet.
- Für Identität eines Falls und Import dienen die Meta [DOC-ID](/de/grammar/meta/declaration/doc-id/) und [IMPORT-DOC](/de/grammar/meta/import/import-doc/) (Subject und See in TANGEUL).

## Gemeinsame Felder

| Feld | Breite | Beschreibung |
|---|---|---|
| ID | LOCAL-Reference-Record | Edge Id des Records. Erstes Element des Payloads jedes Records |
| REF | LOCAL-Reference-Record | Edge Id, die auf einen anderen Record dieses Dokuments verweist. `0` bedeutet „kein“ |
| SPAN | vom SOURCE festgelegte Breite × 2 | Bereich im verfassten Originaltext. Startbyte, Bytezahl |

- ID und REF sind eingebettete [LOCAL](/de/grammar/reference/local/)-Reference-Records (`0000 0LLL L000 1000` + ID in der kürzesten Breite). Die Breite legt die Length dieses Records fest und wird nicht dokumentweit deklariert.
- REF `0` (LOCAL `0`) bedeutet „kein“. Das ist eine Codec-Regel, die LOCAL `0` als „kein“ verwendet ([LOCAL](/de/grammar/reference/local/)).
- Edge Ids werden ab 1 vergeben und im Dokument nicht doppelt verwendet. `0` ist das „kein“ von REF und wird nicht als Edge Id verwendet.
- Auf Knoten verweisen andere Records vorwärts, daher erhalten sie zuerst in der Deklarationsreihenfolge des Dokuments ihre Nummern. Die übrigen Records (SOURCE, TEXT, LINK, FUNC, Gliederungs-Records) erhalten vom Encoder Nummern nach den Knoten.
- Der Decoder prüft nur, dass die Edge Id nicht 0 ist und keine Duplikate vorkommen. Die Vergabereihenfolge wird bei der Interpretation nicht verwendet.
- Auf Knoten und Beziehungen wird über die Edge Id verwiesen.
- Ein eingebetteter Value ist ein Value-Record einschließlich TAG WORD unverändert. Die Länge legt dieses TAG fest.

## Numerische Werte

- Urteilswert (−1~1), Qualifier (0~1) und Angriffskraft (0~1) sind [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/)-Values. Ein eigenes Festkommaformat gibt es nicht.
- Der Encoder entfernt Nullen am Ende des Koeffizienten. 0,8 ist `C=8, E=−1`. Der Decoder akzeptiert bis zu 4 Dezimalstellen.
- Ein Konfidenz-Gate (z. B. `at least 75%`) wird mit 1 WORD Vergleichsoperator und einem Prozent-[UNSIGNED-DECIMAL](/de/grammar/value/decimal/unsigned-decimal/)-Value (`E=0`) geschrieben ([LINK](/de/grammar/edge/toulmin/link/) F_GATE).
- Die Angriffskraft ist das F_FORCE-Feld von ATTACKS ([LINK](/de/grammar/edge/toulmin/link/#angriffskraft)). Außerhalb des Bereichs wird abgelehnt.

## Achsen der Knotendeklaration

- Eine Knotendeklaration (RULE-, COUNTER-, EXCEPT-DECLARE) hat Rolle (Behauptung, Gegenbehauptung, Ausnahme), Qualifier (0~1) und Level (Unset, Fail, Review). Die Rolle tragen der Codec und das role des NODE-Headers, den Qualifier F_QUAL, das Level das level des Headers ([NODE](/de/grammar/edge/toulmin/node/)).
- Die Stärke (Strict, Defeasible, Defeater) ist eine von der Rolle getrennte Achse. Wie sie angeordnet wird, ist noch nicht festgelegt.
- Die Angriffskraft (Force) ist kein Wert eines Knotens, sondern einer ATTACKS-Kante ([LINK](/de/grammar/edge/toulmin/link/#angriffskraft) F_FORCE). Sie ist eine andere Achse als die Stärke.

## Urteilen auf unbekannter Grundlage

Erhält ein Urteilsgraph GEUL-Tatsachen als Eingabe, werden die drei Begriffe des [Slot-Markers](/de/grammar/reference/slot-marker/) (nicht angegeben, unbekannt, kein Wert) unterschiedlich ausgewertet. Die Auswertung der Vergleichsoperatoren von [EXPR](/de/grammar/edge/toulmin/expr/) ist wie folgt.

| Eingabe | `is empty` | `is not empty` | `equals` / `is in` / Größenvergleich |
|---|---|---|---|
| Wert v | falsch | wahr | Auswertung mit v |
| NO-VALUE (kein Wert) | **wahr** | falsch | falsch |
| UNKNOWN-VALUE (unbekannt) | falsch | **wahr** | **unbestimmt (U)** |
| ABSENT (nicht angegeben) / keine Aussage | U (offene Welt) | U | U |

- Die Logik ist die starke 3-Werte-Logik nach Kleene. `NOT U = U`, `falsch AND U = falsch`, `wahr OR U = wahr`. Die übrigen Kombinationen mit U ergeben U.
- `EXISTS any` ist wahr, wenn mindestens ein Element wahr ist. Gibt es kein wahres, aber U, ist es U; sind alle falsch, ist es falsch.
- **Ist das Prädikat U, ist das Urteil dieses Knotens nicht Pass oder Fail, sondern Review.** Was man nicht weiß, gibt man an einen Menschen (oder den nächsten Schritt) weiter.
- Um ABSENT nicht als U, sondern als empty zu sehen, muss die Eingabeseite eine geschlossene Welt **deklarieren** (als Beurteilungskriterium SPEC einspeisen, z. B. „die Eingabe dieses Falls ist vollständig“). Ohne Deklaration ist es U.
- Diese Tabelle und die Entsprechung U → Review sind die Bedeutung des Urteils und daher der **feste Kern**. Sie lassen sich nicht in TOULMIN-Dokumente umwandeln.
- Beispiel: Die Regel „nur noch geltende Grenzen zählen“ (`P582 is empty`) schließt bei P582 = UNKNOWN-VALUE aus, weil falsch, nimmt bei P582 = NO-VALUE auf, weil wahr, und schickt bei fehlendem P582 in Review, weil U.

## Urteilsergebnisse

- Urteilsergebnisse (`VERDICT`, `EVIDENCE`) stehen in einem anderen Dokument als der Urteilsgegenstand. Das Ergebnisdokument importiert das Zieldokument mit [IMPORT-DOC](/de/grammar/meta/import/import-doc/) und verweist mit [EXTERNAL-POINTER-*](/de/grammar/reference/external-pointer/) darauf. Deshalb ändert sich der Inhaltshash des Zieldokuments durch das Urteil nicht.
- Das Urteil über das gesamte Dokument ist das Meta `VERDICT`, das Urteil über Knoten und Records das TOULMIN-`VERDICT`.
- Auch Regeln, die die anzuwendende Fassung einer Revision wählen (Übergangsvorschriften, Wahl zwischen dem Recht zur Tatzeit und neuem Recht), sowie Auslegungsbeispiele und Urteile werden als Urteilsregeln geschrieben ([Dokument](/de/grammar/document/#revision)).

## Offene Fragen

- Layouts von SUPERSEDE-CHAIN (`0x6A`), VERDICT (`0x78`) und EVIDENCE (`0x79`). Ob die derzeitige Weise, SUPERSEDES paarweise zu schreiben, für Ketten ausreicht.
- Anordnung der Knotenstärke (Strict, Defeasible, Defeater).
- Ein ATTACKS mit ausgeschriebener Angriffskraft 1 und eines ohne Angabe urteilen gleich, unterscheiden sich aber in den Bytes. Ob zwei Urteile gleich sind, muss an den dekodierten Werten verglichen werden, nicht an den Bytes.
- Anzahl der Knoten und Labels in EXPR; der Label-Index ist 1 WORD, die Zahl der Kinder 13 Bit. Die Obergrenzen sind fest.
- Layout von PROVENANCE (Regelherkunft, Prämissen).
- Ob Backtick-Namen statt TEXT + LABEL (`0xC029`) als beschreibendes [LABEL](/de/grammar/edge/label/) bzw. [BIND](/de/grammar/edge/bind/) abgelegt werden.
- Wertetabelle der predicate- und mode-Codes einer Claim und der VerbCode-Codes einer FuncRef.
- Ob die Deklaration der geschlossenen Welt (ABSENT als empty lesen) als Beurteilungskriterium (SPEC) oder je Fall erfolgt.
- [Codec-Spezifikationsdokument](/de/grammar/codec-spec/) der TOULMIN-Codecs. Die bedingten Felder von NODE und LINK und die vom SOURCE festgelegte SPAN-Breite sind Layouts, die sich nicht als FIELD deklarieren lassen.

## Verwandte Seiten

- [NODE](/de/grammar/edge/toulmin/node/), [LINK](/de/grammar/edge/toulmin/link/), [EXPR](/de/grammar/edge/toulmin/expr/), [SOURCE und Gliederung](/de/grammar/edge/toulmin/source/)
- [Edge](/de/grammar/edge/), [Dokument](/de/grammar/document/), [PROFILE](/de/grammar/meta/declaration/profile/)
