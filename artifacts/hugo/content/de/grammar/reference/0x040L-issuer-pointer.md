---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER ist ein zeigend-deklarierendes Reference, das den Issuer selbst bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `ISSUER-POINTER` (Spezifikationsdokument BIND `ISSUER-POINTER`) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000400/` (DECLARE-Ziel `0400`) |
| Abschnitt | 2 `0010` (Reference Sonstige), Offset im Abschnitt C = 0 |
| Kind | Reference · Klasse: Zeigen-und-Deklarieren |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo-Seite | `reference/issuer-pointer.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | restlicher Rohwert (`0xFFFF`) |  |  |

ISSUER-POINTER ist ein zeigend-deklarierendes Reference, das den Issuer selbst bezeichnet. Es wird zum Ziel von `BIND` für Issuer-Namen, von `LABEL` und von Beurteilungs-Edge.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[Length-Erweiterungs-TAG]
Issuer            2/4/16 WORD
```

- Die Breite des Issuer ist der gesamte Payload. Der Codec teilt die Breite nicht auf. Ist die Breite nicht 2, 4 oder 16 WORD oder passt der Issuer-Wert in eine schmalere Breite, ist es invalid (Issuer-Normalform).
- Bei einem Issuer von 16 WORD sind es insgesamt 17 WORD, daher kommt 1 WORD Length-Erweiterung hinzu.
- Es ist ein einziger Codec-Platz `0x040L`. Es gibt keine Quantifizierung (Identified).
- Der Issuer-Wert folgt der Vergabe des [Issuer](../issuer.md).
- Verwendung: Subject des BIND in der Issuer-Liste `issuers/` ([Veröffentlichungsadresse und Versionsliste](../publishing.md#issuer-목록)), LABEL des Anzeigenamens des Issuer, Beurteilung über einen Issuer, Unterzeichner und andere Stellen, an denen der Issuer selbst das Objekt ist.
- Die Form, die den Issuer selbst bezeichnet, ist allein ISSUER-POINTER. Den Issuer mit `EXTERNAL-ISSUER-*` unter Verwendung der Dokument-ID `0` und der Ziel-ID `0` zu bezeichnen, ist invalid.

## Beispiel {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## Verwandte Seiten {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer und Veröffentlichung](../issuer.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000400/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
