---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Enregistrement qui ferme le document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `END` (BIND `END` du document de spécification) |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| Document de spécification | `0x00000000/codecs/0x00001C40/` (cible du DECLARE `1C40`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 4 |
| Kind | Meta · classe : structure |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | 1 WORD. Ferme le document. |
| Côté Hugo | `meta/structure/end.md` |

## Champs (document de spécification) {#필드-규격-문서}

Le document de spécification ne contient aucun FIELD. Aucun champ de Payload n'est déclaré.

C'est l'enregistrement qui ferme le document.

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[TAG d'extension Length]
```

- Codec : Meta `0x1C4L`, classe structure
- Payload : aucun (1 WORD)
- Nombre : un par document, tout à la fin

## Interprétation et validité {#해석과-유효성}

- Obligatoire. Sa position se vérifie grâce à la longueur de [DOC](0x1C0L-doc-1word.md) (`DOC-*`).
- Si l'entrée s'arrête sans END, le document est tronqué. Considérer ou non le contenu d'un document tronqué comme valide relève de la politique du décodeur.
- Rien ne vient après.

## Exemple {#예시}

- `0x1C40`

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001C40/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
