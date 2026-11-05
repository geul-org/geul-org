---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF é o Value que guarda, como cadeia de datas estendidas da ISO 8601-2, datas com precisão de ano ou mês, a.C., incertas ou em intervalo (Codec 0x06EL/0x06FL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF é o Value que guarda, como cadeia de datas estendidas da ISO 8601-2, datas com precisão de ano ou mês, a.C., incertas ou em intervalo (Codec 0x06EL/0x06FL).

| Item | Valor |
|---|---|
| Nome | `EDTF` (grupo par/ímpar. Os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x06EL`·`0x06FL` |
| Seção | 3 `0011` (Value), deslocamento C na seção = 14~15 |
| Kind | Value · família: TIME |
| Descrição no índice | cadeia de data EDTF (ISO 8601-2). Bytes pares e ímpares. Não se usa para datas que podem ser escritas com GREGORIAN-DATE |
| Lado Hugo | `value/time/edtf.md` |

## Membros {#구성원}

Esta página trata em conjunto dois códigos de um par par/ímpar. O código par é o do valor com número par de bytes e o código ímpar é o do valor com número ímpar ([Registro e TAG WORD](../record.md#가변-길이-바이트열)). Há um documento de Codec por código. Os campos dos dois documentos de Codec são iguais e só diferem o alvo do DECLARE e o nome (BIND).

| TAG ID | Nome | Número de bytes | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | par | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | ímpar | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | valor bruto restante (`0xFFFF`) |  |  |

EDTF é o Value que guarda uma data como cadeia do [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Biblioteca do Congresso dos EUA, ISO 8601-2:2019). Representa precisão mais grosseira que o dia, a.C., incerteza, aproximação, partes desconhecidas e intervalos.

## Layout {#레이아웃}

- Código: direct code de Value `0x06EL` (bytes pares) e `0x06FL` (bytes ímpares). Família TIME. O Payload é uma cadeia de caracteres, mas fica na família TIME.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORD do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = bytes ímpares)
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          bytes ASCII da cadeia EDTF / se ímpar, o último 0x00
```

## Interpretação e validade {#해석과-유효성}

- A sequência de bytes é uma cadeia ASCII que segue a gramática EDTF dos Levels 0, 1 e 2. Uma cadeia vazia é invalid.
- Exemplos: dia `1952-03-11`, mês `1952-03`, ano `1952`, década `195X`, 44 a.C. `-0043`, incerta `1974?`, aproximada `~1974`, intervalo `1952/2001`, ano grande `Y-13799999999`.
- Os anos seguem a forma astronômica da ISO 8601. `0000` é 1 a.C. e `-0043` é 44 a.C. Ao transpor de uma notação histórica, desloca-se um ano.
- É o calendário gregoriano. O EDTF não trata outros calendários. A notação original de outros calendários, como o juliano, é preservada em [GEDCOM-DATE](0x070L-gedcom-date.md). O valor que transpõe esse mesmo dia ou período para o calendário gregoriano pode ser escrito em EDTF ou em GREGORIAN-DATE.
- **Forma canônica:** uma data que pode ser escrita exatamente com [GREGORIAN-DATE](0x06AL-gregorian-date.md), isto é, `[-]YYYY-MM-DD` sem qualificadores (`?`, `~`, `%`), sem dígitos desconhecidos (`X`), sem intervalo e sem prefixo `Y`, escreve-se com GREGORIAN-DATE. Escrever uma data assim em EDTF é invalid. Só se pode indexar e comparar como tempo se o mesmo dia estiver escrito em um único formato.
- O schema ainda não verifica a gramática EDTF. O produtor verifica com um parser EDTF. Exemplo: `parser.ParseString` de `github.com/sfomuseum/go-edtf` (BSD-3-Clause). Não se usa `parser.IsValid`, pois olha apenas a gramática e deixa passar `2023-02-29` e `1974-13`. Esse parser ainda não suporta anos com prefixo `Y`.

## Comprimento {#길이}

- O total é o número de WORD somando 1 WORD de TAG, o TAG de extensão de Length (se houver) e o Payload ([Length](../record.md)).

## Exemplo {#예시}

| Data | Bytes | WORD totais |
|---|---|---|
| `1974` | 4 (par) | `06E2 3139 3734` |
| `197X` | 4 (par) | `06E2 3139 3758` |
| `1952-03` | 7 (ímpar) | `06F4 3139 3532 2D30 3300` |

## Base normativa {#표준-근거}

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). O Level 0 é um subconjunto da ISO 8601-1 e os Levels 1 e 2 são recursos da ISO 8601-2.
- Em RDF, a mesma cadeia é indicada pelo tipo de dado `http://id.loc.gov/datatypes/edtf`.

## Problemas em aberto {#열린-문제}

- Verificação da gramática EDTF pelo verificador (se o verificador dependerá de uma biblioteca externa).
- Regra para transpor as precisões de século e milênio do Wikidata para dígitos desconhecidos do EDTF.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md), [GEDCOM-DATE](0x070L-gedcom-date.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000006E0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

O acima é o documento de Codec de `EDTF-EVEN` (`0x06EL`). O documento de Codec do outro membro (`EDTF-ODD`) só difere no Codec ID do DOC-ID, no alvo do DECLARE e no nome (BIND) ligado em `#1`.
