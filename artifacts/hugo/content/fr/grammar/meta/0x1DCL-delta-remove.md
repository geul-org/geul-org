---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Dans un diff (DELTA-BASE), indique les LOCAL ID (Edge Id) des enregistrements à retirer du BODY de l'instantané de base (« suppression de l'article X »)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DELTA-REMOVE` (BIND `DELTA-REMOVE` du document de spécification) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| Document de spécification | `0x00000000/codecs/0x00001DC0/` (cible du DECLARE `1DC0`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 28 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Liste des LOCAL ID (Edge Id) à retirer du BODY de base dans un diff |
| Côté Hugo | `meta/lineage/delta-remove.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | valeur brute du reste (`0xFFFF`) |  |  |

Dans un diff ([DELTA-BASE](0x1DBL-delta-base.md)), indique les LOCAL ID (Edge Id) des enregistrements à retirer du BODY de l'instantané de base (“suppression de l'article X”).

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[TAG d'extension Length]
LOCAL ID à supprimer    Enregistrement Reference LOCAL × 1 ou plus
```

- Codec : Meta `0x1DCL`, classe lignée
- Payload : un ou plusieurs enregistrements Reference [LOCAL](../reference/0x005L-local.md)
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- On ne le place que dans un document qui a `DELTA-BASE`.
- Chaque LOCAL ID doit être un Edge Id présent dans le BODY de l'instantané de base. Sinon, c'est invalid. Mettre deux fois le même ID est invalid.
- Remettre le même Edge Id dans le BODY du même diff est invalid (on ne peut pas supprimer et réviser à la fois).
- Un LOCAL ID supprimé n'est pas réattribué à un autre objet dans les versions suivantes ([révision](../document.md#개정)).
- L'absence d'un enregistrement dans le BODY du diff signifie « inchangé ». C'est pourquoi la suppression ne s'exprime que par ce Meta.
- On n'écrit pas les Edge de HEAD (le [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) du document entier et son QUALIFIER). Le HEAD est remplacé en bloc par le HEAD du diff ([stockage par diff](../document.md#diff-저장)).

## Exemple {#예시}

Suppression des LOCAL `#7` et `#12` :

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4` (Meta `0x1DCL`, `LLLL=0100`, 5 WORD), Reference LOCAL `0051 0007`, `0051 000C`.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001DC0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
