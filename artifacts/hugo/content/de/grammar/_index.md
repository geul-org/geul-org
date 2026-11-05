---
title: "GEUL-Grammatik"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Die Grammatikspezifikation von GEUL v1. Sie definiert Records auf 16-Bit-Wörtern, die vier Kinds, die Dokumentstruktur sowie Issuer und Veröffentlichungsregeln."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL (General Encoding Unified Language) ist eine künstliche Sprache und ein Binärformat, mit denen Menschen und KI eindeutig Informationen austauschen.

Diese Dokumente definieren die Grammatik von GEUL v1. Die aktuelle Fassung ist ein Entwurf vor der Veröffentlichung und kann sich ändern. Die Spezifikation wird unter [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) veröffentlicht.

## Auf einen Blick {#한눈에-보기}

- Alle Daten sind eine Folge von **16-Bit-Wörtern (WORD)**. Sie werden in Big-Endian geschrieben.
- Die Einheit der Daten ist der **Record**. Ein Record beginnt mit genau einem TAG WORD, und dieses TAG WORD gibt Art und Länge des Records an.
- Es gibt vier Arten von Records (**Kind**).

| Kind | Aufgabe | Beispiel |
|---|---|---|
| Reference | verweist auf einen Gegenstand | Wikidata Q42, #7 in diesem Dokument |
| Value | enthält den Wert selbst | Datum, Menge, Text mit Sprachangabe |
| Edge | verbindet andere Records zu einer Aussage | „Q42 ist ein Mensch“, „Der englische Name von Q42 ist Douglas Adams“ |
| Meta | sagt etwas über das Dokument | Spezifikationsfassung, Dokument-ID, Autor, Signatur |

- Die Records stehen in einem **Dokument**. Ein Dokument gliedert sich wie HTML in HEAD (Meta sowie die Herkunft SOURCE des gesamten Dokuments und deren QUALIFIER) und BODY (Reference, Value, Edge).
- Ein Dokument wird von einem **Issuer** (Herausgeber) herausgegeben und für jede Version durch einen Inhaltshash festgelegt. Eine veröffentlichte Version wird nicht geändert.

## Entwurfsprinzipien {#설계-원칙}

1. **Überspringen ohne Codebook.** Art und Länge eines Records stehen in den 16 Bit des TAG WORD. Auch ein Decoder, der die Deutungsvorschrift (das Codebook) nicht kennt, kann Records zählen und überspringen.
2. **Nicht Tatsachen, sondern Aussagen werden gespeichert.** Ein Dokument hält mit Meta und Beleg-Edges fest, von wem, wann und woraus eine Aussage stammt.
3. **Identifiziert wird mit Reference.** Man verweist mit einer ID, nicht mit einem Namen. Der Name wird per Edge angehängt.
4. **Veröffentlichtes wird nicht geändert.** Korrekturen erscheinen als neue Version. Eine ID innerhalb eines Dokuments bezeichnet über Versionen hinweg denselben Gegenstand.
5. **Platz lassen.** Der größte Teil des Bitraums bleibt der Zukunft vorbehalten. Direkte Codes lassen sich nicht zurücknehmen, deshalb werden nur Fälle zugewiesen, deren Häufigkeit bestätigt ist.

## Untergeordnete Dokumente {#하위-문서}

Wer zum ersten Mal liest, folgt der Tabelle von oben nach unten.

| Dokument | Inhalt |
|---|---|
| [Aufbau des Records](record.md) | TAG-WORD-Layout, Length, Codec, Erweiterungs-TAG |
| [Issuer und Veröffentlichung](issuer.md) | Issuer-Stufen, 2-WORD-Zuweisungstabelle, Offenlegung, Signatur, Prüfschlüssel |
| [Veröffentlichungsadresse und Versionsliste](publishing.md) | ID-Notation, Veröffentlichungsadresse, Formatangabe, Issuer-Liste, Versionsliste, Vertrauensebenen |
| [Codec-Spezifikationsdokument](codec-spec.md) | Codebooks, geschrieben mit DECLARE, FIELD, ENUM und CODEC |
| [Allgemeines Dokument](document.md) | DOC, HEAD, BODY, END, Dokument-ID, Inhaltshash, Version und Revision |
| [Code-Index](codec-index.md) | alle 227 zugewiesenen Plätze, Codec-Tabellen nach Kind und Familie |
| [Abschnittslayout](layout.md) | 16 Abschnitte und Platzbelegung, zugewiesene und Reserved-Bereiche |
| [Slot-Marker](slot-marker.md) | ABSENT, UNKNOWN-VALUE, NO-VALUE, Akzeptanzregeln |
| [Reference](reference/_index.md) | Identifikation von Gegenständen, LOCAL, externe Verweise, Quantifier, Slot-Marker |
| [Value](value/_index.md) | Wertfamilien, direkte Codes, Text, Menge, Datum |
| [Meta](meta/_index.md) | Struktur, Definition, Herkunft, Abstammung, Verifikation, Richtlinie, IMPORT |
| [Edge](edge/_index.md) | Familien Aussage, Beleg, Ausführung und TOULMIN; TRIPLE, QUALIFIER, LABEL |
| [TOULMIN](toulmin/_index.md) | Familie aus Beurteilungs- und Ausführungsgraph, Layouts von NODE, LINK und SOURCE |
| [Beispiel: Wikidata-Eintrag](example.md) | ein Dokument Wort für Wort lesen |

## Was man ohne Codebook wissen kann {#코덱북-없이-알-수-있는-것}

| Information | Ohne Codebook | Grundlage |
|---|---|---|
| Kind | bekannt | Abschnitt des TAG WORD, Bereich `w >> 9` (Reference 0–2, Value 3 und 4, Edge 5–13, Meta 14 und 15) |
| Gesamtlänge des Records, Position des nächsten Records | bekannt | Length des TAG WORD |
| Codec-Nummer | bekannt | TAG WORD (beim Issuer-Format Issuer und Codec-Nummer des Erweiterungs-TAG) |
| Familie, Klasse | teilweise bekannt | Nur die Familie der direkten Edge-Codes ist an den Bits erkennbar. Direkte Value-Codes, die Familie im Issuer-Format und die Meta-Klasse sind an den Bits nicht erkennbar. Beim Issuer-Format sind Issuer und Codec-Nummer bekannt. Die Meta-Verifikationsklasse erkennt man an `C >= 5` (`w >= 0x1E50`) in Abschnitt 15 |
| Edge Id einer Edge | bekannt | Die erste Komponente einer Edge (Abschnitte 5–13) ist immer eine LOCAL Reference |
| Slot-Marker (nicht angegeben, unbekannt, nicht vorhanden) | bekannt | WORD-Wert `0x0000`, `0x0010`, `0x0020` (Reference, C < 3, L 0). [Slot-Marker](slot-marker.md) |
| Quantifier | bekannt | über den Offset `C` im Abschnitt: in Abschnitt 0 bei `5 <= C < 30`, in Abschnitt 1 bei `C < 30` ist es `C % 5` |
| TAG-Länge je Codec, Beginn des Payload | unbekannt | Codebook |
| Deutung des Payload, Rolle der Edge-Komponenten | unbekannt | Codebook |

- Ein Decoder ohne Codebook kann Records überspringen und nach Kind und Codec zählen, aber der Graphstruktur nicht folgen.
- Jeder Decoder muss die Meta-Klassen Struktur, Definition und IMPORT verarbeiten. Diese Codecs gehören zum GEUL-Kern-Codebook, und der Decoder kennt sie über eine eingebaute Nummerntabelle ([Meta](meta/_index.md)).

Codebooks werden als GEUL-Dokumente veröffentlicht ([Codec-Spezifikationsdokument](codec-spec.md)). Der Decoder muss deshalb nur das benötigte Spezifikationsdokument beziehen und lesen.

## Bereichsstruktur {#영역-구조}

Die oberen Bits des TAG WORD teilen die Bereiche ein.

| Prefix | Bereich | Anteil | Definition |
|---|---|---|---|
| `1` | ferne Zukunft | 50 % | Reserved (ferne Zukunft). Wird nicht verwendet |
| `01` | Zukunft | 25 % | Reserved (nahe Zukunft). Wird nicht verwendet |
| `001` | Standard | 12,5 % | offiziell übernommene und betriebene Grammatik |
| `000` | frei/Vorschlag | 12,5 % | aktuelle Grammatik. Wird sie übernommen, bleibt das Layout unverändert und nur das Prefix wechselt zu `001` |

Die aktuelle Grammatik liegt vollständig im Bereich `000`. Alle TAG WORD dieser Spezifikation beginnen mit `000`.

- Ein v1-Decoder weist TAG WORD ab, deren Prefix nicht `000` ist. Die anderen Bereiche legt eine spätere Fassung fest.
- Der Bereich `000` ist ein Vorschlagsraum. Derzeit gelten weder Registrierung noch Schutz.
