---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Eine Signatur über den Inhaltshash des Dokuments (git signierte Commits und Tags)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SIGNATURE` (Spezifikationsdokument BIND `SIGNATURE`) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001E60/` (DECLARE-Ziel `1E60`) |
| Abschnitt | 15 `1111` (Meta), Offset im Abschnitt C = 6 |
| Kind | Meta · Klasse: Verifikation |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Signatur über ein Objekt. Die Signatur über ein Dokument signiert den Inhaltshash (git signierte Commits und Tags) |
| Hugo-Seite | `meta/verification/signature.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | Rohwert 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | Record | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | Rest-Rohwert (`0xFFFF`) |  |  |

Eine Signatur über den Inhaltshash des Dokuments (git signierte Commits und Tags).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[Length-Erweiterungs-TAG]
Algorithmus-ID    1 WORD (0x0001 = Ed25519)
Unterzeichner     ISSUER-POINTER-(Issuer-)Reference-Record
Signatur          der gesamte Rest. Die Breite bestimmt der Algorithmus (Ed25519 32 WORD)
```

- Codec: Meta `0x1E6L`, Verifikationsklasse
- Payload: Algorithmus-ID (Rohwert 1 WORD) + Unterzeichner (eingebettete Reference) + Signatur (Rohwert, Rest)
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit {#해석과-유효성}

- Signiert wird der Inhaltshash. Nicht nur der BODY wird signiert ([Signatur](../issuer.md#서명)).
- Als Verifikationsklasse fällt es aus dem Inhaltshash heraus. Auch wenn man Signaturen hinzufügt, bleibt der Hash gleich.
- Geprüft wird nicht „wenn eine Signatur da ist, wird sie kontrolliert“, sondern „es muss eine Signatur des festgelegten Schlüssels vorhanden sein“.
- Das Versionslisten-Dokument signiert die veröffentlichende Stelle.
- Der Unterzeichner ist ein [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) (Issuer), der auf den Issuer selbst verweist. Da es ein Reference-Record ist, der mit seiner eigenen Length endet, steht das Layout auch dann fest, wenn die Signaturbreite je Algorithmus verschieden ist ([DECLARE](../edge/0x0BBL-declare.md) Rest-Feld).
- Weicht die WORD-Zahl der Signatur von der vom Algorithmus bestimmten Breite ab, ist es invalid.

## Offene Probleme {#열린-문제}

- Ob der Zeitpunkt der Signatur mitsigniert wird.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001E60/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
