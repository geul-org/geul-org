---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T20:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN ist ein 2-WORD-Reference, das einen Eintrag des GEUL-Token-Vokabulars bezeichnet. Werden die Bytes aufeinanderfolgender TOKEN-Records aneinandergehängt, ergibt sich der ursprüngliche Text."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | TOKEN-0 | TOKEN-1 |
|---|---|---|
| Name | `TOKEN-0` (Spezifikationsdokument BIND `TOKEN-0`) | `TOKEN-1` (Spezifikationsdokument BIND `TOKEN-1`) |
| TAG ID | `0x043L` | `0x044L` |
| Codec ID | `0x00000430` | `0x00000440` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000430/` (DECLARE-Ziel `0430`) | `0x00000000/codecs/0x00000440/` (DECLARE-Ziel `0440`) |
| Abschnitt | 2 `0010` (Reference Sonstige), Offset im Abschnitt C = 3 | 2 `0010`, C = 4 |
| Kind | Reference · Klasse: Deklaration | Reference · Klasse: Deklaration |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| Token-ID | `0`~`65.535` | `65.536`~`131.071` |
| Hugo-Seite | `reference/token.md` | `reference/token.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `token-id` | #2 | Rohwert 1 WORD |  | 60.536 ENUMs (Token-IDs `0x0000`~`0xEC77`). Z. B. `0x0000` `<0x00>`, `0x021B` 가, `0x2DE5` ` the`, `0xE75E` 한국 … |

TOKEN ist ein Reference, das einen Eintrag des GEUL-Token-Vokabulars bezeichnet. Das Vokabular ist ein BPE-Vokabular (Byte Pair Encoding), das auf Koreanisch und Englisch trainiert wurde, und ein Eintrag ist eine Bytefolge. Werden die Bytefolgen aufeinanderfolgender TOKEN-Records der Reihe nach aneinandergehängt, ergeben sich die Bytes des ursprünglichen Textes.

- Passt das Vokabular in 65.536 Einträge, wird nur TOKEN-0 verwendet. Wird es größer, kommen die überzähligen Einträge in TOKEN-1. Auch wenn TOKEN-1 nicht verwendet wird, heißt der erste Codec TOKEN-0.
- Ein Token wird als ein Record geschrieben. Da die Größe auf 2 WORD festgelegt ist, liegt der k-te Record einer Tokenfolge 4k Bytes vom Anfang entfernt.

## Layout {#레이아웃}

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, insgesamt 2 WORD
Payload WORD 1st (16 Bit)           Token-ID (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, insgesamt 2 WORD
Payload WORD 1st (16 Bit)           Token-ID − 65.536 (uint16)
```

- Code: Reference-Direktcodes `0x043L`·`0x044L` (Abschnitt 2).
- Der Payload ist die Ziel-ID. Gemäß dem [gemeinsamen Reference-Layout](_index.md) ist er eine vorzeichenlose Big-Endian-Ganzzahl in der kürzesten Breite; da die Ziel-ID immer `0`~`65.535` ist, ist der Payload immer 1 WORD (`0` ist `0x0000`).
- Es gibt keine Quantifizierung (Quantifizierung wird nur im 5Q-System gelesen).

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Ziel-ID jedes Codecs ist der Payload-Wert. Die Token-ID im gesamten Vokabular ist bei TOKEN-0 die Ziel-ID und bei TOKEN-1 65.536 + Ziel-ID.
- Die maßgebliche Darstellung eines Tokens ist das Spezifikationsdokument seines Codecs. Zu jeder Token-ID gibt es am FIELD `token-id` ein [ENUM](../edge/0x0BDL-enum.md), und der per [BIND](../edge/0x0A3L-bind.md) an diese ENUM-Edge-Id gebundene Name ist die Bytefolge des Tokens. Der ENUM-Codewert von TOKEN-1 ist der Payload-Wert (Token-ID − 65.536).
- Das Vokabular ist eine geschlossene Liste. Eine Token-ID ohne ENUM im Spezifikationsdokument ist invalid. Diese Codec-Regel hat Vorrang vor der allgemeinen ENUM-Regel („Ein nicht deklarierter Codewert ist kein Fehler“).
- **Byte-Tokens:** Die Token-IDs `0`~`255` sind je ein Byte. Die Token-ID ist der Bytewert selbst. Ein Zeichen, das nicht im Vokabular steht, etwa eines außerhalb von Koreanisch und Englisch, wird mit seinen UTF-8-Bytes als Byte-Tokens geschrieben. Der BIND-Name eines Byte-Tokens ist der Maschinenname `<0x00>`~`<0xFF>`, und seine Bedeutung legt diese Regel fest.
- **Übrige Tokens:** Die Bytefolge ist gültiges UTF-8, und der BIND-Name ist genau diese Bytefolge.
- **Dekodierung:** Die Folge der TOKEN-Records wird vom Anfang an gelesen und die Bytefolgen der einzelnen Tokens werden aneinandergehängt. Auch UTF-8-Zeichen, die aus aufeinanderfolgenden Byte-Tokens bestehen, werden durch dieses Aneinanderhängen wiederhergestellt. Das Ergebnis ist bis aufs Byte identisch mit dem Text vor der Kodierung.
- **Kodierung:** Wie Text in eine Tokenfolge zerlegt wird (Zerlegungsregel und Merge-Reihenfolge), hängt von der Vokabularfassung ab. Derselbe Text kann bei einer anderen Vokabularfassung eine andere Tokenfolge ergeben. Das Dekodierungsergebnis ist unabhängig von der Fassung gleich.
- **Fassung:** Die Vokabularfassung ist die Version des Spezifikationsdokuments. Jede Fassung vermerkt die Hashes der Vokabulardatei und des Trainingsprotokolls als [SOURCE](../edge/0x0C0L-source.md) im HEAD des Spezifikationsdokuments. Muss die Fassung genannt werden, die eine Tokenfolge erzeugt hat, wird ihre Version ([CODEC-POINTER](0x042L-codec-pointer.md) (`0x00000000`, `0x00000430`, Versions-ID `n`)) mit angegeben.
- **Nur anhängen:** Eine neue Fassung hängt ENUMs und BINDs nur hinten an. Die Bytefolge einer einmal vergebenen Token-ID wird weder geändert noch gelöscht noch neu geschrieben. Daher ist jede Fassung eine Obermenge der vorigen, und eine mit einer früheren Fassung erzeugte Tokenfolge wird mit einer späteren genauso dekodiert. Wird das Vokabular von Grund auf neu trainiert und ändern sich die Bedeutungen, wird dieser Codec nicht verwendet, sondern eine neue Codec-Nummer vergeben.
- Da ein Token ein Reference ist, kann es Subjekt von [BIND](../edge/0x0A3L-bind.md), [LABEL](../edge/0x0A4L-label.md) und [TRIPLE](../edge/0x0AAL-triple.md) sein (z. B. die Auftretenshäufigkeit eines Tokens, die Sprache).

## Länge {#길이}

- Die Gesamtlänge ist die Summe aus TAG (1 WORD) und Payload (1 WORD), also genau 2 WORDs, mit direkter Länge `LLLL=0001`. Length-Erweiterungs-TAG, Codec-Erweiterungs-TAG und Codec-spezifischer TAG gibt es nicht.
- Ist der Payload nicht genau 1 WORD, wird der Record abgelehnt.

## Beispiel {#예시}

Nummern von Vokabularfassung 1 (Spezifikationsdokument `0x00000000/codecs/0x00000430` Version 1). Zugewiesen wurden 60.536 Tokens: Bytes 256, Grundzeichen 283 (Leerzeichen·Zeilenumbruch·Tabulator, ASCII, Hangul-Jamo, Symbole), Hangul-Silben 11.172 (`0x021B` 가 ~ `0x2DBE` 힣), Merges 48.825. `0xEC78`~`0xFFFF` bleibt für Ergänzungen frei.

| Token (Bytefolge) | Token-ID | Vollständige WORDs |
|---|---|---|
| Byte `0xE3` | `0x00E3` | `0431 00E3` |
| `가` | `0x021B` | `0431 021B` |
| ` the` (mit vorangestelltem Leerzeichen) | `0x2DE5` | `0431 2DE5` |
| ` GEUL` (mit vorangestelltem Leerzeichen) | `0x377F` | `0431 377F` |
| `한국어` | `0xD0B8` | `0431 D0B8` |

- Im Spezifikationsdokument ist ` the` das `ENUM #2 0x2DE5` mit dem an seine Edge Id gebundenen `BIND " the"`.
- Das Leerzeichen hängt am folgenden Wort. Darum sind ` the` und `the` (`0x328D`) verschiedene Tokens.

## Offene Probleme {#열린-문제}

- Das Format, in dem eine Tokenfolge im Dokument steht. Es ist nicht festgelegt, welches Edge- oder Value-Feld eine Folge von TOKEN-Records aufnimmt.
- Kanonische Form der Kodierung. Wie Zerlegungsregel und Merge-Reihenfolge im Spezifikationsdokument zu notieren sind und ob die Tokenfolge für denselben Text eindeutig festgelegt wird.
- Interpretation zwischen Fassungen. Wenn der Leser eine Token-ID antrifft, die neuer ist als seine Fassung: ob sie als invalid verworfen oder mit erhaltenem Rohwert als „unbekanntes Token“ behandelt wird.

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [CODEC-POINTER](0x042L-codec-pointer.md)
- [Codec-Spezifikationsdokument](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)
- Registry gleicher Form: [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000430/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben). Die beiden SOURCEs im HEAD sind die SHA-256 der Vokabulardatei und des Trainingsprotokolls.

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000043000000000
#121077 SOURCE #0 ABSENT
#121078 QUALIFIER P4092 #121077 SHA-256-DIGEST(0xE4DEEA8BA9FE74BEAAD836FEBE06CF4DAC32B30D1E9A85308D0A6E0A9CB6A417)
#121079 SOURCE #0 ABSENT
#121080 QUALIFIER P4092 #121079 SHA-256-DIGEST(0x5B2C82701BCFFD3589DC9640B398B3F07F0AC7F18E483486AF5221C3D30D4D9C)
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "token-id"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
#7 ENUM #2 0x0001
#8 BIND #7 "<0x01>"
… (121.064 Zeilen ENUM·BIND ausgelassen)
#121073 ENUM #2 0xEC76
#121074 BIND #121073 "etap"
#121075 ENUM #2 0xEC77
#121076 BIND #121075 " Aman"
```
