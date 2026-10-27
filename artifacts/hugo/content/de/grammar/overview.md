---
title: "Überblick"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1 ist eine Folge von Records aus 16-Bit-Wörtern. Es gibt vier Arten von Records: Reference, Value, Edge und Meta. Die Records sind in einem Dokument zusammengefasst."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL (General Encoding Unified Language) ist eine künstliche Sprache und ein Binärformat, mit dem Menschen und KI einander eindeutig verstehen. Dieses Dokument definiert die Grammatik von GEUL v1.

## Auf einen Blick

- Alle Daten sind eine Folge von **16-Bit-Wörtern (WORD)**. Sie werden Big-Endian geschrieben.
- Die Einheit der Daten ist der **Record**. Ein Record beginnt mit einem TAG WORD, das Art und Länge des Records angibt.
- Es gibt vier Arten von Records (**Kind**).

| Kind | Aufgabe | Beispiel |
|---|---|---|
| Reference | Verweist auf ein Objekt | Wikidata Q42, #7 in diesem Dokument |
| Value | Enthält den Wert selbst | Datum, Menge, Text mit Sprache |
| Edge | Verbindet andere Records zu einer Aussage | „Q42 ist ein Mensch“, „Der englische Name von Q42 ist Douglas Adams“ |
| Meta | Sagt etwas über das Dokument aus | Spezifikationsausgabe, Dokument-ID, Autor, Signatur |

- Die Records sind in einem **Dokument** zusammengefasst. Ein Dokument gliedert sich wie HTML in HEAD (Meta sowie das SOURCE für die Quelle des gesamten Dokuments und dessen QUALIFIER) und BODY (Reference, Value, Edge).
- Ein Dokument wird von einem **Issuer** (Herausgeber) herausgegeben, und jede Version wird durch einen Inhaltshash festgelegt. Eine veröffentlichte Version wird nicht geändert.

## Entwurfsprinzipien

1. **Überspringen ohne Codebook.** Art und Länge eines Records stehen in den 16 Bit des TAG WORD. Auch ein Decoder, der die Interpretationsvorschrift (das Codebook) nicht kennt, kann Records zählen und überspringen.
2. **Nicht Tatsachen, sondern Aussagen werden festgehalten.** Ein Dokument gibt mit Meta und Beleg-Edges zugleich an, von wem, wann und woraus eine Aussage stammt.
3. **Identifiziert wird per Reference.** Man verweist nicht über Namen, sondern über IDs. Namen werden per Edge angehängt.
4. **Veröffentlichtes wird nicht geändert.** Korrekturen erscheinen als neue Version. Eine ID innerhalb eines Dokuments verweist über Versionen hinweg auf dasselbe Objekt.
5. **Platz freihalten.** Der größte Teil des Bitraums bleibt der Zukunft vorbehalten. Direkte Codes lassen sich nicht zurücknehmen, deshalb werden sie nur für nachweislich häufige Formate vergeben.

## Bereichsstruktur

Die oberen Bits des TAG WORD teilen die Bereiche ein.

| Prefix | Bereich | Anteil | Definition |
|---|---|---|---|
| `1` | Ferne Zukunft | 50 % | Für die ferne Zukunft reserviert. Nicht verwenden |
| `01` | Zukunft | 25 % | Für die nahe Zukunft reserviert. Nicht verwenden |
| `001` | Standard | 12,5 % | Offiziell übernommene und betriebene Grammatik |
| `000` | Frei/Vorschlag | 12,5 % | Aktuelle Grammatik. Wird sie übernommen, bleibt das Layout unverändert und nur der Prefix wechselt auf `001` |

Die aktuelle Grammatik liegt vollständig im Bereich `000`. Jedes TAG WORD dieser Spezifikation beginnt mit `000`.

- Ein v1-Decoder lehnt TAG WORDs ab, deren Prefix nicht `000` ist. Die anderen Bereiche legt eine spätere Ausgabe fest.
- Der Bereich `000` ist ein Vorschlagsraum. Derzeit gelten weder Registrierung noch Schutz. Die Layouts der Issuer-Formate sind jedoch im Hinblick auf ein Registrierungssystem nach dem Start der offiziellen Standardisierung reserviert.

## Was man ohne Codebook weiß

| Information | Ohne Codebook | Grundlage |
|---|---|---|
| Kind | bekannt | TAG WORD |
| Gesamtlänge des Records, Position des nächsten Records | bekannt | Length des TAG WORD |
| Codec-Nummer | bekannt | TAG WORD (bei Issuer-Formaten Issuer und Formatnummer im Erweiterungs-TAG) |
| Familie/Klasse | bekannt | Obere Bits der Codec- oder Formatnummer |
| Edge Id eines Edge | bekannt | Die erste Komponente eines Edge ist immer ein LOCAL Reference |
| Slot-Marker (nicht angegeben, unbekannt, kein Wert) | bekannt | WORD-Wert `0`~`7` (Reference-Codec `0000`, 1 WORD). [Slot-Marker](/de/grammar/reference/slot-marker/) |
| TAG-Länge je Codec, Beginn des Payloads | unbekannt | Codebook |
| Interpretation des Payloads, Rolle der Edge-Komponenten | unbekannt | Codebook |

- Ein Decoder ohne Codebook kann beim Überspringen von Records nach Kind und Codec zählen, aber der Graphstruktur nicht folgen.
- Jeder Decoder muss die Meta-Klassen Struktur, Definition und IMPORT verarbeiten. Diese Codecs gehören zum GEUL-Kern-Codebook ([Meta](/de/grammar/meta/)).

Das Codebook wird als GEUL-Dokument veröffentlicht ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)). Ein Decoder muss deshalb nur die benötigten Spezifikationsdokumente laden und lesen.

## Untergeordnete Dokumente

| Dokument | Inhalt |
|---|---|
| [Record und TAG WORD](/de/grammar/record/) | TAG-WORD-Layout, Length, Codec, Erweiterungs-TAG |
| [Dokument](/de/grammar/document/) | DOC, HEAD, BODY, END, Dokument-ID, Inhaltshash, Version und Revision |
| [Reference](/de/grammar/reference/) | Objektidentifikation, LOCAL, externe Verweise, Quantifier, Slot-Marker |
| [Value](/de/grammar/value/) | Wertfamilien, direkte Codes, Text, Menge, Datum |
| [Edge](/de/grammar/edge/) | Familien Beschreibung, Beleg, Ausführung, TOULMIN; TRIPLE, QUALIFIER, LABEL |
| [Meta](/de/grammar/meta/) | Struktur, Definition, Herkunft, Abstammung, Verifikation, Richtlinie, IMPORT |
| [Issuer und Veröffentlichung](/de/grammar/issuer/) | Issuer-Stufen, 1-WORD-Zuweisungstabelle, Offenlegung, Signatur, Prüfschlüssel |
| [Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/) | ID-Notation, Veröffentlichungsadresse, Formatangabe, Namensindex, Versionsliste, Vertrauensebenen |
| [Codec-Spezifikationsdokument](/de/grammar/codec-spec/) | Das Codebook, geschrieben mit DECLARE, FIELD, ENUM und CODEC |
| [Beispiel: Wikidata-Eintrag](/de/grammar/example/) | Ein Dokument Wort für Wort lesen |

## Offene Fragen

- Das Kind bei Grenzfällen. Etwa bei Aussagen über Aussagen: ob sie als Reference, Value, Edge oder Meta gehören.
