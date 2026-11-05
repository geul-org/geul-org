---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE é o marcador de posição que indica 'inexistente'."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE é o [marcador de posição](../slot-marker.md) que indica "inexistente". É uma afirmação sobre o mundo: não há valor.

| Item | Valor |
|---|---|
| Nome | `NO-VALUE` (BIND `NO-VALUE` do documento de especificação) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| Documento de especificação | `0x00000000/codecs/0x00000020/` (alvo do DECLARE `0020`) |
| Seção | 0 `0000` (entidade Reference), deslocamento C na seção = 2 |
| Kind | Reference · classificação: marcador de posição |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Inexistente. Não há valor (`novalue` do Wikidata) |
| Lado Hugo | `reference/slot-marker.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- Não há Payload. Também não há ID de alvo nem Quantifier ([marcador de posição](../slot-marker.md#레이아웃)).
- Em `0x002L`, a forma com Payload (L ≥ 1) é Reserved.
- Notação textual de `geul show` e `geul add`: `NONE`.

## Significado {#뜻}

| Item | Inexistente |
|---|---|
| Sobre o que fala | **O mundo**: não há valor |
| Lógica | `¬∃x. P(s, x)` |
| Suposição de mundo | Mundo fechado para (s, P, condição de qualificação) |
| Wikidata | `novalue` |

## Aceitação {#수용}

- Só é aceito por campos que declaram o alvo CODEC `0020`. Esse campo aceita a afirmação "inexistente". Exemplos: Object de [TRIPLE](../edge/0x0AAL-triple.md), Value de [QUALIFIER](../edge/0x0ABL-qualifier.md).
- Não pode ser usado em curingas, em campos sem CODEC, em posições de registro HEAD/BODY, em posições de Edge Id nem em campos de valor bruto (regra comum de [marcador de posição](../slot-marker.md#수용-규칙)).

## Obrigações de quem lê {#읽는-쪽의-의무}

- **NO-VALUE se fecha dentro da condição de qualificação da proposição.** Se há QUALIFIER, fecha-se apenas nesse intervalo. Q30 P1304 NO-VALUE(P580 1811, P582 1816) significa que só entre 1811 e 1816 não houve banco central, e não contradiz o TRIPLE de valor da mesma propriedade (Federal Reserve, preferred).
- Se, para o mesmo Subject e Predicate, NO-VALUE e um TRIPLE de valor coexistem com o mesmo rank e sem condição de qualificação que os distinga, há contradição. O verificador emite um aviso. Não rejeita. É um estado que também existe no Wikidata, e quem lê escolhe pelo rank.
- **O rank se aplica da mesma forma.** Ao escolher o valor representativo (truthy), o TRIPLE com NO-VALUE também é candidato.
- **Quando usado como valor de QUALIFIER, muda o sentido dessa qualificação.** Se `P582 = NONE`, afirma-se que não terminou. Se não há nenhum QUALIFIER P582, não se sabe se terminou.
- "Não há" só se pode dizer **escrevendo** NO-VALUE. A ausência de um TRIPLE no documento é não preenchido (mundo aberto).

## Exemplo {#예시}

`0x0020`, 1 WORD. Exemplo: "sem filhos (P40)" é `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` (TRIPLE, a posição de Object é `0020`).

## Documento do codec {#코덱-문서}

O documento do codec contém apenas um DECLARE (alvo `0020`). Sem Payload, não há FIELD. O decodificador traz embutidos o significado do marcador e as regras de aceitação ([camada 0](../publishing.md#층)). Para ler o marcador não se consulta o documento do codec.

## Páginas relacionadas {#관련-페이지}

- [marcador de posição](../slot-marker.md), [ABSENT](0x000L-absent.md), [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Documento de especificação de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000020/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
