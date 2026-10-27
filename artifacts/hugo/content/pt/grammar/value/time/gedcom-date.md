---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE é o Value que preserva, como cadeia de valor de data GEDCOM 7, datas de outros calendários, como o juliano, tal como foram escritas (Codec 0x26/0x27)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE é o Value que contém a cadeia do valor de data (`DateValue`) do [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). Preserva **tal como foi escrita** uma data que a origem escreveu em um calendário que não é o gregoriano (juliano etc.).

## Layout

- Código: códigos diretos de Value `0x26` (número par de bytes) e `0x27` (número ímpar de bytes). Família TIME.
- O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](/pt/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = número ímpar de bytes)
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth          bytes ASCII da cadeia de data GEDCOM / se ímpar, 0x00 no final
```

## Interpretação e validade

- A sequência de bytes é uma cadeia ASCII que segue a gramática `DateValue` do GEDCOM 7. Uma cadeia vazia é invalid. O GEDCOM admite um `DateValue` vazio, mas, se não houver valor, não se escreve o registro.
- Resumo da gramática: `[calendário] [[dia] mês] ano [BCE]`. Na frente podem ir `ABT`, `CAL`, `EST` (aproximado), `BEF`, `AFT`, `BET … AND …` (faixa), `FROM … TO …` (período). O separador é um único espaço.
- Calendários: `GREGORIAN` (padrão se omitido), `JULIAN`, `FRENCH_R`, `HEBREW`, tags de extensão. Os nomes dos meses são definidos por calendário (o juliano usa `JAN`…`DEC`, como o gregoriano).
- O ano é **histórico**. Não existe o ano 0, e antes da era comum acrescenta-se `BCE` (`44 BCE` = 44 a.C.). Há um ano de diferença em relação ao estilo astronômico de EDTF e GREGORIAN-DATE.
- O schema só confere a forma dos bytes: ASCII `0x20`~`0x7E`, não vazio, sem espaços no início e no fim. A gramática e a existência real do dia são conferidas pelo produtor. Exemplo: `gedcom.ParseDate` de `github.com/cacack/gedcom-go/v3` (MIT). O `Validate` dessa biblioteca só confere o dia no calendário gregoriano e deixa passar `JULIAN 30 FEB 1100`, e o `ToGregorian` não converte de fato a precisão de ano e mês. A verificação da existência da data e a normalização fazem-se à parte.
- **Onde se usa:** as datas do calendário gregoriano escrevem-se com [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/) ou [EDTF](/pt/grammar/value/time/edtf/). GEDCOM-DATE usa-se para datas de outro calendário cuja notação original deve ser preservada.

## Uso junto com um valor normalizado

- Para comparar e indexar a mesma data no eixo do tempo, é preciso um valor gregoriano. Na precisão de dia, a correspondência exata é o GREGORIAN-DATE do mesmo dia; na precisão de ano e mês, é o EDTF de intervalo gregoriano desse período (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- Ainda não se definiu como conter, em dois Values, a notação original (GEDCOM-DATE) e o valor normalizado (questão em aberto).

## Comprimento

- O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload ([Length](/pt/grammar/record/)).

## Exemplo

| Data | Bytes | Total de WORD |
|---|---|---|
| `JULIAN 1300` | 11 (ímpar) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## Base normativa

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). A licença do repositório da especificação é Apache 2.0. O GEUL apenas referencia o formato e não transcreve o texto da especificação.
- ISO 8601, EDTF, XSD e os identificadores de calendário do CLDR (`u-ca`) não têm o calendário juliano. O GEDCOM 7 é um formato público de intercâmbio que trata, numa só gramática, o prefixo de calendário, o antes da era comum, a precisão e os qualificadores.

## Questões em aberto

- Como escrever juntos a notação original e o valor normalizado (como ligar os dois num TRIPLE).
- A verificação da gramática GEDCOM pelo schema.
- Precisão de século e década. O GEDCOM não tem esse formato. As datas que não se conseguem transcrever do Wikidata ficam com o texto original em UTF8-TEXT.

## Páginas relacionadas

- [Value](/pt/grammar/value/), [EDTF](/pt/grammar/value/time/edtf/), [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/)
