---
title: "SILK — Symbolischer Index fur LLM-Wissen"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["SILK", "search", "SIDX", "neuro-symbolic"]
summary: "Neuro-symbolische Sucharchitektur auf Basis von 64-Bit-Ganzzahlen. Durchsucht 100 Millionen Wikidata-Entitaeten in unter einer Sekunde ohne Vector DB, ANN-Graphen oder Embedding-Modelle."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Symbolic Index for LLM Knowledge** — neuro-symbolische Sucharchitektur.

Suche mit 64-Bit-Ganzzahlen. Keine Vector DB, keine ANN-Graphen, keine Embedding-Modelle.

<a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">GitHub-Repository</a>

## Kernthese

Suche war kein schwieriges Problem, sondern ein **Symptom unstrukturierter Daten**.
Wenn man beim Schreiben eine 64-Bit-Struktur zuweist, verschwindet das Symptom.

```python
results = index[(index & mask) == pattern]
```

100 Millionen Wikidata-Entitaeten in 1,3 GB Arbeitsspeicher, Suche in unter einer Sekunde.
Allein mit Python (NumPy) schlaegt man optimierte C++/Rust-Vector-DBs — ein Sieg der Architektur.

## Warum nicht vektorielle Embeddings

Vektorielle Embeddings zerstoeren die Struktur.

```
"Friedrich der Grosse war ein preussischer Koenig und Feldherr des 18. Jahrhunderts"
 → Ein Mensch erkennt sofort: Deutscher, Militaer, 18. Jahrhundert

Embedding-Modell:
 [0.234, -0.891, 0.445, ..., 0.112] (384 Dimensionen float)
 → Struktur zerstoert. Nicht lesbar, ob person oder location.

Um die zerstoerte Struktur wiederherzustellen:
 ANN-Graphen (HNSW, IVF-PQ), Cross-Encoder, Re-Ranker, Metadaten-Filter...
```

SILK bewahrt die Struktur.

```
SIDX: [Human / military / europe / early_modern]
 → Die Struktur lebt in den Bits. Man kann sie lesen.
 → Nichts wiederherzustellen. Sie wurde nie zerstoert.
```

Der Schluessel ist die Umkehrung der Reihenfolge.

```
Konventionell: zuerst schreiben → spaeter strukturieren (Indexierung)
SILK:          beim Schreiben strukturieren → Suche ist kostenlos
```

## SIDX-Bit-Layout

SIDX folgt der Entity-Node-Spezifikation der [GEUL-Grammatik](/de/grammar/).

```
[prefix 7 | mode 3 | entity_type 6 | attrs 48]
 MSB(63)                                  LSB(0)
```

| Feld | Bits | Groesse | Beschreibung |
|------|------|---------|--------------|
| prefix | 63-57 | 7 | GEUL-Protokoll-Header (`0001001` fest, bei Suche ignoriert) |
| mode | 56-54 | 3 | Quantifizierungs-/Numerusmodus (registrierte Entitaet=0, definit, universell, existenziell usw., 8 Typen) |
| entity_type | 53-48 | 6 | 64 Typen der obersten Ebene (Human=0 ~ Election=62, unklassifiziert=63) |
| attrs | 47-0 | 48 | Typspezifische Attributkodierung (durch Codebook definiert) |

Suchziel: entity_type 6 Bits + attrs 48 Bits = **54 Bits**.
Die QID ist nicht im SIDX enthalten; sie wird in einem separaten Array gespeichert.

### attrs 48 Bits — Schema je Typ

```
Human(0):       subclass 5 | occupation 6 | country 8 | era 4 | decade 4 | gender 2 | notability 3 | ...
Star(12):       constellation 7 | spectral_type 4 | luminosity 3 | magnitude 4 | ra_zone 4 | dec_zone 4 | ...
Settlement(28): country 8 | admin_level 4 | admin_code 8 | lat_zone 4 | lon_zone 4 | population 4 | ...
Organization(44): country 8 | org_type 4 | legal_form 6 | industry 8 | era 4 | size 4 | ...
Film(51):       country 8 | year 7 | genre 6 | language 8 | color 2 | duration 4 | ...
```

Derzeit sind die Attribut-Bit-Layouts fuer 5 Typen definiert. Die uebrigen kodieren nur entity_type.

## Architektur

SILK hat zwei Pipelines: **Kodierung** (beim Schreiben) und **Suche** (beim Abfragen).
Beide folgen demselben Prinzip: Das Symbolische erfasst die Struktur, das LLM verarbeitet die Bedeutung.

```
Kodierungs-Pipeline (beim Schreiben)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  LLM-        │──►│  VALID-      │──►│  Codebook-   │
│  Tagging     │   │  Validierung │   │  Kodierung   │
│  Dok → JSON  │   │ Gueltige     │   │ JSON → SIDX  │
│ (semant.     │   │ Codebook-    │   │ (Bit-        │
│  Klassifik.) │   │ Werte        │   │  Assemblierung)│
│              │   │ Halluzination│   │              │
│              │   │ → Verwerfung │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
  LLM taggt        Code validiert    Codebook-Kodierung
```

```
Such-Pipeline (beim Abfragen)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Abfrage-     │──►│ Bit-AND-     │──►│  LLM-        │
│ Interpretation│   │ Filter       │   │  Beurteilung │
│ Codebook-    │   │ NumPy SIMD   │   │ Nur wenige   │
│ Lookup       │   │ 100M → einige│   │ Kandidaten   │
│ + LLM-Hilfe  │   │ Dutzend      │   │ → Antwort    │
└──────────────┘   └──────────────┘   └──────────────┘
  Semant. Extraktion  Breite Filterung  Praezises Urteil
```

Kernstrategie: **mit SIDX-Bit-AND breit filtern, ohne etwas zu verlieren**, dann **beurteilt das LLM nur die wenigen Kandidaten**.

```
Jeder macht, was er am besten kann:
 Mensch: Struktur entwerfen (Codebook)
 LLM:    semantische Klassifikation (Tagging) + semantische Beurteilung (Suche)
 Code:   Regelvalidierung (VALID) + Bit-Assemblierung
 CPU:    Massenvergleich (NumPy SIMD)
```

### Kodierung: LLM-Tagging → VALID-Validierung

Das LLM liest das Dokument und taggt es als JSON. VALID fuehrt eine mechanische Pruefung anhand des Codebooks durch.
Werte ausserhalb des Codebooks, Konsistenzverletzungen zwischen Typen und Einschraenkungsverletzungen **koennen physisch nicht in den Index gelangen**.

```
LLM-Tagging: {"type": "Human", "occupation": "military", "country": "germany"}
VALID:       occupation="military" ∈ Codebook? ✓  country="germany" ∈ Codebook? ✓
             Human mit Feld constellation? ✗ Verworfen
Kodierung:   Codebook "military"→6 Bits, "germany"→8 Bits → Bit-Assemblierung → SIDX uint64
```

Das LLM kann halluzinieren. Aber da VALID als Waechter fungiert, ist die Moeglichkeit einer Index-Kontamination 0.
Nur JSON, das VALID passiert, wird codebookbasiert als 64-Bit-SIDX-Ganzzahl kodiert.

### Suche: breit filtern, LLM verfeinert

```
1. Semantische Extraktion    Codebook-Lookup 80% / LLM-Unterstuetzung 20%
2. Masken-Assemblierung      Deterministisch — Algorithmus
3. NumPy-Bit-AND             Deterministisch — vollstaendiger Scan von 100M in 20ms
4. LLM-Endbeurteilung        Nur wenige Kandidaten — praezise semantische Beurteilung
```

### 80% der Suchen sind strukturelle Abfragen

```
"Friedrich der Grosse" → Q33550 exact match. Bit AND. Fertig.
"Samsung Nachrichten"  → org/company + doc_meta/news. Bit AND. Fertig.
"Biden-Xi Gipfel"      → Q6279 ∩ Q15031 ∩ meeting. Schnittmenge. Fertig.
```

```
Strukturelle Abfrage (80%): mit SILK-Bit-AND abgeschlossen. Kein LLM.
Semantische Abfrage  (15%): SILK reduziert Kandidaten → LLM beurteilt 5-10 Eintraege.
Generative Abfrage    (5%): SILK lokalisiert Dokumente → LLM generiert.
```

## Multi-SIDX

Ein einzelnes Dokument/Ereignis kann mehrere SIDX haben.

```
Nachrichtenartikel "Treffen der Chefs von Samsung, NVIDIA und Hyundai":

SIDX[0]: [Human / business / east_asia ]  Lee Jae-yong
SIDX[1]: [Org   / company / east_asia ]  Samsung Electronics
SIDX[2]: [Human / business / n_america]  Jensen Huang
SIDX[3]: [Org   / company / n_america]  NVIDIA
SIDX[4]: [Human / business / east_asia ]  Chung Eui-sun
SIDX[5]: [Org   / company / east_asia ]  Hyundai Motor
SIDX[6]: [Event / meeting / east_asia ]  Treffen
```

Alles derselbe 64-Bit-SIDX. Derselbe Index. Dieselbe Bit-AND-Suche.
Das Feld entity_type unterscheidet Entitaeten (Human, Org) von Ereignissen (Event).

## Indexstruktur

```python
sidx_array = np.array([...], dtype=np.uint64)  # 108.8M × 8B = 870MB
qid_array  = np.array([...], dtype=np.uint32)  # 108.8M × 4B = 435MB
# Gesamt ~1,3 GB Arbeitsspeicher
```

```
Indexaufbau:
 Elasticsearch: Tokenisierung → Analyse → invertierter Index → Segment-Merge
 Pinecone:      Embedding → HNSW-Graph → Clustering
 SILK:          sort
```

Keine Datenstruktur. Ein einziges sortiertes Array.

## Vergleich mit Vector DB

|  | SILK | Vector DB |
|------|------|-----------|
| Indexgroesse (1 Mrd. Eintraege) | 12 TB | 1,5 PB (125x) |
| Indexaufbau | sort | HNSW mehrere Tage |
| Kaltstart | Sofort beim Oeffnen | Stunden fuer Graphaufbau |
| Partitionierter Scan | Moeglich (gleiches Ergebnis) | Unmoeglich (Graph gebrochen) |
| Zusammengesetzte Bedingungen | Schnittmenge (exakt) | In 1 Vektor komprimiert (approximiert) |
| Ergebnis | Exakt (Mengenoperation) | Approximiert (Aehnlichkeitsranking) |
| Audit | JSON (White Box) | Unmoeglich (Black Box) |

```
Bit AND ist reihenfolgeunabhaengig, zustandslos, akkumulierbar.
Vector DB: der gesamte Graph muss im Speicher sein. Partitionieren = zerstoeren.
SILK:      funktioniert, wo man schneidet. Partitionieren = nur langsamer. Gleiches Ergebnis.
```

## Audit-Pipeline

Vektorielle Embeddings sind eine Black Box: nicht auditierbar. SIDX ist JSON: auditierbar.

```
Phase 1 — Tagging mit kleinem LLM       Llama 8B / GPT-4o-mini. Genauigkeit 85-90%.
Phase 2 — Mechanische VALID-Pruefung     Gueltige Werte, Konsistenz, Einschraenkungen. Kosten 0 $.
Phase 3 — Audit mit grossem LLM          Nur confidence=low. Genauigkeit 99%+.

VALID als Waechter: Halluzinationen ausserhalb gueltiger Codebook-Werte koennen physisch nicht in den Index gelangen.
```

## Lizenz

MIT — <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">GitHub</a>
