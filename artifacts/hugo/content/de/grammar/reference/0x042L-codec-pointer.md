---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER ist ein zeigend-deklarierendes Reference, das eine Version eines vom Issuer veröffentlichten Codec-Dokuments bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER ist ein zeigend-deklarierendes Reference, das eine Version eines vom Issuer veröffentlichten Codec-Dokuments bezeichnet. Ein Codec-Dokument hat keine Dokument-ID und bezeichnet sich selbst und seine Version mit CODEC-POINTER.

| Eintrag | Wert |
|---|---|
| Name | `CODEC-POINTER` (Spezifikationsdokument BIND `CODEC-POINTER`) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000420/` (DECLARE-Ziel `0420`) |
| Abschnitt | 2 `0010` (Reference Sonstige), Offset im Abschnitt C = 2 |
| Kind | Reference · Klasse: Zeigen-und-Deklarieren |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Eine Version eines Issuer-Codecs. Issuer + Codec ID 2 WORD + Versions-ID 2 WORD, keine Ziel-ID |
| Hugo-Seite | `reference/codec-pointer.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | Rohwert 2 WORD |  |  |
| 3 | `version` | #4 | Rohwert 2 WORD |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[Length-Erweiterungs-TAG]
Issuer            2/4/16 WORD
Codec ID          2 WORD
Versions-ID       2 WORD
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Breite des Issuer ist der Rest des Payloads nach Abzug der 4 WORD für Codec ID und Versions-ID. Der Payload hat 6, 8 oder 20 WORD; jede andere Länge ist invalid. Passt der Issuer-Wert in eine schmalere Breite, ist es invalid (Issuer-Normalform).
- Bei einem Issuer von 16 WORD sind es insgesamt 21 WORD, daher kommt 1 WORD Length-Erweiterung hinzu.
- Die Codec ID hat 32 Bit. Die Codec ID eines GEUL-Direktcodes ist dessen TAG WORD (L=0) als 32-Bit-Wert geschrieben (TRIPLE `0x0AAL` → `0x00000AA0`). Die Codec ID eines Issuer-Codecs ist die Codec-Nummer des Records, die der Issuer unabhängig vom Kind so in seinem `codecs/` festlegt, dass sie sich nicht überschneidet ([Veröffentlichungsadresse und Versionsliste](../publishing.md#id-표기)).
- Die Versions-ID `0` ist die neueste Version. Alle anderen Werte sind fest an die jeweilige Version gebunden.
- Es ist ein einziger Codec-Platz `0x042L`. Es gibt keine Quantifizierung (Identified). Da es Abschnitt 2 ist, wird es nicht als Quantifizierung oder System gelesen.
- Verwendet wird es im Meta [DOC-ID](../meta/0x1C7L-doc-id.md) eines Codec-Dokuments, in [PUBLICATION](../edge/0x0B8L-publication.md), DEPRECATION und TOMBSTONE der Codec-Versionsliste und in [IMPORT-DOC](../meta/0x1E4L-import-doc.md), das ein Codec-Dokument importiert. An diesen Stellen ersetzt es DOC-POINTER.
- Die Veröffentlichungsadresse ist `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<Versions-ID>.geul` ([Veröffentlichungsadresse und Versionsliste](../publishing.md#공표-주소)).

## Beispiel {#예시}

TRIPLE-Codec (Codec ID `0x00000AA0`) des GEUL-Issuer `0x00000000`.

| Version | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| neueste (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + Versions-ID 2 = 7 WORD, `LLLL=0110`. Das TAG ist `0000 0100 0010 0110` = `0426`.

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [Codec-Spezifikationsdokument](../codec-spec.md)
- [Veröffentlichungsadresse und Versionsliste](../publishing.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000420/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
