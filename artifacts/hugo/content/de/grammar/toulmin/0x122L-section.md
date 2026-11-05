---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION ist ein Record für Originaltext und Gliederung eines TOULMIN-Dokuments. Bedeutung: Beginn eines Abschnitts.

| Eigenschaft | Wert |
|---|---|
| Name | `SECTION` (BIND `SECTION` des Spezifikationsdokuments) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001220/` (DECLARE-Ziel `1220`) |
| Abschnitt | 9 `1001` (Edge TOULMIN-Format), Offset im Abschnitt C = 2 |
| Kind | Edge · Familie: TOULMIN-Format, Layout: ID, Abschnittscode 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Beginn eines Abschnitts |
| Hugo-Seite | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Der Beginn eines Abschnitts. Der Abschnittscode ist 1 WORD.

```
ID
Abschnittscode   1 WORD
```

| Code | Abschnitt | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | Bedingungsausdruck-Regeln |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` wird nicht verwendet. Die Abschnitte werden in der Reihenfolge dieser Codes deklariert.
- Der Abschnittstitel ist das [PROSE](0x125L-prose.md) unmittelbar nach SECTION.

- ID ist die Edge Id, REF ist die Edge Id eines Records dieses Dokuments (gemeinsames Feld von [TOULMIN](_index.md#공통-필드)). Es gibt keine Felder für Issuer und Codec-Nummer; die Payload folgt direkt auf das TAG.

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1220`). Die Felddeklaration wird zusammen mit dem Spezifikationsdokument des TOULMIN-Codec festgelegt ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [SOURCE und Gliederung](_index.md#source와-구획), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001220/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
