---
title: "Meta — Definição"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "A classe de definição do Meta (3 bits superiores `001`, `0x10`~`0x1F`) são declarações de interpretação. Define a versão da especificação, o perfil, o ID do documento, o período de vigência e o idioma padrão."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A classe de definição do Meta (3 bits superiores `001`, Codec `0x10`~`0x1F`) são declarações de interpretação. Como as declarações mudam as regras de interpretação, todos os decodificadores devem processá-las. O âmbito de uma declaração é o seu documento.

- `SPEC-VERSION` define como ler os demais registros e, por isso, contém só um inteiro, sem Value embutido. O GEUL v1 é `0x0001` (registro `1890 0001`).
- `DOC-ID` é um `DOC-POINTER` (Issuer, ID do documento, versão `0`) que aponta para o próprio documento. Sem ele, é um documento sem nome, que só pode ser apontado pelo hash de conteúdo.
- O nome de um documento para o endereço não é posto como Meta. O índice de nomes do Issuer `documents.geul` o liga com um `BIND` descritivo, e o título legível por pessoas liga-se com `LABEL` ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#nome-do-documento)).
