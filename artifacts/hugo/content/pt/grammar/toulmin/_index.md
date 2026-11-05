---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Escreve grafos de julgamento e de execução com o modelo de argumentação de Toulmin."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Escreve grafos de julgamento e de execução com o modelo de argumentação de Toulmin. É a família central para que o GEUL descreva as próprias regras em GEUL e as corrija por conta própria.

| Grupo | Codec |
|---|---|
| declaração | [CASE-DECLARE](0x100L-case-declare.md) (caso), [PREDICATE-DECLARE](0x101L-predicate-declare.md) (predicado), [SPEC-DECLARE](0x102L-spec-declare.md) (critério de julgamento), [RULE-DECLARE](0x103L-rule-declare.md) (afirmação), [COUNTER-DECLARE](0x104L-counter-declare.md) (contestação), [EXCEPT-DECLARE](0x105L-except-declare.md) (exceção) — [NODE](#node) |
| relação | [ATTACKS](0x108L-attacks.md) (ataque), [SUPERSEDES](0x109L-supersedes.md) (exclusão) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (cadeia de prioridade, layout indefinido) |
| execução | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| resultado | [VERDICT](0x118L-verdict.md) (resultado do julgamento: Pass·Review·Fail), [EVIDENCE](0x119L-evidence.md) (evidência do julgamento) — layout indefinido |

- Os nós e relações de texto-fonte, de seção e auxiliares são os códigos diretos `0x120L~0x134L` da família formato TOULMIN ([SOURCE e seções](#source와-구획), [TOULMIN](#toulmin-형식)).
- O resultado do julgamento fica em um documento diferente do alvo do julgamento. O documento de resultado importa o documento alvo e aponta para ele. Assim, o hash de conteúdo do documento alvo não muda mesmo após o julgamento.

Os Edges da família TOULMIN (códigos diretos `0x100L~0x11BL`; os registros auxiliares ficam na família formato TOULMIN `0x120L~0x134L`) escrevem grafos de julgamento e de execução com o modelo de argumentação de Toulmin. A declaração de afirmações, contestações e exceções, as relações de ataque e exclusão, as ligações de execução e os resultados do julgamento são todos Edges. Um documento TANGEUL (a linguagem de regras do motor toulmin) torna-se um documento GEUL. A extensão do arquivo é `.geul`, a mesma dos outros documentos.

O que este documento não define segue as regras comuns de [Edge](../edge/_index.md) e de [Registro e TAG WORD](../record.md).

## Metacognição e autorrevisão {#메타-인지와-자기-개정}

O TOULMIN é um Codec do GEUL para que o GEUL possa ter metacognição de si mesmo. Só se as regras de julgamento e execução também forem descritas em GEUL o TOULMIN pode tomá-las como objeto e corrigi-las sozinho. Por isso o TOULMIN não é um perfil de aplicação, e sim o núcleo da operação do GEUL, e fica no espaço de códigos diretos de Edge (`0x100L~0x11BL`).

- A autodescrição possibilita o autoaperfeiçoamento, mas corre o risco de erro circular. Se as regras julgam a sua própria revisão, também podem passar revisões que afrouxam o critério de julgamento (a taxa de aprovação sobe e a precisão real cai).
- O risco da circularidade é aceito, mas cortado pela estrutura.
  - **Núcleo fixo**: o significado do julgamento (Pass·Review·Fail, ataque·exclusão·prioridade, a avaliação de 3 valores de [Julgar sobre o desconhecido](#미상-위에서-판정하기) abaixo e U → Review) fica fixado nesta especificação. Não pode ser trocado por documentos TOULMIN. Está no mesmo lugar das regras incorporadas ao decodificador (camada 0 de [Endereço de publicação e lista de versões](../publishing.md#층)).
  - **Separação de edições**: a revisão do documento de regras v(n) é julgada pelas regras v(n−1) e por verificação externa. As regras não julgam a si mesmas. O resultado do julgamento fica em um documento diferente do alvo (o hash de conteúdo do alvo não muda).
  - **Histórico imutável**: as revisões se acumulam como novas versões (`PARENT`, hash de conteúdo, assinatura). Como as versões antigas permanecem, um erro circular pode ser encontrado depois e revertido. A rede de segurança da autorrevisão é o modelo de edições do GEUL ([Documento](../document.md#개정)).
  - **Critério externo**: mantém-se à parte um conjunto de casos de teste que o caminho de revisão não pode tocar. A adoção de uma revisão é confirmada pelo resultado desse conjunto.
- Teste de refutação: planta-se de propósito uma regra errada. Se o sistema a corrige e a pontuação do critério externo sobe, a automelhoria funciona. Se só a taxa de aprovação sobe e a pontuação do critério externo cai, é erro circular.

## Código {#코드}

Os registros TOULMIN usam um de três layouts. O layout é definido pelo Codec.

| Layout | Uso | Página |
|---|---|---|
| NODE | nós do grafo, como caso, regra, definição e ponto de entrada | [NODE](#node) |
| LINK | relações entre nós (ataque, exclusão, execução, definição) | [LINK](#link) |
| EXPR | expressão condicional (predicado) | [EXPR](0x101L-predicate-declare.md) |

Os registros de texto-fonte e de seção (SOURCE, TEXT, SECTION, CASE-BEGIN·CASE-END, PROSE) são definidos em [SOURCE e seções](#source와-구획).

### Código direto {#직접-코드}

| Codec | Nome | Layout | TANGEUL | Significado |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | declaração de caso. Grafo de julgamento que contém nós e relações |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | expressão condicional de Rules | declaração de predicado. Expressão de julgamento |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | item de Definitions | declaração de critério de julgamento (Backing). Os bits de role indicam o tipo de definição |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, nome da regra em Rules | declaração de afirmação (Warrant). Pode ser atacada |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | declaração de contestação. Ataca com conclusão própria. O Level padrão é Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | declaração de exceção. Ataca sem conclusão própria. O Level padrão é Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | relação de ataque. O julgamento do atacante reduz gradualmente o julgamento do alvo na medida da força do ataque (0~1, padrão 1) |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | relação de exclusão. Se o atacante estiver Active, o alvo é retirado deterministicamente da agregação. Uma cadeia (`A > B > C`) é escrita com um SUPERSEDES por par |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | cadeia de prioridade `A > B > C`. Abreviação de SUPERSEDES par a par. Apenas o código foi atribuído e o layout ainda não existe |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | composição de execução. Se o nó estiver Active, executa o caso subordinado (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | ação executada quando o nó está Active |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | ação executada uma única vez, mesmo com novas tentativas |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | ação compensatória de DO (saga). Se uma etapa posterior falhar, é executada em ordem inversa |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | ligação que apenas julga, sem efeitos colaterais |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | ponto de entrada externo. Executa ou julga um caso |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | ponto de entrada de evento ou periódico, sem chamada externa |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | resultado do julgamento de um nó ou registro. Resultado (Pass, Review, Fail), valor do julgamento, Activated, Excluded, Level. Apenas o código foi atribuído e o layout ainda não existe |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | evidência do julgamento. Posição, valor esperado, valor real (Fact). Apenas o código foi atribuído e o layout ainda não existe |
| `0x11CL~0x11FL` | Reserved | | | |

- Os códigos diretos que não constam na tabela (`0x106L`·`0x107L`, `0x10BL`~`0x10FL`, `0x117L`, `0x11AL`·`0x11BL`) são Reserved.
- Os grupos são: `0x100L~0x107L` declaração, `0x108L~0x10FL` relação, `0x110L~0x117L` execução, `0x118L~0x11FL` resultado (`0x11CL~0x11FL` são Reserved).
- O julgamento do documento inteiro cabe ao Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`), e o julgamento de nós e registros cabe ao `VERDICT` do TOULMIN (Edge `0x118L`). São Codecs distintos, de Kind diferente.

### Formato TOULMIN {#toulmin-형식}

Os nós e relações de texto-fonte, de seção e auxiliares ficam nos códigos diretos `0x120L~0x134L` da família formato Edge TOULMIN. Não há campos de Issuer nem de número de Codec, e o Payload vem logo após a TAG.

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). Os outros códigos ocupam a mesma posição
[TAG de extensão de Length]
Edge Id           registro Reference LOCAL
componentes       layout definido pelo formato
```

| Codec | Nome | Layout | Significado |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, WORD de largura do SPAN, Value UTF8 | texto-fonte original |
| `0x121L` | [TEXT](0x121L-text.md) | ID, Value UTF8 | nome ou cadeia de caracteres |
| `0x122L` | [SECTION](0x122L-section.md) | ID, código de seção de 1 WORD | início de seção |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (caso) | início do escopo de um caso |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (caso) | fim do escopo de um caso |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | parágrafo descritivo |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | referência de função |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | grupo de execução ordenado |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | caso → campo |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | item de definição → valor ou tipo |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | item de definição → campo |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | ponto de entrada → caso, execução |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | ponto de entrada → caso, julgamento |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | gatilho → caso |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | gatilho → caso (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | nó → identificador global |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | alias → caminho (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | nó → TEXT, notação de nome |

## Documento {#문서}

Um arquivo `.geul` é um DOC. Nenhum outro byte é colocado fora do DOC.

```
DOC-1WORD/2WORD/4WORD     comprimento total
  SPEC-VERSION            0x0001 (v1, inteiro sem Value incorporado)
  PROFILE                 Value UTF8 "tangeul-<major>.<minor>". Atualmente "tangeul-1.0"
  [DEFAULT-LANGUAGE]      Value LANGUAGE-BCP47-CODE. Localidade de autoria ("en", "ko")
BODY
  SOURCE                  texto-fonte original. Primeiro registro de BODY
  registros de sentença … na ordem de declaração do documento
END
```

- HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PROFILE](../meta/0x1C6L-profile.md), e opcionalmente [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md).
- O decodificador rejeita se SPEC-VERSION for diferente ou se o major de PROFILE for diferente. Se só o minor diferir, lê normalmente.
- O primeiro registro de BODY é SOURCE. Todo SPAN é um intervalo dentro desse texto-fonte.
- A ordem dos registros de sentença é igual à ordem de declaração do documento. A ordem de execução (disparo de `do` e `run`, compensação de `undo` em ordem inversa) depende dessa ordem. Em um documento TOULMIN, a ordem dos Edges tem significado (exceção à regra de ordem de [Layout de Edge](../edge/_index.md#레이아웃)).
- Todos os registros de BODY são Edges. Não há registros Value independentes. Os valores são incorporados ao Payload do Edge.
- A identidade do caso e a importação usam o Meta [DOC-ID](../meta/0x1C7L-doc-id.md) e [IMPORT-DOC](../meta/0x1E4L-import-doc.md) (Subject e See de TANGEUL).

## Campos comuns {#공통-필드}

| Campo | Largura | Descrição |
|---|---|---|
| ID | registro Reference LOCAL | Edge Id do registro. Primeiro elemento do Payload de todo registro |
| REF | registro Reference LOCAL | Edge Id que aponta para outro registro deste documento. `0` significa ausente |
| SPAN | largura definida por SOURCE × 2 | Intervalo dentro do texto-fonte original. Byte inicial, número de bytes |

- ID e REF são registros Reference [LOCAL](../reference/0x005L-local.md) incorporados (`0000 0000 0101 LLLL` + o ID na menor largura possível). A largura é determinada pelo Length desse registro e não é declarada por documento.
- REF `0` (LOCAL `0`) significa "ausente". É uma regra de Codec que usa LOCAL `0` como ausente ([LOCAL](../reference/0x005L-local.md)).
- Os Edge Ids são atribuídos a partir de 1 e não se repetem dentro do documento. `0` não é usado como Edge Id, pois é o "ausente" de REF.
- Como outros registros referenciam nós adiante, os nós recebem seus números primeiro, na ordem de declaração do documento. Os demais registros (SOURCE, TEXT, LINK, FUNC, registros de seção) recebem números do codificador a partir do número seguinte aos dos nós.
- O decodificador verifica apenas que o Edge Id não é 0 e que não há repetição. A ordem de atribuição não é usada na interpretação.
- Nós e relações são apontados por Edge Id.
- Um Value incorporado é o registro Value inteiro, incluindo a TAG WORD. O comprimento é definido por essa TAG.

## Valores numéricos {#수치}

- O valor de julgamento (−1~1), o Qualifier (0~1) e a força do ataque (0~1) são Values [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md). Não há um formato de ponto fixo separado.
- O codificador remove os zeros finais do coeficiente. 0.8 é `C=8, E=−1`. O decodificador aceita até 4 casas decimais.
- O portão de confiança (por exemplo, `at least 75%`) é escrito com um operador de comparação de 1 WORD e um Value [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) de percentual (`E=0`) ([LINK](#link) F_GATE).
- A força do ataque é o campo F_FORCE de ATTACKS ([LINK](#공격-세기)). Rejeita-se se estiver fora do intervalo.

## Eixos da declaração de nó {#노드-선언의-축}

- A declaração de nó (RULE, COUNTER, EXCEPT-DECLARE) tem papel (afirmação, contestação, exceção), Qualifier (0~1) e Level (Unset, Fail, Review). O papel é carregado pelo Codec e pelo role do cabeçalho de NODE, o Qualifier por F_QUAL e o Level pelo level do cabeçalho ([NODE](#node)).
- A intensidade (Strict, Defeasible, Defeater) é um eixo separado do papel. A posição da intensidade ainda não foi definida.
- A força do ataque (Force) não é do nó, e sim um valor da aresta ATTACKS ([LINK](#공격-세기) F_FORCE). É um eixo diferente da intensidade.

## Julgar sobre o desconhecido {#미상-위에서-판정하기}

Quando o grafo de julgamento recebe fatos GEUL como entrada, os três conceitos de [marcador de posição](../slot-marker.md) (não escrito, desconhecido, inexistente) são avaliados de modo diferente. A avaliação dos operadores de comparação de [EXPR](0x101L-predicate-declare.md) é a seguinte.

| Entrada | `is empty` | `is not empty` | `equals` / `is in` / comparação de tamanho |
|---|---|---|---|
| valor v | falso | verdadeiro | avaliado com v |
| NO-VALUE (inexistente) | **verdadeiro** | falso | falso |
| UNKNOWN-VALUE (desconhecido) | falso | **verdadeiro** | **indeterminado (U)** |
| ABSENT (não escrito) / enunciado ausente | U (mundo aberto) | U | U |

- A lógica usa os 3 valores fortes de Kleene. `NOT U = U`, `falso AND U = falso`, `verdadeiro OR U = verdadeiro`. Nas demais combinações, o U permanece U.
- `EXISTS any` é verdadeiro se pelo menos um elemento for verdadeiro. Se não houver verdadeiro e houver U, é U; se todos forem falsos, é falso.
- **Se o predicado for U, o julgamento daquele nó não é Pass nem Fail, e sim Review.** Quando não se sabe, passa-se a uma pessoa (ou à etapa seguinte).
- Para tratar ABSENT como empty em vez de U, o lado da entrada deve **declarar** um mundo fechado (injetado como SPEC de critério de julgamento, por exemplo: "a entrada deste caso está completa"). Sem declaração, é U.
- Esta tabela e a correspondência U → Review são o significado do julgamento, portanto um **núcleo fixo**. Não podem ser trocadas por documentos TOULMIN.
- Exemplo: na regra "contar apenas as fronteiras ainda válidas" (`P582 is empty`), se P582 = UNKNOWN-VALUE o resultado é falso e a fronteira é excluída; se P582 = NO-VALUE o resultado é verdadeiro e é incluída; se P582 não existe, é U e vai para Review.

## Resultado do julgamento {#판정-결과}

- O resultado do julgamento (`VERDICT`, `EVIDENCE`) fica em um documento diferente do alvo do julgamento. O documento de resultado importa o documento alvo com [IMPORT-DOC](../meta/0x1E4L-import-doc.md) e aponta para ele com [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md). Assim, o hash de conteúdo do documento alvo não muda mesmo após o julgamento.
- O julgamento do documento inteiro é o Meta `VERDICT`, e o julgamento de nós e registros é o `VERDICT` do TOULMIN.
- As regras que escolhem a edição aplicável de uma revisão (disposições transitórias, escolha entre a lei vigente à época do ato e a lei nova), bem como interpretações e precedentes, também são usadas como regras de julgamento ([Documento](../document.md#개정)).

## Problemas em aberto {#열린-문제}

- O layout de SUPERSEDE-CHAIN (`0x10AL`), VERDICT (`0x118L`) e EVIDENCE (`0x119L`). Se o método atual, de escrever um SUPERSEDES por par, basta para a cadeia.
- A posição da intensidade do nó (Strict, Defeasible, Defeater).
- Um ATTACKS com força 1 escrita e um ATTACKS sem ela têm o mesmo julgamento, mas bytes diferentes. A igualdade de julgamento deve ser comparada pelo valor interpretado, não pelos bytes.
- O número de nós, o número de rótulos e o índice de rótulo dentro de EXPR são de 1 WORD, e o número de filhos é de 13 bits. Os limites superiores são fixos.
- O layout de PROVENANCE (origem e premissas da regra).
- Se um nome entre crases deve ser um [LABEL](../edge/0x0A4L-label.md) ou [BIND](../edge/0x0A3L-bind.md) de enunciado, em vez de TEXT + LABEL (`0x134L`).
- A tabela de valores de código de predicate e mode de Claim e de VerbCode de FuncRef.
- Se a declaração de mundo fechado (ler ABSENT como empty) é feita pelo critério de julgamento (SPEC) ou por caso.
- O [documento de especificação do Codec](../codec-spec.md) dos Codecs TOULMIN. Os campos condicionais de NODE e LINK e a largura do SPAN definida por SOURCE são layouts que não podem ser declarados com FIELD.

## Páginas relacionadas {#관련-페이지}

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE e seções](#source와-구획)
- [Documento](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE é o layout que escreve os nós do grafo de julgamento e de execução TOULMIN. O tipo de nó é definido pelo Codec, e o cabeçalho de 1 WORD determina o papel, o Level, a forma da Claim e os campos condicionais.

### Codec {#codec}

| Codec | Nome | TANGEUL | Nó |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | caso |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | item de Definitions (`means`, `has`) | critério de julgamento (Backing). role indica o tipo de definição |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | afirmação (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | contestação (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | exceção (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | ponto de entrada externo |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | ponto de entrada de evento ou periódico |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | espaço de nomes do documento |
| `0x127L` | [FUNC](0x127L-func.md) | referência de função | função externa (ex.: `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | campo obrigatório |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | alias de um pacote importado |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` lista ordenada | grupo de execução ordenado |

`0x126L~0x12AL` são códigos diretos da família formato Edge TOULMIN ([TOULMIN](#toulmin-형식)).

### Layout {#레이아웃}

```
ID               registro Reference LOCAL (Edge Id)
cabeçalho 1 WORD role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | tipo de object 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 0 se não houver) + VerbCode 1 WORD
[F_QUAL]         Value SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF (caso)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      Value SIGNED-DECIMAL. Valor inicial do julgamento
[F_WITH]         contagem (Value UNSIGNED-INTEGER) + REF(TEXT) × contagem
[F_GROUNDS]      contagem (Value UNSIGNED-INTEGER) + REF(TEXT) × contagem
SPAN             largura definida por SOURCE × 2 (byte inicial, número de bytes)
```

#### WORD de cabeçalho {#헤더-word}

| Bits | Campo | Valor |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | existe uma lista de fundamentos |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | tipo de object | Forma do object da Claim. 0 REF, 1 Value UNSIGNED-INTEGER, 2 SPAN |
| 6–0 | flags | tabela abaixo |

| Bit | flag | Significado |
|---|---|---|
| b0 | F_FUNC | existe o campo FuncRef |
| b1 | F_QUAL | existe o campo Qualifier |
| b2 | F_CHECK | existe o campo do caso alvo de `checking` |
| b3 | F_CLAIM | existe o campo Claim |
| b4 | F_VERDICT | existe o campo de valor inicial do julgamento |
| b5 | F_STRIKE | declaração riscada (cancelada). Não há campo |
| b6 | F_WITH | existe o campo da lista de critérios |

- Os campos condicionais são colocados na ordem das flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Um campo cuja flag está desligada não ocupa espaço.
- Rejeita-se se uma flag estiver ligada e o campo não existir. A posição após ler os campos em sequência, depois do SPAN, deve coincidir exatamente com o fim do registro.

### Campos {#필드}

| Campo | Descrição |
|---|---|
| FuncRef | Posição de função. REF é o registro ALIAS que importou essa função, e é `0` se a função for deste documento. VerbCode é um código de 1 WORD ainda não atribuído (`0x0000` é permitido). A grafia original da função é escrita separadamente com TEXT + [LABEL](#link) |
| Qualifier | Confiança do nó (0~1) |
| caso | F_CHECK: o caso que este nó apenas julga (`checking c`) |
| Claim | A proposição que o nó contém. REF de subject, predicate 1 WORD, object, mode 1 WORD. A forma do object é determinada pelo tipo de object do cabeçalho |
| valor do julgamento | Valor inicial do julgamento (−1~1) |
| F_WITH | Critérios no momento da declaração (`기준으로 하는`, "tendo como critério"). Lista de REF de registros TEXT |
| F_GROUNDS | Nomes de fatos externos resolvidos no momento da avaliação (`근거로 하는`, "tendo como fundamento"). Lista de REF de registros TEXT |
| SPAN | Intervalo do texto-fonte de onde veio esta declaração |

- A notação do valor de julgamento e do Qualifier segue as regras numéricas de [TOULMIN](#수치).
- A contagem das listas é um registro Value [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) incorporado.
- A forma padrão de uma Claim descritiva tem subject e predicate `0` e object como SPAN (tipo de object 2). Fica fixada na grafia do texto original.

### Interpretação e validade {#해석과-유효성}

- role deve ser igual ao do Codec em RULE, COUNTER e EXCEPT-DECLARE (0 general, 1 counter, 2 except). Em SPEC-DECLARE, é o tipo de definição. Nos demais Codecs, é 0.
- Se level for 0 (Unset), usa-se o padrão do motor: Fail em COUNTER-DECLARE e Review em EXCEPT-DECLARE.
- A regra de função do hospedeiro de TANGEUL `tangl:규칙` (`쓰는 규칙이다`, "é uma regra que usa") é escrita como um NODE RULE-DECLARE fora do caso. A função é F_FUNC, o critério é F_WITH e o fundamento é F_GROUNDS. Somente as regras de expressão condicional têm um [PREDICATE-DECLARE](0x101L-predicate-declare.md) antes.
- Os bits Reserved (13–12) devem ser 0. Rejeita-se se um bit Reserved estiver ligado ou se role não corresponder ao Codec.

### Páginas relacionadas {#관련-페이지-1}

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE e seções](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK é o layout que escreve as relações entre nós no grafo TOULMIN. O tipo de relação é definido pelo Codec.

### Codec {#codec-1}

| Codec | Nome | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | regra → regra. Reduz gradualmente o julgamento na medida da força do ataque |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | regra → regra. Se Active, retira o alvo da agregação |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | regra → caso |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | regra → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | regra → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | regra → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | regra → caso. Julgamento sem efeitos colaterais |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | caso → campo |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | item de definição → valor ou tipo |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | item de definição → campo |
| `0x12EL` | [RUNS](0x12EL-runs.md) | ponto de entrada `run c` | ponto de entrada → caso (execução) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | ponto de entrada `check c` | ponto de entrada → caso (julgamento) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | gatilho `run c` | gatilho → caso |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | gatilho → caso |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | nó → identificador global |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | alias → caminho (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | nome entre crases | nó → TEXT. Notação de nome |

### Layout {#레이아웃-1}

```
ID               registro Reference LOCAL (Edge Id)
src              REF
dst              REF. Em DO, DO-ONCE e UNDO, FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         operador 1 WORD (2 bits superiores) + Value UNSIGNED-DECIMAL (percentual)
[F_FORCE]        Value SIGNED-DECIMAL. Força do ataque (0~1). Somente em ATTACKS
SPAN             largura definida por SOURCE × 2
```

| flag | Significado |
|---|---|
| b0 F_ONCE | executa uma única vez (o `once` de UNDO) |
| b1 F_GATE | existe o campo de portão de confiança |
| b2 F_STRIKE | relação riscada (cancelada) |
| b3 F_ORDERED | pertence a uma lista ordenada `1.` |
| b4 F_FORCE | existe o campo de força do ataque. Somente em ATTACKS |

| Operador de portão | Significado |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Os campos condicionais são colocados na ordem das flags (F_GATE, F_FORCE). Um campo cuja flag está desligada não ocupa espaço.

### Força do ataque {#공격-세기}

A força do ataque (F_FORCE) é usada somente por [ATTACKS](0x108L-attacks.md#공격-세기). A fórmula de julgamento, a notação e os exemplos estão naquela página.

### Interpretação e validade {#해석과-유효성-1}

- REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](#공통-필드)).
- A forma de dst é definida pelo Codec. DO, DO-ONCE e UNDO usam FuncRef (REF(ALIAS, 0 se não houver) + VerbCode 1 WORD, [NODE](#필드)); LABEL e IMPORTED-FROM usam o REF de um registro TEXT; os demais usam o REF de um nó.
- `do … once` é representado pelo Codec DO-ONCE. F_ONCE não é usado em flags de DO-ONCE (se estiver ligado, é rejeitado). O `once` de UNDO é escrito com F_ONCE.
- O operador de portão ocupa os 2 bits superiores do WORD de operador, e os 14 bits restantes são 0. O percentual é um Value UNSIGNED-DECIMAL com `E=0`, de 0 a 100.
- Os bits b5~b15 de flags são Reserved e devem ser 0. Caso contrário, rejeita-se.
- F_FORCE é usado somente em ATTACKS. Rejeita-se se estiver ligado em outros Codecs (SUPERSEDES, ligações de execução e de julgamento, relações do formato TOULMIN).
- Rejeita-se se a força do ataque não for um Value SIGNED-DECIMAL, estiver fora de 0~1 ou não puder ser representada exatamente com 4 casas decimais.
- Uma cadeia SUPERSEDES `A > B > C` é escrita com um SUPERSEDES por par.

### Páginas relacionadas {#관련-페이지-2}

- [TOULMIN](_index.md), [NODE](#node), [SOURCE e seções](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE e seções {#source와-구획}

São os registros que escrevem o texto-fonte e as seções de um documento TOULMIN. Todos são códigos diretos `0x120L~0x125L` da família formato Edge TOULMIN ([TOULMIN](#toulmin-형식)). O Payload vem logo após a TAG, sem campos de Issuer e de número de Codec.

### Formato {#형식}

| Codec | Nome | Layout |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, WORD de largura do SPAN, Value UTF8 |
| `0x121L` | [TEXT](0x121L-text.md) | ID, Value UTF8 |
| `0x122L` | [SECTION](0x122L-section.md) | ID, código de seção de 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (caso) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (caso) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID é o Edge Id, e REF é o Edge Id de um registro deste documento (campos comuns de [TOULMIN](#공통-필드)).
- Value UTF8 é um registro Value [UTF8-TEXT](../value/0x072L-utf8-text.md). Contém os bytes como estão.

### Páginas por formato {#형식별-쪽}

O layout, a tabela de códigos de seção e a interpretação têm uma página para cada formato.

- [SOURCE](0x120L-source.md): texto-fonte original. É o primeiro registro de BODY e define a largura do SPAN
- [TEXT](0x121L-text.md): nome ou cadeia de caracteres
- [SECTION](0x122L-section.md): início de seção e código de seção
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md): escopo de um caso
- [PROSE](0x125L-prose.md): parágrafo descritivo

### Páginas relacionadas {#관련-페이지-3}

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
