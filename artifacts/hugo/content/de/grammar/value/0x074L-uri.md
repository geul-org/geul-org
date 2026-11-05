---
title: "URI (0x074L·0x075L)"
weight: 116
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI ist ein Value, der eine ASCII-Bytefolge nach der Grammatik des RFC-3986-URI (absoluter URI mit scheme) enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI ist ein Value, der eine ASCII-Bytefolge nach der Grammatik des RFC-3986-URI (absoluter URI mit scheme) enthält. Er verwendet das Codepaar 0x074L/0x075L für gerade und ungerade Bytes.

| Eintrag | Wert |
|---|---|
| Name | `URI` (gerade/ungerade Paarung. Die Namen je Code stehen in der Mitgliedertabelle unten) |
| TAG ID | `0x074L`·`0x075L` |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 20~21 |
| Kind | Value · Familie: TEXT |
| Indexbeschreibung | ASCII-Bytefolge der RFC-3986-Produktion `URI`. Gerade/ungerade Bytes |
| Hugo-Pfad | `value/text/uri.md` |

## Mitglieder {#구성원}

Diese Seite behandelt die zwei Codes einer gerade/ungerade-Paarung gemeinsam. Der gerade Code gilt für Werte mit gerader Byteanzahl, der ungerade Code für Werte mit ungerader Byteanzahl ([Record und TAG WORD](../record.md#가변-길이-바이트열)). Es gibt ein Codec-Dokument je Code. Die Felder beider Codec-Dokumente sind gleich; nur das DECLARE-Ziel und der Name (BIND) unterscheiden sich.

| TAG ID | Name | Byteanzahl | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x074L` | `URI-EVEN` | gerade | `0x00000740` | `0x00000000/codecs/0x00000740/` | `0000 0111 0100 LLLL` |
| `0x075L` | `URI-ODD` | ungerade | `0x00000750` | `0x00000000/codecs/0x00000750/` | `0000 0111 0101 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restliche Rohwert-Bytes (`0xFFFF`) |  |  |

URI ist ein Value, der eine ASCII-Bytefolge nach der Grammatik `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` aus RFC 3986 enthält. Da er das scheme enthält, braucht die Interpretation keinen base URI.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x074L` (gerade Bytes) und `0x075L` (ungerade Bytes). Familie TEXT.
- Die Byteanzahl ergibt sich aus dem niedrigstwertigen Bit des Codecs und der Anzahl der Payload-WORDs. Sie ist `2 × Anzahl der Payload-WORDs − niedrigstwertiges Bit`; einen Byte Count gibt es nicht ([Value](_index.md)).

```
TAG WORD          0000 0111 010P LLLL      Codec 0x074L/0x075L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORDs oder mehr
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Bytefolge muss der Grammatik `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` aus RFC 3986 entsprechen. Sie darf query und fragment enthalten.
- Die Terminale der URI-Grammatik sind US-ASCII-Zeichen. Erlaubte ASCII-Zeichen werden unverändert gespeichert; beim Percent-Encoding eines Oktetts wird das Format `pct-encoded = "%" HEXDIG HEXDIG` verwendet. Nicht-ASCII-Zeichen dürfen nicht als literale Bytes direkt eingefügt werden.
- `scheme` und `:` sind zwingend enthalten. Für relative Referenzen wird [URI-RELATIVE-REF](ietf.geul.org/uri-relative-ref.md) verwendet (IETF-Codec-Nummern `0x00008000`·`0x00008001`).
- Die URI-Produktion von RFC 3986 erlaubt keine leere Zeichenkette. Ein Record mit 0 Bytes ist ungültig.
- Innerhalb eines WORDs steht das obere Byte zuerst. Bei ungerader Byteanzahl (ungerader Code) muss das ungenutzte untere Byte des letzten WORDs `00` sein.
- Die Anzahl der Payload-WORDs ist `ceil(Byteanzahl/2)`. Ist der Code ungerade und das untere Byte des letzten WORDs nicht `00`, wird der Wert abgelehnt.

## Normative Grundlage {#표준-근거}

- `URI`, URI-Zeichen und die Grammatik des Percent-Encodings folgen [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Das gerade/ungerade Codepaar, das Zero Padding sowie TAG/Length von GEUL und die Anordnung in 16-Bit-WORDs sind die Framing-Regeln dieses Formats.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORDs aus TAG (1 WORD), Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORDs wird die direkte Länge verwendet, ab 15 WORDs die erweiterte Länge `1110`·`1111`; auch der Erweiterungs-TAG zählt zur Gesamtanzahl ([Length](../record.md)).

## Beispiel {#예시}

- `https://example.com/` hat 20 ASCII-Bytes (gerade) und ist daher `URI-EVEN` (`0x074L`).
- Die Payload besteht aus 10 WORDs: `6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.
- TAG (1 WORD) und Payload (10 WORDs) ergeben insgesamt 11 WORDs, also `LLLL=1010`. Das Ganze ist `074A 6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`.

## GEUL Archive URI {#geul-archive-uri}

`archive.geul.org` ist als unveränderlicher Inhaltsspeicher gedacht, mit dem GEUL große Inhalte wie externe Binärdaten und Dokumente referenziert; er wird noch nicht betrieben. Das empfohlene Adressformat ist `https://archive.geul.org/sha256/{digest}`. Dieselbe Bytefolge muss denselben URI haben, und nach der Veröffentlichung dürfen die Bytes unter demselben URI nicht mehr geändert werden.

Ein URI-Value gibt nur den Ort oder die Adresszeichenkette eines externen Inhalts an; er garantiert weder die Identität noch die Unveränderlichkeit des Ziels selbst. Binärdaten und Texte, die den Höchstumfang eines Inline-Values überschreiten, können über einen Archive-URI referenziert werden. In den Metadaten des gespeicherten Objekts sind folgende Angaben festzuhalten.

- Original-URI und Zeitpunkt der Erfassung
- SHA-256 und Byte Length
- MIME type
- license identifier und version
- Urheber, Quelle und Hinweise
- URI der Lizenzgrundlage und, falls nötig, eine Kopie der Grundlage zum Zeitpunkt der Erfassung

Ob etwas erfasst werden darf, richtet sich nicht danach, ob es kostenlos zugänglich ist, sondern danach, ob das Recht zur Weiterverbreitung ausdrücklich bestätigt ist. Die geltenden Lizenzbedingungen wie Namensnennung, nicht kommerziell, keine Bearbeitung und Weitergabe unter gleichen Bedingungen sind einzuhalten. Für Dokumente und Inhalte wird eine ausdrückliche Lizenz wie Creative Commons angegeben, für Software möglichst eine SPDX License ID.

Auch wenn die Bereitstellung wegen Rechtsfragen oder Korrekturen eingestellt wird, dürfen unter dem bisherigen URI keine anderen Bytes abgelegt werden. Dieser URI muss einen Tombstone mit Grund und Zeitpunkt der Einstellung zurückgeben, und der ursprüngliche digest und die Prüfprotokolle müssen bewahrt werden. Verbietet jedoch eine gesetzliche Pflicht die Aufbewahrung der Prüfprotokolle, hat diese Pflicht Vorrang.

Ein Archive-URI liefert zugleich den Zugriffsort und den Inhalts-digest. Diese Regeln zu Content-Address und Unveränderlichkeit sind Richtlinie des GEUL-Archive-Profils; die allgemeine Grammatik des URI-Values hängt nicht von `archive.geul.org` ab.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000740/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000074000000000
BODY
#1 DECLARE 0x0740
#2 FIELD #1 rest
#3 BIND #1 "URI-EVEN"
#4 BIND #2 "bytes"
```

Oben steht das Codec-Dokument von `URI-EVEN` (`0x074L`). Das Codec-Dokument des anderen Mitglieds (`URI-ODD`) unterscheidet sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im unter `#1` gebundenen Namen (BIND).
