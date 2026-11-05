---
title: "Índice de códigos"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "Esta página é o índice de todos os Codecs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Esta página é o índice de todos os Codecs. Ao clicar no nome, vai-se ao documento detalhado daquele Codec. Os códigos diretos que não constam das tabelas são Reserved.

## Kind {#kind}

O TAG WORD é `000K KKKC CCCC LLLL`. Os 4 bits superiores `KKKK` são a seção, `C` é o deslocamento de 5 bits dentro da seção e `LLLL` é o Length. Os 9 bits formados por seção e `C` são a posição do Codec. O TAG ID é escrito como `0x000L`. Os três primeiros dígitos são esses 9 bits (`w >> 4`) e `L` é a posição do Length ([Registro e TAG WORD](record.md)).

| Seção | TAG ID | Classificação | Descrição |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | registros que apontam para um alvo |
| 3·4 | `0x060L~0x09FL` | [Value](value/_index.md) | registros de valor |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | registros de composição |
| 14·15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | registros sobre o documento e sobre registros |

- A seção é `S = w >> 9` (4 bits) e uma seção tem 32 casas.
- O Kind é determinado por uma única faixa de seções: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, o restante Meta. Não há exceções.
- As três últimas casas das zonas Reference, Value e Edge são ISSUER (`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). Meta não tem ISSUER.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | Nome | Classificação | ID do alvo |
|---|---|---|---|
| `0x000L~0x002L` | [Marcador de posição](slot-marker.md) | marcador de posição | grupo de marcadores de 1 WORD que não apontam para alvo (tabela abaixo) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | declaração | ID emitido por este documento |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | declaração | entidade que geul.org emite sob CC0. Números pequenos são atribuídos a entidades de alta frequência |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | declaração | GEUL SIDX (Semantic-aligned Index). Identificador que traz significado nos bits |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | declaração | item do Wikidata. O inteiro depois de `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | declaração | propriedade do Wikidata. O inteiro depois de `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | apontamento | ID LOCAL de um documento trazido por `IMPORT-DOC`. ID de IMPORT de 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | apontamento | igual ao acima. ID de IMPORT de 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | apontamento | igual ao acima. ID de IMPORT de 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | apontamento e declaração | ID LOCAL de um documento de Issuer de 2 WORD |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | apontamento e declaração | ID LOCAL de um documento de Issuer de 4 WORD |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | apontamento e declaração | ID LOCAL de um documento de Issuer de 16 WORD |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | apontamento e declaração | o próprio Issuer. O Payload é apenas o Issuer (2/4/16 WORD) e não há ID do alvo |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | apontamento e declaração | uma versão de um documento do Issuer. Issuer + ID do documento de 4 WORD + ID da versão de 2 WORD, sem ID do alvo |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | apontamento e declaração | uma versão de um Codec do Issuer. Issuer + ID do Codec de 2 WORD + ID da versão de 2 WORD, sem ID do alvo |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | formato Issuer | Issuer de 2 WORD e número do Codec de 2 WORD. A classificação e o alvo são definidos pelo documento do Issuer |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | formato Issuer | Issuer de 4 WORD e número do Codec de 2 WORD. Igual ao acima |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | formato Issuer | Issuer de 16 WORD e número do Codec de 2 WORD. Igual ao acima |

- Reference tem três seções. Seção 0, entidades `0x000L~0x01FL` (marcador de posição, sistema 5Q); seção 1, EXTERNAL `0x020L~0x03FL`; seção 2, outros `0x040L~0x05FL` (ponteiros, REFERENCE-ISSUER). Os Reserved são `0x003L~0x004L`, `0x01EL~0x01FL`, `0x03EL~0x03FL` e `0x043L~0x05CL`.
- Cada grupo de 5 casas (de LOCAL a EXTERNAL-ISSUER-16WORD) segue a ordem de Quantifier abaixo, uma casa para cada. Exemplo: WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### Marcador de posição (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000`, `0x0010`, `0x0020` — [Marcador de posição](slot-marker.md). Só aparecem em uma posição quando a lista de CODECs do campo contém exatamente aquele WORD.

| WORD | Nome | Significado | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | não escrito. Um campo opcional foi omitido. Nada se afirma sobre o mundo | sem snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | desconhecido. Existe um valor, mas não se sabe qual | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | inexistente. Não há valor | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | Nome | Significado | Exemplo |
|---|---|---|---|
| `0` | Identified | entidade identificada | Elon Musk, Coreia do Sul |
| `1` | Generic | enunciado geral ou definidor sobre toda uma espécie. Admite exceções. | Soldados obedecem a ordens |
| `2` | Free-choice | qualquer alvo que satisfaça a condição | qualquer soldado |
| `3` | Universal | todos os alvos pertencentes ao âmbito dado | todos os soldados |
| `4` | Variable | variável de discurso | aquela pessoa, esta mulher |

- A quantificação é lida pelo deslocamento `C` dentro da seção. Na seção 0, se `5 <= C < 30`, a quantificação é `C % 5` e o sistema é `C / 5` (1~5). Na seção 1, se `C < 30`, a quantificação é `C % 5` e o sistema é `6 + C / 5` (6~11). Não se usa nos marcadores (seção 0, `C < 3`) nem na seção 2 (ponteiros, REFERENCE-ISSUER).

## Issuer {#issuer}

O Issuer é a entidade que define documentos e formatos — [Issuer e publicação](issuer.md)

| Posição | Significado |
|---|---|
| Códigos ISSUER de Reference, Value e Edge (as três últimas casas de cada zona) | formato definido por esse Issuer |
| Meta `DOC-ID` | o Issuer que emitiu este documento |
| Meta `IMPORT-DOC` | o Issuer que emitiu o documento importado |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER`, `CODEC-POINTER` | o Issuer que emitiu o documento ou Codec apontado (2/4/16 WORD) |
| Reference `ISSUER-POINTER` | o próprio Issuer apontado (2/4/16 WORD) |

| Largura do Issuer | Emissão |
|---|---|
| 2 WORD | registro em geul.org. Issuer que passou pela prova de propriedade de domínio (ex.: company.com). Os números que geul.org atribui a organismos de normalização e a grandes instituições também têm esta largura ([tabela de atribuição de 2 WORD](issuer.md#2-word-배정표)). |
| 4 WORD | registro em geul.org. Issuer registrado sem prova de propriedade |
| 16 WORD | autoemissão. Calculado a partir da chave pública, sem registro. Segue a regra de geração abaixo. |

### Algoritmo de assinatura do Issuer de 16 WORD {#16-word-issuer-서명-알고리즘}

| ID do algoritmo de assinatura | Algoritmo |
|---|---|
| `0x0001` | Ed25519 |
| demais | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

A família de um código direto é `(código − 0xA0) >> 5` (o código são os três primeiros dígitos do TAG ID). Cada família tem 32 casas e é igual à seção `w >> 9` menos 5. Os códigos diretos atribuídos pertencem às cinco famílias abaixo. `0x135L~0x1BCL` é Reserved (as seções 10~12 são Reserved por inteiro). O formato Issuer não tem regra de família.

| Seção | Família | Códigos diretos |
|---|---|---|
| 5 | enunciado | `0x0A0L~0x0BFL` |
| 6 | fundamento | `0x0C0L~0x0DFL` |
| 7 | execução | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | formato [TOULMIN](toulmin/_index.md) | `0x120L~0x134L` |

- `0x11CL~0x11FL` é Reserved.
- `0x1BDL~0x1BFL` (as três últimas casas da seção 13) é EDGE-ISSUER (veja Formato ISSUER de Edge abaixo).

### Enunciado (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | Nome | Subformato | Descrição |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | vínculo direcional em que o Subject, uma Reference, indica o Object |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | identidade: duas Reference indicam o mesmo alvo |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | não identidade: duas Reference indicam alvos diferentes |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | liga ao Subject um nome para máquina (`UTF8-TEXT-*`). Deve ser único no escopo e coincidir exatamente, e não tem idioma |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | liga o nome (label) do Subject em um idioma. O Object é UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | liga outro nome (alias) do Subject. O layout é igual ao de LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | liga a descrição (description) do Subject em um idioma. O layout é igual ao de LABEL |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | enunciado verbal abreviado |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | enunciado verbal |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | proposição na ordem Predicate, Subject, Object, mais rank. O Object é um valor ou um marcador UNKNOWN-VALUE·NO-VALUE. O significado é a soma de todos os QUALIFIERs que apontam para o Edge Id desse Edge |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | uma condição que qualifica a proposição de outro Edge. Property, Target (Edge Id), Value (valor ou marcador UNKNOWN-VALUE·NO-VALUE). Faz parte da proposição |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | Sim | estrutura para expressar visões de mundo |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | Sim | estrutura para expressar a ordem de mundos e eventos |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | Sim | estrutura de cena para enunciar características de um cenário |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | publicação do documento. DOC-POINTER, hash de conteúdo |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | deprecação de uma versão publicada. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | exclusão (lápide) de uma versão publicada. DOC-POINTER, categoria do motivo |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | declaração da composição do Payload de um Codec. Kind e Codec de destino |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | um campo do Payload. DECLARE a que pertence, largura: registro (Length do TAG) ou valor bruto de n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | um valor de código de um campo de valor bruto. Campo, valor de código |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | um Kind·Codec que o campo aceita. Campo, WORD de destino (`000K KKKC CCCC LLLL`, LLLL 0000 exato, 1111 curinga (todas as 32 casas daquela seção); os marcadores de posição só como destino exato `0000`, `0010`, `0020`). Um campo de registro admite vários (lista fechada) e um campo de valor bruto admite um (aquele Value sem TAG) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | Grupo |
|---|---|
| `0x0A0L~0x0A7L` | apontamento e nome |
| `0x0A8L~0x0AFL` | proposição |
| `0x0B0L~0x0B7L` | estrutura |
| `0x0B8L~0x0BFL` | outros |

### Fundamento (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | Nome | Subformato | Descrição |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | liga um registro, ou o documento inteiro, à sua origem. Target (Edge Id do BODY; no HEAD, `0` = documento inteiro), Origin (Reference, ABSENT ou UNKNOWN-VALUE). A natureza da origem é um TRIPLE que tem a origem como Subject; a natureza da citação (data de consulta, posição, hash do texto original) é um QUALIFIER ligado ao SOURCE. O SOURCE do documento inteiro e seu QUALIFIER ficam no HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- O trecho do original, o agente criador, a confiabilidade, o período de vigência por artigo e os registros antigos escrevem-se com QUALIFIER, e a versão em que algo entrou pela primeira vez é calculada a partir do histórico de versões ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### Execução (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | Nome | Descrição |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | declaração de função. Símbolo, lista de símbolos de parâmetros, tipo de retorno, corpo (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | declaração de tipo. Símbolo e composição (lista de símbolos de campos, valores de enumeração, alvo do alias) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | expressão constante. Um Value embutido |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | expressão unária. Operador de 1 WORD, operando |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | expressão binária. Operador de 1 WORD, esquerda, direita |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | chamada. Função de destino, número de argumentos, argumento × número de argumentos |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | acesso a membro. Alvo, símbolo do campo |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | acesso por índice. Alvo, índice |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | criação de valor composto (lista, registro). Tipo, número de elementos, elemento × número de elementos |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | expressão condicional. Condição, valor se verdadeira, valor se falsa |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | sequência ordenada de instruções. Número de instruções, instrução × número de instruções |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | atribuição. Alvo (símbolo, MEMBER, INDEX), valor |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | ramificação condicional. Condição, BLOCK verdadeiro, falso (BLOCK·IF, 0 se não houver) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | ramificação múltipla. Alvo, número de ramos, (valor, BLOCK) × número de ramos, BLOCK padrão (0 se não houver) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | repetição condicional. Condição, BLOCK do corpo |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | repetição por iteração. Símbolo do elemento, alvo, BLOCK do corpo |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | controle de repetição. Tipo de 1 WORD (break, continue), repetição de destino |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | retorno. Valor (0 se não houver) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | lançamento de erro. Valor do erro |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | tratamento de erro. BLOCK do corpo, símbolo do erro, BLOCK de tratamento, BLOCK de finalização (0 se não houver) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | Grupo |
|---|---|
| `0x0E0L~0x0E7L` | declaração |
| `0x0E8L~0x0EFL` | expressão |
| `0x0F0L~0x0F7L` | instrução |
| `0x0F8L~0x0FFL` | erro |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

Detalhes: [TOULMIN](toulmin/_index.md)

| Codec | Nome | Descrição |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | declaração de caso. Grafo de julgamento que contém nós e relações |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | declaração de predicado. Função ou expressão de julgamento, critério de julgamento (Spec), contrato de fatos (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | declaração de critério de julgamento. Constantes e listas (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | declaração de afirmação. Dentro de um caso, põe um predicado como regra geral (Warrant). Pode ser atacada. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | declaração de contestação. Ataca com conclusão própria. O Level padrão é Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | declaração de exceção. Ataca sem conclusão própria. O Level padrão é Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | relação de ataque. O julgamento do atacante reduz gradualmente o julgamento do alvo. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | relação de exclusão. Se o atacante está Active, retira o alvo da agregação de forma determinística. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | cadeia de prioridade `A > B > C`. Abreviação de SUPERSEDES par a par. Layout indefinido |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | composição de execução. Se o nó está Active, executa o caso subordinado (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | ação executada se o nó está Active |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | ação executada uma única vez mesmo com novas tentativas |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | ação compensatória de DO (saga). Se uma etapa posterior falha, executa-se em ordem inversa. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | ligação que apenas julga, sem efeitos colaterais |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | ponto de entrada externo. Executa ou julga um caso |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | ponto de entrada de evento ou periódico, sem chamada externa |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | resultado do julgamento de um nó ou registro. Resultado (Pass, Review, Fail), valor do julgamento, Activated, Excluded, Level. Layout indefinido. O julgamento do documento inteiro é o Meta [VERDICT](meta/0x1E9L-verdict.md) (`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | evidência do julgamento. Posição, valor esperado, valor real (Fact). Layout indefinido |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | Grupo |
|---|---|
| `0x100L~0x107L` | declaração |
| `0x108L~0x10FL` | relação |
| `0x110L~0x117L` | execução |
| `0x118L~0x11FL` | resultado (`0x11CL~0x11FL` é Reserved) |

### Formato TOULMIN (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

São o texto original, as divisões e os nós e relações auxiliares de um documento [TOULMIN](toulmin/_index.md).

| Codec | Nome | Descrição |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | texto original de autoria. Largura SPAN e Value UTF8 |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | nome ou cadeia de caracteres |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | início de seção. Código da seção |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | início do âmbito de um caso |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | fim do âmbito de um caso |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | parágrafo de prosa (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. referência de função |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. grupo de execução ordenado |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. caso → campo |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. item de definição → valor ou tipo |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. item de definição → campo |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. ponto de entrada → caso, execução |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. ponto de entrada → caso, julgamento |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. gatilho → caso |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. gatilho → caso (`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. nó → identificador global |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. alias → caminho (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. nó → TEXT, notação do nome |

- `0x135L~0x1BCL` é Reserved.

### Formato ISSUER de Edge {#edge-issuer-형식}

Depois de `0x1BDL`~`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), [-4WORD](edge/0x1BEL-edge-issuer-4word.md), [-16WORD](edge/0x1BFL-edge-issuer-16word.md)), a TAG estendida do Codec traz o Issuer e o número do Codec de 2 WORD. No momento, nenhum formato ISSUER de Edge está registrado.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

O número de Value não indica família. Os códigos diretos ficam em `0x060L~0x081L`, sem Reserved. `0x082L~0x09CL` é Reserved e `0x09DL~0x09FL` é VALUE-ISSUER. Os nomes de família (NUMERIC, DECIMAL, TIME, TEXT, BINARY) são agrupamentos por tema. Os pares par·ímpar começam em um código par.

| Família | Códigos diretos |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### Códigos diretos {#직접-코드}

| Codec | Nome | Família | Descrição |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | false ou true em 1 WORD fixo |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | inteiro com sinal em complemento de dois, com o mínimo de WORD |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | inteiro de magnitude sem sinal (unsigned) em big-endian, com o mínimo de WORD |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | escalar IEEE 754 binary16/32/64/128 com Payload de 1/2/4/8 WORD |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | latitude e longitude da Terra (WGS 84) em binary64, incerteza em binary32 e sua Reference de unidade (ABSENT = desconhecida) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Reference do corpo celeste, latitude e longitude em binary64, incerteza em binary32 e sua Reference de unidade |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | amount de Value numérico (inteiro, BINARY-FLOAT, decimal, fração), Reference de unidade, limite inferior e superior. Unidade e limites podem ser omitidos (ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | fração que preserva a notação original: numerador inteiro ou decimal, denominador inteiro sem sinal ou decimal. Não se simplifica |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | `C×10^E`, com expoente com sinal `E` e coeficiente `C` em complemento de dois com o mínimo de WORD |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | `C×10^E`, com expoente com sinal `E` e coeficiente `C` sem sinal com o mínimo de WORD |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | número de dias com sinal em relação a `1970-01-01` do calendário gregoriano proléptico |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | contagem de nanossegundos sem sinal após a meia-noite do dia civil |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | contagem de segundos com sinal desde a época Unix/POSIX |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | tempo decorrido em segundos SI com sinal, sem época |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | cadeia de data EDTF (ISO 8601-2). Número par·ímpar de bytes. Não se usa para datas que podem ser escritas como GREGORIAN-DATE |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | cadeia de valor de data do GEDCOM 7. Preserva a notação original de outros calendários (juliano etc.). Número par·ímpar de bytes |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | sequência de bytes UTF-8 válida, sem implicar normalização. Número par de bytes |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | igual ao acima. Número ímpar de bytes |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | sequência de bytes ASCII da production `URI` da RFC 3986. Número par de bytes |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | igual ao acima. Número ímpar de bytes |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | sequência de bytes ASCII de uma language tag BCP 47 completa em canonical casing. Número par de bytes |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | igual ao acima. Número ímpar de bytes |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | texto com idioma. Registro Value de idioma (LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE) e bytes UTF-8. Par·ímpar refere-se aos bytes do texto |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | tag BCP 47 escrita com o número do GEUL Language Registry (Payload de 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | UUID de 128 bits da RFC 9562, com Payload fixo de 8 WORD |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | resultado SHA-256, com Payload fixo de 16 WORD |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | resultado SHA-1, com Payload fixo de 10 WORD. Apenas para identificação, como o ID de objeto do git |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | sequência de bytes de significado e formato desconhecidos. Número par de bytes |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | igual ao acima. Número ímpar de bytes |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N bits armazenados MSB-first após o bit-count |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | tempo decorrido em nanossegundos com sinal, sem época |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | formato definido pelo Issuer. Veja Formato ISSUER de Value abaixo |

### Formato ISSUER de Value {#value-issuer-형식}

Depois de `0x09DL`~`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md)), a TAG estendida do Codec traz o Issuer e o número do Codec de 2 WORD. O documento do Codec fica em `codecs/` daquele Issuer, com o número do Codec do registro. Exemplo: o CRC32C do IETF está em `0x00000007/codecs/0x0000C000/` ([Endereço de publicação e lista de versões](publishing.md)).

| Issuer | Número do Codec | Nome | Descrição |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | interchange bits BF16 em Payload fixo de 1 WORD |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | vector contíguo de int16 big-endian |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | vector contíguo de uint16 big-endian |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | vector contíguo de int32 big-endian |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | vector contíguo de uint32 big-endian |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | vector contíguo de int64 big-endian |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | vector contíguo de uint64 big-endian |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | vector contíguo IEEE 754 binary16 |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | vector contíguo BF16 |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | vector contíguo IEEE 754 binary32 |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | vector contíguo IEEE 754 binary64 |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | vector bidimensional IEEE binary64 na ordem `(x,y)` |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | vector tridimensional IEEE binary64 na ordem `(x,y,z)` |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | vector IEEE binary64 na ordem `(minX,minY,maxX,maxY)` |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format, rank, shape e payload dense C-contiguous |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format, rank, shape e payload packed low-bit-first dentro do octeto |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | dois binary32 na ordem `(real, imag)` |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | dois binary64 na ordem `(real, imag)` |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | numerator int64 normalizado e denominator int64 positivo |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | intervalo fechado binary64 com `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | quatro binary32 na ordem `(x,y,z,w)` |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | resultado BLAKE3 padrão em Payload fixo de 16 WORD |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | sequência de bytes ASCII de relative-ref da RFC 3986. Número par de bytes |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | igual ao acima. Número ímpar de bytes |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | resultado Castagnoli CRC-32C em Payload fixo de 2 WORD |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | endereço IPv4 de 32 bits em Payload fixo de 2 WORD |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | endereço IPv6 de 128 bits em Payload fixo de 8 WORD |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | IEEE 754 decimal32 DPD em Payload fixo de 2 WORD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | IEEE 754 decimal64 DPD em Payload fixo de 4 WORD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | IEEE 754 decimal128 DPD em Payload fixo de 8 WORD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | IEEE 754 decimal32 BID em Payload fixo de 2 WORD |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | IEEE 754 decimal64 BID em Payload fixo de 4 WORD |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | IEEE 754 decimal128 BID em Payload fixo de 8 WORD |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | contagem de nanossegundos com sinal (signed) desde a época Unix/POSIX |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | endereço MAC IEEE 802 de 48 bits em Payload fixo de 3 WORD |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | vector packed fixo de 4×UNORM8 na ordem R, G, B, A |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | vector packed fixo de 4×UNORM8 na ordem B, G, R, A |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | scalar ONNX E4M3FN no octeto superior do Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | scalar ONNX E4M3FNUZ no octeto superior do Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | scalar ONNX E5M2 no octeto superior do Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | scalar ONNX E5M2FNUZ no octeto superior do Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | scalar E8M0FNU unsigned exponent-only no octeto superior do Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | scalar ONNX/DLPack E2M1FN no nibble superior do Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | contagem de segundos SI com sinal (signed) desde `1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | contagem de nanossegundos com sinal (signed) desde a mesma época TAI |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | resultado SHA-512 em Payload fixo de 32 WORD |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | resultado SHA3-256 em Payload fixo de 16 WORD |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | contagem de segundos com sinal (signed) desde a época GPS |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | contagem de nanossegundos com sinal (signed) desde a época GPS |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

O número de Meta não indica a classe por bits. A classe se conhece pela tabela de faixas abaixo. A classe de verificação são os registros com `C >= 5` na seção 15, isto é, `w >= 0x1E50`, e se conhece sem livro de códigos. Meta não tem código ISSUER.

| Classe | Códigos diretos | O que trata |
|---|---|---|
| [Estrutura](meta/_index.md#구조) | `0x1C0L~0x1C4L` | limites e comprimento do documento |
| [Definição](meta/_index.md#정의) | `0x1C5L~0x1CAL` | declarações de interpretação |
| [Proveniência](meta/_index.md#출처) | `0x1CBL~0x1D0L` | quem, quando, onde |
| [Linhagem](meta/_index.md#계보) | `0x1D1L~0x1DDL` | de que e como se originou |
| [Política](meta/_index.md#정책) | `0x1DEL~0x1E3L` | como é tratado |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | traz um documento externo por um ID de IMPORT (`IMPORT-DOC`) |
| [Verificação](meta/_index.md#검증) | `0x1E5L~0x1E9L` | se é confiável |
| Reserved (exclusivo de verificação) | `0x1EAL~0x1FFL` |  |

- Os números continuam sem Reserved a partir de `0x1C0L`. Um novo Meta fora de verificação não pode ser inserido antes de verificação. O Reserved posterior `0x1EAL~0x1FFL` é exclusivo de verificação. Se um Meta que não é de verificação for colocado ali, ficará fora do hash de conteúdo.

### Estrutura (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | Nome | Descrição |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | início de documento com o comprimento total especificado em Payload de 1 WORD |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | início de documento com o comprimento total especificado em Payload de 2 WORD |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | início de documento com o comprimento total especificado em Payload de 4 WORD |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. Encerra o HEAD do documento e inicia o BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. Fecha o documento. |

### Definição (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | Nome | Descrição |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | edição da especificação GEUL seguida. O Payload é o próprio inteiro sem sinal (unsigned) da menor largura. A v1 é `0x0001` (registro `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | perfil aplicado |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | identificador deste documento. Reference embutida `DOC-POINTER` (Issuer, ID do documento, versão 0). Um documento de Codec usa `CODEC-POINTER` (Issuer, ID do Codec, versão 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | data de entrada em vigor desta versão. Value GREGORIAN-DATE ou POSIX-TIMESTAMP. Se não houver, o momento da publicação |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | fim da vigência desta versão (norma temporária). Se não houver, até a entrada em vigor da versão seguinte |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | idioma padrão |

### Proveniência (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | Nome | Descrição |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | autor. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | coautor. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | momento da criação. Value TIME (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | momento da modificação. Value TIME |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | agente que registrou. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | momento do registro. Value TIME (git commit date) |

- O material de origem, seu âmbito, o momento da obtenção e o hash não se escrevem em Meta, mas no Edge de fundamento [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) do HEAD (Target `0`) e em seu QUALIFIER.

### Linhagem (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | Nome | Descrição |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | hash de conteúdo da versão imediatamente anterior (git parent). Se não houver, é a versão inicial; se houver vários, é uma fusão (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | derivado de registros ou materiais de outra linhagem. Para fixar uma versão específica de um material externo, anexa-se ao [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) do HEAD um QUALIFIER de hash do texto original (P4092) (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | agente gerador. Pessoa, modelo, motor de regras |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | método de transformação. Ferramenta, regra, versão |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | hash de conteúdo da versão original da qual se trouxe uma alteração de outra linhagem (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | hash de conteúdo da versão alvo cuja alteração foi desfeita (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | hash de conteúdo da versão alvo que foi reescrita (git amend·rebase). A versão original não é apagada. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | hashes de conteúdo das versões originais reunidas em uma (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | motivo da alteração. Value UTF8-LANGUAGE-TEXT, um por idioma (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | nome imutável dado a uma versão. Value TEXT e hash de conteúdo (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | o arquivo desta versão é um diff em relação à versão base do mesmo documento (ID de versão de 2 WORD) (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | lista de IDs LOCAL (Edge Id) a retirar do BODY base no diff |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | próximo ID LOCAL a atribuir (auto increment). Fica no HEAD da lista de versões `versions.geul` |

### Política (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | Nome | Descrição |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | licença. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | âmbito de divulgação |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | nível de dados pessoais |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | prazo de retenção |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | âmbito e fundamento do consentimento |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | restrições de uso |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | Nome | Descrição |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | traz um documento externo por um ID de IMPORT. Reference embutida `DOC-POINTER` (para um documento de Codec, `CODEC-POINTER`) + ID de IMPORT |

### Verificação (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | Nome | Descrição |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | declaração do ID do algoritmo de assinatura e da chave pública de um Issuer autoemitido |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | assinatura sobre um alvo. A assinatura do documento assina o hash de conteúdo (commit e tag assinados do git) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | confirmação do direito de contribuir. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | confiabilidade |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | resultado do julgamento do documento inteiro. Pass, Review, Fail. Por nó ou registro, é o `VERDICT` de [TOULMIN](toulmin/_index.md) (Edge `0x118L`) |

## Tabela completa de atribuição {#전체-배정표}

227 casas atribuídas, 176 arquivos md. Os sistemas 5Q e os pares par·ímpar têm uma linha por membro, e o md é o md do cabeça do grupo.

| TAG ID | Codec ID | Nome | Kind | Seção | md | Grupo |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | par·ímpar `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | par·ímpar `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | par·ímpar `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | par·ímpar `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | par·ímpar `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | par·ímpar `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | par·ímpar `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | par·ímpar `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | par·ímpar `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | par·ímpar `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | par·ímpar `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | par·ímpar `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | par·ímpar `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | par·ímpar `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
