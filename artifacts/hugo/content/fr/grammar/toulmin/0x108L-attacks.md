---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS est le Codec LINK qui écrit une relation du graphe TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS est le Codec LINK qui écrit une relation du graphe TOULMIN. Sens : relation d'attaque. Le verdict de l'attaquant réduit progressivement le verdict de la cible de la force d'attaque (0~1, 1 par défaut).

| Élément | Valeur |
|---|---|
| Nom | `ATTACKS` (BIND du document de spécification `ATTACKS`) |
| TAG ID | `0x108L` |
| Codec ID | `0x00001080` |
| Document de spécification | `0x00000000/codecs/0x00001080/` (cible de DECLARE `1080`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 8 |
| Kind | Edge · famille : TOULMIN, groupe : relation, disposition : LINK |
| TAG WORD | `0001 0000 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Relation d'attaque. Le verdict de l'attaquant réduit progressivement le verdict de la cible de la force d'attaque (0~1, 1 par défaut) |
| Côté Hugo | `edge/toulmin/link.md` |

## Disposition {#레이아웃}

La disposition est [LINK](_index.md#link) (ID, src, dst, flags, champs conditionnels, SPAN).

| Élément | Valeur |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | règle → règle. Réduit progressivement le verdict de la force d'attaque |

- dst est le REF d'un nœud.
- F_FORCE (force d'attaque) n'est employé que par ce Codec. Voir [Force d'attaque](#공격-세기) ci-dessous.
- Les champs communs (ID, REF, SPAN) et les règles numériques suivent [TOULMIN](_index.md#공통-필드).

## Force d'attaque {#공격-세기}

La force d'attaque (Force) indique avec quelle intensité une arête ATTACKS attaque sa cible. La plage est 0~1, et vaut 1 s'il n'y a pas de F_FORCE.

- Dans le verdict, on multiplie la contribution `(v+1)/2` de la valeur de verdict v de l'attaquant par la force F. Une attaque de réfutation (COUNTER) entre dans le terme du dénominateur `F·(v+1)/2`, une attaque d'exception (EXCEPT) dans la porte `Π(1 − F·(v+1)/2)`. Si F vaut 0, l'attaque n'a aucun effet sur le verdict.
- La valeur suit les règles numériques de [TOULMIN](_index.md#수치). L'encodeur supprime les 0 finals du coefficient (0,5 s'écrit `C=5, E=−1`, 1,0 s'écrit `C=1, E=0`). Le décodeur accepte jusqu'à 4 décimales.
- Une surface sans force (`don't X when Y`, `` `Y` 면 `X` 는 무효다`` (si Y, X est nul)) éteint F_FORCE.
- Une surface avec force (`` `Y` 면 `X` 를 0.5의 세기로 공격한다`` (si Y, attaquer X avec une force de 0,5)) allume F_FORCE et y met la valeur. Même si l'on écrit 1, comme dans `1.0의 세기로` (avec une force de 1,0), F_FORCE est allumé et contient 1. La surface du texte original est ainsi restituée telle quelle.
- La force d'attaque est un axe différent de la rigueur du nœud (Strict, Defeasible, Defeater). La rigueur est attachée au nœud, la force d'attaque à l'arête ATTACKS.

### Exemple de force d'attaque {#공격-세기-예시}

`` `Y` 면 `X` 를 0.5의 세기로 공격한다`` (si Y, attaquer X avec une force de 0,5). Edge Id 5, l'attaquant Y a l'Edge Id 3, la cible X l'Edge Id 2, largeur de SPAN 1 WORD.

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), 14 WORD au total
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, attaquant)
0051 0002             dst     LOCAL 2 (X, cible)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    octet de début 0x40, nombre d'octets 0x1A
```

La même arête sans force a des flags à `0000` et pas de champ F_FORCE. Le TAG WORD est `1089` (10 WORD au total).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1080`). Les champs conditionnels de la disposition LINK et la largeur de SPAN fixée par SOURCE ne peuvent pas être déclarés par FIELD ; la déclaration des champs est donc un problème ouvert ([TOULMIN](_index.md#열린-문제)).

## Pages liées {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001080/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
