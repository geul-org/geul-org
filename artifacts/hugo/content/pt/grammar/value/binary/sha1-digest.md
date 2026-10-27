---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST é um Value fixo de 11 WORD que contém os 160 bits inteiros do resultado do SHA-1, usado apenas para identificação, como IDs de objetos git."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST é o Value de largura fixa que contém o resultado inteiro do SHA-1. Código direto de Value `0x62`, família BINARY. O Payload tem exatamente 10 WORD (160 bits) e não se admite truncation.

**Usa-se apenas para identificação.** A resistência a colisões do SHA-1 foi quebrada (SHAttered, 2017). Como base de integridade e assinatura, usa-se [SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/). Este formato existe para conter tal como está um identificador já definido por SHA-1, tipicamente o ID de objeto (ID de commit) de um repositório git SHA-1. Por exemplo, a Version (ID de commit) de [TRANSFORMED-BY](/pt/grammar/meta/lineage/transformed-by/) é contida em 11 WORD, em vez de texto hex (22 WORD).

## Layout

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interpretação e validade

- Os 20 octetos do Payload leem-se na mesma ordem da saída do SHA-1. Em cada WORD, o octeto superior vem primeiro (mesmo framing de SHA-256-DIGEST).
- Rejeita-se uma representação cujo Payload não tenha 10 WORD ou em que o resultado tenha sido cortado arbitrariamente (ID abreviado do git etc.). Não há descriptor nem padding.
- O ID de objeto do git é o valor calculado pelo git, tal como está. O SHA-1 do git é uma variante com detecção de colisões (SHA-1DC), mas, para entradas que não são ataques de colisão, o resultado é igual ao do SHA-1.

## Base normativa

- O algoritmo SHA-1 e o resultado de 160 bits seguem o [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final) do NIST.
- A TAG do GEUL e o framing de WORD de 16 bits são regras que este formato acrescenta.

## Comprimento

- O total é exatamente 11 WORD, a soma de 1 WORD de TAG e 10 WORD de Payload, e usa `LLLL=1010`. Não há extensão de Length.

## Exemplo

Commit git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Páginas relacionadas

- [Value](/pt/grammar/value/), [SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/pt/grammar/meta/lineage/transformed-by/)
