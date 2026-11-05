---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indique la méthode de conversion d'une autre représentation vers ce document (par exemple un convertisseur Wikidata, un encodeur de langue naturelle)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `TRANSFORMED-BY` (BIND `TRANSFORMED-BY` du document de spécification) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| Document de spécification | `0x00000000/codecs/0x00001D40/` (cible du DECLARE `1D40`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 20 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Méthode de conversion. Outil, règles, version |
| Côté Hugo | `meta/lineage/transformed-by.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | enregistrement | N'importe quel enregistrement (hors marqueur d'emplacement) |  |
| 2 | `version` | #3 | enregistrement | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

Indique la méthode de conversion d'une autre représentation vers ce document (par exemple un convertisseur Wikidata, un encodeur de langue naturelle). Tool dit avec quoi la conversion a été faite, Version dit de quelle source de cet outil elle provient. Il faut les deux pour pouvoir recréer le même document à partir de la même entrée.

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[TAG d'extension Length]
Tool              1 enregistrement Reference (outil de conversion, règles)
Version           1 enregistrement Value (SHA-256-DIGEST ou SHA1-DIGEST)
```

- Codec : Meta `0x1D4L`, classe lignée
- Payload : Reference intégrée (outil) + Value intégrée (condensat de la version source)
- Nombre : plusieurs possibles (un par outil)

## Interprétation et validité {#해석과-유효성}

- Tool est exactement un enregistrement Reference complet. On peut employer n'importe quelle Reference qui désigne un outil.
  - Outil décrit par un document d'outil de geul.org : [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md) (`0x00000000`, ID de document `0x0001xxxx xxxxxxxx`, son LOCAL). Un document par outil (document de définition de termes de l'[Issuer](../issuer.md)).
  - Si le codec est un document GEUL, on désigne ce document de codec par [CODEC-POINTER](../reference/0x042L-codec-pointer.md).
- Version est exactement un enregistrement Value complet : l'ID d'objet de gestion de versions de la source de Tool. Avec git, c'est l'ID complet de l'objet commit.
  - Si le format d'objet du dépôt git est SHA-256, c'est [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) (`0x07CL`, 16 WORD) ; s'il est SHA-1, c'est [SHA1-DIGEST](../value/0x07DL-sha1-digest.md) (`0x07DL`, 10 WORD). On vérifie le format du dépôt avec `git rev-parse --show-object-format`.
  - On n'emploie pas d'ID abrégé (`2bd496f`, etc.). Les Value de condensat n'admettent pas de valeur tronquée.
  - On ne l'écrit pas en texte hexadécimal (UTF8-TEXT). La même valeur fait 22 WORD (11 en binaire) en SHA-1 et 34 WORD (18 en binaire) en SHA-256.
- Version est obligatoire. Un enregistrement d'outil dont la version source est inconnue ne peut fonder la reproduction. Pour un outil hors gestion de versions, on emploie le SHA-256 du livrable (SHA-256-DIGEST).
- Version désigne la source validée (committed). Pour un document produit depuis un arbre de travail comportant des modifications non validées, on n'emploie pas cet ID de commit (il est recommandé que l'outil refuse de s'exécuter).
- Si l'outil s'appuie sur du code extérieur au dépôt (par exemple une bibliothèque locale désignée par un `replace` de Go), ce code aussi s'écrit séparément par un TRANSFORMED-BY. L'ID de commit de l'outil seul ne détermine pas ce code.
- Un outil qui se contente de transférer la source sans perte (par exemple un outil qui charge un dump tel quel dans une base) ne fixe pas le contenu du document ; on ne l'écrit pas. Un chargement avec perte modifie le document, on l'écrit donc comme outil.
- Le document de spécification de geul.org (`0x1D40`) s'écrit avec deux champs d'enregistrement : Tool (largeur 0, n'importe quelle Reference donc sans CODEC) et Version (largeur 0, [CODEC](../edge/0x0BEL-codec.md) `07C0` et `07D0`).

## Longueur {#길이}

```
total = 1 + N_len + N_tool + N_version WORD
```

- Le curseur, une fois le dernier enregistrement lu, doit coïncider exactement avec la fin du Meta.
- Si Tool est un EXTERNAL-ISSUER-2WORD (8 WORD) et Version un SHA1-DIGEST (11 WORD), le total est 1 + 1 + 8 + 11 = 21 WORD et l'on emploie la longueur étendue. Avec un SHA-256-DIGEST (18 WORD), le total est 28 WORD.

## Exemple {#예시}

Exemple non normatif. L'outil est le LOCAL 2 du document d'outil de geul.org `0x0001000000000001` (`02F7 0000 0000 0001 0000 0000 0001 0002`) ; la source est le commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Problèmes ouverts {#열린-문제}

- Faut-il changer la version de [GENERATED-BY](0x1D3L-generated-by.md) de la même façon (condensat obligatoire ou autre format) ? La version d'un modèle n'est pas un ID de commit.

## Pages liées {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001D40/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
