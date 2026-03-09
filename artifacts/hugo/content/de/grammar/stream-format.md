---
title: "Streamformat"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "Der GEUL-Stream ist eine Paketsequenz, die mit Meta Nodes beginnt und endet. Definiert TID-Scoping, Vorwaertsreferenzen und Paketreihenfolgeregeln."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Der GEUL-Stream ist eine **Paketsequenz, die mit Meta Nodes beginnt und endet**, und bildet ein vollstaendiges GEUL-Dokument.

## Kerneigenschaften

- **Explizite Grenzen:** STREAM_START / STREAM_END (Meta Node)
- **TID-Scope:** Nur innerhalb des Streams gueltig
- **Vorwaertsreferenz:** Nur bereits deklarierte TIDs koennen referenziert werden
- **Big Endian:** Network Byte Order

## Streamstruktur

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← Pflicht (Meta Node)
│          (TID-Breite-Deklaration)   │     0xC000 (16-Bit-TID)
├─────────────────────────────────────┤
│          Metadaten (optional)       │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          Inhaltspakete              │
│          - Entity Node              │
│          - Quantity Node            │
│          - Verb Edge                │
│          - Triple Edge              │
│          - Event6 Edge              │
│          - Clause Edge              │
│          - Context Edge             │
│          - Group Edge               │
│          - Faber Edge               │
├─────────────────────────────────────┤
│          STREAM_END                 │  ← Optional (empfohlen)
└─────────────────────────────────────┘
```

Der minimale Stream ist `STREAM_START` (1 Wort) + `STREAM_END` (1 Wort) = 2 Woerter (4 Bytes), und auch ein leerer Stream ist gueltig.

## TID-Zuweisungsprinzipien

| Regel | Beschreibung |
|-------|--------------|
| **Pflicht** | Jeder Edge/Node im Stream besitzt eine TID |
| **Eindeutigkeit** | Die TID ist innerhalb des Streams eindeutig |
| **Scope** | Die TID ist nur innerhalb ihres Streams gueltig |
| **Vorwaerts** | Nur zum Referenzierungszeitpunkt bereits deklarierte TIDs koennen referenziert werden |

### TID-Position

| Typ | TID-Position | Referenz-Position |
|-----|-------------|-------------------|
| **Meta Node** | Keine | Keine |
| **Entity Node** | Letztes Wort | Keine |
| **Quantity Node** | Letztes Wort | Keine |
| **Tiny Verb Edge** | Keine | Keine (inline) |
| **Verb Edge** | Header-Bereich | Nach Payload |
| **Triple Edge** | Header-Bereich | Nach Payload |
| **Event6 Edge** | Header-Bereich | Nach Payload |
| **Clause Edge** | Header-Bereich | Nach Payload |
| **Context Edge** | Header-Bereich | Nach Payload |
| **Group Edge** | 2. Wort | 3. Wort ff. |

**Nodes** definieren nur sich selbst, daher steht die TID am Ende; **Edges** referenzieren andere TIDs, daher steht die TID vor den Referenzen.

### Reservierte TIDs

| TID | Verwendung |
|-----|------------|
| 0x0000 | **Terminierungsmarker** ([Group Edge](../group-edge/) usw.) |
| 0xFFFF | Reserviert (16-Bit-Basis) |

## Paketreihenfolgeregeln

### Deklarations-Referenz-Reihenfolge

```
Korrekt:
  [Entity: Hans, TID=0x0001]
  [Entity: Anna, TID=0x0002]
  [Verb Edge: treffen, Subject=0x0001, Object=0x0002]

Falsch:
  [Verb Edge: treffen, Subject=0x0001, Object=0x0002]  ← 0x0001 nicht deklariert
  [Entity: Hans, TID=0x0001]
  [Entity: Anna, TID=0x0002]
```

### Empfohlene Reihenfolge

```
1. STREAM_START
2. Metadaten (VERSION, CREATED_AT, CREATOR)
3. Entity Nodes (Entitaetsdeklarationen)
4. Quantity Nodes (Mengen/Literale)
5. Group Edges (Gruppendefinitionen)
6. Tiny Verb Edges (Inline-Praedikationen)
7. Verb Edges (allgemeine Praedikationen)
8. Triple Edges (Eigenschaften/Beziehungen)
9. Event6 Edges (Ereignisse)
10. Clause Edges (Diskursbeziehungen)
11. Context Edges (Kontexte)
12. Faber Edges (Code/AST)
13. STREAM_END
```

Dies ist nur eine empfohlene Reihenfolge; die Anordnung ist frei, solange die Deklarations-Referenz-Regel eingehalten wird.

### Verbot zirkulaerer Referenzen

Zirkulaere Referenzen der Form A → B → A sind nicht moeglich. Wenn eine zirkulaere Beziehung benoetigt wird, wird sie durch separate Edges ausgedrueckt.

```
Moeglich:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## Stream-Beispiele

### "Hans hat Anna getroffen"

```
1. STREAM_START (TID 16 Bit)
   0xC0 0x00

2. Entity: Hans (TID=0x0001)
   [Entity-Paket...] 0x00 0x01

3. Entity: Anna (TID=0x0002)
   [Entity-Paket...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "Hans und Anna haben sich in der Schule getroffen"

```
1. STREAM_START
   0xC0 0x00

2. Entity: Hans (TID=0x0001)
3. Entity: Anna (TID=0x0002)
4. Entity: Schule (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Mitglieder: 0x0001, 0x0002, 0x0000 (Terminierung)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (Gruppe)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## Stream-Validierung

### Pflichtvalidierungen

| Element | Validierung |
|---------|-------------|
| Start | Beginnt er mit STREAM_START? |
| TID-Eindeutigkeit | Gibt es doppelte TIDs? |
| Referenzgueltigkeit | Sind alle referenzierten TIDs deklariert? |
| Vorwaerts | Sind TIDs vor der Referenzierung deklariert? |

### Validierungscode

```python
def validate_stream(packets: list) -> dict:
    """Stream-Validierung"""
    errors = []
    declared_tids = set()

    # Start-Validierung
    if not packets or packets[0].type != "STREAM_START":
        errors.append("Stream beginnt nicht mit STREAM_START")

    for packet in packets:
        # TID-Eindeutigkeitspruefung
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"Doppelte TID: {packet.tid}")
            declared_tids.add(packet.tid)

        # Referenzgueltigkeitspruefung
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"Referenz auf nicht deklarierte TID: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## Mehrere Streams

Jeder Stream ist unabhaengig und der TID-Scope ist pro Stream getrennt. TID=0x0001 in Stream A und TID=0x0001 in Stream B bezeichnen unterschiedliche Entitaeten.

Stream-uebergreifende Referenzen (Cross-reference) werden derzeit nicht unterstuetzt und koennen kuenftig durch die Einfuehrung von Stream-IDs und Import/Export-Mechanismen erweitert werden.
