---
title: "SIGNED-INTEGER"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER est une Value qui contient un entier signé en complément à deux sur le nombre minimal de WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-INTEGER est une Value qui représente une valeur entière signée. Code direct de Value `0x01`, famille NUMERIC. Tout le Payload se lit comme un entier en complément à deux de précision arbitraire, dans l'ordre big-endian des WORD. Le Payload fait au moins 1 WORD et seule la représentation canonique sur le nombre minimal de WORD est admise.

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x01
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er  (WORD de poids fort)   Integer 1er
...
Payload WORD Nème (WORD de poids faible) Integer Nème
```

## Interprétation

- Le bit de poids le plus fort du premier WORD du Payload est le bit de signe de l'entier entier.
- Tous les WORD du Payload se lisent comme une seule suite de bits continue en complément à deux. Le premier WORD est la position la plus haute, le dernier la plus basse.
- Si le Payload fait N WORD, la largeur d'interprétation est de `16N` bits. Cette largeur n'est pas une largeur de stockage déclarée mais la largeur de représentation de la valeur fixée par la représentation canonique.
- Il n'y a ni Byte Count ni descriptor de largeur en bits.

## Représentation canonique

- 0 est le Payload de 1 WORD `0000`.
- Les WORD d'extension de signe de tête qui ne changent pas la valeur sont interdits.
- Quand le Payload fait 2 WORD ou plus, les cas suivants sont non canoniques.
  - Le premier WORD est `0000` et le bit de poids le plus fort du WORD suivant est 0
  - Le premier WORD est `ffff` et le bit de poids le plus fort du WORD suivant est 1
- Un `0000` de tête qui préserve le signe d'un nombre positif est admis quand le bit de poids le plus fort du WORD suivant est 1.
- Un `ffff` de tête qui préserve le signe d'un nombre négatif est admis quand le bit de poids le plus fort du WORD suivant est 0.
- Le décodeur doit rejeter les représentations non canoniques.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Enregistrement et TAG WORD](/fr/grammar/record/)).
- Les largeurs déclarées comme INT8, INT16, INT32 ne sont pas conservées : seule la valeur numérique l'est. `-32768`~`32767` tient dans 1 WORD, et hors de cette plage on ajoute autant de WORD que nécessaire. Il n'existe pas de format SIGNED-INT8 distinct.

## Exemple

| Valeur | WORD du Payload | Verdict |
|---:|---|---|
| 0 | `0000` | canonique |
| 1 | `0001` | canonique |
| 32767 | `7fff` | canonique |
| 32768 | `0000 8000` | canonique : le `0000` est nécessaire pour préserver le signe positif |
| -1 | `ffff` | canonique |
| -32768 | `8000` | canonique |
| -32769 | `ffff 7fff` | canonique : le `ffff` est nécessaire pour préserver le signe négatif |
| 1 | `0000 0001` | non canonique : `0000` de tête inutile |
| -1 | `ffff ffff` | non canonique : `ffff` de tête inutile |

## Statut du format

- Le complément à deux est une convention répandue, mais cette expression, qui normalise une valeur de précision arbitraire en suite de WORD de 16 bits minimale et l'associe au TAG GEUL, est un profil de scalaire propre à GEUL.
- Pour échanger avec des types externes de largeur fixe comme INT8/16/32/64, il faut un contrôle de plage et une conversion de largeur explicite.
