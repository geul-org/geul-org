---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID ist ein Value fester Breite, der den 128-Bit-Wert einer UUID nach RFC 9562 enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `UUID` (BIND im Spezifikationsdokument `UUID`) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000007B0/` (DECLARE-Ziel `07B0`) |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 27 |
| Kind | Value · Familie: BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | 128-Bit-UUID nach RFC 9562 mit fester Payload von 8 WORDs |
| Hugo-Pfad | `value/binary/uuid.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | Rohwert 8 WORDs |  |  |

UUID ist ein Value fester Breite, der den 128-Bit-Wert einer UUID nach RFC 9562 enthält. Der direkte Value-Code ist `0x07BL`, die Familie BINARY. Die Payload ist genau 8 WORDs (16 Oktette, 128 Bit).

## Layout {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  insgesamt 9 WORDs
Payload           8 WORDs (128 Bit)  UUID-Oktett 0 → Oktett 15
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Oktette 0 bis 15 der kanonischen UUID nach RFC 9562 werden der Reihe nach paarweise zu je zwei Oktetten zusammengefasst. Das zuerst kommende Oktett ist die oberen 8 Bit des WORDs. Felder, Version-Bits und Variant-Bits der UUID werden weder umgeordnet noch neu kodiert.
- Die Hex-und-Bindestrich-Zeichenkette im Format `8-4-4-4-12` ist nur eine Ein-/Ausgabedarstellung. Groß-/Kleinschreibung und Bindestriche gehen nicht in die Payload ein; gespeichert werden nur die 16 Oktette des Parsing-Ergebnisses.
- Dieser UUID-Value bewahrt das 128-Bit-Muster verlustfrei. Beim RFC-9562-Variant `10xx` haben die Versionen 1, 3, 4, 5, 6 und 7 ein Standard-Layout, und Version 8 ist ein benutzerdefiniertes UUID-Format. Version 2 ist für DCE Security reserviert und hat im RFC kein festgelegtes Layout, Version 0 ist unused, und die Versionen 9–15 sind für künftige Definitionen reserviert. Auch andere Variants sind für Kompatibilität oder künftige Definitionen reserviert.
- Die Nil-UUID ist der Sonderwert mit 128 Bit aus lauter Nullen, die Max-UUID der Sonderwert mit 128 Bit aus lauter Einsen. 128-Bit-Muster mit reservierten oder unused Versionen/Variants werden strukturell ebenfalls nicht ausgeschlossen; Bedeutung und Interoperabilität solcher Muster werden anhand des geltenden Standards und des externen Kontexts beurteilt.
- Die Identität einer UUID wird danach beurteilt, ob die 128-Bit-Werte der Payload gleich sind. Dass der Wert gleich ist, garantiert weder Authentizität, Eigentum, aktuelles Vorhandensein, Auflösbarkeit noch Zugriffsrechte des Ziels.
- Beim Speichern einer Microsoft-COM-GUID wird die Mixed-Endian-Darstellung im Speicher oder in der Serialisierung nicht unverändert kopiert. Sie wird zuerst in die 16 Oktette in der kanonischen Feld-/Oktett-Reihenfolge von RFC 9562 umgewandelt.
- Ist die Payload nicht genau 8 WORDs, wird der Wert abgelehnt.

## Normative Grundlage {#표준-근거}

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) definiert eine UUID als 16 Oktette (128 Bit) und lässt die Felder most-significant-byte-first kodieren, sodass sie im Binärformat in der Big-Endian-Feldreihenfolge aneinandergereiht werden. Der Variant liegt in den oberen Bits von Oktett 8, die Version in den oberen 4 Bits von Oktett 6; dieses Format bewahrt diese Positionen unverändert.
- RFC 9562 Sections 4.1–5.10 unterscheiden Variant, die Versionen 1–8, Nil, Max und reservierte Bereiche. Da RFC 9562 RFC 4122 ersetzt, ist RFC 9562 die aktuell maßgebliche Norm dieses Formats.
- Das ABNF mit Hex und Bindestrichen in RFC 9562 ist eine Textdarstellung, und auch der Little-Endian-Vorbehalt der COM GUID wird dort gesondert genannt. GEUL legt nur die kanonischen 16 Oktette der RFC-UUID in die Payload.
- GEUL TAG, direkte Length und 16-Bit-WORD-Framing sind nicht Teil von RFC 9562, sondern Regeln, die dieses Format hinzufügt.

## Länge {#길이}

- Die Gesamtlänge ist die Summe aus TAG (1 WORD) und Payload (8 WORDs), also genau 9 WORDs, mit direkter Länge `LLLL=1000`. Length-Erweiterungs-TAG, descriptor und padding gibt es nicht.
- Ist die Payload nicht genau 8 WORDs, wird der Wert abgelehnt.

## Beispiel {#예시}

Der UUIDv7-Testvektor `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` aus RFC 9562 Appendix A.6:

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`, Payload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000007B0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
