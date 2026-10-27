---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION e TOMBSTONE são Edges descritivos que registram a publicação, a recomendação de descontinuação e a exclusão de versões de documentos; esta página também define a especificação do documento da lista de versões escrito com esses Edges (Codec 0x18~0x1A)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edges descritivos que registram a publicação, a deprecação e a exclusão de documentos, e a especificação do documento da lista de versões escrito com esses Edges. Define o formato da lista de versões de [Endereço de publicação e lista de versões](/pt/grammar/publishing/#lista-de-versões).

## Códigos

| Codec | Nome | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, hash de conteúdo |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, categoria do motivo |

- Os três códigos são incorporados ao decodificador ([camada 0](/pt/grammar/publishing/#camadas)). A lista de versões é interpretada sem consultar o codebook.
- Não há subformato (TAG por Codec). Mantém-se tal qual a regra de [Edge](/pt/grammar/edge/) de que o primeiro elemento do Payload é o Edge Id.

## Layout

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Documento         registro Reference DOC-POINTER (Issuer, ID do documento, ID da versão)
Hash de conteúdo  16 WORD   (PUBLICATION)
Categoria motivo  1 WORD    (TOMBSTONE)
```

| Campo | Largura | Descrição |
|---|---|---|
| Edge Id | registro Reference LOCAL | Número de ordem na lista. Numera-se a partir de 1 e acrescenta-se em sequência |
| Documento | registro DOC-POINTER | Uma versão do documento publicado ([DOC-POINTER](/pt/grammar/reference/doc-pointer/)). O Issuer e o ID do documento são os do documento de que a lista trata. Faz o documento de lista dizer de que é a lista mesmo sem caminho. O ID da versão é o número de ordem dentro desse documento ([Documento](/pt/grammar/document/) versão), e `0` (mais recente) não se usa |
| Hash de conteúdo | 16 WORD | Hash de conteúdo dessa versão (SHA-256, [Documento](/pt/grammar/document/) hash de conteúdo) |
| Categoria do motivo | 1 WORD | Código da categoria do motivo da exclusão. A tabela de códigos é uma questão em aberto |

- O comprimento depois do DOC-POINTER é fixo por código (16, 0, 1 WORD). Se for diferente, rejeita-se.
- Não se coloca instante no registro. O `RECORDED-AT` do documento de lista em que o registro apareceu pela primeira vez é o instante da publicação, da deprecação ou da exclusão.

## Documento da lista de versões

O local de publicação mantém, para cada documento, um documento de lista de versões ao qual só se acrescenta: `/<Issuer>/<ID do documento>/versions.geul`. Todas as versões desse documento publicadas por esse local entram numa só lista.

```
DOC-1WORD/2WORD/4WORD     comprimento total
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value SHA-256-DIGEST. Hash de conteúdo do documento de lista anterior (não existe na primeira lista)
  RECORDED-AT             Value POSIX-TIMESTAMP-SECONDS. Instante em que esta lista foi emitida
  NEXT-LOCAL-ID           próximo LOCAL ID a atribuir (se houver versões)
  SIGNATURE               assinatura do local de publicação. O alvo é o hash de conteúdo deste documento de lista
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- Meta do HEAD: [SPEC-VERSION](/pt/grammar/meta/declaration/spec-version/), [PARENT](/pt/grammar/meta/lineage/parent/), [RECORDED-AT](/pt/grammar/meta/provenance/recorded-at/), [NEXT-LOCAL-ID](/pt/grammar/meta/lineage/next-local-id/), [SIGNATURE](/pt/grammar/meta/verification/signature/).
- O documento de lista não tem `DOC-ID` (exceção para documentos cujo nome não começa com `0x`, [DOC-ID](/pt/grammar/meta/declaration/doc-id/)). A lista não é um documento publicado, e sim um registro que acompanha esse documento. De que documento é a lista é dito pelo ID do documento nos registros. Assim, mesmo recebida sem caminho (`h/`, dump), sabe-se de que é a lista.
- O ID do documento de todos os registros deve ser o do documento de que a lista trata. Registros de outro documento são rejeitados.
- O documento de lista não tem IMPORT e só usa Codecs da camada 0. Não é incluído em outra lista (não há lista de listas).
- O novo documento de lista mantém na frente o BODY do documento de lista anterior, tal como estava, e acrescenta registros. Não se corrige, não se apaga e não se muda a ordem.
- O local de publicação assina a lista. Na publicação do geul.org, assina o geul.org (Issuer GEUL); na publicação privada, assina o próprio Issuer.
- O ID de documento `0x0000000000000000` é o documento de índice de definição de termos do Issuer ([Issuer e publicação](/pt/grammar/issuer/)). O próprio Issuer é apontado por [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/).

## Regras

- O ID da versão de PUBLICATION é crescente a partir de 1, sem lacunas. O ID da versão é atribuído pelo local de publicação.
- O mesmo hash de conteúdo não se publica de novo. Se já existe, devolve-se o ID de versão existente.
- DEPRECATION e TOMBSTONE só apontam para o ID de versão de um PUBLICATION que veio antes. Apontar para uma versão inexistente é rejeitado.
- O estado de uma versão é calculado aplicando os registros em sequência: publicada → deprecated → excluída. Uma versão excluída não se publica de novo nem se entrega.
- A versão mais recente é a de maior ID de versão que não é nem deprecated nem excluída.
- Quando o ID da versão chega ao fim dos 2 WORDs, esse documento não publica mais e sai com um novo ID de documento.

## Nome do documento

O nome de documento para endereço é ligado por [BIND](/pt/grammar/edge/bind/) no índice de nomes do Issuer `/<Issuer>/documents.geul` ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#nome-do-documento)). O resolvedor lê apenas esse índice.

O documento de lista também pode ter o mesmo BIND (opcional). Se tiver, observa-se o seguinte.

- O Subject é um `DOC-POINTER` (Issuer, ID do documento dessa lista, versão `0`). O nome liga-se ao documento, não à versão, por isso a versão é `0`.
- Só se liga a documentos que tiveram antes um PUBLICATION. Não se liga nome a um documento nunca publicado.
- O nome segue a regra de nome de documento (slug ASCII em minúsculas) e deve ser igual ao BIND do índice de nomes.
- Ao mudar o nome, acrescenta-se um novo BIND. O nome antigo permanece e continua apontando para o mesmo documento. O nome representativo é o último BIND.
- O documento não escreve o próprio nome.

## Endereço

```
/.well-known/geul/<Issuer>/<ID do documento>/versions.geul             documento de lista mais recente (mutável)
/.well-known/geul/h/<hash de conteúdo>.geul                           documentos de lista anteriores (imutáveis)
```

- O único mutável é o endereço da lista mais recente. A lista recebida é verificada por sua assinatura, `RECORDED-AT` e cadeia `PARENT`.
- Todos os documentos de lista anteriores permanecem em `h/`. Seguindo a cadeia `PARENT`, pode-se reconstituir a lista de qualquer momento.

## Verificação

- O documento de lista deve ter o `SIGNATURE` da chave determinada do local de publicação.
- O ID do documento nos registros deve ser igual ao ID do documento solicitado.
- O hash de conteúdo da lista anterior guardado no registro de bloqueio deve estar na cadeia `PARENT` da nova lista. O BODY dessa lista deve ser igual ao início do BODY da nova lista.
- O hash de conteúdo do documento recebido deve ser igual ao valor escrito no PUBLICATION desse ID de versão, e o `DOC-ID` do documento deve ser igual ao Issuer e ao ID do documento solicitados.

## Questões em aberto

- Tabela de códigos das categorias de motivo.
- Valor padrão do algoritmo de assinatura e layout do Payload de `SIGNATURE`.
- Quando e em que formato passar, com listas grandes, para um log Merkle (provas de inclusão e consistência).
- Se o BIND da lista e o índice de nomes `documents.geul` serão unificados, e a assinatura do índice.
- Prevenção de rebobinamento por Issuer. Como cada documento tem a sua própria cadeia de listas, um ataque que apresente uma lista antiga de um só documento só é barrado pela cadeia desse documento.

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [BIND](/pt/grammar/edge/bind/), [DOC-POINTER](/pt/grammar/reference/doc-pointer/)
- [Issuer e publicação](/pt/grammar/issuer/), [Endereço de publicação e lista de versões](/pt/grammar/publishing/), [Documento](/pt/grammar/document/)
