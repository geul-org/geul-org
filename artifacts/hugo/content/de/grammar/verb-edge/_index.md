---
title: "Verb Edge"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "huffman", "WordNet"]
summary: "Klassifizierung von 13.767 WordNet-Verben in 10 Primitive und 68 Sub-primitive mit Erzeugung eines 16-Bit-Codebuchs durch Huffman-Kodierung. Durchschnittliche Kompression von 2,16 Woertern mit 3 Pakettypen: Tiny (2 Woerter), Short (3 Woerter) und Full (5 Woerter)."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge ist der Edge-Typ, der Praedikationen und Aktionen im GEUL-Stream darstellt. Er klassifiziert 13.767 WordNet-Verben in 10 Primitive → 68 Sub-primitive und erzeugt ein 16-Bit-Codebuch durch **Huffman-Kodierung auf Sub-primitive-Ebene**.

## Unterdokumente

| Dokument | Beschreibung |
|----------|--------------|
| [Teilnehmerrollen](./semantic-role/) | 16 Semantic Role (4-Bit-Kodierung) |
| [Semantische Qualifikatoren](./qualifier/) | Evidentialitaet, Modus, Tempus, Aspekt usw. — 14 Qualifikatoren |

## Verbhierarchie

```
10 Primitive (oberste semantische Kategorien)
 ├── BE          ├── PERCEIVE    ├── FEEL
 ├── THINK       ├── CHANGE      ├── CAUSE
 ├── MOVE        ├── COMMUNICATE ├── TRANSFER
 └── SOCIAL
  → 68 Sub-primitive (Zwischenklassifikation)
    → 559 Root Verb (Wurzelverben)
      → 13,767 Leaf Verb (alle WordNet-Verben)
```

- Primitive (Hauptkategorien) dienen nur der **konzeptuellen Gruppierung** ohne Bit-Zuweisung
- Die 68 Sub-primitive (Unterkategorien) erhalten einen **frequenzbasierten Code variabler Laenge**
- Je haeufiger eine Verbgruppe, desto kuerzer der Code (4 bis 8 Bit)

## Verb Edge Pakettypen

Alle 3 Pakettypen Tiny/Short/Full teilen denselben **16-Bit-Verbkoerper** im letzten Wort.

| | Tiny | Short | Full |
|--|------|-------|------|
| Woerter | 2 (32 Bit) | 3 (48 Bit) | 5 (80 Bit) |
| Teilnehmer | 16 Muster | 512 Muster | 19-Bit-Flags |
| Qualifikatoren | 7 Muster | 3.640 Muster | 27 Bit |
| Verbkoerper | 16 Bit | 16 Bit | 16 Bit |
| Geschaetzter Anteil | 90% | 7% | 3% |

**Durchschnittliche Paketgroesse:** 0,9x2 + 0,07x3 + 0,03x5 = **2,16 Woerter**

### Tiny Verb Edge (2 Woerter)

```
1st WORD:  [Prefix 5bit] [Target×Muster 11bit]
2nd WORD:  [Verbkoerper 16bit]
```

- Target x Muster: 18 Target x 113 Muster = 2.034 Kombinationen
- 16 Teilnehmermuster x 7 Qualifikatormuster = 112 + 1 reserviert = 113
- Abdeckung ~90%

### Short Verb Edge (3 Woerter)

```
1st WORD:  [Prefix 6bit] [Type 1bit=0] [Teilnehmermuster 9bit]
2nd WORD:  [Target×Qualifikatormuster 16bit]
3rd WORD:  [Verbkoerper 16bit]
```

### Full Verb Edge (5 Woerter)

```
1st WORD:  [Prefix 6bit] [Type 1bit=1] [Target Teilnehmer 5bit] [Teilnehmer-Flags 4bit]
2nd+3rd:   [Teilnehmer-Flags 15bit] [Qualifikatoren 17bit]
4th WORD:  [Qualifikatoren 10bit] [Reserviert 6bit]
5th WORD:  [Verbkoerper 16bit]
```

## 16-Bit-Verbkoerper

```
┌─────────────────────────┬────────────────────────────┐
│   sub_primitive code    │     DFS-Index im Baum      │
│   (4-8 Bit, Huffman)    │     (8-12 Bit)             │
└─────────────────────────┴────────────────────────────┘
```

- **sub_primitive code:** 4~8 Bit variabel (Huffman-Code)
- **DFS index:** Identifikation des einzelnen Verbs innerhalb des Sub-primitive

### Verteilung der Codelaengen

| Codelaenge | Anzahl | Gesamtverben | Anteil |
|------------|--------|--------------|--------|
| 4 Bit | 4 | 6.388 | 46,4% |
| 5 Bit | 4 | 2.479 | 18,0% |
| 6 Bit | 8 | 2.321 | 16,9% |
| 7 Bit | 16 | 1.786 | 13,0% |
| 8 Bit | 36 | 813 | 5,9% |

### DFS-Index-Bit-Berechnung

| Sub-primitive Verbanzahl | Benoetigte Bits |
|--------------------------|-----------------|
| 1~256 | 8 Bit |
| 257~512 | 9 Bit |
| 513~1024 | 10 Bit |
| 1025~2048 | 11 Bit |
| 2049~4096 | 12 Bit |

Beispiel: CHANGE-TRANSFORM = `0000` (4 Bit) + 3.063 Verben (12 Bit) = 16 Bit.

### Durchschnittliche Codelaenge

```
Durchschnitt = Sigma(Codelaenge x Verbanzahl) / Gesamtverben ≈ 5,14 Bit
```

| Methode | Durchschn. Bits |
|---------|-----------------|
| Fest 7 Bit (68) | 7,00 |
| Huffman-Kodierung | 5,14 |
| **Einsparung** | **1,86 Bit (27%)** |

## Primitive — Hauptkategorien (10)

| Primitive | Bedeutung | Anz. Sub-primitive | Anz. Verben |
|-----------|-----------|--------------------|-----------  |
| BE | Zustand/Existenz | 8 | 899 |
| PERCEIVE | Wahrnehmung/Kognition | 4 | 218 |
| FEEL | Emotion | 6 | 204 |
| THINK | Denken | 6 | 769 |
| CHANGE | Veraenderung | 8 | 3.358 |
| CAUSE | Verursachung/Handlung | 14 | 3.739 |
| MOVE | Bewegung | 6 | 2.182 |
| COMMUNICATE | Kommunikation | 6 | 586 |
| TRANSFER | Uebertragung | 4 | 530 |
| SOCIAL | Soziale Handlung | 6 | 387 |

## Hoechstfrequente Sub-primitive (4-Bit-Codes)

| Sub-primitive | Code | Anz. Verben | Anteil | Beispiel |
|---------------|------|-------------|--------|----------|
| CHANGE-TRANSFORM | `0000` | 3.063 | 22,2% | "aendern", "werden" |
| CAUSE-USE | `0001` | 1.358 | 9,9% | "benutzen", "verwenden" |
| MOVE-DISPLACE | `0010` | 1.025 | 7,4% | "verschieben" |
| MOVE-GO | `0011` | 942 | 6,8% | "gehen" |

Die oberen 4 Sub-primitive machen 46,4% des Gesamten aus.

## Designphilosophie

### Grund fuer die Wahl der Huffman-Kodierung

- CHANGE-TRANSFORM (22,2%) hat eine ueberwaeltigende Haeufigkeit
- **Durchschnittlich 27% Bit-Einsparung** gegenueber fester Zuweisung
- Die oberen 4 sub_primitive machen 46,4% des Gesamten aus

### Grund fuer die Entfernung der Primitive-Bits

- Vorher: Primitive 3 Bit + Sub_primitive 4 Bit = 7 Bit fest
- Nachher: Direkte Sub_primitive-Kodierung = 4~8 Bit variabel
- **Maximale Einsparung von 4 Bit** bei haeufigen Verben

### Beibehaltung der semantischen Gruppierung

Die Primitive-Klassifikation wird fuer die menschliche Lesbarkeit und als Hinweis fuer semantisches Clustering beim LLM-Training beibehalten.
