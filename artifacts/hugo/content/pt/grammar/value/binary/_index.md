---
title: "Value — Binário"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "Formatos da família BINARY (Codec `0x60`~`0x7B`, números de formato `0xC000`~`0xFFFF`): UUID, digests, CRC, endereços de rede, sequência de bytes desconhecida e bit vector."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A família BINARY são formatos de sequência de bytes. Ficam nos códigos diretos `0x60`~`0x7B` e nos números de formato Issuer `0xC000`~`0xFFFF`.

- UUID, SHA-256 e SHA-1 são códigos diretos. Os demais digests, o CRC32C, os endereços IPv4, IPv6 e MAC, a sequência de bytes desconhecida e o bit vector são formatos Issuer.
- Os valores de tamanho fixo (UUID, digests, endereços) têm tamanho determinado e, por isso, não têm par par/ímpar.
- As mídias públicas, como imagens e vídeos, ficam como formatos BINARY do Issuer IANA (`0x0021`). Os números de formato são atribuídos em pares par/ímpar e o Payload é uma sequência de bytes. O limite do Length é 2^32−1 WORD. Para valores grandes, recomenda-se referenciá-los por URI e SHA-256, em vez de embuti-los.
- As obras contidas na sequência de bytes seguem a sua licença original. A origem e a licença registram-se com Meta.
