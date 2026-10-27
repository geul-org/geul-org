---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO é o Value que contém um ponto sobre um corpo celeste, como um planeta ou satélite, por uma Reference de corpo celeste, latitude e longitude binary64, incerteza binary32 e a Reference da sua unidade."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO é o Value de coordenada que representa um ponto sobre um corpo celeste indicado (planeta, satélite, asteroide etc.) por latitude, longitude e incerteza. Código direto de Value `0x05`, família NUMERIC. É o formato [COORDINATE-EARTH](/pt/grammar/value/numeric/coordinate-earth/) (`0x04`) com uma Reference de corpo celeste (Globe) à frente, e as regras de latitude, longitude, incerteza e unidade são as de COORDINATE-EARTH.

## Layout

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Globe             1 registro Reference (Reference que aponta para o corpo celeste, Quantifier Identified)
Latitude          valor bruto de 4 WORD, IEEE 754 binary64 (graus)
Longitude         valor bruto de 4 WORD, IEEE 754 binary64 (graus)
Uncertainty       valor bruto de 2 WORD, IEEE 754 binary32 (na unidade Unit)
Unit              1 registro Reference, ou o marcador de posição 0x0000 ABSENT
```

## Interpretação e validade

- O Payload começa com o registro Globe. Globe é exatamente um registro Reference completo, com Quantifier Identified (`000`). Pode ser qualquer Reference que aponte para o corpo celeste: [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/) (corpo celeste com nome), [GEUL](/pt/grammar/reference/geul/), um [LOCAL](/pt/grammar/reference/local/) do mesmo documento (corpo celeste definido no documento), ou um corpo celeste de outro documento ([EXTERNAL-POINTER](/pt/grammar/reference/external-pointer/), [EXTERNAL-ISSUER](/pt/grammar/reference/external-issuer/)) etc. Os corpos celestes são incontáveis, e os que têm QID são uma parte deles.
- Depois do Globe vêm 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) e um registro Unit. O cursor depois de ler o Unit deve coincidir com o fim do registro.
- A Latitude é `-90 ≤ φ ≤ 90` e a Longitude é `-180 ≤ λ ≤ 360`. `(180, 360]` é permitido para conter tal como estão os valores dos sistemas de coordenadas de corpos celestes que contam a longitude de 0 a 360°. As demais regras (binary64, valores finitos, ordem dos eixos, significado de Uncertainty e Unit, representação de desconhecido) são as de COORDINATE-EARTH.
- O sistema de coordenadas segue a convenção de cada corpo celeste (latitude planetocêntrica, longitude leste ou oeste de 0 a 360° etc.). O sistema de coordenadas por corpo celeste é definido em um documento GEUL à parte.
- A Uncertainty em unidade de distância (metros etc.) é a distância sobre a superfície do corpo celeste. As unidades angulares (grau, minuto de arco, segundo de arco) são o raio angular de latitude e longitude, independentemente do tamanho do corpo celeste.
- Recomenda-se usar COORDINATE-EARTH para coordenadas da Terra (Q2). Escrever a Terra neste formato também não é invalid, e quem compara as ajusta como a mesma coordenada.
- O documento de especificação `0x0000/0x0000000000000805` do geul.org põe [CODEC](/pt/grammar/edge/codec/) BINARY-FLOAT (`0803`) nos campos de valor bruto Latitude, Longitude e Uncertainty, e os CODEC `0780` (qualquer Reference) e `0000` (ABSENT) no campo de registro Unit.

## Comprimento

- O total é 1 WORD de TAG + (TAG estendida de Length) + o registro Globe + 10 WORD + o registro Unit.
- Se o Globe tem 2 WORD (quando o QID cabe em 1 WORD) e o Unit é ABSENT, são 14 WORD, `LLLL=1101`, TAG `0E85`. Se o Unit for uma Reference (2 WORD ou mais), passa de 15 WORD e usa-se o comprimento estendido: TAG `0F05`, e na WORD seguinte o número total de WORD ([Registro e TAG WORD](/pt/grammar/record/)).

## Correspondência com o Wikidata

- Uma globecoordinate cujo globe não seja a Terra (Q2) escreve-se com este formato. Globe = WIKIDATA-QID (item do globe). A correspondência de latitude, longitude e precision → Uncertainty·Unit é a mesma de COORDINATE-EARTH (a precision é a resolução do registro em graus e, por isso, é transcrita tal como está, independentemente do tamanho do corpo celeste).
- Corpos celestes fora da Terra na amostra do Wikidata (cerca de 24 mil declarações de coordenadas): 23 casos, como Marte (Q111), Ceres (Q596), a Lua (Q405), Mercúrio (Q308) e Vênus (Q313). Os 41 casos com globe vazio não se convertem e preserva-se o texto original como UTF8-TEXT.

## Exemplo

Marte (Q111) 4.5, 137.4, incerteza desconhecida:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, desconhecida).
- Notação em texto: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

O mesmo ponto, com precision 0,1° (Unit grau Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110`, comprimento estendido), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `00A0 6EE6` (Q28390).

## Base normativa

- Significado: latitude, longitude e `u` da [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (quando o Unit é o metro). O único sistema de coordenadas registrado em `crs` da RFC 5870 é `wgs84`, por isso os corpos celestes fora da Terra são indicados pela Reference Globe do GEUL.
- Valores numéricos: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude) e binary32 (incerteza).

## Questões em aberto

1. Documento de sistema de coordenadas por corpo celeste: a definição de latitude (planetocêntrica ou planetográfica) e a direção e a faixa da longitude em cada corpo celeste.

## Páginas relacionadas

- [Value](/pt/grammar/value/), [COORDINATE-EARTH](/pt/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/), [GEUL](/pt/grammar/reference/geul/), [LOCAL](/pt/grammar/reference/local/)
