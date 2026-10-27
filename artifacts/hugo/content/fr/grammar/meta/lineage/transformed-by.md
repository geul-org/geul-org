---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY est un Meta de lignée qui consigne l'outil ayant converti une autre représentation en ce document, ainsi que la version de sa source (digest de commit)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne la méthode par laquelle une autre représentation a été convertie en ce document (par exemple un convertisseur Wikidata, un encodeur de langue naturelle). Tool indique avec quoi la conversion a été faite, Version indique avec quelle source de cet outil. Il faut les deux pour pouvoir reproduire le même document à partir de la même entrée.

## Disposition

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[TAG d'extension de Length]
Tool              1 enregistrement Reference (outil de conversion, règles)
Version           1 enregistrement Value (SHA-256-DIGEST ou SHA1-DIGEST)
```

- Codec : Meta `0x33`, classe de lignée (`011`)
- Payload : Reference intégré (outil) + Value intégré (digest de la version source)
- Nombre : plusieurs possibles (un par outil)

## Interprétation et validité

- Tool est exactement un enregistrement Reference complet. Tout Reference qui désigne l'outil peut être utilisé.
  - Outil d'un document d'outil de geul.org : [EXTERNAL-ISSUER](/fr/grammar/reference/external-issuer/) (`0x0000`, ID de document `0x0001xxxx xxxxxxxx`, son LOCAL). Un document par outil ([Issuer](/fr/grammar/issuer/), document de définition de termes).
  - Si le codec est un document GEUL, ce document est désigné par un [DOC-POINTER](/fr/grammar/reference/doc-pointer/).
- Version est exactement un enregistrement Value complet : l'ID d'objet de gestion de versions de la source de Tool. Avec git, c'est l'ID complet de l'objet commit.
  - Si le format d'objet du dépôt git est SHA-256, c'est [SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/) (`0x61`, 16 WORD) ; s'il est SHA-1, [SHA1-DIGEST](/fr/grammar/value/binary/sha1-digest/) (`0x62`, 10 WORD). Le format du dépôt se vérifie avec `git rev-parse --show-object-format`.
  - Les ID abrégés (comme `2bd496f`) ne sont pas utilisés. Les Value de digest n'admettent pas de valeur tronquée.
  - On ne l'écrit pas en texte hexadécimal (UTF8-TEXT). La même valeur occuperait 22 WORD en SHA-1 (11 en binaire) et 34 WORD en SHA-256 (18 en binaire).
- Version est obligatoire. Un enregistrement d'outil dont la version source est inconnue ne peut pas servir de fondement à la reproduction. Pour un outil hors gestion de versions, on utilise le SHA-256 (SHA-256-DIGEST) de l'artefact distribué.
- Version désigne une source commitée. Pour un document produit à partir d'un arbre de travail comportant des modifications non commitées, on n'écrit pas l'ID de ce commit (il est recommandé que l'outil refuse de s'exécuter).
- Si l'outil dépend de code extérieur au dépôt (par exemple une bibliothèque locale désignée par un `replace` de Go), ce code est aussi consigné séparément par TRANSFORMED-BY. L'ID de commit de l'outil seul ne détermine pas ce code.
- Un outil qui se contente de transférer la source sans perte (par exemple un outil qui charge un dump tel quel en base de données) ne détermine pas le contenu du document et n'est pas consigné. Un chargement avec perte modifie le document ; on le consigne donc comme outil.
- Le document de spécification de geul.org (`0x1833`) s'écrit avec deux champs-enregistrements : Tool (largeur 0, n'importe quel Reference, donc sans CODEC) et Version (largeur 0, [CODEC](/fr/grammar/edge/codec/) `0861`, `0862`).

## Longueur

```
total = 1 + N_len + N_tool + N_version WORD
```

- Le curseur, une fois le dernier enregistrement lu, doit coïncider exactement avec la fin du Meta.
- Si Tool est un EXTERNAL-ISSUER-1WORD (7 WORD) et Version un SHA1-DIGEST (11 WORD), le total est 1 + 1 + 7 + 11 = 20 WORD et l'on utilise la Length étendue. Avec un SHA-256-DIGEST (18 WORD), le total est de 27 WORD.

## Exemple

Exemple non normatif. L'outil est le LOCAL 2 (`0360 0000 0001 0000 0000 0001 0002`) du document d'outil geul.org `0x0001000000000001`, la source est le commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Problèmes ouverts

- Faut-il faire de la version de [GENERATED-BY](/fr/grammar/meta/lineage/generated-by/) la même chose (digest obligatoire ou autre format). La version d'un modèle n'est pas un ID de commit.

## Pages liées

- [Meta](/fr/grammar/meta/), [GENERATED-BY](/fr/grammar/meta/lineage/generated-by/), [DERIVED-FROM](/fr/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/fr/grammar/reference/external-issuer/), [DOC-POINTER](/fr/grammar/reference/doc-pointer/), [SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/), [SHA1-DIGEST](/fr/grammar/value/binary/sha1-digest/), [CODEC](/fr/grammar/edge/codec/)
