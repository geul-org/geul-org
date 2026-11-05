---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value est un enregistrement qui contient une valeur en elle-même."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value est un enregistrement qui contient une valeur en elle-même. C'est le Codec qui fixe l'interprétation du Payload.

## Disposition {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      sections 3·4 (0x060L~0x09FL)
[TAG d'extension Length]
[TAG d'extension Codec]  pour un format d'Issuer
Payload
```

- `LLLL` est le nombre total de WORD, TAG WORD compris, moins 1. De 1 à 14 WORD, la longueur est directe ; à partir de 15 WORD, c'est une longueur étendue.
- Pour un format d'Issuer, le TAG d'extension Codec contient l'Issuer (largeur de 2/4/16 WORD fixée par le Codec) et le numéro de Codec de 2 WORD. Le numéro de Codec est fixé par l'Issuer.
- Un décodeur connaît, même sans connaître le format, le Kind, la Length, l'Issuer et le numéro de Codec.

## Familles {#계열}

Le numéro de Value n'indique pas une famille. Les codes directs n'expriment pas la famille par des bits, et les formats d'Issuer n'ont pas non plus de règle de famille. Une famille est un regroupement par thème.

| Famille | Codes directs |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- Les valeurs numériques telles que vecteur, tenseur, nombre complexe, fraction et intervalle relèvent de NUMERIC. Exception : BIT-VECTOR est BINARY. Les codes de langue sont TEXT.
- Un enregistrement de format d'Issuer porte un TAG d'extension Codec (Issuer et numéro de Codec). Si le Payload est long (15 WORD ou plus au total), on utilise un TAG d'extension Length.

## Codes directs {#직접-코드}

| Codec | Nom | Famille | Description |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false ou true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | entier en complément à deux sur le minimum de WORD |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | entier non signé sur le minimum de WORD |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | latitude·longitude terrestres (WGS 84) et incertitude (Reference d'unité) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | Reference d'un corps céleste, latitude·longitude et incertitude (Reference d'unité) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | quantité numérique (entier·BINARY-FLOAT·nombre décimal·fraction), Reference d'unité, bornes inférieure·supérieure |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | fraction qui conserve sa notation (enregistrements de numérateur·dénominateur, sans simplification) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`, coefficient signé |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`, coefficient non signé |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | nombre de jours depuis 1970-01-01 (calendrier grégorien) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | nanosecondes depuis minuit |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | secondes depuis l'epoch Unix |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | temps écoulé (secondes) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | chaîne de date étendue ISO 8601-2 (précision année·mois, incertitude, intervalle) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | chaîne de date GEDCOM 7 (autres calendriers, dont le julien) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | chaîne UTF-8 sans langue |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | URI de la RFC 3986 |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | language tag BCP 47 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | texte muni d'une langue |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | code de langue compressé sur 1 WORD |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | UUID de la RFC 9562 |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | résultat de SHA-256 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | résultat de SHA-1 (à des fins d'identification, comme un ID d'objet git) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | suite d'octets de sens et de forme inconnus. Octets pairs·impairs |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | N bits stockés en MSB-first après le bit-count |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | temps écoulé (nanosecondes) |

- Les codes appariés en pair/impair sont des suites d'octets de longueur variable. Le code pair correspond à un nombre d'octets pair, le code impair à un nombre d'octets impair ([Enregistrement et TAG WORD](../record.md)).
- Les codes directs occupent `0x060L~0x081L` sans Reserved. `0x082L~0x09CL` sont Reserved, et `0x09DL~0x09FL` sont [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md).

## Formats d'Issuer {#issuer-형식}

Un format absent des codes directs se place sous l'Issuer de l'organisme qui l'a établi, avec un numéro de Codec. Les formats conventionnels sans organisme établisseur se placent sous ADHOC (`0x00000002`). Les formats propres à GEUL (OPAQUE-BYTES, BIT-VECTOR, DURATION-NANOSECONDS) sont des codes directs.

| Issuer | Exemples de formats |
|---|---|
| ADHOC `0x00000002` | BFLOAT16, vecteurs d'entiers·de réels, tenseur, nombre complexe, fraction, intervalle, quaternion, BLAKE3 |
| IETF `0x00000007` | URI relatif, CRC32C, adresses IPv4·IPv6 |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128, timestamp POSIX en nanosecondes, adresse MAC |
| KHRONOS `0x0000000E` | pixels RGBA8·BGRA8 |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | timestamp TAI |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | timestamp GPS |

- Un décodeur qui ne connaît pas le format connaît l'Issuer et le numéro de Codec, et saute le reste grâce à Length.
- Le document de Codec se place sous le `codecs/` de l'Issuer, avec le numéro de Codec de l'enregistrement. Exemple : CRC32C de l'IETF est à `0x00000007/codecs/0x0000C000/` ([Adresse de publication et liste des versions](../publishing.md)).
- Pour les grandes valeurs comme les images et les vidéos, on recommande de les référencer par URI et SHA-256 plutôt que de les inclure directement.
- Une œuvre contenue dans une suite d'octets suit sa licence d'origine. La source et la licence sont consignées en Meta.

## Groupes de formats {#형식-묶음}

Les descriptions par groupe figurent ci-dessous. La disposition, l'interprétation, la validité et les exemples de chaque format se trouvent dans le document propre à ce format.

| Groupe | Famille | Formats |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL, entiers, flottants, coordonnées, QUANTITY, FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | dates, heures, timestamps, temps écoulé, EDTF, date GEDCOM |
| [text](#text) | TEXT | texte UTF-8, texte muni d'une langue, URI, codes de langue |
| [binary](#binary) | BINARY | UUID, digests, CRC, adresses réseau, suites d'octets inconnues, vecteur de bits |
| [vector](#vector) | NUMERIC | vecteurs denses d'entiers·de réels, points·boîtes englobantes, pixels RGBA·BGRA |
| [tensor](#tensor) | NUMERIC | tenseurs dense·packed munis d'un format, d'un rank et d'un shape |
| [etc](#etc) | NUMERIC | nombres complexes, fractions, intervalles fermés, quaternions |

- Les groupes vector, tensor et etc sont tous des formats d'Issuer (ADHOC, KHRONOS) de la famille NUMERIC.

### numeric {#numeric}

Les formats numériques de base de la famille NUMERIC. Ils se placent aux codes directs `0x060L~0x067L`.

- On y trouve BOOL, les entiers signés et non signés, les flottants binary IEEE 754, les coordonnées terrestres (WGS 84) et célestes, QUANTITY qui réunit quantité, unité et bornes, et la fraction FRACTION dans sa notation d'origine.
- Un entier s'écrit sur le minimum de WORD dans lequel la valeur tient.
- Les formats d'Issuer de petits scalaires (BFLOAT16, FP8, FP4) n'ont qu'un numéro de Codec attribué et pas de spécification détaillée (problème ouvert de [Value](#열린-문제)).
- Les vecteurs, tenseurs, nombres complexes, fractions irréductibles (RATIONAL-I64) et intervalles relèvent aussi de la famille NUMERIC, mais comme ce sont des formats d'Issuer, on les place dans les groupes [vector](#vector), [tensor](#tensor) et [etc](#etc).

### decimal {#decimal}

La famille DECIMAL regroupe les formats de nombres décimaux exacts. Ils se placent aux codes directs `0x068L~0x069L`.

- Les codes directs SIGNED-DECIMAL·UNSIGNED-DECIMAL s'écrivent `C × 10^E` et contiennent tel quel le nombre de chiffres de la notation d'origine. `1.20` (`C=120, E=−2`) et `1.2` (`C=12, E=−1`) sont des enregistrements différents. L'égalité de valeur et la conservation du quantum sont un problème ouvert de [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제).
- Les encodages DPD·BID d'IEEE 754 decimal32/64/128 sont des formats de l'Issuer IEEE (`0x0000000D`).

### time {#time}

La famille TIME regroupe les formats de date et d'heure. Ils se placent aux codes directs `0x06AL~0x071L` et `0x081L` (DURATION-NANOSECONDS).

| Précision | Format |
|---|---|
| Date (calendrier grégorien) | GREGORIAN-DATE |
| Année·mois, incertitude, intervalle | EDTF |
| Notation d'origine d'un autre calendrier (julien, etc.) | GEDCOM-DATE |
| Heure | timestamps POSIX·TAI·GPS |
| Temps écoulé | DURATION-SECONDS, DURATION-NANOSECONDS |

- Une date qui peut s'écrire en GREGORIAN-DATE ne s'écrit pas en EDTF.
- Les timestamps en nanosecondes et les formats TAI·GPS sont des formats placés sous les Issuer des organismes de normalisation (IEEE, BIPM, GPS).

### text {#text}

La famille TEXT regroupe les formats de texte et d'identifiants de chaînes. Ils se placent aux codes directs `0x072L~0x07AL`.

- Une chaîne sans langue est un UTF8-TEXT ; un texte avec langue, comme un nom, un titre ou une phrase, est un UTF8-LANGUAGE-TEXT.
- Les codes de langue (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) relèvent aussi de la famille TEXT.
- Les suites d'octets de longueur variable se placent en paires de Codec pair/impair. Si le bit de poids faible est `1`, le nombre d'octets est impair et l'octet de poids faible du dernier WORD est un padding `0x00` ([Enregistrement et TAG WORD](../record.md)).

### binary {#binary}

La famille BINARY regroupe les formats de suites d'octets. Ils se placent aux codes directs `0x07BL~0x080L`.

- UUID, SHA-256, SHA-1, la suite d'octets inconnue (OPAQUE-BYTES) et le vecteur de bits (BIT-VECTOR) sont des codes directs. Les autres digests, CRC32C et les adresses IPv4·IPv6·MAC sont des formats d'Issuer.
- Les valeurs de taille fixe (UUID, digests, adresses) ont une taille déterminée et n'ont donc pas de paire pair/impair.
- Les médias publics comme les images et les vidéos se placent comme formats de l'Issuer IANA (`0x00000008`). Les numéros de Codec sont attribués en paires pair/impair et le Payload est une suite d'octets. La limite supérieure de Length est 2^32−1 WORD. Pour les grandes valeurs, on recommande de les référencer par URI et SHA-256 plutôt que de les inclure directement.
- Une œuvre contenue dans une suite d'octets suit sa licence d'origine. La source et la licence sont consignées en Meta.

### vector {#vector}

Les formats de vecteurs sont des formats d'Issuer de la famille NUMERIC. Les vecteurs denses d'entiers·de réels et les points·boîtes englobantes se placent sous ADHOC (`0x00000002`) aux numéros de Codec `0x00000500`~`0x0000050C`, et les formats de pixels sous KHRONOS (`0x0000000E`).

- Les éléments d'un vecteur dense sont stockés de façon contiguë en big-endian.
- Comme ce sont des formats d'Issuer, le TAG d'extension Codec porte l'Issuer de 2 WORD et le numéro de Codec de 2 WORD.

### tensor {#tensor}

Les formats de tenseurs sont des formats d'Issuer de la famille NUMERIC. Ils se placent sous ADHOC (`0x00000002`) aux numéros de Codec `0x00000600`~`0x00000601`.

- DESCRIBED-DENSE-TENSOR contient le format des éléments, le rank, le shape et un payload dense C-contiguous.
- DESCRIBED-PACKED-TENSOR contient le format packed, le rank, le shape et un payload packed low-bit-first à l'intérieur de l'octet.

### etc {#etc}

Les autres formats numériques sont des formats d'Issuer de la famille NUMERIC. Ils se placent sous ADHOC (`0x00000002`) aux numéros de Codec `0x00000700`~`0x00000704`.

- On y trouve les nombres complexes (COMPLEX64, COMPLEX128), la fraction normalisée (RATIONAL-I64), l'intervalle fermé binary64 et le quaternion binary32.

## Texte {#텍스트}

Un texte avec langue et un texte sans langue sont des valeurs différentes. « Paris » (chaîne) et « Paris » (français) ne sont pas identiques.

| Format | Où l'utiliser |
|---|---|
| UTF8-TEXT | chaînes sans langue : identifiants, codes, noms de fichiers, ID externes |
| UTF8-LANGUAGE-TEXT | textes avec langue : noms, titres, phrases |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = le texte a un nombre d'octets impair)
[TAG d'extension Length]
Langue            enregistrement LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE
Texte             octets UTF-8 (si impair, dernier 0x00)
```

- Le texte est de l'UTF-8 well-formed et conservé tel quel. La normalisation incombe au côté qui compare ou indexe.
- Un nom commun à plusieurs langues s'écrit avec la langue `mul`, une langue indéterminée avec `und`. Une chaîne sans contenu linguistique est un UTF8-TEXT.

Exemple : `"Douglas Adams"@en` (13 octets, impair)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   langue en    D o  u g  l a  s ␠  A d  a m  s (padding)
```

## Nombres décimaux et quantités {#10진수와-수량}

Un nombre décimal exact s'écrit `C × 10^E`. L'exposant `E` est sur 32 bits, et le coefficient `C` est un complément à deux sur le minimum de WORD. Il contient tel quel le nombre de chiffres de la notation d'origine : `1.20` est `C=120, E=−2`, et `1.2` est `C=12, E=−1`. Les deux notations représentent le même nombre mais sont des enregistrements distincts, aux octets différents. L'encodeur ne normalise pas la notation arbitrairement. L'égalité de valeur des deux enregistrements et le sens du quantum (chiffres significatifs) sont un problème ouvert ([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

QUANTITY contient dans une seule valeur la quantité, l'unité et les bornes.

```
TAG WORD          0000 0110 0110 LLLL
[TAG d'extension Length]
Quantité          enregistrement de Value numérique (entier·BINARY-FLOAT·nombre décimal·fraction)
Unité             enregistrement Reference (élément d'unité), 0x0000 si sans unité
Borne inférieure  enregistrement de Value numérique, 0x0000 ABSENT si omis
Borne supérieure  enregistrement de Value numérique, 0x0000 ABSENT si omis
```

- L'unité fait partie de la valeur. On ne détache pas l'unité pour la noter ailleurs (détachée, on ne peut plus savoir si `652` est en km ou en m).
- La valeur convertie en unités SI n'est pas contenue. Elle se calcule à partir de l'unité et de la table de conversion.
- `0x0000` est le marqueur ABSENT indiquant qu'un champ facultatif est omis ([Document de spécification de Codec](../codec-spec.md)).

Exemple : `652 km`, intervalle `[651, 653]` (km = Q828224 de Wikidata)

```
066E 0011                    TAG (longueur étendue de 17 WORD)
0683 0000 0000 028C          quantité 652
0142 000C A340               unité Q828224
0683 0000 0000 028B          borne inférieure 651
0683 0000 0000 028D          borne supérieure 653
```

## Dates {#날짜}

| Précision | Format |
|---|---|
| Date (calendrier grégorien) | GREGORIAN-DATE |
| Année·mois, incertitude (`1971~`), intervalle | EDTF |
| Notation d'origine d'un autre calendrier (julien, etc.) | GEDCOM-DATE |
| Heure | timestamps POSIX·TAI·GPS |

- Une date qui peut s'écrire en GREGORIAN-DATE ne s'écrit pas en EDTF.

## Problèmes ouverts {#열린-문제}

- Les formats de médias publics (JPEG, PNG, MP4, MOV, etc.) se placent aux numéros de Codec de l'Issuer IANA (`0x00000008`). Manière de gérer la table de correspondance entre types de médias et numéros de Codec.
- Liste définitive des codes directs de Value. Elle sera fixée en mesurant la fréquence des Value dans des échantillons de lois et de conversations professionnelles (candidats : montants, pourcentages, intervalles de dates).
- Spécification détaillée et placement des 7 petits scalaires (ADHOC BFLOAT16, ONNX FP8 en 4 variantes, OCP FP8-E8M0FNU·FP4-E2M1FN). On n'a pas décidé de les transférer en codes directs. Pour l'instant, seuls les numéros de Codec sont attribués.
