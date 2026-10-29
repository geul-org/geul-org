---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE ist ein Beleg-Edge (Codec 0x20), das einen Record oder das gesamte Dokument mit seiner Quelle verbindet. Eigenschaften der Quelle schreibt man als TRIPLE mit der Quelle als Subject, Eigenschaften des Zitats (Abrufdatum, Stelle in der Quelle, Hash des Originals) als QUALIFIER, der an das SOURCE angehängt wird. Das SOURCE für das gesamte Dokument steht im HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE ist ein Beleg-Edge, das einen Record (das Ziel) oder das gesamte Dokument mit der Quelle verbindet, aus der es stammt. Codec `0x20`. Es ist der einzige direkte Code der Belegfamilie (`01`).

Eine Wikidata-reference (ein Bündel von Belegen) ist ein SOURCE. Hat ein Record mehrere Quellen, gibt es auch mehrere SOURCE.

## Layout

```
TAG WORD          0001 0LLL L010 0000
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Target            LOCAL-Reference-Record (im BODY die Edge Id des Edge, an das der Beleg angehängt wird; im HEAD 0 = gesamtes Dokument)
Origin            Reference-Record oder Slot-Marker 0x0000 ABSENT / 0x0001 UNKNOWN-VALUE
```

- Der Origin verweist auf die Quelle. Gibt es ein passendes Reference für die Quelle, nimmt man dieses (WIKIDATA-QID, DOC-POINTER oder EXTERNAL-ISSUER eines GEUL-Dokuments usw.), sonst einen LOCAL-Knoten dieses Dokuments.
- Beschreibt die Quellenangabe keine Quelle (z. B. eine Angabe, die nur aus Wikidata „imported from“ (P143) und Abrufdatum besteht), ist der Origin [ABSENT](/de/grammar/reference/slot-marker/) (nicht angegeben). Der Schreibende hat die Quelle lediglich nicht angegeben und behauptet nichts über sie. Der Rest der Angabe steht unverändert in den QUALIFIER.
- [UNKNOWN-VALUE](/de/grammar/reference/slot-marker/) verwendet man nur, wenn der Schreibende behauptet, „es gibt eine Quelle, aber ich weiß nicht, welche“ (von Menschen geschriebene Aufzeichnungen usw.). Ein Konverter, der aus Ausgangsmaterial überträgt, behauptet nichts, was das Original nicht sagt, und verwendet daher ABSENT.
- Ein Origin, der ABSENT oder UNKNOWN-VALUE ist, ist bei jedem Auftreten unabhängig. Die Quellen zweier SOURCE werden nicht als gleich gelesen.

## Zwei Ebenen

Die Informationen zur Herkunft gliedern sich in zwei Ebenen. Man vermischt sie nicht.

| Ebene | Was | Schreibweise | Beispiel |
|---|---|---|---|
| Quelle | Eigenschaften der Quelle selbst. Sie sind unabhängig davon, wer zitiert | [TRIPLE](/de/grammar/edge/triple/) mit der Quelle als Subject (rank normal) | URL (P854), Titel (P1476), Autor (P50/P2093), Erscheinungsdatum (P577), Publikationsorgan (P1433), Verlag (P123), Sprache (P407) |
| Zitat | Eigenschaften des Vorgangs, in dem dieser Record die Quelle zitiert | [QUALIFIER](/de/grammar/edge/qualifier/) mit der Edge Id des SOURCE als Target | Abrufdatum (P813), Stelle in der Quelle (Seite P304, Abschnitt P958, externer Identifikator P227/P1417), Herkunft (P143), Schlussfolgerungsmethode (P887), Hash des Originals (P4092) |

- **Die Bedeutung eines SOURCE ist die Gesamtheit aller QUALIFIER, die auf seine Edge Id verweisen.** Zwei Angaben, die dieselbe Quelle an verschiedenen Tagen abgerufen haben, haben dieselbe Quelle und unterschiedliche QUALIFIER.
- Ein Quellen-TRIPLE ist eine Behauptung über die Quelle. Eine Eigenschaft, bei der man die Ebene nicht festlegen kann, legt man auf die Zitat-Seite (QUALIFIER). Es ist sicherer, nichts über die Quelle zu behaupten.
- Dieselbe Quelle wird im Dokument nur einmal als ein LOCAL deklariert, und mehrere SOURCE verweisen gemeinsam darauf.
- Eine nur durch eine URL beschriebene Quelle wird mit [REFERENCE-NODE](/de/grammar/edge/reference-node/) (LOCAL → URI) definiert. Das entspricht der Art der Sitelink-Dokumentseiten.

## Interpretation und Gültigkeit

- Target und Origin sind jeweils genau ein vollständiger Record. Der Cursor nach dem Lesen des Origin muss mit dem Ende des Edge übereinstimmen.
- Das Target ist ein LOCAL Reference. Ein SOURCE im BODY verweist auf die Edge Id eines Edge im BODY desselben Dokuments. `0` (gesamtes Dokument) verwendet nur das SOURCE im HEAD ([Quelle des gesamten Dokuments](#quelle-des-gesamten-dokuments)). Ein SOURCE mit Target `0` im BODY ist invalid. Für Records anderer Dokumente hängt man den Beleg innerhalb jenes Dokuments an.
- Der Origin ist ein Reference. An Slot-Markern werden nur `0x0000` (ABSENT) und `0x0001` (UNKNOWN-VALUE) akzeptiert. NO-VALUE (`0x0002`) und Value werden nicht akzeptiert.
- Das geul.org-Spezifikationsdokument `0x0000/0x0000000000001020` (Name `source`) setzt beim Target [CODEC](/de/grammar/edge/codec/) LOCAL (`0008`) und beim Origin CODEC `0780` (beliebiges Reference), `0000` (ABSENT, optional) und `0001` (UNKNOWN-VALUE).
- Die Reihenfolge mehrerer SOURCE mit demselben Target hat keine Bedeutung. Auch die Reihenfolge der Einträge innerhalb einer Quellenangabe hat keine (die Reihenfolge der Werte derselben Eigenschaft bleibt als Dokumentreihenfolge erhalten).
- SOURCE ändert nicht, ob das Ziel wahr oder falsch ist. Es hält nur fest, woher das Ziel stammt. Urteilsergebnisse übernimmt [TOULMIN](/de/grammar/edge/toulmin/) `VERDICT`.

## Quelle des gesamten Dokuments

Die Quelle des gesamten Dokuments (Original-Dump, Fassung, Originaldatei) schreibt man im **HEAD als SOURCE mit Target `0`**. Auch die QUALIFIER, die dieses SOURCE als Target haben (Hash des Originals P4092, Empfangszeitpunkt P813, Bereich im Originaltext usw.), stehen im HEAD ([Dokument](/de/grammar/document/#head-und-body)).

- Im HEAD dürfen nur diese beiden Edges stehen. Alle anderen Edges stehen im BODY.
- Der QUALIFIER im HEAD steht hinter dem HEAD-SOURCE, auf das er verweist. Der Decoder liest von vorn und trennt dabei HEAD und BODY.
- Ein QUALIFIER, der das HEAD-SOURCE als Target hat, ist im BODY invalid. SOURCE und QUALIFIER im BODY verweisen nicht auf Edges im HEAD.
- **HEAD und BODY teilen sich einen Nummernraum für Edge Ids.** Eine Edge Id ist im Dokument eindeutig, wird wie bei anderen Edges von [NEXT-LOCAL-ID](/de/grammar/meta/lineage/next-local-id/) bezogen und bei einer Neuerzeugung mit gleichem Inhalt übernommen. Auch in einer Version, in der ein HEAD-Edge fehlt, wird seine Nummer nicht wiederverwendet.
- Ist der Origin ein LOCAL, steht dessen Definition (REFERENCE-NODE, Quellen-TRIPLE) im BODY. LOCAL gilt im gesamten Dokument.
- HEAD-Edges sind keine Meta der Verifikationsklasse und gehen daher in den [Inhaltshash](/de/grammar/document/#inhaltshash) ein. Im Diff ändern sie sich zusammen mit dem HEAD als Ganzes (sie werden nicht in `DELTA-REMOVE` aufgeführt).
- Ein eigenes Meta für die Quelle des gesamten Dokuments gibt es nicht. Bei einem als Meta geschriebenen Bereich im Originaltext oder Beschaffungszeitpunkt ließe sich bei mehreren Quellen nicht bestimmen, zu welcher Quelle er gehört. Ein an das SOURCE angehängter QUALIFIER legt das über sein Target fest.

Beispiel: HEAD eines aus einem Wikidata-Dump übertragenen Q42-Dokuments (die Edge Ids dienen nur der Erläuterung).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         Entitäts-Fassung (revision)
#1741 SOURCE     #0     #1740                                         Dump-Datei
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            Datei-Hash
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    Empfangszeitpunkt
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      Speicherzeitpunkt der Fassung
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  Permalink der Fassung
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- Fassung und Dump sind verschiedene Quellen, daher gibt es zwei SOURCE. Die Fassung ist die Quelle des Inhalts (über den Permalink lässt sich derselbe Inhalt erneut beziehen), der Dump die Datei, mit der diese Fassung empfangen wurde. Dateihash und Empfangszeitpunkt sind Eigenschaften der Zitat-Seite für die Dump-Datei und hängen deshalb am Dump-SOURCE.

## Darstellung weiterer Belege

In der Belegfamilie gibt es nur SOURCE. Andere Belege schreibt man als QUALIFIER.

| Beleg | Schreibweise | Property |
|---|---|---|
| Bereich im Originaltext | QUALIFIER am SOURCE. Ein SOURCE je Bereich | Seite P304, Abschnitt P958, Zitat P1683. Zeichenbereiche sind ein GEUL-Begriff (offen) |
| Zeitpunkt, zu dem das Ausgangsmaterial bezogen wurde | QUALIFIER am SOURCE | Abrufdatum P813 |
| Byte-Hash des Originals (Festlegung der Fassung) | QUALIFIER am SOURCE | Prüfsumme P4092, Wert z. B. [SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/) |
| Erzeugende Instanz (Mensch, Modell, Regelmaschine) | QUALIFIER am SOURCE (die Instanz, die das Zitat erstellt hat) oder am Ziel | GEUL-Begriff (offen) |
| Konfidenz | QUALIFIER am Ziel | GEUL-Begriff (offen), Wert 0~1 wie beim Meta [CONFIDENCE](/de/grammar/meta/verification/confidence/) |
| Geltungszeitraum je Artikel | QUALIFIER am Ziel | Beginn P580, Ende P582 |
| Früherer Record vor Verschiebung, Teilung, Zusammenführung | QUALIFIER am Ziel, Wert ist die alte Edge Id (LOCAL) | P1365 (replaces) |
| Version, in der etwas zuerst auftauchte | Wird nicht gespeichert. Wird aus der Versionshistorie berechnet (git blame) | |

## Beispiel (nicht normativ)

Q42 P19 (Geburtsort) Q350, Ziel-TRIPLE `#178`. Im Wikidata-Dump vom 19.10.2026 hat diese Aussage fünf Quellenangaben; drei davon werden gezeigt. ③, ein Artikel im Telegraph (`#1358`~`#1367`), hat dieselbe Form wie ②, und ⑤, Store norske leksikon (Q746368), dieselbe wie ①; sie sind deshalb weggelassen.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: nur P248, ohne Quellenbeschreibung
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② Artikel #1349 im Guardian
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: zuvor deklariertes LOCAL #1158 (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① hat keine Quellenbeschreibung, und da P248 nur eines ist, ist die Quelle dieser Eintrag. `#1347` sind TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- Eine Quelle mit nur einer URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Eine Quelle mit nur „imported from“ englische Wikipedia: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Der Origin `0x0000` ist 1 WORD.

## Offene Fragen

- GEUL-Begriffe (Begriffsdefinitionsdokument und ID) für Zeichenbereich, erzeugende Instanz und Konfidenz.
- Wenn eine Quellenbeschreibung die Quelle nicht identifiziert (Angaben, die nur eine Sprache enthalten usw.), behauptet man bei gemeinsamer Nutzung einer solchen Beschreibung als ein LOCAL, dass verschiedene Quellen gleich seien.
- Liste von Quellen- und Zitat-Eigenschaften für Quellen außerhalb von Wikidata (Gesetze, Webzitate).
- Quelle der Quelle (Kette): ob an das LOCAL der Quelle erneut ein SOURCE angehängt wird.

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [TRIPLE](/de/grammar/edge/triple/), [QUALIFIER](/de/grammar/edge/qualifier/), [REFERENCE-NODE](/de/grammar/edge/reference-node/), [Slot-Marker](/de/grammar/reference/slot-marker/)
- [Dokument](/de/grammar/document/) (HEAD und BODY), [Meta — Herkunft](/de/grammar/meta/provenance/)
