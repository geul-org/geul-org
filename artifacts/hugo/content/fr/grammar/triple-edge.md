---
title: "Triple Edge"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "Type d'Edge exprimant les relations et proprietes sous la forme (Subject, Property, Object). Structure duale avec un mode de base a 4 mots et un mode etendu a 5 mots, optimisant les Top 63 proprietes a haute frequence."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge est un type d'Edge qui exprime les **relations et proprietes** sous la forme `(Subject, Property, Object)`.

## Conception en double mode

- **Mode de base (4 mots) :** PropCode 0~62 (Top 63 proprietes)
- **Mode etendu (5 mots) :** Si PropCode=63, couvre l'integralite des P-ID (16 bits a alignement semantique)

## Mode de base (4 mots = 64 bits)

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16 bits)
3rd WORD: Subject TID (16 bits)
4th WORD: Object TID (16 bits)
```

| Champ | Bits | Description |
|-------|------|-------------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62 : Top 63 proprietes, 63 : mode etendu |
| Edge TID | 16 | TID de cet Edge |
| Subject TID | 16 | TID de l'entite/noeud sujet |
| Object TID | 16 | TID de l'entite/noeud/quantite objet |

## Mode etendu (5 mots = 80 bits)

Si PropCode vaut 63, un P-ID de 16 bits est ajoute dans le 3e mot.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 bits)
3rd WORD: P-ID a alignement semantique (16 bits)
4th WORD: Subject TID (16 bits)
5th WORD: Object TID (16 bits)
```

## Top 63 proprietes (PropCode 0~62)

Proprietes selectionnees sur la base de la frequence d'utilisation dans Wikidata.

### Classification/Type (Code 0~7)

| Code | P-ID | Nom de propriete | Description |
|------|------|------------------|-------------|
| 0 | P31 | instance of | Instance de ~ |
| 1 | P279 | subclass of | Sous-classe de ~ |
| 2 | P361 | part of | Partie de ~ |
| 3 | P527 | has part | Contient ~ |
| 4 | P1552 | has quality | Propriete/caracteristique |
| 5 | P460 | same as | Identique |
| 6 | P1889 | different from | Different |
| 7 | P156 | followed by | Suivi par |

### Espace/Localisation (Code 8~15)

| Code | P-ID | Nom de propriete | Description |
|------|------|------------------|-------------|
| 8 | P17 | country | Pays |
| 9 | P131 | located in | Localisation (division administrative) |
| 10 | P276 | location | Localisation (lieu) |
| 11 | P625 | coordinate | Coordonnees |
| 12 | P30 | continent | Continent |
| 13 | P36 | capital | Capitale |
| 14 | P150 | contains | Contient (region) |
| 15 | P206 | located next to | Plan d'eau adjacent |

### Temps (Code 16~23)

| Code | P-ID | Nom de propriete | Description |
|------|------|------------------|-------------|
| 16 | P569 | date of birth | Date de naissance |
| 17 | P570 | date of death | Date de deces |
| 18 | P571 | inception | Date de fondation |
| 19 | P576 | dissolved | Date de dissolution |
| 20 | P577 | publication date | Date de publication |
| 21 | P580 | start time | Debut |
| 22 | P582 | end time | Fin |
| 23 | P585 | point in time | Moment precis |

### Informations personnelles (Code 24~31)

| Code | P-ID | Nom de propriete | Description |
|------|------|------------------|-------------|
| 24 | P19 | place of birth | Lieu de naissance |
| 25 | P20 | place of death | Lieu de deces |
| 26 | P21 | sex or gender | Sexe/genre |
| 27 | P27 | citizenship | Nationalite |
| 28 | P735 | given name | Prenom |
| 29 | P734 | family name | Nom de famille |
| 30 | P1559 | name in native language | Nom en langue maternelle |
| 31 | P742 | pseudonym | Pseudonyme |

### Relations/Affiliations (Code 32~39)

| Code | P-ID | Nom de propriete | Description |
|------|------|------------------|-------------|
| 32 | P22 | father | Pere |
| 33 | P25 | mother | Mere |
| 34 | P26 | spouse | Conjoint |
| 35 | P40 | child | Enfant |
| 36 | P3373 | sibling | Frere/soeur |
| 37 | P463 | member of | Membre de |
| 38 | P108 | employer | Employeur |
| 39 | P1027 | conferred by | Decerne par |

### Profession/Activite (Code 40~47)

| Code | P-ID | Nom de propriete | Description |
|------|------|------------------|-------------|
| 40 | P106 | occupation | Profession |
| 41 | P39 | position held | Fonction occupee |
| 42 | P69 | educated at | Formation |
| 43 | P101 | field of work | Domaine |
| 44 | P1344 | participant in | Participation (evenement) |
| 45 | P166 | award received | Recompense |
| 46 | P800 | notable work | Oeuvre notable |
| 47 | P1412 | languages spoken | Langues parlees |

### Medias/Identification (Code 48~55)

| Code | P-ID | Nom de propriete | Description |
|------|------|------------------|-------------|
| 48 | P18 | image | Image |
| 49 | P154 | logo | Logo |
| 50 | P41 | flag image | Drapeau |
| 51 | P373 | Commons category | Wikimedia |
| 52 | P856 | official website | Site officiel |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### Oeuvres/Creation (Code 56~62)

| Code | P-ID | Nom de propriete | Description |
|------|------|------------------|-------------|
| 56 | P50 | author | Auteur |
| 57 | P57 | director | Realisateur |
| 58 | P86 | composer | Compositeur |
| 59 | P175 | performer | Interprete |
| 60 | P136 | genre | Genre |
| 61 | P364 | original language | Langue originale |
| 62 | P123 | publisher | Editeur |

Le code 63 est reserve comme **indicateur du mode etendu**.

## Resume PropCode

```
┌─────────────────────────────────────────────┐
│  0~7:   Classification/Type (P31, P279, ...)│
│  8~15:  Espace/Localisation (P17, P131, ...)│
│  16~23: Temps (P569, P570, ...)             │
│  24~31: Info personnelles (P19, P20, ...)   │
│  32~39: Relations/Affiliations (P22, P25,..)│
│  40~47: Profession/Activite (P106, P39, ...)│
│  48~55: Medias/Identification (P18, P856,..)│
│  56~62: Oeuvres/Creation (P50, P57, ...)    │
├─────────────────────────────────────────────┤
│  63: Indicateur du mode etendu              │
└─────────────────────────────────────────────┘
```

## Exemples

### Mode de base : "Apple est une entreprise"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - Entreprise (Object)

Total: 4 mots
```

### Mode etendu : "La hauteur de la tour Eiffel est 330m"

```
P2048 (height) → Hors Top 63 → Mode etendu

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 a alignement semantique
  4th: [TID: 0x0030]              - Tour Eiffel (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

Total: 5 mots
```

## Analyse syntaxique

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # Mode de base (4 mots)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # Mode etendu (5 mots)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
