---
title: "Warum wir es leer lassen müssen"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["reserviert", "Erweiterbarkeit", "TAG WORD", "Designprinzip", "IPv4"]
summary: "GEUL lässt 75 % des Raums des 16-Bit-TAG-WORD, mit dem jeder Datensatz beginnt, leer. Die Lehren aus IPv4, Unicode und ASCII: Die Kosten des Füllens sind irreversibel, die Kosten des Leerlassens betragen drei Bit pro Datensatz."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Jeder GEUL-Datensatz beginnt mit genau einem 16-Bit-TAG-WORD. Die führenden Bits des TAG WORD teilen es in Bereiche. GEUL lässt 75 % dieses Raums leer.

```
1xx:  50%    Ferne Zukunft
01x:  25%    Nahe Zukunft
001:  12.5%  Standard
000:  12.5%  Aktuelle Grammatik (frei / Vorschlag)
```

Die gesamte aktuelle Grammatik liegt im Bereich `000`, innerhalb von 12,5 %. Wenn ein offizieller Standard startet, bleiben die übernommenen Layouts unverändert, und nur die führenden Bits wandern nach `001`. Die übrigen 75 % bleiben Generationen vorbehalten, die noch nicht geboren sind.

Warum?

---

## Die Lehre von IPv4

1981 dachten die Entwickler von IPv4, dass 32 Bit ausreichen würden. 4,3 Milliarden Adressen. Damals gab es weltweit nur einige hundert Computer. 4,3 Milliarden schienen ewig zu reichen.

2011 waren die IPv4-Adressen erschöpft.

30 Jahre. Gerade einmal 30 Jahre.

Was die Menschheit danach tun musste: NAT, CGNAT, Adresshandel, IPv6-Dual-Stack. Jahrzehnte an Kosten in Billionenhöhe. Alles wäre unnötig gewesen, „wenn man von Anfang an Platz gelassen hätte".

IPv6 wählte 128 Bit. 3,4 × 10^38 Adressen. 6,7 × 10^17 pro Quadratmeter Erdoberfläche. Diesmal genug? Wahrscheinlich. Aber selbst sie waren sich nicht sicher — deshalb wählten sie 128 Bit.

---

## Die Lehre von Unicode

1991 ging Unicode 1.0 davon aus, dass 16 Bit ausreichen würden. 65.536 Zeichen. Genug für alle Schriftsysteme der Welt, dachte man.

Es reichte nicht. CJK-Erweiterungen, Emojis, antike Schriften, Musiksymbole. Die 16-Bit-Grenze wurde überschritten.

Das Ergebnis: UTF-16-Surrogatpaare. Einer der hässlichsten Hacks der Softwaregeschichte. Windows, Java und JavaScript tragen dieses Erbe noch heute.

Unicode wurde schließlich auf 21 Bit erweitert (1.114.112 Codepunkte). Die aktuelle Nutzung liegt bei etwa 10 %. Der Rest ist leer. Diesmal hat man die Lektion gelernt.

---

## Die Lehre von ASCII

1963 verwendete ASCII 7 Bit. 128 Zeichen. Nur Englisch wurde berücksichtigt.

Das Ergebnis: 60 Jahre Encoding-Hölle für die Menschheit. EUC-KR, Shift_JIS, Big5, die ISO-8859-Reihe, CP949. Dasselbe Byte zeigte auf verschiedenen Systemen verschiedene Zeichen. Korruptes Koreanisch. Korruptes Japanisch. Fragezeichen in E-Mail-Betreffzeilen.

Ein einziges Bit mehr hätte genügt. Hätte man volle 8 Bit gesichert und gesagt „den Rest heben wir uns für später auf" — die Geschichte wäre anders verlaufen.

---

## Die Arroganz des Designers

All diese Fälle haben eines gemeinsam: **die Annahme „was wir jetzt brauchen, reicht aus".**

Waren die Entwickler von IPv4 Dummköpfe? Nein. Es waren die besten Ingenieure ihrer Zeit. Sie haben lediglich die Zukunft unterschätzt. Jede Generation hat denselben Fehler gemacht.

„640 KB sollten für jeden genug sein." Ob Bill Gates das wirklich gesagt hat, ist umstritten, aber dass Ingenieure aller Epochen in diese Falle getappt sind, steht außer Frage.

GEUL will diese Falle vermeiden. Die Methode ist einfach. **Nicht verwenden.**

---

## Aller guten Dinge sind drei

Im Deutschen sagt man: „Aller guten Dinge sind drei." Gelegenheiten kommen dreimal.

```
Erste Gelegenheit: 001 (Standard)
  Wenn Menschen einen Standard festlegen.
  Ob internationale Organisation, Industriekonsortium
  oder Community.
  Ein Raum, der in der Geschwindigkeit menschlichen
  Konsenses gefüllt wird.

Zweite Gelegenheit: 01 (Zukunft)
  Nach S1. Wenn Superintelligenz entsteht.
  Eine Entität, die Wissen auf eine Weise strukturiert,
  die Menschen nicht vorhersagen können.
  Sie könnte unsere Strukturen unverändert nutzen,
  oder sie auf eine Weise neu definieren,
  die wir uns nicht vorstellen können.
  Dieser Raum ist für diese Entität.

Dritte Gelegenheit: 1 (ferne Zukunft)
  Niemand weiß, wann.
  Vielleicht wenn K1 erreicht ist und wir eine
  interstellare Zivilisation geworden sind.
  Vielleicht wenn sich die Form des Bewusstseins
  selbst verändert hat.
  Vielleicht etwas, das wir uns heute nur als
  Science-Fiction vorstellen können.
  Wenn jemand dieses Bit von der anderen Seite
  von Orion's Arm* liest,
  gehört dieser Raum ihnen.
```

50 % für die ferne Zukunft zu reservieren bedeutet, die Hälfte aller Möglichkeiten an „das, was wir nicht wissen" abzutreten.

---

## Die Kosten des Leerlassens

Kostet es etwas, Raum leer zu lassen?

```
TAG WORD 16 Bit = 3-Bit-Bereich + 13 Bit

Die 13 Bit des aktuellen Bereichs 000:
  Kind    2 Bit   Reference · Value · Edge · Meta
  Length  4 Bit   1–14 WORD, erweitert bis 2³²−1 WORD
  Codec   7 Bit   124 Direktcodes + 4 Issuer-Formen
```

Sind 13 Bit nicht zu wenig? Nein. Ein Format, das keinen Direktcode bekommt, wird als Issuer-Format geschrieben. Jede Stelle, die Formate definiert (Issuer), hat eigene 16-Bit-Formatnummern; die Zahl der Formate ist damit praktisch unbegrenzt. Der Preis sind ein paar WORD Erweiterungs-TAG. Häufige Formate sind kurz, seltene etwas länger.

Die Kosten des Leerlassens sind drei Bit des TAG WORD pro Datensatz. Diese drei Bit halten der Zukunft das Sechsfache des heute genutzten Raums frei.

Die Kosten des Füllens? IPv4 hat es gezeigt. Sie sind irreversibel.

---

## Designprinzip

Das fünfte Designprinzip der GEUL-v1-[Grammatik](/de/grammar/overview/):

> **Leer lassen.** Der größte Teil des Bitraums bleibt der Zukunft vorbehalten. Direktcodes lassen sich nicht zurücknehmen, daher bekommen nur Formate mit bestätigter Häufigkeit einen.

Die Grammatik schreibt dieses Prinzip als Regel fest. Ein v1-Decoder weist jedes TAG WORD zurück, dessen führende Bits nicht `000` sind. Der Weg, den leeren Raum vorübergehend zu borgen, ist von Anfang an versperrt.

Dies ist keine technische Entscheidung. Es ist eine ethische.

Raum, der jetzt genutzt werden könnte, bewusst ungenutzt zu lassen, ist eine Erklärung, dass die Freiheit der Zukunft Vorrang vor der Bequemlichkeit der Gegenwart hat. Die Schuld, die uns die Generation hinterlassen hat, die IPv4 entworfen hat, werden wir der nächsten Generation nicht hinterlassen.

---

## Das bescheidenste Design

```
"Ich kenne die Zukunft" -> Alle 16 Bit nutzen.
"Ich kenne die Zukunft nicht" -> 75 % leer lassen.
```

Raum leer zu lassen ist Bescheidenheit. Es ist das Eingeständnis, dass wir die Zukunft nicht kennen können. Und diese Bescheidenheit erzeugt das robusteste Design.

IPv4 war ein Produkt der Zuversicht. 32 Bit reichen. Sie reichten nicht.

GEUL ist ein Produkt der Bescheidenheit. Wir wissen nicht, ob die heute genutzten 12,5 % ausreichen. Aber wenn wir 75 % leer lassen, ist es in Ordnung, sich zu irren.

---

*Es hat viele Worte gebraucht, um zu erklären, warum wir leer lassen. Die Handlung selbst braucht nur eine Zeile:*

```
if (bit1 == 1): reserved  // 50 %. Ferne Zukunft.
```

*Eine Zeile Code schützt die Hälfte der Welt.*

---

<small>

\* Orion's Arm — der Spiralarm der Milchstraße, zu dem unser Sonnensystem gehört. Auch der Name des [Orion's Arm Universe Project](https://www.orionsarm.com/), eines kollaborativen Hard-SF-Projekts, das eine Zukunft 10.000 Jahre nach unserer Zeit in diesem Spiralarm entwirft. Es erforscht Themen wie Superintelligenz, interstellare Zivilisationen und die Transformation des Bewusstseins mit wissenschaftlicher Strenge und wird seit dem Jahr 2000 von Hunderten von Beitragenden aufgebaut. Was GEUL die „ferne Zukunft" nennt, stellen sie sich bereits vor.

</small>
