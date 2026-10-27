---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER ist ein Zeiger-Reference, das auf die LOCAL ID eines Dokuments verweist, das mit IMPORT-DOC im HEAD importiert wurde."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER ist ein Zeiger-Reference, das auf die LOCAL ID eines Dokuments verweist, das mit [IMPORT-DOC](/de/grammar/meta/import/import-doc/) im HEAD importiert wurde.

## Layout

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[Length-Erweiterungs-TAG]
IMPORT ID         Breite nach WW (00=1, 01=2, 10=4, 11=8 WORD)
Ziel-ID           der gesamte Rest. LOCAL ID des importierten Dokuments, kürzeste Breite
```

| CCCC | Name | Breite der IMPORT ID |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- Man verwendet den schmalsten Codec, in den der Wert der IMPORT ID passt.
- Die IMPORT ID ist der von `IMPORT-DOC` dieses Dokuments vergebene Wert und nur innerhalb dieses Dokuments gültig. Bei EXTERNAL-POINTER steht kein Issuer. Issuer und Dokument-ID erhält man aus diesem `IMPORT-DOC`. Auch die Version legt dieses `IMPORT-DOC` fest (fest oder neueste).
- Dieselbe LOCAL ID des importierten Dokuments ist dasselbe Objekt, gleich ob sie in jenem Dokument als LOCAL oder hier als EXTERNAL-POINTER geschrieben wird.
- Bei Variable ist es eine LOCAL-Variable des importierten Dokuments.

## Gültigkeit

- Hat dieses Dokument kein `IMPORT-DOC`, das diese IMPORT ID vergeben hat, ist es invalid.
- Passt die IMPORT ID in einen schmaleren Codec und wird ein breiterer verwendet, wird es als non-minimal abgelehnt.
- Ist die Ziel-ID `0`, ist es invalid. Das importierte Dokument selbst spricht man mit [DOC-POINTER](/de/grammar/reference/doc-pointer/) an.
- Ein führendes WORD `0x0000` in der Ziel-ID ist verboten.

## Beispiel

| Ziel | WORD-Folge |
|---|---|
| LOCAL 5 von IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 von IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 von IMPORT ID 70000 | `01C8 0001 1170 0005` |

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [LOCAL](/de/grammar/reference/local/), [EXTERNAL-ISSUER](/de/grammar/reference/external-issuer/), [DOC-POINTER](/de/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/de/grammar/meta/import/import-doc/)
