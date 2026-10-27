---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE est une Value qui contient une balise de langue BCP 47 complète sous forme de suite d'octets ASCII. Elle emploie la paire de codes d'octets pair/impair 0x46/0x47."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE est une Value qui contient une balise de langue BCP 47 complète. Elle sert à écrire la langue avec précision, jusqu'au script, à la région et à la variante.

## Disposition

- Code : code direct de Value `0x46` (nombre d'octets pair) et `0x47` (impair). Famille TEXT.
- Le nombre d'octets est fixé par le bit de poids faible du Codec et le nombre de WORD du Payload. C'est `2 × nombre de WORD du Payload − bit de poids faible`, sans Byte Count ([Value](/fr/grammar/value/)).
- Le Payload n'est pas du texte UTF-8 mais la suite d'octets ASCII d'une balise BCP 47.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er ... Nème          BCP 47 tag bytes / final zero padding
```

## Interprétation et validité

- La suite d'octets doit être une balise de langue BCP 47 well-formed au sens de la RFC 5646. La chaîne vide n'est pas admise.
- Le Payload n'emploie que des lettres ASCII, des chiffres et le trait d'union `-`. Le séparateur est obligatoirement l'ASCII `-`, et `_`, l'espace et les caractères non ASCII ne sont pas admis.
- La comparaison des balises BCP 47 ne distingue pas la casse. Le profil canonique de GEUL écrit tous les séparateurs en `-`, et sérialise les sous-balises language, extlang, variant, extension et private-use en minuscules, script en Titlecase et region en majuscules.
- Le simple fait d'être well-formed ne suffit pas. La validité des sous-balises enregistrées et des balises grandfathered se juge d'après un snapshot précis de l'IANA Language Subtag Registry, et il faut conserver aussi la date de ce snapshot ou la version du registre.
- Les balises private-use et les sous-balises private-use sont admises si elles sont well-formed selon la grammaire de la RFC 5646. Mais leur sens dépend d'un accord entre les parties et n'est pas défini par le registre IANA, donc elles ne garantissent pas l'interopérabilité publique.
- Si, dans le même snapshot, une sous-balise deprecated ou une balise grandfathered a une Preferred-Value, la forme GEUL canonique emploie cette valeur de remplacement en casse canonique. Une balise dans sa notation deprecated peut s'interpréter en entrée mais n'est pas la forme de stockage canonique.
- BCP 47 étant un profil ASCII, l'exigence de normalisation Unicode comme UTF-8 NFC ne s'applique pas.
- Dans un WORD, l'octet de poids fort vient en premier. Si le nombre d'octets est impair (code impair), l'octet de poids faible inutilisé du dernier WORD doit être `00`.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, si l'octet de poids faible du dernier WORD n'est pas `00`, on rejette.

## Fondement normatif

- La grammaire des balises de langue, l'interprétation insensible à la casse et la notion de deprecated/Preferred-Value suivent la [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Le registre qui juge la validité d'une balise est l'[IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- La paire de codes pair/impair, le zero padding, la politique de stockage en casse canonique et le calcul de Length sont des règles de cadrage de GEUL.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Length](/fr/grammar/record/)).

## Relation avec LANGUAGE-SHORT-CODE

- Pour ne contenir que la sous-balise de langue primaire sous forme courte, on emploie [LANGUAGE-SHORT-CODE](/fr/grammar/value/text/language-short-code/).
- Si l'on a besoin de script, région, variante, extension ou private-use, on emploie LANGUAGE-BCP47-CODE.
- On emploie aussi LANGUAGE-BCP47-CODE pour une langue pas encore attribuée dans le registre LANGUAGE-SHORT-CODE, quand l'échappement `0xffff` serait nécessaire, et quand il faut conserver le texte d'origine de la balise complète.

## Exemple

- `ko-KR` fait 5 octets ASCII (impair), donc `LANGUAGE-BCP47-CODE-ODD` (`0x47`), Payload `6b6f 2d4b 5200`.
- Avec le TAG de 1 WORD et le Payload de 3 WORD, on a 4 WORD au total et `LLLL=0011`. L'ensemble est `09C7 6b6f 2d4b 5200`.
