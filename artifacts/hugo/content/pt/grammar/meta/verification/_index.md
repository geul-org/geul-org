---
title: "Meta — Verificação"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "A classe de verificação do Meta (3 bits superiores `100`, `0x40`~`0x4F`) registra a matéria-prima para julgar se o documento é confiável (chave pública, assinatura, grau de confiança, julgamento)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A classe de verificação do Meta (3 bits superiores `100`, Codec `0x40`~`0x4F`) registra a matéria-prima para julgar se o documento é confiável: a chave pública de um Issuer autoemitido, a assinatura, a confirmação do direito de contribuir, o grau de confiança e o resultado do julgamento do documento inteiro.

- A classe de verificação fica fora do cálculo do hash de conteúdo. Por isso, o hash de conteúdo não muda mesmo que se ponha a assinatura dentro do documento ou se acrescentem várias assinaturas (mesmo modo que o `gpgsig` do git).
- A classe é conhecida pelos 3 bits superiores do Codec, de modo que se pode calcular o hash sem codebook.
- O julgamento por nó ou registro fica a cargo do `VERDICT` do Edge [TOULMIN](/pt/grammar/edge/toulmin/) (`0x78`).
