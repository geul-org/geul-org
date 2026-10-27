---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference é um registro que aponta para um alvo. Os 4 bits de Codec definem o sistema de identificação (LOCAL, Wikidata, documento externo etc.) e os 3 bits de Quantifier definem a quantificação (identificado, genérico, universal, variável etc.). O Codec reservado 0000 é o conjunto de marcadores de posição."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference é um registro que aponta para um alvo. O alvo pode ser uma entidade, um conceito, um documento ou outro Edge. Aponta-se por ID, não por nome.

## Layout

```
TAG WORD          0000 0LLL LCCC CQQQ
[TAG estendida de Length]
[IMPORT ID]       no EXTERNAL-POINTER (1/2/4/8 WORD)
[Issuer]          no EXTERNAL-ISSUER (1/2/4/16 WORD)
[ID do documento] no EXTERNAL-ISSUER (4 WORD)
ID do alvo        todo o restante
```

- `LLLL` é o número total de WORDs, incluindo a TAG WORD, menos 1 ([Registro e TAG WORD](/pt/grammar/record/)).
- O Codec são os 4 bits `CCCC` e o Quantifier são os 3 bits `QQQ`. Os 7 bits inferiores da TAG WORD são `CCCC << 3 | QQQ`.
- O ID do alvo é um inteiro big-endian sem sinal e é escrito na **menor largura**. A largura é o que sobra do Length depois dos campos anteriores.
- O ID de alvo `0` escreve-se como 1 WORD `0x0000`. Nos demais casos não se coloca uma WORD `0x0000` na frente.
- Valores inteiros iguais são o mesmo ID. A largura não faz parte do ID.
- Todos os Codecs usam a menor largura. Nenhum Codec fixa a largura do ID do alvo.
- [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/) e [DOC-POINTER](/pt/grammar/reference/doc-pointer/) não seguem este layout. Não têm ID de alvo e contêm apenas o Issuer (e o ID do documento e o ID da versão).

## Codec (`CCCC`)

| CCCC | Nome | Classificação | Alvo |
|---|---|---|---|
| `0000` | [Marcador de posição](/pt/grammar/reference/slot-marker/) | reservado | Não aponta para alvo. Só se usam marcadores de 1 WORD cujos 3 bits inferiores são o número do marcador: `0x0000` ABSENT (não informado), `0x0001` UNKNOWN-VALUE (desconhecido), `0x0002` NO-VALUE (sem valor) |
| `0001` | [LOCAL](/pt/grammar/reference/local/) | declaração | ID emitido por este documento |
| `0010` | [GEUL](/pt/grammar/reference/geul/) | declaração | Entidades emitidas pelo geul.org |
| `0011` | [GEUL-SIDX](/pt/grammar/reference/geul-sidx/) | declaração | Identificador de alinhamento semântico que leva significado nos bits |
| `0100` | [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/) | declaração | Item do Wikidata. O inteiro depois de `Q` |
| `0101` | [WIKIDATA-PID](/pt/grammar/reference/wikidata-pid/) | declaração | Propriedade do Wikidata. O inteiro depois de `P` |
| `0110` | [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/) | indicação-declaração | O próprio Issuer |
| `0111` | [DOC-POINTER](/pt/grammar/reference/doc-pointer/) | indicação-declaração | Uma versão de um documento publicado por um Issuer |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/pt/grammar/reference/external-pointer/) | indicação | LOCAL ID de um documento importado por IMPORT |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/pt/grammar/reference/external-issuer/) | indicação-declaração | LOCAL ID de um documento publicado por um Issuer |

- A **declaração** identifica diretamente o alvo por um ID definido pela entidade emissora.
- A **indicação** aponta para um LOCAL dentro de um documento importado por IMPORT ID. Os 2 bits inferiores são a largura do IMPORT ID (`00`=1, `01`=2, `10`=4, `11`=8 WORD).
- A **indicação-declaração** aponta, com um só registro e sem IMPORT, para outro documento e para o alvo dentro dele.
- Se o bit mais alto for `0`, identifica-se diretamente o alvo (o LOCAL deste documento, um ID emitido, o próprio Issuer ou documento); se for `1`, aponta-se para o LOCAL de outro documento.
- O Codec `0000` é reservado e não se usa como Reference que aponta para um alvo. A exceção é um único conjunto: as WORDs `0x0000`~`0x0007` (Codec `0000`, 1 WORD) são [marcadores de posição](/pt/grammar/reference/slot-marker/). Hoje se usam três (`0x0000` ABSENT, `0x0001` UNKNOWN-VALUE, `0x0002` NO-VALUE). O marcador só é válido na posição de um campo de registro que tenha essa WORD como alvo CODEC exato. Curingas e campos sem CODEC não o aceitam, e na posição de registro de HEAD ou BODY e na posição de Edge Id é invalid. `0x0003`~`0x0007` e o Codec `0000` com Payload são reservados.
- Sistemas de identificação que não são CC0 (WordNet etc.) não se põem como Codec de Reference. A Reference também não tem código ISSUER, e por isso não há lugar para movê-los a um formato Issuer.

### TAGs de uso frequente

| Registro | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Q5 do Wikidata (pessoa) | `00A0 0005` |
| Q691283 do Wikidata | `0120 000a 8c53` |
| P31 do Wikidata (instance of) | `00A8 001f` |
| Marcador de posição ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL é um ID emitido por este documento. Só tem sentido dentro do documento.

- **É único.** Em um documento, um LOCAL ID aponta para um único alvo.
- **0 não é atribuído.** Os IDs de alvo são atribuídos a partir de 1.
- **Recomenda-se atribuir de forma crescente** (auto increment). O tamanho do ID não tem significado.
- Aponta para o mesmo alvo através das versões. Um ID excluído não se reutiliza ([Documento](/pt/grammar/document/) revisão).
- Para ser apontado de fora do documento, o documento deve ter um `DOC-ID`.
- LOCAL IDs diferentes não significam alvos diferentes no mundo real. Se forem o mesmo, liga-se com um Edge `SAME-NODE`; se forem diferentes, com `DIFFERENT-NODE`.

### Edge Id

Todo Edge tem como primeiro elemento do Payload uma Reference LOCAL. Esse LOCAL ID é o **Edge Id**.

- O Edge Id pode ser lido mesmo sem conhecer o codebook.
- O LOCAL na posição de Edge Id é uma declaração, e o LOCAL nas outras posições do Edge é uma menção.
- O LOCAL que declara um Edge Id usa apenas o Quantifier `000`.
- Os outros Edges são apontados pelo Edge Id. Os Edges deste documento por LOCAL, e os Edges de outros documentos por Reference de indicação.

## Apontar para outro documento

| O quê | Como |
|---|---|
| O próprio Issuer | `ISSUER-POINTER` (Issuer) |
| Uma versão de um documento | `DOC-POINTER` (Issuer, ID do documento de 4 WORD, ID da versão de 2 WORD). A versão `0` é a mais recente |
| Um alvo dentro de um documento publicado (mais recente) | `EXTERNAL-ISSUER-*` (Issuer, ID do documento, LOCAL ID) |
| Um alvo dentro de um documento importado (edição fixa) | atribui-se um IMPORT ID com o Meta `IMPORT-DOC` e usa-se `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- O documento em si, dentro ou fora do documento, é apontado apenas por um DOC-POINTER. Ele próprio é o DOC-POINTER do seu `DOC-ID`.
- EXTERNAL-ISSUER segue a versão mais recente. Para fixar a edição, usa-se IMPORT.
- O Issuer é escrito na menor largura em que o valor cabe (1/2/4/16 WORD) e escolhe-se o Codec correspondente a essa largura.
- O ID de documento `0` de cada Issuer é reservado ao documento de índice dos termos (ferramentas, papéis etc.) definidos por esse Issuer. O documento de índice é recomendado a todos os Issuers e não é obrigatório ([Issuer e publicação](/pt/grammar/issuer/#documento-de-definição-de-termos)).

Exemplo: no Issuer `0x0001`, LOCAL 7 dentro do documento `0x0000000000000002`

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | Nome | Significado | Exemplo |
|---|---|---|---|
| `000` | Identified | entidade identificada | Elon Musk, Brasil |
| `001` | Generic | declaração geral sobre toda uma espécie. Admite exceções | soldados obedecem a ordens |
| `010` | Free-choice | qualquer alvo que satisfaça a condição | qualquer soldado |
| `011` | Universal | todos os alvos dentro do âmbito | todos os soldados |
| `100` | Variable | variável de discurso | aquela pessoa, esta mulher |
| `101`~`111` | reservado | | |

- **Exceção: no Codec `0000` (marcador de posição), os 3 bits inferiores não são o Quantifier, e sim o número do marcador.** O número do marcador e o significado do Quantifier não se correspondem (`0x0001` UNKNOWN-VALUE não é Generic). O Quantifier desta tabela só se aplica aos Codecs `0001`~`1111`.
- Generic, ao contrário de Universal, não significa que se aplica sem exceção a todos os alvos individuais. Uma expressão definidora como `o que é um soldado` pode usar Generic. Quando se precisa de uma definição rigorosa de conceito ou classificação, concretiza-se com uma relação separada.
- O âmbito de aplicação da quantificação e a negação são determinados não pela Reference, mas pelo Edge que a usa.
- **Variable** é um alvo do discurso cuja espécie se conhece mas que ainda não foi identificado.
  - Uma variável com nome coloca Variable num LOCAL. O mesmo LOCAL ID é a mesma variável. A espécie liga-se por Edge.
  - Uma variável anônima coloca Variable num Codec de declaração que aponta para a espécie (GEUL, WIKIDATA-*) (por exemplo, "presidente" do Wikidata + Variable). Não acompanha correferência e não pode ser apontada de novo. Variáveis anônimas não são vistas como a mesma variável.
  - Quando o alvo for confirmado depois, liga-se a variável a esse alvo com `SAME-NODE`. Todas as expressões que apontam para a mesma variável passam a ser interpretadas como esse alvo.
  - Mesmo variáveis diferentes não significam que os alvos reais sejam diferentes. Se forem o mesmo, liga-se com `SAME-NODE`; se forem diferentes, com `DIFFERENT-NODE`.
  - A variável só vale dentro desse documento e não se usa como identificador permanente.
  - Variable nos Codecs de indicação externa (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) é a variável LOCAL do documento apontado.
  - Exemplo: em `o presidente discursou`, se a pessoa não está determinada, usa-se Variable "presidente". Para mencioná-lo de novo, põe-se uma Variable LOCAL e liga-se a espécie "presidente" por Edge. Se depois se confirmar que é Obama, liga-se essa variável ao Identified Obama com `SAME-NODE`. Todas as expressões que apontam para a mesma variável passam a ser interpretadas como Obama.
- Exemplo: Q5 do Wikidata (pessoa) usado como Generic é `00A1 0005` ("a pessoa é …").
