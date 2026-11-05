---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION é o Value que representa uma fração tal como escrita no texto original, preservando a notação."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `FRACTION` (BIND `FRACTION` do documento de especificação) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| Documento de especificação | `0x00000000/codecs/0x00000670/` (alvo do DECLARE `0670`) |
| Seção | 3 `0011` (Value), deslocamento C na seção = 7 |
| Kind | Value · família: NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | fração que preserva a notação original: numerador inteiro ou decimal, denominador inteiro ou decimal sem sinal. Não se simplifica |
| Lado Hugo | `value/numeric/fraction.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | registro | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | registro | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION é o Value que representa uma fração tal como escrita no texto original, preservando a notação. É o direct code de Value `0x067L`, família NUMERIC. Numerador e denominador são, cada um, um registro de Value completo. Não se simplifica. Guarda frações cuja forma escrita é o próprio registro, como «dois terços» e «cinco centésimos» de uma lei, ou a participação decimal `23.45/1256.1` de um registro predial.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
numerator         1 registro de Value: SIGNED-INTEGER ou SIGNED-DECIMAL
denominator       1 registro de Value: UNSIGNED-INTEGER ou UNSIGNED-DECIMAL
```

## Interpretação e validade {#해석과-유효성}

- numerator é exatamente um registro [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`) ou [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`).
- denominator é exatamente um registro [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`) ou [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`).
- A lista é fechada. Não se aceitam outros Value, o próprio FRACTION (aninhamento proibido) nem marcador de posição (`0x0000` etc.).
- Como os dois registros têm cada um o seu comprimento, não se escreve o limite entre eles. O cursor que leu os dois registros deve coincidir exatamente com o fim do Payload.
- Os registros internos também seguem a forma canônica de cada Codec (inteiro e coefficient com o mínimo de WORD). Se houver um registro interno não canônico, FRACTION inteira é invalid.
- O valor é `numerator / denominator`.

### Preservação da notação {#표기-보존}

- **Inteiro e decimal**: se o componente original é inteiro (sem ponto decimal), usa-se um registro INTEGER; se tem ponto decimal, um registro DECIMAL. Escrever um componente como DECIMAL com expoente `E = 0` é invalid. Assim, uma mesma notação tem uma única sequência de bytes.
- C e E de um componente DECIMAL são os dígitos do original. `23.450` é `23450×10^-3` e é um Value diferente de `23.45`.
- **Não se simplifica.** `2/4` e «cinco centésimos» (`5/100`) são escritos como estão. Bytes iguais significam notação original igual.
- Uma fração com denominador 1 (`3/1`) também é escrita como está, se o original assim escreveu. Se o original é um inteiro, usa-se o Codec de inteiro, não FRACTION. Se o original é um decimal (`0.5`, `5%`), usa-se DECIMAL.
- O sinal fica só no numerador. O denominador é de um Codec sem sinal.
- Se o valor do denominador é 0, é invalid (tanto `0` quanto `0.0`).

### Comparação {#비교}

- A camada de comparação calcula FRACTION como o racional exato `(C1 × 10^E1) / (C2 × 10^E2)` (componentes INTEGER têm `E = 0`). Não se aproxima com ponto flutuante.
- Comparação, ordenação e detecção de duplicatas usam esse valor, e armazenamento, assinatura e hash de conteúdo usam a notação (bytes). `2/4`, `1/2` e `0.5` têm o mesmo valor e bytes diferentes.
- O julgamento de quórum («dois terços ou mais dos direitos de voto dos acionistas presentes») compara-se por esse valor exato.

## Comprimento {#길이}

- O total é 1 WORD de TAG + (TAG de extensão de Length) + os dois registros. Um registro inteiro tem 1 WORD de TAG + 1 WORD ou mais de Payload; um registro decimal tem 1 WORD de TAG + 2 de expoente + 1 ou mais de coefficient.
- Uma fração inteira pequena tem 5 WORD e uma fração decimal pequena tem 9 WORD. A partir de 15 WORD usa-se o comprimento estendido ([Registro e TAG WORD](../record.md)).

| Original | Componentes | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Exemplo {#예시}

`2/3`:

```
0674 0611 0002 0621 0003
```

- TAG `0674` (Codec `0x067L`, 5 WORD), numerator `0611 0002` (SIGNED-INTEGER 2), denominator `0621 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678` (9 WORD), numerator `0683 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0693 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Relação com outros formatos {#다른-형식과의-관계}

- amount, lower e upper de [QUANTITY](0x066L-quantity.md) aceitam FRACTION. «Dois terços dos direitos de voto presentes» pode ser escrito como um QUANTITY sem unidade com amount `2/3`.
- O documento de especificação `0x00000000/codecs/0x00000670` do geul.org descreve dois campos de registro: numerator (`0610`, `0680`) e denominator (`0620`, `0690`) ([documento de especificação do Codec](../codec-spec.md)).
- Se for necessária uma fração int64 de largura fixa que imponha a simplificação, usa-se o formato de Issuer [RATIONAL-I64](adhoc.geul.org/rational-i64.md).

## Problemas em aberto {#열린-문제}

1. Preservação da notação de números mistos (`1 e 2/3`).
2. Um formato que guarde, com dois QUANTITY, uma fração cujos componentes têm unidade (área/área). FRACTION não guarda unidade.
3. O critério de notação sobre se percentuais e permilagens (`5%`, `5‰`) ficam como DECIMAL com unidade ou como FRACTION (`5/100`).
4. Frações complexas (FRACTION no numerador ou denominador). Por ora são proibidas.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [QUANTITY](0x066L-quantity.md), [SIGNED-INTEGER](0x061L-signed-integer.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000670/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
