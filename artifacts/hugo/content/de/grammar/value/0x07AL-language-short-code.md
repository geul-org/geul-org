---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE ist ein komprimierter GEUL-Sprachcode, der ein im GEUL Language Registry nummeriertes BCP-47-Tag in 1 WORD enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `LANGUAGE-SHORT-CODE` (BIND im Spezifikationsdokument `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000007A0/` (DECLARE-Ziel `07A0`) |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 26 |
| Kind | Value · Familie: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Als Nummer des GEUL Language Registry geschriebenes BCP-47-Tag (Payload 1 WORD) |
| Hugo-Pfad | `value/text/language-short-code.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | Rohwert 1 WORD |  | 8678 ENUMs. Z. B. `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE ist ein komprimierter GEUL-Sprachcode, der ein im GEUL Language Registry nummeriertes BCP-47-Tag in 1 WORD enthält. Die Payload ist genau 1 WORD.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x07AL`. Familie TEXT.
- Die Payload ist ein vorzeichenloser 16-Bit-Code von genau 1 WORD.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  insgesamt 2 WORDs
Payload WORD 1st (16 Bit)           Nummer im GEUL Language Registry (uint16)
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Das 1 WORD der Payload wird als vorzeichenlose 16-Bit-Ganzzahl gelesen.
- Dieser Wert ist ein vom GEUL Language Registry zugewiesenes Tag. Die maßgebliche Darstellung des Registrys ist das Spezifikationsdokument dieses Codecs, `0x00000000/codecs/0x000007A0`. Für jeden Codewert gibt es im FIELD `code` ein [ENUM](../edge/0x0BDL-enum.md), und der per [BIND](../edge/0x0A3L-bind.md) an dessen Edge Id gebundene Name ist das BCP-47-Tag in kanonischer Groß-/Kleinschreibung.
- Das Registry ist eine geschlossene Liste. Ein Wert ohne ENUM im Spezifikationsdokument ist invalid. Diese Codec-Regel hat Vorrang vor der allgemeinen ENUM-Regel („Ein nicht deklarierter Codewert ist kein Fehler“).
- Zugewiesen werden folgende drei Gruppen.
  - Die Records `Type: language` der IANA Language Subtag Registry ohne `Scope: private-use` (`qaa..qtz`). collection, macrolanguage und special (`mul`·`und`·`zxx`·`mis`) werden nicht ausgenommen.
  - Von IANA als Ganzes registrierte Tags: grandfathered und redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan` usw.).
  - In öffentlichen CC0-Quellen beobachtete gültige Kombinationstags (`pt-BR`, `en-GB`, `be-tarask` usw.). Das sind Tags, die nur aus den Subtags language, extlang, script, region und variant bestehen. Tags mit extension (`-u-`·`-t-`) und private-use (`-x-`) werden nicht aufgenommen.
- Ein Tag ohne Nummer kann nicht in diesem Format geschrieben werden. Es wird als [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`) geschrieben. Innerhalb des SHORT-CODE gibt es keinen Escape-Pfad.
- `0x0000` und `0xFFFF` werden dauerhaft nicht zugewiesen. In diesem Value sind beide invalid. Keiner von beiden wird im Sinne von `null`, `unknown` oder `und` verwendet.
- Die Wertebereiche sind eine Zuweisungskonvention. Ein Decoder schließt nicht aus dem Wertebereich auf die Art des Tags. Die Bedeutung eines Werts stammt allein aus dem Spezifikationsdokument.

| Bereich | Verwendung |
|---|---|
| `0x0000` | nicht zugewiesen (invalid) |
| `0x0001`–`0x3FFF` | Tags mit genau einem language-Subtag |
| `0x4000`–`0x7FFF` | Tags mit zwei oder mehr Subtags (von IANA als Ganzes registrierte Tags, beobachtete Kombinationstags) |
| `0x8000`–`0xFFFE` | Überlauf. Ist der obige Block voll, wird hier fortgesetzt |
| `0xFFFF` | nicht zugewiesen (invalid) |

- Die erste Fassung vergibt die Nummern innerhalb eines Blocks in ASCII-Reihenfolge der kleingeschriebenen Tags. Im Block `0x4000` folgen auf die von IANA als Ganzes registrierten Tags (ASCII-Reihenfolge, grandfathered und redundant gemischt) die beobachteten Kombinationstags (ASCII-Reihenfolge). Die physische Reihenfolge der IANA-Datei und die Verwendungshäufigkeit sind keine Nummerierungsregel.
- Die Zuweisung erfolgt nur durch Anhängen (append-only). Ein neues Tag wird ans Ende des Blocks angehängt, und ist der Block voll, an den Überlaufbereich. Das Tag einer einmal vergebenen Nummer (ohne Beachtung der Groß-/Kleinschreibung) wird nicht geändert, gelöscht oder wiederverwendet.
- Neue Tags werden mit ENUM und BIND in einer neuen Version des Spezifikationsdokuments angehängt. Bestehende ENUMs und BINDs werden nicht geändert. Daher ist jede Version eine Obermenge der vorherigen.
- Sind alle 65.534 Nummern vergeben, wird nichts mehr zugewiesen. Neue Tags danach werden als LANGUAGE-BCP47-CODE geschrieben. Die Ausdrucksmöglichkeiten verringern sich nicht; es fehlt nur der Kompressionsvorteil.
- Dieselbe Sprache: Der SHORT-CODE `n` und der LANGUAGE-BCP47-CODE des Tags, das das Registry an `n` bindet (ohne Beachtung der Groß-/Kleinschreibung), bezeichnen dieselbe Sprache.
- Die Registry-Fassung ist die Version des Spezifikationsdokuments. Jede Fassung vermerkt die zugrunde gelegte IANA-Registry-Datei (File-Date, SHA-256) als [SOURCE](../edge/0x0C0L-source.md) im HEAD des Spezifikationsdokuments. Muss die Fassung genannt werden, mit der ein Wert interpretiert wurde, wird diese Version ([CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, `0x000007A0`, Versions-ID `n`)) mit abgelegt.
- Eine Codec-Spezifikation kann denselben 1-WORD-Code als Rohwert-Feld ohne TAG enthalten ([CODEC](../codec-spec.md#codec) eines Rohwert-Felds). Das ist eine Regel dieser Codec-Spezifikation; die Wire Form eines eigenständigen Values ist immer TAG (1 WORD) + Payload (1 WORD).

## Normative Grundlage {#표준-근거}

- Bedeutung des Tags und Gültigkeit der Subtags folgen der [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) und [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). IANA und IETF stellen ihre Rechte an Protokoll-Registries unter CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Die Registry-Nummern (append-only Zuweisung in ASCII-Reihenfolge, Blockaufbau, `0x0000`·`0xFFFF` nicht zugewiesen, geschlossene Liste), dass die ENUMs des Spezifikationsdokuments die maßgebliche Darstellung sind, und die Abgrenzung zum Embedding in Rohwert-Feldern ohne TAG sind GEUL-Regeln.

## Länge {#길이}

- Die Gesamtlänge ist die Summe aus TAG (1 WORD) und Payload (1 WORD), also genau 2 WORDs, mit direkter Länge `LLLL=0001`. Length-Erweiterungs-TAG, descriptor und padding gibt es nicht.
- Ist die Payload nicht genau 1 WORD, wird der Wert abgelehnt.

## Beispiel {#예시}

Nummern des Registrys v2 (Spezifikationsdokument `0x00000000/codecs/0x000007A0` Version 2, IANA File-Date 2026-09-17). Zugewiesen wurden 8.678 (language 8.275, grandfathered 26, redundant 67, beobachtete Kombinationen 310).

| Tag | Code | Gesamt-WORDs |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- Im Spezifikationsdokument ist `en` ein `ENUM #2 0x0784` mit dem an dessen Edge Id gebundenen `BIND "en"`.
- `de-x-formal` (private-use) und `nl-u-sd-bebru` (extension) haben keine Nummer und werden daher als LANGUAGE-BCP47-CODE geschrieben.

## Offene Probleme {#열린-문제}

- Interpretation zwischen Fassungen: Ob eine Nummer, die neuer ist als die Fassung des Lesers, als invalid verworfen oder bei Bewahrung des Originalwerts als „unbekannter Code“ behandelt wird. Dank append-only genügt stets die neueste Fassung, aber für Offline-Decoder ist eine Regel nötig.
- Kanonische Form: Ob ein Tag mit Nummer als SHORT-CODE geschrieben werden muss (SHOULD/MUST). Bei MUST wird die Schreibweise eindeutig, aber mit einer neuen Fassung wäre ein zuvor geschriebenes Dokument nicht mehr kanonisch.
- Wie deprecated Tags und Preferred-Value im Spezifikationsdokument dargestellt werden (die aktuelle Fassung hat das nicht).
- Verfahren zum Anhängen beobachteter Kombinationstags (Quelle, Mindesthäufigkeit der Beobachtung).

## Verwandte Seiten {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [Codec-Spezifikationsdokument](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000007A0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (17346 Zeilen ENUM·BIND ausgelassen)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
