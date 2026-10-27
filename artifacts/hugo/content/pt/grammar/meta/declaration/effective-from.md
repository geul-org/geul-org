---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM é o Meta de definição que declara, como Value de data ou timestamp, a data de entrada em vigor desta versão."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declara a data de entrada em vigor desta versão. A data de vigência é diferente do instante de publicação ([Revisão](/pt/grammar/document/#revisão)).

## Layout

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[TAG estendida de Length]
Payload           um Value TIME
```

- Codec: Meta `0x13`, classe de definição (`001`)
- Payload: Value embutido ([GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/) ou [POSIX-TIMESTAMP-SECONDS](/pt/grammar/value/time/posix-timestamp-seconds/))
- Quantidade: no máximo um

## Interpretação e validade

- Se não houver, vigora a partir do instante da publicação.
- Se houver [EFFECTIVE-UNTIL](/pt/grammar/meta/declaration/effective-until/), deve ser anterior a ele.
- Se a data de vigência difere por artigo, escreve-se à parte no Edge desse artigo com os QUALIFIERs P580 (início) e P582 (fim) ([SOURCE](/pt/grammar/edge/source/#outras-formas-de-expressar-o-fundamento)).
- Este valor é lido quando o documento é interpretado em relação a um instante determinado.

## Exemplo

- Em vigor desde 1970-01-02: `0x1993 0x0920 0x0000 0x0001`
