---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS ist ein LINK-Codec, der eine Relation des TOULMIN-Graphen schreibt. Bedeutung: Angriffsrelation. Die Beurteilung des Angreifers senkt die Beurteilung des Ziels schrittweise um die Angriffsstärke (0~1, Standard 1).

| Eigenschaft | Wert |
|---|---|
| Name | `ATTACKS` (BIND `ATTACKS` des Spezifikationsdokuments) |
| TAG ID | `0x108L` |
| Codec ID | `0x00001080` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001080/` (DECLARE-Ziel `1080`) |
| Abschnitt | 8 `1000` (Edge TOULMIN), Offset im Abschnitt C = 8 |
| Kind | Edge · Familie: TOULMIN, Gruppe: Relation, Layout: LINK |
| TAG WORD | `0001 0000 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Angriffsrelation. Die Beurteilung des Angreifers senkt die Beurteilung des Ziels schrittweise um die Angriffsstärke (0~1, Standard 1) |
| Hugo-Seite | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Das Layout ist [LINK](_index.md#link) (ID, src, dst, flags, bedingte Felder, SPAN).

| Eigenschaft | Wert |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | Regel → Regel. Senkt die Beurteilung schrittweise um die Angriffsstärke |

- dst ist der REF eines Knotens.
- F_FORCE (Angriffsstärke) verwendet nur dieser Codec. Siehe [Angriffsstärke](#공격-세기) unten.
- Gemeinsame Felder (ID, REF, SPAN) und numerische Regeln folgen [TOULMIN](_index.md#공통-필드).

## Angriffsstärke {#공격-세기}

Die Angriffsstärke (Force) gibt an, wie stark eine einzelne ATTACKS-Kante das Ziel angreift. Der Bereich ist 0~1; fehlt F_FORCE, gilt 1.

- In der Beurteilung wird der Beitrag `(v+1)/2` der Angreifer-Beurteilung v mit der Stärke F multipliziert. Der Angriff einer Gegenbehauptung (COUNTER) geht als Nennerterm `F·(v+1)/2` ein, der Angriff einer Ausnahme (EXCEPT) als Gate `Π(1 − F·(v+1)/2)`. Ist F gleich 0, hat der Angriff keinen Einfluss auf die Beurteilung.
- Der Wert folgt den [TOULMIN](_index.md#수치)-Regeln für Zahlen. Der Encoder entfernt abschließende Nullen des Koeffizienten (0.5 ist `C=5, E=−1`, 1.0 ist `C=1, E=0`). Der Decoder akzeptiert bis zu vier Dezimalstellen.
- Eine Oberfläche ohne Stärkeangabe (`don't X when Y`, `` `Y` 면 `X` 는 무효다``) schaltet F_FORCE aus.
- Eine Oberfläche mit Stärkeangabe (`` `Y` 면 `X` 를 0.5의 세기로 공격한다``) schaltet F_FORCE ein und speichert den Wert. Auch eine ausdrücklich angegebene 1 wie in `1.0의 세기로` schaltet F_FORCE ein und speichert 1. So kommt die ursprüngliche Oberfläche unverändert zurück.
- Die Angriffsstärke ist eine andere Achse als die Stärke des Knotens (Strict, Defeasible, Defeater). Die Knotenstärke gehört zum Knoten, die Angriffsstärke zur ATTACKS-Kante.

### Beispiel für die Angriffsstärke {#공격-세기-예시}

`` `Y` 면 `X` 를 0.5의 세기로 공격한다`` (Y greift X mit der Stärke 0,5 an). Edge Id 5, Angreifer Y ist Edge Id 3, Ziel X ist Edge Id 2, SPAN-Breite 1 WORD.

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), insgesamt 14 WORD
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, Angreifer)
0051 0002             dst     LOCAL 2 (X, Ziel)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    Startbyte 0x40, Bytezahl 0x1A
```

Dieselbe Kante ohne Stärkeangabe hat flags `0000` und kein F_FORCE-Feld. Das TAG WORD ist `1089` (insgesamt 10 WORD).

## Codec-Dokument {#코덱-문서}

Das Codec-Dokument enthält DECLARE (Ziel `1080`). Die bedingten Felder des LINK-Layouts und die vom SOURCE bestimmte SPAN-Breite lassen sich nicht mit FIELD deklarieren; die Felddeklaration ist daher ein offenes Problem ([TOULMIN](_index.md#열린-문제)).

## Verwandte Seiten {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001080/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
