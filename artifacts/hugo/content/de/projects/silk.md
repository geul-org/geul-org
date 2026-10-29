---
title: "SILK — Index- und Suchmaschine für GEUL"
weight: 1
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SILK", "Suche", "Index", "GEUL", "Go"]
summary: "Eine Engine, die GEUL-pack-Archive datensatzweise indiziert und durchsucht. Da die Daten schon beim Schreiben strukturiert sind, bleiben für die Suche nur Ganzzahlvergleiche und Bereichssuchen. Abfragen in 0,1–4 ms auf Wikidata Q1–Q10000."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
aliases:
  - /de/silk/
---

SILK ist eine **Index- und Suchmaschine speziell für GEUL**. Ohne GEUL-Dokumente vollständig zu dekodieren, beantwortet sie allein über Datensatzindizes Abfragen wie „Welche Dokumente geben an, dass die Tätigkeit (P106) Physiker (Q169470) ist?“.

| | |
|---|---|
| Status | Frühe Entwicklung. Die Suchalgorithmen werden gerade validiert; bis zum ersten Release können sich Formate ändern |
| Sprache | Go |
| Eingabe | GEUL-pack-Archive (unkomprimiert) |
| Lizenz | CC0 |
| Repository | <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a> |

## Kernthese

Nicht die Suche ist schwierig – **das Problem sind Daten ohne Struktur**.

```
Herkömmlich: erst schreiben → später Struktur erraten (Tokenisierung, Embeddings, Analyse)
GEUL:        beim Schreiben strukturieren → Suche ist nur noch Ganzzahlvergleich und Bereichssuche
```

Ein GEUL-Datensatz enthält Felder wie Subjekt, Prädikat, Objekt und Sprache bereits als Ganzzahl-IDs an festen Positionen. SILK zieht diese Felder lediglich heraus und hält sie sortiert vor.

## Warum es zu GEUL passt

| Eigenschaft von GEUL | Was SILK dadurch gewinnt |
|---|---|
| Ein einziges 16-Bit-TAG WORD enthält Art (Kind, Codec) und Länge | Datensätze lassen sich ohne Codebuch filtern und überspringen |
| Die Felder einer Edge sind Datensätze an festen Positionen | Schlüssel werden über ihre Position ausgelesen. Eigene Parsing-Regeln sind nicht nötig |
| Das kontrollierte Vokabular besteht aus Ganzzahl-IDs (Q, P, Sprache) | Gleichheit wird per Ganzzahlvergleich geprüft, ohne Zeichenketten-Normalisierung |
| Ein pack besteht aus unveränderlichen Objekten und Generationen | Auch der Index wird aus unveränderlichen Segmenten und Generationen aufgebaut, daher sind Snapshots sicher |
| Die Konvertierung ist deterministisch | Gleiche Eingabe ergibt gleichen Index. Inkrementelle Ergebnisse lassen sich Byte für Byte mit einem von Grund auf erstellten Index abgleichen |

GEUL-Dokumente werden nie umsortiert. Der Index ist nur eine sortierte **Sicht (view)**; veröffentlichte Bytes, Inhalts-Hashes und Signaturen bleiben unverändert.

## Aufbau

### Eingabe

GEUL-pack-Archive werden über [gogeul](https://github.com/geul-org/gogeul) gelesen. Da der Index auf Byte-Positionen innerhalb der data packs verweist, muss das Set die Datensätze unkomprimiert speichern (`GEULCOMPRESS=none`). zstd-Kompression dient der Verteilung und Archivierung; die Suchschicht verwendet unkomprimierte packs.

### Partitionsspezifikation

Für jede TAG-Art werden ein **Partitionsschlüssel** und ein **Sortierschlüssel** als Felder mit fester Position im Datensatz deklariert. Prädikate oder Sprachen sind nicht fest einprogrammiert; die folgende Tabelle zeigt die Standardwerte für Wikidata-Dokumente.

| TAG | Partitionsschlüssel | Sortierschlüssel |
|---|---|---|
| TRIPLE | Prädikat (Predicate) | Objekt (Object) |
| QUALIFIER | Eigenschaft (Property) | Wert (Value) |
| LABEL·ALIAS·DESCRIPTION | Sprache | Subjekt (Subject) |
| SOURCE | keiner | Herkunft (Origin) |
| REFERENCE-NODE | keiner | Objekt (Object) |

- Ein Schlüssel sind die ersten Bytes (ein Slot) des Felddatensatzes. Passt der Datensatz in den Slot, ist die Gleichheit exakt; ist er länger, wählt der Schlüssel nur Kandidaten aus.
- Die Spezifikationsprüfung weist Felder als Partitionsschlüssel zurück, deren Position nur mit einem Codebuch bestimmbar ist oder deren Länge unbegrenzt ist.
- Eine Spezifikation wird über ihren Inhalts-Hash identifiziert. Ändert sie sich, wird nur dieser TAG neu aufgebaut.

### Runs, Inkremente und Zusammenführung

| Element | Aufgabe |
|---|---|
| Sortierter Run | Unveränderliches Segment, je Partition nach (Sortierschlüssel, Dokument, Offset) sortiert. Wird binär durchsucht |
| Angehängtes Segment | Enthält nur die neu hinzugekommenen Revisionen eines inkrementellen Updates (`silk index update`). Wird gescannt |
| Bitmap lebender Revisionen | Markiert alte Revisionen geänderter Dokumente als tot, statt sie zu löschen |
| Größenstufenweise Zusammenführung | Führt Runs derselben Größenstufe per O(n)-Merge zusammen und bei vielen toten Zeilen bis in den Basis-Run hinein |
| Generation | Die Manifest-Generation wird atomar ausgetauscht. Lesende fixieren eine Generation, sodass der Snapshot auch während einer Zusammenführung erhalten bleibt |

Die Zusammenführung lässt sich auf Leerlaufzeiten beschränken (`-idle`, 30 % von CPU und Speicher bleiben frei). Sie hält an Partitionsgrenzen an und setzt an einem Checkpoint wieder auf.

### Abfragen

1. **Gleichheitsbedingung**: Partition finden und in den sortierten Runs binär suchen.
2. **Mehrere Bedingungen**: Merge-Join über das Dokument (Subjekt). Alle Bedingungen müssen innerhalb desselben Dokuments erfüllt sein.
3. **Präzise Prüfung**: Kandidatendatensätze mit gogeul dekodieren, feldweise vergleichen und die Edge Id lesen.

```sh
silk query -triple P106=Q169470 ARCHIVE
silk query -count -triple P31=Q5 -triple P106=Q169470 ARCHIVE
silk query -label ko -match LABEL:1=Q42 ARCHIVE
```

## Messungen

Gemessen auf Wikidata Q1–Q10000 und 16.696 Eigenschaftsdokumenten (271 MB, 7,07 Millionen Indexdatensätze). 8 Threads, bester von 7 Durchläufen, ohne Prozessstartzeit.

### Abfragen

| Abfrage | Ergebnisdokumente | Bisheriges Verfahren (vollständiger Scan) | SILK-Index |
|---|---:|---:|---:|
| P106=Q169470 (Tätigkeit = Physiker) | 55 | ~20ms | 0,12ms |
| P31=Q5 (Mensch) | 1.579 | ~19ms | ~1ms |
| Mensch + Physiker | 54 | ~38ms | ~1ms |
| LABEL ko | 9.746 | (nicht möglich) | ~4ms |

- Das bisherige Verfahren scannte die gesamte TRIPLE-Datensatztabelle.
- Bei LABEL ko entfällt der Großteil der Zeit darauf, 9.746 Datensätze zur präzisen Prüfung aus dem pack zu lesen.

### Größe, Aufbau und Inkremente

| Punkt | Wert |
|---|---|
| Indexgröße | 113MB (durchschnittlich 15,7B pro Datensatz) |
| Aufbau | ~3 Sekunden (Dokument-Parsing single-threaded) |
| Inkrementelles Update (4.217 geänderte Revisionen) | 1,8 Sekunden |
| Inkrementelles Ergebnis | Nach 2 Updates, 2 Zusammenführungen sowie Abbruch und Wiederaufnahme sind die Abfrageergebnisse Byte für Byte identisch mit einem von Grund auf erstellten Index |
| Schreibverstärkung | 1,31 kumuliert (1,71 bei jedesmal vollständigem Neuaufbau) |

- Hochgerechnet auf ganz Wikidata (rund 7,5 Milliarden Datensätze) wäre der Index etwa 110 GB groß (**Schätzung**).
- Der Preis ist die Größe: etwa viermal so groß wie eine einfache Tabelle mit 4 B pro Datensatz. Schmalere Slots und Entitätssignaturen sind die nächsten Untersuchungsthemen.

### Signatur-Scan (Vorabmessung für Entitätssignaturen)

Umgerechnete Zeit für den Scan von 100 Millionen 128-Bit-Signaturen mit Maske und Muster (i7-14700K, AVX2).

| Implementierung | Zeit |
|---|---:|
| NumPy, 1 Thread | ~1 s |
| Go, 1 Thread | ~134ms |
| Go, 8 Threads | ~27ms |
| Go, 16–20 Threads | ~23ms (Grenze der Speicherbandbreite) |

Den Unterschied macht nicht die Sprache, sondern **fusionierte Schleifen ohne Zwischenarrays und Multithreading**.

## Verhältnis zur Vektorsuche

Es ist Arbeitsteilung, kein Ersatz.

| | SILK | Vektorsuche |
|---|---|---|
| Zuständig für | Strukturierte Abfragen (Bedingungen zu Prädikat, Objekt, Sprache, Entität) | Semantische Ähnlichkeit, die sich schwer als Struktur ausdrücken lässt |
| Ergebnis | Die Menge, die die Bedingungen erfüllt (exakt) | Ein Ähnlichkeitsranking (approximativ) |
| Voraussetzung | Die Daten müssen in GEUL strukturiert sein | Originaltext oder Embeddings genügen |

Für Abfragen nach Fakten, die in GEUL ausgedrückt sind, ist SILK exakt und günstig. Für unstrukturierten Originaltext oder die Suche nach „etwas Ähnlichem“ ist die Vektorsuche besser geeignet.

## Einordnung und nächste Schritte

SILK ist **die Suchtechnik, die das WMS (der Koordinator für Speicherung und Abruf in GEUL) verwendet**. Ob eine gefundene Aussage zutrifft, beurteilt eine separate Bewertungs-Engine.

| Nächster Schritt | Inhalt |
|---|---|
| Entitätssignaturen | Eine Bitfolge fester Breite von 16–128 Bit pro Entität. Die Felder (Aufzählung, One-Hot, Bloom, Präfix, Bereich) deklariert der Nutzer. Es ist ein approximativer Vorfilter, dem eine präzise Prüfung folgt. Derzeit in der Planungsphase (teilweise in der Bibliothek, noch nicht im Index) |
| Spezifikation als GEUL-Dokument | Die JSON-Spezifikation als GEUL-Dokument deklarieren und das Layout aus den Codec-Spezifikationsdokumenten (DECLARE, FIELD) lesen |
| Index zum Zusammensetzen von Aussagen | Ein Target-Index, der das TRIPLE direkt findet, auf das ein QUALIFIER oder SOURCE verweist |
| Vorbereitung auf große Datenmengen | Speicherobergrenzen für Aufbau und Zusammenführung, parallelisiertes Parsing beim Aufbau |

Das ursprüngliche Konzept (2026-03) war ein Entwurf in Python und NumPy, der 64-Bit-Entitätskennungen per bitweisem AND durchsuchte. Inzwischen ist daraus eine Go-Engine geworden, die GEUL-Datensätze direkt indiziert.

## Repository und Lizenz

- Repository: <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a>
- Installation: `go install github.com/geul-org/silk/cmd/silk@latest`
- Lizenz: Unsere eigenen Werke stehen unter CC0 1.0. Komponenten Dritter unterliegen ihren jeweiligen Lizenzen (NOTICE im Repository).
