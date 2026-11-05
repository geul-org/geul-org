---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER é o Edge de enunciado que anexa uma condição que qualifica a proposição contida em outro Edge (principalmente TRIPLE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `QUALIFIER` (BIND `QUALIFIER` do documento de especificação) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| Documento de especificação | `0x00000000/codecs/0x00000AB0/` (alvo do DECLARE `0AB0`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 11 |
| Kind | Edge · família: enunciado, grupo: proposição |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Uma condição que qualifica a proposição de outro Edge. Property, Target (Edge Id), Value (valor ou marcador UNKNOWN-VALUE·NO-VALUE). É parte da proposição |
| Lado Hugo | `edge/qualifier.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `target` | #3 | registro | `0050` LOCAL |  |
| 3 | `value` | #4 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference), `060F` seção 3 inteira (curinga, Value), `080F` seção 4 inteira (curinga, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |

QUALIFIER é o Edge de enunciado que anexa uma condição que qualifica a proposição contida em outro Edge (principalmente [TRIPLE](0x0AAL-triple.md)). Codec `0x0ABL`.

É igual a um qualifier (snak) do Wikidata: uma propriedade e um valor.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Property          registro Reference (WIKIDATA-PID etc.)
Target            registro Reference LOCAL (Edge Id do Edge que é qualificado)
Value             registro Reference ou Value, ou marcador de posição 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- A ordem dos componentes é igual à de TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). O decodificador lê pelo mesmo caminho. Os papéis são definidos pelo Codec.

## Interpretação e validade {#해석과-유효성}

- Property e Target são, cada um, exatamente um registro Reference completo, e Target é uma Reference LOCAL. O documento de especificação do geul.org põe em Target o [CODEC](0x0BEL-codec.md) LOCAL (`0050`). Value é exatamente um registro Reference ou Value completo, ou 1 WORD de [marcador de posição](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) ou `0x0020` (NO-VALUE). O documento de especificação põe em Value os CODECs `000F`, `020F`, `040F` (qualquer Reference), `060F`, `080F` (qualquer Value), `0010` e `0020`. ABSENT (`0x0000`) não é aceito. Property e Target não aceitam marcadores de posição. O cursor, depois de ler Value, deve coincidir com o fim do Edge.
- Target é um Edge Id dentro do mesmo documento. O QUALIFIER fica no mesmo documento do Edge que qualifica.
- Se Target for o [SOURCE](0x0C0L-source.md#문서-전체의-출처) do HEAD (a origem do documento inteiro), o QUALIFIER também fica no HEAD, depois desse SOURCE. Os demais QUALIFIERs ficam no BODY. Se um QUALIFIER que tem o SOURCE do HEAD como Target estiver no BODY, é invalid.
- Target pode ser outro Edge que não TRIPLE. Um QUALIFIER anexado a [SOURCE](0x0C0L-source.md) qualifica o ato de citação (data de consulta, posição dentro da origem etc.). O significado de SOURCE também é o conjunto de todos os QUALIFIERs que apontam para ele.
- **QUALIFIER é parte da proposição.** Não é uma afirmação separada sobre a proposição, mas qualifica as condições em que a proposição é verdadeira. O significado do TRIPLE alvo é o conjunto de todos os QUALIFIERs que apontam para ele.
  - A origem da proposição é escrita como [SOURCE](0x0C0L-source.md). As propriedades do nó da origem (título, autor etc.) são escritas como TRIPLE com a origem como Subject.
- Pode haver vários QUALIFIERs de mesma Property para o mesmo Target. A ordem dos QUALIFIERs com o mesmo Target é a ordem no documento (uma exceção em que a ordem dos Edges tem significado).

## Desconhecido e inexistente {#알-수-없음과-없음}

Se o Value de um QUALIFIER é um marcador de posição, o sentido dessa qualificação muda. Tome-se como exemplo o instante de fim (P582).

| Anexado ao TRIPLE alvo | Significado | A proposição continua válida agora? |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | terminou em 1974 | não |
| `QUALIFIER P582 #n UNKNOWN` | terminou. Não se sabe quando (`somevalue` do Wikidata) | não |
| `QUALIFIER P582 #n NONE` | afirma que não terminou (`novalue` do Wikidata) | sim |
| sem QUALIFIER P582 | não se sabe se terminou (mundo aberto) | não se sabe |

- Se o `somevalue` e o `novalue` de um qualifier do Wikidata forem descartados, a proposição se amplia. Um TRIPLE de fronteira que perdeu o somevalue do instante de fim é lido como "fronteira ainda válida". Por isso, na conversão, eles são transpostos como marcadores.
- UNKNOWN-VALUEs não são vistos como o mesmo valor entre si. O resultado da comparação é indeterminado.

## Exemplo (não normativo) {#예시-비규범}

Q42 P69 (educated at) Q691283 (St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORDs. Value é o [EDTF](../value/0x06EL-edtf.md) `"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Fronteira (P47) entre Q30 (Estados Unidos) e Q34266 (Império Russo), com instante de fim desconhecido. Edge Id `2060`·`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111` (seção 5): Edge, Codec `0x0ABL`, 8 WORDs. TAG 1 + Edge Id 2 + Property P582 (`0191 0246`) 2 + Target #2060 (`0051 080C`) 2 + marcador 1.

Anexa-se um período ao TRIPLE NO-VALUE `#3161` de banco central (P1304) de Q30. Só não houve entre 1811 e 1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [marcador de posição](../slot-marker.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000AB0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
