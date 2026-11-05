---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Registra o método pelo qual outra representação foi convertida neste documento (por exemplo, conversor do Wikidata, codificador de linguagem natural)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `TRANSFORMED-BY` (BIND `TRANSFORMED-BY` do documento de especificação) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| Documento de especificação | `0x00000000/codecs/0x00001D40/` (alvo do DECLARE `1D40`) |
| Seção | 14 `1110` (Meta), deslocamento C = 20 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Método de conversão. Ferramenta, regra e versão |
| Lado Hugo | `meta/lineage/transformed-by.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `version` | #3 | registro | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

Registra o método pelo qual outra representação foi convertida neste documento (por exemplo, conversor do Wikidata, codificador de linguagem natural). Tool indica com o que se converteu; Version indica com qual fonte dessa ferramenta se converteu. Só com os dois é possível recriar o mesmo documento a partir da mesma entrada.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[TAG de extensão de Length]
Tool              1 registro Reference (ferramenta ou regra de conversão)
Version           1 registro Value (SHA-256-DIGEST ou SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`, classe de linhagem
- Payload: Reference embutida (ferramenta) + Value embutido (digest da versão-fonte)
- Quantidade: vários possíveis (um por ferramenta)

## Interpretação e validade {#해석과-유효성}

- Tool é exatamente um registro Reference completo. Qualquer Reference que aponte para a ferramenta pode ser usada.
  - Ferramenta de um documento de ferramenta de geul.org: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md) (`0x00000000`, ID de documento `0x0001xxxx xxxxxxxx`, o seu LOCAL). Cada ferramenta tem um documento ([Issuer](../issuer.md), documento de definição de termos).
  - Se o codec for um documento GEUL, aponta-se para esse documento de Codec com [CODEC-POINTER](../reference/0x042L-codec-pointer.md).
- Version é exatamente um registro Value completo e é o ID do objeto de controle de versão da fonte de Tool. No git, é o ID completo do objeto de commit.
  - Se o formato de objeto do repositório git for SHA-256, usa-se [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) (`0x07CL`, 16 WORDs); se for SHA-1, [SHA1-DIGEST](../value/0x07DL-sha1-digest.md) (`0x07DL`, 10 WORDs). O formato do repositório verifica-se com `git rev-parse --show-object-format`.
  - Não se usam IDs abreviados (`2bd496f` etc.). O Value de digest não admite valores truncados.
  - Não se escreve como texto hexadecimal (UTF8-TEXT). O mesmo valor ocupa 22 WORDs em SHA-1 (11 em binário) e 34 WORDs em SHA-256 (18 em binário).
- Version é obrigatório. Um registro de ferramenta sem versão-fonte conhecida não serve de base para reprodução. Para uma ferramenta fora do controle de versão, usa-se o SHA-256 do artefato distribuído (SHA-256-DIGEST).
- Version aponta para a fonte commitada. Num documento produzido com uma árvore de trabalho que tenha alterações não commitadas, não se usa esse ID de commit (recomenda-se que a ferramenta recuse a execução).
- Se a ferramenta depender de código fora do repositório (por exemplo, uma biblioteca local apontada por Go `replace`), esse código também é registrado à parte com TRANSFORMED-BY. O ID de commit da ferramenta, sozinho, não determina esse código.
- Ferramentas que apenas transferem a origem sem perdas (por exemplo, uma ferramenta que carrega um dump no banco de dados tal como está) não determinam o conteúdo do documento e, portanto, não são registradas. Um carregamento com perdas altera o documento e, por isso, é registrado como ferramenta.
- O documento de especificação de geul.org (`0x1D40`) é escrito com dois campos de registro: Tool (largura 0, qualquer Reference, portanto sem CODEC) e Version (largura 0, [CODEC](../edge/0x0BEL-codec.md) `07C0` e `07D0`).

## Comprimento {#길이}

```
Total = 1 + N_len + N_tool + N_version WORDs
```

- O cursor, depois de ler todos os registros finais, deve coincidir exatamente com o fim do Meta.
- Se Tool for EXTERNAL-ISSUER-2WORD (8 WORDs) e Version for SHA1-DIGEST (11 WORDs), o total é 1 + 1 + 8 + 11 = 21 WORDs e usa-se o comprimento estendido. Com SHA-256-DIGEST (18 WORDs), são 28 WORDs.

## Exemplo {#예시}

Exemplo não normativo. A ferramenta é o LOCAL 2 (`02F7 0000 0000 0001 0000 0000 0001 0002`) do documento de ferramenta de geul.org `0x0001000000000001`, e a fonte é o commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Problemas em aberto {#열린-문제}

- Resta decidir se a versão de [GENERATED-BY](0x1D3L-generated-by.md) também deve passar ao mesmo esquema (digest obrigatório ou outro formato). A versão de um modelo não é um ID de commit.

## Páginas relacionadas {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001D40/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
