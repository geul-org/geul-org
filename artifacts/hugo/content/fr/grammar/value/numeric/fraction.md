---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION est une Value de fraction qui contient le numérateur (entier ou décimal) et le dénominateur (entier ou décimal non signé) tels qu'ils sont écrits dans l'original, sans simplification."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION est une Value qui représente une fraction écrite dans un texte d'origine en conservant sa notation. Code direct de Value `0x07`, famille NUMERIC. Le numérateur et le dénominateur sont chacun un enregistrement Value complet. La fraction n'est pas simplifiée. Elle contient les fractions dont la forme écrite est elle-même l'acte, comme « les deux tiers » ou « cinq pour cent » dans les lois et la quote-part décimale `23.45/1256.1` au registre foncier.

## Disposition

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[TAG d'extension de Length] si le total atteint 15 WORD ou plus
numerator         un enregistrement Value : SIGNED-INTEGER ou SIGNED-DECIMAL
denominator       un enregistrement Value : UNSIGNED-INTEGER ou UNSIGNED-DECIMAL
```

## Interprétation et validité

- numerator est exactement un enregistrement [SIGNED-INTEGER](/fr/grammar/value/numeric/signed-integer/) (`0x01`) ou [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/) (`0x10`).
- denominator est exactement un enregistrement [UNSIGNED-INTEGER](/fr/grammar/value/numeric/unsigned-integer/) (`0x02`) ou [UNSIGNED-DECIMAL](/fr/grammar/value/decimal/unsigned-decimal/) (`0x11`).
- C'est une liste fermée. Les autres Value, FRACTION elle-même (pas d'imbrication) et les marqueurs de position (`0x0000`, etc.) ne sont pas acceptés.
- Chacun des deux enregistrements porte sa propre longueur ; on n'écrit donc pas de limite à part. Le curseur après la lecture des deux enregistrements doit coïncider exactement avec la fin du Payload.
- Les enregistrements internes suivent aussi la forme canonique de leur Codec (nombre minimal de WORD pour les entiers et le coefficient). Si un enregistrement interne n'est pas canonique, toute la FRACTION est invalid.
- La valeur est `numerator / denominator`.

### Conservation de la notation

- **Entier et décimal** : si une composante de l'original est entière (sans virgule décimale), on emploie un enregistrement INTEGER ; si elle a une virgule décimale, un enregistrement DECIMAL. Écrire une composante en DECIMAL d'exposant `E = 0` est invalid. Une même notation n'a donc qu'une seule suite d'octets.
- C et E d'une composante DECIMAL conservent tel quel le nombre de chiffres de l'original. `23.450` est `23450×10^-3`, une Value différente de `23.45`.
- **Pas de simplification.** `2/4` et « cinq pour cent » (`5/100`) s'écrivent tels quels. Si les octets sont identiques, la notation d'origine est identique.
- Une fraction de dénominateur 1 (`3/1`) s'écrit aussi telle quelle si l'original l'a écrite ainsi. Si l'original est un entier, on emploie un Codec entier et non FRACTION. Si l'original est un décimal (`0.5`, `5%`), on emploie DECIMAL.
- Le signe se place seulement sur le numérateur. Le dénominateur est un Codec non signé.
- Un dénominateur de valeur 0 est invalid (`0` comme `0.0`).

### Comparaison

- La couche de comparaison calcule une FRACTION comme le nombre rationnel exact `(C1 × 10^E1) / (C2 × 10^E2)` (`E = 0` pour une composante INTEGER). Elle n'approche pas par la virgule flottante.
- La comparaison, le tri et la détection des doublons se font sur cette valeur ; le stockage, les signatures et les empreintes de contenu se font sur la notation (les octets). `2/4`, `1/2` et `0.5` ont la même valeur et des octets différents.
- Le contrôle du quorum (« au moins les deux tiers des voix des actionnaires présents ») se compare avec cette valeur exacte.

## Longueur

- Le total est le TAG de 1 WORD + (TAG d'extension de Length) + les deux enregistrements. Un enregistrement entier fait au moins TAG 1 + Payload 1 WORD, et un enregistrement décimal fait au moins TAG 1 + exposant 2 + coefficient 1 WORD.
- Une petite fraction entière fait 5 WORD, une petite fraction décimale 9 WORD. À partir de 15 WORD, on emploie la longueur étendue ([Enregistrement et TAG WORD](/fr/grammar/record/)).

| Original | Composantes | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Exemple

`2/3` :

```
0A07 0881 0002 0882 0003
```

- TAG `0A07` (Codec `0x07`, 5 WORD), numerator `0881 0002` (SIGNED-INTEGER 2), denominator `0882 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1` :

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07` (9 WORD), numerator `0990 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0991 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Relation avec les autres formats

- amount, lower et upper de [QUANTITY](/fr/grammar/value/numeric/quantity/) acceptent FRACTION. « Les deux tiers des voix présentes » peut s'écrire comme une QUANTITY sans unité d'amount `2/3`.
- Le document de spécification de geul.org `0x0000/0x0000000000000807` l'écrit avec deux champs d'enregistrement : numerator (`0801`, `0810`) et denominator (`0802`, `0811`) ([document de spécification de Codec](/fr/grammar/codec-spec/)).
- Si l'on a besoin d'une fraction int64 fixe à simplification imposée, on emploie le format d'Issuer [RATIONAL-I64](/fr/grammar/value/etc/rational-i64/).

## Problèmes ouverts

1. La conservation de la notation des nombres fractionnaires mixtes (`1 et 2/3`).
2. Un format qui contienne en deux QUANTITY une fraction dont les composantes ont une unité (surface/surface). FRACTION ne contient pas d'unité.
3. Le critère de notation des pourcentages et pour-mille (`5%`, `5‰`) : DECIMAL avec unité, ou FRACTION (`5/100`).
4. Les fractions composées (FRACTION au numérateur ou au dénominateur). Elles sont interdites pour l'instant.

## Pages liées

- [Value](/fr/grammar/value/), [QUANTITY](/fr/grammar/value/numeric/quantity/), [SIGNED-INTEGER](/fr/grammar/value/numeric/signed-integer/), [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/), [RATIONAL-I64](/fr/grammar/value/etc/rational-i64/)
