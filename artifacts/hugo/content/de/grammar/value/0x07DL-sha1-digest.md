---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST ist ein Value fester Breite, der das vollständige SHA-1-Ergebnis enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SHA1-DIGEST` (BIND im Spezifikationsdokument `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000007D0/` (DECLARE-Ziel `07D0`) |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 29 |
| Kind | Value · Familie: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | SHA-1-Ergebnis mit fester Payload von 10 WORDs. Nur zur Identifikation, etwa für git-Objekt-IDs |
| Hugo-Pfad | `value/binary/sha1-digest.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | Rohwert 10 WORDs |  |  |

SHA1-DIGEST ist ein Value fester Breite, der das vollständige SHA-1-Ergebnis enthält. Der direkte Value-Code ist `0x07DL`, die Familie BINARY. Die Payload ist genau 10 WORDs (160 Bit); Kürzen (Truncation) ist nicht erlaubt.

**Nur zur Identifikation verwenden.** Die Kollisionsresistenz von SHA-1 ist gebrochen (2017 SHAttered). Als Grundlage für Integrität und Signaturen wird [SHA-256-DIGEST](0x07CL-sha-256-digest.md) verwendet. Dieses Format existiert, um Bezeichner unverändert aufzunehmen, die bereits durch SHA-1 festgelegt sind, vor allem die Objekt-IDs (Commit-IDs) von SHA-1-git-Repositorys. So wird zum Beispiel die Version (Commit-ID) von [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) mit 11 WORDs statt als Hex-Text (22 WORDs) abgelegt.

## Layout {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORDs  SHA-1 Digest
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die 20 Oktette der Payload werden in der Ausgabereihenfolge von SHA-1 gelesen. In jedem WORD steht das obere Oktett zuerst (dasselbe Framing wie bei SHA-256-DIGEST).
- Eine Payload, die nicht 10 WORDs hat, oder eine willkürlich gekürzte Darstellung des Ergebnisses (etwa eine abgekürzte git-ID) wird abgelehnt. descriptor und padding gibt es nicht.
- Die git-Objekt-ID ist der von git berechnete Wert unverändert. Das SHA-1 von git ist eine Variante mit Kollisionserkennung (SHA-1DC), liefert aber bei Eingaben, die keine Kollisionsangriffe sind, dasselbe Ergebnis wie SHA-1.

## Normative Grundlage {#표준-근거}

- Der SHA-1-Algorithmus und das 160-Bit-Ergebnis folgen NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt.

## Länge {#길이}

- Die Gesamtlänge ist die Summe aus TAG (1 WORD) und Payload (10 WORDs), also genau 11 WORDs, mit `LLLL=1010`. Eine Length-Erweiterung gibt es nicht.

## Beispiel {#예시}

git-Commit `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Verwandte Seiten {#관련-페이지}

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000007D0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
