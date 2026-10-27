---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE é o Edge descritivo de não identidade que diz que duas References indicam alvos diferentes (Codec 0x02)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE é o Edge descritivo de não identidade que diz que duas References indicam referents diferentes. Codec `0x02`.

Não quer dizer que a codificação em bytes, o Codec e o ID dos dois registros Reference sejam diferentes. Distingue-se do vínculo direcional de [REFERENCE-NODE](/pt/grammar/edge/reference-node/) e da identidade de [SAME-NODE](/pt/grammar/edge/same-node/).

## Layout

```
TAG WORD          0001 0LLL L000 0010
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference
```

## Interpretação e validade

- Subject e Object devem ser, cada um, exatamente um registro [Reference](/pt/grammar/reference/) completo. A fronteira de cada um é achada pelo seu Length; se for Value ou Edge, ou estiver incompleto, é invalid.
- Subject e Object indicam referents diferentes. Não se infere que o referent é diferente só pela diferença da sequência de bytes, do Codec ou do ID do registro Reference.
- Em particular, [LOCAL](/pt/grammar/reference/local/) IDs diferentes são apenas References diferentes, e não significam que os referents do mundo real sejam diferentes. Não se deriva DIFFERENT só da diferença de LOCAL ID.
- A não identidade é simétrica, irreflexiva e não transitiva. `DIFFERENT(A, B)` é a mesma relação que `DIFFERENT(B, A)`. Mas de `DIFFERENT(A, B)` e `DIFFERENT(B, C)` não se infere `DIFFERENT(A, C)`.
- A ordem Subject/Object no wire é apenas a ordem de serialização para o framing e não cria direção de significado. A implementação deve poder percorrer nos dois sentidos.
- O cursor depois de ler os dois componentes deve coincidir exatamente com o fim do Edge.

Embora a própria relação seja irreflexiva, não se deve apagar como erro de gramática do wire uma afirmação `DIFFERENT(A, A)` estruturalmente válida, nem uma afirmação em que SAME e DIFFERENT se chocam. Essas afirmações preservam o contexto e a linhagem e são tratadas como contradição na camada de julgamento. Ao interpretar ou derivar DIFFERENT, preservam-se a origem, o instante, o world e o policy scope do documento que contém o Edge, e não se amplia para uma conclusão global que os ignore.

## Comprimento

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Exemplo (não normativo)

Edge Id `000a`, o Subject é LOCAL 1 e o Object é LOCAL 2.

- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORDs, `LLLL=0110`. A TAG é `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

A diferença de LOCAL ID neste exemplo serve apenas para mostrar a codificação. Só se faz desta sequência um DIFFERENT-NODE quando existe, à parte, a afirmação de que o ID 1 e o ID 2 indicam referents diferentes.

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [REFERENCE-NODE](/pt/grammar/edge/reference-node/), [SAME-NODE](/pt/grammar/edge/same-node/)
- [Reference](/pt/grammar/reference/), [LOCAL](/pt/grammar/reference/local/)
