---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY é o Value que contém uma grandeza em quatro registros: quantidade como registro Value numérico (inteiro, BINARY-FLOAT, decimal, fração), Reference da unidade e limites inferior e superior."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY é o Value que representa uma grandeza por um número, uma unidade e limites inferior e superior. Código direto de Value `0x06`, família NUMERIC. As quatro partes são, cada uma, um registro completo. A unidade e os limites são [campos opcionais](/pt/grammar/codec-spec/), por isso, se forem omitidos, escreve-se ABSENT (`0x0000`).

## Layout

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[TAG estendida de Length] quando o total é de 15 WORD ou mais
amount            registro Value numérico (inteiro, BINARY-FLOAT, decimal, fração)
unit              registro Reference (item de unidade); 0x0000 se não houver unidade
lower             registro Value numérico; 0x0000 ABSENT se omitido
upper             registro Value numérico; 0x0000 ABSENT se omitido
```

## Interpretação e validade

- O amount é exatamente um registro Value numérico completo. Aceita seis Codecs: [SIGNED-INTEGER](/pt/grammar/value/numeric/signed-integer/) (`0x01`), [UNSIGNED-INTEGER](/pt/grammar/value/numeric/unsigned-integer/) (`0x02`), [BINARY-FLOAT](/pt/grammar/value/numeric/binary-float/) (`0x03`), [FRACTION](/pt/grammar/value/numeric/fraction/) (`0x07`), [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/) (`0x10`) e [UNSIGNED-DECIMAL](/pt/grammar/value/decimal/unsigned-decimal/) (`0x11`). É uma lista fechada, não um curinga. Não se aceitam BOOL, COORDINATE-EARTH e COORDINATE-GEO, a própria QUANTITY (sem aninhamento, profundidade fixa) nem outros Values. No amount não se pode escrever marcador de posição (`0x0000` etc.).
- Os registros internos também seguem a forma canônica de cada Codec (mínimo de WORDs para inteiros e coeficiente, 1/2/4/8 WORD para BINARY-FLOAT, FRACTION segundo as suas regras). Se houver um registro interno não canônico, a QUANTITY inteira é invalid.
- Se amount, lower ou upper for BINARY-FLOAT, tem de ser um valor finito. NaN e ±Infinity são invalid (a mesma regra da latitude e longitude de [COORDINATE-EARTH](/pt/grammar/value/numeric/coordinate-earth/)).
- O formato do número segue tal como está a notação original. Um original inteiro é guardado como INTEGER, um original com casas decimais como DECIMAL, um original fracionário como FRACTION e um valor binário IEEE 754 como BINARY-FLOAT; o codificador não normaliza trocando o formato. C e E de um DECIMAL guardam tal como está o número de dígitos da notação original: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Os dois são o mesmo número, mas, como têm algarismos significativos diferentes, são Values diferentes. Não há limite para o número de dígitos de inteiros e do coeficiente (mínimo de WORDs, comprimento variável).
- A unit é exatamente um registro Reference completo ou `0x0000`. Pode ser qualquer Reference que aponte para o item de unidade (as unidades do Wikidata são WIKIDATA-QID). `0x0000` é sem unidade (contagens, razões, população etc.).
- O lower e o upper são, cada um, um registro de um dos mesmos seis Codecs do amount ou `0x0000` ABSENT. O único marcador de posição aceito é a omissão ABSENT. Basta ter um dos dois. Os três números não precisam ter o mesmo Codec. Uma faixa simétrica (`652 ± 1`) também se escreve com limite inferior e superior (`651`, `653`). Como existem faixas assimétricas e, de qualquer forma, são necessários dois valores, não há um formato reduzido a um só ±.
- lower ≤ amount ≤ upper compara-se pelo valor numérico, não por bytes nem por Codec. Mesmo com tipos diferentes, compara-se como número (por exemplo, SIGNED-INTEGER `652` e SIGNED-DECIMAL `651.5`). FRACTION compara-se como número racional exato.
- A unidade faz parte do valor. Não se separa a unidade em um QUALIFIER ou similar (separada, não se sabe se `652` é km ou m).
- Extraído, o registro amount é tal como está um registro Value independente. Quando se precisa do número sem a unidade, usa-se esse registro sem recodificar.
- Não se guarda o valor convertido para unidades SI. É um valor derivado, que se calcula a partir da unidade e da tabela de conversão.
- O cursor depois de ler os quatro registros deve coincidir exatamente com o fim do Payload. Qualquer outra forma é invalid.
- O documento de especificação do geul.org escreve com quatro campos de registro: amount (`0801`, `0802`, `0803`, `0807`, `0810`, `0811`), unit (`0780`, `0000`), lower e upper (`0801`, `0802`, `0803`, `0807`, `0810`, `0811`, `0000`) ([Documento de especificação de Codec](/pt/grammar/codec-spec/)).

## Comprimento

- O total é 1 WORD de TAG + (TAG estendida de Length) + os quatro registros. O registro inteiro tem TAG 1 + Payload de 1 WORD ou mais, o registro BINARY-FLOAT tem 2, 3, 5 ou 9 WORD, e o registro decimal tem TAG 1 + expoente 2 + coeficiente de 1 WORD ou mais. O registro FRACTION tem 5 WORD ou mais.
- Um inteiro pequeno, sem unidade e sem limites, tem 6 WORD; um decimal pequeno, 8 WORD. De 15 WORD em diante usa-se o comprimento estendido ([Registro e TAG WORD](/pt/grammar/record/)).

## Exemplo

`1.20` sem unidade:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower e upper `0000`.

Inteiro `42` sem unidade:

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD), amount `0881 002A` (SIGNED-INTEGER 42), unit, lower e upper `0000`.

Fração `2/3` sem unidade (dois terços dos votos presentes):

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD), amount `0A07 0881 0002 0882 0003` ([FRACTION](/pt/grammar/value/numeric/fraction/) 2/3), unit, lower e upper `0000`.

`652 km`, faixa `[651, 653]` (km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- São 17 WORD no total, então `LLLL=1110`, TAG estendida `0011`.

## Correspondência com o Wikidata

- O datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower e upper. As cadeias de amount e de limites (`+1.20`, inclusive em notação exponencial) são transcritas para C e E com o mesmo número de dígitos.
- O amount e os limites do Wikidata são cadeias decimais, por isso, mesmo com forma de inteiro (`+652`), são transcritos como SIGNED-DECIMAL. A conversão do Wikidata não usa outros Codecs numéricos.
- A unit `"1"` é sem unidade (`0x0000`), e `http://www.wikidata.org/entity/Qn` é WIKIDATA-QID. Outras unidades e números ou limites de formato inválido não se convertem, e preserva-se o texto original como UTF8-TEXT.
- Amostra do Wikidata (cerca de 42 mil quantity do início do dump): sem unidade 61%, com limites 13% (destes, 93% simétricos), amount mais longo com 31 caracteres.

## Base normativa

- Notação decimal e preservação do número de dígitos: os conceitos de coeficiente, expoente e quantum do decimal de [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL do GEUL).
- Modelo de quantidade do Wikidata: `QuantityValue` do Wikibase DataModel.

## Páginas relacionadas

- [Value](/pt/grammar/value/), [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/pt/grammar/value/numeric/coordinate-geo/), [CODEC](/pt/grammar/edge/codec/), [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/)
