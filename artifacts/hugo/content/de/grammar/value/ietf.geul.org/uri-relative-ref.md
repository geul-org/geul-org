---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF ist ein Value, der die ASCII-Bytefolge der relative-ref-Grammatik von RFC 3986 enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF ist ein Value, der die ASCII-Bytefolge der `relative-ref`-Grammatik von RFC 3986 enthält. Base URI und das aufgelöste Ergebnis werden nicht in den Payload aufgenommen.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, Codec-Nummer `0x00008000` (gerade Byte-Zahl) / `0x00008001` (ungerade Byte-Zahl). Familie TEXT.
- Die Byte-Zahl ergibt sich aus dem niedrigstwertigen Bit der Codec-Nummer und der Zahl der Payload-WORD: `2 × Zahl der Payload-WORD − niedrigstwertiges Bit`. Einen Byte Count gibt es nicht ([Value](../_index.md)).

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            2 WORD  0x00000007 (IETF)
Codec-Nummer      2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Bytefolge muss der Grammatik `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` von RFC 3986 entsprechen.
- Die Terminale der URI-Grammatik sind US-ASCII-Zeichen. Zulässige ASCII-Zeichen werden unverändert gespeichert, und beim Percent-Encoding eines Octets wird die Form `pct-encoded = "%" HEXDIG HEXDIG` verwendet. Nicht-ASCII-Zeichen dürfen nicht direkt als literale Bytes eingefügt werden.
- Da `relative-part` auch `path-empty` sein kann, ist auch eine leere Bytefolge grammatikalisch ein gültiges `relative-ref`.
- Base URI, Resolution Context und Auflösungsergebnis gehören zum Kontext außerhalb dieses Formats.
- Innerhalb eines WORD steht das obere Byte zuerst. Ist die Byte-Zahl ungerade (ungerader Code), muss das ungenutzte untere Byte des letzten WORD `00` sein.
- Die Zahl der Payload-WORD ist `ceil(Byte-Zahl/2)`. Ist der Code ungerade, das untere Byte des letzten WORD aber nicht `00`, wird der Wert abgelehnt.

## Normgrundlage {#표준-근거}

- `relative-ref`, URI-Zeichen und die Percent-Encoding-Grammatik folgen [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Das Paar aus geradem und ungeradem Code, Zero Padding, GEUL-TAG/Length und die 16-Bit-WORD-Anordnung sind Framing-Regeln dieses Formats. Base URI und das Ergebnis der Referenzauflösung gehören zum Kontext der RFC, werden aber nicht in den Payload aufgenommen.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 2 WORD Issuer, 2 WORD Codec-Nummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](../../record.md)).
- 0 Byte sind als leeres `relative-ref` semantisch zulässig und haben kein Payload-WORD. Die physische Anordnung dazu ist das unten genannte offene Problem.

## Beispiel {#예시}

- `a/b?x=1` sind 7 Byte (ungerade), daher Codec-Nummer `0x00008001` und Payload `612F 623F 783D 3100`. Es sind insgesamt 9 WORD, also `LLLL=1000`. Das Ganze lautet `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## Offene Probleme {#열린-문제}

- Die physische Anordnung des leeren `relative-ref` (0 Byte). Ein Record ohne Payload passt nicht zur Regel „mindestens 1 WORD Payload“ und ist daher noch nicht festgelegt.
