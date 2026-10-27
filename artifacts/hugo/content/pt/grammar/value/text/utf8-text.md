---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT é o Value que contém uma cadeia UTF-8 sem idioma. Usa o par de Codecs de bytes par/ímpar 0x40/0x41."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT é o Value que contém uma sequência de bytes UTF-8 válida da RFC 3629. Usa-se em cadeias sem idioma, como identificadores, códigos e nomes de arquivo.

## Layout

- Código: códigos diretos de Value `0x40` (número par de bytes) e `0x41` (número ímpar de bytes). Família TEXT.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](/pt/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          bytes UTF-8 / zero padding final
```

## Interpretação e validade

- A sequência de bytes deve ser UTF-8 well-formed shortest-form de acordo com a gramática da RFC 3629. O resultado da decodificação contém apenas Unicode scalar values na faixa `U+0000..U+10FFFF`, sem a faixa de surrogates `U+D800..U+DFFF`.
- A RFC 3629 descreve o tratamento da signature U+FEFF inicial conforme o contexto. O canonical profile do GEUL, além disso, proíbe a sequência de bytes do BOM UTF-8 `EF BB BF` no início do Payload. Um U+FEFF em outra posição é um caractere, e não um BOM, e por isso esta regra não o proíbe.
- Não se impõe Unicode normalization. Preserva-se tal como está a sequência de scalars do texto original decodificado.
- A sequência de bytes UTF-8 válida vai no Payload sem conversão. Dentro da WORD, o byte superior vem primeiro. Se o número de bytes for ímpar (código ímpar), o byte inferior não usado da última WORD deve ser `00`.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se for um código ímpar e o byte inferior da última WORD não for `00`, rejeita-se.

## Base normativa

- A faixa de scalar do UTF-8, a sequência de bytes well-formed e o significado do tratamento do BOM seguem a [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- A proibição do BOM, o par de Codecs par/ímpar, o zero padding e a TAG/Length do GEUL com a disposição de WORD de 16 bits são regras de canonical framing deste formato.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload. Até 14 WORD usa-se o comprimento direto, e de 15 WORD em diante o comprimento estendido `1110`·`1111`, e a TAG estendida também entra no total ([Length](/pt/grammar/record/)).
- Uma cadeia de 0 byte escreve-se como um registro de 1 WORD (só a TAG WORD) de código par ([Value](/pt/grammar/value/)).

## Exemplo

- `A` (`41`) tem 1 byte (ímpar), então é `UTF8-TEXT-ODD` (`0x41`), com Payload `4100`, 2 WORD no total, `LLLL=0001`. O registro inteiro é `08C1 4100`.
- A cadeia vazia é 1 WORD, `0840` (`UTF8-TEXT-EVEN`, só a TAG WORD).
