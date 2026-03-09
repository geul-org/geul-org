---
title: "Clause Edge"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "Edge fixe de 4 mots exprimant les relations logiques et discursives entre predications, evenements et relations. 16 types de relations basees sur RST encodent les relations causales, temporelles, contrastives et argumentatives."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge est un type d'Edge qui exprime les **relations logiques et discursives** entre predications ([Verb Edge](../verb-edge/)), evenements ([Event6 Edge](../event6-edge/)), relations ([Triple Edge](../triple-edge/)) ou d'autres Clause.

Il est concu sur la base des relations discursives de la RST (Rhetorical Structure Theory).

## Structure du paquet (4 mots, 64 bits)

```
1st WORD (16 bits):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │ Type rel.  │ Reserv.│
│       10 bits       │   4 bits   │ 2 bits │
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16 bits)
3rd WORD: TID 1 (16 bits) - premiere clause
4th WORD: TID 2 (16 bits) - deuxieme clause
```

| Champ | Bits | Description |
|-------|------|-------------|
| Prefix | 10 | `1100 000 010` |
| Type de relation | 4 | 16 relations RST |
| Reserve | 2 | Pour extension future |
| Edge TID | 16 | Identifiant unique de cet Edge |
| TID 1 | 16 | Reference a la premiere clause |
| TID 2 | 16 | Reference a la deuxieme clause |

## Types de relations (4 bits = 16)

### Relations causales

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 0000 | CAUSE | Cause→Effet | "Comme il pleuvait, je suis reste a la maison" |
| 0001 | RESULT | Effet←Cause | "Je suis reste a la maison, car il pleuvait" |
| 0010 | CONDITION | Condition→Consequence | "S'il pleut, je n'irai pas" |
| 0011 | PURPOSE | But | "On mange pour vivre" |

### Relations temporelles/sequentielles

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 0100 | SEQUENCE | Ordre chronologique | "J'ai mange puis dormi" |
| 0101 | PARALLEL | Simultanee/Parallele | "Il parlait en souriant" |

### Relations de contraste/concession

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 0110 | CONTRAST | Contraste | "A est grand et B est petit" |
| 0111 | CONCESSION | Concession | "Bien que ce fut difficile, il l'a fait" |

### Relations d'elaboration/arriere-plan

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 1000 | ELABORATION | Developpement | "Plus precisement..." |
| 1001 | BACKGROUND | Information de fond | "Pour reference, la situation etait..." |

### Relations argumentatives

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 1010 | EVIDENCE | Presentation de preuves | "Parce que... c'est pour cela" |
| 1011 | EVALUATION | Evaluation | "Ceci est bon/mauvais" |

### Autres relations

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 1100 | SOLUTIONHOOD | Probleme→Solution | "Le probleme est X, la solution est Y" |
| 1101 | ALTERNATIVE | Choix/Alternative | "Partir ou ne pas partir" |
| 1110 | MEANS | Moyen | "C'est ainsi qu'il y est parvenu" |
| 1111 | RESERVED | Reserve | Pour extension future |

## Regle d'ordre des TID

La direction est determinee par l'ordre des TID.

| Relation | TID 1 | TID 2 |
|----------|-------|-------|
| CAUSE | Cause | Effet |
| RESULT | Effet | Cause |
| CONDITION | Condition | Consequence |
| PURPOSE | Action | But |
| SEQUENCE | Precedent | Suivant |
| EVIDENCE | Preuve | Affirmation |
| ELABORATION | Essentiel | Developpement |

## Multinuclear vs Nucleus-Satellite

Selon la distinction RST.

### Nucleus-Satellite (asymetrique)

| Relation | TID 1 | TID 2 |
|----------|-------|-------|
| CAUSE | Cause (Satellite) | Effet (Nucleus) |
| CONDITION | Condition (Satellite) | Consequence (Nucleus) |
| EVIDENCE | Preuve (Satellite) | Affirmation (Nucleus) |
| ELABORATION | Essentiel (Nucleus) | Developpement (Satellite) |

### Multinuclear (symetrique)

| Relation | TID 1 | TID 2 |
|----------|-------|-------|
| SEQUENCE | Precedent | Suivant |
| PARALLEL | Premier | Deuxieme |
| CONTRAST | Premier | Deuxieme |
| ALTERNATIVE | Premier | Deuxieme |

Dans les relations symetriques, l'ordre des TID n'indique pas de priorite semantique.

## Exemples

### Causalite simple : "Comme il pleuvait, je suis reste a la maison"

```
Verb Edge E01: rain(pluie) | TID=0x0001
Verb Edge E02: stay(moi, maison) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + Reserve
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (cause: E01)
  4th: [0x0002]                    - TID 2 (effet: E02)
```

### Clause imbriquee : "Comme il pleuvait, je suis reste a la maison, et donc j'ai etudie"

```
Verb Edge E01: rain(pluie) | TID=0x0001
Verb Edge E02: stay(moi, maison) | TID=0x0002
Verb Edge E03: study(moi) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (reference au TID de Clause !)
  4th: [0x0003]                    - E03
```

## Justification de conception

### Pourquoi la RST

- Plus de 30 ans de recherche accumulee
- Validation sur divers corpus
- Outils d'analyse du discours existants
- Independant de la langue

### Pourquoi 4 bits (16)

- Couvre plus de 12 relations RST essentielles
- Marge d'extension conservee
- 3 bits (8) seraient insuffisants

### Pourquoi 4 mots simplifies

- Direction : determinee par l'ordre des TID (pas de bit supplementaire necessaire)
- Certitude : traitee comme metadonnees separees
- 2 bits reserves : pour extension future
