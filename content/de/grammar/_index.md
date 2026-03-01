---
title: "GEUL-Grammatik"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "SIDX", "specification"]
summary: "Spezifikation des binaeren Streamformats basierend auf dem globalen semantischen Identifikator SIDX mit 64 Bit. Designprinzipien, Prefix-System, 9 Pakettypen und Kodierungsregeln."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Die GEUL-Grammatik ist ein binaeres Streamformat, das auf SIDX (Semantic-aligned Index) basiert, einem globalen semantischen Identifikator mit 64 Bit.

## Designprinzipien

1. **Langfristige Erweiterbarkeit:** Reservierte Bits werden niemals fuer temporaere Zwecke umgewidmet. Der Raum fuer zukuenftige Generationen wird bewahrt.
2. **Semantische Dauerhaftigkeit:** Die Bedeutung eines einmal definierten Bitmusters aendert sich nie. Wird eine neue Bedeutung benoetigt, wird ein neues Muster zugewiesen.
3. **Abwaertskompatibilitaet:** Jede Version von GEUL muss alle frueheren Versionen vollstaendig interpretieren koennen.
4. **Lineare Komplexitaet:** Die symbolische Verarbeitung von GEUL haelt O(n) bezueglich der Laenge ein.

## SIDX-Ueberblick

SIDX ist ein globaler semantischer Identifikator mit 64 Bit. Er verzweigt sequentiell vom hoechstwertigen Bit, um den Bereich zu bestimmen.

| Prefix | Bereich | Anteil | Verwendung |
|--------|---------|--------|------------|
| `1` | Far Future | 50% | Reserviert fuer die ferne Zukunft |
| `01` | Future | 25% | Reserviert fuer die nahe Zukunft |
| `001` | Standard | 12.5% | Offizieller Standardbereich |
| `000` | Free | 12.5% | Vollstaendig frei |

`0001` ist der konventionelle Raum, den dieser Vorschlag innerhalb des freien Bereichs (000) nutzt.

## Prefix-System

```
bit1
├─ 1: Far Future
│
└─ 0
    └─ bit2
        ├─ 1 (01): Future
        │
        └─ 0
            └─ bit3
                ├─ 1 (001): Standard
                │     └─ bit4~
                │         ├─ 1           (001 1)        → Tiny Verb Edge
                │         ├─ 01          (001 01)       → Verb Edge
                │         ├─ 001         (001 001)      → Entity Node
                │         └─ 000         (001 000)      → Vereinheitlichter 9-Bit-Bereich
                │
                └─ 0 (000): Free
                      └─ 0001: Proposal (Standard-Spiegelung)
```

## Pakettypen

Der GEUL-Stream besteht aus 9 Pakettypen. Sie werden in der Reihenfolge der Prefix-Bit-Zuweisung (= Wichtigkeit) aufgelistet.

| Typ | Prefix | Woerter | Beschreibung |
|-----|--------|---------|--------------|
| Tiny Verb Edge | `0001 1` | 2 | Hochfrequente einfache Praedikationen |
| [Verb Edge](../verb-edge/) | `0001 01` | 3~5 | 559 Wurzeln → 13.767 WordNet-Verben |
| [Entity Node](../entity-node/) | `0001 001` | 4 | 64 EntityType, 48-Bit-Attribute |
| [Triple Edge](../triple-edge/) | `0001 000 110` | 4~5 | Eigenschaften/Beziehungen, Top63 + Erweiterung |
| [Clause Edge](../clause-edge/) | `0001 000 101` | 4 | 16 RST-basierte Diskurs-/Logikbeziehungen |
| [Event6 Edge](../event6-edge/) | `0001 000 100` | 3~8 | Ereignis nach den 5W1H |
| [Context Edge](../context-edge/) | `0001 000 011` | 3 | 64 Weltanschauungs-/Kontexttypen |
| [Quantity Node](../quantity-node/) | `0001 000 010` | 4~7 | 64 Einheitencodes, SI/Waehrungen/Zeitstempel |
| [AST Edge](../ast-edge/) | `0001 000 001` | 3+ | 64 Programmiersprachen, 256 AST-Knotentypen |
| [Group Edge](../group-edge/) | `0001 000 000 111` | 4+ | 7 Mengen-/Gruppentypen |

### Gemeinsame Spezifikationen

| Dokument | Beschreibung |
|----------|--------------|
| [Streamformat](../stream-format/) | Streamformatregeln, TID-Scoping, Paketreihenfolge |

## Kodierungsregeln

| Element | Regel |
|---------|-------|
| Byte-Reihenfolge | Big Endian |
| Bit-Reihenfolge | MSB First (bit1 = MSB) |
| Wortgroesse | 16 Bit (2 Bytes) |

Alle Felder werden an 16-Bit-Wortgrenzen ausgerichtet, und die Paketgroesse ist immer ein Vielfaches von Woertern (Vielfaches von 2 Bytes). Bei Bedarf wird mit 0x00 aufgefuellt.
