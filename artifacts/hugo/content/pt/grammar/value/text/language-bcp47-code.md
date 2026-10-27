---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE é o Value que contém uma language tag BCP 47 completa como sequência de bytes ASCII. Usa o par de Codecs de bytes par/ímpar 0x46/0x47."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE é o Value que contém uma language tag BCP 47 completa. Usa-se para escrever o idioma com exatidão, até script, region e variant.

## Layout

- Código: códigos diretos de Value `0x46` (número par de bytes) e `0x47` (número ímpar de bytes). Família TEXT.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](/pt/grammar/value/)).
- O Payload não é texto UTF-8, e sim a sequência de bytes ASCII da tag BCP 47.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          bytes da tag BCP 47 / padding zero final
```

## Interpretação e validade

- A sequência de bytes deve ser uma language tag BCP 47 well-formed da RFC 5646. Não se admite cadeia vazia.
- O Payload usa apenas letras ASCII, dígitos e hyphen-minus `-`. O separador é obrigatoriamente o `-` ASCII, e não se admitem `_`, espaços nem caracteres não ASCII.
- A comparação de tags BCP 47 não distingue maiúsculas de minúsculas. O canonical profile do GEUL escreve todos os separadores com `-` e serializa os subtags language/extlang/variant/extension/private-use em minúsculas, o script em Titlecase e a region em maiúsculas.
- Ser apenas well-formed não basta. A validade dos subtags registrados e das tags grandfathered julga-se com base em um snapshot determinado do IANA Language Subtag Registry, e a data desse snapshot ou a versão do registry deve ser preservada junto.
- Tags private-use e subtags private-use são admitidos se forem well-formed pela gramática da RFC 5646. Mas o seu significado depende de acordo entre as partes e não é definido pelo registry da IANA, de modo que não garante interoperabilidade pública.
- No mesmo snapshot, se um subtag deprecated ou uma tag grandfathered tem Preferred-Value, a forma canônica do GEUL escreve esse valor substituto em canonical casing. Uma tag com a notação deprecated tal qual pode ser interpretada como entrada, mas não é a forma canônica de armazenamento.
- Como o BCP 47 é um perfil ASCII, não se aplica a exigência de normalização Unicode, como a UTF-8 NFC.
- Dentro da WORD, o byte superior vem primeiro. Se o número de bytes for ímpar (código ímpar), o byte inferior não usado da última WORD deve ser `00`.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se for um código ímpar e o byte inferior da última WORD não for `00`, rejeita-se.

## Base normativa

- A gramática da language tag, a interpretação sem distinção de maiúsculas e minúsculas e o conceito de deprecated/Preferred-Value seguem a [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- O registry que julga a validade da tag é o [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- O par de Codecs par/ímpar, o zero padding, a política de armazenamento em canonical casing e o cálculo do Length são regras de framing do GEUL.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Length](/pt/grammar/record/)).

## Relação com LANGUAGE-SHORT-CODE

- Para conter de forma curta apenas o primary language subtag, usa-se [LANGUAGE-SHORT-CODE](/pt/grammar/value/text/language-short-code/).
- Se for preciso script, region, variant, extension ou private-use, usa-se LANGUAGE-BCP47-CODE.
- Usa-se também LANGUAGE-BCP47-CODE para um idioma ainda não atribuído no registry de LANGUAGE-SHORT-CODE, para o caso que precise do escape `0xffff` e quando se precisa preservar o texto original da tag completa.

## Exemplo

- `ko-KR` tem 5 bytes ASCII (ímpar), então é `LANGUAGE-BCP47-CODE-ODD` (`0x47`), com Payload `6b6f 2d4b 5200`.
- TAG de 1 WORD e Payload de 3 WORD dão 4 WORD no total, com `LLLL=0011`. O registro inteiro é `09C7 6b6f 2d4b 5200`.
