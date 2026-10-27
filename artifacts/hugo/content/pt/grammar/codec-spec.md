---
title: "Documento de especificação de Codec"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "O codebook também é um documento GEUL. Quatro Edges — DECLARE, FIELD, ENUM e CODEC — declaram a composição do Payload de um Codec, e esse único documento serve para validar, decompor e exibir."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Como um Codec compõe o Payload é definido pelo codebook. O codebook do GEUL não é um formato à parte: é um **documento GEUL**. Um documento de especificação por Codec.

## Localização do documento de especificação

O documento de especificação de um código direto é publicado pelo Issuer GEUL (`0x0000`). O ID do documento é a TAG WORD desse Codec (apenas as posições de Kind e Codec, com Length 0) estendida para 4 WORDs.

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | Documento de especificação |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

O decodificador monta o endereço do documento de especificação só a partir da TAG WORD. Ao encontrar um Codec desconhecido, basta obter e ler esse documento.

- `<TAG>` são 4 dígitos hex da TAG WORD alvo. A posição de Length é `0000`, e em Reference os bits de Quantifier ficam em `000` (LOCAL é `0008`).
- O Codec Reference `0000` é reservado, então não existe documento de especificação cuja TAG WORD alvo seja `0x0000`. Assim, os documentos de especificação não colidem com o documento de índice de definição de termos do Issuer GEUL (ID de documento `0`, [Issuer e publicação](/pt/grammar/issuer/#documento-de-definição-de-termos)). O [marcador de posição](/pt/grammar/reference/slot-marker/) do Codec `0000` (`0x0000`~`0x0002`) também não tem documento de especificação. É embutido no decodificador ([camada 0](/pt/grammar/publishing/#camadas)).
- O documento de especificação define, em `DOC-ID`, o DOC-POINTER (`0x0000`, `0x000000000000<TAG>`, `0`). O registro da lista de versões também usa esse DOC-POINTER.
- Como os outros documentos, o documento de especificação associa um nome em slug minúsculo ao índice de nomes `0x0000/documents.geul` do Issuer GEUL. Exemplo: `publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/` ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#nome-do-documento)).
- As regras de versão, endereço canônico e assinatura são as mesmas dos documentos publicados comuns.

### ID de documento do Issuer GEUL

| ID do documento | Uso |
|---|---|
| `0x0000000000000000` | documento de índice de definição de termos |
| `0x00000000 0000xxxx` | documento de especificação de Codec. `xxxx` é a TAG WORD alvo |
| `0x0001xxxx xxxxxxxx` | documento de definição de termos do geul.org. Um documento por termo ([Issuer e publicação](/pt/grammar/issuer/#documento-de-definição-de-termos)) |

- `0x00000000 0000xxxx` é reservado para documentos de especificação de Codec. Os demais documentos do Issuer GEUL (como documentos do formato ISSUER próprio do GEUL, usado quando faltam códigos diretos) não usam esta faixa.

### Codebook e versão da especificação

- Documentos de codebook não são importados com `IMPORT-DOC`. O [SPEC-VERSION](/pt/grammar/meta/declaration/spec-version/) no HEAD do documento define qual codebook se segue.
- Todo decodificador embute o codebook central ou o obtém deste endereço.
- Quando uma proposta (Prefix `000`) é adotada como padrão, o layout permanece e apenas o Prefix passa para `001` ([Visão geral](/pt/grammar/overview/#estrutura-de-regiões)). Como a TAG WORD alvo muda, a versão adotada passa a ser um novo documento de especificação com outro ID de documento, e o documento da proposta permanece imutável.

## Quatro vocabulários

| Edge | Codec | Função |
|---|---|---|
| DECLARE | `0x1B` | Declara a composição do Payload de um Codec. TAG WORD alvo, 1 WORD |
| FIELD | `0x1C` | Um campo do Payload. O DECLARE a que pertence e a largura |
| ENUM | `0x1D` | Dá significado a um valor de código de um campo de valor bruto |
| CODEC | `0x1E` | Especifica um Kind·Codec que o campo aceita |

- O layout dos quatro Edges é embutido no decodificador ([camada 0](/pt/grammar/publishing/#camadas)), porque o documento de especificação precisa ser lido sem codebook. Ler um documento de especificação não exige outro documento de especificação.
- Os nomes (nome do Codec, nome do campo, nome do valor de código) são todos ligados com BIND.

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (o DECLARE a que este campo pertence)
Largura           1 WORD: 0 = registro, n = valor bruto de n WORDs, 0xFFFF = valor bruto restante
```

- A **ordem dentro do documento** dos FIELDs que apontam para o mesmo DECLARE é a ordem dos campos do Payload.
- Um campo de registro começa com uma TAG WORD e é lido pelo seu Length.
- Um campo de valor bruto é um inteiro sem sinal lido no número de WORDs definido. Valores que exigem interpretação, como sinal, fração ou data, não são valores brutos: ficam em registros Value.
- Só pode haver um valor bruto restante (`0xFFFF`), e depois dele só vêm valores brutos de largura fixa.
- O Edge Id do Edge não se declara como FIELD. É implícito, por ser o primeiro elemento de todo Edge.
- A posição após ler os campos em sequência deve coincidir exatamente com o fim do registro.

### CODEC

Especifica o formato que o campo aceita. A WORD alvo usa as posições de Kind e Codec da TAG WORD como são.

| Posição de Length | Significado | Exemplo |
|---|---|---|
| `0000` | Codec exato | `0810` SIGNED-DECIMAL, `0008` LOCAL |
| `1111` | curinga: bits de Codec com 0 aceitam qualquer valor | `0780` qualquer Reference, `0F80` qualquer Value, `07A0` QID do Wikidata (independente de quantificação) |

- Se um campo de registro não tem CODEC, aceita qualquer registro (exceto marcadores de posição). Se tem um ou mais, deve ser um deles (lista fechada).
- Se um campo de valor bruto tem um CODEC, o valor bruto é interpretado como esse Value sem TAG.

### Campo opcional e marcador de posição

O [marcador de posição](/pt/grammar/reference/slot-marker/) é um conjunto de registros de 1 WORD do Codec Reference reservado `0000`. Só pode aparecer em um lugar se a lista de CODEC do campo contiver essa WORD como alvo exato.

| Alvo do CODEC | Marcador | Esse campo |
|---|---|---|
| `0000` | ABSENT, não informado | é um **campo opcional**. Pode ser omitido |
| `0001` | UNKNOWN-VALUE, desconhecido | aceita a asserção de que há um valor, mas não se sabe qual |
| `0002` | NO-VALUE, sem valor | aceita a asserção de que não há valor |

- **Regra de aceitação:** um marcador só é válido quando a lista de CODEC do campo tem a mesma WORD como alvo exato. Curingas (`0780`, `0781`, `0F80` …) e campos sem CODEC ("qualquer registro") não aceitam marcadores. Em lugar de registro HEAD/BODY ou de Edge Id, é inválido.
- Ao omitir um campo opcional, escreve-se naquele lugar uma única WORD `0x0000` (ABSENT). Um campo opcional também sempre ocupa o seu lugar. Assim a notação de um registro é única e a decomposição é determinada só pela posição.
- Como o marcador é um Codec Reference reservado, não colide com outros registros, e um decodificador que não conhece a especificação o pula como um registro de 1 WORD.
- Os três marcadores dizem coisas diferentes. ABSENT fala do documento (este lugar não foi preenchido), então não afirma nada sobre o mundo. UNKNOWN-VALUE é a asserção de que há um valor (`∃x`), e NO-VALUE é a asserção de que não há (`¬∃x`, dentro da condição restritiva). Omitir é "não informado", não "sem valor".
- O que o marcador significa é definido pela especificação do Codec que o aceita ([TRIPLE](/pt/grammar/edge/triple/), [QUALIFIER](/pt/grammar/edge/qualifier/)).

## Exemplo: documento de especificação de TRIPLE

É o BODY de `0x0000/0x000000000000100A`.

| Edge | Conteúdo | Nome (BIND) |
|---|---|---|
| #1 DECLARE | alvo `100A` | `TRIPLE` |
| #2 FIELD | campo de #1, registro | `predicate` |
| #3 FIELD | campo de #1, registro | `subject` |
| #4 FIELD | campo de #1, registro | `object` |
| #5 FIELD | campo de #1, valor bruto de 1 WORD | `rank` |
| #6~#8 ENUM | valores de código 0, 1, 2 de #5 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5 é interpretado como UNSIGNED-INTEGER (`0802`) | |
| #18, #19 CODEC | #4 é qualquer Reference (`0780`) ou qualquer Value (`0F80`) | |
| #20, #21 CODEC | #4 também aceita UNKNOWN-VALUE (`0001`) e NO-VALUE (`0002`) | |

Com este único documento, o decodificador divide um registro TRIPLE em campos, mostra-o com os nomes dos campos e verifica se os formatos estão corretos.

## Exemplo: documento de especificação de QUANTITY

Em Value QUANTITY (`0806`), os quatro campos são registros.

| Campo | CODEC |
|---|---|
| `amount` | `0801` SIGNED-INTEGER, `0802` UNSIGNED-INTEGER, `0803` BINARY-FLOAT (apenas valores finitos), `0807` FRACTION, `0810` SIGNED-DECIMAL, `0811` UNSIGNED-DECIMAL |
| `unit` | `0780` qualquer Reference, `0000` opcional |
| `lower` | `0801`·`0802`·`0803`·`0807`·`0810`·`0811` (igual a amount), `0000` opcional |
| `upper` | `0801`·`0802`·`0803`·`0807`·`0810`·`0811` (igual a amount), `0000` opcional |

## Regras

- Um documento de especificação tem um DECLARE. O alvo do DECLARE é igual à TAG WORD do ID do documento.
- Um mesmo alvo não é declarado duas vezes em um documento.
- Variantes com composições de campos diferentes não são escritas como ramificações. Cada Codec é declarado separadamente.
- Não se pode declarar um layout com dois ou mais valores brutos variáveis, ou cuja largura de um valor bruto dependa de outro valor. Essas partes são envolvidas em um registro.
- O documento de especificação é publicado em versões, como os outros documentos. No entanto, o layout binário de um Codec não é revisado. Para mudá-lo, atribui-se um novo Codec.

## Questões em aberto

- A correspondência entre o valor de `SPEC-VERSION` (v1 é `0x0001`) e a versão do documento de codebook. Meta de linhagem que liga a versão adotada e a proposta.
