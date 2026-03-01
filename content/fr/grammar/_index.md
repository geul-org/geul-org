---
title: "Grammaire GEUL"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "SIDX", "specification"]
summary: "Specification du format de flux binaire base sur l'identifiant semantique global SIDX 64 bits. Principes de conception, systeme de Prefix, 9 types de paquets et regles d'encodage."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

La grammaire GEUL est un format de flux binaire base sur SIDX (Semantic-aligned Index), un identifiant semantique global de 64 bits.

## Principes de conception

1. **Extensibilite a long terme :** les bits reserves ne sont jamais detournes pour un usage temporaire. L'espace destine aux generations futures est preserve.
2. **Permanence semantique :** la signification d'un motif binaire une fois defini ne change jamais. Si une nouvelle signification est necessaire, un nouveau motif est alloue.
3. **Retrocompatibilite :** toute version de GEUL doit pouvoir interpreter integralement toutes les versions anterieures.
4. **Complexite lineaire :** le traitement symbolique de GEUL maintient une complexite O(n) par rapport a la longueur.

## Apercu de SIDX

SIDX est un identifiant semantique global de 64 bits. Il se ramifie sequentiellement a partir du bit de poids fort pour determiner le domaine.

| Prefix | Domaine | Ratio | Usage |
|--------|---------|-------|-------|
| `1` | Far Future | 50% | Reserve pour le futur lointain |
| `01` | Future | 25% | Reserve pour le futur proche |
| `001` | Standard | 12.5% | Domaine standard officiel |
| `000` | Free | 12.5% | Entierement libre |

`0001` est l'espace conventionnel utilise par cette proposition au sein du domaine libre (000).

## Systeme de Prefix

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
                │         └─ 000         (001 000)      → Domaine unifie 9 bits
                │
                └─ 0 (000): Free
                      └─ 0001: Proposal (miroir de Standard)
```

## Types de paquets

Le flux GEUL est compose de 9 types de paquets. Ils sont listes par ordre d'allocation des bits de Prefix (= ordre d'importance).

| Type | Prefix | Mots | Description |
|------|--------|------|-------------|
| Tiny Verb Edge | `0001 1` | 2 | Predications simples a haute frequence |
| [Verb Edge](../verb-edge/) | `0001 01` | 3~5 | 559 racines → 13 767 verbes WordNet |
| [Entity Node](../entity-node/) | `0001 001` | 4 | 64 EntityType, 48 bits d'attributs |
| [Triple Edge](../triple-edge/) | `0001 000 110` | 4~5 | Proprietes/relations, Top63 + extension |
| [Clause Edge](../clause-edge/) | `0001 000 101` | 4 | 16 relations discursives/logiques basees sur RST |
| [Event6 Edge](../event6-edge/) | `0001 000 100` | 3~8 | Evenement selon les 5W1H |
| [Context Edge](../context-edge/) | `0001 000 011` | 3 | 64 types de vision du monde/contexte |
| [Quantity Node](../quantity-node/) | `0001 000 010` | 4~7 | 64 codes d'unite, SI/devises/horodatage |
| [AST Edge](../ast-edge/) | `0001 000 001` | 3+ | 64 langages de programmation, 256 types de noeuds AST |
| [Group Edge](../group-edge/) | `0001 000 000 111` | 4+ | 7 types d'ensembles/groupes |

### Specifications communes

| Document | Description |
|----------|-------------|
| [Format de flux](../stream-format/) | Regles du format de flux, portee des TID, ordre des paquets |

## Regles d'encodage

| Element | Regle |
|---------|-------|
| Ordre des octets | Big Endian |
| Ordre des bits | MSB First (bit1 = MSB) |
| Taille de mot | 16 bits (2 octets) |

Tous les champs sont alignes sur des limites de mots de 16 bits, et la taille des paquets est toujours un multiple de mots (multiple de 2 octets). Le remplissage se fait avec 0x00 si necessaire.
