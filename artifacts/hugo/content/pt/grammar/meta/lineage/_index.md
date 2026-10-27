---
title: "Meta — Linhagem"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "A classe de linhagem do Meta (3 bits superiores `011`, `0x30`~`0x3F`) registra, com o modelo de commit do git, de que e como o documento surgiu."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A classe de linhagem do Meta (3 bits superiores `011`, Codec `0x30`~`0x3F`) registra de que e como o documento surgiu. A linhagem segue o modelo de commit do git, e a unidade equivalente ao commit é o documento.

- O **hash de conteúdo** aponta para o conteúdo de uma cópia do documento (git commit id). É o SHA-256 do registro de abertura (`DOC-*`) até imediatamente antes de `END`, e os registros da classe de verificação (`100`) ficam fora do cálculo.
- O **ID da versão** é um inteiro de 2 WORDs numerado a partir de 1 na ordem de publicação dentro de um documento com nome. `0` significa que a versão não foi informada.
- Os Meta de linhagem apontam para as versões pelo hash de conteúdo. Como o `PARENT` dentro do documento também entra no hash, o hash de conteúdo forma uma cadeia de hashes que liga todo o histórico.
- O histórico não se apaga. O que foi corrigido sai em uma nova versão. Ponteiros mutáveis, como branch, não ficam no documento.
- `DELTA-BASE` e `DELTA-REMOVE` são o formato que armazena uma versão como diff em relação a uma versão base. A versão é sempre definida como snapshot.

As regras de revisão estão em [Documento](/pt/grammar/document/).
