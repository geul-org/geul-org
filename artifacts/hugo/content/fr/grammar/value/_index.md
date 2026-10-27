---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value est un enregistrement qui contient une valeur. Les 2 bits de poids fort du Codec forment la famille (nombres et décimaux, temps, texte, binaire) ; les formats fréquents ont un code direct, les autres sont des formats d'Issuer par organisme de normalisation."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value est un enregistrement qui contient une valeur. Le Codec fixe l'interprétation du Payload.

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC
[TAG d'extension de Length]
[TAG d'extension de Codec]  pour un format d'Issuer
Payload
```

- `LLLL` est le nombre total de WORD, TAG WORD compris, moins 1. De 1 à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue.
- Pour un format d'Issuer, le TAG d'extension de Codec contient l'Issuer (largeur fixée par le Codec : 1/2/4/16 WORD) et 1 WORD de numéro de format. Les 2 bits de poids fort du numéro de format forment la famille.
- Le décodeur connaît la famille et la Length même sans connaître le format.

## Familles

Les 2 bits de poids fort du Codec forment la famille. Le code direct (7 bits) et le numéro de format d'Issuer (16 bits) suivent la même règle. On connaît donc la famille sans livre de codes.

| 2 bits de poids fort | Famille | Code direct | Numéro de format |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL se subdivisent par le troisième bit. `000` est NUMERIC, `001` est DECIMAL.
- Les valeurs numériques comme vecteurs, tenseurs, complexes, fractions et intervalles sont NUMERIC. Par exception, BIT-VECTOR est BINARY. Les codes de langue sont TEXT.
- Un enregistrement de format d'Issuer porte un TAG d'extension de Codec (Issuer et numéro de format). Si le Payload est long (15 WORD au total ou plus), on emploie un TAG d'extension de Length.

## Codes directs

| Codec | Nom | Famille | Description |
|---|---|---|---|
| `0x00` | [BOOL](/fr/grammar/value/numeric/bool/) | NUMERIC | false ou true |
| `0x01` | [SIGNED-INTEGER](/fr/grammar/value/numeric/signed-integer/) | NUMERIC | Entier en complément à deux sur le nombre minimal de WORD |
| `0x02` | [UNSIGNED-INTEGER](/fr/grammar/value/numeric/unsigned-integer/) | NUMERIC | Entier non signé sur le nombre minimal de WORD |
| `0x03` | [BINARY-FLOAT](/fr/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/fr/grammar/value/numeric/coordinate-earth/) | NUMERIC | Latitude et longitude terrestres (WGS 84) et incertitude (Reference d'unité) |
| `0x05` | [COORDINATE-GEO](/fr/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference d'un corps céleste, latitude et longitude, incertitude (Reference d'unité) |
| `0x06` | [QUANTITY](/fr/grammar/value/numeric/quantity/) | NUMERIC | Quantité décimale, Reference d'unité, bornes inférieure et supérieure |
| `0x10` | [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`, coefficient signé |
| `0x11` | [UNSIGNED-DECIMAL](/fr/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`, coefficient non signé |
| `0x20` | [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/) | TIME | Nombre de jours depuis le 1970-01-01 (calendrier grégorien) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/fr/grammar/value/time/civil-time-nanoseconds/) | TIME | Nanosecondes depuis minuit |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/fr/grammar/value/time/posix-timestamp-seconds/) | TIME | Secondes depuis l'epoch Unix |
| `0x23` | [DURATION-SECONDS](/fr/grammar/value/time/duration-seconds/) | TIME | Durée écoulée (secondes) |
| `0x24`/`0x25` | [EDTF](/fr/grammar/value/time/edtf/) | TIME | Chaîne de date étendue ISO 8601-2 (précision à l'année ou au mois, incertitude, intervalle) |
| `0x26`/`0x27` | [GEDCOM-DATE](/fr/grammar/value/time/gedcom-date/) | TIME | Chaîne de date GEDCOM 7 (autres calendriers comme le julien) |
| `0x40`/`0x41` | [UTF8-TEXT](/fr/grammar/value/text/utf8-text/) | TEXT | Chaîne UTF-8 sans langue |
| `0x44`/`0x45` | [URI](/fr/grammar/value/text/uri/) | TEXT | URI de la RFC 3986 |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/fr/grammar/value/text/language-bcp47-code/) | TEXT | Balise de langue BCP 47 |
| `0x48` | [LANGUAGE-SHORT-CODE](/fr/grammar/value/text/language-short-code/) | TEXT | Code de langue compressé sur 1 WORD |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/) | TEXT | Texte accompagné d'une langue |
| `0x60` | [UUID](/fr/grammar/value/binary/uuid/) | BINARY | UUID de la RFC 9562 |
| `0x61` | [SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/) | BINARY | Résultat SHA-256 |
| `0x62` | [SHA1-DIGEST](/fr/grammar/value/binary/sha1-digest/) | BINARY | Résultat SHA-1 (usage d'identification comme les ID d'objets git) |

- Les codes appariés pair/impair sont des suites d'octets de longueur variable. Le code pair a un nombre d'octets pair, le code impair un nombre impair ([Enregistrement et TAG WORD](/fr/grammar/record/)).
- Les codes directs absents du tableau sont réservés.

## Formats d'Issuer

Les formats absents des codes directs se placent sous l'Issuer de l'organisme qui a établi ce format, avec un numéro de format. Les formats d'usage sans organisme normalisateur vont sous ADHOC (`0x0001`), les formats propres à GEUL sous GEUL (`0x0000`).

| Issuer | Exemples de formats |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, vecteurs d'entiers et de réels, tenseurs, complexes, fractions, intervalles, quaternions, BLAKE3 |
| IETF `0x0020` | URI relatif, CRC32C, adresses IPv4 et IPv6 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, horodatage POSIX en nanosecondes, adresse MAC |
| KHRONOS `0x0041` | Pixels RGBA8 et BGRA8 |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | Horodatage TAI |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | Horodatage GPS |

- Un décodeur qui ignore le format ne connaît que la famille du numéro de format et saute le Payload.
- Pour les grosses valeurs comme images et vidéos, on recommande de les référencer par URI et SHA-256 plutôt que de les mettre directement.
- Une œuvre contenue dans une suite d'octets suit sa licence d'origine. La provenance et la licence se consignent par Meta.

## Groupes de formats

La disposition, l'interprétation, la validité et les exemples de chaque format se trouvent dans le document du groupe.

| Groupe | Famille | Formats |
|---|---|---|
| [numeric](/fr/grammar/value/numeric/) | NUMERIC | BOOL, entiers, virgule flottante, coordonnées, QUANTITY |
| [decimal](/fr/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/fr/grammar/value/time/) | TIME | Dates, heures, horodatages, durées, EDTF, dates GEDCOM |
| [text](/fr/grammar/value/text/) | TEXT | Texte UTF-8, texte accompagné d'une langue, URI, codes de langue |
| [binary](/fr/grammar/value/binary/) | BINARY | UUID, digests, CRC, adresses réseau, suites d'octets inconnues, vecteurs de bits |
| [vector](/fr/grammar/value/vector/) | NUMERIC | Vecteurs denses d'entiers et de réels, points et boîtes englobantes, pixels RGBA et BGRA |
| [tensor](/fr/grammar/value/tensor/) | NUMERIC | Tenseurs dense et packed munis de format, rank et shape |
| [etc](/fr/grammar/value/etc/) | NUMERIC | Complexes, fractions, intervalles fermés, quaternions |

- Les groupes vector, tensor et etc sont tous des formats d'Issuer (ADHOC, KHRONOS) de la famille NUMERIC.

## Texte

Un texte avec langue et un texte sans langue sont des valeurs différentes. « Paris » (chaîne) et « Paris » (en français) ne sont pas égaux.

| Format | Où l'employer |
|---|---|
| UTF8-TEXT | Chaînes sans langue comme identifiants, codes, noms de fichiers, ID externes |
| UTF8-LANGUAGE-TEXT | Textes avec langue comme noms, titres, phrases |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = le texte a un nombre d'octets impair)
[TAG d'extension de Length]
Langue            enregistrement LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE
Texte             octets UTF-8 (si impair, dernier 0x00)
```

- Le texte est de l'UTF-8 bien formé conservé tel quel. La normalisation incombe à celui qui compare ou indexe.
- Un nom commun à plusieurs langues s'écrit avec la langue `mul`, une langue indéterminée avec `und`. Une chaîne sans contenu linguistique est UTF8-TEXT.

Exemple : `"Douglas Adams"@en` (13 octets, impair)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   langue en  D o  u g  l a  s ␠  A d  a m  s (remplissage)
```

## Décimaux et quantités

Un décimal exact s'écrit `C × 10^E`. L'exposant `E` fait 32 bits, le coefficient `C` est en complément à deux sur le nombre minimal de WORD. On conserve tel quel le nombre de chiffres de la notation d'origine : `1.20` est `C=120, E=−2`, `1.2` est `C=12, E=−1`. Les deux notations représentent le même nombre mais sont des enregistrements distincts aux octets différents. L'encodeur ne normalise pas arbitrairement la notation. L'égalité de valeur de deux enregistrements et le sens du quantum (chiffres significatifs) sont des problèmes ouverts ([SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/#problèmes-ouverts)).

QUANTITY contient en une seule valeur la quantité, l'unité et les bornes.

```
TAG WORD          0000 1LLL L000 0110
[TAG d'extension de Length]
Quantité          enregistrement SIGNED-DECIMAL
Unité             enregistrement Reference (élément d'unité), 0x0000 si sans unité
Borne inférieure  enregistrement SIGNED-DECIMAL, 0x0000 ABSENT si omise
Borne supérieure  enregistrement SIGNED-DECIMAL, 0x0000 ABSENT si omise
```

- L'unité fait partie de la valeur. On ne détache pas l'unité pour l'écrire ailleurs (détachée, on ne saurait plus si `652` est en km ou en m).
- On ne contient pas la valeur convertie en unités SI. Elle se calcule à partir de l'unité et de la table de conversion.
- `0x0000` est ABSENT, le marqueur d'omission d'un champ facultatif ([Documents de spécification de Codec](/fr/grammar/codec-spec/)).

Exemple : `652 km`, intervalle `[651, 653]` (km = Q828224 de Wikidata)

```
0F06 0011                    TAG (longueur étendue 17 WORD)
0990 0000 0000 028C          quantité 652
0120 000C A340               unité Q828224
0990 0000 0000 028B          borne inférieure 651
0990 0000 0000 028D          borne supérieure 653
```

## Dates

| Précision | Format |
|---|---|
| Date (calendrier grégorien) | GREGORIAN-DATE |
| Année ou mois, incertitude (`1971~`), intervalle | EDTF |
| Notation d'origine d'un autre calendrier (julien, etc.) | GEDCOM-DATE |
| Heure | Horodatages POSIX, TAI, GPS |

- Une date exprimable en GREGORIAN-DATE ne s'écrit pas en EDTF.

## Problèmes ouverts

- Les formats de médias publics (JPEG, PNG, MP4, MOV, etc.) se placent comme numéros de format BINARY de l'Issuer IANA (`0x0021`). Mode de gestion de la table de correspondance entre types de médias et numéros de format.
- Liste finale des codes directs de Value. À fixer en mesurant la fréquence des Value dans des échantillons de lois et de conversations professionnelles (candidats : montants, pourcentages, intervalles de dates).
- Spécification détaillée et placement de sept petits scalaires (ADHOC BFLOAT16, quatre FP8 ONNX, FP8-E8M0FNU et FP4-E2M1FN d'OCP). On n'a pas décidé de les déplacer dans la plage réservée des codes directs NUMERIC (`0x07`~`0x0F`). Pour l'instant, seuls les numéros de format sont attribués.
