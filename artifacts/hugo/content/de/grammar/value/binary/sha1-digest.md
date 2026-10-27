---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST ist ein Value mit festen 11 WORD, der das gesamte SHA-1-Ergebnis mit 160 Bit enthält und nur für Identifikationszwecke wie git-Objekt-IDs verwendet wird."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST ist ein Value fester Breite, der das gesamte SHA-1-Ergebnis enthält. Direkter Value-Code `0x62`, Familie BINARY. Der Payload ist genau 10 WORD (160 Bit), und Kürzen (truncation) ist nicht zulässig.

**Nur für Identifikationszwecke verwenden.** Die Kollisionsresistenz von SHA-1 ist gebrochen (2017 SHAttered). Als Grundlage für Integrität und Signatur verwendet man [SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/). Dieses Format dient dazu, bereits mit SHA-1 festgelegte Kennungen unverändert aufzunehmen, vor allem die Objekt-IDs (Commit-IDs) von SHA-1-git-Repositories. Zum Beispiel nimmt man die Version (Commit-ID) von [TRANSFORMED-BY](/de/grammar/meta/lineage/transformed-by/) mit 11 WORD statt als Hex-Text (22 WORD) auf.

## Layout

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interpretation und Gültigkeit

- Die 20 Oktette des Payloads werden in der Ausgabereihenfolge von SHA-1 gelesen. In jedem WORD steht das obere Oktett zuerst (dasselbe Framing wie bei SHA-256-DIGEST).
- Ein Payload, der nicht 10 WORD hat, oder eine willkürlich gekürzte Darstellung des Ergebnisses (z. B. abgekürzte git-IDs) wird abgelehnt. Es gibt weder Descriptor noch Padding.
- Die git-Objekt-ID ist der von git berechnete Wert unverändert. Das SHA-1 von git ist eine Variante mit Kollisionserkennung (SHA-1DC), aber bei Eingaben ohne Kollisionsangriff ist das Ergebnis dasselbe wie bei SHA-1.

## Normgrundlage

- Der SHA-1-Algorithmus und das 160-Bit-Ergebnis richten sich nach NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL-TAG und 16-Bit-WORD-Framing sind Regeln, die dieses Format hinzufügt.

## Länge

- Insgesamt sind es genau 11 WORD aus 1 WORD TAG und 10 WORD Payload, mit `LLLL=1010`. Es gibt keine Length-Erweiterung.

## Beispiel

git-Commit `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Verwandte Seiten

- [Value](/de/grammar/value/), [SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/de/grammar/meta/lineage/transformed-by/)
