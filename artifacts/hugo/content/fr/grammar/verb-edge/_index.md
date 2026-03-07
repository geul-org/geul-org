---
title: "Verb Edge"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "huffman", "WordNet"]
summary: "Classification de 13 767 verbes WordNet en 10 Primitive puis 68 Sub-primitive, avec generation d'un codebook 16 bits par codage de Huffman. Compression moyenne de 2,16 mots via 3 types de paquets Tiny (2 mots), Short (3 mots) et Full (5 mots)."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge est le type d'Edge qui represente les predications et actions dans le flux GEUL. Il classifie 13 767 verbes WordNet en 10 Primitive → 68 Sub-primitive et genere un codebook 16 bits par **codage de Huffman au niveau Sub-primitive**.

## Sous-documents

| Document | Description |
|----------|-------------|
| [Roles des participants](./semantic-role/) | 16 Semantic Role (encodage 4 bits) |
| [Qualificateurs semantiques](./qualifier/) | Evidentialite, mode, temps, aspect, etc. — 14 qualificateurs |

## Hierarchie des verbes

```
10 Primitive (categories semantiques superieures)
 ├── BE          ├── PERCEIVE    ├── FEEL
 ├── THINK       ├── CHANGE      ├── CAUSE
 ├── MOVE        ├── COMMUNICATE ├── TRANSFER
 └── SOCIAL
  → 68 Sub-primitive (classification intermediaire)
    → 559 Root Verb (verbes racines)
      → 13,767 Leaf Verb (tous les verbes WordNet)
```

- Les Primitive (categories principales) ne servent qu'au **regroupement conceptuel** sans allocation de bits
- Les 68 Sub-primitive (sous-categories) recoivent un **code a longueur variable base sur la frequence**
- Plus un groupe de verbes est frequent, plus son code est court (4 a 8 bits)

## Types de paquets Verb Edge

Les 3 types de paquets Tiny/Short/Full partagent tous le meme **corps de verbe 16 bits** dans le dernier mot.

| | Tiny | Short | Full |
|--|------|-------|------|
| Mots | 2 (32 bit) | 3 (48 bit) | 5 (80 bit) |
| Participants | 16 motifs | 512 motifs | 19 bit drapeaux |
| Qualificateurs | 7 motifs | 3 640 motifs | 27 bit |
| Corps du verbe | 16 bit | 16 bit | 16 bit |
| Ratio estime | 90% | 7% | 3% |

**Taille moyenne de paquet :** 0.9x2 + 0.07x3 + 0.03x5 = **2,16 mots**

### Tiny Verb Edge (2 mots)

```
1st WORD:  [Prefix 5bit] [Target×motif 11bit]
2nd WORD:  [Corps du verbe 16bit]
```

- Target x motif : 18 Target x 113 motifs = 2 034 combinaisons
- 16 motifs participants x 7 motifs qualificateurs = 112 + 1 reserve = 113
- Couverture ~90%

### Short Verb Edge (3 mots)

```
1st WORD:  [Prefix 6bit] [Type 1bit=0] [motif participants 9bit]
2nd WORD:  [Target×motif qualificateurs 16bit]
3rd WORD:  [Corps du verbe 16bit]
```

### Full Verb Edge (5 mots)

```
1st WORD:  [Prefix 6bit] [Type 1bit=1] [Target participant 5bit] [drapeaux participants 4bit]
2nd+3rd:   [drapeaux participants 15bit] [qualificateurs 17bit]
4th WORD:  [qualificateurs 10bit] [reserve 6bit]
5th WORD:  [Corps du verbe 16bit]
```

## Corps du verbe 16 bits

```
┌─────────────────────────┬────────────────────────────┐
│   sub_primitive code    │     DFS index dans l'arbre │
│   (4-8 bits, Huffman)   │     (8-12 bits)            │
└─────────────────────────┴────────────────────────────┘
```

- **sub_primitive code :** 4 a 8 bits variable (code de Huffman)
- **DFS index :** identification du verbe individuel au sein du sub_primitive

### Distribution des longueurs de code

| Longueur du code | Nombre | Total verbes | Ratio |
|------------------|--------|--------------|-------|
| 4 bits | 4 | 6 388 | 46.4% |
| 5 bits | 4 | 2 479 | 18.0% |
| 6 bits | 8 | 2 321 | 16.9% |
| 7 bits | 16 | 1 786 | 13.0% |
| 8 bits | 36 | 813 | 5.9% |

### Calcul des bits DFS index

| Nb verbes sub_primitive | Bits necessaires |
|------------------------|------------------|
| 1~256 | 8 bits |
| 257~512 | 9 bits |
| 513~1024 | 10 bits |
| 1025~2048 | 11 bits |
| 2049~4096 | 12 bits |

Exemple : CHANGE-TRANSFORM = `0000` (4 bits) + 3 063 verbes (12 bits) = 16 bits.

### Longueur moyenne de code

```
Moyenne = Sigma(longueur_code x nb_verbes) / total_verbes ≈ 5,14 bits
```

| Methode | Bits moyens |
|---------|-------------|
| Fixe 7 bits (68) | 7.00 |
| Codage de Huffman | 5.14 |
| **Economie** | **1,86 bits (27%)** |

## Primitive — categories principales (10)

| Primitive | Signification | Nb Sub-primitive | Nb verbes |
|-----------|---------------|------------------|-----------|
| BE | Etat/Existence | 8 | 899 |
| PERCEIVE | Perception/Cognition | 4 | 218 |
| FEEL | Emotion | 6 | 204 |
| THINK | Pensee | 6 | 769 |
| CHANGE | Changement | 8 | 3 358 |
| CAUSE | Causation/Action | 14 | 3 739 |
| MOVE | Mouvement | 6 | 2 182 |
| COMMUNICATE | Communication | 6 | 586 |
| TRANSFER | Transfert | 4 | 530 |
| SOCIAL | Action sociale | 6 | 387 |

## Sub-primitive les plus frequents (codes 4 bits)

| Sub-primitive | Code | Nb verbes | Ratio | Exemple |
|---------------|------|-----------|-------|---------|
| CHANGE-TRANSFORM | `0000` | 3 063 | 22.2% | "changer", "devenir" |
| CAUSE-USE | `0001` | 1 358 | 9.9% | "utiliser", "employer" |
| MOVE-DISPLACE | `0010` | 1 025 | 7.4% | "deplacer" |
| MOVE-GO | `0011` | 942 | 6.8% | "aller" |

Les 4 premiers Sub-primitive representent 46,4% du total.

## Philosophie de conception

### Raison du choix du codage de Huffman

- CHANGE-TRANSFORM (22,2%) a une frequence ecrasante
- **Reduction moyenne de 27% des bits** par rapport a une allocation fixe
- Les 4 premiers sub_primitive representent 46,4% du total

### Raison de la suppression des bits Primitive

- Avant : Primitive 3 bits + Sub_primitive 4 bits = 7 bits fixes
- Apres : Codage direct Sub_primitive = 4~8 bits variables
- **Economie maximale de 4 bits** pour les verbes frequents

### Maintien du regroupement semantique

La classification Primitive est maintenue pour la lisibilite humaine et comme indice de clustering semantique lors de l'apprentissage LLM.
