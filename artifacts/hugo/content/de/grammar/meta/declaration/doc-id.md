---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID ist ein Definitions-Meta, das die Kennung eines Dokuments als DOC-POINTER (Issuer, Dokument-ID, Version 0) deklariert, der auf das Dokument selbst zeigt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Deklariert die Kennung dieses Dokuments. Sie wird gebraucht, damit andere Dokumente dieses Dokument und seine Ziele ansprechen können.

## Layout

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[Length-Erweiterungs-TAG]
Dokument          DOC-POINTER-Reference-Record. (Issuer, Dokument-ID, Version 0)
```

- Codec: Meta `0x12`, Definitionsklasse (`001`)
- Payload: genau eine eingebettete Reference [DOC-POINTER](/de/grammar/reference/doc-pointer/) (Issuer, Dokument-ID, Version 0)
- Anzahl: höchstens eins. Für Dokumente, deren Name mit `0x` beginnt, ist sie Pflicht

## Interpretation und Gültigkeit

- Der Payload ist genau ein Reference-Record `DOC-POINTER` (Issuer, Dokument-ID, Version `0`). Als Versions-ID wird nur `0` verwendet. Versionen vergibt die Versionsliste, nicht das Dokument. Der Quantifier ist `000`.
- Deshalb ist die Schreibweise, die "dieses Dokument" bezeichnet, in DOC-ID, im Subject des [BIND](/de/grammar/edge/bind/) in `documents.geul` und in Zitaten anderer Dokumente dieselbe.
- Unabhängig von der Version hat dasselbe Dokument dieselbe `DOC-ID`. Versions-ID und Inhaltshash werden nicht ins Dokument geschrieben ([Version](/de/grammar/document/#version)).
- Den Adressnamen trägt das beschreibende `BIND` des Namensindex `documents.geul` ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#dokumentname)), den für Menschen lesbaren Titel das beschreibende [LABEL](/de/grammar/edge/label/).
- Fehlt sie, ist das Dokument namenlos und nur über den Inhaltshash ansprechbar. Sie wird gebraucht, damit andere Dokumente die LOCALs dieses Dokuments per hinweisender Reference ansprechen können.
- Wer ein Dokument importiert, prüft, ob die `DOC-ID` des erhaltenen Dokuments mit dem angeforderten Issuer und der angeforderten Dokument-ID übereinstimmt.
- Die Dokument-ID `0x0000000000000000` ist das Begriffsdefinitions-Indexdokument des Issuers ([Issuer](/de/grammar/issuer/)). Da sein Name ebenfalls mit `0x` beginnt, trägt es eine DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). Der Issuer selbst wird durch [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) vertreten.
- Dokumente unter `.well-known/geul/`, deren Name mit `0x` beginnt (Versionsdokument `<Versions-ID>.geul`, Spezifikationsdokumente), müssen eine `DOC-ID` tragen.
- Dokumente, deren Name nicht mit `0x` beginnt, tragen ausnahmsweise keine `DOC-ID`: die Versionsliste `versions.geul` ([PUBLICATION](/de/grammar/edge/publication/)), der Dokumentnamen-Index `documents.geul` und der Issuer-Namen-Index `issuers.geul` ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/)). Das Inhaltshash-Repository `h/` enthält Kopien der obigen Dokumente und folgt den Originalen.
- Codec-Spezifikationsdokumente sind Dokumente des GEUL Issuer `0x0000`. Die Dokument-ID ist der auf 4 WORD erweiterte Kind-/Codec-TAG-WORD-Wert (`0x1018` → `0x0000000000001018`). Da Reference `0000` reserviert ist, wird die Dokument-ID nie `0` ([Spezifikationsdokument](/de/grammar/codec-spec/)).

## Beispiel

- Issuer `0x0001`, Dokument `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (Meta-TAG 1 + Reference-TAG 1 + Issuer 1 + Dokument-ID 4 + Version 2 = 9 WORD)
