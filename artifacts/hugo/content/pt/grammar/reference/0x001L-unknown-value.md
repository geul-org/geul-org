---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE é o marcador de posição que indica 'desconhecido'."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE é o [marcador de posição](../slot-marker.md) que indica "desconhecido". É uma afirmação sobre o mundo: existe um valor, mas não se sabe qual.

| Item | Valor |
|---|---|
| Nome | `UNKNOWN-VALUE` (BIND `UNKNOWN-VALUE` do documento de especificação) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| Documento de especificação | `0x00000000/codecs/0x00000010/` (alvo do DECLARE `0010`) |
| Seção | 0 `0000` (entidade Reference), deslocamento C na seção = 1 |
| Kind | Reference · classificação: marcador de posição |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Desconhecido. Existe um valor, mas não se sabe qual (`somevalue` do Wikidata) |
| Lado Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- Não há Payload. Também não há ID de alvo nem Quantifier ([marcador de posição](../slot-marker.md#레이아웃)).
- Em `0x001L`, a forma com Payload (L ≥ 1) é Reserved.
- Notação textual de `geul show` e `geul add`: `UNKNOWN`.

## Significado {#뜻}

| Item | Desconhecido |
|---|---|
| Sobre o que fala | **O mundo**: existe um valor. Não se sabe qual |
| Lógica | `∃x. P(s, x)`, x não é identificado |
| Suposição de mundo | A existência é fechada, a identidade é aberta |
| Wikidata | `somevalue` |

## Aceitação {#수용}

- Só é aceito por campos que declaram o alvo CODEC `0010`. Esse campo aceita a afirmação "desconhecido". Exemplos: Object de [TRIPLE](../edge/0x0AAL-triple.md), Value de [QUALIFIER](../edge/0x0ABL-qualifier.md), Origin de [SOURCE](../edge/0x0C0L-source.md).
- Não pode ser usado em curingas, em campos sem CODEC, em posições de registro HEAD/BODY, em posições de Edge Id nem em campos de valor bruto (regra comum de [marcador de posição](../slot-marker.md#수용-규칙)).

## Obrigações de quem lê {#읽는-쪽의-의무}

- **UNKNOWN-VALUE não é um valor, é uma afirmação de existência.** Não é igual nem diferente de nenhum outro valor (o resultado da comparação é indeterminado). Dois UNKNOWN-VALUE também não são tratados como o mesmo valor. Cada ocorrência é uma quantificação existencial independente (como um blank node do Wikidata).
- Por isso, dois TRIPLE idênticos byte a byte (`P40 Q… UNKNOWN` ×2) não são duplicados. Pode haver dois filhos ou apenas um. Um TRIPLE que contém UNKNOWN-VALUE não é mesclado como duplicado.
- Quando a identidade for descoberta, publica-se uma nova versão desse TRIPLE corrigido. Não é possível apontar para um UNKNOWN-VALUE. Se for necessária correferência, usa-se a Variable de LOCAL ([Reference](_index.md#quantifier) Variable).
- **O rank se aplica da mesma forma.** Ao escolher o valor representativo (truthy), o TRIPLE com UNKNOWN-VALUE também é candidato.
- **Quando usado como valor de QUALIFIER, muda o sentido dessa qualificação.** Se `P582 = UNKNOWN`, terminou, mas o momento é desconhecido. Não se lê como proposição ainda válida hoje.
- UNKNOWN-VALUE é uma afirmação de que "existe", portanto só se usa quando a origem diz isso. Um valor que não foi transportado não se escreve como UNKNOWN-VALUE.

## Exemplo {#예시}

`0x0010`, 1 WORD. Exemplo: o momento de término (P582) da fronteira Q30–Q34266 é desconhecido: `0AB7 0051 0C58 0191 0246 0051 080C 0010` (QUALIFIER, a posição de Value é `0010`).

## Documento do codec {#코덱-문서}

O documento do codec contém apenas um DECLARE (alvo `0010`). Sem Payload, não há FIELD. O decodificador traz embutidos o significado do marcador e as regras de aceitação ([camada 0](../publishing.md#층)). Para ler o marcador não se consulta o documento do codec.

## Páginas relacionadas {#관련-페이지}

- [marcador de posição](../slot-marker.md), [ABSENT](0x000L-absent.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Documento de especificação de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000010/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
