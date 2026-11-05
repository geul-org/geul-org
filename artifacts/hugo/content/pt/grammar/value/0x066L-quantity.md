---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY é o Value que representa uma quantidade por número, unidade e limites inferior e superior."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `QUANTITY` (BIND `QUANTITY` do documento de especificação) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| Documento de especificação | `0x00000000/codecs/0x00000660/` (alvo do DECLARE `0660`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 6 |
| Kind | Value · família: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | amount como Value numérico (inteiro, BINARY-FLOAT, decimal, fração), Reference da unidade, limites inferior e superior. Unidade e limites podem ser omitidos (ABSENT `0x0000`) |
| Lado Hugo | `value/numeric/quantity.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | registro | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | registro | `000F` toda a seção 0 (curinga, Reference), `020F` toda a seção 1 (curinga, Reference), `040F` toda a seção 2 (curinga, Reference), `0000` ABSENT (campo opcional) |  |
| 3 | `lower` | #4 | registro | `0680` SIGNED-DECIMAL, `0000` ABSENT (campo opcional), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | registro | `0680` SIGNED-DECIMAL, `0000` ABSENT (campo opcional), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY é o Value que representa uma quantidade por número, unidade e limites inferior e superior. É o direct code de Value `0x066L`, família NUMERIC. Cada uma das quatro partes é um registro completo. Unidade e limites são [campos opcionais](../codec-spec.md), e quando omitidos usa-se ABSENT (`0x0000`).

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
amount            registro de Value numérico (inteiro, BINARY-FLOAT, decimal, fração)
unit              registro Reference (item de unidade); 0x0000 se não há unidade
lower             registro de Value numérico; se omitido, 0x0000 ABSENT
upper             registro de Value numérico; se omitido, 0x0000 ABSENT
```

## Interpretação e validade {#해석과-유효성}

- amount é exatamente um registro completo de Value numérico. Os Codec aceitos são seis: [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`), [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`), [BINARY-FLOAT](0x063L-binary-float.md) (`0x063L`), [FRACTION](0x067L-fraction.md) (`0x067L`), [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`) e [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`). A lista é fechada e não é um curinga. BOOL, COORDINATE-EARTH e COORDINATE-GEO, o próprio QUANTITY (aninhamento proibido, profundidade fixa) e os demais Value não são aceitos. Em amount não se pode usar marcador de posição (`0x0000` etc.).
- Os registros internos também seguem a forma canônica de cada Codec (inteiro e coefficient com o mínimo de WORD, BINARY-FLOAT com 1/2/4/8 WORD, FRACTION com as suas regras). Se houver um registro interno não canônico, QUANTITY inteiro é invalid.
- Se amount, lower ou upper é BINARY-FLOAT, deve ser um valor finito. NaN e ±Infinity são invalid (mesma regra de latitude e longitude de [COORDINATE-EARTH](0x064L-coordinate-earth.md)).
- O formato do número segue a notação original. Um original inteiro vai em INTEGER, um original decimal em DECIMAL, um original fracionário em FRACTION e um valor binário IEEE 754 em BINARY-FLOAT, e o codificador não normaliza trocando de formato. C e E de DECIMAL guardam os dígitos da notação original: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Os dois valores são o mesmo número, mas têm algarismos significativos diferentes, portanto são Value diferentes. Não há limite superior para os dígitos de inteiro e coefficient (mínimo de WORD, comprimento variável).
- unit é exatamente um registro Reference completo ou `0x0000`. Pode-se usar qualquer Reference que aponte um item de unidade (a unidade do Wikidata é WIKIDATA-QID). `0x0000` significa sem unidade (contagem, razão, população etc.).
- lower e upper são, cada um, um registro de um dos mesmos seis Codec de amount ou `0x0000` ABSENT. O marcador de posição só admite a omissão ABSENT. Basta que um dos dois exista. Os Codec dos três números não precisam ser iguais.
- lower ≤ amount ≤ upper é comparado por valor numérico, não por bytes nem por Codec. Mesmo com tipos diferentes comparam-se como números (ex.: SIGNED-INTEGER `652` e SIGNED-DECIMAL `651.5`). FRACTION é comparada como racional exato. Um intervalo simétrico (`652 ± 1`) também se escreve com limites inferior e superior (`651`, `653`). Como há intervalos assimétricos e de qualquer modo são necessários dois valores, não se define um formato reduzido a um único ±.
- A unidade faz parte do valor. Não se separa a unidade em QUALIFIER etc. (se separada, não se saberia se `652` é km ou m).
- Ao extrair o registro amount, ele é por si só um registro de Value independente. Se for preciso o número sem a unidade, usa-se esse registro sem recodificar.
- Não se guarda o valor convertido para unidades SI. É um valor derivado que se calcula a partir da unidade e da tabela de conversão.
- O cursor que leu os quatro registros deve coincidir exatamente com o fim do Payload. Qualquer outra forma é invalid.
- O documento de especificação do geul.org descreve quatro campos de registro: amount (`0610`, `0620`, `0630`, `0670`, `0680`, `0690`), unit (`000F`, `020F`, `040F`, `0000`) e lower e upper (`0610`, `0620`, `0630`, `0670`, `0680`, `0690`, `0000`) ([documento de especificação do Codec](../codec-spec.md)).

## Comprimento {#길이}

- O total é 1 WORD de TAG + (TAG de extensão de Length) + os quatro registros. Um registro inteiro tem 1 WORD de TAG + 1 WORD ou mais de Payload; um registro BINARY-FLOAT tem 2, 3, 5 ou 9 WORD; um registro decimal tem 1 WORD de TAG + 2 de expoente + 1 ou mais de coefficient; um registro FRACTION tem 5 WORD ou mais.
- Um inteiro pequeno sem unidade nem limites tem 6 WORD e um decimal pequeno tem 8 WORD. A partir de 15 WORD usa-se o comprimento estendido ([Registro e TAG WORD](../record.md)).

## Exemplo {#예시}

`1.20` sem unidade:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667` (Codec `0x066L`, 8 WORD), amount `0683 FFFF FFFE 0078` (E = -2, C = 120), unit, lower e upper `0000`.

Inteiro `42` sem unidade:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665` (6 WORD), amount `0611 002A` (SIGNED-INTEGER 42), unit, lower e upper `0000`.

Fração `2/3` sem unidade (dois terços dos direitos de voto presentes):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668` (9 WORD), amount `0674 0611 0002 0621 0003` ([FRACTION](0x067L-fraction.md) 2/3), unit, lower e upper `0000`.

`652 km`, intervalo `[651, 653]` (km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- O total é de 17 WORD, então `LLLL=1110` e o TAG de extensão é `0011`.

## Correspondência com o Wikidata {#위키데이터-대응}

- O datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower, upper. As cadeias de amount e dos limites (`+1.20`, inclusive notação exponencial) são transportadas para C e E com os mesmos dígitos.
- Como amount e os limites do Wikidata são cadeias decimais, mesmo os de aparência inteira (`+652`) são transportados como SIGNED-DECIMAL. A conversão do Wikidata não usa outros Codec numéricos.
- A unit `"1"` é sem unidade (`0x0000`), e `http://www.wikidata.org/entity/Qn` é WIKIDATA-QID. Outras unidades e números ou limites de formato inadequado não são convertidos e o texto original é preservado em UTF8-TEXT.
- Amostra do Wikidata (cerca de 42 mil quantity no início do dump): 61% sem unidade, 13% com limites (93% deles simétricos), o amount mais longo com 31 caracteres.

## Base normativa {#표준-근거}

- Notação decimal e preservação de dígitos: os conceitos de coefficient, exponent e quantum do decimal do [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL do GEUL).
- Modelo de quantidade do Wikidata: `QuantityValue` do Wikibase DataModel.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000660/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
