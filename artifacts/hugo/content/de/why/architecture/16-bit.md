---
title: "Warum 16-Bit?"
weight: 17
date: 2026-02-26T12:00:04+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["16-Bit", "binaer", "Stream"]
summary: "Ein einzelnes 16-Bit-Wort ist als Einheit dreier Welten entworfen: des Netzwerkstroms, des Dateiformats und des LLM-Vokabulars. Warum 16 Bit und nicht 8, 32 oder variable Länge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Ein einziges Wort durchdringt drei Welten

---

## Drei Welten

Es gibt drei Welten in der Informatik.

**Die Welt der Netzwerke.**
Daten fliessen als Byte-Streams.
Bytes kommen ueber TCP-Sockets herein, und Bytes gehen hinaus.
Das Vokabular des Netzwerkingenieurs: Pakete, Header und Nutzlasten.

**Die Welt der Speicherung.**
Daten werden in Dateiformaten persistiert.
Auf die Festplatte geschrieben, von der Festplatte gelesen.
Das Vokabular des Speicheringenieurs: Bloecke, Offsets und Alignment.

**Die Welt der KI.**
Daten werden als Token-Sequenzen verarbeitet.
LLMs nehmen Tokens auf und produzieren Tokens.
Das Vokabular des KI-Ingenieurs: Embeddings, Attention und Kontext.

Diese drei Welten sprechen unterschiedliche Sprachen.
Und zwischen ihnen ist immer eine Uebersetzung erforderlich.

---

## Die Kosten der Uebersetzung

Verfolgen wir den Weg, den Daten in einem modernen KI-System zuruecklegen.

Wissen ist in einer Datei gespeichert. Als JSON oder Klartext.

Um dies an eine KI zu uebermitteln:

1. Die Datei oeffnen und den Text lesen.
2. Den Text parsen. Wenn es JSON ist, die Struktur interpretieren und Felder extrahieren.
3. Den extrahierten Text in einen Tokenizer einspeisen.
4. Der Tokenizer wandelt den Text in eine Sequenz von Token-IDs um.
5. Die Token-Sequenz wird in das LLM eingespeist.

Wenn die KI eine Antwort generiert:

6. Das LLM gibt eine Token-Sequenz aus.
7. Die Tokens zurueck in Text dekodieren.
8. Den Text in ein strukturiertes Format serialisieren.
9. Die serialisierten Daten in eine Datei schreiben.

Eine einfache "Lese- und Schreib"-Operation erfordert neun Schritte.

Jeder Schritt kostet Zeit.
Jeder Schritt kostet Speicher.
Jeder Schritt birgt das Risiko eines Informationsverlusts.

Die Schritte 3 und 4 -- der Tokenisierungsprozess -- sind notorisch problematisch.
Weil die Wortgrenzen natuerlicher Sprache nicht mit den Token-Grenzen des Tokenizers uebereinstimmen,
kann ein Eigenname wie "Yi Sun-sin" in willkuerliche Fragmente zerteilt werden,
oder eine einzelne semantische Einheit wird ueber mehrere Tokens verstreut.

Dies ist der Preis dafuer, dass drei Welten unterschiedliche Sprachen sprechen.

---

## Was wäre, wenn eine einzige Einheit alle drei Welten durchdringen würde?

In dieser Sprache ist ein Wort 16 Bit (2 Byte) groß.

Ein einzelnes 16-Bit-Wort ist so entworfen, dass es drei Rollen zugleich übernimmt.

**Einheit des Bytestroms.**
16-Bit-Wörter treffen in einem kontinuierlichen Strom über das Netzwerk ein.
Big Endian. Auf 2 Byte ausgerichtet.
Man liest sie einfach in der Reihenfolge ihres Eintreffens.

**Einheit des Dateiformats.**
Schreiben Sie den Strom unverändert auf die Festplatte – das ist Ihre Datei.
Lesen Sie die Bytes von der Festplatte und senden Sie sie unverändert über das Netzwerk – das ist Ihr Strom.
Keine Serialisierung. Keine Deserialisierung.

**Einheit des LLM-Vokabulars.**
16 Bit = 65.536 verschiedene Symbole.
Die Vokabulargröße moderner LLMs reicht von Zehntausenden bis zu Hunderttausenden.
GPT-2 nutzt etwa 50.000, neuere Modelle etwa 100.000 bis 200.000.
65.536 liegt innerhalb dieses Bereichs.
Ein 16-Bit-Wort ist eine Einheit in einer Größe, die ein LLM als Vokabular lernen kann.

Drei Welten teilen dieselbe Einheit.
Übersetzung nimmt ab.

---

## Der Strom ist die Datei

Sehen wir uns an, was das konkret bedeutet.

**Herkömmlicher Ansatz: 9 Schritte**

```
[Datei] -> Lesen -> Parsen -> Text extrahieren -> Tokenisieren -> [LLM]
[LLM] -> Dekodieren -> Serialisieren -> Schreiben -> [Datei]
```

**Der GEUL-Ansatz**

```
[Strom] = [Datei]                              dieselben Bytes
[Datei] -> Datensatz für Datensatz lesen,      ohne Codebuch
           überspringen
```

Einen Strom unverändert schreiben – das ist eine Datei. Eine Datei unverändert senden – das ist ein Strom.
Weder Serialisierung noch Deserialisierung.
Das erste Wort jedes Datensatzes (das TAG WORD) nennt Art und Länge,
sodass nicht benötigte Datensätze ohne Interpretation übersprungen werden.

Die LLM-Seite ist noch ein Ziel.
Ein Wort ist nicht dasselbe wie ein Token.
Ein Datensatz umfasst mehrere Wörter, und Text wird als Bytefolge getragen.
Doch wenn die Einheit auf 16 Bit festgelegt ist,
muss ein Tokenizer keine Grenzen erraten, sondern folgt bereits gegebenen Grenzen.
„Yi Sun-sin“ wird nicht an einer beliebigen Stelle zerteilt, denn es ist ein einziger Reference-Datensatz, der auf Wikidata Q50184 zeigt.

---

## Warum nicht 8-Bit?

8 Bit ergeben 256 verschiedene Symbole.

256 Symbole sind bei weitem zu wenig, um die Welt darzustellen.
Weist man das Alphabet, Ziffern und grundlegende Satzzeichen zu, ist die Haelfte des Raums bereits verbraucht.

Wenn man 8 Bit als grundlegende Einheit verwendet,
erfordern die meisten bedeutungsvollen Tokens 2 oder mehr Bytes.
Das erzwingt eine Kodierung variabler Laenge,
und variable Laenge macht das Parsen komplex.

Als Byte-Stream-Einheit ausreichend,
aber als Token-Einheit unzureichend.

---

## Warum nicht 32-Bit?

32 Bit ergeben etwa 4,3 Milliarden verschiedene Symbole.

Die Ausdruckskraft ist mehr als ausreichend.
Das Problem ist die Effizienz.

Der kleinste Datensatz dieser Sprache ist 1 Wort groß: Markierungen wie BODY und END, die aus einem einzigen TAG WORD bestehen.
Eine Reference auf Wikidata Q42 umfasst 2 Wörter,
ein einzelnes TRIPLE „Q42 ist ein Mensch“ 10 Wörter.
Bei 16-Bit-Wörtern belegt dieses TRIPLE 20 Byte, bei 32-Bit-Wörtern wären es 40.
Derselbe Datensatz wird doppelt so groß.

Auch aus Sicht des LLM gibt es ein Problem.
Ein 32-Bit-Vokabular mit 4,3 Milliarden Symbolen ist zehntausendfach größer als jedes LLM-Vokabular.
Es gibt weder die Daten noch die Modelle, um ein so großes Vokabular zu lernen.

Ein 32-Bit-Wort ist als Einheit dieser Sprache überdimensioniert.

---

## Warum nicht variable Laenge?

UTF-8 ist eine Kodierung variabler Laenge.
Die Zeichenlaenge reicht von 1 Byte bis 4 Bytes je nach Zeichen.

Dies bietet Vorteile bei der Speichereffizienz,
fuehrt aber eine fatale Schwaeche bei der Verarbeitungseffizienz ein.

Um das n-te Zeichen zu finden, muss man vom Anfang zaehlen.
Wahlfreier Zugriff ist unmoeglich.
Parallele SIMD-Verarbeitung wird schwierig.

Diese Sprache verwendet 16-Bit-Woerter fester Breite als grundlegende Einheit.
Die Position des n-ten Wortes ist immer n * 2 Bytes.
Wahlfreier Zugriff ist O(1).
SIMD kann mehrere Woerter in einer einzigen Instruktion vergleichen.
GPUs koennen Milliarden von Woertern parallel scannen.

Dennoch ist auf Datensatzebene variable Länge erlaubt.
Datensätze reichen von 1 Wort bis 2³²−1 Wörter, und die Länge steht im ersten Wort.
Die Wort-Einheit ist fest, die Datensatz-Einheit flexibel.

Die Verarbeitungseffizienz fester Breite kombiniert mit der Ausdruckskraft variabler Laenge.
Das 16-Bit-Wort erreicht beides gleichzeitig.

---

## Der Weg, den Unicode bewiesen hat

Unicode ist der erfolgreichste Kodierungsstandard, den die Menschheit geschaffen hat.

Die Grundeinheit von UTF-16 sind 16 Bit (2 Byte).
Die Zeichen der Basic Multilingual Plane (BMP) werden in einem einzigen Wort dargestellt,
alle anderen über Surrogatpaare (2 Wörter = 4 Byte) erweitert.

GEUL folgt derselben Struktur.
Häufige Formate werden als Direktcode innerhalb eines einzigen TAG WORD getragen,
seltene Formate über Erweiterungs-TAGs verlängert.

So wie Unicode alle Schriftzeichen der Welt
auf der Grundeinheit „ein Zeichen = 2 Byte“ ausdrückt,
drückt GEUL Aussagen, ihre Quellen und ihre Begründungen
auf der Grundeinheit „ein Wort = 2 Byte“ aus.

---

## Abwaertskompatibilitaet und Aufwaertserweiterung

Eine weitere Staerke von 16 Bit ist das Alignment.

16 ist ein Vielfaches von 8, ein Teiler von 32, ein Teiler von 64 und ein Teiler von 128.

Das bedeutet, dass das Alignment niemals bricht, egal in welche Richtung man erweitert.

Was wenn sich die Transformer-Architektur in Zukunft aendert
und Tokens 32 Bit werden?
Zwei 16-Bit-Woerter ergeben einen Token. Keine Alignment-Probleme.

Was ist mit 64 Bit?
Vier 16-Bit-Woerter ergeben einen Token. Immer noch keine Alignment-Probleme.

Umgekehrt: Was wenn ein eingebettetes 8-Bit-System dieses Format verarbeitet?
Einfach jedes 16-Bit-Wort als High-Byte und Low-Byte lesen.

Abwaertskompatibilitaet muss absolut aufrechterhalten werden.
Das 16-Bit-Wort garantiert dies auf physischer Ebene.

Wir koennen die Wortgroesse zukuenftiger Intelligenzen nicht vorhersagen,
aber das Vielfach-Alignment von 16 Bit garantiert Kompatibilitaet mit jeder Groesse.

---

## Die Dreifachstruktur

Fassen wir zusammen.

Ein einzelnes 16-Bit-Wort ist als Einheit dreier Welten entworfen.

| Welt | Rolle eines Wortes |
|-------|---------------------|
| Netzwerk | Einheit des Bytestroms |
| Speicher | Einheit des Dateiformats |
| KI | Einheit des LLM-Vokabulars (Ziel) |

Eine einzige Einheit durchdringt alle drei Welten.

Einen Strom unverändert speichern – das ist eine Datei.
Eine Datei unverändert senden – das ist ein Strom.
Sie Wort für Wort mit LLMs ineinandergreifen zu lassen, ist der nächste Schritt.

Weniger Konvertierung.
Weniger Übersetzung.
Weniger Verlust.

Deshalb 16 Bit.
Nicht 8, nicht 32, keine variable Länge.
Die Zahl, die genau am Schnittpunkt dreier Welten liegt.

16.
