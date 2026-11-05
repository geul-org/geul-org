---
title: "EXTERNAL-ISSUER-16WORD (0x039L~0x03DL)"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER ist ein zeigend-deklarierendes Reference, das eine LOCAL ID eines vom Issuer veröffentlichten Dokuments ohne IMPORT mit einem einzigen Record zitiert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER ist ein zeigend-deklarierendes Reference, das eine LOCAL ID eines vom Issuer veröffentlichten Dokuments ohne IMPORT mit einem einzigen Record zitiert.

| Eintrag | Wert |
|---|---|
| Name | `EXTERNAL-ISSUER-16WORD` (5Q-Gruppe. Namen der einzelnen Codes in der Mitgliedertabelle unten) |
| TAG ID | `0x039L~0x03DL` |
| Abschnitt | 1 `0001` (Reference EXTERNAL), Offset im Abschnitt C = 25~29 |
| Kind | Reference · Klasse: Zeigen-und-Deklarieren |
| Hugo-Seite | `reference/external-issuer.md` (diese Seite behandelt auch [EXTERNAL-ISSUER-2WORD](0x02FL-external-issuer-2word.md) und [EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md)) |

## Mitglieder {#구성원}

Diese Seite behandelt ein vollständiges 5Q-System, also fünf Codes zusammen. Die Quantifizierung ist der Offset im Abschnitt `C % 5` ([Reference](_index.md#quantifier)). Es gibt ein Codec-Dokument pro Code. Die Felder der fünf Codec-Dokumente sind gleich, nur DECLARE-Ziel und Name (BIND) unterscheiden sich.

| TAG ID | Name | Quantifizierung | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x039L` | `EXTERNAL-ISSUER-16WORD-IDENTIFIED` | Identified | `0x00000390` | `0x00000000/codecs/0x00000390/` | `0000 0011 1001 LLLL` |
| `0x03AL` | `EXTERNAL-ISSUER-16WORD-GENERIC` | Generic | `0x000003A0` | `0x00000000/codecs/0x000003A0/` | `0000 0011 1010 LLLL` |
| `0x03BL` | `EXTERNAL-ISSUER-16WORD-FREE-CHOICE` | Free-choice | `0x000003B0` | `0x00000000/codecs/0x000003B0/` | `0000 0011 1011 LLLL` |
| `0x03CL` | `EXTERNAL-ISSUER-16WORD-UNIVERSAL` | Universal | `0x000003C0` | `0x00000000/codecs/0x000003C0/` | `0000 0011 1100 LLLL` |
| `0x03DL` | `EXTERNAL-ISSUER-16WORD-VARIABLE` | Variable | `0x000003D0` | `0x00000000/codecs/0x000003D0/` | `0000 0011 1101 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Rohwert 16 WORD |  |  |
| 2 | `doc` | #3 | Rohwert 4 WORD |  |  |
| 3 | `target-id` | #4 | restlicher Rohwert (`0xFFFF`) |  |  |

EXTERNAL-ISSUER ist ein zeigend-deklarierendes Reference, das eine LOCAL ID eines vom Issuer veröffentlichten Dokuments ohne IMPORT zitiert. Ein einziger Record ist in seiner Bedeutung vollständig, und es folgt der neuesten Version.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (Abschnitt 1)
[Length-Erweiterungs-TAG]
Issuer            vom Codec bestimmte Breite (2/4/16 WORD)
Dokument-ID       4 WORD
Ziel-ID           der gesamte Rest. LOCAL ID dieses Dokuments, kürzeste Breite
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Name | Breite des Issuer |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (bei geul.org registriert, Domainnachweis) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (bei geul.org registriert, ohne Nachweis) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (aus dem öffentlichen Schlüssel berechnet) |

- Die Breite wird durch die Systemnummer bestimmt: Ist Systemnummer − 9 (`C / 5 − 3` des Offsets im Abschnitt `C`) gleich 0, 1 oder 2, beträgt sie 2, 4 bzw. 16 WORD. Die Quantifizierung ist `C % 5`.
- Die Issuer-ID ist ein ganzzahliger Wert. Gleicher Wert heißt gleicher Issuer. Der Issuer wird in der kürzesten Breite geschrieben, in die der Wert passt, und der Codec dieser Breite wird gewählt (4 WORD nur ab `2^32`, 16 WORD nur ab `2^64`). Eine breitere Schreibweise ist invalid ([Issuer](../issuer.md)).
- Registrierung und Verwaltung der Issuer übernimmt geul.org.
- Eine Version wird nicht angegeben; es gilt die neueste Version. Um die Version festzulegen, verwendet man [IMPORT-DOC](../meta/0x1E4L-import-doc.md) und [EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- Der Ort wird über die Regeln der Veröffentlichungsadresse gefunden ([Veröffentlichungsadresse und Versionsliste](../publishing.md)).
- Ist es dieselbe LOCAL ID dieses Dokuments, bezeichnet sie dasselbe Objekt, ob sie in diesem Dokument als LOCAL, in einem anderen Dokument als EXTERNAL-ISSUER oder (nach IMPORT) als EXTERNAL-POINTER geschrieben wird.
- Es verweist nur auf LOCAL eines Dokuments. Auf das Dokument selbst verweist man mit [DOC-POINTER](0x041L-doc-pointer.md), auf den Issuer selbst mit [ISSUER-POINTER](0x040L-issuer-pointer.md). Daher ist die Ziel-ID nicht `0`. Die Dokument-ID `0` ist das Indexdokument für die Begriffsdefinitionen des Issuers.

## Gültigkeit {#유효성}

- Passt die Breite des Issuer nicht zum Codec oder passt der Wert in eine schmalere Breite, ist es invalid.
- Ist die Ziel-ID `0`, ist es invalid. Die Ziel-ID `0` (das Dokument selbst) übernimmt DOC-POINTER.
- Führende WORD `0x0000` in der Ziel-ID sind verboten.

## Beispiel {#예시}

| Ziel | WORD sequence |
|---|---|
| Issuer `0x00000002`, Dokument `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, Dokument `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer und Veröffentlichung](../issuer.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000390/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000039000000000
BODY
#1 DECLARE 0x0390
#2 FIELD #1 0x0010
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-16WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

Oben steht das Codec-Dokument von `EXTERNAL-ISSUER-16WORD-IDENTIFIED` (`0x039L`). Die Codec-Dokumente der anderen Mitglieder (`EXTERNAL-ISSUER-16WORD-GENERIC`, `EXTERNAL-ISSUER-16WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-16WORD-UNIVERSAL`, `EXTERNAL-ISSUER-16WORD-VARIABLE`) unterscheiden sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im in `#1` gebundenen Namen (BIND).
