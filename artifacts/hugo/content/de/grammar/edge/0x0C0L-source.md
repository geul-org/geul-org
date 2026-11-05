---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE ist ein Beleg-Edge, der einen einzelnen Record (das Target) oder ein ganzes Dokument mit der Quelle verbindet, aus der es stammt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SOURCE` (Spezifikationsdokument BIND `SOURCE`) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000C00/` (DECLARE-Ziel `0C00`) |
| Abschnitt | 6 `0110` (Edge-Beleg), Offset im Abschnitt C = 0 |
| Kind | Edge · Familie: Beleg |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Verbindet einen einzelnen Record oder ein ganzes Dokument mit seiner Quelle. Target (BODY: Edge Id, HEAD: `0` = ganzes Dokument), Origin (Reference, ABSENT oder UNKNOWN-VALUE). Die Eigenschaften der Quelle stehen in einem TRIPLE mit der Quelle als Subject, die Eigenschaften der Zitierung (Abrufdatum, Stelle, Hash des Originaltexts) in einem QUALIFIER, der an das SOURCE gehängt wird. Das SOURCE für das ganze Dokument und sein QUALIFIER stehen im HEAD |
| Hugo-Seite | `edge/source.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | Record | `0050` LOCAL |  |
| 2 | `origin` | #3 | Record | `000F` ganzer Abschnitt 0 (Wildcard, Reference), `020F` ganzer Abschnitt 1 (Wildcard, Reference), `040F` ganzer Abschnitt 2 (Wildcard, Reference), `0010` UNKNOWN-VALUE, `0000` ABSENT (optionales Feld) |  |

SOURCE ist ein Beleg-Edge, der einen einzelnen Record (das Target) oder ein ganzes Dokument mit der Quelle verbindet, aus der es stammt. Codec `0x0C0L`. Es ist der einzige direkte Code der Belegfamilie (`01`).

Eine Wikidata-Reference (ein Bündel von Herkunftsangaben) ergibt genau ein SOURCE. Hat ein Record mehrere Herkunftsangaben, gibt es entsprechend mehrere SOURCE.

## Layout {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Target            LOCAL-Reference-Record (im BODY die Edge Id des Edge, an den der Beleg gehängt wird; im HEAD 0 = ganzes Dokument)
Origin            Reference-Record oder Slot-Marker 0x0000 ABSENT · 0x0010 UNKNOWN-VALUE
```

- Origin zeigt auf die Quelle. Gibt es eine passende Reference für die Quelle, wird diese verwendet (WIKIDATA-QID, DOC-POINTER oder EXTERNAL-ISSUER eines GEUL-Dokuments usw.), andernfalls ein LOCAL-Knoten dieses Dokuments.
- Beschreibt die Herkunftsangabe die Quelle nicht (z. B. eine Herkunftsangabe in Wikidata, die nur „imported from“ (P143) und ein Abrufdatum enthält), ist Origin [ABSENT](../slot-marker.md) (nicht angegeben). Der Schreibende hat die Quelle lediglich nicht angegeben und behauptet über sie nichts. Der Rest der Herkunftsangabe bleibt unverändert im QUALIFIER.
- [UNKNOWN-VALUE](../slot-marker.md) wird nur verwendet, wenn der Schreibende behauptet, dass es eine Quelle gibt, er aber nicht weiß, welche (etwa bei von Menschen geschriebenen Aufzeichnungen). Ein Konverter, der aus Quelldaten übernimmt, behauptet nichts, was die Quelldaten nicht sagen, und verwendet daher ABSENT.
- Ein Origin mit ABSENT oder UNKNOWN-VALUE ist bei jedem Auftreten unabhängig. Die Quellen zweier SOURCE werden nicht als gleich gelesen.

## Zwei Schichten {#두-층}

Die Informationen zur Herkunft zerfallen in zwei Teile. Sie werden nicht vermischt.

| Schicht | Was | Schreibweise | Beispiel |
|---|---|---|---|
| Quelle | Eigenschaften der Quelle selbst. Sie sind unabhängig davon, wer zitiert | [TRIPLE](0x0AAL-triple.md) mit der Quelle als Subject (rank normal) | URL (P854), Titel (P1476), Autor (P50 · P2093), Veröffentlichungsdatum (P577), Publikationsorgan (P1433), Herausgeber (P123), Sprache (P407) |
| Zitierung | Eigenschaften des Akts, mit dem dieser Record die Quelle zitiert | [QUALIFIER](0x0ABL-qualifier.md) mit der Edge Id des SOURCE als Target | Abrufdatum (P813), Stelle innerhalb der Quelle (Seite P304, Abschnitt P958, externe Kennungen P227 · P1417), Herkunftsort (P143), Schlussfolgerungsmethode (P887), Hash des Originaltexts (P4092) |

- **Die Bedeutung eines SOURCE ist die Gesamtheit aller QUALIFIER, die auf seine Edge Id zeigen.** Zwei Herkunftsangaben, die dieselbe Quelle an verschiedenen Tagen abgerufen haben, haben dieselbe Quelle, aber verschiedene QUALIFIER.
- Ein Quellen-TRIPLE ist eine Aussage über die Quelle. Eine Eigenschaft, die sich keiner der beiden Schichten sicher zuordnen lässt, kommt auf die Zitierungsseite (QUALIFIER). Es ist sicherer, über die Quelle nichts zu behaupten.
- Dieselbe Quelle wird innerhalb eines Dokuments nur einmal als ein LOCAL deklariert, auf das mehrere SOURCE gemeinsam zeigen.
- Eine Quelle, die nur durch eine URL beschrieben wird, wird als [REFERENCE-NODE](0x0A0L-reference-node.md) (LOCAL → URI) definiert. Das entspricht dem Vorgehen bei der Dokumentseite eines Sitelinks.

## Interpretation und Gültigkeit {#해석과-유효성}

- Target und Origin sind jeweils genau ein vollständiger Record. Der Cursor nach dem Lesen von Origin muss mit dem Ende des Edge übereinstimmen.
- Target ist eine LOCAL-Reference. Ein SOURCE im BODY zeigt auf die Edge Id eines Edge im BODY desselben Dokuments. `0` (ganzes Dokument) verwendet nur das SOURCE im HEAD ([Herkunft des ganzen Dokuments](#문서-전체의-출처)). Ein SOURCE mit Target `0` im BODY ist invalid. Für Records eines anderen Dokuments wird der Beleg innerhalb jenes Dokuments angehängt.
- Origin ist eine Reference. Als Slot-Marker werden nur `0x0000` (ABSENT) und `0x0010` (UNKNOWN-VALUE) akzeptiert. NO-VALUE (`0x0020`) und Value werden nicht akzeptiert.
- Das geul.org-Spezifikationsdokument `0x00000000/codecs/0x00000C00` (Name `source`) legt für Target den [CODEC](0x0BEL-codec.md) LOCAL (`0050`) fest, für Origin die CODEC `000F` · `020F` · `040F` (beliebige Reference), `0000` (ABSENT, optional) und `0010` (UNKNOWN-VALUE).
- Die Reihenfolge mehrerer SOURCE zum selben Target hat keine Bedeutung. Auch die Reihenfolge der Einträge innerhalb einer Herkunftsangabe hat keine Bedeutung (die Reihenfolge der Werte derselben Eigenschaft bleibt als Dokumentreihenfolge erhalten).
- SOURCE ändert nichts an Wahrheit oder Falschheit des Targets. Es hält nur fest, woher das Target stammt. Das Ergebnis einer Beurteilung liegt bei [TOULMIN](../toulmin/_index.md) `VERDICT`.

## Herkunft des ganzen Dokuments {#문서-전체의-출처}

Die Quelle des ganzen Dokuments (Original-Dump, Ausgabe, Originaltextdatei) wird als **SOURCE mit Target `0` im HEAD** geschrieben. Auch die QUALIFIER, die dieses SOURCE als Target haben (Hash des Originaltexts P4092, Empfangszeitpunkt P813, Bereich im Originaltext usw.), stehen im HEAD ([Dokument](../document.md#head와-body)).

- Im HEAD dürfen nur diese beiden Edge stehen. Alle anderen Edge stehen im BODY.
- Ein QUALIFIER im HEAD steht hinter dem HEAD-SOURCE, auf das er zeigt. Der Decoder liest von vorn und trennt dabei HEAD und BODY.
- Ein QUALIFIER, der auf ein HEAD-SOURCE zeigt, ist im BODY invalid. SOURCE und QUALIFIER im BODY zeigen nicht auf Edge im HEAD.
- **HEAD und BODY teilen sich einen Nummernraum für die Edge Id.** Sie ist innerhalb des Dokuments eindeutig, wird wie bei den anderen Edge von [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) vergeben, und bei einer Neuerzeugung mit gleichem Inhalt wird dieselbe Nummer übernommen. Auch in einer Version, in der ein HEAD-Edge fehlt, wird seine Nummer nicht wiederverwendet.
- Ist Origin ein LOCAL, stehen dessen Definitionen (REFERENCE-NODE, Quellen-TRIPLE) im BODY. Der Geltungsbereich eines LOCAL ist das ganze Dokument.
- HEAD-Edge sind keine Meta der Verifikationsklasse und gehen daher in den [Inhaltshash](../document.md#내용-해시) ein. Im diff ändern sie sich zusammen mit dem HEAD als Ganzes (sie werden nicht in `DELTA-REMOVE` eingetragen).
- Für die Herkunft des ganzen Dokuments gibt es kein eigenes Meta. Bei einem als Meta geschriebenen Bereich im Originaltext oder Beschaffungszeitpunkt lässt sich bei mehreren Quellen nicht festlegen, auf welche Quelle er sich bezieht. Ein QUALIFIER, der an das SOURCE gehängt wird, legt das über sein Target fest.

Beispiel: der HEAD eines aus einem Wikidata-Dump übernommenen Dokuments zu Q42 (die Edge Id dient nur der Erläuterung).

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         Entitätsrevision (revision)
#1741 SOURCE     #0     #1740                                         Dump-Datei
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            Datei-Hash
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    Empfangszeitpunkt
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      Speicherzeitpunkt der Revision
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  Permalink der Revision
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- Revision und Dump sind verschiedene Quellen, daher gibt es zwei SOURCE. Die Revision ist die Quelle des Inhalts (über den Permalink lässt sich derselbe Inhalt erneut beziehen), der Dump ist die Datei, in der diese Revision empfangen wurde. Datei-Hash und Empfangszeitpunkt sind Eigenschaften der Zitierungsseite zur Dump-Datei und werden deshalb an das Dump-SOURCE gehängt.

## Darstellung anderer Belege {#다른-근거의-표현}

Die Belegfamilie enthält nur SOURCE. Andere Belege werden als QUALIFIER geschrieben.

| Beleg | Schreibweise | Property |
|---|---|---|
| Bereich im Originaltext | QUALIFIER am SOURCE. Ein SOURCE pro Bereich | Seite P304, Abschnitt P958, Zitat P1683. Zeichenbereich: GEUL-Begriff (offen) |
| Zeitpunkt des Empfangs der Quelldaten | QUALIFIER am SOURCE | Abrufdatum P813 |
| Byte-Hash des Originaltexts (Festlegung der Ausgabe) | QUALIFIER am SOURCE | Prüfsumme P4092, Wert z. B. [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) |
| Erzeuger (Mensch, Modell, Regel-Engine) | QUALIFIER am SOURCE (Erzeuger der Zitierung) oder am Target | GEUL-Begriff (offen) |
| Verlässlichkeit | QUALIFIER am Target | GEUL-Begriff (offen), Wert wie bei Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) von 0 bis 1 |
| Geltungszeitraum je Artikel | QUALIFIER am Target | Beginn P580, Ende P582 |
| Alter Record vor Verschiebung, Teilung oder Zusammenführung | QUALIFIER am Target, Wert ist die alte Edge Id (LOCAL) | P1365 (replaces) |
| Version, in der er zuerst auftrat | wird nicht gespeichert. Wird aus dem Versionsverlauf berechnet (git blame) | |

## Beispiel (nicht normativ) {#예시-비규범}

Q42 P19 (Geburtsort) Q350, Ziel-TRIPLE `#178`. Im Wikidata-Dump vom 2026-10-19 hat diese Aussage fünf Herkunftsangaben, davon werden drei gezeigt. ③ der Telegraph-Artikel (`#1358` bis `#1367`) hat dieselbe Form wie ②, ⑤ Store norske leksikon (Q746368) dieselbe wie ①, daher wurden sie weggelassen.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: keine Quellenbeschreibung, nur ein P248
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② Guardian-Artikel #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: das zuvor deklarierte LOCAL #1158 (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- Bei ① gibt es keine Quellenbeschreibung und nur ein P248, daher ist die Quelle dieser Eintrag. `#1347` besteht aus TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `0C07`.

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- Herkunftsangabe nur mit einer URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Herkunftsangabe nur mit „imported from“ der englischen Wikipedia: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` ist 1 WORD.

## Offene Probleme {#열린-문제}

- GEUL-Begriffe für Zeichenbereich, Erzeuger und Verlässlichkeit (Begriffsdefinitionsdokument und ID).
- Wenn die Quellenbeschreibung die Quelle nicht identifiziert (etwa eine Herkunftsangabe, die nur die Sprache enthält), würde das gemeinsame Verwenden derselben Beschreibung durch ein einziges LOCAL behaupten, dass verschiedene Quellen gleich sind.
- Eine Liste von Quellen- und Zitierungs-Properties für Herkunftsangaben außerhalb von Wikidata (Gesetze, Web-Zitate).
- Herkunft der Herkunft (Kette): ob an das Quellen-LOCAL wiederum ein SOURCE gehängt werden soll.

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [QUALIFIER](0x0ABL-qualifier.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [Slot-Marker](../slot-marker.md)
- [Dokument](../document.md) (HEAD und BODY), [Meta — Herkunft](../meta/_index.md#출처)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000C00/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
