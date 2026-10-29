---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "Öffentliche GitHub-Repositories von GEUL: die Go-Bibliothek und die geul-CLI, Laden und Umwandeln von Wikidata, die Suchmaschine SILK, Codebücher aus der Zeit vor v1 und diese Website."
image: "/images/og-default.webp"
---

Die öffentlichen Repositories von GEUL befinden sich in der GitHub-Organisation [geul-org](https://github.com/geul-org). Maßgeblich für die Grammatik ist die [GEUL-Grammatik](/de/grammar/) auf dieser Website.

Ein GEUL-Dokument ist eine Folge von 16-Bit-WORDs. Die Dateneinheit ist der Datensatz (Record), der mit einem TAG WORD beginnt; Datensätze stehen in einem Dokument. Dokumente werden von einem Issuer veröffentlicht, und jede Version ist durch einen Inhalts-Hash festgelegt. Die folgenden Repositories sind Werkzeuge, um diese Dokumente zu schreiben, zu lesen, umzuwandeln und zu durchsuchen.

---

## Bibliothek

### gogeul

Die Go-Bibliothek von GEUL und das Kommandozeilenwerkzeug `geul`.

Schreibt, liest, prüft und veröffentlicht GEUL-Dokumente (`.geul`). Die Pakete bieten Formatprüfung, Dekodierung von Datensätzen anhand von Codec-Spezifikationsdokumenten, Versionsdiffs, Auflösung von IMPORT-Abhängigkeiten und den TOULMIN-Codec. Die CLI `geul` deckt Bearbeiten (`new`, `add`), Veröffentlichen (`publish`), Ansehen (`ls`, `log`, `show`), einen Browser-Viewer (`serve`, `build`) und Pack-Archive (`pack build`, `pack unpack`) ab. Pack-Archive können Datensätze mit zstd komprimiert speichern.

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| Sprache | Go |
| Lizenz | CC0 |

---

## Wikidata

### wikigeul

Umwandlung Wikidata → GEUL (früher gogeulwiki).

Liest einen Wikidata-Dump, den wikipg in PostgreSQL geladen hat, und veröffentlicht ein GEUL-Dokument pro Item oder Property, mit Labels, Beschreibungen, Aliasen, Aussagen mit ihren Qualifikatoren und Belegen sowie Sitelinks in allen Sprachen. Alle Dokumente werden unter dem Issuer `wikidata.geul.org` (`0x00010000`) veröffentlicht.

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| Sprache | Go |
| Lizenz | CC0 |

### wikipg

Verlustfreies Laden von Wikidata-JSON-Dumps in PostgreSQL.

Speichert Entitäten, Labels, Beschreibungen, Aliase, Aussagen, Qualifikatoren, Belege, Sitelinks und Lexeme in Dump-Reihenfolge und bewahrt jede Dump-Zeile wörtlich auf. Auch der Dump selbst (Datei, URL, Größe, Prüfsummen, Commit des Laders) wird festgehalten. wikipg hängt nicht von GEUL ab.

| | |
|---|---|
| GitHub | [geul-org/wikipg](https://github.com/geul-org/wikipg) |
| Sprache | Go |
| Lizenz | CC0 |

---

## Suche

### silk

[SILK](/de/projects/silk/) — eine für GEUL gebaute Index- und Suchmaschine.

Baut partitionierte, sortierte Indizes der Datensätze eines GEUL-Pack-Archivs und beantwortet Anfragen wie „Welche Dokumente sagen aus, dass der Beruf (P106) einer Person Physiker (Q169470) ist?", ohne alle Dokumente zu dekodieren. Datensätze und ihre Felder grenzt es allein anhand der TAG WORDs ab, ohne Codebuch. Es ist in früher Entwicklung, prüft seine Suchalgorithmen, und die Formate können sich vor einer ersten Veröffentlichung ändern.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Sprache | Go |
| Lizenz | CC0 |

---

## Codebücher (vor v1)

Die beiden folgenden Repositories wurden vor der aktuellen v1-Grammatik entworfen. Teile davon passen nicht zu ihr.

### sidx

Forschung zur Vergabe von SIDX (Semantic-aligned Index).

Forschungsmaterial zur Vergabe von SIDX, einer semantischen Adresse, die bedeutungsnahen Entitäten nahe Nummern gibt, anhand von Wikidata-Nutzungsstatistiken. Es enthält das frühere 48-Bit-Attributschema für Entity, Encoder-Skripte und Codebücher; eine SIDX-Vergabe gibt es noch nicht. Die normative Definition von SIDX ist [GEUL-SIDX](/de/grammar/reference/geul-sidx/) in der Grammatik.

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| Sprache | Python |
| Lizenz | CC0 |

### wordnet-verb

Vorläufige Ausgabe eines 16-Bit-Verb-Codebuchs auf Basis von WordNet 3.0.

Gibt jedem der 13.767 Verb-Synsets von WordNet 3.0 einen 16-Bit-Code, mit nahen Codes für bedeutungsnahe Verben. Es ist eine vorläufige Ausgabe, die durch ein Codebuch ohne WordNet ersetzt werden soll; wie die Codes in GEUL-Datensätzen getragen werden, ist noch nicht entschieden.

Es enthält aus WordNet abgeleitetes Material und ist daher **kein CC0-Ergebnis.** Die aus WordNet abgeleiteten Teile unterliegen der WordNet 3.0 License; nur die eigenen Teile des GEUL-Projekts, etwa die Codes und die Klassifikation, sind CC0.

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| Sprache | Python |
| Lizenz | WordNet 3.0 License (abgeleitete Teile) · CC0 (eigene Teile) |

---

## Website

### geul-org

Quelltext dieser Website, geul.org.

Eine statische Hugo-Site in 12 Sprachen, ausgeliefert über S3 + CloudFront.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Sprache | Hugo |
| Lizenz | CC0 |

---

## Verwandte Repositories

Repositories außerhalb der Organisation geul-org.

### toulmin

Eine Regel-Engine auf Grundlage des Argumentationsmodells von Toulmin (TypeScript, Python, Go, C).

Regeln sind Funktionen, Ausnahmen sind Angriffsbeziehungen in einem Graphen. Das [TOULMIN](/de/grammar/edge/toulmin/)-Edge der GEUL-Grammatik (direkte Codes `0x60`–`0x7B`) schreibt diese Urteils- und Ausführungsgraphen als GEUL-Dokumente.

| | |
|---|---|
| GitHub | [park-jun-woo/toulmin](https://github.com/park-jun-woo/toulmin) |
| Lizenz | MIT |
