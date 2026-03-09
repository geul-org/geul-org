---
title: "Group Edge"
weight: 90
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "group", "set", "logic"]
summary: "Edge variabler Laenge, der mehrere Nodes in 7 Typen gruppiert: AND, OR, LIST, SET usw. Ein 13-Bit-Prefix und ein Terminierungsmarker (0x0000) ermoeglichen unbegrenzte Mitgliederzahl."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Group Edge ist ein Edge-Typ, der **mehrere Nodes zu einer Gruppe zusammenfasst**.

## Paketstruktur

```
1st WORD (16 Bit)
┌───────────────────────┬───────────┐
│        Prefix         │ GroupType │
│        13 Bit         │   3 Bit   │
└───────────────────────┴───────────┘
  [1100 000 111 000]       [TTT]

2nd WORD: Edge TID (16 Bit)
3rd+ WORD: Mitglieder-TIDs (variabel)
Letztes WORD: Terminierungsmarker (0x0000)
```

| Feld | Bits | Beschreibung |
|------|------|--------------|
| Prefix | 13 | `1100 000 111 000` |
| GroupType | 3 | Gruppenart (8) |
| Edge TID | 16 | Eindeutiger Identifikator dieses Edge |
| Mitglieder-TID | 16xN | Gruppenmitglieder-Referenzen |
| Terminierungsmarker | 16 | `0x0000` |

Minimum 4 Woerter (1 Mitglied), ueblicherweise 5~6 Woerter (2~3 Mitglieder), Maximum ohne Limit.

## GroupType (3 Bit = 8)

| Code | Typ | Bedeutung | Mitgliederzahl |
|------|-----|-----------|----------------|
| 000 | **AND** | Logische Konjunktion | 2+ |
| 001 | **OR** | Logische Disjunktion | 2+ |
| 010 | **XOR** | Exklusives Oder | 2+ |
| 011 | **LIST** | Geordnete Liste | 1+ |
| 100 | **SET** | Ungeordnete Menge | 1+ |
| 101 | **RANGE** | Bereich (Anfang~Ende) | Genau 2 |
| 110 | **PAIR** | Geordnetes Paar | Genau 2 |
| 111 | Erweiterung | Zukuenftige Erweiterung | - |

## GroupType im Detail

### AND

Alle Mitglieder nehmen gleichzeitig teil. Beispiel: "Hans **und** Anna **und** Peter hatten eine Besprechung"

### OR

Eines oder mehrere Mitglieder sind betroffen (inklusives Oder). Beispiel: "Bestellen Sie einen Kaffee **oder** einen Tee"

### XOR

Genau ein Mitglied ist betroffen (exklusives Oder). Beispiel: "Bestanden oder durchgefallen (eines von beiden)"

### LIST

Liste, bei der die Reihenfolge bedeutsam ist. Fuer Rankings und Sequenzen. Beispiel: "1. Hans, 2. Anna, 3. Peter"

### SET

Menge, bei der die Reihenfolge bedeutungslos ist. Nur die Mitgliedschaft zaehlt. Beispiel: "Teilnehmer: Hans, Anna, Peter"

### RANGE

Kontinuierlicher Bereich einschliesslich Zwischenwerte. Genau 2 Mitglieder (Anfang, Ende). Beispiel: "Von 1 bis 10"

### PAIR

Einfaches geordnetes Paar. Genau 2 Mitglieder. Fuer Koordinaten, Key-Value usw. Beispiel: "Koordinaten (3, 5)"

### RANGE vs PAIR

| Typ | Bedeutung | Zwischenwerte |
|-----|-----------|---------------|
| RANGE | Kontinuierlicher Bereich | Eingeschlossen |
| PAIR | Einfaches Paar | Keine |

`RANGE [1, 5]` → 1, 2, 3, 4, 5 (Zwischenwerte vorhanden). `PAIR [1, 5]` → (1, 5) (nur zwei Werte).

## Beispiele

### "Hans und Anna haben sich getroffen"

```
1. Entity Node: Hans (TID=0x0001)
2. Entity Node: Anna (TID=0x0002)
3. Group Edge: AND (TID=0x0100)
   1st: [1100 000 111 000] [000] = Prefix + AND
   2nd: [0x0100]                 = Edge TID
   3rd: [0x0001]                 = Hans
   4th: [0x0002]                 = Anna
   5th: [0x0000]                 = Terminierung

4. Verb Edge: meet
   Subject: 0x0100 (Gruppenreferenz)

Gesamt: 5 Woerter
```

### "Koordinaten (3, 5)"

```
1. Quantity Node: 3 (TID=0x0001)
2. Quantity Node: 5 (TID=0x0002)
3. Group Edge: PAIR (TID=0x0100)
   1st: [1100 000 111 000] [110] = Prefix + PAIR
   2nd: [0x0100]
   3rd: [0x0001]                 = Erster (x)
   4th: [0x0002]                 = Zweiter (y)
   5th: [0x0000]

Gesamt: 5 Woerter
```

## Einschraenkungen

| GroupType | Minimum | Maximum |
|-----------|---------|---------|
| AND / OR / XOR | 2 | unbegrenzt |
| LIST / SET | 1 | unbegrenzt |
| RANGE / PAIR | 2 | 2 |

- Mitglieder-TIDs muessen bereits deklarierte Nodes/Edges referenzieren
- Selbstreferenz (Zyklus) nicht erlaubt
- TID=0x0000 ist als Terminierungsmarker reserviert
