---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND ist ein Aussage-Edge, der an das Subject einen Namen bindet, auf den sich Maschinen abstimmen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `BIND` (BIND des Spezifikationsdokuments `BIND`) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A30/` (DECLARE-Ziel `0A30`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 3 |
| Kind | Edge · Familie: Aussage, Gruppe: Verweis und Name |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Bindet an das Subject einen Namen (`UTF8-TEXT-*`), auf den sich Maschinen abstimmen. Er ist im Geltungsbereich eindeutig, muss exakt übereinstimmen und hat keine Sprache |
| Hugo-Seite | `edge/bind.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | Record | Beliebiger Record (außer Slot-Marker) |  |
| 2 | `name` | #3 | Record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

BIND ist ein Aussage-Edge, der an das Subject einen Namen bindet, auf den sich Maschinen abstimmen. Codec `0x0A3L`.

Es ist eine Benennung. Für menschenlesbare Namen (Titel je Sprache) ist [LABEL](0x0A4L-label.md) zuständig. Sowohl der Name eines Programmsymbols als auch der Domainname in der Issuer-Liste werden mit demselben Record geschrieben.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Subject           1 Reference-Record oder 1 WORD Codec-TAG-WORD
Name              1 UTF8-TEXT-* Value
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Subject ist genau ein vollständiger [Reference](../reference/_index.md)-Record. Bei LOCAL ist es ein Ziel dieses Dokuments (Symbol usw.), bei einem Zeiger-Reference ein Ziel eines anderen Dokuments. Das Dokument selbst ist [DOC-POINTER](../reference/0x041L-doc-pointer.md), der Issuer selbst [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Oder das Subject ist ein einzelnes Codec-TAG-WORD (nur Kind und Codec, `LLLL = 0`, kein Payload). Dies ist kein Record mit leerem Payload, sondern verweist auf den direkten Code selbst, also auf dessen Spezifikationsdokument (GEUL-Issuer-Codec `0x0000<TAG>`) ([Codec-Spezifikationsdokument](../codec-spec.md), [DECLARE](0x0BBL-declare.md)). Beispiel: `0B80` ist PUBLICATION. Codecs von Issuer-Formaten werden nicht in dieser Form angesprochen.
- Andere Records (Value usw.) können nicht Subject sein. Da das FIELD im BIND-Spezifikationsdokument das Subject nur mit Breite `0` (Record) deklariert, ist diese Einschränkung eine Regel im BIND-Text.
- Der Name ist genau ein [UTF8-TEXT](../value/0x072L-utf8-text.md)-Value. Er hat keine Sprache und wird nicht normalisiert. Nur gleiche Bytes sind derselbe Name.
- Der Geltungsbereich des Namens ist das Dokument, das das BIND enthält. In einem Dokument wird derselbe Name nicht an verschiedene Subject gebunden.
- An ein Subject können mehrere Namen gebunden werden (Alias, früherer Name). Legt das Dokument nichts anderes fest, ist das letzte BIND der Hauptname.
- Andere Records verweisen nicht über den Namen, sondern über die LOCAL ID auf das Ziel. Der Name dient dem Abgleich mit der Außenwelt (Host-Funktionen, Adresseingaben, Menschen).
- Welche Zeichen im Namen zulässig sind, legt der Verwendungszweck fest. Domainnamen in der Issuer-Liste folgen den Domainregeln (Kleinbuchstaben, IDNA) ([Veröffentlichungsadresse und Versionsliste](../publishing.md#issuer-목록)).
- In der Versionsliste steht kein BIND. Eine Dokumentnamen-Adresse gibt es nicht ([Veröffentlichungsadresse und Versionsliste](../publishing.md#문서-이름)).

## Länge {#길이}

```
Gesamt = 1 + N_len + N_id + N_subject + N_name WORD
```

## Beispiel (nicht normativ) {#예시-비규범}

Programmsymbol: Edge Id `0003`, Subject LOCAL 7, Name `main`.

- Der Name `main` hat 4 Byte (gerade), also `0722 6D61 696E` mit 3 WORD.
- Der Edge hat TAG 1 + Edge Id 2 + Subject 2 + Name 3 = 8 WORD, TAG `0A37`.

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [Veröffentlichungsadresse und Versionsliste](../publishing.md#issuer-목록) (Domainnamen der Issuer-Liste)
- [LOCAL](../reference/0x005L-local.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A30/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
