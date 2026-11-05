---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO é o Value de coordenada que representa um ponto sobre um corpo celeste indicado (planeta, lua, asteroide etc.) por latitude, longitude e incerteza."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `COORDINATE-GEO` (BIND `COORDINATE-GEO` do documento de especificação) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| Documento de especificação | `0x00000000/codecs/0x00000650/` (alvo do DECLARE `0650`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 5 |
| Kind | Value · família: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Reference do corpo celeste, latitude e longitude em binary64, incerteza em binary32 e o Reference da unidade dela |
| Lado Hugo | `value/numeric/coordinate-geo.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | registro | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | valor bruto de 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | valor bruto de 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | valor bruto de 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | registro | `000F` toda a seção 0 (curinga, Reference), `020F` toda a seção 1 (curinga, Reference), `040F` toda a seção 2 (curinga, Reference), `0000` ABSENT (campo opcional) |  |

COORDINATE-GEO é o Value de coordenada que representa um ponto sobre um corpo celeste indicado (planeta, lua, asteroide etc.) por latitude, longitude e incerteza. É o direct code de Value `0x065L`, família NUMERIC. É o formato de [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) com um Reference de corpo celeste (Globe) à frente, e as regras de latitude, longitude, incerteza e unidade são as mesmas de COORDINATE-EARTH.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Globe             1 registro Reference (Reference que aponta o corpo celeste, Quantifier Identified)
Latitude          4 WORD de valor bruto, IEEE 754 binary64 (graus)
Longitude         4 WORD de valor bruto, IEEE 754 binary64 (graus)
Uncertainty       2 WORD de valor bruto, IEEE 754 binary32 (na unidade Unit)
Unit              1 registro Reference, ou marcador de posição 0x0000 ABSENT
```

## Interpretação e validade {#해석과-유효성}

- O Payload começa com o registro Globe. Globe é exatamente um registro Reference completo, com Quantifier Identified. Pode-se usar qualquer Reference que aponte um corpo celeste: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (corpo celeste com nome), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md) do mesmo documento (corpo celeste definido dentro do documento), corpo celeste de outro documento ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md), [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)) etc. Os corpos celestes são incontáveis e os que têm QID são apenas parte deles.
- Depois de Globe vêm 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) e um registro Unit. O cursor que leu o Unit deve coincidir com o fim do registro.
- Latitude satisfaz `-90 ≤ φ ≤ 90` e Longitude satisfaz `-360 ≤ λ ≤ 360`. Admite-se um intervalo mais largo que o da Terra para guardar sem alteração tanto os valores dos sistemas de coordenadas celestes que contam a longitude de 0 a 360° (leste e oeste) quanto os valores negativos escritos no sentido oposto. O intervalo é o mesmo do modelo de dados globecoordinate do Wikidata (`LatLongValue` do Wikibase). `λ` e `λ ± 360` são o mesmo meridiano e o GEUL não os normaliza. As demais regras (binary64, valor finito, ordem dos eixos, significado de Uncertainty e Unit, representação de desconhecido) são as mesmas de COORDINATE-EARTH.
- O sistema de coordenadas segue a convenção de cada corpo celeste (latitude planetocêntrica, longitude leste ou oeste de 0 a 360° etc.). O sistema de coordenadas de cada corpo celeste é definido em documento GEUL à parte.
- Uma Uncertainty em unidade de distância (metro etc.) é uma distância sobre a superfície do corpo celeste. Unidades angulares (grau, minuto de arco, segundo de arco) são um raio angular de latitude e longitude, independente do tamanho do corpo celeste.
- Para coordenadas da Terra (Q2), recomenda-se usar COORDINATE-EARTH. Escrever a Terra neste formato também não é invalid, e quem compara a ajusta para a mesma coordenada.
- O documento de especificação `0x00000000/codecs/0x00000650` do geul.org coloca [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) nos campos de valor bruto Latitude, Longitude e Uncertainty, e coloca CODEC `000F`, `020F`, `040F` (qualquer Reference) e `0000` (ABSENT) no campo de registro Unit.

## Comprimento {#길이}

- O total é 1 WORD de TAG + (TAG de extensão de Length) + registro Globe + 10 WORD + registro Unit.
- Se Globe tem 2 WORD (quando o QID cabe em 1 WORD) e Unit é ABSENT, o total é 14 WORD, `LLLL=1101`, TAG `065D`. Se Unit é um Reference (2 WORD ou mais), passa de 15 WORD e usa-se o comprimento estendido: TAG `065E`, e a WORD seguinte traz o número total de WORD ([Registro e TAG WORD](../record.md)).

## Correspondência com o Wikidata {#위키데이터-대응}

- Um globecoordinate cujo globe não é a Terra (Q2) é escrito neste formato. Globe = WIKIDATA-QID (item do globe). A correspondência de latitude, longitude e precision → Uncertainty e Unit é a mesma de COORDINATE-EARTH (a precision é a resolução de registro em graus, então é transportada tal qual, independentemente do tamanho do corpo celeste).
- Corpos celestes fora da Terra na amostra do Wikidata (cerca de 24 mil declarações de coordenada): 23 casos, como Marte (Q111), Ceres (Q596), Lua (Q405), Mercúrio (Q308) e Vênus (Q313). Os 41 casos com globe vazio não são convertidos e o texto original é preservado em UTF8-TEXT.

## Exemplo {#예시}

Marte (Q111) 4.5, 137.4, incerteza desconhecida:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, desconhecida).
- Notação em texto: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

O mesmo ponto, com precision 0.1° (Unit grau Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`, comprimento estendido), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `0141 6EE6` (Q28390).

## Base normativa {#표준-근거}

- Significado: latitude, longitude e `u` do [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (quando Unit é o metro). O único sistema de coordenadas registrado em `crs` do RFC 5870 é `wgs84`, então corpos celestes fora da Terra são indicados pelo Reference Globe do GEUL.
- Numérico: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude), binary32 (incerteza).
- Intervalo da longitude: `-360 ≤ λ ≤ 360` do [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo), o modelo de dados globecoordinate do Wikidata.

## Problemas em aberto {#열린-문제}

1. Documentos de sistema de coordenadas por corpo celeste: definição de latitude (planetocêntrica ou planetográfica) e sentido e intervalo da longitude em cada corpo celeste.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000650/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
