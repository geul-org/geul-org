---
title: "Marcador de posição"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "O marcador de posição é um conjunto de registros de 1 WORD no Codec reservado 0000 de Reference. 0x0000 ABSENT (não informado), 0x0001 UNKNOWN-VALUE (desconhecido) e 0x0002 NO-VALUE (sem valor) ocupam a posição de um campo de registro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

O marcador de posição (slot marker) é um registro de 1 WORD que ocupa a posição de um campo de registro. Não aponta para nada. Fica no Codec reservado `0000` de Reference.

Na posição de um valor só podem vir três coisas: o valor não foi informado, há um valor mas não se sabe qual, ou não há valor. Os três são coisas diferentes. O marcador de posição as separa em três WORDs vizinhas.

## Layout

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00 (Reference), LLLL 0000 (1 WORD), CCCC 0000, MMM = número do marcador
```

| WORD | Nome | Significado | Notação |
|---|---|---|---|
| `0x0000` | ABSENT | não informado | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | desconhecido: há um valor. Não se sabe qual | `UNKNOWN` |
| `0x0002` | NO-VALUE | sem valor: não há valor | `NONE` |
| `0x0003`~`0x0007` | reservado | | |
| CCCC `0000`, LLLL ≥ `0001` | reservado | marcadores com Payload serão definidos depois | |

- Os 3 bits inferiores `MMM` são o **número do marcador, não um Quantifier**. Só têm o mesmo lugar e o mesmo nome que o `QQQ` dos outros Codecs de Reference, sem relação de significado ([Reference](/pt/grammar/reference/) exceção do Quantifier).
- Não tem Payload. Também não tem ID de alvo.
- Mesmo um decodificador sem codebook, só olhando a TAG WORD, sabe que é um Kind Reference de 1 WORD e o pula. "Se o valor da WORD for `0`~`7`, é um marcador de posição" se sabe com uma só verificação de bits (`w & 0xFFF8 == 0`).
- As notações `ABSENT`, `UNKNOWN` e `NONE` são as notações em texto de `geul show` e `geul add`.

## Três distinções

| | Não informado (ABSENT) | Desconhecido (UNKNOWN-VALUE) | Sem valor (NO-VALUE) |
|---|---|---|---|
| Sobre o que fala | **o documento**: esta posição não foi preenchida | **o mundo**: há um valor. Não se sabe qual | **o mundo**: não há valor |
| Lógica | não afirma nada | `∃x. P(s, x)`, x não identificado | `¬∃x. P(s, x)` |
| Pressuposto de mundo | mundo aberto (sem informação) | a existência é fechada, a identidade é aberta | mundo fechado para (s, P, condição restritiva) |
| Wikidata | não há o snak correspondente | `somevalue` | `novalue` |
| Onde se usa | campo opcional com alvo CODEC `0000` (Origin de SOURCE etc.) | campo com alvo CODEC `0001` (Object de TRIPLE, Value de QUALIFIER, Origin de SOURCE) | campo com alvo CODEC `0002` (Object de TRIPLE, Value de QUALIFIER) |
| "Quantos filhos (P40)?" | não se sabe | 1 ou mais | 0 |
| "Há instante de fim (P582)?" | não se sabe → não se sabe se ainda é válido | terminou. Não se sabe quando | não terminou (afirmado) |

A mesma distinção vale no nível da proposição. **Não haver o TRIPLE no documento** é não informado. O documento GEUL é de mundo aberto, e a ausência de uma descrição não significa que o fato não exista. "Não há" só se pode dizer **escrevendo** NO-VALUE.

## Regra de aceitação

- O marcador de posição só é válido se a lista de [CODEC](/pt/grammar/edge/codec/) do campo contiver **a mesma WORD como alvo exato**. O alvo `0000` significa "campo opcional", `0001` "aceita desconhecido" e `0002` "aceita sem valor".
- Os curingas (`0780`, `0781`, `0F80` etc.) não aceitam marcadores. Os curingas de Reference também não se sobrepõem ao Codec `0000`.
- Um campo de registro sem CODEC ("qualquer registro") também não aceita marcadores.
- Um marcador na posição de registro de HEAD ou BODY, ou na posição de Edge Id, é invalid.
- Um campo de valor bruto não pode usar marcadores. O valor bruto não tem TAG, então não há lugar para um marcador de 1 WORD.
- Uma lista de CODEC só com alvos de marcador (sempre marcador) é invalid.
- O significado do marcador (o que há e o que não há) é definido pela especificação do Edge que o recebe. É o mesmo princípio de que a quantificação e a negação são determinadas pelo Edge, não pela Reference.
- O marcador de posição não tem documento de especificação de Codec. É da [camada 0](/pt/grammar/publishing/#camadas) (incorporado ao decodificador). Como o alvo de Reference em DECLARE deixa a posição do Quantifier em 0, não se pode criar o documento de especificação de `0x0001` e `0x0002`, e como os três não têm Payload, também não há custo de incorporação.

## Deveres de quem lê

1. **UNKNOWN-VALUE não é um valor, e sim uma afirmação de existência.** Não é igual nem diferente de nenhum outro valor (resultado da comparação indefinido). Dois UNKNOWN-VALUE tampouco são vistos como o mesmo valor. Cada ocorrência é uma quantificação existencial independente (como o nó em branco do Wikidata).
   - Por isso dois TRIPLEs com bytes iguais (`P40 Q… UNKNOWN` ×2) não são duplicatas. Pode haver dois filhos ou um só. Os TRIPLEs com UNKNOWN-VALUE não se fundem como duplicatas.
   - Quando a identidade for revelada, publica-se uma nova versão que corrige esse TRIPLE. UNKNOWN-VALUE não pode ser apontado. Se for preciso correferência, usa-se uma Variable LOCAL ([Reference](/pt/grammar/reference/) Variable).
2. **NO-VALUE fecha dentro das condições restritivas da proposição.** Com QUALIFIERs, fecha apenas nesse âmbito. Q30 P1304 NO-VALUE (P580 1811, P582 1816) significa que só entre 1811 e 1816 não houve banco central, e não contradiz o TRIPLE de valor da mesma propriedade (Federal Reserve, preferred).
   - Se, no mesmo Subject e Predicate, um NO-VALUE e um TRIPLE de valor estiverem juntos com o mesmo rank, sem que as condições restritivas os distingam, há contradição. O verificador avisa. Não rejeita. É um estado que existe também no Wikidata, e quem lê escolhe pelo rank.
3. **O rank se aplica da mesma forma.** Ao escolher o valor representativo (truthy), os TRIPLEs UNKNOWN-VALUE e NO-VALUE também são candidatos. Se houver preferred, só ele permanece.
4. **Usado como valor de QUALIFIER, muda o sentido dessa restrição.** Com `P582 = UNKNOWN`, terminou e não se sabe quando. Não se lê como proposição ainda válida. Com `P582 = NONE`, afirma-se que não terminou. Se não houver nenhum QUALIFIER P582, não se sabe se terminou.
5. **ABSENT não diz nada sobre o mundo.** Não se lê como UNKNOWN-VALUE nem como NO-VALUE. Em contrapartida, é proibido um conversor escrever como UNKNOWN-VALUE um valor que não conseguiu transcrever (um valor que existe na origem), porque na origem o valor é conhecido. Também nas posições que a origem não informou (por exemplo, o Origin do [SOURCE](/pt/grammar/edge/source/) de uma origem que não descreve a fonte), o conversor escreve ABSENT. UNKNOWN-VALUE é uma afirmação de que "há", e só se usa quando a origem diz isso.

## Diferença em relação a outros "sem"

- A regra de Codec que usa [LOCAL](/pt/grammar/reference/local/) `0` como "sem" (REF de [TOULMIN](/pt/grammar/edge/toulmin/) etc.) é uma convenção interna desse Codec. É diferente do marcador de posição.
- Não se usa um LOCAL Identified como null ou sentinela. Para escrever desconhecido ou ausente, usa-se o marcador num campo que o aceite.

## Exemplo

Fronteira entre Q30 (Estados Unidos) e Q34266 (Império Russo), com o instante de fim desconhecido. Os Edge Ids são ilustrativos.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Banco central de Q30: não houve entre 1811 e 1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- A posição do marcador é 1 WORD. O TRIPLE tem 9 WORDs (`140A`) e o QUALIFIER, 8 WORDs (`138B`).
- Na forma simples, "sem filhos (P40)" é `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [CODEC](/pt/grammar/edge/codec/), [Documento de especificação de Codec](/pt/grammar/codec-spec/)
- [TRIPLE](/pt/grammar/edge/triple/), [QUALIFIER](/pt/grammar/edge/qualifier/), [TOULMIN](/pt/grammar/edge/toulmin/)
