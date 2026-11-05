---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge é um registro que descreve algo reunindo outros registros como componentes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge é um registro que descreve algo reunindo outros registros como componentes. Enunciados como "Q42 é uma pessoa" ou "O nome em inglês de Q42 é Douglas Adams" são, cada um, um único Edge.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      seção 5~13 (0x0A0L~0x1BFL)
[TAG estendida de Length]
[TAG estendida de Codec]  no formato Issuer
Edge Id           registro Reference LOCAL
componentes       na ordem definida pelo Codec
```

- `LLLL` é o número total de WORDs, incluindo a TAG WORD, menos 1. O decodificador salta para o registro seguinte só com o Length, sem conhecer o Codec.
- **O primeiro componente é sempre o Edge Id (Reference LOCAL).** Como é uma Reference LOCAL (`0051` + ID, Identified `0x005L`), o Edge Id pode ser lido mesmo sem conhecer o codec.
- Cada componente encontra a sua fronteira pelo próprio Length. A posição após a leitura do último componente deve coincidir exatamente com o fim do Edge.
- A composição (Payload) dos componentes é definida pelo documento de cada Codec de Edge.
- Nos Codecs com subformato (WORLD, TIMELINE, SCENE), 1 WORD de TAG específica do Codec indica o subformato.
- A ordem entre registros Edge não tem significado (exceto quando o Codec a define à parte; por exemplo, o documento [TOULMIN](../toulmin/_index.md)).
- Outro Edge é apontado pelo Edge Id. Os Edges deste documento são apontados como LOCAL, e os Edges de outros documentos por Reference de apontamento (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Famílias {#계열}

A zona de Edge é `0x0A0L~0x1BFL`. A família de um código direto é `(código − 0xA0) >> 5` (o código são os três primeiros dígitos do TAG ID). Cada família tem 32 posições e equivale à seção `w >> 9` menos 5. Edge ocupa as seções 5~13.

| Seção | Família | Código direto | Função |
|---|---|---|---|
| 5 | enunciado | `0x0A0L~0x0BFL` | compõe o conteúdo sobre o mundo e os acontecimentos |
| 6 | fundamento | `0x0C0L~0x0DFL` | de onde vieram registros e documentos ([SOURCE](0x0C0L-source.md)) |
| 7 | execução | `0x0E0L~0x0FFL` | estrutura de programa executável (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | grafo de argumentação: afirmação, contestação, exceção, relação de ataque, execução, resultado do julgamento |
| 9 | formato [TOULMIN](../toulmin/_index.md) | `0x120L~0x134L` | texto original, divisões, nós auxiliares e relações do documento TOULMIN |

- Os códigos diretos atribuídos são estas cinco famílias. `0x11CL~0x11FL` é Reserved, e `0x135L~0x1BCL` é Reserved (as seções 10~12 são inteiramente Reserved).
- `0x1BDL~0x1BFL` (as três últimas posições da seção 13) é EDGE-ISSUER (ver Edge de formato Issuer abaixo). O formato Issuer não tem regra de família.

## Edge de enunciado {#서술-edge}

| Codec | Nome | Componentes |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | binding direcional em que Subject (Reference) aponta para Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | duas References apontam para o mesmo referente |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | duas References apontam para referentes diferentes |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | liga a Subject um nome para máquina (UTF8-TEXT) |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | nome de Subject por idioma (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | outro nome de Subject. O layout é igual ao de LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | descrição de Subject por idioma. O layout é igual ao de LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | enunciado com verbo |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | uma proposição (Predicate, Subject, Object) e rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | uma condição que qualifica a proposição de outro Edge |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | cosmovisão, ordem dos acontecimentos, estrutura de cena |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | publicação, recomendação de descontinuação e remoção de versões de documento ([endereço de publicação e lista de versões](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | vocabulário para escrever especificações de Codec ([documento de especificação de Codec](../codec-spec.md)) |

- `-SHORT` e a forma geral formam um par par/ímpar (VERB-SHORT `0x0A8L`/VERB `0x0A9L`). LABEL recebe o idioma como registro de idioma dentro do Object (UTF8-LANGUAGE-TEXT), por isso usa apenas `0x0A4L`.
- PUBLICATION, DEPRECATION e TOMBSTONE são usados pelo documento de lista de versões. Como a lista de versões deve poder ser lida sem codebook, eles são embutidos no decodificador (camada 0 em [endereço de publicação e lista de versões](../publishing.md#층)).
- DECLARE, FIELD, ENUM e CODEC são o vocabulário para escrever especificações de Codec. Como o documento de especificação deve poder ser lido sem codebook, o layout é embutido no decodificador (camada 0). Cada documento de especificação de Codec escrito com esse vocabulário é um documento comum.

### TRIPLE {#triple}

Detalhes: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
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
| `2` | deprecated | valor julgado errado ou desatualizado, mas mantido como registro |

- Rank é igual ao statement rank do Wikidata. Fontes que não atribuem rank usam `0`.
- **O significado de um TRIPLE é o conjunto de todos os QUALIFIERs que apontam para o seu Edge Id.** Quem lê reúne os QUALIFIERs antes de interpretar o TRIPLE.

Exemplo: Q42 — P31 (instance of) — Q5 (pessoa), normal, Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

Detalhes: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[TAG estendida de Length]
Edge Id           Reference LOCAL
Property          Reference
Target            Reference LOCAL (Edge Id do Edge que é qualificado)
Value             Reference ou Value
```

- QUALIFIER é parte da proposição. Não é uma afirmação separada sobre a proposição, mas qualifica as condições em que a proposição é verdadeira (instante de início e fim, âmbito de aplicação etc.).
- Uma afirmação separada sobre a proposição (quem a afirmou etc.) é escrita como TRIPLE.
- Target é um Edge do mesmo documento. A ordem dos QUALIFIERs com o mesmo Target é a ordem no documento.

Exemplo: Q42 — P69 (educated at) — Q691283, início (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

Detalhes: [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[TAG estendida de Length]
Edge Id           Reference LOCAL
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- O nome e o idioma ficam juntos em um único Object (UTF8-LANGUAGE-TEXT).
- Para o mesmo Subject e idioma há no máximo um LABEL. Outros nomes são escritos como ALIAS.
- Um nome para máquina, sem idioma, é escrito como BIND. LABEL exige idioma.

### BIND {#bind}

Detalhes: [BIND](0x0A3L-bind.md)

- Liga a Subject um nome (UTF8-TEXT) com o qual a máquina faz correspondência. Não tem idioma e não é normalizado. Só é o mesmo nome se os bytes forem iguais.
- O âmbito do nome é o documento que contém o BIND. Em um documento, o mesmo nome não é ligado a Subjects diferentes.
- Outros registros apontam por LOCAL ID, não pelo nome. O nome serve para fazer a correspondência com o exterior (funções do host, entrada de endereços, pessoas).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

Detalhes: [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE é a identidade em que duas References apontam para o mesmo referente. É reflexiva, simétrica e transitiva.
- DIFFERENT-NODE é a não identidade em que duas References são referentes diferentes.
- REFERENCE-NODE é um binding direcional que define, por meio de Object, o que Subject (Reference) é. Não é uma afirmação de identidade. Exemplo: define o URI para o qual um nó LOCAL aponta.

## Edge de fundamento {#근거-edge}

Anexa fundamento a um registro individual do BODY ou ao documento inteiro (HEAD). O código direto da família de fundamento é apenas [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | Nome | Componentes |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (Edge Id do Edge do BODY ao qual se anexa o fundamento; no HEAD, `0` = documento inteiro), Origin (Reference da origem, ABSENT ou UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- As propriedades da própria origem (URL, título, autor, data de publicação …) são escritas como TRIPLE com a origem como Subject; as propriedades da citação (data de consulta, posição dentro da origem …) são escritas como QUALIFIER com o Edge Id do SOURCE como Target.
- A origem do documento inteiro é escrita no HEAD como SOURCE com Target `0`, e o QUALIFIER que o tem como Target também fica no HEAD. Estes dois são os únicos Edges que aparecem no HEAD, e o Edge Id usa um único espaço de numeração para HEAD e BODY ([proveniência do documento inteiro](0x0C0L-source.md#문서-전체의-출처)).
- Outros fundamentos (intervalo do texto original, agente que o produziu, confiabilidade, período de vigência por artigo, registro antigo) são escritos como QUALIFIER, e a versão em que entrou pela primeira vez é calculada a partir do histórico de versões ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- O resultado do julgamento por registro fica a cargo do `VERDICT` de TOULMIN.

### SOURCE {#source}

Detalhes: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[TAG estendida de Length]
Edge Id           Reference LOCAL
Target            Reference LOCAL (Edge Id do Edge do BODY ao qual se anexa o fundamento; no HEAD, 0 = documento inteiro)
Origin            Reference ou marcador de posição 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

Exemplo: origem Britannica (Q5375741) do TRIPLE Q42 P19 `#178`, identificador P1417 dentro dela

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Edge de execução {#실행-edge}

É uma estrutura de programa não ligada a nenhuma linguagem de programação específica. Os componentes são apontados por LOCAL ID deste documento.

| Grupo | Codec |
|---|---|
| declaração | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| expressão | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| instrução | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| erro | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- Não é um formato que guarda código de outra linguagem tal como está. O código de outra linguagem é posto no formato Issuer.
- Os componentes são apontados por LOCAL ID (REF) deste documento. No lugar de uma expressão põe-se um Edge de expressão ou um símbolo. REF `0` significa ausência.
- Uma expressão produz um valor; uma instrução não. Uma expressão pode ocupar o lugar de uma instrução em BLOCK (o valor é descartado).
- O `for` de estilo C é escrito como BLOCK (inicialização, WHILE), e `else if` como um IF no lugar do falso.
- Um símbolo é um LOCAL ID, e o nome é ligado por BIND. Outros registros apontam para o símbolo por LOCAL ID, não pelo nome. Mesmo com o mesmo nome, LOCAL IDs diferentes são símbolos diferentes.
- O que o símbolo é (variável, parâmetro, função, tipo) é determinado pelo registro que aponta para ele. Um símbolo sem definição no documento é fornecido pelo exterior (host); se for o alvo de um CALL, é uma função do host.

Problemas em aberto: códigos de operador, representação de tipos, layout do Payload de cada Codec.

## Edge TOULMIN {#toulmin-edge}

Escreve grafos de julgamento e de execução com o modelo de argumentação de Toulmin. Os códigos diretos são `0x100L~0x11BL`, e os registros auxiliares são da família de formato TOULMIN `0x120L~0x134L`. Detalhes: [TOULMIN](../toulmin/_index.md)

## Edge de formato Issuer {#issuer-형식-edge}

O Issuer pode definir e usar os seus próprios formatos de Edge ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)·[4WORD](0x1BEL-edge-issuer-4word.md)·[16WORD](0x1BFL-edge-issuer-16word.md), Codec `0x1BDL`~`0x1BFL`). São as três últimas posições da zona de Edge. A TAG estendida de Codec contém 2 WORDs: Issuer e número de codec. O Edge Id é o primeiro elemento do Payload que se segue (TAG, Issuer, número de codec, Edge Id, restante do Payload). O número de codec é definido pelo Issuer e não tem regra de família. Independentemente do Kind, não se repete dentro de `codecs/` desse Issuer. O documento do codec fica em `codecs/` desse Issuer, sob o número de codec do registro ([endereço de publicação e lista de versões](../publishing.md)).

- Atualmente não há formato Edge ISSUER registrado.
