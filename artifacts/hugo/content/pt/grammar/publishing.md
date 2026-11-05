---
title: "Endereço de publicação e lista de versões"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "O GEUL aponta documentos por ID (Issuer, ID do documento, ID da versão), e não por URL em texto."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

O GEUL aponta documentos por ID (Issuer, ID do documento, ID da versão), e não por URL em texto. O endereço é determinado pelo ID. Esta página define as regras de publicação de que codificadores, decodificadores e resolvedores precisam para funcionar em conjunto. Os níveis de Issuer e as formas de publicação são definidos em [Issuer e publicação](issuer.md).

## Notação de ID {#id-표기}

Os IDs usados em endereços são escritos em hexadecimal.

- O prefixo é `0x` em minúsculas. O hexadecimal usa A-F em maiúsculas. O resolvedor também procura um endereço escrito em minúsculas convertendo-o para maiúsculas.
- O número de dígitos é fixo em largura × 4. Os zeros à esquerda não são omitidos, e o número de dígitos é a própria largura.
- Ao escrever um endereço, o Issuer é escrito com o número de dígitos da largura de emissão: 2 WORD 8 dígitos, 4 WORD 16 dígitos, 16 WORD 64 dígitos.
- Ao ler, o Issuer é aceito com 8, 16 ou 64 dígitos. A notação mais longa de um Issuer ID curto, com zeros à esquerda, é procurada como o mesmo Issuer (`0x00000001` e `0x0000000000000001` são o mesmo Issuer, [Issuer e publicação](issuer.md#issuer-등급)).

| Objeto | Largura | Dígitos | Exemplo |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 dígitos |
| Codec ID | 2 WORD | 8 | `0x00000AA0` |
| ID do documento | 4 WORD | 16 | `0x0000000000000000` |
| ID da versão | 2 WORD | 8 | `0x00000003` |
| Hash de conteúdo | 16 WORD | 64 | `0x` + 64 dígitos |

- O Codec ID de um código direto do GEUL é o seu TAG WORD (L=0) escrito como valor de 32 bits (TRIPLE `0x0AAL` → `0x00000AA0`). O Kind está contido no TAG, portanto não há colisão.
- Os Codecs de formato ISSUER de outros Issuers ficam sob o `codecs/` desse Issuer, com o número de Codec do registro. Exemplo: o CRC32C do IETF é `0x00000007/codecs/0x0000C000/`.
- O Codec ID de um Codec de Issuer é o número de Codec (2 WORD) do registro. O Issuer atribui os números de Codec de modo que não se repitam dentro do seu `<Issuer>/codecs/`, independentemente do Kind (Reference, Value, Edge). O endereço não se divide por Kind (não há pastas como `references/`, `values/`, `edges/`).
- O resolvedor trata como erro o caso em que o Kind do registro difere do Kind do destino do [DECLARE](edge/0x0BBL-declare.md) do seu documento de Codec.
- A publicação rejeita subir um Codec diferente sob o mesmo Codec ID.
- As regras do ID da versão (a partir de 1, `0` é a mais recente, atribuído pelo publicador, novo ID de documento ao esgotar) são definidas em [documento](document.md#버전).

## Endereço de publicação {#공표-주소}

```
/.well-known/geul/issuers/latest.geul                              Lista de Issuers, mais recente
/.well-known/geul/issuers/<ID da versão>.geul                      Lista de Issuers, versão indicada
/.well-known/geul/issuers/versions.geul                            Lista de versões da lista de Issuers
/.well-known/geul/<Issuer>/codecs/<Codec ID>/latest.geul           Codec, mais recente
/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID da versão>.geul   Codec, versão indicada
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul         Lista de versões do Codec
/.well-known/geul/<Issuer>/docs/<ID do documento>/latest.geul      Documento, mais recente
/.well-known/geul/<Issuer>/docs/<ID do documento>/<ID da versão>.geul   Documento, versão indicada
/.well-known/geul/<Issuer>/docs/<ID do documento>/versions.geul    Lista de versões do documento
/.well-known/geul/<Issuer>/hashes/<hash de conteúdo>.geul          Consulta por hash de conteúdo
```

Exemplo: `/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- O caminho segue o `.well-known` da RFC 8615. geul.org e as publicações privadas usam o mesmo caminho, mudando apenas o domínio. O único sufixo a registrar é `geul`.
- A lista de Issuers é `issuers/`. Codecs, documentos comuns e hashes ficam sob a pasta do Issuer, em `codecs/<Codec ID>/`, `docs/<ID do documento>/` e `hashes/`. A lista de Issuers também começa na versão 1 e tem `versions.geul` ([documentos de lista](#목록-문서)).
- `latest.geul` é uma palavra reservada e um alias. Não é armazenado. Procura-se a versão mais recente no `versions.geul` do mesmo lugar e entregam-se, como estão, os bytes dessa versão. Não há redirecionamento. É igual para todo `latest.geul` da lista de Issuers, de Codecs e de documentos.
- O endereço canônico de uma versão é `/<Issuer>/docs/<ID do documento>/<ID da versão>.geul`. Para Codecs, é `/<Issuer>/codecs/<Codec ID>/<ID da versão>.geul`. Outros endereços que entregam o mesmo conteúdo apontam o endereço canônico por `Link: rel=canonical`.
- O endereço com versão indicada e o endereço por hash de conteúdo são imutáveis. Endereços imutáveis podem ficar em cache permanente e em CDN. Quem recebe verifica pelo hash de conteúdo da lista de versões (ou do registro de bloqueio).
- Para procurar por hash de conteúdo, é preciso conhecer o Issuer. Não há consulta global apenas pelo hash.
- Documentos de Codec não têm ID de documento. Apontam a si mesmos e à versão por [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID da versão).
- O ID sempre começa com `0x`. Assim, os nomes reservados (`issuers`, `codecs`, `docs`, `hashes`, `latest.geul`, `versions.geul`) ou nomes dados por pessoas não colidem com IDs, mesmo que sejam palavras só de hexadecimal como `add` e `cafe`.
- A localização (de qual servidor se recebe) não entra no conteúdo do documento. Se entrasse, o hash de conteúdo mudaria quando o endereço mudasse. A localização é determinada pela configuração de quem recebe o documento.

### Forma de publicação e consulta {#공표-형태와-조회}

- O endereço é um endereço lógico. O publicador pode entregar arquivos individuais ou pack; no caso de pack, não se pode receber diretamente pela URL do endereço, e lê-se com um resolvedor GEUL.
- Quer esteja armazenado em arquivos individuais, em pack ou em pack zstd, encontra-se pelo mesmo endereço. Endereços fora dos 10 formatos acima e endereços inexistentes dão 404 (não encontrado).

Ferramenta de linha de comando `geul` ([gogeul](https://github.com/geul-org/gogeul)):

```
geul get <endereço>     emite o binário do documento GEUL puro na saída padrão
geul show <endereço>    mostra o documento em texto
```

- `geul get` aceita endereços `file://` e `https://`. Endereços fora dos 10 formatos e endereços inexistentes terminam em 404 (não encontrado).

O `pkg/resolve` da biblioteca Go gogeul tem uma função de consulta para cada endereço. Todas devolvem o binário GEUL puro (`[]byte`). Como o ID da versão começa em 1, `Latest` (0) é a mais recente. Um endereço inexistente é o erro de inexistência (`ErrNotFound`).

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // formatos fora dos 10: 404 (não encontrado)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → saída padrão
```

### Especificação de formato {#형식-지정}

- O endereço de publicação termina em `.geul` e é binário (`application/vnd.geul`).
- A forma canônica do documento é o binário. O hash de conteúdo e a assinatura são calculados apenas sobre o binário.

### Documentos de lista {#목록-문서}

O documento de lista é um só: a lista de Issuers `issuers/`. Liga Issuers a domínios ([lista de Issuers](#issuer-목록)). Começa na versão 1 e tem `versions.geul`. O ID de documento da lista é o ID de documento reservado `0xFFFFFFFFFFFFFFFF` (Issuer geul.org `0x00000000`). Todo Issuer reserva os IDs de documento `0x0000000000000000` e `0xFFFFFFFFFFFFFFFF` ([Issuer e publicação](issuer.md#용어-정의-문서)).

- `latest.geul` é um alias não armazenado. Procura-se a versão mais recente em `versions.geul` e entregam-se os seus bytes.
- PUBLICATION, DEPRECATION e TOMBSTONE em `issuers/versions.geul` apontam a versão da lista por DOC-POINTER (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, ID da versão). Assim, mesmo recebendo por `hashes/`, sabe-se de que é a lista ([PUBLICATION](edge/0x0B8L-publication.md#목록-문서의-버전-목록)).
- O ID de documento `0xFFFFFFFFFFFFFFFF` não é obtido em nenhum Issuer pelo endereço `<Issuer>/docs/<ID do documento>/` (404). O outro ID de documento reservado, `0x0000000000000000`, é o documento de índice de definição de termos daquele Issuer e fica sob `docs/` ([Issuer e publicação](issuer.md#용어-정의-문서)).
- Os documentos de lista não têm `DOC-ID`. De que é a lista, diz o DOC-POINTER dos registros ([DOC-ID](meta/0x1C7L-doc-id.md)).
- Documentos e Codecs são encontrados diretamente pelo ID calculado a partir do registro, sem lista ([nome de documento](#문서-이름)).

### Nome de domínio {#도메인-이름}

O nome de domínio não é um endereço URL de publicação. Um endereço que use um domínio na posição de `<Issuer>` ou um nome na posição de ID está fora dos 10 formatos acima e dá 404 (não encontrado). Também não há redirecionamento do nome para o endereço por ID.

- O nome de domínio é entrada do resolvedor e da CLI. O resolvedor converte o domínio em Issuer ID pelo BIND da lista de Issuers `issuers/`. O ID convertido é registrado no registro de bloqueio. Não há endereço por nome de documento ([nome de documento](#문서-이름)).
- O endereço canônico, a chave de cache e o objeto da assinatura são o endereço por ID.
- O domínio é escrito em minúsculas, e os domínios internacionalizados em forma IDNA (punycode). Não se acrescenta o `.` final.
- Issuers de 16 WORD, que não têm registro, e ambientes isolados (air-gapped) sem acesso a geul.org não podem usar nomes de domínio. Usam o ID.

### Lista de Issuers {#issuer-목록}

A lista de Issuers é um documento sob `/.well-known/geul/issuers/` (a mais recente é `issuers/latest.geul`). Liga Issuers a seus nomes (domínios).

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   nome = "geul.org"
  …
```

- O Subject é [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) (o próprio Issuer), e o nome é ligado por [BIND](edge/0x0A3L-bind.md).
- O nome é um domínio que passou pela prova de propriedade. É escrito em minúsculas, e domínios internacionalizados em IDNA (punycode). Um nome liga-se a um único Issuer.
- O nome de exibição do Issuer legível por pessoas (por idioma) é anexado ao mesmo Subject como [LABEL](edge/0x0A4L-label.md) de enunciado.
- É assinada por geul.org (Issuer GEUL), e, quando muda, acrescenta-se e não se corrige (a mesma regra de cadeia da lista de versões).

### Nome de documento {#문서-이름}

**Não há endereço por nome de documento.** Documentos e Codecs são encontrados por ID.

- Não há índice que converta nomes de documentos ou de Codecs em ID. Também não se coloca na lista de versões o [BIND](edge/0x0A3L-bind.md) do nome de documento ([PUBLICATION](edge/0x0B8L-publication.md#버전-목록-문서)).
- O índice para navegação por pessoas é feito pela ferramenta (visualizador) a partir do inventário de pack.
- O endereço canônico, a chave de cache e o objeto da assinatura são o endereço por ID. IMPORT e as citações dentro de documentos usam apenas ID.
- O título legível por pessoas (por idioma) é anexado como [LABEL](edge/0x0A4L-label.md) de enunciado.

### Documentos excluídos {#삭제된-문서}

- O endereço de uma versão revogada por exclusão legal ou de ofício (TOMBSTONE) também dá 404 (não encontrado), como qualquer endereço inexistente.
- Uma versão com recomendação de descontinuação (DEPRECATION) não dá 404. Continua sendo entregue por esse endereço de versão.
- A exclusão fica na lista de versões como um registro [TOMBSTONE](edge/0x0BAL-tombstone.md) (DOC-POINTER dessa versão, categoria do motivo).

## Camadas {#층}

O GEUL expressa até a procedência, os metadados e as listas como documentos GEUL. O mínimo necessário para lê-los é embutido no decodificador, para romper a circularidade. Cada camada depende apenas das camadas inferiores.

| Camada | Conteúdo | Depende de |
|---|---|---|
| Camada 0 | Regras embutidas no decodificador: enquadramento, hash de conteúdo, verificação de assinatura, Codecs de registros da lista de versões (`PUBLICATION`, `DEPRECATION`, `TOMBSTONE`), vocabulário de especificação de Codec (`DECLARE`, `FIELD`, `ENUM`, `CODEC`), [marcadores de posição](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`), chaves de confiança recebidas de fora do documento | Nada. Não consulta |
| Camada 1 | Documentos da lista de versões | Camada 0 |
| Camada 2 | Documentos comuns, codebooks, documentos de especificação de Codec, documentos de chave de verificação de Issuer | Encontrados pela camada 1 e verificados pela camada 0 |

- Nenhuma camada depende de si mesma nem de camadas superiores.
- Distingue-se o que se expressa em GEUL do que só se lê interpretando em GEUL. A camada 0 pode ser expressa em GEUL, mas sua interpretação não exige consulta.
- O núcleo fixo que não pode ser convertido em documento TOULMIN, como o significado do julgamento, também fica aqui ([TOULMIN](toulmin/_index.md#메타-인지와-자기-개정)).

## Lista de versões {#버전-목록}

O publicador mantém, para cada documento, um documento de lista de versões, em que escreve em sequência (`/<Issuer>/docs/<ID do documento>/versions.geul`; para Codecs, `/<Issuer>/codecs/<Codec ID>/versions.geul`; para a lista de Issuers, `issuers/versions.geul`). O formato dos registros e a estrutura do documento são definidos em [PUBLICATION](edge/0x0B8L-publication.md).

```
DOC-*
  SPEC-VERSION
  PARENT          hash de conteúdo da lista de versões anterior
  RECORDED-AT     instante em que esta lista foi emitida
  NEXT-LOCAL-ID   próximo LOCAL ID a atribuir
  SIGNATURE       assinatura do publicador
BODY
  PUBLICATION     #1  documento@1  hash de conteúdo
  PUBLICATION     #2  documento@2  hash de conteúdo
  DEPRECATION     #3  documento@1
  …
END
```

| Edge | Significado |
|---|---|
| PUBLICATION | Publica uma versão do documento e seu hash de conteúdo |
| DEPRECATION | Marca uma versão publicada com recomendação de descontinuação. Continua sendo interpretada |
| TOMBSTONE | Exclui uma versão publicada (exclusão legal ou de ofício). Registra a categoria do motivo |

- Os registros só são acrescentados. Não se corrige, apaga ou reordena. Deprecar e excluir também acrescentam registros. A nova lista mantém na frente, como estava, o BODY da lista anterior e acrescenta registros, e as listas se ligam por uma cadeia de hashes de `PARENT`.
- Significa que o registro de publicação não é corrigido, e é diferente da revisão do conteúdo do documento ([documento](document.md#개정)). O estado atual de uma versão é calculado aplicando os registros em ordem.
- O ID da versão é ascendente a partir de 1, sem lacunas. O mesmo conteúdo não é publicado de novo.
- A versão mais recente é a mais alta que não é nem desaconselhada nem excluída.
- Os registros não levam instante. O `RECORDED-AT` da primeira lista em que o registro apareceu é o instante de publicação.
- A lista de versões não tem `DOC-ID`. O DOC-POINTER dos registros (ID do documento; para a lista de Issuers, o ID de documento reservado) diz de que é a lista.
- A lista de versões não tem IMPORT e usa apenas Codecs da camada 0. O BODY contém apenas PUBLICATION, DEPRECATION e TOMBSTONE.
- As listas de versões anteriores são apontadas apenas pelo hash de conteúdo (`<Issuer>/hashes/<hash de conteúdo>.geul`), e o histórico se liga pela cadeia de `PARENT`.
- Os endereços mutáveis são `latest.geul` e `versions.geul`. Como ponteiros mutáveis não podem ser feitos como documento, verificam-se pela assinatura, pelo `RECORDED-AT` e pelo `PARENT` da lista recebida.

### Signatário {#서명-주체}

| Assinatura | Signatário | Objeto |
|---|---|---|
| Assinatura do documento | O Issuer do documento | Hash de conteúdo do documento ([Issuer e publicação](issuer.md#서명)) |
| Assinatura da lista | O publicador que atribuiu os IDs de versão | Hash de conteúdo da lista de versões |

- Na publicação em geul.org, geul.org (Issuer GEUL) atribui os IDs de versão e assina a lista; na publicação privada, é o próprio Issuer.
- O autor responde pelo conteúdo e o publicador pelos números e pela ordem.

### Verificação {#검증}

- A assinatura é excluída do hash de conteúdo, de modo que o hash permanece o mesmo se for removida. Por isso, verifica-se não com «se há assinatura, confira», mas com «deve haver a assinatura da chave determinada». As chaves exigidas são determinadas pela configuração de confiança do resolvedor e pelo registro de bloqueio.
- O resolvedor registra no registro de bloqueio o hash de conteúdo da última lista vista. Se esse hash não está na cadeia de `PARENT` de uma lista recém-recebida, ela é rejeitada (impede retrocesso e bifurcação).
- Espelhos e ambientes isolados copiam também a cadeia de listas de versões. Com a chave pública, a verificação é feita offline.
- Um documento recebido, venha de qualquer origem, é verificado pelo hash de conteúdo. Não é preciso confiar na origem.

## Resolução de dependências {#의존성-해석}

- O documento registra os documentos de que depende com [IMPORT-DOC](meta/0x1E4L-import-doc.md) no HEAD.
- Uma nova versão não promete compatibilidade com a anterior. Por isso, não se unifica em uma só a versão de um documento em todo o grafo (não se usa a seleção de versão mínima).
- Cada `IMPORT-DOC` fica vinculado à edição que fixou. Várias edições do mesmo documento podem coexistir em um grafo (uma sentença que cita a lei antiga e outra que cita a lei vigente). As referências são resolvidas por (documento, versão, LOCAL ID).
- Uma importação da mais recente (versão `0`) vincula-se à edição mais recente no momento da interpretação. Se a interpretação é feita num instante determinado, vincula-se à edição em vigor naquele instante ([documento](document.md#개정)).
- Uma importação fixada por ID de versão é reproduzida (o conteúdo de um ID de versão é imutável e verificado pelo registro de bloqueio).

## Tipo de mídia {#미디어-타입}

- O tipo de mídia dos documentos GEUL é `application/vnd.geul`. A extensão é `.geul`.
- Mesmo que se mude para a árvore padrão `application/geul`, continua-se aceitando `application/vnd.geul`.

## Problemas em aberto {#열린-문제}

- O tratamento de quando os IDs de versão divergem (mesmo ID de versão, conteúdo diferente) em publicações privadas, Issuers de 16 WORD e ambientes isolados.
- A composição do HEAD da lista de Issuers `issuers/` e o formato de assinatura e cadeia. Regras de nome para Issuers sem domínio (4 WORD), tratamento de disputas de nome e limite de comprimento.
- Quando e em que formato migrar, à medida que a lista cresce, da cadeia completa para um log Merkle (provas de inclusão e consistência).
- O Meta que registra no HEAD o Issuer que fornece a localização.
