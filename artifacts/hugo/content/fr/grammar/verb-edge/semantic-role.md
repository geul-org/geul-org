---
title: "Roles des participants"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "16 Participant definissant les roles semantiques au sein d'un evenement. L'encodage 4 bits couvre les roles principaux tels que Agent, Theme et Recipient, ainsi que les roles complementaires comme Cause et Purpose."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Le **Participant** est un Edge qui specifie le **role semantique** d'une entite impliquee dans un evenement au sein d'une predication.

```
Event Node (verbe)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## Principes de conception

### Principe de separation

| Categorie | Appartenance | Exemple |
|-----------|-------------|---------|
| **Participant** | Niveau Event | Agent, Theme, Recipient |
| **Information pragmatique** | Niveau Context/Claim | Speaker, Listener, Evidentiality |

Speaker (locuteur), Listener (auditeur), Source (source d'information) ne sont pas des participants mais sont traites dans les **[qualificateurs semantiques](../qualifier/)** ou au niveau Context/Claim.

### Encodage

- **4 bits** (0x0~0xF), maximum 16 roles semantiques
- Correspondance de motifs possible par operations binaires SIMD

## Liste des roles semantiques (16)

### Participants principaux (Core Participants)

| ID | Code | Role | Definition | Exemple |
|----|------|------|------------|---------|
| 0x0 | **AGT** | Agent | Sujet executant intentionnellement une action | "**Jean** a frappe la balle" |
| 0x1 | **EXP** | Experiencer | Sujet eprouvant une emotion/cognition/perception | "**Marie** etait triste" |
| 0x2 | **THM** | Theme | Objet se deplacant ou dont l'etat est decrit | "Jean a frappe **la balle**" |
| 0x3 | **PAT** | Patient | Objet dont l'etat change suite a une action | "**La vitre** s'est brisee" |
| 0x4 | **RCP** | Recipient | Destinataire qui recoit quelque chose | "Il a donne un livre **a Marie**" |
| 0x5 | **BNF** | Beneficiary | Beneficiaire d'une action | "Il l'a fait **pour l'enfant**" |

### Outils et moyens (Instruments & Means)

| ID | Code | Role | Definition | Exemple |
|----|------|------|------------|---------|
| 0x6 | **INS** | Instrument | Outil utilise pour executer l'action | "Il a plante le clou **avec un marteau**" |
| 0x7 | **MNR** | Manner | Maniere dont l'action est executee | "Il a couru **rapidement**" |

### Spatial

| ID | Code | Role | Definition | Exemple |
|----|------|------|------------|---------|
| 0x8 | **LOC** | Location | Lieu ou se produit l'evenement | "Il vivait **a Paris**" |
| 0x9 | **SRC** | Source | Point de depart du deplacement | "Il est parti **de la maison**" |
| 0xA | **DST** | Destination | Point d'arrivee du deplacement | "Il est alle **a l'ecole**" |
| 0xB | **PTH** | Path | Trajet emprunte | "Il est passe **par le parc**" |

### Causal

| ID | Code | Role | Definition | Exemple |
|----|------|------|------------|---------|
| 0xC | **CAU** | Cause | Cause de l'evenement | "C'est annule **a cause de la pluie**" |
| 0xD | **PRP** | Purpose | But de l'action | "Il y est alle **pour faire du sport**" |

### Autres (Others)

| ID | Code | Role | Definition | Exemple |
|----|------|------|------------|---------|
| 0xE | **COM** | Comitative | Accompagnateur | "Il y est alle **avec un ami**" |
| 0xF | **ATR** | Attribute | Description d'etat/attribut | "Le ciel est **bleu**" |

## Structure du Participant Edge

```
PARTICIPANT Edge {
    source:     Event SIDX       // noeud verbe
    target:     Entity SIDX      // noeud entite
    role:       4-bit            // role semantique (0x0~0xF)
    gram_role:  2-bit (optional) // role grammatical (sujet/objet/complement)
    focus:      4-bit (optional) // degre d'emphase (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // reference qualificateur
}
```

| Champ | Bits | Description |
|-------|------|-------------|
| role | 4 | Role semantique (obligatoire) |
| gram_role | 2 | 0=non specifie, 1=sujet, 2=objet, 3=complement |
| focus | 4 | Importance informationnelle (0=arriere-plan, 15=emphase maximale) |
| quant_ref | 16 | TID de qualificateur "tous", "la plupart", etc. |

## Theme vs Patient

| Role | Changement d'etat | Exemple |
|------|-------------------|---------|
| Theme | Non (deplacement/description) | "Il a **lance** la balle" (la balle reste intacte) |
| Patient | Oui (affecte) | "Il a **casse** la vitre" (la vitre change d'etat) |

En pratique, on peut unifier sous Theme et distinguer par la semantique du verbe si necessaire.

## Exemples

### Phrase simple : "Jean a donne un livre a Marie"

```
Event: give.v.01
├─ PARTICIPANT (AGT) → Jean
├─ PARTICIPANT (THM) → livre
└─ PARTICIPANT (RCP) → Marie
```

### Phrase complexe : "A cause de la pluie, il a couru rapidement de la maison a l'ecole avec un ami"

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [locuteur]
├─ PARTICIPANT (CAU) → pluie
├─ PARTICIPANT (COM) → ami
├─ PARTICIPANT (SRC) → maison
├─ PARTICIPANT (DST) → ecole
└─ PARTICIPANT (MNR) → rapidement
```

### Description d'etat : "Le ciel est tres bleu"

```
Event: be.v.01
├─ PARTICIPANT (THM) → ciel
└─ PARTICIPANT (ATR) → bleu (focus=15)
```

## Normalisation actif/passif

| Forme de surface | Agent | Theme |
|------------------|-------|-------|
| "Apple a acquis Tesla" | Apple | Tesla |
| "Tesla a ete acquis par Apple" | Apple | Tesla |

La normalisation en un motif identique est effectuee lors de l'etape d'analyse.
