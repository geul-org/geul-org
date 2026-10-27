---
title: "MODIFIED-AT"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "MODIFIED-AT é o Meta de proveniência que registra, como Value TIME, o instante em que o documento foi modificado."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o instante em que o documento foi modificado.

## Layout

```
TAG WORD          0001 1LLL L010 0011      Codec 0x23
[TAG estendida de Length]
Payload           um Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS etc.)
```

- Codec: Meta `0x23`, classe de proveniência (`010`)
- Payload: Value embutido (família TIME: [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/pt/grammar/value/time/posix-timestamp-seconds/) etc.)
- Quantidade: no máximo um

## Interpretação e validade

- O formato é escolhido entre os Values da família TIME. Se for preciso mais precisão, usa-se o formato em nanossegundos definido por um Issuer (por exemplo, [POSIX-TIMESTAMP-NANOSECONDS](/pt/grammar/value/time/posix-timestamp-nanoseconds/)).
