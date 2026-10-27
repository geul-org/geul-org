---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF ist ein Value, der eine ASCII-Bytefolge der Grammatik relative-ref nach RFC 3986 enthält. Es werden die Formatnummern 0x8000/0x8001 des IETF-Issuers verwendet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF ist ein Value, der eine ASCII-Bytefolge der Grammatik `relative-ref` von RFC 3986 enthält. Basis-URI und das aufgelöste Ergebnis kommen nicht in den Payload.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, Formatnummer `0x8000` (gerade Bytezahl) und `0x8001` (ungerade Bytezahl). Familie TEXT.
- Die Bytezahl ergibt sich aus dem niederwertigsten Bit der Formatnummer und der Zahl der Payload-WORD. Sie ist `2 × Anzahl der Payload-WORD − niederwertigstes Bit`, und ein Byte Count steht nicht dabei ([Value](/de/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0020 (IETF)
Formatnummer      1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Interpretation und Gültigkeit

- Die Bytefolge muss der Grammatik `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` von RFC 3986 entsprechen.
- Die Terminale der URI-Grammatik sind US-ASCII-Zeichen. Zulässige ASCII-Zeichen werden unverändert gespeichert, und beim Percent-Encoding von Oktetten wird das Format `pct-encoded = "%" HEXDIG HEXDIG` verwendet. Nicht-ASCII-Zeichen dürfen nicht als literale Bytes eingefügt werden.
- Da `relative-part` ein `path-empty` sein kann, ist auch eine leere Bytefolge grammatikalisch ein gültiges `relative-ref`.
- Basis-URI, Auflösungskontext und Auflösungsergebnis sind Kontext außerhalb dieses Formats.
- Innerhalb eines WORD steht das obere Byte zuerst. Bei ungerader Bytezahl (ungerader Code) muss das nicht verwendete untere Byte des letzten WORD `00` sein.
- Die Zahl der Payload-WORD ist `ceil(Bytezahl/2)`. Ist es ein ungerader Code und das untere Byte des letzten WORD nicht `00`, wird abgelehnt.

## Normgrundlage

- `relative-ref`, URI-Zeichen und die Grammatik des Percent-Encoding richten sich nach [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Codepaar aus gerade/ungerade, Zero-Padding sowie GEUL-TAG/Length und die 16-Bit-WORD-Anordnung sind Framing-Regeln dieses Formats. Basis-URI und das Ergebnis der Referenzauflösung sind Kontext des RFC, kommen aber nicht in den Payload.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).
- 0 Byte sind als leeres `relative-ref` inhaltlich zulässig und haben kein Payload-WORD. Die physische Anordnung dazu steht unten bei den offenen Fragen.

## Beispiel

- `a/b?x=1` hat 7 Byte (ungerade), also die Formatnummer `0x8001`, Payload `612f 623f 783d 3100`. Insgesamt sind es 7 WORD, also `LLLL=0110`. Der gesamte Record ist `0B7C 0020 8001 612f 623f 783d 3100`.

## Offene Fragen

- Die physische Anordnung eines leeren `relative-ref` (0 Byte). Ein Record ohne Payload passt nicht zur Regel „mindestens 1 WORD Payload“ und ist deshalb noch nicht festgelegt.
