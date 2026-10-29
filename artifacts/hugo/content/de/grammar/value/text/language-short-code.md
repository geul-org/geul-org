---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE ist eine GEUL-Sprachcode-Value, die in 1 WORD einen von der GEUL Language Registry nummerierten BCP-47-Tag enthält (Codec 0x48). Die Registry sind die ENUMs des Spezifikationsdokuments dieses Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE ist ein komprimierter GEUL-Sprachcode, der in 1 WORD einen BCP-47-Tag enthält, der in der GEUL Language Registry eine Nummer hat. Der Payload ist genau 1 WORD.

## Layout

- Code: direkter Value-Code `0x48`. Familie TEXT.
- Der Payload ist genau 1 WORD, ein unsigned 16-Bit-Code.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  insgesamt 2 WORD
Payload WORD 1st (16 Bit)           Nummer der GEUL Language Registry (uint16)
```

## Interpretation und Gültigkeit

- Das Payload-WORD wird als unsigned 16-Bit-Ganzzahl gelesen.
- Dieser Wert ist ein von der GEUL Language Registry vergebener Tag. Die normative Form der Registry ist das Spezifikationsdokument dieses Codec, `0x0000/0x0000000000000848`. Jeder Codewert hat ein [ENUM](/de/grammar/edge/enum/) auf dem FIELD `code`, und der mit [BIND](/de/grammar/edge/bind/) an die Edge Id dieses ENUM gebundene Name ist der BCP-47-Tag in kanonischer Schreibung.
- Die Registry ist eine geschlossene Liste. Ein Wert ohne ENUM im Spezifikationsdokument ist invalid. Diese Codec-Regel geht der allgemeinen ENUM-Regel („ein nicht deklarierter Codewert ist kein Fehler“) vor.
- Nummern erhalten drei Arten von Tags.
  - Die `Type: language`-Einträge der IANA Language Subtag Registry außer `Scope: private-use` (`qaa..qtz`). Collection, macrolanguage und special (`mul`, `und`, `zxx`, `mis`) werden nicht ausgenommen.
  - Tags, die IANA als Ganzes registriert: grandfathered und redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan` usw.).
  - Gültige zusammengesetzte Tags, die in öffentlichen CC0-Quellen beobachtet wurden (`pt-BR`, `en-GB`, `be-tarask` usw.). Sie bestehen nur aus language-, extlang-, script-, region- und variant-Subtags. Tags mit extension (`-u-`, `-t-`) oder private-use (`-x-`) werden nicht aufgenommen.
- Ein Tag ohne Nummer kann nicht in diesem Format geschrieben werden. Er wird als [LANGUAGE-BCP47-CODE](/de/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`) geschrieben. SHORT-CODE hat keinen Escape-Weg.
- `0x0000` und `0xffff` werden nie vergeben. Beide sind in dieser Value invalid. Keiner von beiden wird im Sinne von `null`, `unknown` oder `und` verwendet.
- Die Wertebereiche sind eine Vergabekonvention. Ein Decoder schließt nicht aus dem Bereich eines Werts auf die Art des Tags. Die Bedeutung eines Werts kommt allein aus dem Spezifikationsdokument.

| Bereich | Verwendung |
|---|---|
| `0x0000` | Nie vergeben (invalid) |
| `0x0001`–`0x3fff` | Tags aus einem einzigen language-Subtag |
| `0x4000`–`0x7fff` | Tags aus zwei oder mehr Subtags (ganze IANA-Tags, beobachtete zusammengesetzte Tags) |
| `0x8000`–`0xfffe` | Überlauf. Ist ein Block darüber voll, geht die Vergabe hier weiter |
| `0xffff` | Nie vergeben (invalid) |

- Die erste Ausgabe nummeriert die Tags innerhalb eines Blocks in ASCII-Reihenfolge der Kleinschreibung. Im Block `0x4000` kommen zuerst die ganzen IANA-Tags (grandfathered und redundant gemischt, ASCII-Reihenfolge), danach die beobachteten zusammengesetzten Tags (ASCII-Reihenfolge). Weder die physische Reihenfolge der IANA-Datei noch die Gebrauchshäufigkeit ist eine Nummerierungsregel.
- Die Vergabe hängt nur an (append-only). Ein neuer Tag wird ans Ende seines Blocks angehängt, ist der Block voll, im Überlaufbereich. Der Tag (ohne Beachtung der Groß-/Kleinschreibung) einer einmal vergebenen Nummer wird weder geändert noch gelöscht noch wiederverwendet.
- Ein neuer Tag kommt hinzu, indem in einer neuen Version des Spezifikationsdokuments ein ENUM und ein BIND angehängt werden. Bestehende ENUMs und BINDs werden nicht verändert. Daher ist jede Version eine Obermenge der vorigen.
- Sind alle 65.534 Nummern vergeben, wird nichts mehr vergeben. Spätere neue Tags werden als LANGUAGE-BCP47-CODE geschrieben. Die Ausdruckskraft sinkt nicht, es entfällt nur der Kompressionsgewinn.
- Gleiche Sprache: SHORT-CODE `n` und der LANGUAGE-BCP47-CODE des Tags, den die Registry an `n` bindet (ohne Beachtung der Groß-/Kleinschreibung), sind dieselbe Sprache.
- Eine Ausgabe der Registry ist eine Version des Spezifikationsdokuments. Jede Ausgabe vermerkt die zugrunde liegende IANA-Registry-Datei (File-Date, SHA-256) als [SOURCE](/de/grammar/edge/source/) im HEAD des Spezifikationsdokuments. Muss angegeben werden, mit welcher Ausgabe ein Wert interpretiert wurde, wird diese Version (`0x0000/0x0000000000000848@n`) mit ihm aufbewahrt.
- Eine Codec-Spezifikation kann denselben 1-WORD-Code in einem Rohwertfeld ohne TAG halten ([CODEC](/de/grammar/codec-spec/#codec) eines Rohwertfelds). Das ist eine Regel dieser Codec-Spezifikation; die wire form einer eigenständigen Value ist immer TAG 1 WORD + Payload 1 WORD.

## Normgrundlage

- Die Bedeutung der Tags und die Gültigkeit der Subtags folgen der [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) und [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA und IETF stellen ihre Rechte an den Protokoll-Registries unter CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Die Registry-Nummern (append-only-Vergabe in ASCII-Reihenfolge, Blockaufteilung, nie vergebene `0x0000` und `0xffff`, geschlossene Liste), dass die ENUMs des Spezifikationsdokuments die normative Form sind, und die Abgrenzung zur TAG-losen Einbettung in ein Rohwertfeld sind GEUL-Regeln.

## Länge

- Insgesamt sind es genau 2 WORD, TAG 1 WORD plus Payload 1 WORD, mit direkter Länge `LLLL=0001`. Es gibt keinen Length-Erweiterungs-TAG, keinen descriptor und kein padding.
- Ist der Payload nicht genau 1 WORD, wird abgelehnt.

## Beispiel

Nummern der Registry v2 (Spezifikationsdokument `0x0000/0x0000000000000848` Version 2, IANA File-Date 2026-09-17). Vergeben sind 8.678 Tags (language 8.275, grandfathered 26, redundant 67, beobachtete zusammengesetzte 310).

| Tag | Code | Alle WORD |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- Im Spezifikationsdokument ist `en` das `ENUM #2 0x0784` und das `BIND "en"` auf dessen Edge Id.
- `de-x-formal` (private-use) und `nl-u-sd-bebru` (extension) haben keine Nummer und werden daher als LANGUAGE-BCP47-CODE geschrieben.

## Offene Fragen

- Lesen über Ausgaben hinweg: Wird eine Nummer, die neuer ist als die Ausgabe des Lesers, als invalid verworfen oder mit ihrem Rohwert als „unbekannter Code“ bewahrt? Da append-only, genügt stets die neueste Ausgabe, doch Offline-Decoder brauchen eine Regel.
- Kanonische Form: Soll (SHOULD/MUST) ein Tag mit Nummer als SHORT-CODE geschrieben werden? Mit MUST ist die Schreibung eindeutig, aber eine neue Ausgabe machte früher geschriebene Dokumente nicht kanonisch.
- Wie deprecated-Tags und Preferred-Value im Spezifikationsdokument ausgedrückt werden (die aktuelle Ausgabe hat sie nicht).
- Das Verfahren zum Anhängen beobachteter zusammengesetzter Tags (Quellen, Beobachtungsschwelle).

## Verwandte Seiten

- [LANGUAGE-BCP47-CODE](/de/grammar/value/text/language-bcp47-code/), [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/), [LABEL](/de/grammar/edge/label/)
- [Codec-Spezifikationsdokument](/de/grammar/codec-spec/), [ENUM](/de/grammar/edge/enum/), [BIND](/de/grammar/edge/bind/), [SOURCE](/de/grammar/edge/source/)
