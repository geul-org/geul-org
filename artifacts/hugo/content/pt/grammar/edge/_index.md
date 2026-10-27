---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge é um registro que descreve unindo Reference, Value e outros Edges. O primeiro componente é sempre o Edge Id, e os 2 bits superiores do Codec são a família (descritivo, fundamento, execução, TOULMIN)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge é um registro que descreve unindo outros registros como componentes. Descrições como "Q42 é uma pessoa" e "o nome de Q42 em inglês é Douglas Adams" são, cada uma, um Edge.

## Layout

```
TAG WORD          0001 0LLL LCCC CCCC
[TAG estendida de Length]
[TAG estendida de Codec]  no formato Issuer
Edge Id           registro Reference LOCAL
Componentes       na ordem definida pelo Codec
```

- `LLLL` é o número total de WORDs, incluindo a TAG WORD, menos 1. O decodificador pula para o registro seguinte só pelo Length, sem conhecer o Codec.
- **O primeiro componente é sempre o Edge Id (Reference LOCAL).** Por ser uma Reference LOCAL (`0088` + ID, Quantifier `000`), o Edge Id pode ser lido mesmo sem conhecer o codec.
- Cada componente encontra a sua fronteira pelo próprio Length. A posição em que termina a leitura do último componente deve coincidir exatamente com o fim do Edge.
- A composição (Payload) dos componentes é definida pelo documento de cada Codec de Edge.
- Nos Codecs com subformato (WORLD, TIMELINE, SCENE), 1 WORD de TAG por Codec indica o subformato.
- A ordem entre registros Edge não tem significado (exceto quando o Codec determina outra coisa; ex.: documentos [TOULMIN](/pt/grammar/edge/toulmin/)).
- Um Edge de outro Edge é apontado pelo Edge Id. Os Edges deste documento são apontados por LOCAL e os Edges de outros documentos por Reference de indicação (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Famílias

| 2 bits superiores | Família | Código direto | Função |
|---|---|---|---|
| `00` | descritivo | `0x00`~`0x1F` | compõe conteúdo sobre o mundo e os eventos |
| `01` | fundamento | `0x20`~`0x3F` | de onde vieram os registros e o documento ([SOURCE](/pt/grammar/edge/source/)) |
| `10` | execução | `0x40`~`0x5F` | estrutura de programa executável (AST) |
| `11` | [TOULMIN](/pt/grammar/edge/toulmin/) | `0x60`~`0x7B` | grafo de argumentação: afirmações, contestações, exceções, relações de ataque, execução, resultado do julgamento |

## Edges descritivos

| Codec | Nome | Componentes |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/pt/grammar/edge/reference-node/) | Vínculo direcional em que o Subject (Reference) indica o Object |
| `0x01` | [SAME-NODE](/pt/grammar/edge/same-node/) | Duas References indicam o mesmo alvo |
| `0x02` | [DIFFERENT-NODE](/pt/grammar/edge/different-node/) | Duas References indicam alvos diferentes |
| `0x03` | [BIND](/pt/grammar/edge/bind/) | Liga ao Subject um nome para máquina (UTF8-TEXT) |
| `0x04` | [LABEL](/pt/grammar/edge/label/) | Nome do Subject por idioma (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/pt/grammar/edge/alias/) | Outro nome do Subject. O layout é igual ao de LABEL |
| `0x06` | [DESCRIPTION](/pt/grammar/edge/description/) | Descrição do Subject por idioma. O layout é igual ao de LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | Descrição verbal |
| `0x0A` | [TRIPLE](/pt/grammar/edge/triple/) | Uma proposição (Predicate, Subject, Object) e o rank |
| `0x0B` | [QUALIFIER](/pt/grammar/edge/qualifier/) | Uma condição que restringe a proposição de outro Edge |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | Visão de mundo, ordem de eventos, estrutura de cena |
| `0x18`~`0x1A` | [PUBLICATION](/pt/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | Publicação, recomendação de descontinuação e exclusão de versões de documentos ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#lista-de-versões)) |
| `0x1B`~`0x1E` | [DECLARE](/pt/grammar/edge/declare/) / [FIELD](/pt/grammar/edge/field/) / [ENUM](/pt/grammar/edge/enum/) / [CODEC](/pt/grammar/edge/codec/) | Vocabulário para escrever a especificação de Codec ([Documento de especificação de Codec](/pt/grammar/codec-spec/)) |

- A forma `-SHORT` e a forma geral formam um par par/ímpar (VERB-SHORT `0x08` / VERB `0x09`). LABEL recebe o idioma num registro de idioma dentro do Object (UTF8-LANGUAGE-TEXT), por isso usa um único `0x04`.
- PUBLICATION, DEPRECATION e TOMBSTONE são usados pelo documento da lista de versões. Como a lista de versões deve ser lida sem codebook, eles são incorporados ao decodificador (camada 0 em [Endereço de publicação e lista de versões](/pt/grammar/publishing/#camadas)).
- DECLARE, FIELD, ENUM e CODEC são o vocabulário para escrever a especificação de Codec. Como o documento de especificação deve ser lido sem codebook, o layout é incorporado ao decodificador (camada 0). Cada documento de especificação de Codec escrito com esse vocabulário é um documento comum.

### TRIPLE

Detalhes: [TRIPLE](/pt/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[TAG estendida de Length]
Edge Id           Reference LOCAL
Predicate         Reference (propriedade do Wikidata etc.)
Subject           Reference
Object            Reference ou Value
Rank              1 WORD
```

| Rank | Nome | Significado |
|---|---|---|
| `0` | normal | padrão |
| `1` | preferred | valor atual, o mais autorizado |
| `2` | deprecated | valor julgado errado ou obsoleto, mas mantido como registro |

- O Rank é igual ao statement rank do Wikidata. Fontes que não atribuem rank usam `0`.
- **O significado de um TRIPLE é a soma de todos os QUALIFIERs que apontam para o seu Edge Id.** Quem lê reúne os QUALIFIERs antes de interpretar o TRIPLE.

Exemplo: Q42 — P31 (instance of) — Q5 (pessoa), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

Detalhes: [QUALIFIER](/pt/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[TAG estendida de Length]
Edge Id           Reference LOCAL
Property          Reference
Target            Reference LOCAL (Edge Id do Edge restringido)
Value             Reference ou Value
```

- O QUALIFIER faz parte da proposição. Não é uma afirmação separada sobre a proposição: restringe as condições em que a proposição é verdadeira (instante de início e fim, âmbito de aplicação etc.).
- Uma afirmação separada sobre a proposição (quem a afirmou etc.) escreve-se com um TRIPLE.
- O Target é um Edge do mesmo documento. A ordem dos QUALIFIERs de um mesmo Target é a ordem dentro do documento.

Exemplo: Q42 — P69 (educated at) — Q691283, início (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

Detalhes: [LABEL](/pt/grammar/edge/label/), [ALIAS](/pt/grammar/edge/alias/), [DESCRIPTION](/pt/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[TAG estendida de Length]
Edge Id           Reference LOCAL
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- O nome e o idioma vão juntos num único Object (UTF8-LANGUAGE-TEXT).
- Para um mesmo Subject e idioma há no máximo um LABEL. Outros nomes escrevem-se com ALIAS.
- Um nome para máquina, sem idioma, escreve-se com BIND. O LABEL deve ter idioma.

### BIND

Detalhes: [BIND](/pt/grammar/edge/bind/)

- Liga ao Subject um nome que a máquina compara (UTF8-TEXT). Não tem idioma e não é normalizado. Só é o mesmo nome se os bytes forem iguais.
- O âmbito do nome é o documento que contém o BIND. Em um documento, o mesmo nome não se liga a Subjects diferentes.
- Os outros registros apontam por LOCAL ID, não por nome. O nome serve para casar com o exterior (funções do host, entrada de endereços, pessoas).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

Detalhes: [SAME-NODE](/pt/grammar/edge/same-node/), [DIFFERENT-NODE](/pt/grammar/edge/different-node/), [REFERENCE-NODE](/pt/grammar/edge/reference-node/)

- SAME-NODE é a identidade: duas References apontam para o mesmo alvo. É reflexiva, simétrica e transitiva.
- DIFFERENT-NODE é a não identidade: duas References são alvos diferentes.
- REFERENCE-NODE é um vínculo direcional que define, por meio do Object, o que é o Subject (Reference). Não é uma afirmação de identidade. Exemplo: define a URI para a qual aponta um nó LOCAL.

## Edges de fundamento

Anexam um fundamento a um registro individual do BODY ou ao documento inteiro (HEAD). O único código direto da família de fundamento é [SOURCE](/pt/grammar/edge/source/) (`0x20`).

| Codec | Nome | Componentes |
|---|---|---|
| `0x20` | [SOURCE](/pt/grammar/edge/source/) | Target (Edge Id do Edge do BODY ao qual se anexa o fundamento; no HEAD, `0` = documento inteiro), Origin (Reference da fonte, ABSENT ou UNKNOWN-VALUE) |
| `0x21`~`0x3F` | Reserved | |

- As propriedades da própria fonte (URL, título, autor, data de publicação …) escrevem-se com um TRIPLE que tem a fonte como Subject; as propriedades da citação (data de consulta, posição dentro da fonte …) escrevem-se com QUALIFIERs que têm o Edge Id do SOURCE como Target.
- A fonte do documento inteiro escreve-se no HEAD com um SOURCE de Target `0`, e os QUALIFIERs que o têm como Target também ficam no HEAD. Esses dois são os únicos Edges que podem estar no HEAD, e o Edge Id usa um único espaço de números para HEAD e BODY ([Origem do documento inteiro](/pt/grammar/edge/source/#origem-do-documento-inteiro)).
- Outros fundamentos (faixa do texto original, autor, grau de confiança, período de vigência por artigo, registros antigos) escrevem-se com QUALIFIERs, e a versão em que um registro entrou pela primeira vez calcula-se a partir do histórico de versões ([SOURCE](/pt/grammar/edge/source/#outras-formas-de-expressar-o-fundamento)).
- O resultado do julgamento por registro fica a cargo do `VERDICT` do TOULMIN.

### SOURCE

Detalhes: [SOURCE](/pt/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[TAG estendida de Length]
Edge Id           Reference LOCAL
Target            Reference LOCAL (Edge Id do Edge do BODY ao qual se anexa o fundamento; no HEAD, 0 = documento inteiro)
Origin            Reference ou marcador de posição 0x0000 ABSENT · 0x0001 UNKNOWN-VALUE
```

Exemplo: fonte do TRIPLE `#178` de Q42 P19: Britannica (Q5375741), e nela o identificador P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edges de execução

Estruturas de programa não presas a uma linguagem de programação específica. Os componentes são apontados pelos LOCAL IDs deste documento.

| Grupo | Codec |
|---|---|
| declaração | FUNCTION-DECLARE, TYPE-DECLARE |
| expressão | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| instrução | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| erro | RAISE, TRY |

- Não é um formato que contém tal e qual o código de uma linguagem externa. O código de linguagens externas fica em formatos Issuer.
- Os componentes são apontados pelo LOCAL ID (REF) deste documento. Na posição de expressão, coloca-se um Edge de expressão ou um símbolo. REF `0` significa ausência.
- A expressão produz um valor; a instrução não. Uma expressão pode ficar na posição de instrução de um BLOCK (o valor é descartado).
- O `for` estilo C escreve-se como BLOCK (inicialização, WHILE), e `else if` como um IF na posição do falso.
- O símbolo é um LOCAL ID e o nome é ligado por BIND. Os outros registros apontam o símbolo por LOCAL ID, não por nome. Mesmo com o mesmo nome, LOCAL IDs diferentes são símbolos diferentes.
- O que o símbolo é (variável, parâmetro, função, tipo) é determinado pelo registro que aponta para o símbolo. Um símbolo sem definição no documento é fornecido de fora (pelo host); se for o alvo de um CALL, é uma função do host.

Questões em aberto: códigos de operadores, representação de tipos, layout do Payload de cada Codec.

## Edges TOULMIN

Detalhes: [TOULMIN](/pt/grammar/edge/toulmin/)

Escreve grafos de julgamento e execução com o modelo de argumentação de Toulmin. É a família central para que o GEUL descreva as próprias regras em GEUL e as corrija sozinho.

| Grupo | Codec |
|---|---|
| declaração | CASE-DECLARE (caso), [PREDICATE-DECLARE](/pt/grammar/edge/toulmin/expr/) (predicado), SPEC-DECLARE (critério de julgamento), RULE-DECLARE (afirmação), COUNTER-DECLARE (contestação), EXCEPT-DECLARE (exceção) — [NODE](/pt/grammar/edge/toulmin/node/) |
| relação | ATTACKS (ataque), SUPERSEDES (exclusão) — [LINK](/pt/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN (cadeia de prioridade, layout indefinido) |
| execução | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/pt/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/pt/grammar/edge/toulmin/node/) |
| resultado | VERDICT (resultado do julgamento: Pass, Review, Fail), EVIDENCE (evidência do julgamento) — layout indefinido |

- O texto original, as seções e os nós e relações auxiliares são formatos ISSUER do Issuer GEUL (`0xC000`~`0xC029`) ([SOURCE e seções](/pt/grammar/edge/toulmin/source/)).
- O resultado do julgamento fica em um documento diferente do alvo julgado. O documento de resultado importa o documento alvo e o aponta. Assim, julgar não altera o hash de conteúdo do documento alvo.

## Edges de formato Issuer

Um Issuer pode definir e usar os seus formatos de Edge (Codec `0x7C`~`0x7F`). Os códigos diretos `0x7C`~`0x7F` estão dentro da faixa TOULMIN, mas são códigos ISSUER comuns, e a família é determinada pelos 2 bits superiores do número de formato.

| Issuer | Número de formato | Nome | Família |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/pt/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/pt/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/pt/grammar/edge/toulmin/link/) | TOULMIN |
