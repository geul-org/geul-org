---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK é o layout que escreve as relações entre nós TOULMIN (ataque, exclusão, execução, ligação de julgamento, definição, nome). É formado por REF de src e dst, uma WORD de flags, um portão de certeza opcional e SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK é o layout que escreve as relações entre nós no grafo TOULMIN. O tipo de relação é determinado pelo Codec (ou pelo número de formato ISSUER do GEUL).

## Codec

| Codec | Nome | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | regra → regra. Reduz gradualmente o julgamento |
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
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         operador de 1 WORD (2 bits superiores) + Value UNSIGNED-DECIMAL (porcentagem)
SPAN             largura definida por SOURCE × 2
```

| flag | Significado |
|---|---|
| b0 F_ONCE | executa uma só vez (`once` de UNDO) |
| b1 F_GATE | há o campo do portão de certeza |
| b2 F_STRIKE | relação riscada (tachada) |
| b3 F_ORDERED | pertence a uma lista ordenada `1.` |

| Operador do portão | Significado |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## Interpretação e validade

- REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](/pt/grammar/edge/toulmin/#campos-comuns)).
- A forma do dst é determinada pelo Codec. Em DO, DO-ONCE e UNDO é um FuncRef (REF (ALIAS; 0 se não houver) + VerbCode de 1 WORD, [NODE](/pt/grammar/edge/toulmin/node/#campos)); em LABEL e IMPORTED-FROM é o REF de um registro TEXT; nos demais é o REF de um nó.
- `do … once` é representado pelo Codec DO-ONCE. Nos flags de DO-ONCE não se usa F_ONCE (se estiver ligado, rejeita-se). O `once` de UNDO escreve-se com F_ONCE.
- O operador do portão são os 2 bits superiores da WORD do operador, e os 14 bits restantes são 0. A porcentagem é um Value UNSIGNED-DECIMAL com `E=0`, de 0 a 100.
- Os bits b4~b15 dos flags são reservados e devem ser 0. Caso contrário, rejeita-se.
- A cadeia `A > B > C` de SUPERSEDES escreve-se com um SUPERSEDES por par.

## Páginas relacionadas

- [TOULMIN](/pt/grammar/edge/toulmin/), [NODE](/pt/grammar/edge/toulmin/node/), [SOURCE e seções](/pt/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/pt/grammar/value/decimal/unsigned-decimal/)
