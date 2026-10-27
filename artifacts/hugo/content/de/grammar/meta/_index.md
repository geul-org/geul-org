---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta sind Records über das Dokument, nicht über die Welt. Sie gliedern sich in sieben Klassen (Struktur, Definition, Herkunft, Abstammung, Verifikation, Richtlinie, IMPORT) und stehen im HEAD des Dokuments."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta enthält keine Aussagen über die Welt, sondern Records über das Dokument. Mit Ausnahme der Dokumentstruktur-Records (DOC, BODY, END) stehen alle im HEAD des Dokuments. Im HEAD stehen neben den Meta auch der Beleg-Edge [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) für das gesamte Dokument und dessen QUALIFIER.

## Layout

```
TAG WORD          0001 1LLL LCCC CCCC
[Length-Erweiterungs-TAG]
Payload           Rohwert oder eingebettete Value-/Reference-Records
```

- Meta hat kein Issuer-Format. Meta ist die gemeinsame Spezifikation, der alle Issuer folgen, und wird allein von GEUL definiert.
- `LLLL` ist die Gesamtzahl der WORDs einschließlich TAG WORD minus 1. Codecs, die nicht in der Tabelle stehen, sind reserviert.

## Payload-Formate

| Format | Wann | Beispiel |
|---|---|---|
| Rohwert | Das Format steht eindeutig fest. Es stützt sich auf keinen anderen Record-Codec | Länge von `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Eingebetteter Value | Wahl unter mehreren Formaten. Das Value-TAG nennt das Format | `PROFILE`, `EFFECTIVE-*`, Zeitpunkte, Inhaltshash |
| Eingebettete Reference | Verweis auf Personen, Organisationen, Werkzeuge, Dokumente | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, Signierender von `SIGNATURE` |
| Keiner | Marker aus 1 WORD | `BODY`, `END` |

- Eingebettete Records sind keine eigenständigen Records, sondern gehören zu ihrem Meta. Jeder findet seine Grenze über seine Length, und die Position nach dem Lesen des letzten Records muss genau mit dem Ende des Meta übereinstimmen.
- Ob ein Meta nur einmal oder mehrfach in einem Dokument stehen darf, legt der Abschnitt "Anzahl" im jeweiligen Codec-Dokument fest.

## Klassen

Die oberen 3 Bit des Codec sind die Klasse.

| Obere 3 Bit | Klasse | Direkter Code | Gegenstand |
|---|---|---|---|
| `000` | Struktur | `0x00`~`0x0F` | Grenzen und Länge des Dokuments |
| `001` | Definition | `0x10`~`0x1F` | Interpretationsdeklarationen |
| `010` | Herkunft | `0x20`~`0x2F` | Wer, wann, woher |
| `011` | Abstammung | `0x30`~`0x3F` | Woraus und wie es entstanden ist |
| `100` | Verifikation | `0x40`~`0x4F` | Ob man ihm vertrauen kann |
| `101` | Richtlinie | `0x50`~`0x5F` | Wie damit umzugehen ist |
| `110` | IMPORT | `0x60`~`0x6F` | Import externer Dokumente |
| `111` | Reserviert | `0x70`~`0x7F` | |

- **Für die Interpretation nötige Meta**: Struktur, Definition, IMPORT. Ohne sie lassen sich Records nicht lesen oder ihre Interpretation ändert sich. Jeder Decoder muss sie verarbeiten. Diese Codecs gehören zum **GEUL-Kern-Codebook**.
- **Meta, die die Interpretation nicht ändern**: Herkunft, Abstammung, Verifikation, Richtlinie. Ohne sie bleibt der Inhalt der Aussagen unverändert. Es fehlt nur das Material für Vertrauensurteile und Umgang.
- Den Beleg schreibt man nicht als Meta, sondern mit dem Beleg-Edge [SOURCE](/de/grammar/edge/source/) und QUALIFIER. Der Beleg einzelner Records steht im BODY, die Quelle des gesamten Dokuments im HEAD als SOURCE mit Target `0` ([Dokument](/de/grammar/document/#head-und-body)).

## Struktur

Sammelseite: [Meta — Struktur](/de/grammar/meta/structure/)

| Codec | Name | Bedeutung |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/de/grammar/meta/structure/doc/) | Öffnet das Dokument mit Angabe der Gesamtlänge |
| `0x0E` | [BODY](/de/grammar/meta/structure/body/) | Beendet den HEAD und öffnet den BODY |
| `0x0F` | [END](/de/grammar/meta/structure/end/) | Schließt das Dokument |

Die Einzelheiten stehen unter [Dokument](/de/grammar/document/).

## Definition

Sammelseite: [Meta — Definition](/de/grammar/meta/declaration/)

| Codec | Name | Bedeutung |
|---|---|---|
| `0x10` | [SPEC-VERSION](/de/grammar/meta/declaration/spec-version/) | Befolgte Spezifikationsausgabe. Eine einzelne Ganzzahl |
| `0x11` | [PROFILE](/de/grammar/meta/declaration/profile/) | Angewandtes Profil |
| `0x12` | [DOC-ID](/de/grammar/meta/declaration/doc-id/) | Kennung dieses Dokuments. Ein DOC-POINTER (Version 0), der auf das Dokument selbst zeigt |
| `0x13` | [EFFECTIVE-FROM](/de/grammar/meta/declaration/effective-from/) | Inkrafttreten dieser Version. Fehlt er, gilt der Veröffentlichungszeitpunkt |
| `0x14` | [EFFECTIVE-UNTIL](/de/grammar/meta/declaration/effective-until/) | Ende der Gültigkeit dieser Version (befristetes Recht). Fehlt er, bis die nächste Version in Kraft tritt |
| `0x16` | [DEFAULT-LANGUAGE](/de/grammar/meta/declaration/default-language/) | Standardsprache |

- Der Adressname eines Dokuments wird nicht als Meta gesetzt. Der Namensindex `documents.geul` des Issuers hängt ihn per BIND an ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#dokumentname)). Einen für Menschen lesbaren Titel hängt man als LABEL im BODY an.

## Herkunft

Sammelseite: [Meta — Herkunft](/de/grammar/meta/provenance/)

| Codec | Name | Bedeutung |
|---|---|---|
| `0x20` | [AUTHOR](/de/grammar/meta/provenance/author/) | Autor (Reference) |
| `0x21` | [CO-AUTHOR](/de/grammar/meta/provenance/co-author/) | Mitautor |
| `0x22` | [CREATED-AT](/de/grammar/meta/provenance/created-at/) | Erstellungszeitpunkt |
| `0x23` | [MODIFIED-AT](/de/grammar/meta/provenance/modified-at/) | Änderungszeitpunkt |
| `0x24` | [RECORDED-BY](/de/grammar/meta/provenance/recorded-by/) | Aufzeichnende Instanz |
| `0x25` | [RECORDED-AT](/de/grammar/meta/provenance/recorded-at/) | Aufzeichnungszeitpunkt |
| `0x26`~`0x2F` | Reserved | |

- Quellmaterial schreibt man nicht als Meta, sondern als Beleg-Edge [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) (Target `0`) im HEAD. Den Bereich im Originaltext, den Beschaffungszeitpunkt und den Hash des Originals schreibt man als QUALIFIER, der an dieses SOURCE angehängt wird.

## Abstammung

Sammelseite: [Meta — Abstammung](/de/grammar/meta/lineage/)

Die Abstammung folgt dem Commit-Modell von git. Die Einheit, die einem Commit entspricht, ist das Dokument.

| Codec | Name | Bedeutung |
|---|---|---|
| `0x30` | [PARENT](/de/grammar/meta/lineage/parent/) | Inhaltshash der unmittelbar vorherigen Version. Mehrere bedeuten einen Merge |
| `0x31` | [DERIVED-FROM](/de/grammar/meta/lineage/derived-from/) | Abgeleitet von Material einer anderen Abstammungslinie |
| `0x32` | [GENERATED-BY](/de/grammar/meta/lineage/generated-by/) | Erzeugende Instanz (Mensch, Modell, Regelmaschine) |
| `0x33` | [TRANSFORMED-BY](/de/grammar/meta/lineage/transformed-by/) | Transformationswerkzeug und dessen Quellversion (Commit-Digest) |
| `0x34` | [CHERRY-PICKED-FROM](/de/grammar/meta/lineage/cherry-picked-from/) | Ursprungsversion einer übernommenen Änderung |
| `0x35` | [REVERTS](/de/grammar/meta/lineage/reverts/) | Zurückgenommene Zielversion |
| `0x36` | [REPLACES](/de/grammar/meta/lineage/replaces/) | Überarbeitete Zielversion. Die ursprüngliche Version wird nicht gelöscht |
| `0x37` | [SQUASHED-FROM](/de/grammar/meta/lineage/squashed-from/) | Ursprungsversionen, die zu einer zusammengefasst wurden |
| `0x38` | [MESSAGE](/de/grammar/meta/lineage/message/) | Grund der Änderung. Eine je Sprache |
| `0x39` | [TAG](/de/grammar/meta/lineage/tag/) | Unveränderlicher Name einer Version |
| `0x3A` | [DELTA-BASE](/de/grammar/meta/lineage/delta-base/) | Diese Datei ist ein Diff gegen eine Basisversion |
| `0x3B` | [DELTA-REMOVE](/de/grammar/meta/lineage/delta-remove/) | Liste der LOCAL IDs, die aus dem Diff zu entfernen sind |
| `0x3C` | [NEXT-LOCAL-ID](/de/grammar/meta/lineage/next-local-id/) | Nächste zu vergebende LOCAL ID. Steht im Versionslisten-Dokument |

- Die Historie wird nicht gelöscht. Korrekturen erscheinen als neue Version.
- Veränderliche Zeiger wie Branches stehen nicht im Dokument. Sie werden vom Repository und vom Index verwaltet.

## Verifikation

Sammelseite: [Meta — Verifikation](/de/grammar/meta/verification/)

| Codec | Name | Bedeutung |
|---|---|---|
| `0x40` | [ISSUER-KEY](/de/grammar/meta/verification/issuer-key/) | Signaturalgorithmus und öffentlicher Schlüssel eines selbst ausgestellten Issuers |
| `0x41` | [SIGNATURE](/de/grammar/meta/verification/signature/) | Signatur über den Inhaltshash. Algorithmus, Signierender, Signatur |
| `0x42` | [SIGNED-OFF](/de/grammar/meta/verification/signed-off/) | Bestätigung des Beitragsrechts |
| `0x43` | [CONFIDENCE](/de/grammar/meta/verification/confidence/) | Vertrauenswert |
| `0x44` | [VERDICT](/de/grammar/meta/verification/verdict/) | Urteil über das gesamte Dokument (Pass, Review, Fail) |

- Die Verifikationsklasse wird bei der Berechnung des Inhaltshash ausgelassen. Deshalb ändert sich der Inhaltshash weder, wenn man die Signatur ins Dokument legt, noch, wenn man weitere Signaturen hinzufügt.

## Richtlinie

Sammelseite: [Meta — Richtlinie](/de/grammar/meta/policy/)

| Codec | Name | Bedeutung |
|---|---|---|
| `0x50` | [LICENSE](/de/grammar/meta/policy/license/) | Lizenz |
| `0x51` | [ACCESS](/de/grammar/meta/policy/access/) | Zugriffsbereich |
| `0x52` | [PRIVACY](/de/grammar/meta/policy/privacy/) | Datenschutzstufe |
| `0x53` | [RETENTION](/de/grammar/meta/policy/retention/) | Aufbewahrungsfrist |
| `0x54` | [CONSENT](/de/grammar/meta/policy/consent/) | Umfang und Grundlage der Einwilligung |
| `0x55` | [USAGE](/de/grammar/meta/policy/usage/) | Nutzungsbeschränkung |

- Eine Richtlinie ändert nicht die Interpretation, sondern legt den Umgang fest.

## IMPORT

Sammelseite: [Meta — IMPORT](/de/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length-Erweiterungs-TAG]
Dokument          DOC-POINTER-Record (Issuer, Dokument-ID, Versions-ID)
IMPORT ID         Rest. Ganzzahl in der kürzesten Breite
```

- Verwendet wird nur [IMPORT-DOC](/de/grammar/meta/import/import-doc/) (`0x60`). IMPORT importiert nur Dokumente. Ziele innerhalb des importierten Dokuments werden im BODY über `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) angesprochen.
- Mit angegebener Versions-ID bindet es an diese Fassung, bei `0` an die zum Zeitpunkt der Interpretation neueste Fassung. Veröffentlichte Dokumente geben die Version an.
- In einem Dokument wird dieselbe IMPORT ID nicht zweimal vergeben.
- Der HEAD des importierten Dokuments wird nicht importiert. Die Ziele dieses Dokuments werden gemäß dessen eigenen Deklarationen interpretiert.

Beispiel: Von Issuer `0x0001` wird die neueste Version des Dokuments `0x0000000000000002` mit IMPORT ID 1 importiert.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
