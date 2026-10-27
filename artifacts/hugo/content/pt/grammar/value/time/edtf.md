---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF é o Value que contém, como cadeia de data estendida ISO 8601-2, datas como precisão de ano e mês, antes da era comum, incerteza e intervalo (Codec 0x24/0x25)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF é o Value que contém uma data como cadeia [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Biblioteca do Congresso dos EUA, ISO 8601-2:2019). Representa precisão mais grossa que o dia, antes da era comum, incerto, aproximado, parcialmente desconhecido e intervalos.

## Layout

- Código: códigos diretos de Value `0x24` (número par de bytes) e `0x25` (número ímpar de bytes). Família TIME. O Payload é uma cadeia, mas fica na família TIME para que o decodificador e o índice o tratem como valor de tempo mesmo sem conhecer o formato.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](/pt/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = número ímpar de bytes)
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          bytes ASCII da cadeia EDTF / se ímpar, 0x00 no final
```

## Interpretação e validade

- A sequência de bytes é uma cadeia ASCII que segue a gramática dos níveis 0, 1 e 2 do EDTF. Uma cadeia vazia é invalid.
- Exemplos: dia `1952-03-11`, mês `1952-03`, ano `1952`, década `195X`, 44 a.C. `-0043`, incerto `1974?`, aproximado `~1974`, intervalo `1952/2001`, ano grande `Y-13799999999`.
- O ano é astronômico, como na ISO 8601. `0000` é 1 a.C. e `-0043` é 44 a.C. Ao transcrever de uma notação histórica, desloca-se um ano.
- É o calendário gregoriano. O EDTF não trata outros calendários. A notação original de outros calendários, como o juliano, preserva-se com [GEDCOM-DATE](/pt/grammar/value/time/gedcom-date/). O valor que transcreve para o calendário gregoriano o mesmo dia ou período dessa data pode ser escrito como EDTF ou GREGORIAN-DATE.
- **Forma canônica:** uma data que se pode escrever exatamente como [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/), isto é, `[-]YYYY-MM-DD` sem qualificadores (`?`, `~`, `%`), dígitos desconhecidos (`X`), intervalo nem prefixo `Y`, escreve-se como GREGORIAN-DATE. Escrever tal data como EDTF é invalid. Só se o mesmo dia for escrito de uma única forma é possível indexar e comparar como tempo.
- O schema ainda não confere a gramática do EDTF. O produtor a confere com um parser de EDTF. Exemplo: `parser.ParseString` de `github.com/sfomuseum/go-edtf` (BSD-3-Clause). `parser.IsValid` só vê a gramática e deixa passar também `2023-02-29` e `1974-13`, por isso não se usa. Esse parser ainda não suporta anos com prefixo `Y`.

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload ([Length](/pt/grammar/record/)).

## Exemplo

| Data | Bytes | Total de WORD |
|---|---|---|
| `1974` | 4 (par) | `0924 3139 3734` |
| `197X` | 4 (par) | `0924 3139 3758` |
| `1952-03` | 7 (ímpar) | `0A25 3139 3532 2d30 3300` |

## Base normativa

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). O nível 0 é um subconjunto da ISO 8601-1, e os níveis 1 e 2 são recursos da ISO 8601-2.
- Em RDF, a mesma cadeia é indicada pelo datatype `http://id.loc.gov/datatypes/edtf`.

## Questões em aberto

- A verificação da gramática EDTF pelo verificador (se o verificador depende de uma biblioteca externa).
- A regra para transcrever a precisão de século e milênio do Wikidata como dígitos desconhecidos do EDTF.

## Páginas relacionadas

- [Value](/pt/grammar/value/), [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/), [GEDCOM-DATE](/pt/grammar/value/time/gedcom-date/)
