---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS ist ein IEEE-Issuer-Format mit festen 6 WORD, das eine 48-Bit-IEEE-802-MAC-Adresse in ihrer Oktettreihenfolge unverändert enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS ist ein Value fester Breite, der den Wert einer 48-Bit-IEEE-802-MAC-Adresse enthält. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, Formatnummer `0xC000`, Familie BINARY. Der Payload ist genau 3 WORD (6 Oktette, 48 Bit).

## Layout

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  insgesamt 6 WORD
Issuer            1 WORD  0x0040 (IEEE)
Formatnummer      1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretation und Gültigkeit

- Die sechs Oktette der 48-Bit-MAC-Adresse bleiben in der Oktettreihenfolge der Schreibweise als Zeichenkette und der LAN-Übertragung. Die Oktette 0–1, 2–3 und 4–5 werden jeweils vom oberen zum unteren Oktett eines WORD gebündelt.
- Bei IEEE-802-Medien wird von jedem Oktett das least-significant bit zuerst übertragen, aber deshalb werden die Bits innerhalb eines Oktetts nicht umgedreht. I/G und U/L bleiben unverändert im least-significant bit von Oktett 0 und im nächsten Bit.
- I/G=0 ist eine individual-Adresse und wird am Ziel als unicast verwendet, I/G=1 ist eine group-Adresse und wird als multicast oder broadcast verwendet. U/L=0 ist eine universally administered, U/L=1 eine locally administered Adresse.
- Wegen I/G- oder U/L-Werten wird strukturell kein Muster ausgeschlossen. Dargestellt werden universally/locally administered sowie individual/group-Adressen, und auch locally administered, randomized, spoofed und virtuelle MAC-Adressen lassen sich als 48-Bit-Wert darstellen.
- Dieser Wert bewahrt nur die 48 Bit der beobachteten oder vorgelegten Adresse. Er garantiert weder die dauerhafte Adresse eines bestimmten Geräts, weltweite Eindeutigkeit, Geräte- oder Benutzerauthentifizierung, Eigentum noch eine dauerhafte Bindung an dasselbe Gerät.
- Dieses Format behandelt nur IEEE-802-MAC-Adressen mit genau 48 Bit. EUI-64 und andere 64-Bit-MAC-Adressen werden nicht aufgenommen. Die IEEE RA beschreibt den historischen Begriff `MAC-48` als obsolet, aber nicht jede 48-Bit-MAC-Adresse darf als EUI-48 bezeichnet werden, daher wird dieses Format nicht automatisch mit EUI-48 gleichgesetzt.
- Ist der Payload nicht genau 3 WORD, wird abgelehnt.

## Normgrundlage

- Die [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) der IEEE Registration Authority beschreiben, dass 48-Bit-LAN-MAC-Adressen als sechs Oktette in Übertragungsreihenfolge geschrieben werden, jedes Oktett beginnend mit dem least-significant bit übertragen wird und I/G und U/L die beiden least-significant bits des ersten Oktetts sind. Dieses Format bewahrt Oktette und Bitpositionen unverändert.
- Die [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) der IEEE Registration Authority definieren I/G=0/1 als individual/group und U/L=0/1 als universal/local administration und erläutern, dass lokale Adressen nicht global eindeutig sind. Sie erläutern auch das historische Begriffsverhältnis und den Unterschied von `MAC-48` und EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) erläutert, dass EUI-48 und EUI-64 als MAC-Adressen u. Ä. verwendet werden können. Das bedeutet nicht, dass EUI-64 in diesen 48-Bit-Record aufgenommen wird.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) und [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) halten fest, dass tatsächliche Geräte locally administered MAC-Adressen zufällig erzeugen und wechseln können. Deshalb schließt man aus dem MAC-Wert allein nicht auf eine dauerhafte Geräteidentität.
- GEUL-TAG, Issuer-Vergabe, direkte Length und 16-Bit-WORD-Framing sind nicht Teil von IEEE 802 oder der obigen Quellen, sondern Regeln, die dieses Format hinzufügt.

## Länge

- Insgesamt sind es genau 6 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 3 WORD Payload, mit der direkten Länge `LLLL=0101`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 3 WORD, wird abgelehnt.

## Beispiel

Die locally administered individual-(unicast-)Adresse `02:00:5e:10:00:00` (I/G=0, U/L=1 des ersten Oktetts `0x02`):

```
0afc 0040 c000 0200 5e10 0000
```
