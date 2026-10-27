---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION é o Meta de definição que declara, com um só inteiro, a versão da especificação GEUL seguida pelo documento. O GEUL v1 é 0x0001."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declara a versão da especificação GEUL seguida pelo documento. Este valor determina como ler os demais registros.

## Layout

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[TAG estendida de Length]
Payload           versão da especificação. v1 = 0x0001
```

- Codec: Meta `0x10`, classe de definição (`001`)
- Payload: valor bruto (inteiro sem sinal na menor largura)
- Quantidade: no máximo um

## Interpretação e validade

- Não depende de um código de Value. Contém só um inteiro, sem Value embutido, para que o decodificador de qualquer versão possa lê-lo.
- Se a versão for desconhecida, o decodificador rejeita ou avisa.
- Sem ele, lê-se na versão que o decodificador conhece. Os documentos publicados o escrevem.

## Exemplo

- `0x1890 0x0001`: GEUL v1

## Questões em aberto

- Correspondência com as versões dos documentos de codebook ([especificação](/pt/grammar/codec-spec/)).
