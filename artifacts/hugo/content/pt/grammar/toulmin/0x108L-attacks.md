---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS é um Codec LINK que escreve uma relação do grafo TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS é um Codec LINK que escreve uma relação do grafo TOULMIN. Significado: relação de ataque. O julgamento do atacante reduz gradualmente o julgamento do alvo na medida da força do ataque (0~1, padrão 1).

| Item | Valor |
|---|---|
| Nome | `ATTACKS` (BIND do documento de especificação `ATTACKS`) |
| TAG ID | `0x108L` |
| Codec ID | `0x00001080` |
| Documento de especificação | `0x00000000/codecs/0x00001080/` (alvo do DECLARE `1080`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 8 |
| Kind | Edge · família: TOULMIN, grupo: relação, layout: LINK |
| TAG WORD | `0001 0000 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | relação de ataque. O julgamento do atacante reduz gradualmente o julgamento do alvo na medida da força do ataque (0~1, padrão 1) |
| Lado Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

O layout é [LINK](_index.md#link) (ID, src, dst, flags, campos condicionais, SPAN).

| Item | Valor |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | regra → regra. Reduz gradualmente o julgamento na medida da força do ataque |

- dst é o REF de um nó.
- F_FORCE (força do ataque) é usado somente por este Codec. Veja [Força do ataque](#공격-세기) abaixo.
- Os campos comuns (ID, REF, SPAN) e as regras numéricas seguem [TOULMIN](_index.md#공통-필드).

## Força do ataque {#공격-세기}

A força do ataque (Force) indica com que intensidade uma aresta ATTACKS ataca o alvo. O intervalo é 0~1, e sem F_FORCE vale 1.

- No julgamento, a contribuição `(v+1)/2` do valor de julgamento v do atacante é multiplicada pela força F. O ataque de contestação (COUNTER) entra no termo do denominador `F·(v+1)/2`, e o ataque de exceção (EXCEPT) entra no portão `Π(1 − F·(v+1)/2)`. Se F for 0, o ataque não afeta o julgamento.
- O valor segue as regras numéricas de [TOULMIN](_index.md#수치). O codificador remove os zeros finais do coeficiente (0.5 é `C=5, E=−1`, 1.0 é `C=1, E=0`). O decodificador aceita até 4 casas decimais.
- Uma forma de superfície sem força escrita (`don't X when Y`, `` `Y` 면 `X` 는 무효다``) deixa F_FORCE desligado.
- Uma forma de superfície com força escrita (`` `Y` 면 `X` 를 0.5의 세기로 공격한다``) liga F_FORCE e guarda esse valor. Mesmo ao escrever 1, como em `1.0의 세기로`, F_FORCE é ligado e guarda 1. Assim, a forma de superfície do texto original é restaurada.
- A força do ataque é um eixo diferente da intensidade do nó (Strict, Defeasible, Defeater). A intensidade pertence ao nó, e a força do ataque pertence à aresta ATTACKS.

### Exemplo de força do ataque {#공격-세기-예시}

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, o atacante Y é o Edge Id 3, o alvo X é o Edge Id 2, largura do SPAN de 1 WORD.

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), 14 WORD no total
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, atacante)
0051 0002             dst     LOCAL 2 (X, alvo)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    byte inicial 0x40, número de bytes 0x1A
```

A mesma aresta sem força escrita tem flags `0000` e não tem o campo F_FORCE. A TAG WORD é `1089` (10 WORD no total).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1080`). Os campos condicionais do layout LINK e a largura do SPAN definida por SOURCE não podem ser declarados com FIELD; a declaração de campos é um problema em aberto ([TOULMIN](_index.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001080/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
