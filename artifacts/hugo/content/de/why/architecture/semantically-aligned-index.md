---
title: "Warum ein semantisch ausgerichteter Index?"
weight: 16
date: 2026-02-26T12:00:03+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SIDX", "semantische Ausrichtung", "Index"]
summary: "Wäre eine ID Wissen statt einer Adresse, könnte eine einzige Bitoperation die Kandidaten ohne JOIN eingrenzen. Dieser Essay behandelt SIDX, den semantisch ausgerichteten Bezeichner, den GEUL erforscht, und warum seine Breite aus Nutzungsstatistiken bestimmt wird."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Was passiert, wenn eine ID Wissen ist, nicht eine Adresse

---

## Eine Adresse weiss nichts

Um Yi Sun-sin in einer Datenbank zu finden, braucht man eine ID.

In Wikidata ist Yi Sun-sins ID `Q50184`.

Diese Nummer zeigt auf Yi Sun-sin.
Aber die Zeichenkette `Q50184` selbst weiss nichts.

Sie weiss nicht, ob es sich um eine Person oder ein Gebaeude handelt.
Sie weiss nicht, ob es sich um einen Koreaner oder einen franzoesischen Staatsbuerger handelt.
Sie weiss nicht, ob es sich um eine Figur des 16. oder des 21. Jahrhunderts handelt.
Sie weiss nicht, ob diese Person lebt oder tot ist.

`Q50184` ist eine Adresse.
Ein Brieftraeger, der Post ausliefert, hat keine Ahnung, was im Umschlag steht.
Er schaut einfach auf die Adresse auf dem Umschlag und liefert.

UUID ist dasselbe. `550e8400-e29b-41d4-a716-446655440000`.
128 Bit Zufallszahlen. Einzigartig nur um Kollisionen zu vermeiden --
es sagt nichts darueber aus, worauf es sich bezieht.

Seit fuenfzig Jahren funktionieren Datenbank-IDs so.
Eine ID ist eine Adresse, und um etwas zu erfahren, muss man dieser Adresse folgen und die Daten lesen.

---

## Man muss folgen, um zu wissen

Warum ist das ein Problem?

Angenommen, Sie moechten "einen maennlichen Philosophen deutscher Staatsangehoerigkeit, geboren im 19. Jahrhundert" finden.

In einer traditionellen Datenbank funktioniert das so:

```
1. Personentabelle filtern, wo gender = 'male'
2. JOIN mit Nationalitaetentabelle und filtern country = 'Germany'
3. JOIN mit Geburtsdatentabelle und filtern year BETWEEN 1800 AND 1899
4. JOIN mit Berufstabelle und filtern occupation = 'philosopher'
```

Vier JOIN-Operationen.
Jeder JOIN vergleicht Zeilen aus zwei Tabellen.
Wenn die Tabellen gross sind, durchlaeuft man einen Index; ohne Index erfolgt ein Full Scan.
Bei einer Milliarde Datensaetze dauert dieser Prozess Sekunden bis Dutzende von Sekunden.

Warum ist es so komplex?

Weil die ID nichts weiss.
Wenn man `Q50184` betrachtet, kann man nicht erkennen, ob es sich um einen Deutschen oder einen Koreaner handelt,
also muss man eine andere Tabelle aufsuchen, um diese Information abzurufen.

Fuer jede Frage muss man der Adresse der ID folgen.
Das sind die Kosten, die Datenbanken seit fuenfzig Jahren zahlen.

---

## Was waere, wenn die ID bereits wuesste?

Kehren wir die Praemisse um.

Was waere, wenn die ID selbst die wesentlichen Informationen enthielte?

Was waere, wenn man allein durch Betrachten der ID
erkennen koennte, ob sie sich auf einen Menschen bezieht, aus welchem Land er stammt,
welcher Epoche er angehoert und wie er klassifiziert ist?

Um "einen deutschen maennlichen Philosophen des 19. Jahrhunderts" zu finden,
werden JOINs ueberfluessig.

Beim Durchscannen einer Milliarde IDs
kann man sofort feststellen, ob jede einzelne passt, indem man ihre Bits untersucht.

Das ist die Kernidee hinter dem semantisch ausgerichteten Index.

---

## Bedeutung in die ID einbetten

SIDX (Semantically-Aligned Index) ist die Forschung an einer solchen ID.
Die GEUL-Grammatik hat bereits einen Reference-Platz, der ein Ziel per SIDX bezeichnet ([GEUL-SIDX](/de/grammar/reference/geul-sidx/)).
Breite und Vergabeverfahren sind aber noch nicht entschieden. Sie werden aus gesammelten Nutzungsstatistiken bestimmt.
Im Folgenden dienen 64 Bit als Beispiel zur Erklärung.

Die Bits einer SIDX sind keine Zufallszahl.
Jeder Bitposition ist eine Bedeutung zugewiesen.

Die oberen Bits tragen die wichtigste Information.
Was für eine Entität ist das? Eine Person, ein Ort, ein Ereignis, ein Begriff?

Die nächsten Bits tragen Klassifikationsinformation.
Wenn es eine Person ist: aus welcher Epoche? Aus welcher Region?

Je weiter nach unten, desto spezifischer die Information.

Das Kernprinzip lautet:

> Die Reihenfolge der Bits ist die Reihenfolge der Wichtigkeit der Information.

Die grundlegendste Klassifikation ganz oben,
die feinsten Unterscheidungen ganz unten.

Das ist keine bloße Sortierung.
Es ist eine Designphilosophie.

---

## Von einer Milliarde auf zehntausend, in einem Durchlauf

Die praktische Stärke der SIDX zeigt sich in Zahlen.

Angenommen, es gibt eine Milliarde Entitäten, jede mit einer 64-Bit-SIDX.
Gesamtgröße: 1 Milliarde × 8 Byte = 8 GB.

Diese 8 GB passen vollständig in den Speicher.

Gesucht sind „Entitäten, die Menschen sind und aus Ostasien stammen“.
Enthalten die oberen Bits eine Markierung „Mensch“ und einen Code „Ostasien“,
genügt eine einzige Bitmaske zum Filtern.

```
mask   = 0xFF00_0000_0000_0000  (obere 8 Bit: Typ + Region)
target = 0x8100_0000_0000_0000  (Mensch + Ostasien)

for each sidx in 1_Milliarde:
    if (sidx & mask) == target:
        zu Kandidaten hinzufügen
```

Diese Operation lässt sich mit SIMD parallelisieren.
Die Grenze ist nicht die Rechenleistung, sondern die Speicherbandbreite.
In einer Vorab-Messung für [SILK](/de/projects/silk/) dauerte das Durchsuchen von 100 Millionen 128-Bit-Signaturen (1,6 GB) mit einer Maske etwa 27 Millisekunden auf 8 Go-Threads.
Bei gleicher Rate bräuchte eine Milliarde 64-Bit-SIDX (8 GB) etwas mehr als 0,1 Sekunden.

Eine Milliarde Datensätze, eingegrenzt auf zehntausend.
Die restlichen zehntausend im Detail zu filtern, geht im Nu.

Null JOINs.
Null Durchläufe durch Indexbäume.
Nur ein bitweises AND.

---

## Wie breit sollte sie sein?

Anfangs dachte ich, es brauche mehr Platz.

32 Byte (256 Bit). Ein 32-dimensionaler FP16-Vektor.
Ich versuchte, alle Schlüsselattribute einer Entität in die ID zu packen.
Mensch oder nicht, Geschlecht, Staatsangehörigkeit, Epoche, Beruf, Region, lebend oder tot, Klassifikationspfad...

Doch dann erkannte ich etwas.

**Die ID muss nicht alles wissen.**

Sie muss nur eine Milliarde Datensätze auf zehntausend eingrenzen.
Den Rest erledigt die genaue Prüfung.

Das ist wie ein Kontrollpunkt.
An einer Mautstelle muss man, um am Kennzeichen zu erkennen,
dass „dieses Fahrzeug Richtung Provinz Gyeonggi fährt“,
nicht wissen, was im Kofferraum liegt.

Also könnten 64 Bit genügen.
Mit den oberen Bits für Typ und Grobklassifikation
und den unteren für die Feinklassifikation
scheint die Eingrenzung von einer Milliarde auf zehntausend gut erreichbar.
64 Bit = vier 16-Bit-Wörter. Leicht, auch im Strom.

Aber das ist noch eine Hypothese.
GEUL legt die Breite nicht am Schreibtisch fest.
Unter Kandidaten wie 4 WORD (64 Bit) und 16 WORD wird anhand realer Nutzungsstatistiken entschieden.
Bis dahin werden Ziele über fortlaufend vergebene IDs bezeichnet,
und sobald eine SIDX vergeben ist, werden beide IDs als dasselbe Ziel verknüpft.

---

## Graceful Degradation: Bedeutung ueberlebt selbst bei abgeschnittenen Bits

Eine weitere Staerke der semantischen Ausrichtung sind ihre Degradationseigenschaften.

Weil SIDX-Bits von wichtig nach unwichtig geordnet sind,
bleibt die Kerninformation in den oberen Bits erhalten,
selbst wenn untere Bits beschaedigt oder abgeschnitten werden.

```
Volle 64 Bits:  "Yi Sun-sin, Flottenkommandant des Joseon des 16. Jahrhunderts"
48 Bits:        "Militaeroffizier des Joseon des 16. Jahrhunderts"
32 Bits:        "Ostasiatischer Mensch des 16. Jahrhunderts"
16 Bits:        "Mensch"
8 Bits:         "Physische Entitaet"
```

Wenn Information abgeschnitten wird, geht Spezifitaet verloren,
aber die grundlegendste Klassifikation ueberlebt bis zum Schluss.

Dies ist eine Bit-Level-Implementierung des "Graceful Degradation"-Prinzips.

Selbst wenn eine Netzwerkunterbrechung nur Teildaten liefert,
weiss das System "ich weiss nicht genau, wer das ist, aber es geht mindestens um einen Menschen"
und kann weiter denken.

Ein unscharfer Umriss ist besser als voellige Stille.
Teilverstaendnis ist besser als totales Versagen.

---

## Eine Abfrage wird zur ID

Die faszinierendste Möglichkeit, die ein semantisch ausgerichteter Index eröffnet:

Was, wenn sich eine Anfrage in natürlicher Sprache in eine temporäre SIDX verwandeln ließe?

Ein Nutzer fragt: „Welcher General besiegte im Imjin-Krieg die japanische Flotte?“

Der Encoder analysiert die Frage.
Mensch. Ostasien. 16. Jahrhundert. Militärisch.
Setzt man diese Attribute zu Bits zusammen, entsteht eine temporäre SIDX.

Diese temporäre SIDX durchsucht eine Milliarde SIDX.
Entitäten mit den ähnlichsten Bitmustern steigen als Kandidaten auf.
Yi Sun-sin, Won Gyun, Gwon Yul, Yi Eok-gi...

Der Abgleich detaillierter Informationen mit diesen Kandidaten liefert die endgültige Antwort.

Suche und Entitätsverknüpfung (entity linking) könnten zu einem einzigen Mechanismus werden.
Ohne eigene Suchmaschine,
ohne eigene NER-Pipeline (Named Entity Recognition),
mit einem einzigen SIDX-Vergleich.

---

## Warum kein B-Tree?

Klassische Datenbanken verwenden B-Tree-Indizes.

B-Trees finden einen bestimmten Wert in sortierten Daten hervorragend in O(log n).
Für „finde Q50184“ sind sie optimal.

Für „finde alle Entitäten, die Menschen sind und aus Ostasien stammen“ aber sind sie schwach.
Suchen mit zusammengesetzten Bedingungen erfordern die Schnittmenge mehrerer Indizes,
und deren Kosten steigen mit der Datenmenge steil an.

Der vollständige Scan aus SIDX + SIMD ist ein anderer Ansatz.

Ist ein B-Tree ein Telefonbuch, das schnell beantwortet „wer wohnt unter dieser Adresse“,
so ist ein SIDX-Scan ein Profiling, das schnell beantwortet „wer hat diese Merkmale“.

Die Art der Frage unterscheidet sich, und damit auch die optimale Datenstruktur.

| Abfragetyp | B-Tree | SIDX-Scan |
|-----------|--------|-----------|
| Suche nach bestimmter ID | O(log n), optimal | Unnötig (per Hash gelöst) |
| Filtern nach zusammengesetzten Bedingungen | JOIN nötig, langsam | Ein bitweises AND, schnell |
| Suche nach ähnlichen Entitäten | Unmöglich | Über Bitähnlichkeit möglich |
| Einfügen | O(log n), Rebalancing | O(1), anhängen |
| Implementierungsaufwand | Hoch | Niedrig |

Beide teilen sich die Arbeit, statt zu konkurrieren.
Heute beantwortet SILK exakte Abfragen wie „Dokumente mit Prädikat P106 und Objekt Q169470“ mit sortierten Läufen und binärer Suche.
Ein Scan von Bit-Signaturen als vorgeschalteter Erstfilter ist als nächster Schritt geplant.

Einfach. Brachial. Schnell.

---

## Huffmans Weisheit

Die Bitzuteilung der SIDX folgt dem Prinzip der Huffman-Kodierung.

Bei der Huffman-Kodierung erhalten häufige Symbole kurze Codes,
seltene Symbole längere.

In der SIDX belegt die am häufigsten benötigte Klassifikation die oberen Bits,
selten benötigte Details die unteren.

Die Codec-Vergabe in der GEUL-Grammatik folgt demselben Prinzip.
Formate mit bestätigter Häufigkeit erhalten einen kurzen Direktcode im TAG WORD,
seltene Formate gehen in Issuer-Formate mit Erweiterungs-TAG.

Huffmans Weisheit zieht sich durch das gesamte Design.
Die geringsten Kosten für das, was am meisten genutzt wird.

---

## Zusammenfassung

Eine traditionelle ID ist eine Adresse. Eine Adresse weiß nichts.

1. Trägt die ID keine Bedeutung, muss man ihr jedes Mal zu den Daten folgen. Das ist ein JOIN.
2. Vier JOINs über eine Milliarde Datensätze sind langsam.
3. SIDX ist die Forschung daran, Bedeutung durch semantische Ausrichtung direkt in die ID zu kodieren.
4. Ein einziges AND mit einer Bitmaske kann eine Milliarde Datensätze auf zehntausend eingrenzen. Null JOINs.
5. Die ID muss nicht alles wissen – sie muss nur die Kandidaten eingrenzen. Die Breite wird aus Nutzungsstatistiken bestimmt.
6. Weil die wichtigste Information in den oberen Bits liegt, überlebt der Kern der Bedeutung auch abgeschnittene Bits.
7. Lässt sich eine Anfrage in natürlicher Sprache in eine temporäre SIDX verwandeln, wird Suche zu einer Bitoperation.

In dem Moment, in dem eine ID aufhört, eine Adresse zu sein, und zu Wissen wird,
ändern sich die Regeln der Datenbank.
