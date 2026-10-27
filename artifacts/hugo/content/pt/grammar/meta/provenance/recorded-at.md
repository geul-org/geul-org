---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT é o Meta de proveniência que registra, como Value TIME, o instante em que se gravou o documento (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o instante em que se gravou o documento (git commit date).

## Layout

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[TAG estendida de Length]
Payload           um Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS etc.)
```

- Codec: Meta `0x25`, classe de proveniência (`010`)
- Payload: Value embutido (família TIME: [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/pt/grammar/value/time/posix-timestamp-seconds/) etc.)
- Quantidade: no máximo um

## Interpretação e validade

- O formato é escolhido entre os Values da família TIME. Se for preciso mais precisão, usa-se o formato em nanossegundos definido por um Issuer (por exemplo, [POSIX-TIMESTAMP-NANOSECONDS](/pt/grammar/value/time/posix-timestamp-nanoseconds/)).
- O documento da lista de versões ([PUBLICATION](/pt/grammar/edge/publication/)) usa este valor como instante de publicação, deprecação (deprecate) e exclusão.

## Questões em aberto

- O Meta de proveniência entra no hash de conteúdo. Se se admite que o mesmo conteúdo gravado em instantes diferentes tenha hashes diferentes.
