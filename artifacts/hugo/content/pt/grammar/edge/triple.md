---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE é o Edge descritivo que contém uma proposição (Predicate, Subject, Object) e o seu grau (rank) (Codec 0x0A). No Object, em vez de um valor, pode-se usar desconhecido (UNKNOWN-VALUE) ou sem valor (NO-VALUE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE é o Edge descritivo que contém uma proposição (Predicate, Subject, Object) e o seu grau (rank). Codec `0x0A`.

As condições que restringem a proposição (instante de início e fim, âmbito de aplicação etc.) são anexadas por [QUALIFIER](/pt/grammar/edge/qualifier/) que aponta para o Edge Id do TRIPLE. A origem (references do Wikidata) é anexada pelo Edge de fundamento [SOURCE](/pt/grammar/edge/source/) que aponta para o Edge Id do TRIPLE.

## Layout

```
TAG WORD          0001 0LLL L000 1010
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Predicate         registro Reference (WIKIDATA-PID etc.)
Subject           registro Reference
Object            registro Reference ou Value, ou marcador de posição 0x0001 UNKNOWN-VALUE · 0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| Código | Nome | Significado |
|---|---|---|
| `0` | normal | padrão |
| `1` | preferred | valor atual, o mais autorizado |
| `2` | deprecated | valor julgado errado ou obsoleto, mas mantido como registro |

- É igual ao statement rank do Wikidata. O valor representativo (truthy do Wikidata) é, entre os de mesmo Subject e Predicate, o preferred se existir e, senão, o normal.
- Fontes que não atribuem rank usam `0` (normal).
- Qualquer outro código é invalid.

## Interpretação e validade

- Predicate e Subject são, cada um, exatamente um registro Reference completo.
- Object é exatamente um registro Reference ou Value completo, ou 1 WORD de [marcador de posição](/pt/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) ou `0x0002` (NO-VALUE). Não aceita ABSENT (`0x0000`). O Object não é um campo opcional.
- Depois de ler o Object, deve restar exatamente 1 WORD (Rank).
- O documento de especificação do geul.org põe no campo bruto Rank o [CODEC](/pt/grammar/edge/codec/) UNSIGNED-INTEGER (`0802`) e os [ENUM](/pt/grammar/edge/enum/) 0, 1 e 2. No campo Object põe os CODEC `0780` (qualquer Reference), `0F80` (qualquer Value), `0001` (UNKNOWN-VALUE) e `0002` (NO-VALUE). Predicate e Subject não aceitam marcadores de posição.
- **O significado de um TRIPLE é a soma de todos os QUALIFIERs que, no mesmo documento, apontam para o seu Edge Id.** Quem lê reúne os QUALIFIERs antes de interpretar o TRIPLE. Um TRIPLE lido sem QUALIFIERs pode ser uma proposição sem a restrição (por exemplo, "chefe do executivo" sem a restrição de tempo).

## Desconhecido e sem valor

O marcador de posição na posição do Object não é um valor, e sim uma afirmação sobre a proposição.

| Object | Significado | Lógica |
|---|---|---|
| valor v | um dos valores do Predicate do Subject é v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | há um valor. Não se sabe qual (`somevalue` do Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | não há valor (`novalue` do Wikidata) | `¬∃x. P(s, x)` |
| sem TRIPLE | nada se afirma (mundo aberto) | |

- **Lê-se dentro da condição restritiva.** O âmbito de `∃` e `¬∃` é determinado pelos QUALIFIERs que apontam para esse TRIPLE. Com QUALIFIERs, fecha-se apenas nesse âmbito. "Entre 1811 e 1816 não havia banco central" escreve-se com um TRIPLE NO-VALUE e QUALIFIERs P580 e P582. Não contradiz os TRIPLEs de valor de outros períodos do mesmo Predicate.
- **O rank se aplica da mesma forma.** Ao escolher o valor representativo (truthy), os TRIPLEs UNKNOWN-VALUE e NO-VALUE também são candidatos. Se houver preferred, só ele permanece.
- **UNKNOWN-VALUE não é igual a outro UNKNOWN-VALUE.** UNKNOWN-VALUE não é igual nem diferente de nenhum valor (resultado de comparação indefinido), e dois UNKNOWN-VALUE tampouco são vistos como o mesmo valor. Cada ocorrência é uma quantificação existencial independente. Por isso dois TRIPLEs UNKNOWN-VALUE com bytes idênticos não são duplicatas e não se fundem (pode haver dois filhos ou um só).
- Se, no mesmo Subject, Predicate e rank, houver juntos um TRIPLE NO-VALUE e um TRIPLE de valor (ou UNKNOWN-VALUE) sem que as condições restritivas os distingam, há contradição. O verificador avisa. Não rejeita (é um estado que existe também no Wikidata).
- Um valor que não se conseguiu transcrever (a origem tem o valor) não se escreve como UNKNOWN-VALUE.

## Exemplo (não normativo)

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORDs, `LLLL=1001`. A TAG é `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (Estados Unidos) P1304 (banco central) NO-VALUE, normal. Entre 1811 e 1816 não havia banco central (os QUALIFIERs P580 e P582 estão no exemplo de [QUALIFIER](/pt/grammar/edge/qualifier/)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORDs, `LLLL=1000`. A TAG é `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "Sem filhos (P40)" é `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Questões em aberto

- scope (contexto da afirmação: mundo, ponto de vista): decide-se quando houver uso.
- Forma abreviada que dobra TRIPLE e QUALIFIER num só registro: depois que existir a declaração de campos repetidos (questão em aberto de [DECLARE](/pt/grammar/edge/declare/)).

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [QUALIFIER](/pt/grammar/edge/qualifier/), [SOURCE](/pt/grammar/edge/source/), [LABEL](/pt/grammar/edge/label/), [ALIAS](/pt/grammar/edge/alias/), [Marcador de posição](/pt/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/pt/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/)
