---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT é o Value que contém tal como estão os bits de interchange IEEE 754 binary16/32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT é o Value que representa um scalar de interchange binary IEEE 754. Código direto de Value `0x03`, família NUMERIC. Se o Payload tem 1/2/4/8 WORD, é, respectivamente, binary16/32/64/128. Preserva tal como estão os bits de interchange e não admite outros tamanhos de Payload.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[TAG estendida de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st  (WORD superior)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD inferior)   IEEE Binary Interchange Nth
```

## Interpretação

- As WORDs do Payload, concatenadas em ordem big-endian, são lidas como a sequência de bits de interchange binary IEEE 754 da largura correspondente.
- Preservam-se os padrões de bits de interchange, inclusive o payload de NaN e o zero com sinal.
- O decodificador não deve trocar um NaN por um NaN canônico qualquer nem apagar o sinal do zero com sinal.
- O modo de arredondamento e o comportamento aritmético não são definidos por este formato de serialização.

## Comprimento

O total é o número de WORDs da soma de 1 WORD de TAG, a TAG estendida de Length (se houver) e o Payload ([Registro e TAG WORD](/pt/grammar/record/)).

| Formato | Payload | Código de Length | TAG estendida de Length | Length total |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | nenhuma | 2 WORD |
| binary32 | 2 WORD | `0010` | nenhuma | 3 WORD |
| binary64 | 4 WORD | `0100` | nenhuma | 5 WORD |
| binary128 | 8 WORD | `1000` | nenhuma | 9 WORD |

O binary128 também está na faixa direta de 1 a 14 WORD, por isso não usa TAG estendida de Length.

## Validade

- O Payload é exatamente 1, 2, 4 ou 8 WORD.
- Cada tamanho de Payload deve coincidir exatamente com a representação de Length da tabela acima.
- Não se permitem a recodificação que mude a largura nem WORDs de padding antes ou depois do Payload.

## Exemplo

| Formato | TAG | TAG estendida de Length | Exemplo de Payload | Julgamento |
|---|---|---|---|---|
| binary16 | `0883` | nenhuma | `0000` | canônico |
| binary32 | `0903` | nenhuma | `0000 0000` | canônico |
| binary64 | `0A03` | nenhuma | `0000 0000 0000 0000` | canônico |
| binary128 | `0C03` | nenhuma | sequência de bits de 8 WORD | canônico |
| qualquer | Length não coincide com o tamanho indicado | qualquer | qualquer | invalid |

## Base normativa

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): aplica as codificações de interchange binary16, binary32, binary64 e binary128. O GEUL só acrescenta a essa sequência de bits a TAG e o framing big-endian de WORD de 16 bits.
