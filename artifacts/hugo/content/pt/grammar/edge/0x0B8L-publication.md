---
title: "PUBLICATION (0x0B8L)"
weight: 184
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION e TOMBSTONE são Edges de enunciado que registram a publicação, a recomendação de descontinuação e a remoção de versões de documento, e esta página também define a especificação do documento de lista de versões escrito com esses Edges (Codec 0x0B8L~0x0BAL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION, DEPRECATION e TOMBSTONE são Edges de enunciado que registram a publicação, a recomendação de descontinuação e a remoção de versões de documento, e esta página também define a especificação do documento de lista de versões escrito com esses Edges (Codec 0x0B8L~0x0BAL).

| Item | Valor |
|---|---|
| Nome | `PUBLICATION` (BIND `PUBLICATION` do documento de especificação) |
| TAG ID | `0x0B8L` |
| Codec ID | `0x00000B80` |
| Documento de especificação | `0x00000000/codecs/0x00000B80/` (alvo do DECLARE `0B80`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 24 |
| Kind | Edge · família: enunciado, grupo: outros |
| TAG WORD | `0000 1011 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | publicação do documento. DOC-POINTER, hash de conteúdo |
| Lado Hugo | `edge/publication.md` (esse lado trata também de [DEPRECATION](0x0B9L-deprecation.md), [TOMBSTONE](0x0BAL-tombstone.md)) |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | registro | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `hash` | #4 | valor bruto 16 WORD |  |  |

Edges de enunciado que registram a publicação, a descontinuação (deprecate) e a remoção de documentos, e a especificação do documento de lista de versões escrito com esses Edges. Define o formato da lista de versões de [endereço de publicação e lista de versões](../publishing.md#버전-목록).

## Códigos {#코드}

| Codec | Nome | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, DOC-POINTER, hash de conteúdo |
| `0x0B9L` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, DOC-POINTER, categoria do motivo |

- Os três códigos são embutidos no decodificador ([camada 0](../publishing.md#층)). A lista de versões é interpretada sem consultar o codebook.
- Não há subformato (TAG específica do Codec). Mantém-se a regra de [Edge](_index.md) de que o primeiro elemento do Payload é o Edge Id.

## Layout {#레이아웃}

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
documento         registro Reference DOC-POINTER (Issuer, ID do documento, ID da versão). Para a lista de versões de um codec, CODEC-POINTER
hash de conteúdo  16 WORDs   (PUBLICATION)
motivo            1 WORD    (TOMBSTONE)
```

| Campo | Largura | Descrição |
|---|---|---|
| Edge Id | registro Reference LOCAL | número de ordem na lista. Numera-se a partir de 1 e acrescenta-se em seguida |
| documento | registro DOC-POINTER | uma versão do documento publicado ([DOC-POINTER](../reference/0x041L-doc-pointer.md)). O Issuer e o ID do documento são os mesmos do documento de que a lista trata. Permite que o documento de lista diga de que é a lista, mesmo sem caminho. O ID da versão é o número de ordem dentro desse documento (versão do [documento](../document.md)) e não se usa `0` (a mais recente). A lista de versões de um codec usa [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, ID do codec, ID da versão) |
| hash de conteúdo | 16 WORDs | hash de conteúdo dessa versão (SHA-256, hash de conteúdo do [documento](../document.md)) |
| categoria do motivo | 1 WORD | código de categoria do motivo da remoção. A tabela de códigos é um problema em aberto |

- O comprimento depois do DOC-POINTER é fixo para cada código (16, 0, 1 WORD). Se for diferente, rejeita-se.
- O instante não entra no registro. O `RECORDED-AT` do documento de lista em que o registro apareceu pela primeira vez é o instante da publicação, da descontinuação ou da remoção.

## Documento de lista de versões {#버전-목록-문서}

O publicador mantém, para cada documento, um documento de lista de versões, ao qual vai acrescentando: `/<Issuer>/docs/<ID do documento>/versions.geul` (para um codec, `/<Issuer>/codecs/<ID do codec>/versions.geul`; para a lista de Issuers, ver [abaixo](#목록-문서의-버전-목록)). Todas as versões desse documento publicadas por esse publicador entram em uma única lista.

```
DOC-1WORD/2WORD/4WORD     comprimento total
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value SHA-256-DIGEST. Hash de conteúdo do documento de lista anterior (ausente se for a primeira lista)
  RECORDED-AT             Value POSIX-TIMESTAMP-SECONDS. Instante em que esta lista foi emitida
  NEXT-LOCAL-ID           próximo LOCAL ID a atribuir (se houver versões)
  SIGNATURE               assinatura do publicador. O alvo é o hash de conteúdo deste documento de lista
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- Meta do HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- O documento de lista de versões não tem `DOC-ID` (exceção dos documentos de lista, [DOC-ID](../meta/0x1C7L-doc-id.md)). A lista não é um documento publicado, mas um registro anexo a esse documento. De que documento é a lista diz o DOC-POINTER (ID do documento) do registro. Por isso, mesmo recebida sem caminho (`hashes/`, dump), sabe-se de que é a lista.
- Todos os IDs de documento dos registros devem ser o do documento de que a lista trata. Rejeitam-se registros de outros documentos.
- O documento de lista de versões não tem IMPORT e usa só Codecs da camada 0. O BODY contém apenas PUBLICATION, DEPRECATION e TOMBSTONE. Não se põe BIND de nome de documento ([endereço de publicação e lista de versões](../publishing.md#문서-이름)).
- O novo documento de lista mantém, no início, o BODY do documento de lista anterior tal como está e acrescenta registros. Não corrige, não apaga e não muda a ordem.
- O publicador assina a lista. A publicação do geul.org é assinada pelo geul.org (Issuer GEUL), e a publicação privada pelo respectivo Issuer.
- O ID de documento `0x0000000000000000` é o documento de índice de definição de termos do Issuer ([Issuer e publicação](../issuer.md)). O próprio Issuer é apontado por [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).

## Lista de versões do documento de lista {#목록-문서의-버전-목록}

O documento de lista é a lista de Issuers `issuers/`, um só ([endereço de publicação e lista de versões](../publishing.md#목록-문서)). A lista de Issuers também começa na versão 1 e tem a lista de versões `issuers/versions.geul`. O registro aponta para a versão da lista por um DOC-POINTER com o ID de documento reservado (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, ID da versão).

- O formato do registro é o mesmo de cima. Por isso, mesmo recebida por `hashes/`, sabe-se de que é a lista.
- O próprio documento de lista (`<ID da versão>.geul`) também não tem `DOC-ID`.
- O ID de documento `0xFFFFFFFFFFFFFFFF` não é recebido em nenhum Issuer pelo endereço `<Issuer>/docs/<ID do documento>/` (404).
- O `latest.geul` da lista é um alias que não se armazena. Encontra-se a versão mais recente nesta lista de versões e emitem-se os seus bytes.

## Regras {#규칙}

- O ID de versão de PUBLICATION é ascendente a partir de 1, sem lacunas. O ID de versão é atribuído pelo publicador.
- Não se republica o mesmo hash de conteúdo. Se já existir, devolve-se esse ID de versão.
- DEPRECATION e TOMBSTONE apontam apenas para o ID de versão de um PUBLICATION que apareceu antes. Se apontarem para uma versão inexistente, rejeita-se.
- O estado de uma versão calcula-se aplicando os registros em ordem. publicada → deprecated → removida. Uma versão removida não se republica nem se entrega.
- A versão mais recente é o maior ID de versão que não é deprecated nem removido.
- Quando o ID de versão chega ao fim de 2 WORDs, esse documento não é mais publicado e emite-se com um novo ID de documento.

## Endereços {#주소}

```
/.well-known/geul/<Issuer>/docs/<ID do documento>/versions.geul        documento de lista mais recente (mutável)
/.well-known/geul/<Issuer>/codecs/<ID do codec>/versions.geul      documento de lista mais recente do codec (mutável)
/.well-known/geul/issuers/versions.geul                       lista de versões mais recente da lista de Issuers (mutável)
/.well-known/geul/<Issuer>/hashes/<hash de conteúdo>.geul             documentos de lista anteriores (imutável)
```

- O mutável é o endereço da lista mais recente. A lista recebida é verificada pela assinatura, por `RECORDED-AT` e pela cadeia `PARENT`.
- Todos os documentos de lista anteriores ficam em `<Issuer>/hashes/`. Seguindo a cadeia `PARENT` pode-se reconstituir a lista em qualquer momento.

## Verificação {#검증}

- O documento de lista deve ter o `SIGNATURE` da chave do publicador designado.
- O ID de documento do registro deve ser igual ao ID de documento solicitado.
- O hash de conteúdo da lista anterior registrado no log de bloqueio deve estar na cadeia `PARENT` da nova lista. O BODY dessa lista deve ser igual à parte inicial do BODY da nova lista.
- O hash de conteúdo do documento recebido deve ser igual ao valor registrado no PUBLICATION desse ID de versão, e o `DOC-ID` do documento deve ser igual ao Issuer e ao ID de documento solicitados. O documento de lista não tem `DOC-ID`.

## Problemas em aberto {#열린-문제}

- Tabela de códigos da categoria do motivo.
- Valor padrão do algoritmo de assinatura e layout do Payload de `SIGNATURE`.
- Quando e em que formato migrar, à medida que a lista cresce, para um log de Merkle (provas de inclusão e consistência).
- Prevenção de rollback por Issuer. Como a lista forma uma cadeia separada para cada documento, o ataque de apresentar uma lista antiga de apenas um documento só é barrado pela cadeia desse documento.

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer e publicação](../issuer.md), [endereço de publicação e lista de versões](../publishing.md), [documento](../document.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000B80/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B8000000000
BODY
#1 DECLARE 0x0B80
#2 FIELD #1 record
#9 CODEC #2 0x0410
#4 FIELD #1 0x0010
#5 BIND #1 "PUBLICATION"
#6 BIND #2 "doc"
#8 BIND #4 "hash"
#10 CODEC #2 0x0420
```
