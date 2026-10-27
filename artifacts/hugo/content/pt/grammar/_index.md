---
title: "Gramática do GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Especificação da gramática do GEUL v1. Define os registros sobre palavras de 16 bits, os quatro Kinds e todos os Codecs, a estrutura do documento e as regras de Issuer e publicação."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

Esta é a especificação da gramática do GEUL v1. Se for a primeira leitura, siga a ordem abaixo.

1. [Visão geral](/pt/grammar/overview/) — o que é o GEUL e com quais princípios foi projetado
2. [Registro e TAG WORD](/pt/grammar/record/) — a TAG WORD de 16 bits, Kind, Length, Codec
3. [Documento](/pt/grammar/document/) — HEAD e BODY, hash de conteúdo, versão e revisão
4. [Reference](/pt/grammar/reference/), [Value](/pt/grammar/value/), [Edge](/pt/grammar/edge/), [Meta](/pt/grammar/meta/) — os quatro Kinds
5. [Issuer e publicação](/pt/grammar/issuer/) — quem emite documentos e formatos, tabela de atribuição de 1 WORD, modo de divulgação, assinatura e chave de verificação
6. [Endereço de publicação e lista de versões](/pt/grammar/publishing/) — notação de ID, endereço de publicação, especificação de formato, índice de nomes, lista de versões, camadas de confiança
7. [Documento de especificação de Codec](/pt/grammar/codec-spec/) — como escrever o layout de um Codec como documento GEUL
8. [Exemplo: item do Wikidata](/pt/grammar/example/) — um documento real completo

Esta página é o índice de todos os Codecs. Ao clicar num nome, vai-se ao documento detalhado desse Codec. Nomes sem link ainda não têm documento detalhado. Os códigos diretos que não estão na tabela são reservados.

## Kind

A TAG WORD é `000K KLLL LCCC CCCC`. `KK` é o Kind, `LLLL` é o Length e `CCC CCCC` são os 7 bits de Codec. Em Reference, porém, são 4 bits de Codec e 3 bits de Quantifier.

| Valor | Classificação | Descrição |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/pt/grammar/reference/) | Registro que aponta para um alvo. `QQQ` é o Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/pt/grammar/value/) | Registro de valor |
| `0001 0LLL LCCC CCCC` | [Edge](/pt/grammar/edge/) | Registro de composição |
| `0001 1LLL LCCC CCCC` | [Meta](/pt/grammar/meta/) | Registro sobre o documento e os registros |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/pt/grammar/reference/)

### Codec (`CCCC`)

| CCCC | Nome | Classificação | ID do alvo |
|---|---|---|---|
| `0000` | [Marcador de posição](/pt/grammar/reference/slot-marker/) | reservado | Conjunto de marcadores de 1 WORD que não apontam para alvo algum. Os 3 bits inferiores são o número do marcador (tabela abaixo) |
| `0001` | [LOCAL](/pt/grammar/reference/local/) | declaração | ID emitido por este documento |
| `0010` | [GEUL](/pt/grammar/reference/geul/) | declaração | Entidades emitidas pelo geul.org em CC0. Os números pequenos são atribuídos a entidades de alta frequência |
| `0011` | [GEUL-SIDX](/pt/grammar/reference/geul-sidx/) | declaração | GEUL SIDX (Semantic-aligned Index). Identificador que leva significado nos bits |
| `0100` | [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/) | declaração | Item do Wikidata. O inteiro depois de `Q` |
| `0101` | [WIKIDATA-PID](/pt/grammar/reference/wikidata-pid/) | declaração | Propriedade do Wikidata. O inteiro depois de `P` |
| `0110` | [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/) | indicação-declaração | O próprio Issuer. O Payload é só o Issuer (1/2/4/16 WORDs) e não há ID de alvo |
| `0111` | [DOC-POINTER](/pt/grammar/reference/doc-pointer/) | indicação-declaração | Uma versão de um documento do Issuer. Issuer + ID do documento de 4 WORDs + ID da versão de 2 WORDs, sem ID de alvo |
| `1000` | [EXTERNAL-POINTER-1WORD](/pt/grammar/reference/external-pointer/) | indicação | ID LOCAL de um documento importado com `IMPORT-DOC`. IMPORT ID de 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/pt/grammar/reference/external-pointer/) | indicação | Igual ao anterior. IMPORT ID de 2 WORDs |
| `1010` | [EXTERNAL-POINTER-4WORD](/pt/grammar/reference/external-pointer/) | indicação | Igual ao anterior. IMPORT ID de 4 WORDs |
| `1011` | [EXTERNAL-POINTER-8WORD](/pt/grammar/reference/external-pointer/) | indicação | Igual ao anterior. IMPORT ID de 8 WORDs |
| `1100` | [EXTERNAL-ISSUER-1WORD](/pt/grammar/reference/external-issuer/) | indicação-declaração | ID LOCAL de um documento de Issuer de 1 WORD |
| `1101` | [EXTERNAL-ISSUER-2WORD](/pt/grammar/reference/external-issuer/) | indicação-declaração | ID LOCAL de um documento de Issuer de 2 WORDs |
| `1110` | [EXTERNAL-ISSUER-4WORD](/pt/grammar/reference/external-issuer/) | indicação-declaração | ID LOCAL de um documento de Issuer de 4 WORDs |
| `1111` | [EXTERNAL-ISSUER-16WORD](/pt/grammar/reference/external-issuer/) | indicação-declaração | ID LOCAL de um documento de Issuer de 16 WORDs |

### Marcador de posição (Codec `0000`)

`0000 0000 0000 0MMM` — [Marcador de posição](/pt/grammar/reference/slot-marker/). Só aparece no lugar se a lista de CODEC do campo contiver essa WORD exatamente.

| WORD | Nome | Significado | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/pt/grammar/reference/slot-marker/) | Não informado. Um campo opcional foi omitido. Não afirma nada sobre o mundo | sem snak |
| `0x0001` | [UNKNOWN-VALUE](/pt/grammar/reference/slot-marker/) | Desconhecido. Há um valor, mas não se sabe qual | `somevalue` |
| `0x0002` | [NO-VALUE](/pt/grammar/reference/slot-marker/) | Sem valor. Não há valor | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | Nome | Significado | Exemplo |
|---|---|---|---|
| `000` | Identified | entidade identificada | Elon Musk, Brasil |
| `001` | Generic | declaração geral ou definidora sobre toda uma espécie. Admite exceções. | soldados obedecem a ordens |
| `010` | Free-choice | qualquer alvo que satisfaça a condição | qualquer soldado |
| `011` | Universal | todos os alvos dentro de um dado âmbito | todos os soldados |
| `100` | Variable | variável de discurso | aquela pessoa, esta mulher |
| `101`~`111` | Reserved |  |  |

- No Codec `0000` (marcador de posição), os 3 bits inferiores são o número do marcador, não um Quantifier.

## Issuer

O Issuer é a entidade que define documentos e formatos — [Issuer e publicação](/pt/grammar/issuer/)

| Lugar | Significado |
|---|---|
| Códigos ISSUER de Value e Edge (`0x7C`~`0x7F`) | formato definido por esse Issuer |
| Meta `DOC-ID` | Issuer que emitiu este documento |
| Meta `IMPORT-DOC` | Issuer que emitiu o documento importado |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER` | Issuer que emitiu o documento apontado (1/2/4/16 WORDs) |
| Reference `ISSUER-POINTER` | o próprio Issuer apontado (1/2/4/16 WORDs) |

| Largura do Issuer | Emissão |
|---|---|
| 1 WORD | O geul.org atribui a entidades de normalização e a grandes instituições ([tabela de atribuição de 1 WORD](/pt/grammar/issuer/#tabela-de-atribuição-de-1-word)). |
| 2 WORDs | Registro no geul.org. Issuer que passou pela prova de propriedade do domínio (ex.: company.com) |
| 4 WORDs | Registro no geul.org. Issuer registrado sem prova de propriedade |
| 16 WORDs | Autoemissão. Calculado a partir da chave pública, sem registro. Segue as regras de geração abaixo. |

### Algoritmo de assinatura do Issuer de 16 WORDs

| ID do algoritmo de assinatura | Algoritmo |
|---|---|
| `0x0001` | Ed25519 |
| outros | reservado |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/pt/grammar/edge/)

Os 2 bits superiores do Codec são a família. Tanto o código direto (7 bits) quanto o número de formato ISSUER (16 bits) seguem a mesma regra.

| 2 bits superiores | Família | Código direto | Número de formato |
|---|---|---|---|
| `00` | descritivo | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | fundamento | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | execução | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/pt/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Descritivo (`00`)

| CCCCC | Codec | Nome | Subformato | Descrição |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/pt/grammar/edge/reference-node/) |  | Vínculo direcional em que o Subject, uma Reference, indica o Object |
| `00001` | `0x01` | [SAME-NODE](/pt/grammar/edge/same-node/) |  | Identidade: duas References indicam o mesmo alvo |
| `00010` | `0x02` | [DIFFERENT-NODE](/pt/grammar/edge/different-node/) |  | Não identidade: duas References indicam alvos diferentes |
| `00011` | `0x03` | [BIND](/pt/grammar/edge/bind/) |  | Liga ao Subject um nome para máquina (`UTF8-TEXT-*`). Deve ser único no escopo e coincidir exatamente, e não tem idioma |
| `00100` | `0x04` | [LABEL](/pt/grammar/edge/label/) |  | Liga o nome em um idioma (label) do Subject. O Object é UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/pt/grammar/edge/alias/) |  | Liga outro nome (alias) do Subject. O layout é igual ao de LABEL |
| `00110` | `0x06` | [DESCRIPTION](/pt/grammar/edge/description/) |  | Liga a descrição (description) do Subject em um idioma. O layout é igual ao de LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | Descrição verbal abreviada |
| `01001` | `0x09` | VERB |  | Descrição verbal |
| `01010` | `0x0A` | [TRIPLE](/pt/grammar/edge/triple/) |  | Proposição na ordem Predicate, Subject, Object, mais o rank. O Object é um valor ou um marcador UNKNOWN-VALUE/NO-VALUE. O significado é a soma de todos os QUALIFIERs que apontam para o seu Edge Id |
| `01011` | `0x0B` | [QUALIFIER](/pt/grammar/edge/qualifier/) |  | Uma condição que restringe a proposição de outro Edge. Property, Target (Edge Id), Value (valor ou marcador UNKNOWN-VALUE/NO-VALUE). Faz parte da proposição |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | sim | Estrutura para expressar visões de mundo |
| `10001` | `0x11` | TIMELINE | sim | Estrutura para expressar a ordem de mundos e eventos |
| `10010` | `0x12` | SCENE | sim | Estrutura de cena para descrições de natureza de roteiro |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/pt/grammar/edge/publication/) |  | Publicação do documento. DOC-POINTER, hash de conteúdo |
| `11001` | `0x19` | DEPRECATION |  | Deprecação de uma versão publicada. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | Remoção (lápide) de uma versão publicada. DOC-POINTER, categoria do motivo |
| `11011` | `0x1B` | [DECLARE](/pt/grammar/edge/declare/) |  | Declaração da composição do Payload de um Codec. Kind·Codec alvo |
| `11100` | `0x1C` | [FIELD](/pt/grammar/edge/field/) |  | Um campo do Payload. DECLARE a que pertence, largura: registro (Length da TAG) ou valor bruto de n WORDs |
| `11101` | `0x1D` | [ENUM](/pt/grammar/edge/enum/) |  | Um valor de código de um campo de valor bruto. Campo, valor de código |
| `11110` | `0x1E` | [CODEC](/pt/grammar/edge/codec/) |  | Um Kind·Codec que o campo aceita. Campo, WORD alvo (`000K KLLL LCCC CCCC`, LLLL 0000 exato · 1111 curinga; marcadores de posição só como alvo exato `0000`~`0002`). Um campo de registro pode ter vários (lista fechada); um campo de valor bruto, um (esse Value sem TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| 2 bits superiores de CCCCC | Grupo |
|---|---|
| `00` | indicação e nome |
| `01` | proposição |
| `10` | estrutura |
| `11` | outros |

### Fundamento (`01`)

| Codec | Nome | Subformato | Descrição |
|---|---|---|---|
| `0x20` | [SOURCE](/pt/grammar/edge/source/) |  | Liga um registro ou o documento inteiro à sua fonte. Target (Edge Id do BODY; no HEAD, `0` = documento inteiro), Origin (Reference, ABSENT ou UNKNOWN-VALUE). As propriedades da fonte vão em um TRIPLE que tem a fonte como Subject; as propriedades da citação (data de consulta, posição, hash do texto original) vão em QUALIFIERs ligados ao SOURCE. O SOURCE do documento inteiro e seus QUALIFIERs ficam no HEAD |
| `0x21`~`0x3F` | Reserved |  |  |

- Faixa do texto original, autor, grau de confiança, período de vigência por artigo e registros antigos escrevem-se com QUALIFIER; a versão em que um registro entrou pela primeira vez calcula-se a partir do histórico de versões ([SOURCE](/pt/grammar/edge/source/#outras-formas-de-expressar-o-fundamento)).

### Execução (`10`)

| CCCCC | Codec | Nome | Descrição |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | Declaração de função. Símbolo, lista de símbolos de parâmetros, tipo de retorno, corpo (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | Declaração de tipo. Símbolo e composição (lista de símbolos de campos, valores de enumeração, alvo do alias) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | Expressão constante. Um Value embutido |
| `01001` | `0x49` | UNARY | Expressão unária. Operador de 1 WORD, operando |
| `01010` | `0x4A` | BINARY | Expressão binária. Operador de 1 WORD, esquerda, direita |
| `01011` | `0x4B` | CALL | Chamada. Função alvo, número de argumentos, argumentos × número de argumentos |
| `01100` | `0x4C` | MEMBER | Acesso a membro. Alvo, símbolo do campo |
| `01101` | `0x4D` | INDEX | Acesso por índice. Alvo, índice |
| `01110` | `0x4E` | CONSTRUCT | Criação de valor composto (lista, registro). Tipo, número de elementos, elementos × número de elementos |
| `01111` | `0x4F` | CONDITIONAL | Expressão condicional. Condição, valor se verdadeira, valor se falsa |
| `10000` | `0x50` | BLOCK | Conjunto ordenado de instruções. Número de instruções, instruções × número de instruções |
| `10001` | `0x51` | ASSIGN | Atribuição. Alvo (símbolo, MEMBER, INDEX), valor |
| `10010` | `0x52` | IF | Ramificação condicional. Condição, BLOCK verdadeiro, falso (BLOCK ou IF; 0 se não houver) |
| `10011` | `0x53` | SWITCH | Ramificação múltipla. Alvo, número de ramos, (valor, BLOCK) × número de ramos, BLOCK padrão (0 se não houver) |
| `10100` | `0x54` | WHILE | Repetição condicional. Condição, BLOCK do corpo |
| `10101` | `0x55` | FOREACH | Repetição por iteração. Símbolo do elemento, alvo, BLOCK do corpo |
| `10110` | `0x56` | JUMP | Controle de repetição. Tipo de 1 WORD (break, continue), repetição alvo |
| `10111` | `0x57` | RETURN | Retorno. Valor (0 se não houver) |
| `11000` | `0x58` | RAISE | Geração de erro. Valor do erro |
| `11001` | `0x59` | TRY | Tratamento de erro. BLOCK do corpo, símbolo do erro, BLOCK de tratamento, BLOCK de finalização (0 se não houver) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| 2 bits superiores de CCCCC | Grupo |
|---|---|
| `00` | declaração |
| `01` | expressão |
| `10` | instrução |
| `11` | erro |

### TOULMIN (`11`)

Detalhes: [TOULMIN](/pt/grammar/edge/toulmin/)

| CCCCC | Codec | Nome | Descrição |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/pt/grammar/edge/toulmin/node/) | Declaração de caso. Grafo de julgamento com nós e relações |
| `00001` | `0x61` | [PREDICATE-DECLARE](/pt/grammar/edge/toulmin/expr/) | Declaração de predicado. Função ou expressão de julgamento, critério de julgamento (Spec), contrato de fatos (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/pt/grammar/edge/toulmin/node/) | Declaração de critério de julgamento. Constantes e listas (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/pt/grammar/edge/toulmin/node/) | Declaração de afirmação. Coloca um predicado como regra geral (Warrant) dentro do caso. Pode ser atacada. |
| `00100` | `0x64` | [COUNTER-DECLARE](/pt/grammar/edge/toulmin/node/) | Declaração de contestação. Ataca com conclusão própria. O Level padrão é Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/pt/grammar/edge/toulmin/node/) | Declaração de exceção. Ataca sem conclusão própria. O Level padrão é Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/pt/grammar/edge/toulmin/link/) | Relação de ataque. O julgamento do atacante reduz gradualmente o julgamento do alvo. |
| `01001` | `0x69` | [SUPERSEDES](/pt/grammar/edge/toulmin/link/) | Relação de exclusão. Se o atacante está Active, retira o alvo da agregação de forma determinística. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | Cadeia de prioridade `A > B > C`. Abreviação de SUPERSEDES par a par. Layout indefinido |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/pt/grammar/edge/toulmin/link/) | Composição de execução. Se o nó está Active, executa o caso inferior (DAG). |
| `10001` | `0x71` | [DO](/pt/grammar/edge/toulmin/link/) | Ação executada se o nó está Active |
| `10010` | `0x72` | [DO-ONCE](/pt/grammar/edge/toulmin/link/) | Ação executada uma única vez, mesmo com novas tentativas |
| `10011` | `0x73` | [UNDO](/pt/grammar/edge/toulmin/link/) | Ação de compensação de DO (saga). Se uma etapa posterior falha, é executada em ordem inversa. |
| `10100` | `0x74` | [CHECKING](/pt/grammar/edge/toulmin/link/) | Ligação que só julga, sem efeitos colaterais |
| `10101` | `0x75` | [ENTRY](/pt/grammar/edge/toulmin/node/) | Ponto de entrada externo. Executa ou julga o caso |
| `10110` | `0x76` | [TRIGGER](/pt/grammar/edge/toulmin/node/) | Ponto de entrada de evento ou periódico, sem chamada externa |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | Resultado do julgamento de um nó ou registro. Resultado (Pass, Review, Fail), valor do julgamento, Activated, Excluded, Level. Layout indefinido. O julgamento do documento inteiro é o Meta [VERDICT](/pt/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | Evidência do julgamento. Posição, valor esperado, valor real (Fact). Layout indefinido |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Formato definido por um Issuer |

| 2 bits superiores de CCCCC | Grupo |
|---|---|
| `00` | declaração |
| `01` | relação |
| `10` | execução |
| `11` | resultado (`0x7C`~`0x7F` são ISSUER) |

### Formatos ISSUER de Edge

Depois de `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD), a TAG estendida de Codec contém o Issuer e o número de formato. Os 2 bits superiores do número de formato são a família. O espaço de números de formato é separado do de Value.

| Issuer | Número de formato | Nome | Família | Descrição |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/pt/grammar/edge/toulmin/source/) | TOULMIN | Texto original de autoria. Largura SPAN e Value UTF8 |
| `0x0000` GEUL | `0xC001` | [TEXT](/pt/grammar/edge/toulmin/source/) | TOULMIN | Nomes e cadeias de caracteres |
| `0x0000` GEUL | `0xC002` | [SECTION](/pt/grammar/edge/toulmin/source/) | TOULMIN | Início de seção. Código da seção |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/pt/grammar/edge/toulmin/source/) | TOULMIN | Início do âmbito do caso |
| `0x0000` GEUL | `0xC004` | [CASE-END](/pt/grammar/edge/toulmin/source/) | TOULMIN | Fim do âmbito do caso |
| `0x0000` GEUL | `0xC005` | [PROSE](/pt/grammar/edge/toulmin/source/) | TOULMIN | Parágrafo descritivo (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/pt/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/pt/grammar/edge/toulmin/node/) | TOULMIN | NODE. Referência de função |
| `0x0000` GEUL | `0xC012` | [FIELD](/pt/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/pt/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/pt/grammar/edge/toulmin/node/) | TOULMIN | NODE. Conjunto de execução ordenado |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. caso → campo |
| `0x0000` GEUL | `0xC021` | [MEANS](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. item de definição → valor ou tipo |
| `0x0000` GEUL | `0xC022` | [HAS](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. item de definição → campo |
| `0x0000` GEUL | `0xC023` | [RUNS](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. ponto de entrada → caso, execução |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. ponto de entrada → caso, julgamento |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. gatilho → caso |
| `0x0000` GEUL | `0xC026` | [UNTIL](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. gatilho → caso (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. nó → identificador global |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. alias → caminho (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/pt/grammar/edge/toulmin/link/) | TOULMIN | LINK. nó → TEXT, notação do nome |

## Value

`0000 1LLL LCCC CCCC` — [Value](/pt/grammar/value/)

Os 2 bits superiores do Codec são a família. NUMERIC/DECIMAL se dividem de novo pelo terceiro bit superior (`000` NUMERIC, `001` DECIMAL).

| 2 bits superiores | Família | Código direto | Número de formato |
|---|---|---|---|
| `00` | [NUMERIC](/pt/grammar/value/numeric/)/[DECIMAL](/pt/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/pt/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/pt/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/pt/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Código direto

| Codec | Nome | Família | Descrição |
|---|---|---|---|
| `0x00` | [BOOL](/pt/grammar/value/numeric/bool/) | NUMERIC | false ou true em 1 WORD fixa |
| `0x01` | [SIGNED-INTEGER](/pt/grammar/value/numeric/signed-integer/) | NUMERIC | Inteiro com sinal em complemento de dois, no mínimo de WORDs |
| `0x02` | [UNSIGNED-INTEGER](/pt/grammar/value/numeric/unsigned-integer/) | NUMERIC | Inteiro com magnitude sem sinal big-endian, no mínimo de WORDs |
| `0x03` | [BINARY-FLOAT](/pt/grammar/value/numeric/binary-float/) | NUMERIC | Escalar IEEE 754 binary16/32/64/128 com Payload de 1/2/4/8 WORDs |
| `0x04` | [COORDINATE-EARTH](/pt/grammar/value/numeric/coordinate-earth/) | NUMERIC | Latitude e longitude binary64 na Terra (WGS 84), incerteza binary32 e a Reference da sua unidade (ABSENT = desconhecida) |
| `0x05` | [COORDINATE-GEO](/pt/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference de corpo celeste, latitude e longitude binary64, incerteza binary32 e a Reference da sua unidade |
| `0x06` | [QUANTITY](/pt/grammar/value/numeric/quantity/) | NUMERIC | amount Value numérico (inteiro, BINARY-FLOAT, decimal, fração), Reference da unidade, limite inferior e superior. Unidade e limites podem ser omitidos (ABSENT `0x0000`) |
| `0x07` | [FRACTION](/pt/grammar/value/numeric/fraction/) | NUMERIC | Fração que preserva a notação original: numerador inteiro ou decimal, denominador inteiro ou decimal sem sinal. Não é simplificada |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` com expoente com sinal `E` e coeficiente `C` em complemento de dois no mínimo de WORDs |
| `0x11` | [UNSIGNED-DECIMAL](/pt/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` com expoente com sinal `E` e coeficiente sem sinal `C` no mínimo de WORDs |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/) | TIME | Número de dias com sinal em relação a `1970-01-01` no calendário gregoriano proléptico |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/pt/grammar/value/time/civil-time-nanoseconds/) | TIME | Contagem de nanossegundos sem sinal desde a meia-noite do dia civil |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/pt/grammar/value/time/posix-timestamp-seconds/) | TIME | Contagem de segundos com sinal desde a epoch Unix/POSIX |
| `0x23` | [DURATION-SECONDS](/pt/grammar/value/time/duration-seconds/) | TIME | Tempo decorrido em segundos SI com sinal, sem epoch |
| `0x24`/`0x25` | [EDTF](/pt/grammar/value/time/edtf/) | TIME | Cadeia de data EDTF (ISO 8601-2). Número par/ímpar de bytes. Datas que podem ser GREGORIAN-DATE não se escrevem assim |
| `0x26`/`0x27` | [GEDCOM-DATE](/pt/grammar/value/time/gedcom-date/) | TIME | Cadeia de valor de data GEDCOM 7. Preserva a notação original de outros calendários (juliano etc.). Número par/ímpar de bytes |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/pt/grammar/value/text/utf8-text/) | TEXT | Sequência de bytes UTF-8 válida que não implica normalização. Número par de bytes |
| `0x41` | [UTF8-TEXT-ODD](/pt/grammar/value/text/utf8-text/) | TEXT | Igual ao anterior. Número ímpar de bytes |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/pt/grammar/value/text/uri/) | TEXT | Sequência de bytes ASCII da produção `URI` da RFC 3986. Número par de bytes |
| `0x45` | [URI-ODD](/pt/grammar/value/text/uri/) | TEXT | Igual ao anterior. Número ímpar de bytes |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/pt/grammar/value/text/language-bcp47-code/) | TEXT | Sequência de bytes ASCII de uma language tag BCP 47 completa em canonical casing. Número par de bytes |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/pt/grammar/value/text/language-bcp47-code/) | TEXT | Igual ao anterior. Número ímpar de bytes |
| `0x48` | [LANGUAGE-SHORT-CODE](/pt/grammar/value/text/language-short-code/) | TEXT | Código comprimido de idioma primário do GEUL, com Payload fixo de 1 WORD |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/) | TEXT | Texto com idioma. Registro Value de idioma (LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE) e bytes UTF-8. Paridade dos bytes do texto |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/pt/grammar/value/binary/uuid/) | BINARY | UUID RFC 9562 de 128 bits, com Payload fixo de 8 WORDs |
| `0x61` | [SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/) | BINARY | Resultado SHA-256, com Payload fixo de 16 WORDs |
| `0x62` | [SHA1-DIGEST](/pt/grammar/value/binary/sha1-digest/) | BINARY | Resultado SHA-1, com Payload fixo de 10 WORDs. Apenas para identificação, como IDs de objetos git |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Formato definido por um Issuer. Veja Formatos ISSUER de Value abaixo |

### Formatos ISSUER de Value

Depois de `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD), a TAG estendida de Codec contém o Issuer e o número de formato. Os 2 bits superiores do número de formato são a família.

| Issuer | Número de formato | Nome | Família | Descrição |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/pt/grammar/value/time/duration-nanoseconds/) | TIME | Tempo decorrido em nanossegundos com sinal, sem epoch |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/pt/grammar/value/binary/opaque-bytes/) | BINARY | Sequência de bytes de significado e formato desconhecidos. Número par de bytes |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/pt/grammar/value/binary/opaque-bytes/) | BINARY | Igual ao anterior. Número ímpar de bytes |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/pt/grammar/value/binary/bit-vector/) | BINARY | N bits guardados em MSB-first depois de bit-count |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | Bits de interchange BF16, com Payload fixo de 1 WORD |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/pt/grammar/value/vector/dense-i16-vector/) | NUMERIC | vector contíguo de int16 big-endian |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/pt/grammar/value/vector/dense-u16-vector/) | NUMERIC | vector contíguo de uint16 big-endian |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/pt/grammar/value/vector/dense-i32-vector/) | NUMERIC | vector contíguo de int32 big-endian |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/pt/grammar/value/vector/dense-u32-vector/) | NUMERIC | vector contíguo de uint32 big-endian |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/pt/grammar/value/vector/dense-i64-vector/) | NUMERIC | vector contíguo de int64 big-endian |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/pt/grammar/value/vector/dense-u64-vector/) | NUMERIC | vector contíguo de uint64 big-endian |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/pt/grammar/value/vector/dense-binary16-vector/) | NUMERIC | vector contíguo de IEEE 754 binary16 |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/pt/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | vector contíguo de BF16 |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/pt/grammar/value/vector/dense-binary32-vector/) | NUMERIC | vector contíguo de IEEE 754 binary32 |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/pt/grammar/value/vector/dense-binary64-vector/) | NUMERIC | vector contíguo de IEEE 754 binary64 |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/pt/grammar/value/vector/point2-binary64/) | NUMERIC | vector bidimensional IEEE binary64 na ordem `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/pt/grammar/value/vector/point3-binary64/) | NUMERIC | vector tridimensional IEEE binary64 na ordem `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/pt/grammar/value/vector/bbox2-binary64/) | NUMERIC | vector IEEE binary64 na ordem `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/pt/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format, rank, shape e payload dense C-contiguous |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/pt/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format, rank, shape e payload packed low-bit-first dentro do octeto |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/pt/grammar/value/etc/complex64/) | NUMERIC | dois binary32 na ordem `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/pt/grammar/value/etc/complex128/) | NUMERIC | dois binary64 na ordem `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/pt/grammar/value/etc/rational-i64/) | NUMERIC | numerator int64 normalizado e denominator int64 positivo |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/pt/grammar/value/etc/closed-interval-binary64/) | NUMERIC | intervalo fechado binary64 com `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/pt/grammar/value/etc/quaternion-binary32/) | NUMERIC | quatro binary32 na ordem `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/pt/grammar/value/binary/blake3-256-digest/) | BINARY | Resultado padrão BLAKE3, com Payload fixo de 16 WORDs |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/pt/grammar/value/text/uri-relative-ref/) | TEXT | Sequência de bytes ASCII de relative-ref da RFC 3986. Número par de bytes |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/pt/grammar/value/text/uri-relative-ref/) | TEXT | Igual ao anterior. Número ímpar de bytes |
| `0x0020` IETF | `0xC000` | [CRC32C](/pt/grammar/value/binary/crc32c/) | BINARY | Resultado Castagnoli CRC-32C, com Payload fixo de 2 WORDs |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/pt/grammar/value/binary/ipv4-address/) | BINARY | Endereço IPv4 de 32 bits, com Payload fixo de 2 WORDs |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/pt/grammar/value/binary/ipv6-address/) | BINARY | Endereço IPv6 de 128 bits, com Payload fixo de 8 WORDs |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/pt/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE 754 decimal32 DPD, com Payload fixo de 2 WORDs |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/pt/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE 754 decimal64 DPD, com Payload fixo de 4 WORDs |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/pt/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE 754 decimal128 DPD, com Payload fixo de 8 WORDs |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/pt/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE 754 decimal32 BID, com Payload fixo de 2 WORDs |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/pt/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE 754 decimal64 BID, com Payload fixo de 4 WORDs |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/pt/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE 754 decimal128 BID, com Payload fixo de 8 WORDs |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/pt/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | Contagem de nanossegundos com sinal desde a epoch Unix/POSIX |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/pt/grammar/value/binary/mac-48-address/) | BINARY | Endereço MAC IEEE 802 de 48 bits, com Payload fixo de 3 WORDs |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/pt/grammar/value/vector/rgba8-unorm/) | NUMERIC | packed vector fixo de 4×UNORM8 na ordem R, G, B, A |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/pt/grammar/value/vector/bgra8-unorm/) | NUMERIC | packed vector fixo de 4×UNORM8 na ordem B, G, R, A |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | Escalar ONNX E4M3FN no octeto superior do Payload |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | Escalar ONNX E4M3FNUZ no octeto superior do Payload |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | Escalar ONNX E5M2 no octeto superior do Payload |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | Escalar ONNX E5M2FNUZ no octeto superior do Payload |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Escalar E8M0FNU sem sinal, só de expoente, no octeto superior do Payload |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | Escalar ONNX/DLPack E2M1FN no nibble superior do Payload |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/pt/grammar/value/time/tai-timestamp-seconds/) | TIME | Contagem de segundos SI com sinal desde `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/pt/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | Contagem de nanossegundos com sinal desde a mesma epoch TAI |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/pt/grammar/value/binary/sha-512-digest/) | BINARY | Resultado SHA-512, com Payload fixo de 32 WORDs |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/pt/grammar/value/binary/sha3-256-digest/) | BINARY | Resultado SHA3-256, com Payload fixo de 16 WORDs |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/pt/grammar/value/time/gps-timestamp-seconds/) | TIME | Contagem de segundos com sinal desde a epoch GPS |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/pt/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | Contagem de nanossegundos com sinal desde a epoch GPS |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/pt/grammar/meta/)

Os 3 bits superiores do Codec são a classe. Meta não tem código ISSUER.

| 3 bits superiores | Classe | Código direto | O que trata |
|---|---|---|---|
| `000` | [Estrutura](/pt/grammar/meta/structure/) | `0x00`~`0x0F` | limites e comprimento do documento |
| `001` | [Declaração](/pt/grammar/meta/declaration/) | `0x10`~`0x1F` | declarações de interpretação |
| `010` | [Proveniência](/pt/grammar/meta/provenance/) | `0x20`~`0x2F` | quem, quando, onde |
| `011` | [Linhagem](/pt/grammar/meta/lineage/) | `0x30`~`0x3F` | de que e como surgiu |
| `100` | [Verificação](/pt/grammar/meta/verification/) | `0x40`~`0x4F` | se é confiável |
| `101` | [Política](/pt/grammar/meta/policy/) | `0x50`~`0x5F` | como é tratado |
| `110` | [IMPORT](/pt/grammar/meta/import/) | `0x60`~`0x6F` | importa um documento externo por IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### Estrutura (`000`)

| Codec | Nome | Descrição |
|---|---|---|
| `0x00` | [DOC-1WORD](/pt/grammar/meta/structure/doc/) | Início de documento com o comprimento total indicado em 1 WORD de Payload |
| `0x01` | [DOC-2WORD](/pt/grammar/meta/structure/doc/) | Início de documento com o comprimento total indicado em 2 WORDs de Payload |
| `0x02` | [DOC-4WORD](/pt/grammar/meta/structure/doc/) | Início de documento com o comprimento total indicado em 4 WORDs de Payload |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/pt/grammar/meta/structure/body/) | 1 WORD. Encerra o HEAD do documento e inicia o BODY. |
| `0x0F` | [END](/pt/grammar/meta/structure/end/) | 1 WORD. Fecha o documento. |

### Declaração (`001`)

| Codec | Nome | Descrição |
|---|---|---|
| `0x10` | [SPEC-VERSION](/pt/grammar/meta/declaration/spec-version/) | Versão da especificação GEUL que se segue. O Payload é o próprio inteiro sem sinal na menor largura. A v1 é `0x0001` (registro `0x1890 0x0001`) |
| `0x11` | [PROFILE](/pt/grammar/meta/declaration/profile/) | Perfil aplicado |
| `0x12` | [DOC-ID](/pt/grammar/meta/declaration/doc-id/) | Identificador deste documento. Reference embutida `DOC-POINTER` (Issuer, ID do documento, versão 0) |
| `0x13` | [EFFECTIVE-FROM](/pt/grammar/meta/declaration/effective-from/) | Data de entrada em vigor desta versão. Value GREGORIAN-DATE ou POSIX-TIMESTAMP. Se não houver, o instante da publicação |
| `0x14` | [EFFECTIVE-UNTIL](/pt/grammar/meta/declaration/effective-until/) | Fim da validade desta versão (lei temporária). Se não houver, até a entrada em vigor da próxima versão |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/pt/grammar/meta/declaration/default-language/) | Idioma padrão |
| `0x17`~`0x1F` | Reserved |  |

### Proveniência (`010`)

| Codec | Nome | Descrição |
|---|---|---|
| `0x20` | [AUTHOR](/pt/grammar/meta/provenance/author/) | Autor. Reference (git author) |
| `0x21` | [CO-AUTHOR](/pt/grammar/meta/provenance/co-author/) | Coautor. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/pt/grammar/meta/provenance/created-at/) | Instante de criação. Value TIME (git author date) |
| `0x23` | [MODIFIED-AT](/pt/grammar/meta/provenance/modified-at/) | Instante de modificação. Value TIME |
| `0x24` | [RECORDED-BY](/pt/grammar/meta/provenance/recorded-by/) | Quem registrou. Reference (git committer) |
| `0x25` | [RECORDED-AT](/pt/grammar/meta/provenance/recorded-at/) | Instante do registro. Value TIME (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- O material de origem e seu alcance, instante de obtenção e hash não vão em Meta, e sim no Edge de fundamento [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do HEAD (Target `0`) e em seus QUALIFIERs.

### Linhagem (`011`)

| Codec | Nome | Descrição |
|---|---|---|
| `0x30` | [PARENT](/pt/grammar/meta/lineage/parent/) | Hash de conteúdo da versão imediatamente anterior (git parent). Se não houver, é a primeira versão; se houver várias, é um merge (git merge commit). |
| `0x31` | [DERIVED-FROM](/pt/grammar/meta/lineage/derived-from/) | Derivado de registros ou materiais de outra linhagem. Para fixar numa versão específica de material externo, acrescenta-se ao [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do HEAD um QUALIFIER de hash do texto original (P4092) (git submodule). |
| `0x32` | [GENERATED-BY](/pt/grammar/meta/lineage/generated-by/) | Quem gerou. Pessoa, modelo, motor de regras |
| `0x33` | [TRANSFORMED-BY](/pt/grammar/meta/lineage/transformed-by/) | Método de transformação. Ferramenta, regra, versão |
| `0x34` | [CHERRY-PICKED-FROM](/pt/grammar/meta/lineage/cherry-picked-from/) | Hash de conteúdo da versão original de onde se trouxe uma mudança de outra linhagem (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/pt/grammar/meta/lineage/reverts/) | Hash de conteúdo da versão alvo cuja mudança foi desfeita (git revert) |
| `0x36` | [REPLACES](/pt/grammar/meta/lineage/replaces/) | Hash de conteúdo da versão alvo que foi reescrita (git amend, rebase). A versão original não é apagada. |
| `0x37` | [SQUASHED-FROM](/pt/grammar/meta/lineage/squashed-from/) | Hashes de conteúdo das versões originais reunidas em uma (git squash) |
| `0x38` | [MESSAGE](/pt/grammar/meta/lineage/message/) | Motivo da mudança. Value UTF8-LANGUAGE-TEXT, um por idioma (git commit message) |
| `0x39` | [TAG](/pt/grammar/meta/lineage/tag/) | Nome imutável dado a uma versão. Value TEXT e hash de conteúdo (git annotated tag) |
| `0x3A` | [DELTA-BASE](/pt/grammar/meta/lineage/delta-base/) | Este arquivo de versão é um diff em relação à versão base do mesmo documento (ID de versão de 2 WORDs) (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/pt/grammar/meta/lineage/delta-remove/) | Lista de IDs LOCAL (Edge Id) a retirar do BODY base no diff |
| `0x3C` | [NEXT-LOCAL-ID](/pt/grammar/meta/lineage/next-local-id/) | Próximo ID LOCAL a atribuir (auto increment). Fica no HEAD da lista de versões `versions.geul` |
| `0x3D`~`0x3F` | Reserved |  |

### Verificação (`100`)

| Codec | Nome | Descrição |
|---|---|---|
| `0x40` | [ISSUER-KEY](/pt/grammar/meta/verification/issuer-key/) | Declaração do ID do algoritmo de assinatura e da chave pública de um Issuer autoemitido |
| `0x41` | [SIGNATURE](/pt/grammar/meta/verification/signature/) | Assinatura sobre um alvo. A assinatura do documento assina o hash de conteúdo (git signed commit/tag) |
| `0x42` | [SIGNED-OFF](/pt/grammar/meta/verification/signed-off/) | Confirmação do direito de contribuir. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/pt/grammar/meta/verification/confidence/) | Grau de confiança |
| `0x44` | [VERDICT](/pt/grammar/meta/verification/verdict/) | Resultado do julgamento do documento inteiro. Pass, Review, Fail. Por nó ou registro, usa-se [TOULMIN](/pt/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### Política (`101`)

| Codec | Nome | Descrição |
|---|---|---|
| `0x50` | [LICENSE](/pt/grammar/meta/policy/license/) | Licença. Reference |
| `0x51` | [ACCESS](/pt/grammar/meta/policy/access/) | Âmbito de divulgação |
| `0x52` | [PRIVACY](/pt/grammar/meta/policy/privacy/) | Nível de dados pessoais |
| `0x53` | [RETENTION](/pt/grammar/meta/policy/retention/) | Prazo de retenção |
| `0x54` | [CONSENT](/pt/grammar/meta/policy/consent/) | Âmbito e fundamento do consentimento |
| `0x55` | [USAGE](/pt/grammar/meta/policy/usage/) | Restrições de uso |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | Nome | Descrição |
|---|---|---|
| `0x60` | [IMPORT-DOC](/pt/grammar/meta/import/import-doc/) | Importa um documento externo por IMPORT ID. Reference embutida `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
