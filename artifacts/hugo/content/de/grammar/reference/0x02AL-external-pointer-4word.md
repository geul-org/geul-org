---
title: "EXTERNAL-POINTER-4WORD (0x02AL~0x02EL)"
weight: 42
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER ist ein zeigendes Reference auf eine LOCAL ID eines Dokuments, das mit IMPORT-DOC im HEAD importiert wurde."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER ist ein zeigendes Reference auf eine LOCAL ID eines Dokuments, das mit IMPORT-DOC im HEAD importiert wurde.

| Eintrag | Wert |
|---|---|
| Name | `EXTERNAL-POINTER-4WORD` (5Q-Gruppe. Namen der einzelnen Codes in der Mitgliedertabelle unten) |
| TAG ID | `0x02AL~0x02EL` |
| Abschnitt | 1 `0001` (Reference EXTERNAL), Offset im Abschnitt C = 10~14 |
| Kind | Reference · Klasse: Zeigen |
| Hugo-Seite | `reference/external-pointer.md` (diese Seite behandelt auch [EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md) und [EXTERNAL-POINTER-2WORD](0x025L-external-pointer-2word.md)) |

## Mitglieder {#구성원}

Diese Seite behandelt ein vollständiges 5Q-System, also fünf Codes zusammen. Die Quantifizierung ist der Offset im Abschnitt `C % 5` ([Reference](_index.md#quantifier)). Es gibt ein Codec-Dokument pro Code. Die Felder der fünf Codec-Dokumente sind gleich, nur DECLARE-Ziel und Name (BIND) unterscheiden sich.

| TAG ID | Name | Quantifizierung | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x02AL` | `EXTERNAL-POINTER-4WORD-IDENTIFIED` | Identified | `0x000002A0` | `0x00000000/codecs/0x000002A0/` | `0000 0010 1010 LLLL` |
| `0x02BL` | `EXTERNAL-POINTER-4WORD-GENERIC` | Generic | `0x000002B0` | `0x00000000/codecs/0x000002B0/` | `0000 0010 1011 LLLL` |
| `0x02CL` | `EXTERNAL-POINTER-4WORD-FREE-CHOICE` | Free-choice | `0x000002C0` | `0x00000000/codecs/0x000002C0/` | `0000 0010 1100 LLLL` |
| `0x02DL` | `EXTERNAL-POINTER-4WORD-UNIVERSAL` | Universal | `0x000002D0` | `0x00000000/codecs/0x000002D0/` | `0000 0010 1101 LLLL` |
| `0x02EL` | `EXTERNAL-POINTER-4WORD-VARIABLE` | Variable | `0x000002E0` | `0x00000000/codecs/0x000002E0/` | `0000 0010 1110 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | Rohwert 4 WORD |  |  |
| 2 | `target-id` | #3 | restlicher Rohwert (`0xFFFF`) |  |  |

EXTERNAL-POINTER ist ein zeigendes Reference auf eine LOCAL ID eines Dokuments, das mit [IMPORT-DOC](../meta/0x1E4L-import-doc.md) im HEAD importiert wurde.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (Abschnitt 1)
[Length-Erweiterungs-TAG]
IMPORT ID         vom Codec bestimmte Breite (1/2/4 WORD)
Ziel-ID           der gesamte Rest. LOCAL ID des importierten Dokuments, kürzeste Breite
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Name | Breite der IMPORT ID |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- Die Breite wird durch die Systemnummer bestimmt: Ist Systemnummer − 6 (`C / 5` des Offsets im Abschnitt `C`) gleich 0, 1 oder 2, beträgt sie 1, 2 bzw. 4 WORD. Die Quantifizierung ist `C % 5`.

- Es wird der schmalste Codec verwendet, in den der Wert der IMPORT ID passt.
- Die IMPORT ID ist der Wert, den das `IMPORT-DOC` dieses Dokuments vergeben hat. Im EXTERNAL-POINTER wird kein Issuer angegeben. Issuer und Dokument-ID erhält man aus diesem `IMPORT-DOC`. Auch die Version bestimmt dieses `IMPORT-DOC` (fest oder neueste).
- Ist es dieselbe LOCAL ID des importierten Dokuments, bezeichnet sie dasselbe Objekt, ob sie dort als LOCAL oder hier als EXTERNAL-POINTER geschrieben wird.
- Bei Variable ist es eine LOCAL-Variable des importierten Dokuments.

## Gültigkeit {#유효성}

- Gibt es in diesem Dokument kein `IMPORT-DOC`, das diese IMPORT ID vergeben hat, ist es invalid.
- Passt die IMPORT ID in einen schmaleren Codec und wird ein breiterer verwendet, wird es als non-minimal abgelehnt.
- Ist die Ziel-ID `0`, ist es invalid. Auf das importierte Dokument selbst verweist man mit [DOC-POINTER](0x041L-doc-pointer.md).
- Führende WORD `0x0000` in der Ziel-ID sind verboten.

## Beispiel {#예시}

| Ziel | WORD sequence |
|---|---|
| IMPORT ID 1, LOCAL 5 | `0202 0001 0005` |
| IMPORT ID 1, LOCAL 65536 | `0203 0001 0001 0000` |
| IMPORT ID 70000, LOCAL 5 | `0253 0001 1170 0005` |

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000002A0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002A000000000
BODY
#1 DECLARE 0x02A0
#2 FIELD #1 0x0004
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-4WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

Oben steht das Codec-Dokument von `EXTERNAL-POINTER-4WORD-IDENTIFIED` (`0x02AL`). Die Codec-Dokumente der anderen Mitglieder (`EXTERNAL-POINTER-4WORD-GENERIC`, `EXTERNAL-POINTER-4WORD-FREE-CHOICE`, `EXTERNAL-POINTER-4WORD-UNIVERSAL`, `EXTERNAL-POINTER-4WORD-VARIABLE`) unterscheiden sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im in `#1` gebundenen Namen (BIND).
