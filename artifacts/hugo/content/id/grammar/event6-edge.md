---
title: "Event6 Edge"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "Edge panjang variabel untuk menyatakan peristiwa berdasarkan prinsip 5W1H (Who, What, Whom, When, Where, Why). Bitmask Presence mewujudkan struktur variabel 3~8 word."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge adalah tipe Edge untuk menyatakan **5W1H** (Who, What, Whom, When, Where, Why) sekaligus dalam satu peristiwa.

## Elemen 5W1H

| Elemen | Inggris | Bit | Makna | Target referensi TID |
|--------|---------|-----|-------|----------------------|
| Who | Agent | 0 | Pelaku | [Entity Node](../entity-node/) |
| What | Action | 1 | Tindakan | [Verb Edge](../verb-edge/) |
| Whom | Patient | 2 | Objek/penderita | [Entity Node](../entity-node/) |
| When | Time | 3 | Waktu | Quantity/Entity |
| Where | Location | 4 | Tempat | [Entity Node](../entity-node/) |
| Why | Reason | 5 | Alasan/tujuan | [Clause Edge](../clause-edge/)/Entity |

## Struktur Paket

```
1st WORD (16 bit)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bit)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: TID elemen (sesuai urutan Presence)
```

### Bitmask Presence (6 bit)

| Bit | Elemen | Jika diset |
|-----|--------|------------|
| 0 | Who | TID disertakan |
| 1 | What | TID disertakan |
| 2 | Whom | TID disertakan |
| 3 | When | TID disertakan |
| 4 | Where | TID disertakan |
| 5 | Why | TID disertakan |

Total word = 2 (header + Edge TID) + popcount(Presence). Rentang: 3~8 word (48~128 bit).

## Struktur per Mode

### Mode Minimal (3 word)

```
Contoh: "Hujan turun" (hanya What)

1st: [Prefix] + [000010]      - hanya What
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### Mode Inti (5 word)

Who + What + Whom. Konfigurasi paling sering.

```
Contoh: "Budi memukul Andi"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - Budi
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - Andi
```

### Mode Standar (6 word)

```
Contoh: "Budi bertemu Sari kemarin"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - Budi
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - Sari
6th: [When TID]               - kemarin
```

### Mode Lengkap (8 word)

```
Contoh: "Budi karena cinta kemarin di sekolah memberikan hadiah kepada Sari"

1st: [Prefix] + [111111]      - semua elemen
2nd: [Edge TID]
3rd: [Who TID]                - Budi
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - Sari
6th: [When TID]               - kemarin
7th: [Where TID]              - sekolah
8th: [Why TID]                - cinta (alasan)
```

## Detail Elemen

### What (tindakan)

What merujuk TID [Verb Edge](../verb-edge/). Verb Edge tersebut berisi informasi tense, aspek, dan kualifikator lainnya.

### Why (alasan)

Alasan sederhana dinyatakan sebagai TID Entity ("cinta"), alasan kompleks sebagai TID [Clause Edge](../clause-edge/) ("karena hujan").

## Perbandingan Event6 vs Verb Edge

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **Fokus** | Predikat/tindakan | Peristiwa lengkap |
| **Partisipan** | Struktur Participant | TID 5W1H |
| **Ruang-waktu** | Ekspresi terpisah | When/Where bawaan |
| **Alasan** | Clause terpisah | Why bawaan |
| **Word** | 2~5 | 3~8 |
| **Kegunaan** | Ekspresi predikat | Penyimpanan peristiwa |

**Panduan pemilihan:** Untuk analisis predikat/kalimat gunakan Verb Edge, untuk penyimpanan peristiwa/catatan gunakan Event6 Edge, untuk fakta sederhana gunakan [Triple Edge](../triple-edge/).

## Contoh

### "Apple mengakuisisi Tesla"

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

Total: 5 word
```

### "Soekarno memproklamasikan kemerdekaan pada 1945 di Jakarta"

```
Who:   Soekarno         → Entity TID 0x0010
What:  proclaim          → Verb Edge TID 0x0101
When:  1945             → Entity TID 0x0011
Where: Jakarta          → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - Soekarno
  4th: [TID: 0x0101]              - proclaim
  5th: [TID: 0x0011]              - 1945
  6th: [TID: 0x0012]              - Jakarta

Total: 6 word
```

## Parsing

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
