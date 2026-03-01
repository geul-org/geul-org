---
title: "Qualificateurs semantiques"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "qualifier", "tense", "aspect"]
summary: "Qualificateurs semantiques du Verb Edge. 14 categories incluant evidentialite, mode, modalite, temps, aspect, politesse, polarite, intentionnalite, certitude et iterativite pour encoder les informations grammaticales et pragmatiques de la predication."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Le Verb Edge encode differents qualificateurs semantiques en plus du corps du verbe. Avec les [participants](../semantic-role/), ils constituent la signification complete de la predication.

## Liste des qualificateurs

| Categorie | Nom anglais | Type de donnees | Mappage de valeurs |
|-----------|-------------|-----------------|-------------------|
| Verbe principal | Core Verb | Identifiant | Identifiant absolu a alignement semantique |
| Liste des [participants](../semantic-role/) | Participant List | Liste de types composes | {entite, role grammatical, role semantique} |
| Locuteur | Speaker | Reference | Sujet de la predication (obligatoire) |
| Auditeur | Listener | Reference | Cible de la predication (Nullable) |
| Evidentialite | Evidentiality | Float [-1.0~1.0] | -1=inference, 0=experience directe, 1=ouie-dire |
| Mode | Mood | Float [-1.0~1.0] | -1=hypothetique, 0=declaratif, 1=imperatif |
| Modalite | Modality | Float [0.0~1.0] | Degre de volonte |
| Temps | Tense | Float [-1.0~1.0] | -1=passe, 0=present, 1=futur |
| Aspect | Aspect | Masque de bits | 1:progressif, 2:accompli, 4:resultatif |
| Politesse | Politeness | Float [-1.0~1.0] | -1=familier, 0=neutre, 1=honorifique |
| Polarite | Polarity | Float [-1.0~1.0] | -1=negatif, 0=indetermine, 1=positif |
| Intentionnalite | Volitionality | Float [-1.0~1.0] | -1=non intentionnel, 0=indetermine, 1=intentionnel |
| Certitude | Confidence | Float [-1.0~1.0] | -1=conjecture, 0=indetermine, 1=certain |
| Iterativite | Iterativity | Entier | 0=indetermine, 1=une fois, MAX=infini |

## Evidentialite (Evidentiality)

Exprime la source de l'information.

| Valeur | Signification | Exemple |
|--------|---------------|---------|
| -1.0 | Inference | "Il semble que ~" |
| 0.0 | Experience directe | "Il a fait ~" |
| 1.0 | Ouie-dire | "On dit que ~" |

## Mode (Mood)

Exprime la fonction de l'enonce.

| Valeur | Signification | Exemple |
|--------|---------------|---------|
| -1.0 | Hypothetique/Contrefactuel | "S'il avait fait ~" |
| 0.0 | Declaratif/Factuel | "C'est ~" |
| 1.0 | Imperatif/Requete | "Fais ~" |

## Temps (Tense)

Exprime la position temporelle de l'evenement.

| Valeur | Signification | Exemple |
|--------|---------------|---------|
| -1.0 | Passe | "Il a fait ~" |
| 0.0 | Present | "Il fait ~" |
| 1.0 | Futur | "Il fera ~" |

## Aspect

Exprime la structure temporelle interne de l'evenement par un masque de bits.

| Bits | Signification | Exemple |
|------|---------------|---------|
| 001 | Progressif | "Il est en train de faire ~" |
| 010 | Accompli | "Il a fait ~" |
| 100 | Resultatif | "Il a fini par ~" |
| 011 | Progressif+Accompli | "Il fait ~ depuis longtemps" |

## Politesse (Politeness)

Exprime la relation sociale entre locuteur et auditeur.

| Valeur | Signification | Exemple |
|--------|---------------|---------|
| -1.0 | Familier/Tutoiement | "Fais-le" |
| 0.0 | Neutre | "Faites-le" |
| 1.0 | Honorifique/Humble | "Auriez-vous l'amabilite de ~" |

## Principes de conception

- **Valeurs continues :** representation en Float plutot qu'en classes discretes pour permettre les gradations
- **Bipolaire :** la plupart des categories dans l'intervalle [-1.0, 1.0] pour exprimer les deux extremes
- **Indetermination :** 0.0 peut signifier "neutre" ou "indetermine" (Polarity, Volitionality, Confidence)
- **Combinaison :** melange de masques de bits (Aspect) et de Float pour exprimer des significations complexes
