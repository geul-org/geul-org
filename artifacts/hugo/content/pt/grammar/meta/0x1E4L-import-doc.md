---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Importa um documento externo por IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `IMPORT-DOC` (BIND `IMPORT-DOC` do documento de especificação) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| Documento de especificação | `0x00000000/codecs/0x00001E40/` (alvo do DECLARE `1E40`) |
| Seção | 15 `1111` (Meta), deslocamento C = 4 na seção |
| Kind | Meta · classe: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Importa um documento externo por IMPORT ID. Reference embutida `DOC-POINTER` (`CODEC-POINTER` para documentos de Codec) + IMPORT ID |
| Lado Hugo | `meta/import/import-doc.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | registro | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | valor bruto restante(`0xFFFF`) |  |  |

Importa um documento externo por IMPORT ID. O documento a importar é apontado por [DOC-POINTER](../reference/0x041L-doc-pointer.md), que também carrega a largura do Issuer.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[TAG de extensão de Length]
Documento         Registro Reference DOC-POINTER (Issuer, ID do documento, ID de versão. Versão 0 é a mais recente). Documentos de Codec usam CODEC-POINTER
IMPORT ID         Todo o restante. Sem sinal, na menor largura
```

- Codec: Meta `0x1E4L`, classe de IMPORT
- Payload: Reference embutida `DOC-POINTER` (Issuer, ID do documento, ID de versão) + valor bruto IMPORT ID
- Quantidade: vários possíveis (um por IMPORT ID)

## Interpretação e validade {#해석과-유효성}

- O documento é exatamente um registro DOC-POINTER. Ao importar um documento de Codec, é um registro [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID de versão). Termina no seu próprio Length, e o restante é o IMPORT ID.
- O IMPORT ID tem 1 WORD ou mais, na menor largura. A largura do IMPORT ID é definida aqui pelo comprimento do registro e, em [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md), pelo Codec.
- Num mesmo documento, não se atribui o mesmo IMPORT ID duas vezes.
- Se um ID de versão for indicado, liga-se a essa edição; se for `0`, liga-se à edição mais recente no momento da interpretação (ou à que estava em vigor no momento especificado) ([revisão](../document.md#개정)).
- O [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) do BODY aponta para um LOCAL do documento importado por IMPORT ID. O próprio documento importado é apontado por DOC-POINTER.
- O HEAD do documento importado não é importado. Os alvos desse documento são interpretados conforme as declarações desse documento.
- Não é possível buscar entre documentos por IMPORT ID. Um repositório que carrega vários documentos resolve e armazena o IMPORT ID como caminho completo (Issuer, ID do documento, ID de versão, LOCAL ID).

## Exemplo {#예시}

- IMPORT ID 1, Issuer `0x00000002`, documento `0x…0002`, mais recente: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (TAG Meta 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORDs)

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E40/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
