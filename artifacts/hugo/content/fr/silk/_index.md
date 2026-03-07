---
title: "SILK — Index Symbolique pour la Connaissance des LLM"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["SILK", "search", "SIDX", "neuro-symbolic"]
summary: "Architecture de recherche neuro-symbolique basee sur des entiers 64 bits. Recherche 100 millions d'entites Wikidata en moins d'une seconde sans vector DB, graphes ANN ni modeles d'embedding."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Symbolic Index for LLM Knowledge** — architecture de recherche neuro-symbolique.

Recherche par entiers 64 bits. Ni vector DB, ni graphes ANN, ni modeles d'embedding.

<a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">Depot GitHub</a>

## Proposition centrale

La recherche n'etait pas un probleme difficile, mais un **symptome de donnees sans structure**.
Si l'on attribue une structure de 64 bits au moment de l'ecriture, le symptome disparait.

```python
results = index[(index & mask) == pattern]
```

100 millions d'entites Wikidata dans 1.3 Go de memoire, recherche en moins d'une seconde.
Avec Python (NumPy) seul, on bat les vector DBs optimisees en C++/Rust — une victoire de l'architecture.

## Pourquoi pas les embeddings vectoriels

Les embeddings vectoriels ecrasent la structure.

```
"Napoleon etait un chef militaire et empereur francais"
 → Un humain identifie immediatement : francais, militaire, XIXe siecle

Modele d'embedding :
 [0.234, -0.891, 0.445, ..., 0.112] (384 dimensions float)
 → Structure detruite. Impossible de lire si c'est person ou location.

Pour recuperer la structure detruite :
 Graphes ANN (HNSW, IVF-PQ), cross-encoders, re-rankers, filtres de metadonnees...
```

SILK preserve la structure.

```
SIDX : [Human / military / europe / early_modern]
 → La structure vit dans les bits. On peut la lire.
 → Rien a recuperer. Elle n'a jamais ete detruite.
```

La cle est l'inversion de l'ordre.

```
Classique : ecrire d'abord → structurer ensuite (indexation)
SILK :      structurer a l'ecriture → la recherche est gratuite
```

## Disposition des bits SIDX

SIDX suit la specification Entity Node de la [grammaire GEUL](/fr/grammar/).

```
[prefix 7 | mode 3 | entity_type 6 | attrs 48]
 MSB(63)                                  LSB(0)
```

| Champ | Bits | Taille | Description |
|-------|------|--------|-------------|
| prefix | 63-57 | 7 | En-tete de protocole GEUL (`0001001` fixe, ignore a la recherche) |
| mode | 56-54 | 3 | Mode de quantification/nombre (entite enregistree=0, defini, universel, existentiel, etc. 8 types) |
| entity_type | 53-48 | 6 | 64 types de niveau superieur (Human=0 ~ Election=62, non classe=63) |
| attrs | 47-0 | 48 | Encodage d'attributs par type (defini par codebook) |

Cible de recherche : entity_type 6 bits + attrs 48 bits = **54 bits**.
Le QID n'est pas inclus dans le SIDX ; il est stocke dans un tableau separe.

### attrs 48 bits — schema par type

```
Human(0):       subclass 5 | occupation 6 | country 8 | era 4 | decade 4 | gender 2 | notability 3 | ...
Star(12):       constellation 7 | spectral_type 4 | luminosity 3 | magnitude 4 | ra_zone 4 | dec_zone 4 | ...
Settlement(28): country 8 | admin_level 4 | admin_code 8 | lat_zone 4 | lon_zone 4 | population 4 | ...
Organization(44): country 8 | org_type 4 | legal_form 6 | industry 8 | era 4 | size 4 | ...
Film(51):       country 8 | year 7 | genre 6 | language 8 | color 2 | duration 4 | ...
```

Les dispositions d'attributs sont actuellement definies pour 5 types. Les autres n'encodent que entity_type.

## Architecture

SILK comporte deux pipelines : **encodage** (a l'ecriture) et **recherche** (a la consultation).
Tous deux suivent le meme principe : le symbolique capture la structure, le LLM traite le sens.

```
Pipeline d'encodage (a l'ecriture)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  Etiquetage  │──►│  Validation  │──►│  Encodage    │
│  LLM         │   │  VALID       │   │ par codebook │
│  Doc → JSON  │   │ Valeurs      │   │ JSON → SIDX  │
│ (classif.    │   │ valides du   │   │ (assemblage  │
│  semantique) │   │ codebook     │   │  de bits)    │
│              │   │ Hallucination│   │              │
│              │   │ → rejet      │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
  LLM etiquette     Code valide       Encodage par codebook
```

```
Pipeline de recherche (a la consultation)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Interpretat. │──►│ Filtre bit   │──►│  Jugement    │
│ de requete   │   │ AND          │   │  LLM         │
│ Lookup dans  │   │ NumPy SIMD   │   │ Seulement    │
│ le codebook  │   │ 100M → qlq   │   │ quelques     │
│ + assist.LLM │   │ dizaines     │   │ candidats    │
│              │   │              │   │ → reponse    │
└──────────────┘   └──────────────┘   └──────────────┘
  Extrac. semantique  Filtrage large   Jugement precis
```

Strategie cle : **filtrer largement sans rien perdre avec bit AND du SIDX**, puis **le LLM juge seulement les quelques candidats**.

```
Chacun fait ce qu'il fait le mieux :
 Humain : concevoir la structure (codebook)
 LLM :    classification semantique (etiquetage) + jugement semantique (recherche)
 Code :   validation des regles (VALID) + assemblage de bits
 CPU :    comparaison massive (NumPy SIMD)
```

### Encodage : etiquetage LLM → validation VALID

Le LLM lit le document et l'etiquette en JSON. VALID effectue une verification mecanique basee sur le codebook.
Les valeurs hors codebook, les violations de coherence inter-types et les violations de contraintes **ne peuvent physiquement pas entrer dans l'index**.

```
Etiquetage LLM : {"type": "Human", "occupation": "military", "country": "france"}
VALID :          occupation="military" ∈ codebook ? ✓  country="france" ∈ codebook ? ✓
                 Human avec champ constellation ? ✗ Rejete
Encodage :       codebook "military"→6 bits, "france"→8 bits → assemblage de bits → SIDX uint64
```

Le LLM peut halluciner. Mais puisque VALID joue le role de gardien, la possibilite de contamination de l'index est 0.
Seul le JSON ayant passe VALID est encode en entier SIDX 64 bits a partir du codebook.

### Recherche : filtrage large, le LLM affine

```
1. Extraction semantique     Lookup codebook 80% / assistance LLM 20%
2. Assemblage du masque       Deterministe — algorithme
3. Bit AND NumPy              Deterministe — scan complet de 100M en 20ms
4. Jugement final LLM         Quelques candidats seulement — jugement semantique precis
```

### 80% des recherches sont des requetes structurelles

```
"Napoleon"          → Q517 exact match. Bit AND. Fin.
"actualites Samsung" → org/company + doc_meta/news. Bit AND. Fin.
"sommet Biden-Xi"   → Q6279 ∩ Q15031 ∩ meeting. Intersection. Fin.
```

```
Requete structurelle (80%) : completee par bit AND de SILK. Sans LLM.
Requete semantique   (15%) : SILK reduit les candidats → LLM juge 5-10 elements.
Requete generative    (5%) : SILK localise les documents → LLM genere.
```

## Multi-SIDX

Un seul document/evenement peut avoir plusieurs SIDX.

```
Article "Reunion des dirigeants de Samsung, NVIDIA et Hyundai" :

SIDX[0]: [Human / business / east_asia ]  Lee Jae-yong
SIDX[1]: [Org   / company / east_asia ]  Samsung Electronics
SIDX[2]: [Human / business / n_america]  Jensen Huang
SIDX[3]: [Org   / company / n_america]  NVIDIA
SIDX[4]: [Human / business / east_asia ]  Chung Eui-sun
SIDX[5]: [Org   / company / east_asia ]  Hyundai Motor
SIDX[6]: [Event / meeting / east_asia ]  Reunion
```

Tous sont le meme SIDX 64 bits. Meme index. Meme recherche par bit AND.
Le champ entity_type distingue les entites (Human, Org) des evenements (Event).

## Structure de l'index

```python
sidx_array = np.array([...], dtype=np.uint64)  # 108.8M × 8B = 870MB
qid_array  = np.array([...], dtype=np.uint32)  # 108.8M × 4B = 435MB
# Total ~1.3 Go en memoire
```

```
Construction de l'index :
 Elasticsearch : tokenisation → analyse → index inverse → fusion de segments
 Pinecone :      embedding → graphe HNSW → clustering
 SILK :          sort
```

Aucune structure de donnees. Un seul tableau trie.

## Comparaison avec les vector DB

|  | SILK | Vector DB |
|------|------|-----------|
| Taille de l'index (1 Md d'entrees) | 12 To | 1.5 Po (125x) |
| Construction de l'index | sort | HNSW plusieurs jours |
| Demarrage a froid | Immediat a l'ouverture | Heures de construction du graphe |
| Scan partitionne | Possible (resultat identique) | Impossible (graphe casse) |
| Conditions composees | Intersection (exacte) | Comprime en 1 vecteur (approche) |
| Resultat | Exact (operation ensembliste) | Approche (classement par similarite) |
| Audit | JSON (boite blanche) | Impossible (boite noire) |

```
Bit AND est independant de l'ordre, sans etat, cumulable.
Vector DB : le graphe entier doit etre en memoire. Partitionner = detruire.
SILK :      fonctionne ou qu'on coupe. Partitionner = juste plus lent. Meme resultat.
```

## Pipeline d'audit

Les embeddings vectoriels sont une boite noire : impossible a auditer. SIDX est du JSON : auditable.

```
Phase 1 — Etiquetage par petit LLM      Llama 8B / GPT-4o-mini. Precision 85-90%.
Phase 2 — Verification mecanique VALID   Valeurs valides, coherence, contraintes. Cout 0 $.
Phase 3 — Audit par grand LLM           Seulement confidence=low. Precision 99%+.

VALID comme gardien : les hallucinations hors valeurs valides du codebook ne peuvent physiquement pas entrer dans l'index.
```

## Licence

MIT — <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">GitHub</a>
