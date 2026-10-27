---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC é o Meta de IMPORT que aponta um documento externo por DOC-POINTER e atribui um IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Importa um documento externo por IMPORT ID. O documento a importar é apontado por [DOC-POINTER](/pt/grammar/reference/doc-pointer/), e a largura do Issuer também vem no DOC-POINTER.

## Layout

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[TAG estendida de Length]
Documento         registro Reference DOC-POINTER (Issuer, ID do documento, ID da versão. Com versão 0, a mais recente)
IMPORT ID         todo o restante. Sem sinal, na menor largura
```

- Codec: Meta `0x60`, classe IMPORT (`110`)
- Payload: Reference embutida `DOC-POINTER` (Issuer, ID do documento, ID da versão) + IMPORT ID como valor bruto
- Quantidade: vários possíveis (um por IMPORT ID)

## Interpretação e validade

- O documento é exatamente um registro DOC-POINTER. Termina no seu próprio Length, e o restante é o IMPORT ID.
- O IMPORT ID tem 1 WORD ou mais, na menor largura. A largura do IMPORT ID é determinada aqui pelo comprimento do registro e, em [EXTERNAL-POINTER-*](/pt/grammar/reference/external-pointer/), pelo Codec. O IMPORT ID só vale dentro desse documento.
- Num documento, o mesmo IMPORT ID não se atribui duas vezes.
- Se o ID da versão for escrito, vincula-se a essa edição; se for `0`, à edição mais recente no momento da interpretação (ou à edição em vigor no instante indicado) ([Revisão](/pt/grammar/document/#revisão)).
- O [EXTERNAL-POINTER-*](/pt/grammar/reference/external-pointer/) do BODY aponta para o LOCAL do documento importado por IMPORT ID. O próprio documento importado é apontado por DOC-POINTER.
- O HEAD do documento importado não é importado. Os alvos desse documento são interpretados conforme as declarações dele.
- Não se pode buscar atravessando documentos pelo IMPORT ID. Um repositório que carrega vários documentos armazena o IMPORT ID resolvido para o caminho completo (Issuer, ID do documento, ID da versão, LOCAL ID).

## Exemplo

- IMPORT ID 1, Issuer `0x0001`, documento `0x…0002`, mais recente: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (TAG do Meta 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
