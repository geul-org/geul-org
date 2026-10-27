---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER ist ein Zeiger-Deklarations-Reference, das auf eine Version eines vom Issuer veröffentlichten Dokuments verweist. Die Versions-ID 0 ist die neueste Version."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER ist ein Zeiger-Deklarations-Reference, das auf eine Version eines vom Issuer veröffentlichten Dokuments verweist. Es ist Ziel von Veröffentlichung, Deprecation und Löschung eines Dokuments, von zitierten Fassungen und von Aussagen über ein Dokument.

## Layout

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length-Erweiterungs-TAG]
Issuer            1/2/4/16 WORD
Dokument-ID       4 WORD
Versions-ID       2 WORD
```

## Interpretation und Gültigkeit

- Die Issuer-Breite ist der Rest des Payloads nach Abzug von Dokument-ID und Versions-ID (6 WORD). Der Codec teilt die Breite nicht auf. Ist die Breite nicht 1, 2, 4 oder 16 WORD, oder passt der Issuer-Wert in eine schmalere Breite, ist es invalid (kanonische Form des Issuers).
- Die Versions-ID wird nicht ausgelassen. Erlaubte man das, ließe sich die Issuer-Breite nicht mehr allein aus der Payload-Länge bestimmen (Issuer 4 WORD ohne Version und Issuer 2 WORD mit Version wären beide 8 WORD).
- Die Versions-ID `0` ist die neueste Version. Sie ist an die zum Zeitpunkt der Interpretation geltende Version gebunden. Andere Werte sind an diese Version fest gebunden ([PUBLICATION](/de/grammar/edge/publication/)).
- Die Dokument-ID `0` ist das Begriffsdefinitions-Indexdokument des Issuers. Den Issuer selbst spricht man mit [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) an.
- Als Quantifier wird nur `000` (Identified) verwendet. Andere Werte sind invalid.
- Das Format, das auf ein Dokument eines Issuers verweist, ist allein DOC-POINTER. Mit `EXTERNAL-ISSUER-*` (Issuer, Dokument-ID, Ziel-ID `0`) oder `EXTERNAL-POINTER-*` (IMPORT ID, Ziel-ID `0`) auf ein Dokument zu verweisen ist invalid.
- Verwendung: Meta [DOC-ID](/de/grammar/meta/declaration/doc-id/) und [IMPORT-DOC](/de/grammar/meta/import/import-doc/), PUBLICATION, DEPRECATION, TOMBSTONE und das Subject des BIND in der Versionsliste, das Subject des BIND im Namensindex `documents.geul`.

## Beispiel

Issuer `0x0000` (GEUL), Dokument `0xffff000000000001`.

| Version | WORD-Folge |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| neueste (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + Dokument-ID 4 + Versions-ID 2 = 8 WORD, `LLLL=0111`. Das TAG ist `0000 0 0111 0111 000` = `03B8`.

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/de/grammar/reference/external-issuer/), [PUBLICATION](/de/grammar/edge/publication/)
- [Issuer und Veröffentlichung](/de/grammar/issuer/)
