---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE ist ein Verifikations-Meta, das die Signatur über den Inhaltshash eines Dokuments aus Algorithmus-ID, Signierendem und Signatur festhält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Signatur über den Inhaltshash des Dokuments (git signierter Commit/Tag).

## Layout

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[Length-Erweiterungs-TAG]
Algorithmus-ID    1 WORD (0x0001 = Ed25519)
Signierender      ISSUER-POINTER(Issuer)-Reference-Record
Signatur          der gesamte Rest. Die Breite legt der Algorithmus fest (Ed25519 32 WORD)
```

- Codec: Meta `0x41`, Verifikationsklasse (`100`)
- Payload: Algorithmus-ID (Rohwert 1 WORD) + Signierender (eingebettetes Reference) + Signatur (Rohwert, Rest)
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- Gegenstand der Signatur ist der Inhaltshash. Es wird nicht nur der BODY signiert ([Signatur](/de/grammar/issuer/#signatur)).
- Als Verifikationsklasse bleibt es beim Inhaltshash außen vor. Auch mit weiteren Signaturen bleibt der Hash gleich.
- Geprüft wird nicht „wenn eine Signatur vorhanden ist, wird sie geprüft“, sondern „es muss eine Signatur des festgelegten Schlüssels vorhanden sein“.
- Das Versionslisten-Dokument signiert die veröffentlichende Stelle.
- Der Signierende ist ein [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) (Issuer), der auf den Issuer selbst verweist. Da ein Reference-Record mit seiner eigenen Length endet, ist das Layout eindeutig, auch wenn die Signaturbreite je Algorithmus unterschiedlich ist ([DECLARE](/de/grammar/edge/declare/), Restfeld).
- Weicht die WORD-Zahl der Signatur von der vom Algorithmus festgelegten Breite ab, ist es invalid.

## Offene Fragen

- Ob der Signaturzeitpunkt mit signiert werden soll.
