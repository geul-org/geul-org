---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE é o Edge de enunciado que contém uma proposição (Predicate, Subject, Object) e o seu grau (rank)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `TRIPLE` (BIND `TRIPLE` do documento de especificação) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| Documento de especificação | `0x00000000/codecs/0x00000AA0/` (alvo do DECLARE `0AA0`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 10 |
| Kind | Edge · família: enunciado, grupo: proposição |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Proposição na ordem Predicate, Subject, Object, e rank. Object é um valor ou um marcador UNKNOWN-VALUE·NO-VALUE. O significado é o conjunto de todos os QUALIFIERs que apontam para o seu Edge Id |
| Lado Hugo | `edge/triple.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference) |  |
| 2 | `subject` | #3 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference) |  |
| 3 | `object` | #4 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference), `060F` seção 3 inteira (curinga, Value), `080F` seção 4 inteira (curinga, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |
| 4 | `rank` | #5 | valor bruto 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal, `0x0001` preferred, `0x0002` deprecated |

TRIPLE é o Edge de enunciado que contém uma proposição (Predicate, Subject, Object) e o seu grau (rank). Codec `0x0AAL`.

As condições que qualificam a proposição (instante de início e fim, âmbito de aplicação etc.) são anexadas por [QUALIFIER](0x0ABL-qualifier.md) que aponta para o Edge Id do TRIPLE. A origem (references do Wikidata) é anexada pelo Edge de fundamento [SOURCE](0x0C0L-source.md) que aponta para o Edge Id do TRIPLE.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Predicate         registro Reference (WIKIDATA-PID etc.)
Subject           registro Reference
Object            registro Reference ou Value, ou marcador de posição 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| Código | Nome | Significado |
|---|---|---|
| `0` | normal | padrão |
| `1` | preferred | valor atual, o mais autorizado |
| `2` | deprecated | valor julgado errado ou desatualizado, mas mantido como registro |

- É igual ao statement rank do Wikidata. O valor representativo (truthy do Wikidata) é, entre os de mesmo Subject e Predicate, o preferred se existir, e caso contrário o normal.
- Fontes que não atribuem rank usam `0` (normal).
- Qualquer outro código é invalid.

## Interpretação e validade {#해석과-유효성}

- Predicate e Subject são, cada um, exatamente um registro Reference completo.
- Object é exatamente um registro Reference ou Value completo, ou 1 WORD de [marcador de posição](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) ou `0x0020` (NO-VALUE). ABSENT (`0x0000`) não é aceito. Object não é um campo opcional.
- Depois de ler Object, deve restar exatamente 1 WORD (Rank).
- O documento de especificação do geul.org põe no campo de valor bruto Rank o [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER (`0620`) e o [ENUM](0x0BDL-enum.md) 0·1·2. No campo Object põe os CODECs `000F`·`020F`·`040F` (qualquer Reference), `060F`·`080F` (qualquer Value), `0010` (UNKNOWN-VALUE) e `0020` (NO-VALUE). Nos campos Predicate e Subject põe os CODECs `000F`·`020F`·`040F` (qualquer Reference). Por serem curingas, não aceitam marcadores de posição.
- **O significado de um TRIPLE é o conjunto de todos os QUALIFIERs que apontam para o seu Edge Id no mesmo documento.** Quem lê reúne os QUALIFIERs antes de interpretar o TRIPLE. Um TRIPLE lido sem QUALIFIER pode ser uma proposição à qual falta a qualificação (por exemplo, "chefe do executivo" sem a qualificação temporal).

## Desconhecido e inexistente {#알-수-없음과-없음}

Um marcador de posição no lugar de Object não é um valor, mas uma asserção sobre a proposição.

| Object | Significado | Lógica |
|---|---|---|
| valor v | um dos valores do Predicate de Subject é v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | há um valor. Não se sabe qual (`somevalue` do Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | não há valor (`novalue` do Wikidata) | `¬∃x. P(s, x)` |
| sem TRIPLE | não afirma nada (mundo aberto) | |

- **Lê-se dentro da condição qualificadora.** O âmbito de `∃` e `¬∃` é definido pelo QUALIFIER que aponta para esse TRIPLE. Quando um QUALIFIER é anexado, fecha-se apenas nesse âmbito. "Entre 1811 e 1816 não havia banco central" escreve-se anexando QUALIFIERs P580 e P582 a um TRIPLE NO-VALUE. Não contradiz um TRIPLE de valor de outro período para o mesmo Predicate.
- **O rank se aplica da mesma forma.** Ao escolher o valor representativo (truthy), os TRIPLEs UNKNOWN-VALUE e NO-VALUE também são candidatos. Se houver preferred, só ele permanece.
- **UNKNOWN-VALUEs não são iguais entre si.** UNKNOWN-VALUE não é igual nem diferente de nenhum valor (o resultado da comparação é indeterminado), e dois UNKNOWN-VALUEs também não são vistos como o mesmo valor. Cada ocorrência é uma quantificação existencial independente. Por isso dois TRIPLEs UNKNOWN-VALUE com bytes iguais não são duplicados e não se fundem (pode haver dois filhos ou um só).
- Se NO-VALUE e um TRIPLE de valor (ou UNKNOWN-VALUE) coexistirem para o mesmo Subject, Predicate e rank sem que as condições qualificadoras os distingam, há contradição. O verificador emite aviso. Não rejeita (é um estado que também existe no Wikidata).
- Um valor que não foi possível converter (a origem tem valor) não é escrito como UNKNOWN-VALUE.

## Exemplo (não normativo) {#예시-비규범}

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORDs, `LLLL=1001`. A TAG é `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (Estados Unidos) P1304 (banco central) NO-VALUE, normal. Entre 1811 e 1816 não havia banco central (os QUALIFIERs P580·P582 estão no exemplo de [QUALIFIER](0x0ABL-qualifier.md)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORDs, `LLLL=1000`. A TAG é `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "Sem filhos (P40)" é `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Problemas em aberto {#열린-문제}

- scope (contexto da afirmação: mundo, ponto de vista): será definido quando surgir um uso.
- Forma abreviada que dobra TRIPLE e QUALIFIER em um só registro: depois que existir a declaração de campos repetidos (problemas em aberto de [DECLARE](0x0BBL-declare.md)).

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [marcador de posição](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000AA0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
