---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI ist ein Value, der eine ASCII-Bytefolge der Grammatik eines URI nach RFC 3986 (absoluter URI mit scheme) enthält. Es wird das Codepaar 0x44/0x45 für gerade/ungerade Bytezahl verwendet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI ist ein Value, der eine ASCII-Bytefolge der Grammatik `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` von RFC 3986 enthält. Da er das scheme enthält, braucht die Interpretation keinen Basis-URI.

## Layout

- Code: direkter Value-Code `0x44` (gerade Bytezahl) und `0x45` (ungerade Bytezahl). Familie TEXT.
- Die Bytezahl ergibt sich aus dem niederwertigsten Bit des Codec und der Zahl der Payload-WORD. Sie ist `2 × Anzahl der Payload-WORD − niederwertigstes Bit`, und ein Byte Count steht nicht dabei ([Value](/de/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interpretation und Gültigkeit

- Die Bytefolge muss der Grammatik `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` von RFC 3986 entsprechen. query und fragment dürfen enthalten sein.
- Die Terminale der URI-Grammatik sind US-ASCII-Zeichen. Zulässige ASCII-Zeichen werden unverändert gespeichert, und beim Percent-Encoding von Oktetten wird das Format `pct-encoded = "%" HEXDIG HEXDIG` verwendet. Nicht-ASCII-Zeichen dürfen nicht als literale Bytes eingefügt werden.
- `scheme` und `:` müssen enthalten sein. Relative Referenzen schreibt man mit [URI-RELATIVE-REF](/de/grammar/value/text/uri-relative-ref/) (IETF-Formatnummern `0x8000` und `0x8001`).
- Die URI-Produktion von RFC 3986 lässt keine leere Zeichenkette zu. Ein Record mit 0 Byte ist nicht gültig.
- Innerhalb eines WORD steht das obere Byte zuerst. Bei ungerader Bytezahl (ungerader Code) muss das nicht verwendete untere Byte des letzten WORD `00` sein.
- Die Zahl der Payload-WORD ist `ceil(Bytezahl/2)`. Ist es ein ungerader Code und das untere Byte des letzten WORD nicht `00`, wird abgelehnt.

## Normgrundlage

- `URI`, URI-Zeichen und die Grammatik des Percent-Encoding richten sich nach [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Codepaar aus gerade/ungerade, Zero-Padding sowie GEUL-TAG/Length und die 16-Bit-WORD-Anordnung sind Framing-Regeln dieses Formats.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).

## Beispiel

- `https://example.com/` hat ASCII 20 Byte (gerade) und ist daher `URI-EVEN` (`0x44`).
- Der Payload sind 10 WORD `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.
- TAG 1 WORD und Payload 10 WORD ergeben insgesamt 11 WORD, also `LLLL=1010`. Der gesamte Record ist `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.

## GEUL Archive URI

`archive.geul.org` ist ein geplanter unveränderlicher Inhaltsspeicher, über den GEUL auf große Inhalte wie externe Binärdateien und Dokumente verweisen soll. Er ist noch nicht in Betrieb. Das empfohlene Adressformat ist `https://archive.geul.org/sha256/{digest}`. Dieselbe Bytefolge muss denselben URI haben, und nach der Veröffentlichung dürfen die Bytes unter demselben URI nicht geändert werden.

Ein URI-Value stellt nur die Position oder Adresszeichenkette externer Inhalte dar und garantiert weder Identität noch Unveränderlichkeit des Ziels selbst. Binärdaten und Texte, die den maximalen Bereich eines Inline-Values überschreiten, können über einen Archive-URI referenziert werden. In den Metadaten eines gespeicherten Objekts sind folgende Angaben festzuhalten.

- Original-URI und Zeitpunkt der Erfassung
- SHA-256 und Byte Length
- MIME type
- license identifier und version
- Urheber, Quelle und Hinweise
- URI der Lizenzgrundlage und, falls nötig, eine Kopie der Grundlage zum Zeitpunkt der Erfassung

Ob etwas erfasst werden kann, entscheidet nicht, ob es kostenlos zugänglich ist, sondern ob die Weiterverbreitungsberechtigung ausdrücklich bestätigt ist. Anzuwendende Lizenzbedingungen wie Namensnennung, nicht kommerziell, keine Bearbeitung und Weitergabe unter gleichen Bedingungen sind einzuhalten. Bei Dokumenten und Inhalten wird eine ausdrückliche Lizenz wie Creative Commons festgehalten, bei Software möglichst die SPDX License ID.

Auch wenn die Bereitstellung wegen Rechtsfragen oder Korrekturen eingestellt wird, dürfen unter dem bisherigen URI keine anderen Bytes abgelegt werden. Dieser URI muss einen tombstone mit Grund und Zeitpunkt der Einstellung zurückgeben, und der ursprüngliche Digest und das Prüfprotokoll müssen bewahrt werden. Verbietet jedoch eine gesetzliche Pflicht die Aufbewahrung des Prüfprotokolls, hat diese Pflicht Vorrang.

Ein Archive-URI liefert Zugriffsort und Inhalts-Digest zusammen. Diese Regeln zu Content-Address und Unveränderlichkeit sind Richtlinie des GEUL-Archive-Profils, und die allgemeine Grammatik des URI-Value ist nicht an `archive.geul.org` gebunden.
