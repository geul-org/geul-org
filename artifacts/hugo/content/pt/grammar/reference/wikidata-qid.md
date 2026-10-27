---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID é a Reference de declaração que aponta para um item (Item) do Wikidata pelo número do ID Q."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID é a Reference de declaração que aponta para um item (Item) do Wikidata. Escreve-se como inteiro sem sinal a parte numérica do ID Q, sem o `Q`.

## Layout

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[TAG estendida de Length]
QID               unsigned big-endian na menor largura
```

- O QID é escrito na menor largura. `Q1`~`Q65535` têm 2 WORD no total, e acima disso, 3 WORD.
- Os dados do Wikidata são CC0.
- Se for Variable, é uma variável anônima da espécie a que esse item se refere ([Reference](/pt/grammar/reference/) Variable).

## Exemplo

| Item | Sequência de WORDs |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [WIKIDATA-PID](/pt/grammar/reference/wikidata-pid/), [TRIPLE](/pt/grammar/edge/triple/)
