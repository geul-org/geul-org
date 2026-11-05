---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER ist ein zeigend-deklarierendes Reference, das eine Version eines vom Issuer veröffentlichten Dokuments bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DOC-POINTER` (Spezifikationsdokument BIND `DOC-POINTER`) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000410/` (DECLARE-Ziel `0410`) |
| Abschnitt | 2 `0010` (Reference Sonstige), Offset im Abschnitt C = 1 |
| Kind | Reference · Klasse: Zeigen-und-Deklarieren |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo-Seite | `reference/doc-pointer.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | Rohwert 4 WORD |  |  |
| 3 | `version` | #4 | Rohwert 2 WORD |  |  |

DOC-POINTER ist ein zeigend-deklarierendes Reference, das eine Version eines vom Issuer veröffentlichten Dokuments bezeichnet. Es wird zum Ziel von Veröffentlichung, Deprecate und Löschung eines Dokuments, von zitierten Ausgaben und von Aussagen über das Dokument.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[Length-Erweiterungs-TAG]
Issuer            2/4/16 WORD
Dokument-ID       4 WORD
Versions-ID       2 WORD
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Breite des Issuer ist der Rest des Payloads nach Abzug der 6 WORD für Dokument-ID und Versions-ID. Der Codec teilt die Breite nicht auf. Ist die Breite nicht 2, 4 oder 16 WORD oder passt der Issuer-Wert in eine schmalere Breite, ist es invalid (Issuer-Normalform).
- Die Versions-ID wird nicht ausgelassen. Erlaubte man das Auslassen, ließe sich die Breite des Issuer nicht allein aus der Payload-Länge bestimmen (Issuer 4 WORD ohne Version und Issuer 2 WORD mit Version wären beide 8 WORD).
- Die Versions-ID `0` ist die neueste Version. Sie ist an die zum Zeitpunkt der Interpretation aktuelle Version gebunden. Alle anderen Werte sind an diese Version fest gebunden ([PUBLICATION](../edge/0x0B8L-publication.md)).
- Die Dokument-ID `0` ist das Indexdokument für die Begriffsdefinitionen des Issuer. Auf den Issuer selbst verweist man mit [ISSUER-POINTER](0x040L-issuer-pointer.md).
- Jeder Issuer reserviert die Dokument-IDs `0x0000000000000000` und `0xFFFFFFFFFFFFFFFF` ([Issuer und Veröffentlichung](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF` wird für die Issuer-Liste `issuers/` des Issuer `0x00000000` verwendet, andere Issuer verwenden es nicht. PUBLICATION, DEPRECATION und TOMBSTONE in `issuers/versions.geul` bezeichnen mit diesem Wert die Version der Liste ([Veröffentlichungsadresse und Versionsliste](../publishing.md#목록-문서)).
- Es ist ein einziger Codec-Platz `0x041L`. Es gibt keine Quantifizierung (Identified).
- Die Form, die ein Dokument eines Issuer bezeichnet, ist allein DOC-POINTER. Ein Dokument mit `EXTERNAL-ISSUER-*` (Issuer, Dokument-ID, Ziel-ID `0`) oder `EXTERNAL-POINTER-*` (IMPORT ID, Ziel-ID `0`) zu bezeichnen, ist invalid.
- Verwendet wird es bei den Meta [DOC-ID](../meta/0x1C7L-doc-id.md) und [IMPORT-DOC](../meta/0x1E4L-import-doc.md) sowie bei PUBLICATION, DEPRECATION und TOMBSTONE der Versionsliste.
- Codec-Dokumente haben keine Dokument-ID. Ein Codec-Dokument und seine Version werden mit [CODEC-POINTER](0x042L-codec-pointer.md) bezeichnet.

## Beispiel {#예시}

Dokument `0xFFFF000000000001` des GEUL-Issuer `0x00000000`.

| Version | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| neueste (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + Dokument-ID 4 + Versions-ID 2 = 9 WORD, `LLLL=1000`. Das TAG ist `0000 0100 0001 1000` = `0418`.

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer und Veröffentlichung](../issuer.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000410/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
