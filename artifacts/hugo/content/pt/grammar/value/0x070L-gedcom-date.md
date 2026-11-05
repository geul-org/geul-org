---
title: "GEDCOM-DATE (0x070L·0x071L)"
weight: 112
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE é o Value que preserva, como cadeia de valor de data GEDCOM 7, datas de outros calendários, como o juliano, tal como foram escritas (Codec 0x070L/0x071L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE é o Value que preserva, como cadeia de valor de data GEDCOM 7, datas de outros calendários, como o juliano, tal como foram escritas (Codec 0x070L/0x071L).

| Item | Valor |
|---|---|
| Nome | `GEDCOM-DATE` (grupo par/ímpar; os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x070L`·`0x071L` |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 16~17 |
| Kind | Value · família: TIME |
| Descrição do índice | Cadeia de valor de data GEDCOM 7. Preserva a notação original de outros calendários (juliano etc.). Bytes pares·ímpares |
| Lado Hugo | `value/time/gedcom-date.md` |

## Membros {#구성원}

Esta página trata em conjunto os dois códigos de um par par/ímpar. O código par é o de valores com número par de bytes, e o ímpar, o de valores com número ímpar ([Registro e TAG WORD](../record.md#가변-길이-바이트열)). Há um documento de Codec por código. Os campos dos dois documentos de Codec são iguais; só diferem o alvo de DECLARE e o nome (BIND).

| TAG ID | Nome | Número de bytes | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x070L` | `GEDCOM-DATE-EVEN` | par | `0x00000700` | `0x00000000/codecs/0x00000700/` | `0000 0111 0000 LLLL` |
| `0x071L` | `GEDCOM-DATE-ODD` | ímpar | `0x00000710` | `0x00000000/codecs/0x00000710/` | `0000 0111 0001 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restante, valor bruto (`0xFFFF`) |  |  |

GEDCOM-DATE é o Value que contém a cadeia do valor de data (`DateValue`) do [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). Preserva **tal como foi escrita** uma data que a origem escreveu em um calendário que não é o gregoriano (juliano etc.).

## Layout {#레이아웃}

- Código: códigos diretos de Value `0x070L` (número par de bytes) e `0x071L` (número ímpar de bytes). Família TIME.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 000P LLLL      Codec 0x070L/0x071L (P = número ímpar de bytes)
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          bytes ASCII da cadeia de data GEDCOM / se ímpar, 0x00 no final
```

## Interpretação e validade {#해석과-유효성}

- A sequência de bytes é uma cadeia ASCII que segue a gramática `DateValue` do GEDCOM 7. Uma cadeia vazia é invalid. O GEDCOM admite um `DateValue` vazio, mas, se não houver valor, não se escreve o registro.
- Resumo da gramática: `[calendário] [[dia] mês] ano [BCE]`. Na frente podem ir `ABT`, `CAL`, `EST` (aproximado), `BEF`, `AFT`, `BET … AND …` (intervalo), `FROM … TO …` (período). O separador é um único espaço.
- Calendários: `GREGORIAN` (padrão se omitido), `JULIAN`, `FRENCH_R`, `HEBREW`, tags de extensão. Os nomes dos meses são definidos por calendário (o juliano usa `JAN`…`DEC`, como o gregoriano).
- O ano é **histórico**. Não existe o ano 0, e antes da era comum acrescenta-se `BCE` (`44 BCE` = 44 a.C.). Há um ano de diferença em relação ao estilo astronômico de EDTF e GREGORIAN-DATE.
- O schema só confere a forma dos bytes: ASCII `0x20`~`0x7E`, não vazio, sem espaços no início e no fim. A gramática e a existência real do dia são conferidas pelo produtor. Exemplo: `gedcom.ParseDate` de `github.com/cacack/gedcom-go/v3` (MIT). O `Validate` dessa biblioteca só confere o dia no calendário gregoriano e deixa passar `JULIAN 30 FEB 1100`, e o `ToGregorian` não converte de fato a precisão de ano e mês. A verificação da existência da data e a normalização fazem-se à parte.
- **Onde se usa:** as datas do calendário gregoriano escrevem-se com [GREGORIAN-DATE](0x06AL-gregorian-date.md) ou [EDTF](0x06EL-edtf.md). GEDCOM-DATE usa-se para datas de outro calendário cuja notação original deve ser preservada.

## Uso junto com um valor normalizado {#정규화된-값과-함께-쓰기}

- Para comparar e indexar a mesma data no eixo do tempo, é preciso um valor gregoriano. Na precisão de dia, a correspondência exata é o GREGORIAN-DATE do mesmo dia; na precisão de ano e mês, é o EDTF de intervalo gregoriano desse período (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- Ainda não se definiu como reunir, em dois Values, a notação original (GEDCOM-DATE) e o valor normalizado (problema em aberto).

## Comprimento {#길이}

- O total é 1 WORD de TAG mais o número de WORDs da TAG de extensão de Length (se houver) e do Payload ([Length](../record.md)).

## Exemplo {#예시}

| Data | Bytes | WORDs no total |
|---|---|---|
| `JULIAN 1300` | 11 (ímpar) | `0716 4A55 4C49 414E 2031 3330 3000` |

## Base normativa {#표준-근거}

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). A licença do repositório da especificação é Apache 2.0. GEUL apenas faz referência ao formato e não transcreve o texto da especificação.
- ISO 8601, EDTF, XSD e os identificadores de calendário do CLDR (`u-ca`) não incluem o calendário juliano. GEDCOM 7 é um formato público de intercâmbio que trata, numa só gramática, prefixo de calendário, era anterior à comum, precisão e qualificadores.

## Problemas em aberto {#열린-문제}

- Como escrever juntos a notação original e o valor normalizado (como ligar os dois em um TRIPLE).
- Verificação da gramática GEDCOM no schema.
- Precisão de século e de década. O GEDCOM não tem formato para elas. Datas que não podem ser transpostas do Wikidata ficam como texto original em UTF8-TEXT.

## Páginas relacionadas {#관련-페이지}

- [Value](_index.md), [EDTF](0x06EL-edtf.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000700/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000070000000000
BODY
#1 DECLARE 0x0700
#2 FIELD #1 rest
#3 BIND #1 "GEDCOM-DATE-EVEN"
#4 BIND #2 "bytes"
```

Acima está o documento de Codec de `GEDCOM-DATE-EVEN` (`0x070L`). O documento de Codec do outro membro (`GEDCOM-DATE-ODD`) difere apenas no Codec ID do DOC-ID, no alvo de DECLARE e no nome ligado a `#1` (BIND).
