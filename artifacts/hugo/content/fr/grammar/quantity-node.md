---
title: "Quantity Node"
weight: 70
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "quantity", "SI", "currency"]
summary: "Node a longueur variable de 4 a 7 mots representant grandeurs physiques, valeurs numeriques, devises et litteraux. 6 bits d'Unit encodent les unites SI de base et derivees, devises et litteraux speciaux, tandis que 4 bits de Scale expriment les prefixes SI."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Quantity Node est un type de Node a longueur variable representant les **grandeurs physiques, valeurs numeriques, devises et litteraux**.

| Caracteristique | Description |
|-----------------|-------------|
| **Longueur variable** | 4~N mots (selon la taille de la valeur) |
| **Unite explicite** | SI de base/derivees + non-SI (devises, temps, etc.) |
| **Support d'echelle** | Prefixes exprimes en puissances de 10 |
| **Litteraux speciaux** | Horodatage, chaines (UTF-16), couleurs (RGBA) |
| **TID en fin** | Propriete des Node (coherence avec [Entity Node](../entity-node/)) |

**Usages :** Object du [Triple Edge](../triple-edge/), participant du Verb Edge, participant de l'[Event6 Edge](../event6-edge/), nom/label d'entite, expressions temporelles, etc.

## Structure du paquet

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │       Unit         │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌──────┬──────┬──────┬────────────────────┐
│ Sign │ Size │ Type │      Scale         │
│ 1bit │ 2bit │ 1bit │       4bit         │
├──────┴──────┴──────┴────────────────────┤
│              Reserved (8bit)            │
└─────────────────────────────────────────┘

3rd+ WORD: Value (variable, 1/2/4 mots selon Size)

Last WORD (16 bits)
┌─────────────────────────────────────────┐
│                  TID                    │
│                 16bit                   │
└─────────────────────────────────────────┘
```

| Champ | Bits | Taille | Description |
|-------|------|--------|-------------|
| Prefix | 1-10 | 10 | `0001 000 010` (Quantity Node) |
| Unit | 11-16 | 6 | 64 codes d'unite |
| Sign | 17 | 1 | 0=positif, 1=negatif |
| Size | 18-19 | 2 | Nombre de mots de la valeur |
| Type | 20 | 1 | 0=entier, 1=virgule flottante |
| Scale | 21-24 | 4 | Puissance de 10 (decalage 8) |
| Reserved | 25-32 | 8 | Reserve (code devise si devise) |

### Taille du paquet selon Size

| Size | Mots de valeur | Total mots |
|------|----------------|------------|
| 00 | 1 (16 bits) | 4 |
| 01 | 2 (32 bits) | 5 |
| 10 | 4 (64 bits) | 7 |

## Codes Unit (6 bits = 64)

### Unites SI de base (0x00~0x06)

| Code | Unite | Symbole | Grandeur |
|------|-------|---------|----------|
| 0x00 | meter | m | Longueur |
| 0x01 | kilogram | kg | Masse |
| 0x02 | second | s | Temps |
| 0x03 | ampere | A | Courant electrique |
| 0x04 | kelvin | K | Temperature |
| 0x05 | mole | mol | Quantite de matiere |
| 0x06 | candela | cd | Intensite lumineuse |

### Unites SI derivees (0x07~0x1C)

| Code | Unite | Symbole | Grandeur |
|------|-------|---------|----------|
| 0x07 | hertz | Hz | Frequence |
| 0x08 | newton | N | Force |
| 0x09 | pascal | Pa | Pression |
| 0x0A | joule | J | Energie |
| 0x0B | watt | W | Puissance |
| 0x0C | coulomb | C | Charge electrique |
| 0x0D | volt | V | Tension |
| 0x0E | farad | F | Capacite electrique |
| 0x0F | ohm | Ω | Resistance |
| 0x10 | siemens | S | Conductance |
| 0x11 | weber | Wb | Flux magnetique |
| 0x12 | tesla | T | Champ magnetique |
| 0x13 | henry | H | Inductance |
| 0x14 | celsius | °C | Temperature |
| 0x15 | lumen | lm | Flux lumineux |
| 0x16 | lux | lx | Eclairement |
| 0x17 | becquerel | Bq | Radioactivite |
| 0x18 | gray | Gy | Dose absorbee |
| 0x19 | sievert | Sv | Equivalent de dose |
| 0x1A | katal | kat | Activite catalytique |
| 0x1B | radian | rad | Angle plan |
| 0x1C | steradian | sr | Angle solide |

### Unites non-SI (0x20~0x2F)

| Code | Unite | Usage |
|------|-------|-------|
| 0x20 | CURRENCY | Devise (extension code devise) |
| 0x21 | percent | % (ratio) |
| 0x22 | degree | ° (angle) |
| 0x23~0x28 | minute~year | Unites de temps |
| 0x29 | bit | Quantite d'information |
| 0x2A | byte | Quantite d'information |
| 0x2B~0x2F | COUNT~INDEX | Valeurs sans unite |

### Litteraux speciaux (0x30~0x3F)

| Code | Type | Payload | Usage |
|------|------|---------|-------|
| 0x30 | TIMESTAMP_SEC | 2/4 mots | Unix timestamp (secondes) |
| 0x31 | TIMESTAMP_MS | 4 mots | Unix timestamp (millisecondes) |
| 0x32 | UTF16 | 2+N mots | Chaine UTF-16 |
| 0x33 | RGBA | 2 mots | Couleur (32 bits) |

## Scale (4 bits)

Puissance de 10. Decalage de 8. **Calcul :** `valeur_reelle = Value x 10^(Scale - 8)`

| Code | Valeur | Prefixe | Code | Valeur | Prefixe |
|------|--------|---------|------|--------|---------|
| 0000 | 10⁻⁸ | - | 1000 | **10⁰ (par defaut)** | - |
| 0010 | 10⁻⁶ | μ | 1001 | 10¹ | da |
| 0101 | 10⁻³ | m | 1011 | 10³ | k |
| 0110 | 10⁻² | c | 1110 | 10⁶ | M |

## Extension devise (Unit = 0x20)

Lorsque l'unite est CURRENCY, les 8 bits Reserved sont utilises comme code devise.

| Code | Devise | ISO | Code | Devise | ISO |
|------|--------|-----|------|--------|-----|
| 0x00 | Dollar US | USD | 0x05 | Won coreen | KRW |
| 0x01 | Euro | EUR | 0x06 | Franc suisse | CHF |
| 0x02 | Yen japonais | JPY | 0x07 | Dollar australien | AUD |
| 0x03 | Livre sterling | GBP | 0x08 | Dollar canadien | CAD |
| 0x04 | Yuan chinois | CNY | 0x80 | Bitcoin | BTC |

## Exemples

### "100kg" → 4 mots

```
1st: [Prefix] + [0x01(kg)]
2nd: +, 1 mot, int, x1     → 0x0800
3rd: 0x0064 (100)
4th: TID
Interpretation: +100 x 10⁰ kg = 100kg
```

### "$2,500,000" → 4 mots (utilisation d'echelle)

```
1st: [Prefix] + [0x20(CURRENCY)]
2nd: +, 1 mot, int, x10³, USD  → 0x0B00
3rd: 0x09C4 (2500)
4th: TID
Interpretation: +2500 x 10³ USD = $2,500,000
```
