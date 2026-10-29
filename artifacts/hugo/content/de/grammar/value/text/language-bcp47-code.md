---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE ist ein Value, der einen vollständigen BCP-47-Language-Tag als ASCII-Bytefolge enthält. Es wird das Codepaar 0x46/0x47 für gerade/ungerade Bytezahl verwendet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE ist ein Value, der einen vollständigen BCP-47-Language-Tag enthält. Er wird verwendet, wenn eine Sprache einschließlich script, region und variant genau angegeben werden soll.

## Layout

- Code: direkter Value-Code `0x46` (gerade Bytezahl) und `0x47` (ungerade Bytezahl). Familie TEXT.
- Die Bytezahl ergibt sich aus dem niederwertigsten Bit des Codec und der Zahl der Payload-WORD. Sie ist `2 × Anzahl der Payload-WORD − niederwertigstes Bit`, und ein Byte Count steht nicht dabei ([Value](/de/grammar/value/)).
- Der Payload ist kein UTF-8-Text, sondern die ASCII-Bytefolge des BCP-47-Tags.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interpretation und Gültigkeit

- Die Bytefolge muss ein wohlgeformter BCP-47-Language-Tag nach RFC 5646 sein. Eine leere Zeichenkette ist nicht zulässig.
- Der Payload verwendet nur ASCII-Buchstaben, Ziffern und das Hyphen-Minus `-`. Das Trennzeichen ist stets ASCII `-`; `_`, Leerzeichen und Nicht-ASCII-Zeichen sind nicht zulässig.
- Der Vergleich von BCP-47-Tags unterscheidet nicht zwischen Groß- und Kleinschreibung. Das kanonische GEUL-Profil schreibt alle Trennzeichen als `-` und serialisiert Subtags für language/extlang/variant/extension/private-use in Kleinbuchstaben, script in Titlecase und region in Großbuchstaben.
- Wohlgeformtheit allein genügt nicht. Die Gültigkeit registrierter Subtags und grandfathered Tags wird anhand eines bestimmten IANA-Language-Subtag-Registry-Snapshots beurteilt, und das Snapshot-Datum oder die Registry-Version muss mit bewahrt werden.
- private-use Tags und private-use Subtags sind zulässig, wenn sie nach der Grammatik von RFC 5646 wohlgeformt sind. Ihre Bedeutung hängt jedoch von der Vereinbarung der Beteiligten ab und wird von der IANA-Registry nicht definiert, daher garantieren sie keine allgemeine Interoperabilität.
- Hat ein deprecated Subtag oder grandfathered Tag im selben Snapshot einen Preferred-Value, schreibt die kanonische GEUL-Form diesen Ersatzwert in kanonischer Groß-/Kleinschreibung. Ein Tag in deprecated-Schreibweise kann als Eingabe interpretiert werden, ist aber keine kanonische Speicherform.
- BCP 47 ist ein ASCII-Profil, daher gilt die Anforderung einer Unicode-Normalisierung wie UTF-8 NFC nicht.
- Innerhalb eines WORD steht das obere Byte zuerst. Bei ungerader Bytezahl (ungerader Code) muss das nicht verwendete untere Byte des letzten WORD `00` sein.
- Die Zahl der Payload-WORD ist `ceil(Bytezahl/2)`. Ist es ein ungerader Code und das untere Byte des letzten WORD nicht `00`, wird abgelehnt.

## Normgrundlage

- Grammatik des Language-Tags, Interpretation ohne Unterscheidung von Groß-/Kleinschreibung und das Konzept von deprecated/Preferred-Value richten sich nach [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Die Registry, die die Gültigkeit von Tags beurteilt, ist die [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Codepaar aus gerade/ungerade, Zero-Padding, die Speicherpolitik der kanonischen Groß-/Kleinschreibung und die Berechnung der Length sind GEUL-Framing-Regeln.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Length](/de/grammar/record/)).

## Verhältnis zu LANGUAGE-SHORT-CODE

- Ein Tag, der in der GEUL Language Registry eine Nummer hat, kann in 1 WORD als [LANGUAGE-SHORT-CODE](/de/grammar/value/text/language-short-code/) geschrieben werden.
- Ein Tag ohne Nummer in der Registry (auch Tags mit extension oder private-use) wird als LANGUAGE-BCP47-CODE geschrieben. Auch wenn der Originaltext des vollständigen Tags bewahrt werden muss, verwendet man LANGUAGE-BCP47-CODE.
- SHORT-CODE `n` und der LANGUAGE-BCP47-CODE des Tags, den die Registry an `n` bindet (ohne Beachtung der Groß-/Kleinschreibung), sind dieselbe Sprache.

## Beispiel

- `ko-KR` hat ASCII 5 Byte (ungerade), also `LANGUAGE-BCP47-CODE-ODD` (`0x47`), der Payload ist `6b6f 2d4b 5200`.
- TAG 1 WORD und Payload 3 WORD ergeben insgesamt 4 WORD, also `LLLL=0011`. Der gesamte Record ist `09C7 6b6f 2d4b 5200`.
