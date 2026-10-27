---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID é o Meta de linhagem que registra na lista de versões o LOCAL ID que a próxima versão do documento atribuirá a novas descrições (auto increment)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o LOCAL ID que a próxima versão desse documento atribuirá a novas descrições (auto increment de um DBMS, `AUTO_INCREMENT` do MySQL). Todos os LOCAL IDs atribuídos em qualquer versão do documento são menores que este valor.

## Layout

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           próximo LOCAL ID a atribuir, inteiro sem sinal na menor largura
```

- Codec: Meta `0x3C`, classe de linhagem (`011`)
- Payload: valor bruto (inteiro sem sinal na menor largura)
- Quantidade: no máximo um
- Onde fica: no HEAD do documento da lista de versões `versions.geul` ([PUBLICATION](/pt/grammar/edge/publication/))

## Interpretação e validade

- O LOCAL ID (inclusive o Edge Id) é uma identidade que atravessa versões ([Revisão](/pt/grammar/document/#revisão)). Uma nova descrição recebe este valor, e o valor aumenta em 1. Um LOCAL ID excluído não se reutiliza. Por isso, mesmo que se exclua a descrição que tinha o valor máximo, este valor não diminui.
- Como o LOCAL ID `0` não é atribuído, o primeiro valor é `1`. Se ainda não houver versão, este Meta não se coloca e o próximo número é `1`.
- O local de publicação o atualiza e escreve no novo documento de lista quando publica uma versão. Deve ser maior que qualquer LOCAL ID usado nas versões publicadas. Se for menor ou igual, é invalid.
- O valor só cresce. Se for menor que o do documento de lista anterior ([PARENT](/pt/grammar/meta/lineage/parent/)), é invalid.
- Não existe em documentos sem gestão de versões (documentos sem `versions.geul` e documentos sem nome). Esses documentos também não têm diff ([DELTA-BASE](/pt/grammar/meta/lineage/delta-base/)).
- Não se coloca no corpo do documento (o documento de versão). Lembrar o número não é conteúdo do documento, e sim estado do local de publicação que mantém o documento (do lado das refs, não do commit do git).

## Exemplo

Próximo número a atribuir 524:

```
18BC 020C
```

- TAG `18BC` (Meta `0x3C`, `LLLL=0001`, 2 WORD), Payload `020C`.
