---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER é o Edge descritivo que anexa uma condição que restringe a proposição de outro Edge (em geral um TRIPLE) (Codec 0x0B). No Value, em vez de um valor, pode-se usar desconhecido (UNKNOWN-VALUE) ou sem valor (NO-VALUE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER é o Edge descritivo que anexa uma condição que restringe a proposição contida em outro Edge (em geral um [TRIPLE](/pt/grammar/edge/triple/)). Codec `0x0B`.

É igual a um qualifier (snak) do Wikidata: uma propriedade e um valor.

## Layout

```
TAG WORD          0001 0LLL L000 1011
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Property          registro Reference (WIKIDATA-PID etc.)
Target            registro Reference LOCAL (Edge Id do Edge restringido)
Value             registro Reference ou Value, ou marcador de posição 0x0001 UNKNOWN-VALUE · 0x0002 NO-VALUE
```

- A ordem dos componentes é a mesma do TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). O decodificador lê pelo mesmo caminho. O papel é determinado pelo Codec.

## Interpretação e validade

- Property e Target são, cada um, exatamente um registro Reference completo, e o Target é uma Reference LOCAL. O documento de especificação do geul.org põe em Target o LOCAL de [CODEC](/pt/grammar/edge/codec/) (`0008`). O Value é exatamente um registro Reference ou Value completo, ou 1 WORD de [marcador de posição](/pt/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) ou `0x0002` (NO-VALUE). O documento de especificação põe em Value os CODEC `0780`, `0F80`, `0001` e `0002`. Não aceita ABSENT (`0x0000`). Property e Target não aceitam marcadores de posição. O cursor depois de ler o Value deve coincidir com o fim do Edge.
- O Target é um Edge Id dentro do mesmo documento. O QUALIFIER fica no mesmo documento que o Edge que restringe.
- Se o Target for o [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do HEAD (a fonte do documento inteiro), o QUALIFIER também fica no HEAD, depois desse SOURCE. Os demais QUALIFIERs ficam no BODY. Um QUALIFIER que tenha o SOURCE do HEAD como Target e esteja no BODY é invalid.
- O Target pode ser outro Edge além do TRIPLE. O QUALIFIER anexado a um [SOURCE](/pt/grammar/edge/source/) restringe o ato de citação (data de consulta, posição dentro da fonte etc.). O significado de um SOURCE também é a soma de todos os QUALIFIERs que apontam para ele.
- **O QUALIFIER faz parte da proposição.** Não é uma afirmação separada sobre a proposição: restringe as condições em que a proposição é verdadeira. O significado do TRIPLE alvo é a soma de todos os QUALIFIERs que apontam para ele.
  - A origem da proposição escreve-se com [SOURCE](/pt/grammar/edge/source/). As propriedades do nó da fonte (título, autor etc.) escrevem-se com um TRIPLE que tem a fonte como Subject.
- Pode haver vários QUALIFIERs da mesma Property no mesmo Target. A ordem dos QUALIFIERs de um mesmo Target é a ordem dentro do documento (exceção em que a ordem dos Edges tem significado).

## Desconhecido e sem valor

Quando o Value do QUALIFIER é um marcador de posição, muda o sentido dessa restrição. Tome-se como exemplo o instante de fim (P582).

| O que se anexa ao TRIPLE alvo | Significado | A proposição ainda é válida? |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | terminou em 1974 | não |
| `QUALIFIER P582 #n UNKNOWN` | terminou. Não se sabe quando (`somevalue` do Wikidata) | não |
| `QUALIFIER P582 #n NONE` | afirma-se que não terminou (`novalue` do Wikidata) | sim |
| sem QUALIFIER P582 | não se sabe se terminou (mundo aberto) | não se sabe |

- Descartar o `somevalue` e o `novalue` de um qualifier do Wikidata alarga a proposição. Um TRIPLE de fronteira que perdeu o `somevalue` do instante de fim seria lido como "fronteira ainda válida". Por isso, ao transcrever, passam-se como marcadores.
- UNKNOWN-VALUE não é visto como igual a outro UNKNOWN-VALUE. O resultado da comparação é indefinido.

## Exemplo (não normativo)

Q42 P69 (educated at) Q691283 (St John's College), 1971 a 1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORDs. O Value é [EDTF](/pt/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

Fronteira (P47) entre Q30 (Estados Unidos) e Q34266 (Império Russo), com o instante de fim desconhecido. Edge Id `2060` e `3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge, 8 WORDs, Codec `0x0B`. TAG 1 + Edge Id 2 + Property P582 (`00A8 0246`) 2 + Target #2060 (`0088 080C`) 2 + marcador 1.

Anexa-se um período ao TRIPLE NO-VALUE `#3161` do banco central (P1304) de Q30. Só não houve entre 1811 e 1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [TRIPLE](/pt/grammar/edge/triple/), [SOURCE](/pt/grammar/edge/source/), [WIKIDATA-PID](/pt/grammar/reference/wikidata-pid/), [EDTF](/pt/grammar/value/time/edtf/), [Marcador de posição](/pt/grammar/reference/slot-marker/)
