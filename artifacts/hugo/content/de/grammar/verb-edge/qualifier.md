---
title: "Semantische Qualifikatoren"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "qualifier", "tense", "aspect"]
summary: "Semantische Qualifikatoren des Verb Edge. 14 Kategorien umfassen Evidentialitaet, Modus, Modalitaet, Tempus, Aspekt, Hoeflichkeit, Polaritaet, Intentionalitaet, Sicherheit und Iterativitaet zur Kodierung grammatischer und pragmatischer Informationen der Praedikation."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Der Verb Edge kodiert neben dem Verbkoerper verschiedene semantische Qualifikatoren. Zusammen mit den [Teilnehmern](../semantic-role/) bilden sie die vollstaendige Bedeutung der Praedikation.

## Liste der Qualifikatoren

| Kategorie | Englischer Name | Datentyp | Wertzuordnung |
|-----------|----------------|----------|---------------|
| Kernverb | Core Verb | Identifikator | Semantisch ausgerichteter absoluter Identifikator |
| [Teilnehmer](../semantic-role/)-Liste | Participant List | Zusammengesetzte Typliste | {Entitaet, grammatische Rolle, semantische Rolle} |
| Sprecher | Speaker | Referenz | Subjekt der Praedikation (Pflicht) |
| Hoerer | Listener | Referenz | Ziel der Praedikation (Nullable) |
| Evidentialitaet | Evidentiality | Float [-1.0~1.0] | -1=Inferenz, 0=direkte Erfahrung, 1=Hoerensagen |
| Modus | Mood | Float [-1.0~1.0] | -1=hypothetisch, 0=deklarativ, 1=imperativ |
| Modalitaet | Modality | Float [0.0~1.0] | Willensgrad |
| Tempus | Tense | Float [-1.0~1.0] | -1=Vergangenheit, 0=Gegenwart, 1=Zukunft |
| Aspekt | Aspect | Bitmaske | 1:progressiv, 2:perfektiv, 4:resultativ |
| Hoeflichkeit | Politeness | Float [-1.0~1.0] | -1=informell, 0=neutral, 1=ehrerbietig |
| Polaritaet | Polarity | Float [-1.0~1.0] | -1=negativ, 0=unbestimmt, 1=positiv |
| Intentionalitaet | Volitionality | Float [-1.0~1.0] | -1=unbeabsichtigt, 0=unbestimmt, 1=beabsichtigt |
| Sicherheit | Confidence | Float [-1.0~1.0] | -1=Vermutung, 0=unbestimmt, 1=sicher |
| Iterativitaet | Iterativity | Ganzzahl | 0=unbestimmt, 1=einmal, MAX=unendlich |

## Evidentialitaet (Evidentiality)

Drueckt die Quelle der Information aus.

| Wert | Bedeutung | Beispiel |
|------|-----------|----------|
| -1.0 | Inferenz | "Es scheint, dass ~" |
| 0.0 | Direkte Erfahrung | "Er hat ~ gemacht" |
| 1.0 | Hoerensagen | "Man sagt, dass ~" |

## Modus (Mood)

Drueckt die Funktion der Aeusserung aus.

| Wert | Bedeutung | Beispiel |
|------|-----------|----------|
| -1.0 | Hypothetisch/Kontrafaktisch | "Wenn er ~ getan haette" |
| 0.0 | Deklarativ/Faktisch | "Es ist ~" |
| 1.0 | Imperativ/Aufforderung | "Mach ~" |

## Tempus (Tense)

Drueckt die zeitliche Position des Ereignisses aus.

| Wert | Bedeutung | Beispiel |
|------|-----------|----------|
| -1.0 | Vergangenheit | "Er hat ~ gemacht" |
| 0.0 | Gegenwart | "Er macht ~" |
| 1.0 | Zukunft | "Er wird ~ machen" |

## Aspekt (Aspect)

Drueckt die interne Zeitstruktur des Ereignisses durch eine Bitmaske aus.

| Bits | Bedeutung | Beispiel |
|------|-----------|----------|
| 001 | Progressiv | "Er ist dabei, ~ zu machen" |
| 010 | Perfektiv | "Er hat ~ gemacht" |
| 100 | Resultativ | "Er hat ~ fertiggestellt" |
| 011 | Progressiv+Perfektiv | "Er macht ~ schon seit langem" |

## Hoeflichkeit (Politeness)

Drueckt die soziale Beziehung zwischen Sprecher und Hoerer aus.

| Wert | Bedeutung | Beispiel |
|------|-----------|----------|
| -1.0 | Informell/Duzen | "Mach das" |
| 0.0 | Neutral | "Machen Sie das" |
| 1.0 | Ehrerbietig/Bescheiden | "Wuerden Sie so freundlich sein, ~" |

## Designprinzipien

- **Kontinuierliche Werte:** Darstellung als Float statt diskreter Klassen fuer Gradationsmoeglichkeiten
- **Bipolar:** Die meisten Kategorien im Bereich [-1.0, 1.0] zur Darstellung beider Extreme
- **Unbestimmtheit:** 0.0 kann "neutral" oder "unbestimmt" bedeuten (Polarity, Volitionality, Confidence)
- **Kombination:** Mischung aus Bitmasken (Aspect) und Float fuer komplexe Bedeutungsausdruecke
