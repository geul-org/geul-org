---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER é a Reference de indicação que aponta para o LOCAL ID de um documento importado pelo IMPORT-DOC do HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER é a Reference de indicação que aponta para o LOCAL ID de um documento importado pelo [IMPORT-DOC](/pt/grammar/meta/import/import-doc/) do HEAD.

## Layout

```
TAG WORD          0000 0LLL L10W WQQQ      CCCC = 10WW
[TAG estendida de Length]
IMPORT ID         largura determinada por WW (00=1, 01=2, 10=4, 11=8 WORD)
ID do alvo        todo o restante. LOCAL ID do documento importado, na menor largura
```

| CCCC | Nome | Largura do IMPORT ID |
|---|---|---|
| `1000` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `1001` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `1010` | EXTERNAL-POINTER-4WORD | 4 WORD |
| `1011` | EXTERNAL-POINTER-8WORD | 8 WORD |

- Usa-se o Codec mais estreito em que o valor do IMPORT ID cabe.
- O IMPORT ID é o valor atribuído pelo `IMPORT-DOC` deste documento e só vale dentro dele. O EXTERNAL-POINTER não escreve o Issuer. O Issuer e o ID do documento vêm desse `IMPORT-DOC`. A versão também é determinada por esse `IMPORT-DOC` (fixa ou mais recente).
- Com o mesmo LOCAL ID do documento importado, é o mesmo alvo, quer seja usado como LOCAL dentro desse documento, quer como EXTERNAL-POINTER aqui.
- Se for Variable, é a variável LOCAL do documento importado.

## Validade

- Se não houver neste documento um `IMPORT-DOC` que tenha atribuído esse IMPORT ID, é invalid.
- Se o IMPORT ID couber num Codec mais estreito e se usar um mais largo, rejeita-se por não ser mínimo.
- Se o ID de alvo for `0`, é invalid. O próprio documento importado é apontado por [DOC-POINTER](/pt/grammar/reference/doc-pointer/).
- Proíbe-se WORD `0x0000` à frente no ID do alvo.

## Exemplo

| Alvo | Sequência de WORDs |
|---|---|
| LOCAL 5 do IMPORT ID 1 | `0140 0001 0005` |
| LOCAL 65536 do IMPORT ID 1 | `01C0 0001 0001 0000` |
| LOCAL 5 do IMPORT ID 70000 | `01C8 0001 1170 0005` |

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [LOCAL](/pt/grammar/reference/local/), [EXTERNAL-ISSUER](/pt/grammar/reference/external-issuer/), [DOC-POINTER](/pt/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/pt/grammar/meta/import/import-doc/)
