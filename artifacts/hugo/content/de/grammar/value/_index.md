---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Ein Value ist ein Record, der den Wert selbst enthält. Die oberen 2 Bit des Codec bilden die Familie (Zahlen/Dezimalzahlen, Zeit, Text, Binär). Häufig verwendete Formate sind direkte Codes, die übrigen liegen als Issuer-Formate je Normungsorganisation vor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Ein Value ist ein Record, der den Wert selbst enthält. Der Codec legt die Interpretation des Payloads fest.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC
[Length-Erweiterungs-TAG]
[Codec-Erweiterungs-TAG]  bei Issuer-Formaten
Payload
```

- `LLLL` ist die Gesamtzahl der WORD einschließlich TAG WORD minus 1. 1~14 WORD sind direkte Länge, ab 15 WORD erweiterte Länge.
- Bei Issuer-Formaten stehen im Codec-Erweiterungs-TAG der Issuer (Breite 1/2/4/16 WORD, vom Codec festgelegt) und die Formatnummer (1 WORD). Die oberen 2 Bit der Formatnummer bilden die Familie.
- Auch ein Decoder, der das Format nicht kennt, kennt Familie und Length.

## Familien

Die oberen 2 Bit des Codec bilden die Familie. Direkte Codes (7 Bit) und Issuer-Formatnummern (16 Bit) folgen derselben Regel. Deshalb kennt man die Familie auch ohne Codebook.

| Obere 2 Bit | Familie | Direkter Code | Formatnummer |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL werden über das dritte Bit weiter unterteilt. `000` ist NUMERIC, `001` DECIMAL.
- Numerische Werte wie Vektoren, Tensoren, komplexe Zahlen, Brüche und Intervalle sind NUMERIC. Ausnahme ist BIT-VECTOR, der BINARY ist. Sprachcodes sind TEXT.
- Issuer-Format-Records erhalten einen Codec-Erweiterungs-TAG (Issuer und Formatnummer). Ist der Payload lang (insgesamt ab 15 WORD), wird ein Length-Erweiterungs-TAG verwendet.

## Direkte Codes

| Codec | Name | Familie | Beschreibung |
|---|---|---|---|
| `0x00` | [BOOL](/de/grammar/value/numeric/bool/) | NUMERIC | false oder true |
| `0x01` | [SIGNED-INTEGER](/de/grammar/value/numeric/signed-integer/) | NUMERIC | Ganzzahl im Zweierkomplement mit minimaler WORD-Zahl |
| `0x02` | [UNSIGNED-INTEGER](/de/grammar/value/numeric/unsigned-integer/) | NUMERIC | Vorzeichenlose Ganzzahl mit minimaler WORD-Zahl |
| `0x03` | [BINARY-FLOAT](/de/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/de/grammar/value/numeric/coordinate-earth/) | NUMERIC | Breite und Länge der Erde (WGS 84) und Unsicherheit (Einheit als Reference) |
| `0x05` | [COORDINATE-GEO](/de/grammar/value/numeric/coordinate-geo/) | NUMERIC | Himmelskörper-Reference, Breite und Länge, Unsicherheit (Einheit als Reference) |
| `0x06` | [QUANTITY](/de/grammar/value/numeric/quantity/) | NUMERIC | Numerische Menge (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch), Einheit als Reference, untere/obere Schranke |
| `0x07` | [FRACTION](/de/grammar/value/numeric/fraction/) | NUMERIC | Bruch, der seine Schreibweise wahrt (Zähler- und Nenner-Record, nicht gekürzt) |
| `0x10` | [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`, vorzeichenbehafteter Koeffizient |
| `0x11` | [UNSIGNED-DECIMAL](/de/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`, vorzeichenloser Koeffizient |
| `0x20` | [GREGORIAN-DATE](/de/grammar/value/time/gregorian-date/) | TIME | Tageszahl seit 1970-01-01 (gregorianischer Kalender) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/de/grammar/value/time/civil-time-nanoseconds/) | TIME | Nanosekunden seit Mitternacht |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/de/grammar/value/time/posix-timestamp-seconds/) | TIME | Sekunden seit der Unix-Epoche |
| `0x23` | [DURATION-SECONDS](/de/grammar/value/time/duration-seconds/) | TIME | Verstrichene Zeit (Sekunden) |
| `0x24`/`0x25` | [EDTF](/de/grammar/value/time/edtf/) | TIME | Erweiterte Datumszeichenkette nach ISO 8601-2 (Jahres-/Monatsgenauigkeit, Unsicherheit, Intervalle) |
| `0x26`/`0x27` | [GEDCOM-DATE](/de/grammar/value/time/gedcom-date/) | TIME | GEDCOM-7-Datumszeichenkette (andere Kalender wie der Julianische) |
| `0x40`/`0x41` | [UTF8-TEXT](/de/grammar/value/text/utf8-text/) | TEXT | UTF-8-Zeichenkette ohne Sprache |
| `0x44`/`0x45` | [URI](/de/grammar/value/text/uri/) | TEXT | URI nach RFC 3986 |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/de/grammar/value/text/language-bcp47-code/) | TEXT | BCP-47-Sprach-Tag |
| `0x48` | [LANGUAGE-SHORT-CODE](/de/grammar/value/text/language-short-code/) | TEXT | Komprimierter Sprachcode mit 1 WORD |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/) | TEXT | Text mit Sprache |
| `0x60` | [UUID](/de/grammar/value/binary/uuid/) | BINARY | UUID nach RFC 9562 |
| `0x61` | [SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/) | BINARY | SHA-256-Ergebnis |
| `0x62` | [SHA1-DIGEST](/de/grammar/value/binary/sha1-digest/) | BINARY | SHA-1-Ergebnis (für Identifikationszwecke wie git-Objekt-IDs) |

- Paarweise nach gerade/ungerade angeordnete Codes sind Bytefolgen variabler Länge. Ein gerader Code bedeutet gerade, ein ungerader ungerade Bytezahl ([Record und TAG WORD](/de/grammar/record/)).
- Direkte Codes, die nicht in der Tabelle stehen, sind reserviert.

## Issuer-Formate

Formate, die es als direkte Codes nicht gibt, liegen unter dem Issuer der Organisation, die das Format festgelegt hat, als Formatnummer vor. Konventionsformate ohne normsetzende Organisation stehen unter ADHOC (`0x0001`), GEUL-eigene Formate unter GEUL (`0x0000`).

| Issuer | Beispiele für Formate |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, Vektoren aus Ganz- und Gleitkommazahlen, Tensoren, komplexe Zahlen, Brüche, Intervalle, Quaternionen, BLAKE3 |
| IETF `0x0020` | Relative URI, CRC32C, IPv4- und IPv6-Adressen |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, POSIX-Nanosekunden-Zeitstempel, MAC-Adresse |
| KHRONOS `0x0041` | RGBA8- und BGRA8-Pixel |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | TAI-Zeitstempel |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | GPS-Zeitstempel |

- Ein Decoder, der das Format nicht kennt, kennt nur die Familie der Formatnummer und überspringt den Payload.
- Große Werte wie Bilder und Videos referenziert man besser über URI und SHA-256, statt sie direkt einzufügen.
- Werke in einer Bytefolge folgen ihrer ursprünglichen Lizenz. Quelle und Lizenz werden als Meta festgehalten.

## Formatgruppen

Layout, Interpretation, Gültigkeit und Beispiele jedes Formats stehen in den Dokumenten der Gruppen.

| Gruppe | Familie | Formate |
|---|---|---|
| [numeric](/de/grammar/value/numeric/) | NUMERIC | BOOL, Ganzzahlen, Gleitkomma, Koordinaten, QUANTITY, FRACTION |
| [decimal](/de/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/de/grammar/value/time/) | TIME | Datum, Uhrzeit, Zeitstempel, Dauer, EDTF, GEDCOM-Datum |
| [text](/de/grammar/value/text/) | TEXT | UTF-8-Text, Text mit Sprache, URI, Sprachcodes |
| [binary](/de/grammar/value/binary/) | BINARY | UUID, Digests, CRC, Netzwerkadressen, Bytefolge unbekannter Art, Bitvektor |
| [vector](/de/grammar/value/vector/) | NUMERIC | Dichte Vektoren aus Ganz- und Gleitkommazahlen, Punkte und Bounding Boxes, RGBA- und BGRA-Pixel |
| [tensor](/de/grammar/value/tensor/) | NUMERIC | Dichte und gepackte Tensoren mit Format, rank und shape |
| [etc](/de/grammar/value/etc/) | NUMERIC | Komplexe Zahlen, Brüche, abgeschlossene Intervalle, Quaternionen |

- Die Gruppen vector, tensor und etc sind sämtlich Issuer-Formate (ADHOC, KHRONOS) der NUMERIC-Familie.

## Text

Text mit Sprache und Text ohne Sprache sind verschiedene Werte. „Paris“ (Zeichenkette) und „Paris“ (Französisch) sind nicht gleich.

| Format | Verwendung |
|---|---|
| UTF8-TEXT | Zeichenketten ohne Sprache wie Kennungen, Codes, Dateinamen und externe IDs |
| UTF8-LANGUAGE-TEXT | Text mit Sprache wie Namen, Titel und Sätze |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = Text hat ungerade Bytezahl)
[Length-Erweiterungs-TAG]
Sprache           LANGUAGE-SHORT-CODE- oder LANGUAGE-BCP47-CODE-Record
Text              UTF-8-Bytes (bei ungerader Zahl zuletzt 0x00)
```

- Der Text ist wohlgeformtes UTF-8 und wird unverändert bewahrt. Normalisierung übernimmt, wer vergleicht oder indiziert.
- Namen, die mehreren Sprachen gemeinsam sind, schreibt man mit der Sprache `mul`, nicht festgelegte Sprache mit `und`. Eine Zeichenkette ohne Sprachinhalt ist UTF8-TEXT.

Beispiel: `"Douglas Adams"@en` (13 Bytes, ungerade)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   Sprache en D o  u g  l a  s ␠  A d  a m  s (Padding)
```

## Dezimalzahlen und Mengen

Exakte Dezimalzahlen schreibt man als `C × 10^E`. Der Exponent `E` hat 32 Bit, der Koeffizient `C` ist ein Zweierkomplement mit minimaler WORD-Zahl. Die Stellenzahl der ursprünglichen Schreibweise bleibt erhalten: `1.20` ist `C=120, E=−2`, `1.2` ist `C=12, E=−1`. Beide Schreibweisen stellen dieselbe Zahl dar, sind aber getrennte Records mit verschiedenen Bytes. Ein Encoder normalisiert die Schreibweise nicht eigenmächtig. Die Wertgleichheit beider Records und die Bedeutung des Quantums (signifikante Stellen) sind eine offene Frage ([SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/#offene-fragen)).

QUANTITY enthält Menge, Einheit und Schranken in einem einzigen Wert.

```
TAG WORD          0000 1LLL L000 0110
[Length-Erweiterungs-TAG]
Menge             numerischer Value-Record (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch)
Einheit           Reference-Record (Einheiten-Eintrag), bei Einheitenlosigkeit 0x0000
Untere Schranke   numerischer Value-Record, falls ausgelassen 0x0000 ABSENT
Obere Schranke    numerischer Value-Record, falls ausgelassen 0x0000 ABSENT
```

- Die Einheit ist Teil des Wertes. Man schreibt sie nicht losgelöst an anderer Stelle (ohne sie weiß man bei `652` nicht, ob es km oder m sind).
- Ein in SI-Einheiten umgerechneter Wert wird nicht abgelegt. Er lässt sich aus Einheit und Umrechnungstabelle berechnen.
- `0x0000` (ABSENT) ist der Marker dafür, dass ein optionales Feld ausgelassen wurde ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)).

Beispiel: `652 km`, Bereich `[651, 653]` (km = Wikidata Q828224)

```
0F06 0011                    TAG (erweiterte Länge 17 WORD)
0990 0000 0000 028C          Menge 652
0120 000C A340               Einheit Q828224
0990 0000 0000 028B          untere Schranke 651
0990 0000 0000 028D          obere Schranke 653
```

## Datum

| Genauigkeit | Format |
|---|---|
| Datum (gregorianischer Kalender) | GREGORIAN-DATE |
| Jahr/Monat, unsicher (`1971~`), Intervall | EDTF |
| Originalschreibweise eines anderen Kalenders (Julianisch usw.) | GEDCOM-DATE |
| Uhrzeit | POSIX-, TAI- und GPS-Zeitstempel |

- Ein Datum, das sich als GREGORIAN-DATE schreiben lässt, wird nicht als EDTF geschrieben.

## Offene Fragen

- Öffentliche Medienformate (JPEG, PNG, MP4, MOV usw.) liegen als BINARY-Formatnummern des IANA-Issuers (`0x0021`) vor. Wie die Zuordnungstabelle von Medientyp und Formatnummer verwaltet wird.
- Die endgültige Liste der direkten Codes für Value. Sie wird anhand der Häufigkeit von Value in Stichproben aus Gesetzen und Geschäftsdialogen festgelegt (Kandidaten: Geldbeträge, Prozentwerte, Datumsintervalle).
- Detaillierte Spezifikation und Platzierung der 7 kleinen Skalare (ADHOC BFLOAT16, 4 ONNX-FP8, OCP FP8-E8M0FNU und FP4-E2M1FN). Es ist nicht entschieden, ob sie in den für NUMERIC reservierten Bereich direkter Codes (`0x08`~`0x0F`) verlegt werden. Derzeit sind nur Formatnummern vergeben.
