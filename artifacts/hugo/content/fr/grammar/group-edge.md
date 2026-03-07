---
title: "Group Edge"
weight: 90
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "group", "set", "logic"]
summary: "Edge a longueur variable regroupant plusieurs Nodes en 7 types : AND, OR, LIST, SET, etc. Un Prefix de 13 bits et un marqueur de fin (0x0000) permettent un nombre illimite de membres."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Group Edge est un type d'Edge qui **regroupe plusieurs Nodes en un seul groupe**.

## Structure du paquet

```
1st WORD (16 bits)
┌───────────────────────┬───────────┐
│        Prefix         │ GroupType │
│        13 bits        │   3 bits  │
└───────────────────────┴───────────┘
  [1100 000 111 000]       [TTT]

2nd WORD: Edge TID (16 bits)
3rd+ WORD: TID des membres (variable)
Dernier WORD: Marqueur de fin (0x0000)
```

| Champ | Bits | Description |
|-------|------|-------------|
| Prefix | 13 | `1100 000 111 000` |
| GroupType | 3 | Type de groupe (8) |
| Edge TID | 16 | Identifiant unique de cet Edge |
| TID membres | 16xN | References aux membres du groupe |
| Marqueur de fin | 16 | `0x0000` |

Minimum 4 mots (1 membre), generalement 5~6 mots (2~3 membres), maximum sans limite.

## GroupType (3 bits = 8)

| Code | Type | Signification | Nb membres |
|------|------|---------------|------------|
| 000 | **AND** | Conjonction logique | 2+ |
| 001 | **OR** | Disjonction logique | 2+ |
| 010 | **XOR** | Choix exclusif | 2+ |
| 011 | **LIST** | Liste ordonnee | 1+ |
| 100 | **SET** | Ensemble non ordonne | 1+ |
| 101 | **RANGE** | Plage (debut~fin) | Exactement 2 |
| 110 | **PAIR** | Paire ordonnee | Exactement 2 |
| 111 | Extension | Extension future | - |

## Details des GroupType

### AND

Tous les membres participent simultanement. Exemple : "Jean **et** Marie **et** Pierre ont eu une reunion"

### OR

Un ou plusieurs membres sont concernes (ou inclusif). Exemple : "Commandez un cafe **ou** un the"

### XOR

Exactement un seul membre est concerne (ou exclusif). Exemple : "Reussite ou echec (l'un ou l'autre)"

### LIST

Liste dont l'ordre est significatif. Utilisee pour les classements et sequences. Exemple : "1er Jean, 2e Marie, 3e Pierre"

### SET

Ensemble dont l'ordre est sans importance. Seule l'appartenance compte. Exemple : "Participants : Jean, Marie, Pierre"

### RANGE

Plage continue incluant les valeurs intermediaires. Exactement 2 membres (debut, fin). Exemple : "De 1 a 10"

### PAIR

Simple paire ordonnee. Exactement 2 membres. Utilisee pour les coordonnees, key-value, etc. Exemple : "Coordonnees (3, 5)"

### RANGE vs PAIR

| Type | Signification | Valeurs intermediaires |
|------|---------------|------------------------|
| RANGE | Plage continue | Incluses |
| PAIR | Simple paire | Aucune |

`RANGE [1, 5]` → 1, 2, 3, 4, 5 (valeurs intermediaires). `PAIR [1, 5]` → (1, 5) (deux valeurs seulement).

## Exemples

### "Jean et Marie se sont rencontres"

```
1. Entity Node: Jean (TID=0x0001)
2. Entity Node: Marie (TID=0x0002)
3. Group Edge: AND (TID=0x0100)
   1st: [1100 000 111 000] [000] = Prefix + AND
   2nd: [0x0100]                 = Edge TID
   3rd: [0x0001]                 = Jean
   4th: [0x0002]                 = Marie
   5th: [0x0000]                 = Fin

4. Verb Edge: meet
   Subject: 0x0100 (reference au groupe)

Total: 5 mots
```

### "Coordonnees (3, 5)"

```
1. Quantity Node: 3 (TID=0x0001)
2. Quantity Node: 5 (TID=0x0002)
3. Group Edge: PAIR (TID=0x0100)
   1st: [1100 000 111 000] [110] = Prefix + PAIR
   2nd: [0x0100]
   3rd: [0x0001]                 = Premier (x)
   4th: [0x0002]                 = Deuxieme (y)
   5th: [0x0000]

Total: 5 mots
```

## Contraintes

| GroupType | Minimum | Maximum |
|-----------|---------|---------|
| AND / OR / XOR | 2 | infini |
| LIST / SET | 1 | infini |
| RANGE / PAIR | 2 | 2 |

- Les TID des membres doivent referencer des Nodes/Edges deja declares
- Auto-reference (cycle) interdite
- TID=0x0000 est reserve comme marqueur de fin
