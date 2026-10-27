---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY é o Value que contém uma grandeza em quatro registros: quantidade decimal exata, Reference da unidade e limites inferior e superior."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY é o Value que representa uma grandeza por um decimal exato, uma unidade e limites inferior e superior. Código direto de Value `0x06`, família NUMERIC. As quatro partes são, cada uma, um registro completo. A unidade e os limites são [campos opcionais](/pt/grammar/codec-spec/), por isso, se forem omitidos, escreve-se ABSENT (`0x0000`).

## Layout

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[TAG estendida de Length] quando o total é de 15 WORD ou mais
amount            registro Value SIGNED-DECIMAL
unit              registro Reference (item de unidade); 0x0000 se não houver unidade
lower             registro Value SIGNED-DECIMAL; 0x0000 ABSENT se omitido
upper             registro Value SIGNED-DECIMAL; 0x0000 ABSENT se omitido
```

## Interpretação e validade

- O amount é [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/) `C×10^E`. C e E guardam tal como está o número de dígitos da notação original: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Os dois são o mesmo número, mas, como têm algarismos significativos diferentes, são Values diferentes. Não há limite para o número de dígitos do coeficiente (complemento de dois no mínimo de WORDs, comprimento variável).
- A unit é exatamente um registro Reference completo ou `0x0000`. Pode ser qualquer Reference que aponte para o item de unidade (as unidades do Wikidata são WIKIDATA-QID). `0x0000` é sem unidade (contagens, razões, população etc.).
- O lower e o upper são, cada um, um registro SIGNED-DECIMAL ou `0x0000`. Basta ter um dos dois. Uma faixa simétrica (`652 ± 1`) também se escreve com limite inferior e superior (`651`, `653`). Como existem faixas assimétricas e, de qualquer forma, são necessários dois valores, não há um formato reduzido a um só ±.
- A unidade faz parte do valor. Não se separa a unidade em um QUALIFIER ou similar (separada, não se sabe se `652` é km ou m).
- Não se guarda o valor convertido para unidades SI. É um valor derivado, que se calcula a partir da unidade e da tabela de conversão.
- O cursor depois de ler os quatro registros deve coincidir exatamente com o fim do Payload. Qualquer outra forma é invalid.
- O documento de especificação do geul.org escreve com quatro campos de registro: amount (`0810`), unit (`0780`, `0000`), lower e upper (`0810`, `0000`) ([Documento de especificação de Codec](/pt/grammar/codec-spec/)).

## Comprimento

- O total é 1 WORD de TAG + (TAG estendida de Length) + os quatro registros. O registro decimal tem TAG 1 + expoente 2 + coeficiente de 1 WORD ou mais.
- Um número pequeno, sem unidade e sem limites, tem 8 WORD. De 15 WORD em diante usa-se o comprimento estendido ([Registro e TAG WORD](/pt/grammar/record/)).

## Exemplo

`1.20` sem unidade:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower e upper `0000`.

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
- A unit `"1"` é sem unidade (`0x0000`), e `http://www.wikidata.org/entity/Qn` é WIKIDATA-QID. Outras unidades e números ou limites de formato inválido não se convertem, e preserva-se o texto original como UTF8-TEXT.
- Amostra do Wikidata (cerca de 42 mil quantity do início do dump): sem unidade 61%, com limites 13% (destes, 93% simétricos), amount mais longo com 31 caracteres.

## Base normativa

- Notação decimal e preservação do número de dígitos: os conceitos de coeficiente, expoente e quantum do decimal de [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL do GEUL).
- Modelo de quantidade do Wikidata: `QuantityValue` do Wikibase DataModel.

## Páginas relacionadas

- [Value](/pt/grammar/value/), [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/pt/grammar/value/numeric/coordinate-geo/), [CODEC](/pt/grammar/edge/codec/), [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/)
