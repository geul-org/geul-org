---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE ist ein GEUL-Sprachcode-Value, der nur den Primary-Language-Subtag auf 1 WORD komprimiert enthält (Codec 0x48)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE ist ein komprimierter GEUL-Sprachcode, der nicht den vollständigen BCP-47-Tag, sondern nur den Primary-Language-Subtag enthält. Der Payload ist genau 1 WORD.

## Layout

- Code: direkter Value-Code `0x48`. Familie TEXT.
- Der Payload ist ein vorzeichenloser 16-Bit-Code von genau 1 WORD.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  insgesamt 2 WORD
Payload WORD 1st (16 Bit)           GEUL language code (uint16)
```

## Interpretation und Gültigkeit

- Der Payload von 1 WORD wird als vorzeichenlose 16-Bit-Ganzzahl gelesen.
- Dieser Wert ist der komprimierte Code eines Primary-Language-Subtags. script, region, variant, extension und private-use sind nicht enthalten. Werden solche Angaben gebraucht, verwendet man [LANGUAGE-BCP47-CODE](/de/grammar/value/text/language-bcp47-code/) (`0x46`/`0x47`).
- `0x0000..0xfffe` ist der Vergabebereich der GEUL Language Registry. Auch innerhalb dieses Bereichs ist ein Wert invalid, wenn er in der betreffenden Registry-Version nicht tatsächlich vergeben ist.
- Die anfänglichen Vergabeziele sind die öffentlichen Records mit `Type: language` eines bestimmten IANA-Language-Subtag-Registry-Snapshots ohne `Scope: private-use`. collections, macrolanguage und special werden nicht ausgenommen.
- Bei der anfänglichen Vergabe werden diese öffentlichen Records nach ASCII-Subtag sortiert und mit IDs versehen. Die physische Reihenfolge der IANA-Datei ist keine ID-Regel.
- Neue Subtags mit `Type: language` werden später ohne Änderung bestehender Nummern am Ende angehängt (append-only).
- Die IDs deprecated Language-Subtags werden nicht gelöscht oder wiederverwendet. Die Preferred-Value-Beziehung und der deprecated-Status werden als Registry-Metadaten bewahrt.
- `0xffff` ist als Erweiterungs-Escape reserviert. Bis ein Erweiterungsformat eigens definiert ist, ist es in einem eigenständigen LANGUAGE-SHORT-CODE-Value invalid. Es wird nicht mit Bedeutungen wie `null`, `unknown` oder `und` verwendet.
- Eine andere Codec-Spezifikation kann künftig Interpretationsregeln nach `0xffff` definieren. Das bedeutet aber nicht, dass diese Regel den Payload dieses Formats verlängert oder nachfolgenden Payload zulässt.
- Eine Codec-Spezifikation kann denselben 1-WORD-Code ohne TAG in einem Rohwert-Feld ablegen (ein [CODEC](/de/grammar/codec-spec/#codec) beim Rohwert-Feld). Das ist eine Regel dieser Codec-Spezifikation, und die Wire-Form des eigenständigen Value ist stets TAG 1 WORD + Payload 1 WORD.
- Um die Bedeutung eines Wertes zu beurteilen, muss man die verwendete Version der GEUL Language Registry und das Datum des von dieser Version festgelegten IANA-Registry-Snapshots zusammen bewahren.

## Normgrundlage

- Die Ursprungs-Registry der Primary-Language-Subtags und die deprecated-/Preferred-Value-Metadaten richten sich nach der [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Die Grundbedeutung des BCP-47-Language-Subtag-Systems richtet sich nach [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- ID-Vergabe nach ASCII-Sortierung (append-only), die Reservierung von `0xffff` und die Abgrenzung zur TAG-losen Einbettung in einem Rohwert-Feld sind GEUL-Regeln.

## Länge

- Insgesamt sind es genau 2 WORD aus 1 WORD TAG und 1 WORD Payload, mit der direkten Länge `LLLL=0001`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 1 WORD, wird abgelehnt.

## Beispiel

- Da Registry-Snapshot und tatsächliche Codetabelle noch nicht feststehen, wird kein Beispiel für die numerische ID einer bestimmten Sprache angegeben.

## Offene Fragen

- Datum des anfänglichen IANA-Snapshots, Versionsname der GEUL Language Registry, vollständige Zuordnungstabelle. Bis dies feststeht, werden keine konkreten Zahlenbeispiele oder Codetabellen festgelegt.
