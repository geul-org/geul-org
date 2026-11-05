---
title: "Documento de especificação de Codec"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "Como um Codec compõe o Payload é definido pelo codebook."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Como um Codec compõe o Payload é definido pelo codebook. O codebook do GEUL não é um formato à parte: é um **documento GEUL**. Um documento de especificação por Codec.

## Localização do documento de especificação {#규격-문서의-위치}

O documento de especificação de um código direto é publicado pelo Issuer GEUL (`0x00000000`). O documento de especificação é um documento de Codec e não tem ID de documento. O Codec ID é o TAG WORD do Codec (apenas a seção e o campo Codec de `C`, com Length igual a 0) escrito como valor de 32 bits.

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<ID da versão>.geul
```

| Codec | TAG | Documento de especificação |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

O decodificador monta o endereço do documento de especificação apenas a partir do TAG WORD. Ao encontrar um Codec desconhecido, basta baixar e ler esse documento.

- `<TAG>` são os 4 dígitos hexadecimais (maiúsculos) do TAG WORD de destino. O campo Length é `0000`. Há um documento de Codec por código. O sistema Reference 5Q também tem um documento por código de quantificação (LOCAL Identified `0050`, LOCAL Generic `0060`). Códigos diretos e Codecs de Issuer usam a mesma regra de endereço `<Issuer>/codecs/<Codec ID>/` ([endereço de publicação e lista de versões](publishing.md#공표-주소)).
- Os [marcadores de posição](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`) também têm documento de especificação. Como não têm Payload, contêm apenas DECLARE e nenhum FIELD. O significado e as regras de aceitação dos marcadores são embutidos no decodificador ([camada 0](publishing.md#층)). Um Codec cujo layout ainda não foi definido também começa como um documento de especificação com apenas DECLARE.
- O documento de especificação usa como `DOC-ID` um [CODEC-POINTER](reference/0x042L-codec-pointer.md) (`0x00000000`, `0x0000<TAG>`, `0`). O registro da lista de versões usa o mesmo CODEC-POINTER.
- As regras de versão, endereço canônico e assinatura são as mesmas dos documentos publicados em geral.

### Codebook e edição da especificação {#코덱북과-명세-판}

- Um documento de Codec também pode ser importado com [IMPORT-DOC](meta/0x1E4L-import-doc.md). Nesse caso, na posição do documento usa-se um [CODEC-POINTER](reference/0x042L-codec-pointer.md) em vez de DOC-POINTER. O [SPEC-VERSION](meta/0x1C5L-spec-version.md) do HEAD do documento determina qual codebook é seguido.
- Todo decodificador embute o codebook central ou o obtém neste endereço.
- Quando uma proposta (Prefix `000`) é adotada como padrão, o layout permanece e apenas o Prefix muda para `001` ([visão geral](_index.md#영역-구조)). Como o TAG WORD de destino muda, a versão adotada passa a ser um novo documento de especificação com outro Codec ID, e o documento da proposta permanece imutável.

## Quatro vocabulários {#네-어휘}

| Edge | Codec | Função |
|---|---|---|
| DECLARE | `0x0BBL` | Declara a composição do Payload de um Codec. TAG WORD de destino: 1 WORD |
| FIELD | `0x0BCL` | Um campo do Payload. O DECLARE a que pertence e a largura |
| ENUM | `0x0BDL` | Atribui um significado a um valor de código de um campo de valor bruto |
| CODEC | `0x0BEL` | Especifica um Kind ou Codec aceito por um campo |

- O layout dos quatro Edges é embutido no decodificador ([camada 0](publishing.md#층)), pois é preciso ler o documento de especificação sem um codebook. Ler um documento de especificação não exige outro documento de especificação.
- Todos os nomes (nome do Codec, nome do campo, nome do valor de código) são ligados por BIND.

### FIELD {#field}

```
Edge Id           LOCAL
DECLARE           LOCAL (o DECLARE a que este campo pertence)
largura           1 WORD: 0 = registro, n = valor bruto de n WORD, 0xFFFF = valor bruto restante
```

- A **ordem dentro do documento** dos FIELDs que apontam para o mesmo DECLARE é a ordem dos campos do Payload.
- Um campo de registro começa com um TAG WORD e lê tantos WORDs quanto seu Length.
- Um campo de valor bruto é um inteiro sem sinal lido com o número fixo de WORDs. Valores que exigem interpretação, como sinal, fração ou data, não são valores brutos: são colocados como registros Value.
- O valor bruto restante (`0xFFFF`) pode aparecer apenas uma vez, e depois dele só vêm valores brutos de largura fixa.
- O Edge Id de um Edge não é declarado como FIELD. É implícito, por ser o primeiro elemento de todo Edge. O EDGE-ISSUER é o primeiro elemento após o Issuer e o número do Codec ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)).
- A posição alcançada após ler os campos em sequência deve coincidir exatamente com o fim do registro.

### CODEC {#codec}

Especifica o formato aceito por um campo. O WORD de destino usa como está a posição do Codec do TAG WORD (seção `KKKK` e `C`).

| Campo Length | Significado | Exemplo |
|---|---|---|
| `0000` | Codec exato | `0680` SIGNED-DECIMAL, `0050` LOCAL |
| `1111` | Curinga: independentemente do valor de `C`, toda a seção `KKKK` (32 posições). Recomenda-se a primeira posição da seção (`C = 0`) | `000F` toda a seção 0, `060F` toda a seção 3 |

- Se o Kind abrange várias seções, listam-se CODECs por seção. Qualquer Reference é `000F`, `020F`, `040F`; qualquer Value é `060F`, `080F`.
- Para um grupo ou para quantificação indiferente, listam-se os Codecs exatos. O QID do Wikidata (quantificação indiferente) são cinco: `0140`, `0150`, `0160`, `0170`, `0180`.

- Se um campo de registro não tem CODEC, aceita qualquer registro (exceto marcadores de posição). Se tem um ou mais, deve ser um deles (lista fechada).
- Se um campo de valor bruto tem um CODEC, esse valor bruto é interpretado como esse Value sem TAG.

### Campos opcionais e marcadores de posição {#선택-필드와-자리-표지}

Os [marcadores de posição](slot-marker.md) são um grupo de registros de 1 WORD atribuídos às três primeiras posições `0x000L~0x002L` da seção 0 de Reference. Só podem aparecer em um campo cuja lista de CODEC tenha esse WORD como destino exato.

| Destino do CODEC | Marcador | O campo |
|---|---|---|
| `0000` | ABSENT, não escrito | é um **campo opcional**. Pode ser omitido |
| `0010` | UNKNOWN-VALUE, desconhecido | aceita a asserção de que há um valor, mas não se sabe qual |
| `0020` | NO-VALUE, inexistente | aceita a asserção de que não há valor |

- **Regra de aceitação:** um marcador só é válido se o mesmo WORD constar como destino exato na lista de CODEC do campo. Curingas (`000F`, `060F` …) e campos sem CODEC (qualquer registro) não aceitam marcadores. Nas posições de registro de HEAD e BODY e na posição do Edge Id, é inválido.
- Para omitir um campo opcional, escreve-se naquela posição um único WORD `0x0000` (ABSENT). Um campo opcional também ocupa sempre a sua posição. Assim, a notação de um registro é única e a decomposição é determinada apenas pela posição.
- O marcador tem seu próprio código Reference, não colide com outros registros, e um decodificador que não conhece a especificação o salta como um registro de 1 WORD.
- Os três marcadores significam coisas diferentes. ABSENT é uma afirmação sobre o documento (esta posição não foi preenchida) e portanto não assere nada sobre o mundo. UNKNOWN-VALUE assere que há um valor (`∃x`); NO-VALUE assere que não há valor (`¬∃x`, dentro de uma condição de qualificação). Omitir não é «sem valor», é «não escrito».
- O que um marcador significa é definido pela especificação do Codec que o aceita ([TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md)).

## Exemplo: documento de especificação do TRIPLE {#예-triple-규격-문서}

É o BODY de `0x00000000/codecs/0x00000AA0`.

| Edge | Conteúdo | Nome (BIND) |
|---|---|---|
| #1 DECLARE | destino `0AA0` | `TRIPLE` |
| #2 FIELD | campo de #1, registro | `predicate` |
| #3 FIELD | campo de #1, registro | `subject` |
| #4 FIELD | campo de #1, registro | `object` |
| #5 FIELD | campo de #1, valor bruto de 1 WORD | `rank` |
| #6~#8 ENUM | valores de código 0, 1, 2 de #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 é interpretado como UNSIGNED-INTEGER (`0620`) | |
| #18, #22, #23, #19, #24 CODEC | #4 é qualquer Reference (`000F`·`020F`·`040F`) ou qualquer Value (`060F`·`080F`) | |
| #20, #21 CODEC | #4 também aceita UNKNOWN-VALUE (`0010`) e NO-VALUE (`0020`) | |
| #25~#27 CODEC | #2 é qualquer Reference (`000F`·`020F`·`040F`) | |
| #28~#30 CODEC | #3 é qualquer Reference (`000F`·`020F`·`040F`) | |

Com este único documento, o decodificador divide um registro TRIPLE em campos, exibe-o com os nomes dos campos e verifica se o formato está correto.

## Exemplo: documento de especificação do QUANTITY {#예-quantity-규격-문서}

No Value QUANTITY (`0660`), os quatro campos são registros.

| Campo | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT (apenas valores finitos), `0670` FRACTION, `0680` SIGNED-DECIMAL, `0690` UNSIGNED-DECIMAL |
| `unit` | `000F`·`020F`·`040F` qualquer Reference, `0000` opcional |
| `lower` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (igual a amount), `0000` opcional |
| `upper` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690` (igual a amount), `0000` opcional |

## Regras {#규칙}

- Um documento de especificação tem um único DECLARE. O destino do DECLARE é igual ao TAG WORD do Codec ID.
- Um mesmo destino não é declarado duas vezes em um documento.
- Variantes com composição de campos diferente não são usadas como ramificação. Declara-se cada Codec separadamente.
- Não se pode declarar um layout com dois ou mais valores brutos de tamanho variável, ou em que a largura de um valor bruto dependa de outro valor. Essas partes são envolvidas em um registro.
- O documento de especificação é publicado por versão, como os demais documentos. Contudo, o layout binário de um Codec não é revisado. Para alterá-lo, atribui-se um novo Codec.

## Problemas em aberto {#열린-문제}

- A correspondência do valor de `SPEC-VERSION` (v1 é `0x0001`) para a versão do documento do codebook. Um Meta de linhagem que ligue a versão adotada à versão proposta.
