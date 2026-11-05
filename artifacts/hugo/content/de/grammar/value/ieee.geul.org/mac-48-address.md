---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS ist ein Value fester Breite, der einen 48-Bit-IEEE-802-MAC-Adresswert enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS ist ein Value fester Breite, der einen 48-Bit-IEEE-802-MAC-Adresswert enthält. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, Codec-Nummer `0x0000C000`, Familie BINARY. Der Payload umfasst genau 3 WORD (6 Octets, 48 Bit).

## Layout {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  insgesamt 8 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec-Nummer      2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die sechs Octets der 48-Bit-MAC-Adresse bleiben in der Octet-Reihenfolge der Schreibweise und der LAN-Übertragung. Die Octets 0–1, 2–3 und 4–5 werden jeweils vom oberen zum unteren Octet eines WORD zusammengefasst.
- In IEEE-802-Medien wird je Octet das Least-Significant-Bit zuerst übertragen, doch deswegen werden die Bits innerhalb eines Octets nicht umgekehrt. I/G und U/L bleiben unverändert im Least-Significant-Bit und im nächsten Bit von octet 0.
- I/G=0 ist eine Individualadresse und wird am Ziel als Unicast verwendet, I/G=1 ist eine Gruppenadresse und wird als Multicast oder Broadcast verwendet. U/L=0 ist eine universally administered Adresse, U/L=1 eine locally administered Adresse.
- Aufgrund der Werte von I/G oder U/L wird strukturell kein Muster ausgeschlossen. Universally/locally administered sowie Individual-/Gruppenadressen sind alle darstellbar, und auch locally administered, randomized, spoofed und virtuelle MAC-Adressen lassen sich als 48-Bit-Wert darstellen.
- Dieser Wert bewahrt nur die 48 Bit der beobachteten oder vorgelegten Adresse. Er garantiert weder die permanente Adresse eines bestimmten Geräts noch weltweite Eindeutigkeit, Geräte- oder Nutzerauthentifizierung, Eigentum oder dauerhafte Bindung an dasselbe Gerät.
- Dieses Format behandelt nur IEEE-802-MAC-Adressen von genau 48 Bit. EUI-64 und andere 64-Bit-MAC-Adressen werden nicht aufgenommen. Die IEEE RA beschreibt den historischen Begriff `MAC-48` als obsolet, doch nicht jede 48-Bit-MAC-Adresse darf EUI-48 genannt werden; dieses Format wird daher nicht automatisch mit EUI-48 gleichgesetzt.
- Hat der Payload nicht genau 3 WORD, wird er abgelehnt.

## Normgrundlage {#표준-근거}

- Die [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) der IEEE Registration Authority notieren die 48-Bit-LAN-MAC-Adresse als sechs Octets in Übertragungsreihenfolge und erläutern, dass jedes Octet ab dem Least-Significant-Bit übertragen wird und I/G und U/L die beiden Least-Significant-Bits des ersten Octets sind. Dieses Format bewahrt Octet- und Bit-Positionen unverändert.
- Die [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) der IEEE Registration Authority definieren I/G=0/1 als Individual/Group und U/L=0/1 als Universal/Local Administration und erläutern, dass Local-Adressen nicht global eindeutig sind. Sie erläutern auch das historische Begriffsverhältnis und den Unterschied zwischen `MAC-48` und EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) erläutert, dass EUI-48 und EUI-64 unter anderem als MAC-Adressen verwendet werden können. Das bedeutet nicht, dass EUI-64 in diesen 48-Bit-Record aufgenommen wird.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) und [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) halten fest, dass reale Geräte locally administered MAC-Adressen zufällig erzeugen und wechseln können. Aus dem MAC-Wert allein wird daher keine dauerhafte Geräte-Identity abgeleitet.
- GEUL-TAG, Issuer-Zuweisung, direkte Length und 16-Bit-WORD-Framing sind keine Bestandteile von IEEE 802 oder der obigen Quellen, sondern Regeln, die dieses Format hinzufügt.

## Länge {#길이}

- Die Gesamtlänge ist genau 8 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 3 WORD Payload; verwendet wird die direkte Länge `LLLL=0111`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 3 WORD, wird er abgelehnt.

## Beispiel {#예시}

Die locally administered Individualadresse (Unicast) `02:00:5e:10:00:00` (I/G=0, U/L=1 des ersten Octets `0x02`):

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
