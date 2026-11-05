---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Bestätigung des Beitragsrechts (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SIGNED-OFF` (Spezifikationsdokument BIND `SIGNED-OFF`) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001E70/` (DECLARE-Ziel `1E70`) |
| Abschnitt | 15 `1111` (Meta), Offset im Abschnitt C = 7 |
| Kind | Meta · Klasse: Verifikation |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Bestätigung des Beitragsrechts. Reference (git `Signed-off-by`, DCO) |
| Hugo-Seite | `meta/verification/signed-off.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | Record | beliebiger Record (außer Slot-Marker) |  |

Bestätigung des Beitragsrechts (git `Signed-off-by`, DCO).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[Length-Erweiterungs-TAG]
Payload           eine Reference
```

- Codec: Meta `0x1E7L`, Verifikationsklasse
- Payload: eingebettete Reference
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit {#해석과-유효성}

- In auf geul.org veröffentlichten Dokumenten gibt es keine Reference, die auf natürliche Personen verweist ([Issuer und Veröffentlichung](../issuer.md#geulorg-공표)). Sie verweist auf Organisationen und Issuer. Als Ausnahme ist es erlaubt, mit [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) auf natürliche Personen zu verweisen.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001E70/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
