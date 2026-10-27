---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE é o Edge descritivo de identidade, sem direção, que declara que duas References indicam o mesmo alvo (Codec 0x01)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE é o Edge descritivo de identidade, sem direção, que declara que duas References indicam o mesmo referent. Codec `0x01`.

Não quer dizer que a codificação em bytes, o Codec e o ID dos dois registros Reference sejam iguais. Ao contrário do [REFERENCE-NODE](/pt/grammar/edge/reference-node/), que é um vínculo direcional `Reference → registro`, o SAME-NODE expressa a identidade (referential identity) entre duas References.

## Layout

```
TAG WORD          0001 0LLL L000 0001
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference
```

## Interpretação e validade

- Subject e Object são serializados nessa ordem, e cada um deve ser exatamente um registro [Reference](/pt/grammar/reference/) completo. A fronteira de cada um é achada pelo seu Length.
- Se o Subject ou o Object for Value, Edge ou um registro incompleto, é invalid.
- A relação SAME-NODE é reflexiva, simétrica e transitiva. A ordem Subject/Object no wire serve ao framing e não cria direção de significado. A implementação deve poder percorrer a relação nos dois sentidos.
- [LOCAL](/pt/grammar/reference/local/) IDs diferentes são apenas References diferentes, e não prova de que o referent é igual ou diferente. Que duas References indiquem o mesmo referent se declara com SAME-NODE.
- A interpretação e a inferência devem preservar a origem, o instante, o world e o policy scope do documento que contém o Edge e do grafo de julgamento. Não se usa SAME-NODE como base de uma fusão global independente do contexto.
- Mesmo que exista um SAME-NODE, não se apaga nem se sobrescreve o registro Reference original nem a linhagem.
- Se o mesmo par tiver ao mesmo tempo SAME-NODE e [DIFFERENT-NODE](/pt/grammar/edge/different-node/), o wire nem por isso é invalid. Preserva-se o contexto de cada afirmação e avalia-se como conflito.
- Liga-se uma Reference Variable a uma Reference Identified com SAME-NODE para resolver a variável ([Reference](/pt/grammar/reference/) Variable).

## Comprimento

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Exemplo (não normativo)

Edge Id `0009`, o Subject é LOCAL 1 e o Object é LOCAL 2.

- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORDs, `LLLL=0110`. A TAG é `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [REFERENCE-NODE](/pt/grammar/edge/reference-node/), [DIFFERENT-NODE](/pt/grammar/edge/different-node/)
- [Reference](/pt/grammar/reference/), [LOCAL](/pt/grammar/reference/local/)
