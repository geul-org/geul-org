---
title: "Registro e TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Todo registro começa com uma TAG WORD de 16 bits. Prefix de 3 bits, Kind de 2 bits, Length de 4 bits e Codec de 7 bits definem o tipo e o comprimento do registro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Os dados GEUL são uma sequência de registros. Todo registro começa com uma única TAG WORD.

## Layout do registro

```
TAG WORD (16 bits)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[TAG estendida de Length]
[TAG estendida de Codec]
[TAG por Codec]
Payload
```

- A TAG WORD é `000K KLLL LCCC CCCC`.
- As TAGs estendidas só aparecem na ordem acima. A TAG estendida de Length vem sempre logo depois da TAG WORD.
- A composição da TAG por Codec e do Payload é definida pela especificação de cada Codec. O comprimento da TAG por Codec não é escrito na TAG WORD, porque para interpretar o Payload o codebook é necessário de qualquer forma.
- Um Codec com subformatos indica o subformato com 1 WORD de TAG por Codec (Edge WORLD etc.).

## Ordem dos bytes

- A serialização canônica é big-endian.
- Os campos de bits são dispostos a partir do bit mais significativo.
- Dentro de uma WORD vem primeiro o byte superior; em valores de várias WORDs, escreve-se primeiro a WORD superior.
- A representação em memória fica a critério da implementação.

## Kind (2 bits)

| Valor | Kind | TAG WORD | Definição |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | Aponta para um alvo. O Codec e o ID do alvo identificam o alvo |
| `01` | Value | `0000 1LLL LCCC CCCC` | Contém o próprio valor. O Codec define a interpretação do Payload |
| `10` | Edge | `0001 0LLL LCCC CCCC` | Une outros registros como componentes. O Codec define o papel e a ordem dos componentes |
| `11` | Meta | `0001 1LLL LCCC CCCC` | Fala sobre o documento e os registros |

- O Kind é uma propriedade imutável do Codec. Um Codec, uma vez atribuído, não muda de Kind.
- Value e Edge têm o mesmo formato "Codec + Payload". Só o Edge tem outros registros como componentes.
- Reference divide os 7 bits de Codec em Codec de 4 bits e Quantifier de 3 bits ([Reference](/pt/grammar/reference/)).

## Length (4 bits)

Length é o **número total de WORDs** que o registro ocupa. Inclui a TAG WORD, as TAGs estendidas, o Payload e o preenchimento da última WORD.

| Valor | Significado |
|---|---|
| `0000`~`1101` | 1~14 WORDs (valor + 1) |
| `1110` | comprimento estendido 1: a próxima 1 WORD contém o número total de WORDs (15~65.535) |
| `1111` | comprimento estendido 2: as próximas 2 WORDs contêm o número total de WORDs (65.536~2³²−1) |

- De 1 a 14 WORDs, o comprimento direto é obrigatório. Uma notação mais larga não é a forma canônica.
- O número total de WORDs do comprimento estendido inclui a própria TAG estendida de Length.
- Não há registro maior que 2³²−1 WORDs.
- Um registro de 1 WORD é só a TAG WORD, sem Payload. Usa-se apenas quando a especificação do Codec permite (por exemplo, Meta `BODY`, `END`, sequência de bytes vazia, marcador de posição).
- Mesmo sem codebook, é possível pular registros com `posição do próximo registro = início do registro atual + Length`.

## Codec (7 bits)

| Valor | Nome | Significado |
|---|---|---|
| `0x00`~`0x7B` | código direto | A TAG WORD sozinha define o Codec |
| `0x7C` | ISSUER-1WORD | A TAG estendida de Codec contém 1 WORD de Issuer e 1 WORD de número de formato |
| `0x7D` | ISSUER-2WORD | A TAG estendida de Codec contém 2 WORDs de Issuer e 1 WORD de número de formato |
| `0x7E` | ISSUER-4WORD | A TAG estendida de Codec contém 4 WORDs de Issuer e 1 WORD de número de formato |
| `0x7F` | ISSUER-16WORD | A TAG estendida de Codec contém 16 WORDs de Issuer e 1 WORD de número de formato |

- O espaço de números de Codec é separado por Kind. O mesmo número com Kind diferente é outro Codec.
- Um Codec que não é código direto é um par `(Issuer, número de formato)`. O número de formato é definido por esse Issuer ([Issuer e publicação](/pt/grammar/issuer/)). Formatos estendidos ficam sob o Issuer da entidade que os estabeleceu.
- Um Codec que tem código direto não é registrado separadamente como formato de Issuer.
- Formatos de Issuer existem apenas em Value e Edge. Reference usa Codec de 4 bits, e Meta é uma especificação comum definida só pelo GEUL.
- Os bits superiores do Codec e do número de formato indicam a família (Value, Edge) ou a classe (Meta). A família é conhecida mesmo sem codebook.
- Códigos diretos não podem ser recuperados. Apenas formatos de frequência comprovada ficam em código direto.

## Registro de formato Issuer

```
TAG WORD          Codec = 0x7C~0x7F
[TAG estendida de Length]
Issuer            1/2/4/16 WORDs (o Codec define a largura)
Número de formato 1 WORD. Os bits superiores indicam a família
Payload           valor definido pelo formato
```

- Um decodificador que não conhece o formato sabe apenas a família do número de formato e pula o Payload.

## Sequência de bytes de comprimento variável

Para valores cujo comprimento é em bytes — texto, URI, tag de idioma, sequência de bytes opaca — o Codec (ou número de formato) é atribuído em um **par par/ímpar**.

- Se o bit menos significativo do Codec é `0`, o número de bytes é par; se é `1`, é ímpar.
- Número de bytes = `2 × número de WORDs do Payload − bit menos significativo`. Não há campo Byte Count.
- Se for ímpar, o byte inferior da última WORD é preenchimento `0x00`. Se não for `0x00`, rejeita-se.
- Uma sequência de bytes vazia é um registro de 1 WORD (só a TAG WORD) do Codec par.
- Valores de tamanho fixo, como UUID, digest e endereços, não têm par.

## Exemplo: lendo uma TAG WORD

Vamos ler `148A`.

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10 (Edge), Length 1001 (10 WORDs), Codec 0x0A (TRIPLE)
```

Este registro é um Edge de 10 WORDs, com Codec TRIPLE. Mesmo sem codebook, sabe-se que o próximo registro está 10 WORDs adiante.

## Marcador de posição

As TAG WORDs `0x0000`~`0x0007` são registros de 1 WORD do Codec Reference reservado `0000`. Não apontam para alvo algum; ocupam o lugar de um campo do registro ([Marcador de posição](/pt/grammar/reference/slot-marker/)).

```
0x0000~0x0007 = 0000 0000 0000 0MMM
                Prefix 000, Kind 00 (Reference), LLLL 0000 (1 WORD), CCCC 0000, MMM = número do marcador
```

| WORD | Nome | Significado | Sobre o que fala | Lógica | Pressuposto de mundo | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | não informado | documento: este lugar não foi preenchido | nenhuma asserção | mundo aberto | sem snak |
| `0x0001` | UNKNOWN-VALUE | desconhecido | mundo: há um valor, mas não se sabe qual | `∃x. P(s, x)` | existência fechada, identidade aberta | `somevalue` |
| `0x0002` | NO-VALUE | sem valor | mundo: não há valor | `¬∃x. P(s, x)` | fechado para (s, P, condição restritiva) | `novalue` |
| `0x0003`~`0x0007` | reservado | | | | | |

- Exemplo: se filhos (P40) é ABSENT, não se sabe quantos; se UNKNOWN-VALUE, pelo menos 1; se NO-VALUE, 0. Se a data de término (P582) é ABSENT, não se sabe se ainda vale; se UNKNOWN-VALUE, terminou mas não se sabe quando; se NO-VALUE, não terminou.
- Os 3 bits inferiores `MMM` são o número do marcador, não um Quantifier (exceção do Quantifier em [Reference](/pt/grammar/reference/)).
- Um marcador só é válido quando a lista de CODEC do campo contém essa WORD exatamente. Em curinga, em campo sem CODEC, em lugar de registro HEAD/BODY ou em lugar de Edge Id, é inválido ([CODEC](/pt/grammar/edge/codec/)).
- Obrigações de quem lê:
  1. UNKNOWN-VALUE não é um valor, é uma asserção de existência. Não é igual nem diferente de nenhum valor, e dois UNKNOWN-VALUEs também não são vistos como o mesmo valor. TRIPLEs que contêm UNKNOWN-VALUE não são mesclados como duplicatas.
  2. NO-VALUE é fechado dentro da condição restritiva da proposição. Se coexiste com um TRIPLE de valor de mesmo Subject, Predicate e rank cujas condições restritivas não se distinguem, é uma contradição e o verificador emite um aviso (não rejeita).
  3. O rank se aplica igualmente. Ao escolher o valor representativo (truthy), os TRIPLEs com os dois marcadores também são candidatos.
  4. Quando usado como valor de QUALIFIER, muda o sentido dessa restrição (`P582 = UNKNOWN`: terminou, momento desconhecido. `P582 = NONE`: não terminou).
  5. ABSENT não diz nada sobre o mundo. Um valor que não pôde ser convertido não se escreve como UNKNOWN-VALUE.

## Forma canônica

O mesmo conteúdo deve resultar nos mesmos bytes. Assim o hash de conteúdo e a assinatura ficam determinados de modo único.

- Usa-se a notação mais curta para o comprimento (1~14 WORDs em comprimento direto).
- Inteiros são escritos na menor largura. Segue-se a forma canônica definida pela especificação de cada Codec.
- Registros que não estão na forma canônica são rejeitados.
