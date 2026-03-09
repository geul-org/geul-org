---
title: "Event6 Edge"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "Edge evenement a longueur variable exprimant les 5W1H (Who, What, Whom, When, Where, Why) d'un seul coup. La structure variable de 3 a 8 mots est realisee par un masque de bits Presence."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge est un type d'Edge evenement qui exprime les **5W1H** (Who, What, Whom, When, Where, Why) en une seule fois.

## Elements des 5W1H

| Element | Anglais | Bit | Signification | Reference TID |
|---------|---------|-----|---------------|---------------|
| Who | Agent | 0 | Acteur | [Entity Node](../entity-node/) |
| What | Action | 1 | Action | [Verb Edge](../verb-edge/) |
| Whom | Patient | 2 | Objet/Cible | [Entity Node](../entity-node/) |
| When | Time | 3 | Moment | Quantity/Entity |
| Where | Location | 4 | Lieu | [Entity Node](../entity-node/) |
| Why | Reason | 5 | Raison/But | [Clause Edge](../clause-edge/)/Entity |

## Structure du paquet

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: TID des elements (dans l'ordre de Presence)
```

### Masque de bits Presence (6 bits)

| Bit | Element | Si present |
|-----|---------|------------|
| 0 | Who | TID correspondant inclus |
| 1 | What | TID correspondant inclus |
| 2 | Whom | TID correspondant inclus |
| 3 | When | TID correspondant inclus |
| 4 | Where | TID correspondant inclus |
| 5 | Why | TID correspondant inclus |

Total mots = 2 (en-tete + Edge TID) + popcount(Presence). Plage de 3 a 8 mots (48 a 128 bits).

## Structures par mode

### Mode minimal (3 mots)

```
Exemple: "Il a plu" (What seul)

1st: [Prefix] + [000010]      - What uniquement
2nd: [Edge TID]
3rd: [What TID]               - Verb Edge "rain"
```

### Mode essentiel (5 mots)

Who + What + Whom. La configuration la plus frequente.

```
Exemple: "Jean a frappe Marie"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - Jean
4th: [What TID]               - Verb Edge "hit"
5th: [Whom TID]               - Marie
```

### Mode standard (6 mots)

```
Exemple: "Jean a rencontre Marie hier"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - Jean
4th: [What TID]               - Verb Edge "meet"
5th: [Whom TID]               - Marie
6th: [When TID]               - Hier
```

### Mode complet (8 mots)

```
Exemple: "Par amour, Jean a offert un cadeau a Marie hier a l'ecole"

1st: [Prefix] + [111111]      - Tous les elements
2nd: [Edge TID]
3rd: [Who TID]                - Jean
4th: [What TID]               - Verb Edge "give"
5th: [Whom TID]               - Marie
6th: [When TID]               - Hier
7th: [Where TID]              - Ecole
8th: [Why TID]                - Amour (raison)
```

## Details des elements

### What (Action)

What reference le TID d'un [Verb Edge](../verb-edge/). Les informations de temps, aspect et autres qualificateurs sont contenues dans ce Verb Edge.

### Why (Raison)

Les raisons simples sont exprimees par un TID Entity ("amour"), les raisons complexes par un TID [Clause Edge](../clause-edge/) ("parce qu'il pleuvait").

## Comparaison Event6 vs Verb Edge

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **Focus** | Predication/Action | Evenement complet |
| **Participants** | Structure Participant | TID des 5W1H |
| **Spatio-temporel** | Expression separee | When/Where integres |
| **Raison** | Clause separee | Why integre |
| **Mots** | 2~5 | 3~8 |
| **Usage** | Expression de predication | Stockage d'evenements |

**Guide de choix :** Verb Edge pour l'analyse de predications/phrases, Event6 Edge pour le stockage d'evenements/enregistrements, [Triple Edge](../triple-edge/) pour les faits simples.

## Exemples

### "Apple a acquis Tesla"

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

Total: 5 mots
```

### "Yi Sun-sin est mort au combat a la bataille de Noryang en 1598"

```
Who:   Yi Sun-sin       → Entity TID 0x0010
What:  die (mort)       → Verb Edge TID 0x0101
When:  1598             → Entity TID 0x0011
Where: Bataille Noryang  → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - Yi Sun-sin
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1598
  6th: [TID: 0x0012]              - Bataille de Noryang

Total: 6 mots
```

## Analyse syntaxique

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
