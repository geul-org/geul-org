---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY é o Meta de verificação que declara o ID do algoritmo de assinatura e a chave pública de um Issuer autoemitido (16 WORD)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declara a chave pública de um Issuer autoemitido (16 WORD). Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID do algoritmo ‖ chave pública) ([Issuer de 16 WORD](/pt/grammar/issuer/#issuer-de-16-word)).

## Layout

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[TAG estendida de Length]
ID do algoritmo   1 WORD (0x0001 = Ed25519)
Chave pública     largura definida pelo algoritmo (Ed25519 16 WORD)
```

- Codec: Meta `0x40`, classe de verificação (`100`)
- Payload: valor bruto (ID do algoritmo + chave pública)
- Quantidade: pode haver vários (troca de chave)

## Interpretação e validade

- Por ser da classe de verificação, fica fora do hash de conteúdo.
- Os Issuers de 1, 2 e 4 WORD usam a chave registrada no geul.org, então não é necessário.
