---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG ist ein Abstammungs-Meta, das einen unveränderlichen Namen für eine Version festhält (git annotated tag)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält einen unveränderlichen Namen für eine Version fest (git annotated tag).

## Layout

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[Length-Erweiterungs-TAG]
Name              UTF8-TEXT-*-Value
Ziel              SHA-256-DIGEST-Value, oder Auslassungsmarker 0x0000 (optionales Feld). Bei Auslassung diese Version
```

- Codec: Meta `0x39`, Abstammungsklasse (`011`)
- Payload: eingebettete Values (Text + optionaler Inhaltshash)
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- Der Name ist ein [UTF8-TEXT](/de/grammar/value/text/utf8-text/), das Ziel ein [SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/).
- Wird das Ziel ausgelassen (ABSENT `0x0000`, optionales Feld von [CODEC](/de/grammar/edge/codec/)), ist es ein Name für dieses Dokument selbst. Den eigenen Inhaltshash kann man nicht in sich selbst eintragen. Die geul.org-Spezifikation `0x1839` ist ein Zwei-Record-Feld aus name (`0840`, `0841`) und target (`0861`, `0000`).
- Derselbe Name wird nicht für eine andere Version erneut verwendet.

## Beispiel

- Name `v1`, diese Version: `19B9 08C0 7631 0000`

## Offene Fragen

- Ob TAG trotz der Versions-ID (laufende Nummer) nötig ist, und die Rollenabgrenzung zum Dokumentnamen (`BIND`).
