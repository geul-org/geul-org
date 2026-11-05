---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS es el Codec LINK que escribe una relación del grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS es el Codec LINK que escribe una relación del grafo TOULMIN. Significado: relación de ataque. El veredicto del atacante reduce gradualmente el del destino según la fuerza de ataque (0 a 1, por defecto 1).

| Elemento | Valor |
|---|---|
| Nombre | `ATTACKS` (BIND `ATTACKS` del documento de especificación) |
| TAG ID | `0x108L` |
| Codec ID | `0x00001080` |
| Documento de especificación | `0x00000000/codecs/0x00001080/` (destino de DECLARE `1080`) |
| Sección | 8 `1000` (Edge TOULMIN), desplazamiento dentro de la sección C = 8 |
| Kind | Edge · familia: TOULMIN, grupo: relación, layout: LINK |
| TAG WORD | `0001 0000 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descripción del índice | relación de ataque. El veredicto del atacante reduce gradualmente el del destino según la fuerza de ataque (0 a 1, por defecto 1) |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

El layout es [LINK](_index.md#link) (ID, src, dst, flags, campos condicionales, SPAN).

| Elemento | Valor |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | regla → regla. Reduce gradualmente el veredicto según la fuerza de ataque |

- dst es el REF de un nodo.
- Solo este Codec usa F_FORCE (fuerza de ataque). Véase [Fuerza de ataque](#공격-세기) más abajo.
- Los campos comunes (ID, REF, SPAN) y las reglas numéricas siguen a [TOULMIN](_index.md#공통-필드).

## Fuerza de ataque {#공격-세기}

La fuerza de ataque (Force) indica con cuánta intensidad ataca una arista ATTACKS a su destino. El rango es de 0 a 1, y es 1 si no hay F_FORCE.

- En el veredicto, la contribución `(v+1)/2` del valor de veredicto v del atacante se multiplica por la fuerza F. Un ataque de refutación (COUNTER) entra como el término del denominador `F·(v+1)/2`; uno de excepción (EXCEPT), como la compuerta `Π(1 − F·(v+1)/2)`. Si F es 0, el ataque no afecta al veredicto.
- El valor sigue las reglas numéricas de [TOULMIN](_index.md#수치). El codificador elimina los ceros finales del coeficiente (0.5 es `C=5, E=−1`; 1.0 es `C=1, E=0`). El decodificador acepta hasta 4 decimales.
- Las formas de superficie que no escriben la fuerza (`don't X when Y`, `` `Y` 면 `X` 는 무효다`` («si Y, X queda sin efecto»)) dejan F_FORCE apagado.
- Las formas de superficie que sí escriben la fuerza (`` `Y` 면 `X` 를 0.5의 세기로 공격한다`` («si Y, ataca a X con fuerza 0.5»)) activan F_FORCE y contienen ese valor. Aunque se escriba 1, como en `1.0의 세기로` («con fuerza 1.0»), F_FORCE se activa y contiene 1. Así la forma de superficie original se recupera tal cual.
- La fuerza de ataque es un eje distinto de la fortaleza del nodo (Strict, Defeasible, Defeater). La fortaleza se asigna al nodo; la fuerza de ataque, a la arista ATTACKS.

### Ejemplo de fuerza de ataque {#공격-세기-예시}

`` `Y` 면 `X` 를 0.5의 세기로 공격한다`` («si Y, ataca a X con fuerza 0.5»). Edge Id 5, el atacante Y es el Edge Id 3, el destino X es el Edge Id 2, ancho de SPAN 1 WORD.

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), 14 WORD en total
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, atacante)
0051 0002             dst     LOCAL 2 (X, destino)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    byte de inicio 0x40, número de bytes 0x1A
```

La misma arista sin fuerza escrita tiene flags `0000` y no lleva campo F_FORCE. Su TAG WORD es `1089` (10 WORD en total).

## Documento del Codec {#코덱-문서}

El documento del Codec contiene DECLARE (destino `1080`). Los campos condicionales del layout LINK y el ancho de SPAN que fija SOURCE no se pueden declarar con FIELD, por lo que la declaración de campos es un problema abierto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original del documento de especificación {#규격-문서-원문}

Así se ve el documento de especificación `0x00000000/codecs/0x00001080/latest.geul` leído con `geul show` (hexadecimal en mayúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
