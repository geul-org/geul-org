---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH é o Value que contém um ponto na Terra (WGS 84) como latitude e longitude binary64, incerteza binary32 e a Reference da unidade da incerteza."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH é o Value de coordenada que representa um ponto na Terra por latitude, longitude e incerteza. Código direto de Value `0x04`, família NUMERIC. O significado é igual ao de `geo:latitude,longitude;u=incerteza` da [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI) (sistema de coordenadas WGS 84), e é contido não como cadeia de caracteres, mas como valores numéricos de largura fixa. A incerteza leva escrita a sua unidade. As coordenadas de corpos celestes fora da Terra escrevem-se com [COORDINATE-GEO](/pt/grammar/value/numeric/coordinate-geo/) (`0x05`).

## Layout

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          valor bruto de 4 WORD, IEEE 754 binary64 (graus)
Longitude         valor bruto de 4 WORD, IEEE 754 binary64 (graus)
Uncertainty       valor bruto de 2 WORD, IEEE 754 binary32 (na unidade Unit)
Unit              1 registro Reference, ou o marcador de posição 0x0000 ABSENT
```

## Interpretação e validade

- O Payload é Latitude de 4 WORD, Longitude de 4 WORD e Uncertainty de 2 WORD, seguidos de exatamente um registro Unit. O cursor depois de ler o Unit deve coincidir com o fim do registro.
- O sistema de coordenadas é o WGS 84 (o `crs=wgs84` padrão da RFC 5870).
- Latitude e Longitude são IEEE 754 binary64 formado pelas WORDs do Payload concatenadas em ordem big-endian (mesma disposição de bits do binary64 de [BINARY-FLOAT](/pt/grammar/value/numeric/binary-float/)). A unidade é o grau (°).
  - Devem ser valores finitos. NaN e ±Infinity são invalid.
  - A Latitude é `-90 ≤ φ ≤ 90` (norte positivo) e a Longitude é `-180 ≤ λ ≤ 180` (leste positivo).
  - A ordem dos eixos é latitude, longitude (como na RFC 5870 e na ISO 6709). Não é a ordem x (longitude), y (latitude) do WKB e do GeoJSON.
- A Uncertainty é IEEE 754 binary32 formado por 2 WORD concatenadas em big-endian (mesma disposição de bits do binary32 de BINARY-FLOAT). Significa que a posição real está dentro desse raio, e o valor se lê na unidade Unit.
  - Deve ser finita e `+0` ou maior. Negativo, `-0` (`8000 0000`), NaN e ±Infinity são invalid.
  - `0` (quando há Unit): coordenada exata. É igual em qualquer unidade em que se escreva.
- Unit é uma Reference que aponta para a unidade da Uncertainty. Não aceita Value. O Quantifier é Identified (`000`).
  - Recomenda-se usar o item de unidade do Wikidata [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/): grau Q28390, minuto de arco Q209426, segundo de arco Q829073, metro Q11573, milímetro Q174789 etc. Uma unidade sem QID é apontada por outra Reference (LOCAL, GEUL etc.). Se várias Reference apontam para a mesma unidade, o QID é a forma canônica.
  - Se o Unit for o metro (Q11573), a Uncertainty é igual ao `u` da RFC 5870.
- **Desconhecida**: na posição de Unit escreve-se [ABSENT](/pt/grammar/reference/slot-marker/) (`0x0000`) e a Uncertainty fica `+0` (`0000 0000`). É igual a omitir `u` na RFC 5870. Se for ABSENT e a Uncertainty não for `+0`, é invalid (fixa-se uma única representação).
- A altitude não é contida. Se for necessária, define-se por um formato à parte. A altitude do Wikidata não foi usada na amostra (0/23.066), e, se houver valor, não se converte e preserva-se o texto original como UTF8-TEXT.
- Recomenda-se usar este formato para coordenadas da Terra. Uma coordenada que escreva a Terra (Q2) em COORDINATE-GEO também não é invalid, e quem compara as ajusta como a mesma coordenada.
- O documento de especificação `0x0000/0x0000000000000804` do geul.org põe [CODEC](/pt/grammar/edge/codec/) BINARY-FLOAT (`0803`) nos campos de valor bruto Latitude, Longitude e Uncertainty (4 WORD = binary64, 2 WORD = binary32), e põe os CODEC `0780` (qualquer Reference) e `0000` (ABSENT) no campo de registro Unit.

## Comprimento

- O total é 1 WORD de TAG + 10 WORD + o registro Unit.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| quando o QID cabe em 1 WORD (2 WORD, por exemplo grau Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| quando o QID tem 2 WORD (3 WORD, por exemplo minuto de arco Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| registro Unit de 4 WORD ou mais | 15 WORD ou mais | comprimento estendido ([Registro e TAG WORD](/pt/grammar/record/)) |

- Não há par de Codecs par/ímpar.

## Correspondência com o Wikidata

globecoordinate do Wikidata: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | este formato (a Terra). Outros corpos celestes usam COORDINATE-GEO |
| latitude, longitude | binary64 tal como estão (o valor do Wikidata já é binary64, então não há perda) |
| precision (graus) | Uncertainty e Unit. Veja "Precisão" abaixo |
| precision null ou ausente | Unit = ABSENT, Uncertainty = `+0` (desconhecida) |
| altitude | descarta-se (é sempre null) |

- A precision do Wikidata não é um erro de medição, e sim a **resolução do registro** (em quantos graus, minutos ou segundos se escreveu a coordenada). A Uncertainty do GEUL transcreve esse valor sem alterá-lo. Não é um raio que some erros de medição e do sistema de coordenadas.

### Precisão

A precision é transcrita sem conversão. Escolhe-se a primeira unidade, entre grau, minuto de arco e segundo de arco, que restaure a notação original.

| precision original (exemplo) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k graus) | grau Q28390 | o binary32 desse valor |
| notação decimal curta como `0.0166667` | grau Q28390 | o binary32 desse valor |
| `0.016666666666667` (1/60°) | minuto de arco Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | segundo de arco Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0,1″) | segundo de arco Q829073 | `0.1` |

- Conversão direta: na ordem grau, minuto de arco (×60), segundo de arco (×3600), toma-se como Uncertainty o binary32 mais próximo do valor da precision multiplicado pelo número de unidades, e usa-se a primeira unidade em que a conversão inversa abaixo devolva exatamente a notação original da precision.
- Conversão inversa: divide-se a notação decimal mais curta da Uncertainty (o número mais curto que se relê como esse binary32) pelo número de unidades, converte-se em graus e escreve-se do modo que o Wikibase escreve no dump (14 algarismos significativos; abaixo de `1e-4`, notação exponencial como `1.0e-6` e `2.7777777777778e-5`). O banco de dados carregado (jsonb) guarda isso em notação decimal, como `0.0000010` e `0.000027777777777778`.
- Se nenhuma unidade devolver o original (notação de 17 algarismos significativos `0.0002777777777777778`, valores anômalos que parecem valores calculados etc.), não se converte a coordenada inteira e preserva-se o texto original como UTF8-TEXT. O mesmo vale para precision negativa e para valores com o corpo celeste vazio.
- Amostra Q1–Q10000 do Wikidata (7.026 declarações de coordenadas, 6.824 com precision): em 5.933 (86,9%) recuperou-se o original (grau 4.104, segundo de arco 1.370, minuto de arco 459). Das 891 que não se recuperaram, 753 são da família 1/3600 e 1/60 em notação de 17 algarismos significativos.

## Exemplo

Berlim 52.516666666667, 13.383333333333, precision 1/60° (1 minuto de arco):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0120 0003 3212` (WIKIDATA-QID Q209426, minuto de arco).
- Notação em texto: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

O mesmo ponto com incerteza desconhecida: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Base normativa

- Significado: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — ordem latitude, longitude; incerteza `u` (metros); sistema de coordenadas padrão WGS 84. Se o Unit for o metro, Uncertainty = `u`.
- Valores numéricos: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude) e binary32 (incerteza).
- Ordem e faixa dos eixos: ISO 6709 (Standard representation of geographic point location by coordinates).
- Unidade: item de unidade do Wikidata (QID). A disposição de largura fixa, o campo Unit e a representação de desconhecido são regras do GEUL.

## Questões em aberto

1. Altitude.
2. O formato que preserva a cadeia original ISO 6709 (COORDINATE-ISO6709) será definido quando houver uso.
3. Como transcrever sem perdas a notação de 17 algarismos significativos da precision do Wikidata (cerca de 11% da amostra).

## Páginas relacionadas

- [Value](/pt/grammar/value/), [COORDINATE-GEO](/pt/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/pt/grammar/value/numeric/binary-float/), [Marcador de posição](/pt/grammar/reference/slot-marker/)
- O formato Issuer [POINT2-BINARY64](/pt/grammar/value/vector/point2-binary64/) é um ponto bidimensional genérico que deixa ao contexto externo o sistema de coordenadas, a unidade e o significado dos eixos; este formato é uma coordenada geográfica na Terra.
