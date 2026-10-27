---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID ist ein Value mit festen 9 WORD, der den 128-Bit-Wert einer UUID nach RFC 9562 unverändert in den kanonischen 16 Oktetten enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID ist ein Value fester Breite, der den 128-Bit-Wert einer UUID nach RFC 9562 enthält. Direkter Value-Code `0x60`, Familie BINARY. Der Payload ist genau 8 WORD (16 Oktette, 128 Bit).

## Layout

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  insgesamt 9 WORD
Payload           8 WORD (128 Bit)  UUID octet 0 → octet 15
```

## Interpretation und Gültigkeit

- Die kanonischen UUID-Oktette von octet 0 bis octet 15 nach RFC 9562 werden der Reihe nach zu je zwei Oktetten zusammengefasst. Das zuerst kommende Oktett sind die oberen 8 Bit des WORD. Felder, version-Bits und variant-Bits der UUID werden weder umgeordnet noch neu kodiert.
- Die Hex-und-Bindestrich-Zeichenkette `8-4-4-4-12` ist nur eine Ein-/Ausgabedarstellung. Groß-/Kleinschreibung und Bindestriche kommen nicht in den Payload, und gespeichert werden nur die 16 Oktette des Parsing-Ergebnisses.
- Dieser UUID-Value bewahrt das 128-Bit-Muster verlustfrei. Beim variant `10xx` von RFC 9562 sind die Versionen 1, 3, 4, 5, 6 und 7 Standardlayouts, und Version 8 ist ein benutzerdefiniertes UUID-Format. Version 2 ist für DCE Security reserviert, und der RFC legt kein Layout fest; Version 0 ist unused, die Versionen 9–15 sind für künftige Definitionen reserviert. Auch andere Varianten sind für Kompatibilität oder künftige Definitionen reserviert.
- Die Nil-UUID ist ein Spezialwert mit 128 Bit nur aus Nullen, die Max-UUID einer mit 128 Bit nur aus Einsen. Auch 128-Bit-Muster mit reservierten oder unused version/variant werden strukturell nicht ausgeschlossen, und Bedeutung und Interoperabilität dieser Muster beurteilt man nach dem anzuwendenden Standard und dem äußeren Kontext.
- Die Identität einer UUID wird danach beurteilt, ob die 128-Bit-Werte im Payload gleich sind. Dass der Wert gleich ist, garantiert weder Authentizität, Eigentum, aktuelles Vorhandensein, Auflösbarkeit noch Zugriffsrechte des Ziels.
- Beim Speichern einer Microsoft-COM-GUID kopiert man nicht die gemischt-endianen Speicher- oder Serialisierungsdarstellung unverändert. Man wandelt sie zuerst in die 16 Oktette in der kanonischen Feld-/Oktettreihenfolge von RFC 9562 um.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.

## Normgrundlage

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) definiert die UUID als 16 Oktette (128 Bit) und lässt die Felder mit dem most-significant-byte-first kodieren, sodass sie im Binärformat in Big-Endian-Feldreihenfolge verbunden werden. Der variant liegt in den oberen Bits von octet 8, die version in den oberen 4 Bit von octet 6, und dieses Format bewahrt diese Positionen unverändert.
- Die Abschnitte 4.1–5.10 von RFC 9562 unterscheiden variant und Versionen 1–8, Nil, Max sowie reservierte Bereiche. Da RFC 9562 RFC 4122 ersetzt, ist die maßgebliche Norm dieses Formats RFC 9562.
- Das hex-and-dash-ABNF von RFC 9562 ist eine Textdarstellung, und auch den Little-Endian-Vorbehalt der COM-GUID nennt er gesondert. GEUL legt nur die kanonischen 16 Oktette der RFC-UUID in den Payload.
- GEUL-TAG, direkte Length und 16-Bit-WORD-Framing sind nicht Teil von RFC 9562, sondern Regeln, die dieses Format hinzufügt.

## Länge

- Insgesamt sind es genau 9 WORD aus 1 WORD TAG und 8 WORD Payload, mit der direkten Länge `LLLL=1000`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.

## Beispiel

Der UUIDv7-Testvektor `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` aus RFC 9562 Appendix A.6:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
