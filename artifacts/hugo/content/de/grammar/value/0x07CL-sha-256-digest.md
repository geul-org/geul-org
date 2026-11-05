---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST ist ein Value fester Breite, der das vollständige Ergebnis von SHA-256 aus der SHA-2-Familie enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SHA-256-DIGEST` (BIND im Spezifikationsdokument `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000007C0/` (DECLARE-Ziel `07C0`) |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 28 |
| Kind | Value · Familie: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | SHA-256-Ergebnis mit fester Payload von 16 WORDs |
| Hugo-Pfad | `value/binary/sha-256-digest.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | Rohwert 16 WORDs |  |  |

SHA-256-DIGEST ist ein Value fester Breite, der das vollständige Ergebnis von SHA-256 aus der SHA-2-Familie enthält. Der direkte Value-Code ist `0x07CL`, die Familie BINARY. Die Payload ist genau 16 WORDs (256 Bit); Kürzen (Truncation) ist nicht erlaubt.

## Layout {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
Length-Erweiterungs-TAG   1 WORD  0x0012 (insgesamt 18 WORDs)
Payload           16 WORDs  SHA-256 Digest
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die 32 Oktette der Payload werden in der Ausgabereihenfolge von SHA-256 gelesen. In jedem WORD steht das obere Oktett zuerst.
- Auf den Digest-Bitstring wird keine gesonderte GEUL-Endian-Umwandlung angewendet. Die Oktettfolge der Ausgabe wird lediglich der Reihe nach paarweise zu 16-Bit-Big-Endian-WORDs gerahmt.
- Eine Payload, die nicht 16 WORDs hat, oder eine willkürlich gekürzte Darstellung des Ergebnisses wird abgelehnt. descriptor und padding gibt es nicht.

## Normative Grundlage {#표준-근거}

- Der SHA-256-Algorithmus und das 256-Bit-Ergebnis folgen NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG, Length und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt, und kein Teil des SHA-2-Algorithmus.

## Länge {#길이}

- Die Gesamtlänge ist die Summe aus TAG (1 WORD), Length-Erweiterungs-TAG (1 WORD) und Payload (16 WORDs), also genau 18 WORDs, mit `LLLL=1110`. descriptor und padding gibt es nicht.
- Ist die Payload nicht genau 16 WORDs, wird der Wert abgelehnt.

## Beispiel {#예시}

- Die Digest-Oktette `d[0]` bis `d[31]` werden der Reihe nach als Payload-WORDs `(d[0]<<8)|d[1]` bis `(d[30]<<8)|d[31]` abgelegt. Die Gesamt-Length beträgt immer 18 WORDs.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000007C0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
