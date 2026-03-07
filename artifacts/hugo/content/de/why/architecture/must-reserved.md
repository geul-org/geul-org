---
title: "Warum wir es leer lassen müssen"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["reserviert", "Erweiterbarkeit", "64-Bit", "Designprinzip", "IPv4"]
summary: "GEUL lässt 75% seines 64-Bit-Raums leer. Die Lehren aus IPv4, Unicode und ASCII zeigen: Die Kosten des Füllens sind unumkehrbar, aber die Kosten des Leerlassens sind null."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

64 Bit bedeuten 18.446.744.073.709.551.616 Adressen. 18,4 Trillionen. GEUL lässt davon 75 % leer.

```
bit1 = 1:    50%    ferne Zukunft
bit1-2 = 01: 25%    nahe Zukunft
bit1-3 = 001: 12.5% Standard
bit1-4 = 0001: 6.25% aktueller Vorschlag
```

Der aktuell genutzte Raum beträgt 6,25 %. Von den verbleibenden 93,75 % werden 12,5 % verwendet, wenn der Standard festgelegt wird, und 75 % bleiben für Generationen reserviert, die noch nicht geboren sind.

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

Kostet das Leerlassen etwas?

```
75 % reserviert bei 64 Bit = 48 Bit ungenutzt.
Die verbleibenden 16 Bit (6,25 %) = 1.152.921.504.606.846.976 Adressen.

11,5 Trillionen.
Das 10-Millionenfache von ganz Wikidata (108 Millionen Einträge).
Genug, um alle existierenden Daten aufzunehmen und noch Platz übrig zu haben.
```

Leerlassen verursacht keinen Mangel. 6,25 % reichen für den aktuellen Bedarf. Die Kosten des Leerlassens sind null.

Die Kosten des Füllens? IPv4 hat es gezeigt. Unumkehrbar.

---

## Designprinzip

Artikel 1 der Designprinzipien von GEUL Grammar v0.11:

> **Langfristige Erweiterbarkeit:** Reservierte Bits nicht für temporäre Zwecke zweckentfremden. Den Raum bewahren, den künftige Generationen nutzen werden.

Das ist keine technische Entscheidung. Es ist eine ethische Entscheidung.

Verfügbaren Raum heute nicht zu nutzen bedeutet, die Freiheit der Zukunft über den Komfort der Gegenwart zu stellen. Es bedeutet, die Schuld, die uns die IPv4-Generation hinterlassen hat, nicht an die nächste Generation weiterzugeben.

---

## Das bescheidenste Design

```
"Ich kenne die Zukunft" → alle 64 Bit verwenden.
"Ich kenne die Zukunft nicht" → 75 % leer lassen.
```

Leerlassen ist Bescheidenheit. Es ist das Eingeständnis, dass wir heute die Zukunft nicht kennen können. Und diese Bescheidenheit erzeugt das robusteste Design.

IPv4 war ein Produkt des Selbstvertrauens. 32 Bit reichen. Sie reichten nicht.

GEUL ist ein Produkt der Bescheidenheit. Reichen 6,25 % von 64 Bit? Wir wissen es nicht. Aber wenn wir 75 % leer lassen, ist es nicht schlimm, selbst wenn wir falsch liegen.

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
