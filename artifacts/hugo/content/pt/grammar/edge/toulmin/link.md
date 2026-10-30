---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK é o layout que escreve as relações entre nós TOULMIN (ataque, exclusão, execução, ligação de julgamento, definição, nome). É formado por REF de src e dst, uma WORD de flags, um portão de certeza opcional, uma intensidade do ataque opcional e SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK é o layout que escreve as relações entre nós no grafo TOULMIN. O tipo de relação é determinado pelo Codec (ou pelo número de formato ISSUER do GEUL).

## Codec

| Codec | Nome | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | regra → regra. Reduz gradualmente o julgamento conforme a intensidade do ataque |
| `0x69` | SUPERSEDES | `X supersedes Y` | regra → regra. Se Active, retira o alvo da agregação |
| `0x70` | RUN | `run c when n` | regra → caso |
| `0x71` | DO | `do fn when n` | regra → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | regra → FuncRef |
| `0x73` | UNDO | `undo fn when n` | regra → FuncRef |
| `0x74` | CHECKING | `checking c` | regra → caso. Julgamento sem efeitos colaterais |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | caso → campo |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | item de definição → valor ou tipo |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | item de definição → campo |
| ISSUER `0x0000`/`0xC023` | RUNS | ponto de entrada `run c` | ponto de entrada → caso (execução) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | ponto de entrada `check c` | ponto de entrada → caso (julgamento) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | gatilho `run c` | gatilho → caso |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | gatilho → caso |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | nó → identificador global |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | alias → caminho (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | nome entre crases | nó → TEXT. Notação do nome |

## Layout

```
ID               registro Reference LOCAL (Edge Id)
src              REF
dst              REF. Em DO, DO-ONCE e UNDO, FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         operador de 1 WORD (2 bits superiores) + Value UNSIGNED-DECIMAL (porcentagem)
[F_FORCE]        SIGNED-DECIMAL Value. Intensidade do ataque (0~1). Só ATTACKS
SPAN             largura definida por SOURCE × 2
```

| flag | Significado |
|---|---|
| b0 F_ONCE | executa uma só vez (`once` de UNDO) |
| b1 F_GATE | há o campo do portão de certeza |
| b2 F_STRIKE | relação riscada (tachada) |
| b3 F_ORDERED | pertence a uma lista ordenada `1.` |
| b4 F_FORCE | Há um campo de intensidade do ataque. Só ATTACKS |

| Operador do portão | Significado |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Os campos condicionais ficam na ordem dos flags (F_GATE, F_FORCE). Um campo com o flag desligado não ocupa espaço.

## Intensidade do ataque

A intensidade do ataque (Force) diz com que intensidade uma aresta ATTACKS ataca o alvo. O intervalo é 0~1 e vale 1 quando não há F_FORCE.

- No julgamento, a contribuição `(v+1)/2` do valor de julgamento v do atacante é multiplicada pela intensidade F. Um ataque de refutação (COUNTER) entra no termo do denominador como `F·(v+1)/2`, e um ataque de exceção (EXCEPT) entra no portão `Π(1 − F·(v+1)/2)`. Com F = 0 o ataque não afeta o julgamento.
- O valor segue as regras numéricas de [TOULMIN](/pt/grammar/edge/toulmin/#números). O codificador remove os zeros finais do coeficiente (0.5 é `C=5, E=−1`; 1.0 é `C=1, E=0`). O decodificador aceita até 4 casas decimais.
- Uma superfície que não escreve intensidade (`don't X when Y`, em coreano `` `Y` 면 `X` 는 무효다``) desliga F_FORCE.
- Uma superfície que escreve intensidade (em coreano `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) liga F_FORCE e guarda o valor. Mesmo quando se escreve 1, como em `1.0의 세기로`, F_FORCE é ligado e guarda 1. Assim a superfície original volta tal como foi escrita.
- A intensidade do ataque é um eixo diferente da força do nó (Strict, Defeasible, Defeater). A força pertence ao nó; a intensidade do ataque, à aresta ATTACKS.

### Exemplo

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, atacante Y é Edge Id 3, alvo X é Edge Id 2, largura de SPAN 1 WORD.

```
16E8                  TAG WORD: Edge, 14 WORD no total, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, atacante)
0088 0002             dst     LOCAL 2 (X, alvo)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    byte inicial 0x40, número de bytes 0x1A
```

A mesma aresta sem intensidade tem flags `0000` e nenhum campo F_FORCE. A TAG WORD é `14E8` (10 WORD no total).

## Interpretação e validade

- REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](/pt/grammar/edge/toulmin/#campos-comuns)).
- A forma do dst é determinada pelo Codec. Em DO, DO-ONCE e UNDO é um FuncRef (REF (ALIAS; 0 se não houver) + VerbCode de 1 WORD, [NODE](/pt/grammar/edge/toulmin/node/#campos)); em LABEL e IMPORTED-FROM é o REF de um registro TEXT; nos demais é o REF de um nó.
- `do … once` é representado pelo Codec DO-ONCE. Nos flags de DO-ONCE não se usa F_ONCE (se estiver ligado, rejeita-se). O `once` de UNDO escreve-se com F_ONCE.
- O operador do portão são os 2 bits superiores da WORD do operador, e os 14 bits restantes são 0. A porcentagem é um Value UNSIGNED-DECIMAL com `E=0`, de 0 a 100.
- Os bits b5~b15 dos flags são reservados e devem ser 0. Caso contrário, rejeita-se.
- F_FORCE só é usado em ATTACKS. Se estiver ligado em outro Codec (SUPERSEDES, ligações de execução e de julgamento, relações de formato ISSUER), rejeita-se.
- Se a intensidade do ataque não for um Value SIGNED-DECIMAL, estiver fora de 0~1 ou não puder ser escrita exatamente com 4 casas decimais, rejeita-se.
- A cadeia `A > B > C` de SUPERSEDES escreve-se com um SUPERSEDES por par.

## Páginas relacionadas

- [TOULMIN](/pt/grammar/edge/toulmin/), [NODE](/pt/grammar/edge/toulmin/node/), [SOURCE e seções](/pt/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/pt/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/)
