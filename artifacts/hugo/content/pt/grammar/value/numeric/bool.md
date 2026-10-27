---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL é um Value fixo de 2 WORD que contém os valores lógicos false e true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL é o Value que representa os valores lógicos false e true. Código direto de Value `0x00`, família NUMERIC. É um tipo diferente de SIGNED-INTEGER e UNSIGNED-INTEGER, que contêm os números 0 e 1.

## Layout

```
TAG WORD          0x0880 (0000 1000 1000 0000)  total de 2 WORD
Payload           1 WORD  Boolean Code
```

## Interpretação e validade

- O Payload `0000` é false e `0001` é true.
- Não há padding nem descriptor.
- O Payload é exatamente `0000` ou `0001`. Qualquer outro valor de 16 bits é rejeitado como invalid.
- Qualquer outra representação de Length é rejeitada como invalid.

## Comprimento

- O total é exatamente 2 WORD, a soma de 1 WORD de TAG e 1 WORD de Payload, e usa o comprimento direto `LLLL=0001`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 1 WORD, rejeita-se.

## Exemplo

| Registro completo (TAG + Payload) | Payload | Julgamento |
|---|---|---|
| `0880 0000` | `0000` | false, canônico |
| `0880 0001` | `0001` | true, canônico |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| TAG com Length diferente de `0001` + `0000` ou `0001` | `0000` ou `0001` | invalid |

## Status do formato

- Esta representação, que une a code word de 16 bits `0000`/`0001` à TAG do GEUL, é um scalar profile próprio do GEUL.
- O valor lógico em si é universal, mas não se afirma que exista uma única norma industrial correspondente a esta representação de 1 WORD.
