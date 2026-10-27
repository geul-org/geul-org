---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT est une Value qui contient une chaîne UTF-8 sans langue. Elle emploie la paire de codes d'octets pair/impair 0x40/0x41."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT est une Value qui contient une suite d'octets UTF-8 valide au sens de la RFC 3629. Elle sert aux chaînes sans langue comme identifiants, codes et noms de fichiers.

## Disposition

- Code : code direct de Value `0x40` (nombre d'octets pair) et `0x41` (impair). Famille TEXT.
- Le nombre d'octets est fixé par le bit de poids faible du Codec et le nombre de WORD du Payload. C'est `2 × nombre de WORD du Payload − bit de poids faible`, sans Byte Count ([Value](/fr/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er ... Nème          UTF-8 bytes / final zero padding
```

## Interprétation et validité

- La suite d'octets doit être de l'UTF-8 well-formed à forme la plus courte conforme à la grammaire de la RFC 3629. Le résultat du décodage ne contient que des Unicode scalar value de `U+0000..U+10FFFF`, sans la plage des surrogates `U+D800..U+DFFF`.
- La RFC 3629 décrit le traitement de la signature U+FEFF de tête selon le contexte. Le profil canonique de GEUL y ajoute l'interdiction de la suite d'octets BOM UTF-8 `EF BB BF` en tête de Payload. Un U+FEFF à un autre endroit est un caractère et non un BOM, donc cette règle ne l'interdit pas.
- La normalisation Unicode n'est pas imposée. On conserve telle quelle la suite de scalar du texte original décodé.
- Une suite d'octets UTF-8 valide se place dans le Payload sans conversion. Dans un WORD, l'octet de poids fort vient en premier. Si le nombre d'octets est impair (code impair), l'octet de poids faible inutilisé du dernier WORD doit être `00`.
- Le nombre de WORD du Payload est `ceil(nombre d'octets/2)`. Pour un code impair, si l'octet de poids faible du dernier WORD n'est pas `00`, on rejette.

## Fondement normatif

- L'étendue des scalar d'UTF-8, les suites d'octets well-formed et le sens du traitement du BOM suivent la [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- L'interdiction du BOM, la paire de codes pair/impair, le zero padding, le TAG et la Length de GEUL et la disposition en WORD de 16 bits sont les règles de cadrage canonique de ce format.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Length](/fr/grammar/record/)).
- Une chaîne de 0 octet s'écrit comme un enregistrement de 1 WORD du code pair (le TAG WORD seul) ([Value](/fr/grammar/value/)).

## Exemple

- `A` (`41`) fait 1 octet (impair), donc `UTF8-TEXT-ODD` (`0x41`), Payload `4100`, 2 WORD au total, `LLLL=0001`. L'ensemble est `08C1 4100`.
- La chaîne vide est `0840` (`UTF8-TEXT-EVEN`, TAG WORD seul), 1 WORD.
