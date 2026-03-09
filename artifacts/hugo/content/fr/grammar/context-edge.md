---
title: "Context Edge"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "Edge leger de 3 mots exprimant 'dans quelle vision du monde/contexte cette affirmation est-elle vraie'. 64 types couvrant source, vision du monde, fiction et point de vue encodent les conditions de verite."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge exprime **"dans quelle vision du monde/contexte cette affirmation (Claim) est-elle vraie"**.

Il correspond au concept de mondes possibles de la logique modale : pour un meme sujet, des faits differents peuvent exister selon la vision du monde.

```
Context "Realite":          (Terre, age, 4.6 milliards d'annees)
Context "Jeune Terre":      (Terre, age, 6000 ans)
Context "Harry Potter":     (magie, exists, true)
```

## Structure du paquet (3 mots, 48 bits)

```
1st WORD (16 bits):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10 bits       │     6 bits      │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16 bits)
3rd WORD: Target TID (16 bits)
```

| Champ | Bits | Description |
|-------|------|-------------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=non specifie, 1~62=type, 63=etendu (reserve) |
| Context TID | 16 | Identifiant unique de ce Context |
| Target TID | 16 | TID cible ([Triple](../triple-edge/)/[Verb](../verb-edge/)/[Event6](../event6-edge/)/[Clause](../clause-edge/)) |

## Context Type (6 bits = 64)

### Source — Code 1~20

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 1 | SYSTEM | Generation automatique | Synchronisation Wikidata |
| 2 | USER | Saisie utilisateur | Redaction manuelle |
| 3 | DOCUMENT | Document general | PDF, Word |
| 4 | NEWS | Article de presse | Reuters, AP |
| 5 | ACADEMIC | Article academique | arXiv, Nature |
| 6 | GOVERNMENT | Agence gouvernementale/publique | SEC, INSEE |
| 7 | WIKI | Wikipedia/Wikidata | Q42, P31 |
| 8 | API | API externe | Finance, meteo |
| 9 | ORG | Communique d'organisation | IR d'entreprise |
| 10 | BOOK | Livre | Base ISBN |
| 11 | INTERVIEW | Interview/Temoignage | Citation directe |
| 12 | DATASET | Jeu de donnees | Kaggle |
| 13 | SOCIAL | Reseaux sociaux | Twitter |
| 14 | LEGAL | Droit/Jurisprudence | Decision de justice |
| 15 | ARCHIVE | Archive | archive.org |
| 16 | MULTIMEDIA | Video/Audio | YouTube |
| 17 | DATABASE | Base de donnees | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | Encyclopedie | Britannica |
| 19 | MANUAL | Manuel/Guide | Documentation technique |
| 20 | STANDARD | Document normatif | ISO, RFC |

### Derive/Inference — Code 21~30

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 21 | MODEL | Generation par modele IA | GPT, Claude |
| 22 | INFERENCE | Inference logique | Base de regles |
| 23 | AGGREGATION | Agregation/Synthese | Synthese multi-sources |
| 24 | CALCULATION | Resultat de calcul | Application de formule |
| 25 | TRANSLATION | Traduction | Original→Traduction |
| 26 | EXTRACTION | Extraction | NER, RE |
| 27 | CORRECTION | Correction | Rectification d'erreur |
| 28 | HEARSAY | Ouie-dire/Rumeur | Non confirme |
| 29 | ESTIMATION | Estimation | Valeur approximative |
| 30 | PREDICTION | Prediction | Perspective future |

### Vision du monde/Croyance — Code 31~45

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 31 | RELIGION | Vision religieuse | Protestantisme, Bouddhisme |
| 32 | PHILOSOPHY | Perspective philosophique | Existentialisme |
| 33 | SCIENCE | Consensus scientifique | Physique moderne |
| 34 | POLITICS | Perspective politique | Conservateur, Progressiste |
| 35 | CULTURE | Perspective culturelle | Orient, Occident |
| 36 | MYTHOLOGY | Systeme mythologique | Mythologie grecque |
| 37 | FOLKLORE | Contes/Traditions | Legendes locales |
| 38 | IDEOLOGY | Systeme ideologique | Capitalisme |
| 39 | THEORY | Theorie | Relativite |
| 40 | HYPOTHESIS | Hypothese | Avant verification |
| 41 | TRADITION | Tradition/Coutume | Tradition confuceenne |
| 42 | CONSENSUS | Consensus/These admise | These etablie |
| 43 | MAINSTREAM | Vue dominante | Opinion majoritaire |
| 44 | ALTERNATIVE | Vue alternative | Opinion minoritaire |
| 45 | FRINGE | Marginal/Heterodoxe | Pseudo-science |

### Fiction/Creation — Code 46~55

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 46 | NOVEL | Univers de roman | Le Seigneur des Anneaux |
| 47 | FILM | Univers de film | MCU |
| 48 | GAME | Univers de jeu | Zelda |
| 49 | COMICS | Univers de BD | DC Universe |
| 50 | ANIMATION | Univers d'animation | Studio Ghibli |
| 51 | DRAMA | Univers de serie | Game of Thrones |
| 52 | THEATER | Univers theatral | Hamlet |
| 53 | FANFIC | Creation derivee | Fanfiction |
| 54 | LEGEND | Legende | Roi Arthur |
| 55 | FAIRYTALE | Conte de fees | Cendrillon |

### Point de vue/Narrateur — Code 56~62

| Code | Type | Description | Exemple |
|------|------|-------------|---------|
| 56 | NARRATOR | Point de vue du narrateur | Narrateur omniscient |
| 57 | PROTAGONIST | Point de vue du protagoniste | Point de vue du heros |
| 58 | ANTAGONIST | Point de vue de l'antagoniste | Point de vue du mechant |
| 59 | AUTHOR | Intention de l'auteur | Commentaire de l'auteur |
| 60 | EXPERT | Avis d'expert | Opinion de chercheur |
| 61 | LAYMAN | Perception du grand public | Perception populaire |
| 62 | SATIRICAL | Satire/Ironie | Expression ironique |

Code 0 est UNSPECIFIED (non specifie), Code 63 est EXTENDED (etendu, reserve).

## Extension de metadonnees

Les informations complementaires sur le Context (source, fiabilite, nom de l'univers) sont exprimees via [Triple Edge](../triple-edge/).

```
(Context TID, P:source_entity, Reuters_Entity)  - Organisation source
(Context TID, P:confidence, 0.95)               - Fiabilite
(Context TID, P:universe_name, "Harry Potter")  - Nom de l'univers
(Context TID, P:perspective_holder, Villain_Entity) - Detenteur du point de vue
```

## Exemples

### Source : "Selon Reuters"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple a acquis Tesla"

Triple supplementaires:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### Fiction : "Univers Harry Potter"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "Poudlard est_une ecole"

Triple supplementaires:
  (0x0302, P:universe_name, "Harry Potter")
  (0x0302, P:author, J.K. Rowling)
```

### Inference IA : "Claude a deduit"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X cause Y"

Triple supplementaires:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## Justification de conception

- **Context Edge comme type separe** : la vision du monde est une meta-couche differente des Triple/Clause. Correspond au G (Graph) du RDF Quad.
- **6 bits pour le Context Type** : classification immediate sans Triple supplementaire. 62 types couvrent la plupart des cas.
- **Structure legere de 3 mots** : les connexions de contexte se produisent en masse, donc une taille minimale garantit l'efficacite de stockage.
