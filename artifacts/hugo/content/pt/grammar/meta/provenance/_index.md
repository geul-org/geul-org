---
title: "Meta — Proveniência"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "A classe de proveniência do Meta (3 bits superiores `010`, `0x20`~`0x2F`) registra quem e quando criou e registrou o documento. O material de origem escreve-se com o Edge de fundamento SOURCE."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A classe de proveniência do Meta (3 bits superiores `010`, Codec `0x20`~`0x2F`) registra quem e quando criou e registrou o documento.

- O autor, quem registrou e os seus instantes seguem o modelo de author e committer do git (`AUTHOR` e `CREATED-AT`, `RECORDED-BY` e `RECORDED-AT`).
- Mesmo apagando a proveniência, o conteúdo descrito não muda. Só desaparece a matéria-prima do julgamento de confiança.
- O material de origem não está nesta classe. A fonte do documento inteiro escreve-se no HEAD, e a de cada registro no BODY, com o Edge de fundamento [SOURCE](/pt/grammar/edge/source/). A faixa correspondente dentro do texto original, o instante de obtenção e o hash do texto original são QUALIFIERs ligados a esse SOURCE (página P304 · seção P958, data de consulta P813, checksum P4092).
- Se as propriedades que acompanham a fonte (faixa do texto original, instante de obtenção) fossem postas como Meta, não se poderia determinar de qual fonte são quando há várias. Por isso se escrevem com um QUALIFIER que tem o SOURCE como Target. Os Codecs `0x26`~`0x2F` são reservados.
