---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Os Edges TOULMIN (Codec 0x60~0x7B) escrevem grafos de julgamento e execução com o modelo de argumentação de Toulmin. Esta página define as regras do documento TOULMIN, os campos comuns, a tabela de códigos, as regras numéricas e o núcleo fixo da autorrevisão."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Os Edges da família TOULMIN (2 bits superiores do Codec `11`, códigos diretos `0x60`~`0x7B`) escrevem grafos de julgamento e execução com o modelo de argumentação de Toulmin. A declaração de afirmações, contestações e exceções, as relações de ataque e exclusão, as ligações de execução e os resultados do julgamento são, todos, Edges. Um documento TANGEUL (a linguagem de regras do motor toulmin) torna-se um documento GEUL. A extensão do arquivo é `.geul`, a mesma dos outros documentos.

O que esta página não define segue as regras comuns de [Edge](/pt/grammar/edge/) e de [Registro e TAG WORD](/pt/grammar/record/).

## Metacognição e autorrevisão

O TOULMIN é um Codec do GEUL para que o GEUL possa ter metacognição de si mesmo. Só se as regras de julgamento e execução também forem descritas em GEUL o TOULMIN pode tomá-las como objeto e corrigi-las sozinho. Por isso o TOULMIN não é um perfil de aplicação, e sim o núcleo da operação do GEUL, e fica no espaço de códigos diretos de Edge (`0x60`~`0x7B`).

- A autodescrição possibilita o autoaperfeiçoamento, mas corre o risco de erro circular. Se as regras julgam a sua própria revisão, também podem passar revisões que afrouxam o critério de julgamento (a taxa de aprovação sobe e a precisão real cai).
- O risco da circularidade é aceito, mas cortado pela estrutura.
  - **Núcleo fixo**: o significado do julgamento (Pass, Review, Fail, ataque, exclusão, prioridade, a avaliação de 3 valores de [Julgar sobre o desconhecido](#julgar-sobre-o-desconhecido) e U → Review) fica fixado nesta especificação. Não pode ser trocado por documentos TOULMIN. Está no mesmo lugar das regras incorporadas ao decodificador (camada 0 de [Endereço de publicação e lista de versões](/pt/grammar/publishing/#camadas)).
  - **Separação de edições**: a revisão do documento de regras v(n) é julgada pelas regras v(n−1) e por verificação externa. As regras não julgam a si mesmas. O resultado do julgamento fica em um documento diferente do alvo (o hash de conteúdo do alvo não muda).
  - **Histórico imutável**: as revisões se acumulam em novas versões (`PARENT`, hash de conteúdo, assinatura). Como as versões antigas permanecem, é possível achar depois um erro circular e revertê-lo. A rede de segurança da autorrevisão é o modelo de edições do GEUL ([Documento](/pt/grammar/document/#revisão)).
  - **Critério externo**: mantém-se à parte um conjunto de casos de teste em que o caminho de revisão não pode mexer. A adoção de uma revisão é confirmada pelo resultado desse conjunto.
- Teste de refutação: planta-se de propósito uma regra errada. Se o sistema a corrigir e a nota do critério externo subir, o autoaperfeiçoamento funciona. Se só a taxa de aprovação subir e a nota do critério externo cair, é um erro circular.

## Códigos

Um registro TOULMIN usa um de três layouts. O layout é determinado pelo Codec (ou pelo número de formato).

| Layout | Uso | Página |
|---|---|---|
| NODE | nós do grafo, como caso, regra, definição e ponto de entrada | [NODE](/pt/grammar/edge/toulmin/node/) |
| LINK | relações entre nós (ataque, exclusão, execução, definição) | [LINK](/pt/grammar/edge/toulmin/link/) |
| EXPR | expressão condicional (predicado) | [EXPR](/pt/grammar/edge/toulmin/expr/) |

Os registros de texto original e de seção (SOURCE, TEXT, SECTION, CASE-BEGIN·CASE-END, PROSE) são definidos por [SOURCE e seções](/pt/grammar/edge/toulmin/source/).

### Códigos diretos

| Codec | Nome | Layout | TANGEUL | Significado |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/pt/grammar/edge/toulmin/node/) | NODE | `in case of` | Declaração de caso. Grafo de julgamento com nós e relações |
| `0x61` | [PREDICATE-DECLARE](/pt/grammar/edge/toulmin/expr/) | EXPR | expressão condicional de Rules | Declaração de predicado. Expressão de julgamento |
| `0x62` | [SPEC-DECLARE](/pt/grammar/edge/toulmin/node/) | NODE | item de Definitions | Declaração de critério de julgamento (Backing). O bit role é o tipo de definição |
| `0x63` | [RULE-DECLARE](/pt/grammar/edge/toulmin/node/) | NODE | general rule, nome de regra de Rules | Declaração de afirmação (Warrant). Pode ser atacada |
| `0x64` | [COUNTER-DECLARE](/pt/grammar/edge/toulmin/node/) | NODE | counter rule | Declaração de contestação. Ataca com conclusão própria. O Level padrão é Fail |
| `0x65` | [EXCEPT-DECLARE](/pt/grammar/edge/toulmin/node/) | NODE | except rule | Declaração de exceção. Ataca sem conclusão própria. O Level padrão é Review |
| `0x68` | [ATTACKS](/pt/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | Relação de ataque. O julgamento do atacante reduz gradualmente o julgamento do alvo conforme a intensidade do ataque (0~1, padrão 1) |
| `0x69` | [SUPERSEDES](/pt/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | Relação de exclusão. Se o atacante está Active, retira o alvo da agregação de forma determinística. A cadeia (`A > B > C`) escreve-se um par por vez |
| `0x6A` | SUPERSEDE-CHAIN | — | | Cadeia de prioridade `A > B > C`. Abreviação de SUPERSEDES par a par. Só o código foi atribuído; o layout ainda não existe |
| `0x70` | [RUN](/pt/grammar/edge/toulmin/link/) | LINK | `run c when n` | Composição de execução. Se o nó está Active, executa o caso inferior (DAG) |
| `0x71` | [DO](/pt/grammar/edge/toulmin/link/) | LINK | `do fn when n` | Ação executada se o nó está Active |
| `0x72` | [DO-ONCE](/pt/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | Ação executada uma única vez, mesmo com novas tentativas |
| `0x73` | [UNDO](/pt/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | Ação de compensação de DO (saga). Se uma etapa posterior falha, é executada em ordem inversa |
| `0x74` | [CHECKING](/pt/grammar/edge/toulmin/link/) | LINK | `checking c` | Ligação que só julga, sem efeitos colaterais |
| `0x75` | [ENTRY](/pt/grammar/edge/toulmin/node/) | NODE | `provides x` | Ponto de entrada externo. Executa ou julga o caso |
| `0x76` | [TRIGGER](/pt/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | Ponto de entrada de evento ou periódico, sem chamada externa |
| `0x78` | VERDICT | — | | Resultado do julgamento de um nó ou registro. Resultado (Pass, Review, Fail), valor do julgamento, Activated, Excluded, Level. Só o código foi atribuído; o layout ainda não existe |
| `0x79` | EVIDENCE | — | | Evidência do julgamento. Posição, valor esperado, valor real (Fact). Só o código foi atribuído; o layout ainda não existe |
| `0x7C`~`0x7F` | ISSUER-* | | | Formato definido por um Issuer. Formatos ISSUER abaixo |

- Os códigos diretos que não estão na tabela (`0x66`, `0x67`, `0x6B`~`0x6F`, `0x77`, `0x7A`, `0x7B`) são reservados.
- Os 2 bits superiores dos 5 bits inferiores do Codec formam o grupo: `00` declaração, `01` relação, `10` execução, `11` resultado (`0x7C`~`0x7F` são ISSUER).
- O julgamento do documento inteiro fica com o Meta [VERDICT](/pt/grammar/meta/verification/verdict/) (`0x44`), e o julgamento de nós e registros com o `VERDICT` do TOULMIN (Edge `0x78`). Os dois são Codecs distintos, de Kinds diferentes.

### Formatos ISSUER

Os registros TOULMIN para os quais faltam códigos diretos ficam sob `ISSUER-1WORD` (`0x7C`), com número de formato sob o Issuer `0x0000` (GEUL). O número de formato é da família TOULMIN (`0xC000`~`0xFFFF`, 2 bits superiores `11`).

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[TAG estendida de Length]
Issuer            0x0000
Número de formato 0xC000~0xC029
Edge Id           registro Reference LOCAL
Componentes       layout definido pelo formato
```

| Número de formato | Nome | Layout | Significado |
|---|---|---|---|
| `0xC000` | [SOURCE](/pt/grammar/edge/toulmin/source/) | ID, WORD de largura SPAN, Value UTF8 | Texto original de autoria |
| `0xC001` | [TEXT](/pt/grammar/edge/toulmin/source/) | ID, Value UTF8 | Nomes e cadeias de caracteres |
| `0xC002` | [SECTION](/pt/grammar/edge/toulmin/source/) | ID, código de seção de 1 WORD | Início de seção |
| `0xC003` | [CASE-BEGIN](/pt/grammar/edge/toulmin/source/) | ID, REF (caso) | Início do âmbito do caso |
| `0xC004` | [CASE-END](/pt/grammar/edge/toulmin/source/) | ID, REF (caso) | Fim do âmbito do caso |
| `0xC005` | [PROSE](/pt/grammar/edge/toulmin/source/) | ID, SPAN | Parágrafo descritivo |
| `0xC010` | [NAMESPACE](/pt/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/pt/grammar/edge/toulmin/node/) | NODE | Referência de função |
| `0xC012` | [FIELD](/pt/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/pt/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/pt/grammar/edge/toulmin/node/) | NODE | Conjunto de execução ordenado |
| `0xC020` | [REQUIRES](/pt/grammar/edge/toulmin/link/) | LINK | caso → campo |
| `0xC021` | [MEANS](/pt/grammar/edge/toulmin/link/) | LINK | item de definição → valor ou tipo |
| `0xC022` | [HAS](/pt/grammar/edge/toulmin/link/) | LINK | item de definição → campo |
| `0xC023` | [RUNS](/pt/grammar/edge/toulmin/link/) | LINK | ponto de entrada → caso, execução |
| `0xC024` | [EVALUATES](/pt/grammar/edge/toulmin/link/) | LINK | ponto de entrada → caso, julgamento |
| `0xC025` | [TRIGGERS](/pt/grammar/edge/toulmin/link/) | LINK | gatilho → caso |
| `0xC026` | [UNTIL](/pt/grammar/edge/toulmin/link/) | LINK | gatilho → caso (`every … until`) |
| `0xC027` | [SAME-AS](/pt/grammar/edge/toulmin/link/) | LINK | nó → identificador global |
| `0xC028` | [IMPORTED-FROM](/pt/grammar/edge/toulmin/link/) | LINK | alias → caminho (TEXT) |
| `0xC029` | [LABEL](/pt/grammar/edge/toulmin/link/) | LINK | nó → TEXT, notação do nome |

- O espaço de números de formato é separado por Kind. O formato GEUL `0xC000` de Value (OPAQUE-BYTES-EVEN) e o `0xC000` de Edge (SOURCE) são formatos diferentes.
- Os números de formato só são acrescentados. Um número atribuído não se reutiliza para outro formato.

## Documento

Um arquivo `.geul` é um DOC. Não há outros bytes fora do DOC.

```
DOC-1WORD/2WORD/4WORD     comprimento total
  SPEC-VERSION            0x0001 (v1, inteiro sem Value embutido)
  PROFILE                 Value UTF8 "tangeul-<major>.<minor>". Atualmente "tangeul-1.0"
  [DEFAULT-LANGUAGE]      Value LANGUAGE-BCP47-CODE. Locale de redação ("en", "ko")
BODY
  SOURCE                  texto original de autoria. Primeiro registro do BODY
  registros de sentença …  na ordem de declaração do documento
END
```

- HEAD: [SPEC-VERSION](/pt/grammar/meta/declaration/spec-version/), [PROFILE](/pt/grammar/meta/declaration/profile/) e, opcional, [DEFAULT-LANGUAGE](/pt/grammar/meta/declaration/default-language/).
- O decodificador rejeita se SPEC-VERSION for diferente ou se o major do PROFILE for diferente. Lê mesmo que o minor seja diferente.
- O primeiro registro do BODY é o SOURCE. Todo SPAN é uma faixa dentro desse texto original.
- A ordem dos registros de sentença é igual à ordem de declaração do documento. A ordem de execução (disparo de `do` e `run`, compensação de `undo` em ordem inversa) depende dessa ordem. Num documento TOULMIN a ordem dos Edges tem significado (exceção à regra de ordem de [Edge](/pt/grammar/edge/)).
- Todos os registros do BODY são Edges. Não se põem registros Value independentes. Os valores são embutidos no Payload do Edge.
- A identidade do caso e as importações usam os Meta [DOC-ID](/pt/grammar/meta/declaration/doc-id/) e [IMPORT-DOC](/pt/grammar/meta/import/import-doc/) (Subject e See do TANGEUL).

## Campos comuns

| Campo | Largura | Descrição |
|---|---|---|
| ID | registro Reference LOCAL | Edge Id do registro. Primeiro elemento do Payload de todos os registros |
| REF | registro Reference LOCAL | Edge Id que aponta para outro registro deste documento. `0` significa ausência |
| SPAN | largura definida por SOURCE × 2 | Faixa dentro do texto original de autoria. Byte inicial, número de bytes |

- ID e REF são registros Reference [LOCAL](/pt/grammar/reference/local/) embutidos (`0000 0LLL L000 1000` + ID na menor largura). A largura é determinada pelo Length desse registro e não se declara por documento.
- REF `0` (LOCAL `0`) é "ausência". É uma regra de Codec que usa LOCAL `0` como ausência ([LOCAL](/pt/grammar/reference/local/)).
- Os Edge Ids são atribuídos a partir de 1 e não se repetem no documento. `0` é a "ausência" do REF e por isso não se usa como Edge Id.
- Como os nós são referenciados à frente por outros registros, recebem primeiro os números, na ordem de declaração do documento. Os demais registros (SOURCE, TEXT, LINK, FUNC, registros de seção) recebem do codificador os números seguintes aos dos nós.
- O decodificador só confere que o Edge Id não é 0 e que não há repetição. A ordem de atribuição não é usada na interpretação.
- Nós e relações são apontados por Edge Id.
- O Value embutido é o registro Value tal qual, incluindo a TAG WORD. O comprimento é determinado por essa TAG.

## Números

- O valor de julgamento (−1~1), o Qualifier (0~1) e a intensidade do ataque (0~1) são Values [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/). Não se mantém um formato de ponto fixo à parte.
- O codificador apaga os zeros finais do coeficiente. 0,8 é `C=8, E=−1`. O decodificador aceita até 4 casas decimais.
- O portão de grau de certeza (por exemplo, `at least 75%`) escreve-se com 1 WORD de operador de comparação e um Value de porcentagem [UNSIGNED-DECIMAL](/pt/grammar/value/decimal/unsigned-decimal/) (`E=0`) ([LINK](/pt/grammar/edge/toulmin/link/) F_GATE).
- A intensidade do ataque é o campo F_FORCE de ATTACKS ([LINK](/pt/grammar/edge/toulmin/link/#intensidade-do-ataque)). Fora do intervalo, rejeita-se.

## Eixos da declaração de nó

- A declaração de nó (RULE, COUNTER e EXCEPT-DECLARE) tem papel (afirmação, contestação, exceção), Qualifier (0~1) e Level (Unset, Fail, Review). O papel é dado pelo Codec e pelo role do cabeçalho NODE, o Qualifier por F_QUAL e o Level pelo level do cabeçalho ([NODE](/pt/grammar/edge/toulmin/node/)).
- A força (Strict, Defeasible, Defeater) é um eixo separado do papel. A colocação da força ainda não foi definida.
- A intensidade do ataque (Force) não é um valor do nó, e sim da aresta ATTACKS ([LINK](/pt/grammar/edge/toulmin/link/#intensidade-do-ataque) F_FORCE). É um eixo diferente da força.

## Julgar sobre o desconhecido

Quando o grafo de julgamento recebe fatos GEUL como entrada, os três conceitos do [marcador de posição](/pt/grammar/reference/slot-marker/) (não informado, desconhecido, sem valor) são avaliados de modos diferentes. A avaliação dos operadores de comparação de [EXPR](/pt/grammar/edge/toulmin/expr/) é a seguinte.

| Entrada | `is empty` | `is not empty` | `equals` / `is in` / comparação de tamanho |
|---|---|---|---|
| valor v | falso | verdadeiro | avalia com v |
| NO-VALUE (sem valor) | **verdadeiro** | falso | falso |
| UNKNOWN-VALUE (desconhecido) | falso | **verdadeiro** | **indefinido (U)** |
| ABSENT (não informado) / sem descrição | U (mundo aberto) | U | U |

- A lógica usa a lógica forte de 3 valores de Kleene. `NOT U = U`, `falso AND U = falso`, `verdadeiro OR U = verdadeiro`. Nas demais combinações, U é U.
- `EXISTS any` é verdadeiro se pelo menos um elemento for verdadeiro. Se não houver verdadeiro e houver U, é U; se todos forem falsos, é falso.
- **Se o predicado for U, o julgamento desse nó não é Pass nem Fail, e sim Review.** O que não se sabe é passado a uma pessoa (ou à etapa seguinte).
- Para ler ABSENT como empty, e não como U, o lado da entrada precisa **declarar** o mundo fechado (injetado como critério de julgamento SPEC, por exemplo "a entrada deste caso é completa"). Sem a declaração, é U.
- Esta tabela e a correspondência U → Review são o significado do julgamento e, portanto, o **núcleo fixo**. Não podem ser trocadas por documentos TOULMIN.
- Exemplo: a regra "só conta as fronteiras ainda válidas" (`P582 is empty`) exclui, por ser falsa, se P582 = UNKNOWN-VALUE; inclui, por ser verdadeira, se P582 = NO-VALUE; e envia para Review, por ser U, se P582 não existir.

## Resultado do julgamento

- O resultado do julgamento (`VERDICT`, `EVIDENCE`) fica em um documento diferente do alvo julgado. O documento de resultado importa o documento alvo com [IMPORT-DOC](/pt/grammar/meta/import/import-doc/) e o aponta com [EXTERNAL-POINTER-*](/pt/grammar/reference/external-pointer/). Assim, julgar não altera o hash de conteúdo do documento alvo.
- O julgamento do documento inteiro é o Meta `VERDICT`, e o de nós e registros é o `VERDICT` do TOULMIN.
- As regras que escolhem a edição a aplicar de uma revisão (disposições transitórias, lei vigente à época do ato e escolha da lei nova), bem como interpretações e jurisprudência, também se escrevem como regras de julgamento ([Documento](/pt/grammar/document/#revisão)).

## Questões em aberto

- Layout de SUPERSEDE-CHAIN (`0x6A`), VERDICT (`0x78`) e EVIDENCE (`0x79`). Se o método atual, de escrever SUPERSEDES par a par, basta para as cadeias.
- Colocação da força do nó (Strict, Defeasible, Defeater).
- Um ATTACKS que escreve intensidade 1 e um que não escreve intensidade dão o mesmo julgamento, mas diferem nos bytes. Se dois julgamentos são iguais deve ser comparado pelos valores decodificados, não pelos bytes.
- O número de nós, o número de rótulos e o índice de rótulo dentro de EXPR ocupam 1 WORD, e o número de filhos tem 13 bits. Os limites são fixos.
- Layout de PROVENANCE (origem e premissas da regra).
- Se os nomes entre crases ficam como [LABEL](/pt/grammar/edge/label/) e [BIND](/pt/grammar/edge/bind/) descritivos, em vez de TEXT + LABEL (`0xC029`).
- Tabela de valores de código de predicate e mode do Claim e de VerbCode do FuncRef.
- Se a declaração de mundo fechado (ler ABSENT como empty) é feita por critério de julgamento (SPEC) ou por caso.
- [Documento de especificação de Codec](/pt/grammar/codec-spec/) dos Codecs TOULMIN. Os campos condicionais de NODE e LINK e a largura de SPAN definida por SOURCE são layouts que não se podem declarar com FIELD.

## Páginas relacionadas

- [NODE](/pt/grammar/edge/toulmin/node/), [LINK](/pt/grammar/edge/toulmin/link/), [EXPR](/pt/grammar/edge/toulmin/expr/), [SOURCE e seções](/pt/grammar/edge/toulmin/source/)
- [Edge](/pt/grammar/edge/), [Documento](/pt/grammar/document/), [PROFILE](/pt/grammar/meta/declaration/profile/)
