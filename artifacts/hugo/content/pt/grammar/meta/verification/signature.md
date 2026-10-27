---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE é o Meta de verificação que registra a assinatura do hash de conteúdo do documento como ID do algoritmo, signatário e assinatura."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

É a assinatura do hash de conteúdo do documento (git signed commit e tag).

## Layout

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[TAG estendida de Length]
ID do algoritmo   1 WORD (0x0001 = Ed25519)
Signatário        registro Reference ISSUER-POINTER(Issuer)
Assinatura        todo o restante. A largura é definida pelo algoritmo (Ed25519 32 WORD)
```

- Codec: Meta `0x41`, classe de verificação (`100`)
- Payload: ID do algoritmo (valor bruto de 1 WORD) + signatário (Reference embutida) + assinatura (valor bruto, o restante)
- Quantidade: pode haver vários

## Interpretação e validade

- O alvo da assinatura é o hash de conteúdo. Não se assina apenas o BODY ([Assinatura](/pt/grammar/issuer/#assinatura)).
- Por ser da classe de verificação, fica fora do hash de conteúdo. Mesmo acrescentando assinaturas, o hash é o mesmo.
- A verificação não é "se houver assinatura, confere-se", e sim "tem de haver a assinatura de uma chave determinada".
- O documento da lista de versões é assinado pelo local de publicação.
- O signatário é um [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/) (Issuer) que aponta para o próprio Issuer. Por ser um registro Reference, termina no seu próprio Length, de modo que o layout fica determinado de um só modo mesmo que a largura da assinatura varie conforme o algoritmo ([DECLARE](/pt/grammar/edge/declare/) campo restante).
- Se o número de WORDs da assinatura for diferente da largura definida pelo algoritmo, é invalid.

## Questões em aberto

- Se o instante da assinatura é assinado junto.
