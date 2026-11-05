---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH é o Value de coordenada que representa um ponto sobre a Terra por latitude, longitude e incerteza."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `COORDINATE-EARTH` (BIND `COORDINATE-EARTH` do documento de especificação) |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| Documento de especificação | `0x00000000/codecs/0x00000640/` (alvo do DECLARE `0640`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 4 |
| Kind | Value · família: NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | latitude e longitude da Terra (WGS 84) em binary64, incerteza em binary32 e o Reference da unidade dela (ABSENT = desconhecida) |
| Lado Hugo | `value/numeric/coordinate-earth.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | valor bruto de 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | valor bruto de 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | valor bruto de 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | registro | `000F` toda a seção 0 (curinga, Reference), `020F` toda a seção 1 (curinga, Reference), `040F` toda a seção 2 (curinga, Reference), `0000` ABSENT (campo opcional) |  |

COORDINATE-EARTH é o Value de coordenada que representa um ponto sobre a Terra por latitude, longitude e incerteza. É o direct code de Value `0x064L`, família NUMERIC. O significado é o mesmo de `geo:latitude,longitude;u=incerteza` do [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI; sistema de coordenadas WGS 84), mas guardado como valores numéricos de largura fixa, não como cadeia de caracteres. A incerteza é escrita junto com a unidade. Coordenadas de corpos celestes fora da Terra usam [COORDINATE-GEO](0x065L-coordinate-geo.md) (`0x065L`).

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD de valor bruto, IEEE 754 binary64 (graus)
Longitude         4 WORD de valor bruto, IEEE 754 binary64 (graus)
Uncertainty       2 WORD de valor bruto, IEEE 754 binary32 (na unidade Unit)
Unit              1 registro Reference, ou marcador de posição 0x0000 ABSENT
```

## Interpretação e validade {#해석과-유효성}

- O Payload é Latitude de 4 WORD, Longitude de 4 WORD e Uncertainty de 2 WORD, seguidos de exatamente um registro Unit. O cursor que leu o Unit deve coincidir com o fim do registro.
- O sistema de coordenadas é WGS 84 (o `crs=wgs84` padrão do RFC 5870).
- Latitude e Longitude são IEEE 754 binary64 formados pela concatenação das WORD do Payload em ordem big-endian (mesma disposição de bits do binary64 de [BINARY-FLOAT](0x063L-binary-float.md)). A unidade é o grau (°).
  - Devem ser valores finitos. NaN e ±Infinity são invalid.
  - Latitude satisfaz `-90 ≤ φ ≤ 90` (norte positivo) e Longitude satisfaz `-180 ≤ λ ≤ 180` (leste positivo).
  - A ordem dos eixos é latitude, longitude (como no RFC 5870 e na ISO 6709). Não é a ordem x (longitude), y (latitude) de WKB e GeoJSON.
- Uncertainty é um IEEE 754 binary32 formado pela concatenação de 2 WORD em big-endian (mesma disposição de bits do binary32 de BINARY-FLOAT). Significa que a posição real está dentro desse raio, e o valor é lido na unidade Unit.
  - Deve ser finito e maior ou igual a `+0`. Negativo, `-0` (`8000 0000`), NaN e ±Infinity são invalid.
  - `0` (quando há Unit): coordenada exata. Vale o mesmo em qualquer unidade.
- Unit é o Reference que aponta a unidade de Uncertainty. Não aceita Value. O Quantifier é Identified.
  - Recomenda-se usar um item de unidade do Wikidata, [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md): grau Q28390, minuto de arco Q209426, segundo de arco Q829073, metro Q11573, milímetro Q174789 etc. Uma unidade sem QID é indicada por outro Reference (LOCAL, GEUL etc.). Se vários Reference apontam a mesma unidade, o QID é a forma canônica.
  - Se Unit é o metro (Q11573), Uncertainty equivale ao `u` do RFC 5870.
- **Desconhecida**: usa-se [ABSENT](../slot-marker.md) (`0x0000`) na posição de Unit e Uncertainty fica em `+0` (`0000 0000`). É o mesmo caso de omitir `u` no RFC 5870. Se for ABSENT e Uncertainty não for `+0`, é invalid (a representação é fixada em uma só).
- A altitude não é guardada. Se necessária, define-se em outro formato. A altitude do Wikidata não foi usada na amostra (0/23.066) e, se houver valor, não se converte e preserva-se o texto original em UTF8-TEXT.
- Para coordenadas da Terra, recomenda-se usar este formato. Uma coordenada que indique a Terra (Q2) em COORDINATE-GEO também não é invalid, e quem compara a ajusta para a mesma coordenada.
- O documento de especificação `0x00000000/codecs/0x00000640` do geul.org coloca [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) nos campos de valor bruto Latitude, Longitude e Uncertainty (4 WORD = binary64, 2 WORD = binary32) e coloca CODEC `000F`, `020F`, `040F` (qualquer Reference) e `0000` (ABSENT) no campo de registro Unit.

## Comprimento {#길이}

- O total é 1 WORD de TAG + 10 WORD + o registro Unit.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `064B` (`LLLL=1011`) |
| Quando o QID cabe em 1 WORD (2 WORD, ex.: grau Q28390) | 13 WORD | `064C` (`LLLL=1100`) |
| Quando o QID tem 2 WORD (3 WORD, ex.: minuto de arco Q209426) | 14 WORD | `064D` (`LLLL=1101`) |
| Registro Unit de 4 WORD ou mais | 15 WORD ou mais | comprimento estendido ([Registro e TAG WORD](../record.md)) |

- Não se define par de Codec par/ímpar.

## Correspondência com o Wikidata {#위키데이터-대응}

globecoordinate do Wikidata: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | este formato (Terra). Outros corpos celestes usam COORDINATE-GEO |
| latitude, longitude | binary64 tal qual (o valor do Wikidata já é binary64, então não há perda) |
| precision (graus) | Uncertainty e Unit. Ver «Precisão» abaixo |
| precision null ou ausente | Unit = ABSENT, Uncertainty = `+0` (desconhecida) |
| altitude | descartada (sempre null) |

- A precision do Wikidata não é erro de medição, mas a **resolução de registro** (em quantos graus, minutos ou segundos a coordenada foi escrita). A Uncertainty do GEUL transporta esse valor sem alterá-lo. Não é um raio que some erros de medição ou do sistema de coordenadas.

### Precisão {#정밀도}

A precision é transportada sem conversão. Escolhe-se a primeira unidade, entre grau, minuto de arco e segundo de arco, que reconstitui a notação original.

| precision original (exemplo) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k graus) | grau Q28390 | binary32 desse valor |
| notação decimal curta como `0.0166667` | grau Q28390 | binary32 desse valor |
| `0.016666666666667` (1/60°) | minuto de arco Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | segundo de arco Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | segundo de arco Q829073 | `0.1` |

- Conversão direta: na ordem grau, minuto de arco (×60), segundo de arco (×3600), toma-se como Uncertainty o binary32 mais próximo do valor da precision multiplicado pelo número de unidades, e usa-se a primeira unidade cuja conversão inversa abaixo devolve exatamente o original da precision.
- Conversão inversa: divide-se a notação decimal mais curta de Uncertainty (o número mais curto que se relê como esse binary32) pelo número de unidades para voltar a graus, e escreve-se do modo como o Wikibase grava no dump (14 algarismos significativos; abaixo de `1e-4`, notação exponencial como `1.0e-6` e `2.7777777777778e-5`). O DB de carga (jsonb) guarda isso em notação decimal como `0.0000010` e `0.000027777777777778`.
- Se nenhuma unidade devolve o original (notação de 17 algarismos significativos como `0.0002777777777777778`, valores atípicos que parecem valores calculados etc.), a coordenada inteira não é convertida e o texto original é preservado em UTF8-TEXT. O mesmo vale para precision negativa e para valores com o corpo celeste vazio.
- Amostra Q1–Q10000 do Wikidata (7.026 declarações de coordenada, 6.824 com precision): 5.933 tiveram o original devolvido (86,9%; grau 4.104, segundo de arco 1.370, minuto de arco 459). Dos 891 que não foram devolvidos, 753 pertencem à série 1/3600 e 1/60 em notação de 17 algarismos significativos.

## Exemplo {#예시}

Berlim 52.516666666667, 13.383333333333, precision 1/60° (1 minuto de arco):

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0142 0003 3212` (WIKIDATA-QID Q209426, minuto de arco).
- Notação em texto: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

O mesmo ponto com incerteza desconhecida: `064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Base normativa {#표준-근거}

- Significado: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — ordem latitude, longitude, incerteza `u` (metros), sistema de coordenadas padrão WGS 84. Se Unit é o metro, Uncertainty = `u`.
- Numérico: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude), binary32 (incerteza).
- Ordem e intervalo dos eixos: ISO 6709 (Standard representation of geographic point location by coordinates).
- Unidade: itens de unidade do Wikidata (QID). A disposição de largura fixa, o campo Unit e a representação de desconhecido são regras do GEUL.

## Problemas em aberto {#열린-문제}

1. Altitude.
2. O formato que preserva o texto original da cadeia ISO 6709 (COORDINATE-ISO6709) será definido quando surgir uso.
3. Como transportar sem perda a notação de 17 algarismos significativos da precision do Wikidata (cerca de 11% da amostra).

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [BINARY-FLOAT](0x063L-binary-float.md), [marcador de posição](../slot-marker.md)
- O formato de Issuer [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) é um ponto bidimensional genérico que deixa o sistema de coordenadas, a unidade e o significado dos eixos para o contexto externo, enquanto este formato é uma coordenada geográfica sobre a Terra.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000640/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000064000000000
BODY
#1 DECLARE 0x0640
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "COORDINATE-EARTH"
#6 BIND #2 "latitude"
#7 BIND #3 "longitude"
#8 BIND #4 "uncertainty"
#9 CODEC #2 0x0630
#10 CODEC #3 0x0630
#11 CODEC #4 0x0630
#12 FIELD #1 record
#13 BIND #12 "unit"
#14 CODEC #12 0x000F
#16 CODEC #12 0x020F
#17 CODEC #12 0x040F
#15 CODEC #12 0x0000
```
