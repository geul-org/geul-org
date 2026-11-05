---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION est une Value qui représente une fraction écrite dans le texte d'origine, telle quelle dans sa notation."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `FRACTION` (document de spécification BIND `FRACTION`) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| Document de spécification | `0x00000000/codecs/0x00000670/` (cible DECLARE `0670`) |
| Section | 3 `0011` (Value), offset C dans la section = 7 |
| Kind | Value · famille : NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | fraction conservant la notation d'origine : numérateur entier ou nombre décimal, dénominateur entier non signé ou nombre décimal non signé. Sans simplification |
| Côté Hugo | `value/numeric/fraction.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | enregistrement | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | enregistrement | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION est une Value qui représente une fraction écrite dans le texte d'origine, telle quelle dans sa notation. Son code direct Value est `0x067L`, sa famille est NUMERIC. Le numérateur et le dénominateur sont chacun un enregistrement de Value complet. On ne simplifie pas. Elle porte les fractions dont la notation même est l'enregistrement, comme « deux tiers » ou « cinq centièmes » dans un texte de loi, ou une quote-part décimale d'un registre foncier `23.45/1256.1`.

## Disposition {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[TAG d'extension de Length] à partir de 15 WORD au total
numerator         1 enregistrement de Value : SIGNED-INTEGER ou SIGNED-DECIMAL
denominator       1 enregistrement de Value : UNSIGNED-INTEGER ou UNSIGNED-DECIMAL
```

## Interprétation et validité {#해석과-유효성}

- numerator est exactement un enregistrement [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`) ou [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`).
- denominator est exactement un enregistrement [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`) ou [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`).
- La liste est fermée. Les autres Value, FRACTION lui-même (imbrication interdite) et les marqueurs d'emplacement (`0x0000`, etc.) ne sont pas reçus.
- Les deux enregistrements ayant chacun leur longueur, on n'écrit pas séparément de frontière. Le curseur après la lecture des deux enregistrements doit coïncider exactement avec la fin du Payload.
- Les enregistrements intérieurs suivent aussi la forme canonique de chaque Codec (entiers et coefficient en nombre minimal de WORD). Si un enregistrement intérieur est non canonique, FRACTION tout entier est invalid.
- La valeur est `numerator / denominator`.

### Conservation de la notation {#표기-보존}

- **Entier et nombre décimal** : si la composante du texte d'origine est un entier (sans séparateur décimal), on utilise un enregistrement INTEGER ; s'il y a un séparateur décimal, un enregistrement DECIMAL. Écrire une composante en DECIMAL avec l'exposant `E = 0` est invalid. Ainsi, une même notation correspond à une seule suite d'octets.
- Les C et E d'une composante DECIMAL sont les chiffres du texte d'origine tels quels. `23.450` est `23450×10^-3` et est une Value différente de `23.45`.
- **On ne simplifie pas.** `2/4` et « cinq centièmes » (`5/100`) s'écrivent tels quels. Si les octets sont identiques, la notation d'origine est identique.
- Une fraction de dénominateur 1 (`3/1`) s'écrit telle quelle si le texte d'origine l'écrit ainsi. Si le texte d'origine est un entier, on utilise un Codec entier et non FRACTION. Si le texte d'origine est un nombre décimal (`0.5`, `5%`), on utilise DECIMAL.
- Le signe n'est placé que sur le numérateur. Le dénominateur est d'un Codec non signé.
- Si la valeur du dénominateur est 0, c'est invalid (`0` comme `0.0`).

### Comparaison {#비교}

- La couche de comparaison calcule FRACTION comme le rationnel exact `(C1 × 10^E1) / (C2 × 10^E2)` (une composante INTEGER vaut `E = 0`). Elle n'approxime pas en virgule flottante.
- La comparaison, le tri et la détection des doublons se font sur cette valeur, tandis que le stockage, la signature et le hachage du contenu se font sur la notation (les octets). `2/4`, `1/2` et `0.5` ont la même valeur et des octets différents.
- Le contrôle de quorum (« au moins les deux tiers des voix des actionnaires présents ») se compare avec cette valeur exacte.

## Longueur {#길이}

- Le total est 1 WORD de TAG + (TAG d'extension de Length) + les deux enregistrements. Un enregistrement entier fait TAG 1 + Payload 1 WORD ou plus, un enregistrement de nombre décimal fait TAG 1 + exposant 2 + coefficient 1 WORD ou plus.
- Une petite fraction entière fait 5 WORD, une petite fraction décimale 9 WORD. À partir de 15 WORD, on utilise la longueur étendue ([Enregistrement et TAG WORD](../record.md)).

| Texte d'origine | Composantes | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Exemple {#예시}

`2/3` :

```
0674 0611 0002 0621 0003
```

- TAG `0674` (Codec `0x067L`, 5 WORD), numerator `0611 0002` (SIGNED-INTEGER 2), denominator `0621 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1` :

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678` (9 WORD), numerator `0683 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0693 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Relation avec les autres formats {#다른-형식과의-관계}

- amount, lower et upper de [QUANTITY](0x066L-quantity.md) acceptent FRACTION. « Deux tiers des voix des présents » peut s'écrire avec amount `2/3` dans un QUANTITY sans unité.
- Le document de spécification geul.org `0x00000000/codecs/0x00000670` le décrit avec deux champs d'enregistrement : numerator (`0610`·`0680`) et denominator (`0620`·`0690`) ([document de spécification de Codec](../codec-spec.md)).
- Si l'on a besoin d'une fraction int64 de largeur fixe qui impose la simplification, on utilise le format d'Issuer [RATIONAL-I64](adhoc.geul.org/rational-i64.md).

## Problèmes ouverts {#열린-문제}

1. Conservation de la notation des nombres mixtes (`1 et 2/3`).
2. Un format qui porte, avec deux QUANTITY, une fraction dont les composantes ont une unité (surface/surface). FRACTION ne porte pas d'unité.
3. Le critère de notation pour savoir s'il faut représenter les pourcentages et pour-mille (`5%`, `5‰`) par DECIMAL et une unité, ou par FRACTION (`5/100`).
4. Les fractions complexes (FRACTION au numérateur ou au dénominateur). Elles sont interdites pour l'instant.

## Pages liées {#관련-페이지}

- [Value](_index.md), [QUANTITY](0x066L-quantity.md), [SIGNED-INTEGER](0x061L-signed-integer.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000670/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
