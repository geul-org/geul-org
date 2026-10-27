---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER ist ein Zeiger-Deklarations-Reference, das die LOCAL ID eines vom Issuer veröffentlichten Dokuments ohne IMPORT mit einem einzigen Record zitiert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER ist ein Zeiger-Deklarations-Reference, das die LOCAL ID eines vom Issuer veröffentlichten Dokuments ohne IMPORT zitiert. Die Bedeutung ist mit einem einzigen Record vollständig, und es folgt der neuesten Version.

## Layout

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length-Erweiterungs-TAG]
Issuer            Breite nach WW (00=1, 01=2, 10=4, 11=16 WORD)
Dokument-ID       4 WORD
Ziel-ID           der gesamte Rest. LOCAL ID dieses Dokuments, kürzeste Breite
```

| CCCC | Name | Issuer-Breite |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (von geul.org zugewiesen) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (bei geul.org registriert, Domainnachweis) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (bei geul.org registriert, ohne Nachweis) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (aus dem öffentlichen Schlüssel berechnet) |

- Die Issuer-ID ist ein ganzzahliger Wert. Gleicher Wert bedeutet gleicher Issuer. Der Issuer wird in der kürzesten Breite geschrieben, in die der Wert passt, und der Codec dieser Breite gewählt (2 WORD nur, wenn der Wert `0xFFFF` übersteigt, 4 WORD nur ab `2^32`, 16 WORD nur ab `2^64`). Breitere Schreibweisen sind invalid ([Issuer](/de/grammar/issuer/)).
- Registrierung und Verwaltung der Issuer übernimmt geul.org.
- Eine Version wird nicht angegeben, es gilt die neueste Version. Um eine Version festzulegen, verwendet man [IMPORT-DOC](/de/grammar/meta/import/import-doc/) und [EXTERNAL-POINTER](/de/grammar/reference/external-pointer/).
- Den Ort findet man über die Regeln der Veröffentlichungsadresse ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/)).
- Dieselbe LOCAL ID dieses Dokuments ist dasselbe Objekt, gleich ob sie in jenem Dokument als LOCAL, in einem anderen Dokument als EXTERNAL-ISSUER (oder nach einem IMPORT als EXTERNAL-POINTER) geschrieben wird.
- Es verweist nur auf LOCAL eines Dokuments. Das Dokument selbst spricht man mit [DOC-POINTER](/de/grammar/reference/doc-pointer/), den Issuer selbst mit [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) an. Deshalb ist die Ziel-ID nicht `0`. Die Dokument-ID `0` ist das Begriffsdefinitions-Indexdokument des Issuers.

## Gültigkeit

- Passt die Issuer-Breite nicht zum Codec, oder passt der Wert in eine schmalere Breite, ist es invalid.
- Ist die Ziel-ID `0`, ist es invalid. Die Ziel-ID `0` (das Dokument selbst) übernimmt DOC-POINTER.
- Ein führendes WORD `0x0000` in der Ziel-ID ist verboten.

## Beispiel

| Ziel | WORD-Folge |
|---|---|
| Issuer `0x0001`, Dokument `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, Dokument `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [DOC-POINTER](/de/grammar/reference/doc-pointer/), [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/de/grammar/reference/external-pointer/)
- [Issuer und Veröffentlichung](/de/grammar/issuer/)
