---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value ist ein Record, der den Wert selbst enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value ist ein Record, der den Wert selbst enthält. Der Codec bestimmt die Interpretation der Payload.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      Abschnitte 3·4 (0x060L~0x09FL)
[Length-Erweiterungs-TAG]
[Codec-Erweiterungs-TAG]  bei Issuer-Format
Payload
```

- `LLLL` ist die Gesamtzahl der WORDs einschließlich des TAG WORDs − 1. 1~14 WORDs sind direkte Länge, ab 15 WORDs ist es erweiterte Länge.
- Bei einem Issuer-Format stehen im Codec-Erweiterungs-TAG der Issuer (Breite 2/4/16 WORDs, vom Codec festgelegt) und die Codec-Nummer mit 2 WORDs. Die Codec-Nummer bestimmt der Issuer.
- Ein Decoder kennt auch ohne Kenntnis des Formats Kind, Length, Issuer und Codec-Nummer.

## Familien {#계열}

Die Value-Nummer bedeutet keine Familie. Direkte Codes drücken die Familie nicht über Bits aus, und auch bei Issuer-Formaten gibt es keine Familienregel. Eine Familie ist eine thematische Gruppe.

| Familie | Direkte Codes |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- Zahlenwerte wie Vektoren, Tensoren, komplexe Zahlen, Brüche und Intervalle gehören zu NUMERIC. Eine Ausnahme ist BIT-VECTOR, der zu BINARY gehört. Sprachcodes gehören zu TEXT.
- Bei Records im Issuer-Format kommt der Codec-Erweiterungs-TAG (Issuer und Codec-Nummer) hinzu. Ist die Payload lang (insgesamt 15 WORDs oder mehr), wird ein Length-Erweiterungs-TAG verwendet.

## Direkte Codes {#직접-코드}

| Codec | Name | Familie | Beschreibung |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false oder true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | Zweierkomplement-Ganzzahl mit minimaler WORD-Anzahl |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | Ganzzahl ohne Vorzeichen mit minimaler WORD-Anzahl |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | Breite und Länge der Erde (WGS 84) und Unsicherheit (Einheit als Reference) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | Himmelskörper-Reference, Breite und Länge, Unsicherheit (Einheit als Reference) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | Numerische Größe (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch), Einheit als Reference, Untergrenze und Obergrenze |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | Bruch mit erhaltener Schreibweise (Record aus Zähler und Nenner, nicht gekürzt) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`, Koeffizient mit Vorzeichen |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`, Koeffizient ohne Vorzeichen |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | Anzahl der Tage seit 1970-01-01 (Gregorianischer Kalender) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | Nanosekunden seit Mitternacht |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | Sekunden seit der Unix-Epoche |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | Zeitspanne (Sekunden) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | Erweiterte Datumszeichenkette nach ISO 8601-2 (Jahres- und Monatsgenauigkeit, Unsicherheit, Intervall) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | GEDCOM-7-Datumszeichenkette (andere Kalender wie der Julianische) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | UTF-8-Zeichenkette ohne Sprache |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | RFC-3986-URI |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | BCP-47-Sprach-Tag |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | Text mit Sprachangabe |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | Komprimierter Sprachcode mit 1 WORD |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | RFC-9562-UUID |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | SHA-256-Ergebnis |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | SHA-1-Ergebnis (zur Identifikation, etwa für git-Objekt-IDs) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | Bytefolge mit unbekannter Bedeutung und unbekanntem Format. Gerade/ungerade Bytes |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | Nach dem Bit-Count N Bits, MSB-first gespeichert |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | Zeitspanne (Nanosekunden) |

- Als gerade/ungerade Paar angelegte Codes sind Bytefolgen variabler Länge. Der gerade Code gilt für gerade Byteanzahl, der ungerade Code für ungerade Byteanzahl ([Record und TAG WORD](../record.md)).
- Die direkten Codes liegen ohne Reserved in `0x060L~0x081L`. `0x082L~0x09CL` ist Reserved, und `0x09DL~0x09FL` sind [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md).

## Issuer-Formate {#issuer-형식}

Formate, die es unter den direkten Codes nicht gibt, liegen als Codec-Nummer unter dem Issuer der Organisation, die das Format festgelegt hat. Konventionsformate ohne festlegende Organisation liegen unter ADHOC (`0x00000002`). Formate, die GEUL eigen sind (OPAQUE-BYTES, BIT-VECTOR, DURATION-NANOSECONDS), sind direkte Codes.

| Issuer | Beispielformate |
|---|---|
| ADHOC `0x00000002` | BFLOAT16, Ganzzahl- und Gleitkomma-Vektoren, Tensoren, komplexe Zahlen, Brüche, Intervalle, Quaternionen, BLAKE3 |
| IETF `0x00000007` | Relativer URI, CRC32C, IPv4- und IPv6-Adressen |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128, POSIX-Nanosekunden-Zeitstempel, MAC-Adressen |
| KHRONOS `0x0000000E` | RGBA8- und BGRA8-Pixel |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | TAI-Zeitstempel |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | GPS-Zeitstempel |

- Ein Decoder, der das Format nicht kennt, kennt Issuer und Codec-Nummer und überspringt den Rest mithilfe von Length.
- Das Codec-Dokument liegt unter `codecs/` des jeweiligen Issuers bei der Codec-Nummer des Records. Beispiel: IETF CRC32C liegt unter `0x00000007/codecs/0x0000C000/` ([Veröffentlichungsadresse und Versionsliste](../publishing.md)).
- Große Werte wie Bilder und Videos werden besser über URI und SHA-256 referenziert, statt sie direkt einzufügen.
- Werke innerhalb von Bytefolgen folgen ihrer ursprünglichen Lizenz. Quelle und Lizenz werden als Meta festgehalten.

## Formatgruppen {#형식-묶음}

Die Beschreibung je Gruppe steht unten. Layout, Interpretation, Gültigkeit und Beispiele jedes Formats stehen im Dokument des jeweiligen Formats.

| Gruppe | Familie | Formate |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL, Ganzzahlen, Gleitkommazahlen, Koordinaten, QUANTITY, FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | Datum, Uhrzeit, Zeitstempel, Zeitspannen, EDTF, GEDCOM-Datum |
| [text](#text) | TEXT | UTF-8-Text, Text mit Sprachangabe, URI, Sprachcodes |
| [binary](#binary) | BINARY | UUID, Digests, CRC, Netzwerkadressen, Bytefolgen unbekannter Bedeutung, Bitvektoren |
| [vector](#vector) | NUMERIC | Dichte Vektoren aus Ganz- und Gleitkommazahlen, Punkte und Begrenzungsrahmen, RGBA- und BGRA-Pixel |
| [tensor](#tensor) | NUMERIC | Dense- und Packed-Tensoren mit Format, Rank und Shape |
| [etc](#etc) | NUMERIC | Komplexe Zahlen, Brüche, geschlossene Intervalle, Quaternionen |

- Die Gruppen vector, tensor und etc sind sämtlich Issuer-Formate (ADHOC, KHRONOS) der Familie NUMERIC.

### numeric {#numeric}

Die grundlegenden Zahlenformate der Familie NUMERIC. Sie liegen in den direkten Codes `0x060L~0x067L`.

- Es gibt BOOL, Ganzzahlen mit und ohne Vorzeichen, IEEE-754-binary-Gleitkommazahlen, Koordinaten der Erde (WGS 84) und von Himmelskörpern, QUANTITY, das Größe, Einheit und Grenzen bündelt, sowie FRACTION, einen Bruch in seiner Originalschreibweise.
- Ganzzahlen werden mit der minimalen WORD-Anzahl geschrieben, in die der Wert passt.
- Für kleine skalare Issuer-Formate (BFLOAT16, FP8, FP4) sind nur Codec-Nummern vergeben, eine detaillierte Spezifikation fehlt ([Value](#열린-문제), offene Probleme).
- Vektoren, Tensoren, komplexe Zahlen, gekürzte Brüche (RATIONAL-I64) und Intervalle gehören ebenfalls zur Familie NUMERIC, sind aber Issuer-Formate und liegen daher in den Gruppen [vector](#vector), [tensor](#tensor) und [etc](#etc).

### decimal {#decimal}

Die Familie DECIMAL umfasst exakte Dezimalformate. Sie liegt in den direkten Codes `0x068L~0x069L`.

- Die direkten Codes SIGNED-DECIMAL und UNSIGNED-DECIMAL werden als `C × 10^E` geschrieben und enthalten die Stellenzahl der ursprünglichen Schreibweise unverändert. `1.20` (`C=120, E=−2`) und `1.2` (`C=12, E=−1`) sind verschiedene Records. Wertgleichheit und Erhalt des Quantums sind ein offenes Problem von [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제).
- Die DPD- und BID-Kodierungen von IEEE 754 decimal32/64/128 sind Formate des IEEE-Issuers (`0x0000000D`).

### time {#time}

Die Familie TIME umfasst Datums- und Uhrzeitformate. Sie liegt in den direkten Codes `0x06AL~0x071L` und `0x081L` (DURATION-NANOSECONDS).

| Genauigkeit | Format |
|---|---|
| Datum (Gregorianischer Kalender) | GREGORIAN-DATE |
| Jahr und Monat, Unsicherheit, Intervall | EDTF |
| Originalschreibweise eines anderen Kalenders (Julianisch usw.) | GEDCOM-DATE |
| Uhrzeit | POSIX-, TAI- und GPS-Zeitstempel |
| Zeitspanne | DURATION-SECONDS, DURATION-NANOSECONDS |

- Ein Datum, das als GREGORIAN-DATE geschrieben werden kann, wird nicht als EDTF geschrieben.
- Nanosekunden-Zeitstempel sowie die Formate TAI und GPS sind Formate unter den Issuern der jeweiligen Normungsorganisationen (IEEE, BIPM, GPS).

### text {#text}

Die Familie TEXT umfasst Text und Zeichenketten-Bezeichner. Sie liegt in den direkten Codes `0x072L~0x07AL`.

- Eine Zeichenkette ohne Sprache ist UTF8-TEXT, ein Text mit Sprache wie Name, Titel und Satz ist UTF8-LANGUAGE-TEXT.
- Auch die Sprachcodes (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) gehören zur Familie TEXT.
- Bytefolgen variabler Länge werden als gerade/ungerade Codec-Paar angelegt. Ist das niedrigstwertige Bit `1`, ist die Byteanzahl ungerade, und das untere Byte des letzten WORDs ist ein `0x00`-Padding ([Record und TAG WORD](../record.md)).

### binary {#binary}

Die Familie BINARY umfasst Bytefolgen-Formate. Sie liegt in den direkten Codes `0x07BL~0x080L`.

- UUID, SHA-256, SHA-1, Bytefolgen unbekannter Bedeutung (OPAQUE-BYTES) und Bitvektoren (BIT-VECTOR) sind direkte Codes. Die übrigen Digests, CRC32C sowie IPv4-, IPv6- und MAC-Adressen sind Issuer-Formate.
- Werte fester Größe (UUID, Digests, Adressen) haben eine feste Größe und daher kein gerade/ungerade Paar.
- Öffentliche Medien wie Bilder und Videos liegen als Formate des IANA-Issuers (`0x00000008`). Die Codec-Nummern werden als gerade/ungerade Paar vergeben, und die Payload ist eine Bytefolge. Die Obergrenze von Length ist 2^32−1 WORDs. Große Werte werden besser über URI und SHA-256 referenziert, statt sie direkt einzufügen.
- Werke innerhalb von Bytefolgen folgen ihrer ursprünglichen Lizenz. Quelle und Lizenz werden als Meta festgehalten.

### vector {#vector}

Vektorformate sind Issuer-Formate der Familie NUMERIC. Dichte Vektoren aus Ganz- und Gleitkommazahlen sowie Punkte und Begrenzungsrahmen liegen bei ADHOC (`0x00000002`) unter den Codec-Nummern `0x00000500`~`0x0000050C`, Pixelformate unter KHRONOS (`0x0000000E`).

- Die Elemente eines dichten Vektors werden Big-Endian fortlaufend gespeichert.
- Da es Issuer-Formate sind, folgen auf den Codec-Erweiterungs-TAG der Issuer mit 2 WORDs und die Codec-Nummer mit 2 WORDs.

### tensor {#tensor}

Tensorformate sind Issuer-Formate der Familie NUMERIC. Sie liegen bei ADHOC (`0x00000002`) unter den Codec-Nummern `0x00000600`~`0x00000601`.

- DESCRIBED-DENSE-TENSOR enthält Elementformat, Rank, Shape und eine C-contiguous Dense-Payload.
- DESCRIBED-PACKED-TENSOR enthält Packed-Format, Rank, Shape und eine Packed-Payload mit Low-Bit-First innerhalb eines Oktetts.

### etc {#etc}

Sonstige Zahlenformate sind Issuer-Formate der Familie NUMERIC. Sie liegen bei ADHOC (`0x00000002`) unter den Codec-Nummern `0x00000700`~`0x00000704`.

- Es gibt komplexe Zahlen (COMPLEX64, COMPLEX128), normalisierte Brüche (RATIONAL-I64), geschlossene binary64-Intervalle und binary32-Quaternionen.

## Text {#텍스트}

Text mit und ohne Sprache sind verschiedene Werte. „Paris“ (Zeichenkette) und „Paris“ (Französisch) sind nicht dasselbe.

| Format | Verwendung |
|---|---|
| UTF8-TEXT | Zeichenketten ohne Sprache wie Bezeichner, Codes, Dateinamen und externe IDs |
| UTF8-LANGUAGE-TEXT | Text mit Sprache wie Namen, Titel und Sätze |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = Text hat ungerade Bytes)
[Length-Erweiterungs-TAG]
Sprache           Record LANGUAGE-SHORT-CODE oder LANGUAGE-BCP47-CODE
Text              UTF-8-Bytes (bei ungerader Anzahl letztes 0x00)
```

- Der Text ist wohlgeformtes UTF-8 und wird unverändert bewahrt. Die Normalisierung übernimmt, wer vergleicht oder indiziert.
- Für einen Namen, der mehreren Sprachen gemeinsam ist, wird die Sprache `mul` verwendet, für eine unbestimmte Sprache `und`. Eine Zeichenkette ohne sprachlichen Inhalt ist UTF8-TEXT.

Beispiel: `"Douglas Adams"@en` (13 Bytes, ungerade)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   Sprache en D o  u g  l a  s ␠  A d  a m  s (Padding)
```

## Dezimalzahlen und Größen {#10진수와-수량}

Exakte Dezimalzahlen werden als `C × 10^E` geschrieben. Der Exponent `E` hat 32 Bit, der Koeffizient `C` ist ein Zweierkomplement mit minimaler WORD-Anzahl. Die Stellenzahl der ursprünglichen Schreibweise bleibt unverändert erhalten: `1.20` ist `C=120, E=−2`, `1.2` ist `C=12, E=−1`. Beide Schreibweisen bezeichnen dieselbe Zahl, sind aber verschiedene Records mit unterschiedlichen Bytes. Ein Encoder normalisiert die Schreibweise nicht eigenmächtig. Die Wertgleichheit zweier Records und die Bedeutung des Quantums (der signifikanten Stellen) sind ein offenes Problem ([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

QUANTITY enthält Größe, Einheit und Grenzen als einen Wert.

```
TAG WORD          0000 0110 0110 LLLL
[Length-Erweiterungs-TAG]
Größe             Zahlen-Value-Record (Ganzzahl, BINARY-FLOAT, Dezimalzahl, Bruch)
Einheit           Reference-Record (Einheitseintrag), ohne Einheit 0x0000
Untergrenze       Zahlen-Value-Record, bei Auslassung 0x0000 ABSENT
Obergrenze        Zahlen-Value-Record, bei Auslassung 0x0000 ABSENT
```

- Die Einheit ist Teil des Werts. Sie wird nicht abgetrennt und andernorts notiert (ohne sie ließe sich bei `652` nicht sagen, ob es km oder m sind).
- Ein in SI-Einheiten umgerechneter Wert wird nicht abgelegt. Er lässt sich aus Einheit und Umrechnungstabelle berechnen.
- `0x0000` ist die Markierung ABSENT, dass ein optionales Feld ausgelassen wurde ([Codec-Spezifikationsdokument](../codec-spec.md)).

Beispiel: `652 km`, Bereich `[651, 653]` (km = Wikidata Q828224)

```
066E 0011                    TAG (erweiterte Länge, 17 WORDs)
0683 0000 0000 028C          Größe 652
0142 000C A340               Einheit Q828224
0683 0000 0000 028B          Untergrenze 651
0683 0000 0000 028D          Obergrenze 653
```

## Datum {#날짜}

| Genauigkeit | Format |
|---|---|
| Datum (Gregorianischer Kalender) | GREGORIAN-DATE |
| Jahr und Monat, Unsicherheit (`1971~`), Intervall | EDTF |
| Originalschreibweise eines anderen Kalenders (Julianisch usw.) | GEDCOM-DATE |
| Uhrzeit | POSIX-, TAI- und GPS-Zeitstempel |

- Ein Datum, das als GREGORIAN-DATE geschrieben werden kann, wird nicht als EDTF geschrieben.

## Offene Probleme {#열린-문제}

- Öffentliche Medienformate (JPEG, PNG, MP4, MOV usw.) liegen als Codec-Nummern des IANA-Issuers (`0x00000008`). Wie die Zuordnungstabelle zwischen Medientypen und Codec-Nummern verwaltet wird.
- Die endgültige Liste der direkten Value-Codes. Sie wird festgelegt, indem die Value-Häufigkeit in Stichproben aus Gesetzen und Geschäftsgesprächen gemessen wird (Kandidaten: Geldbeträge, Prozentsätze, Datumsintervalle).
- Detaillierte Spezifikation und Anordnung der 7 kleinen Skalare (ADHOC BFLOAT16, ONNX FP8 4 Arten, OCP FP8-E8M0FNU·FP4-E2M1FN). Ob sie zu direkten Codes werden, ist nicht entschieden. Derzeit sind nur Codec-Nummern vergeben.
