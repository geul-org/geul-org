---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT é o marcador de posição que indica 'não preenchido'."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT é o [marcador de posição](../slot-marker.md) que indica "não preenchido". É uma afirmação sobre o documento: esta posição não foi preenchida. Não afirma nada sobre o mundo.

| Item | Valor |
|---|---|
| Nome | `ABSENT` (BIND `ABSENT` do documento de especificação) |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| Documento de especificação | `0x00000000/codecs/0x00000000/` (alvo do DECLARE `0000`) |
| Seção | 0 `0000` (entidade Reference), deslocamento C na seção = 0 |
| Kind | Reference · classificação: marcador de posição |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Não preenchido. Um campo opcional foi omitido. Não afirma nada sobre o mundo |
| Lado Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- Não há Payload. Também não há ID de alvo nem Quantifier ([marcador de posição](../slot-marker.md#레이아웃)).
- Em `0x000L`, a forma com Payload (L ≥ 1) é Reserved.
- Notação textual de `geul show` e `geul add`: `ABSENT`.

## Significado {#뜻}

| Item | Não preenchido |
|---|---|
| Sobre o que fala | **O documento**: esta posição não foi preenchida |
| Lógica | Não afirma nada |
| Suposição de mundo | Mundo aberto (sem informação) |
| Wikidata | O snak correspondente não existe |

## Aceitação {#수용}

- Só é aceito por campos que declaram o alvo CODEC `0000`. Esse campo é um **campo opcional**. Ao omitir um campo opcional, escreve-se nessa posição um único WORD `0x0000`. Um campo opcional também ocupa sempre a sua posição ([Documento de especificação de Codec](../codec-spec.md#선택-필드와-자리-표지)). Exemplos: Origin de [SOURCE](../edge/0x0C0L-source.md); unidade, limite inferior e limite superior de [QUANTITY](../value/0x066L-quantity.md).
- Não pode ser usado em curingas, em campos sem CODEC, em posições de registro HEAD/BODY, em posições de Edge Id nem em campos de valor bruto (regra comum de [marcador de posição](../slot-marker.md#수용-규칙)).

## Obrigações de quem lê {#읽는-쪽의-의무}

- **ABSENT não diz nada sobre o mundo.** Não o leia como UNKNOWN-VALUE nem como NO-VALUE.
- É proibido que um conversor escreva como UNKNOWN-VALUE um valor que não conseguiu transportar (um valor que existe na origem), pois a origem conhece o valor. Mesmo uma posição sobre a qual a origem nada diz (por exemplo, o Origin de um [SOURCE](../edge/0x0C0L-source.md) cuja proveniência a origem não descreve) é escrita pelo conversor como ABSENT.
- No grafo de julgamento, ABSENT e a ausência de enunciado tornam indeterminado (U) qualquer operador de comparação. Para ler ABSENT como vazio (empty), a entrada precisa declarar um mundo fechado ([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)).

## Exemplo {#예시}

`0x0000`, 1 WORD. Exemplo: a posição da unidade em um QUANTITY cuja unidade não foi informada.

## Documento do codec {#코덱-문서}

O documento do codec contém apenas um DECLARE (alvo `0000`). Sem Payload, não há FIELD. O decodificador traz embutidos o significado do marcador e as regras de aceitação ([camada 0](../publishing.md#층)). Para ler o marcador não se consulta o documento do codec.

## Páginas relacionadas {#관련-페이지}

- [marcador de posição](../slot-marker.md), [UNKNOWN-VALUE](0x001L-unknown-value.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Documento de especificação de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000000/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
