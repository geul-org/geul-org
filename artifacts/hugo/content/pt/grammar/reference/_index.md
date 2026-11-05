---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference é o registro que aponta um alvo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference é o registro que aponta um alvo. O alvo pode ser uma entidade, um conceito, um documento ou outro Edge. Aponta-se por ID, não por nome.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      seções 0~2 (0x000L~0x05FL)
[TAG estendida de Length]
[IMPORT ID]       no caso de EXTERNAL-POINTER (1/2/4 WORD)
[Issuer]          no caso de EXTERNAL-ISSUER (2/4/16 WORD)
[ID do documento] no caso de EXTERNAL-ISSUER (4 WORD)
ID do alvo        todo o restante
```

- `LLLL` é o número total de WORD, incluindo o TAG WORD, menos 1 ([registro e TAG WORD](../record.md)).
- Reference ocupa as 96 posições das seções 0~2 (`w < 0x0600`). Seção 0, entidades: `0x000L~0x01FL`; seção 1, EXTERNAL: `0x020L~0x03FL`; seção 2, diversas: `0x040L~0x05FL`.
- Os Codec são usados como uma tabela de códigos (tabela abaixo). No sistema 5Q, um único código reúne o sistema de identificação e a quantificação. A quantificação de REFERENCE-ISSUER é definida pelo documento do Issuer.
- O ID do alvo é um inteiro sem sinal big-endian e é escrito na **menor largura**. A largura é o que resta do Length depois de subtrair os campos anteriores.
- O ID de alvo `0` é escrito como `0x0000`, 1 WORD. Nos demais casos, não se antepõe WORD `0x0000`.
- Valor inteiro igual é o mesmo ID. A largura não faz parte do ID.
- Todos os Codec usam a menor largura. O Codec não fixa a largura do ID do alvo.
- [ISSUER-POINTER](0x040L-issuer-pointer.md), [DOC-POINTER](0x041L-doc-pointer.md) e [CODEC-POINTER](0x042L-codec-pointer.md) não seguem este layout. Não têm ID de alvo; têm apenas o Issuer (e o ID de documento, o Codec ID e o ID de versão).
- [REFERENCE-ISSUER](#reference-issuer) também não segue este layout. É TAG, Issuer, número de Codec de 2 WORD e Payload. O Payload é definido pelo documento de Codec publicado pelo Issuer.

## Codec {#codec}

| TAG ID | Nome | Classificação | Alvo |
|---|---|---|---|
| `0x000L~0x002L` | [marcador de posição](../slot-marker.md) | marcador de posição | Não aponta alvo. Usa-se apenas um marcador de 1 WORD: `0x0000` ABSENT (não preenchido), `0x0010` UNKNOWN-VALUE (desconhecido), `0x0020` NO-VALUE (inexistente) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | declaração | ID emitido por este documento |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | declaração | Entidade emitida por geul.org |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | declaração | Identificador semanticamente alinhado, com significado nos bits |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | declaração | Item do Wikidata. O inteiro após `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | declaração | Propriedade do Wikidata. O inteiro após `P` |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | indicação | LOCAL ID de um documento importado por IMPORT |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | indicação e declaração | LOCAL ID de um documento publicado por um Issuer |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | indicação e declaração | O próprio Issuer |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | indicação e declaração | Uma versão de um documento publicado por um Issuer |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | indicação e declaração | Uma versão de um codec publicado por um Issuer |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | formato de Issuer | Definido pelo Issuer. A classificação e a posição do ID do alvo são definidas pelo documento do Issuer |

- Reserved são `0x003L~0x004L`, `0x01EL~0x01FL` (seção 0), `0x03EL~0x03FL` (seção 1) e `0x043L~0x05CL` (seção 2, posições para novos sistemas de identificação).
- O número do sistema é lido pelo deslocamento `C` na seção. Na seção 0, se `5 <= C < 30`, o sistema é `C / 5` (1~5); na seção 1, se `C < 30`, o sistema é `6 + C / 5` (6~11).

| Sistema | Nome | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- A **declaração** identifica diretamente o alvo por um ID definido por quem o emite.
- A **indicação** aponta um LOCAL dentro de um documento importado por IMPORT ID. A largura do IMPORT ID é determinada pelo sistema: se sistema − 6 for 0, 1, 2, a largura é 1, 2, 4 WORD.
- A **indicação e declaração** aponta, num único registro e sem IMPORT, outro documento e o alvo dentro dele. A largura do Issuer de EXTERNAL-ISSUER é 2, 4, 16 WORD quando sistema − 9 é 0, 1, 2.
- `0x020L~0x03DL` (seção 1, sistemas 6~11) apontam o LOCAL de outro documento. Os demais sistemas de declaração identificam diretamente o alvo (LOCAL deste documento, IDs emitidos). Os ponteiros (seção 2, `0x040L~0x042L`) apontam o próprio Issuer, o documento e o codec. REFERENCE-ISSUER fica fora desta divisão.
- `0x000L~0x002L` são códigos atribuídos aos marcadores de posição e não se usam como Reference que aponta um alvo. Os WORD `0x0000`, `0x0010` e `0x0020` (L 0, 1 WORD) são [marcadores de posição](../slot-marker.md) (`0x0000` ABSENT, `0x0010` UNKNOWN-VALUE, `0x0020` NO-VALUE). Um marcador só é válido na posição de um campo de registro que tenha exatamente esse WORD como alvo CODEC. Curingas e campos sem CODEC não o aceitam, e nas posições de registro HEAD/BODY e de Edge Id é invalid. As formas de TAG com Payload em C 0~2 (L ≥ 1) são Reserved.
- Só os códigos diretos e as publicações fornecidos por geul.org são CC0. Sistemas de identificação que não são CC0 (WordNet etc.) não se colocam como código direto. A licença de um formato de Issuer é definida por esse Issuer.

### TAG de uso frequente {#자주-쓰는-tag}

| Registro | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5 (pessoa) | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (instance of) | `0191 001F` |
| marcador de posição ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL é um ID emitido por este documento.

- **É único.** Num documento, um LOCAL ID aponta apenas um alvo.
- **O 0 não é atribuído.** Os IDs de alvo são atribuídos a partir de 1.
- **Recomenda-se atribuir em ordem crescente** (auto increment). A magnitude do ID não tem significado.
- Aponta o mesmo alvo entre versões. Um ID excluído não é reutilizado (revisão de [documento](../document.md)).
- Para ser apontado de fora do documento, o documento precisa ter um `DOC-ID`.
- LOCAL ID diferentes não significam que sejam alvos diferentes na realidade. Se iguais, liga-se com o Edge `SAME-NODE`; se diferentes, com `DIFFERENT-NODE`.

### Edge Id {#edge-id}

Todo Edge coloca uma Reference LOCAL como primeiro elemento do Payload. Esse LOCAL ID é o **Edge Id**.

- O Edge Id pode ser lido sem conhecer o codebook.
- O LOCAL na posição de Edge Id é uma declaração, e o LOCAL nas outras posições do Edge é uma menção.
- Para declarar um Edge Id usa-se apenas LOCAL Identified (`0x005L`).
- Outros Edge são apontados pelo Edge Id. Os Edge deste documento são apontados por LOCAL e os Edge de outros documentos, por Reference de indicação.

## Apontar outro documento {#다른-문서-가리키기}

| O quê | Como |
|---|---|
| O próprio Issuer | `ISSUER-POINTER` (Issuer) |
| Uma versão de um documento | `DOC-POINTER` (Issuer, ID de documento de 4 WORD, ID de versão de 2 WORD). A versão `0` é a mais recente |
| Uma versão de um codec | `CODEC-POINTER` (Issuer, Codec ID de 2 WORD, ID de versão de 2 WORD). A versão `0` é a mais recente |
| Um alvo dentro de um documento publicado (mais recente) | `EXTERNAL-ISSUER-*` (Issuer, ID de documento, LOCAL ID) |
| Um alvo dentro de um documento importado (edição fixa) | Atribui-se um IMPORT ID com o Meta `IMPORT-DOC` e usa-se `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- O próprio documento, dentro ou fora dele, é apontado apenas por um DOC-POINTER. Ele mesmo é o DOC-POINTER do seu `DOC-ID`. O documento de codec é exceção e é apontado por CODEC-POINTER (o `DOC-ID` também é CODEC-POINTER).
- EXTERNAL-ISSUER segue a versão mais recente. Para fixar a edição, usa-se IMPORT.
- O Issuer é escrito na menor largura em que o valor cabe (2/4/16 WORD), e escolhe-se o Codec dessa largura. É igual em EXTERNAL-ISSUER e REFERENCE-ISSUER.
- O ID de documento `0` de cada Issuer é reservado ao documento de índice dos termos que esse Issuer definiu (ferramentas, papéis etc.). O documento de índice é recomendado a todo Issuer, não obrigatório ([Issuer e publicação](../issuer.md#용어-정의-문서)).

Exemplo: LOCAL 7 dentro do documento `0x0000000000000002` do Issuer `0x00000002`

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | Nome | Significado | Exemplo |
|---|---|---|---|
| `0` | Identified | Indivíduo identificado | Elon Musk, Coreia do Sul |
| `1` | Generic | Enunciado geral sobre toda uma espécie. Admite exceções | Soldados obedecem a ordens |
| `2` | Free-choice | Qualquer alvo que satisfaça a condição | Qualquer soldado |
| `3` | Universal | Todos os alvos dentro do escopo | Todos os soldados |
| `4` | Variable | Variável de discurso | essa pessoa, essa mulher (em coreano: 그 사람, 이 여자) |

- **A quantificação só se lê no sistema 5Q (sistemas 1~11).** Pelo deslocamento `C` na seção: na seção 0 com `5 <= C < 30`, na seção 1 com `C < 30`, a quantificação é `C % 5`. Como cada seção tem 32 posições, dividir por 5 a posição de Codec de 9 bits (`w >> 4`) desalinharia a seção 1. Os marcadores (seção 0, `C < 3`) e a seção 2 (ponteiros, REFERENCE-ISSUER) não têm quantificação. O marcador `0x0010` UNKNOWN-VALUE não é Generic. A quantificação de REFERENCE-ISSUER é definida pelo documento de Codec publicado pelo Issuer.
- Generic, ao contrário de Universal, não significa que se aplica sem exceção a todos os alvos individuais. Expressões definitórias como `병사란 무엇인가` (o que é um soldado) podem ser escritas como Generic. Se for necessária uma definição rigorosa de conceito ou classificação, concretiza-se com uma relação separada.
- O escopo de aplicação e a negação da quantificação são definidos não pela Reference, mas pelo Edge que a usa.
- **Variable** é um alvo do discurso cuja espécie se conhece mas que ainda não foi identificado.
  - Uma variável nomeada acrescenta Variable a um LOCAL. LOCAL ID igual é a mesma variável. A espécie liga-se por Edge.
  - Uma variável anônima acrescenta Variable a um Codec de declaração que aponta uma espécie (GEUL, WIKIDATA-*) (por exemplo, "presidente" do Wikidata + Variable). Não rastreia correferência e não pode ser apontada de novo. Variáveis anônimas não são tratadas como a mesma variável.
  - Quando o alvo for confirmado depois, liga-se a variável a esse alvo com `SAME-NODE`. Todas as expressões que apontam a mesma variável passam a ser interpretadas como esse alvo.
  - Mesmo variáveis diferentes não significam que os alvos reais sejam diferentes. Se iguais, liga-se com `SAME-NODE`; se diferentes, com `DIFFERENT-NODE`.
  - A Variable de um Codec de indicação externa (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) é uma variável LOCAL do documento apontado.
  - Exemplo: se em `대통령이 연설했다` (o presidente discursou) a pessoa não está determinada, usa-se Variable de "presidente". Para mencioná-lo de novo, cria-se um LOCAL Variable e liga-se por Edge a espécie "presidente". Quando mais tarde se confirmar que é Obama, liga-se essa variável ao Identified Obama com `SAME-NODE`. Todas as expressões que apontam a mesma variável passam a ser interpretadas como Obama.
- Exemplo: usar Q5 (pessoa) do Wikidata como Generic dá `0151 0005` ("o ser humano é …").

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER é um formato de Reference definido por um Issuer. São as três últimas posições da região Reference. Tem o mesmo layout que o ISSUER de Value e Edge ([registro e TAG WORD](../record.md#issuer-형식-레코드)).

### Layout {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = largura do Issuer: 01 2, 10 4, 11 16 WORD)
[TAG estendida de Length]
Issuer            2/4/16 WORD (a largura é definida pelo Codec)
número de Codec   2 WORD. Definido pelo Issuer
Payload           Definido pelo documento de Codec publicado pelo Issuer
```

| Codec | Nome | Largura do Issuer |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- Cada código tem a sua página: [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md).
- O documento de codec do Issuer GEUL é um por código e contém três FIELD: Issuer (2·4·16 WORD), número de Codec (2 WORD) e Payload (definido pelo codec do Issuer).

### Interpretação e validade {#해석과-유효성}

- Por meio do Length, GEUL conhece apenas o limite do Payload. O Payload não é interpretado sem o codebook.
- O significado do número de Codec e a quantificação são definidos pelo Issuer. O que ele aponta também é definido pelo documento de Codec publicado pelo Issuer.
- As regras comuns de Reference não se aplicam: menor largura do ID do alvo, notação de 1 WORD para o ID de alvo `0`, Quantifier, leitura de quantificação e sistema pelo deslocamento na seção, classificação em declaração/indicação, e o que se aponta.
- O número de Codec de 2 WORD é igual ao do ISSUER de Value e Edge. Se os números acabarem, obtém-se mais um Issuer.
- Um decodificador que não conhece o formato conhece até Kind, Length, Issuer e número de Codec, e salta o restante pelo Length.
- A licença de um formato de Issuer é definida por esse Issuer ([Issuer e publicação](../issuer.md#라이선스)).

### Páginas relacionadas {#관련-페이지}

- [registro e TAG WORD](../record.md), [Issuer e publicação](../issuer.md)
