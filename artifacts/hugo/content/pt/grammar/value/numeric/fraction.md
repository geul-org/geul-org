---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION é o Value de fração que guarda o numerador (inteiro ou decimal) e o denominador (inteiro ou decimal sem sinal) tal como escritos no original, sem simplificar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION é o Value que representa uma fração escrita num texto original, preservando a sua notação. Código direto de Value `0x07`, família NUMERIC. O numerador e o denominador são, cada um, um registro Value completo. Não se simplifica. Guarda frações cuja forma escrita é o próprio registro, como "dois terços" e "cinco por cento" nas leis e a fração ideal decimal `23.45/1256.1` no registro de imóveis.

## Layout

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[TAG estendida de Length] quando o total é de 15 WORD ou mais
numerator         um registro Value: SIGNED-INTEGER ou SIGNED-DECIMAL
denominator       um registro Value: UNSIGNED-INTEGER ou UNSIGNED-DECIMAL
```

## Interpretação e validade

- O numerator é exatamente um registro [SIGNED-INTEGER](/pt/grammar/value/numeric/signed-integer/) (`0x01`) ou [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/) (`0x10`).
- O denominator é exatamente um registro [UNSIGNED-INTEGER](/pt/grammar/value/numeric/unsigned-integer/) (`0x02`) ou [UNSIGNED-DECIMAL](/pt/grammar/value/decimal/unsigned-decimal/) (`0x11`).
- É uma lista fechada. Não se aceitam outros Values, a própria FRACTION (sem aninhamento) nem marcadores de posição (`0x0000` etc.).
- Cada um dos dois registros tem o seu próprio comprimento, por isso não se escreve um limite à parte. O cursor depois de ler os dois registros tem de coincidir exatamente com o fim do Payload.
- Os registros internos também seguem a forma canônica de cada Codec (mínimo de WORDs para inteiros e coeficiente). Se houver um registro interno não canônico, a FRACTION inteira é invalid.
- O valor é `numerator / denominator`.

### Preservação da notação

- **Inteiro e decimal**: se um componente do original é inteiro (sem vírgula decimal), usa-se um registro INTEGER; se tem casas decimais, um registro DECIMAL. Escrever um componente como DECIMAL com expoente `E = 0` é invalid. Assim, uma mesma notação tem uma única sequência de bytes.
- C e E de um componente DECIMAL guardam tal como está o número de dígitos do original. `23.450` é `23450×10^-3`, um Value diferente de `23.45`.
- **Não se simplifica.** `2/4` e "cinco por cento" (`5/100`) escrevem-se tal como estão. Se os bytes forem iguais, a notação original é a mesma.
- Uma fração com denominador 1 (`3/1`) também se escreve tal como está, se o original a escreveu assim. Se o original é um inteiro, usa-se um Codec inteiro em vez de FRACTION. Se o original é um decimal (`0.5`, `5%`), usa-se DECIMAL.
- O sinal fica só no numerador. O denominador é um Codec sem sinal.
- Um denominador de valor 0 é invalid (tanto `0` como `0.0`).

### Comparação

- A camada de comparação calcula uma FRACTION como o número racional exato `(C1 × 10^E1) / (C2 × 10^E2)` (`E = 0` para um componente INTEGER). Não aproxima com ponto flutuante.
- A comparação, a ordenação e a deteção de duplicados usam este valor; o armazenamento, as assinaturas e os hashes de conteúdo usam a notação (bytes). `2/4`, `1/2` e `0.5` têm o mesmo valor e bytes diferentes.
- A verificação de quórum ("pelo menos dois terços dos votos dos acionistas presentes") compara-se com este valor exato.

## Comprimento

- O total é 1 WORD de TAG + (TAG estendida de Length) + os dois registros. O registro inteiro tem TAG 1 + Payload de 1 WORD ou mais, e o registro decimal tem TAG 1 + expoente 2 + coeficiente de 1 WORD ou mais.
- Uma fração inteira pequena tem 5 WORD; uma fração decimal pequena, 9 WORD. De 15 WORD em diante usa-se o comprimento estendido ([Registro e TAG WORD](/pt/grammar/record/)).

| Original | Componentes | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Exemplo

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07` (Codec `0x07`, 5 WORD), numerator `0881 0002` (SIGNED-INTEGER 2), denominator `0882 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07` (9 WORD), numerator `0990 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0991 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Relação com outros formatos

- O amount, o lower e o upper de [QUANTITY](/pt/grammar/value/numeric/quantity/) aceitam FRACTION. "Dois terços dos votos presentes" pode escrever-se como uma QUANTITY sem unidade com amount `2/3`.
- O documento de especificação do geul.org `0x0000/0x0000000000000807` escreve-a com dois campos de registro: numerator (`0801`, `0810`) e denominator (`0802`, `0811`) ([documento de especificação de Codec](/pt/grammar/codec-spec/)).
- Quando se precisa de uma fração int64 fixa com simplificação obrigatória, usa-se o formato Issuer [RATIONAL-I64](/pt/grammar/value/etc/rational-i64/).

## Questões em aberto

1. A preservação da notação de números mistos (`1 e 2/3`).
2. Um formato que guarde como duas QUANTITY uma fração cujos componentes têm unidade (área/área). FRACTION não guarda unidade.
3. O critério de notação para percentagem e permilagem (`5%`, `5‰`): DECIMAL com unidade ou FRACTION (`5/100`).
4. Frações compostas (FRACTION no numerador ou no denominador). Por ora são proibidas.

## Páginas relacionadas

- [Value](/pt/grammar/value/), [QUANTITY](/pt/grammar/value/numeric/quantity/), [SIGNED-INTEGER](/pt/grammar/value/numeric/signed-integer/), [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/), [RATIONAL-I64](/pt/grammar/value/etc/rational-i64/)
