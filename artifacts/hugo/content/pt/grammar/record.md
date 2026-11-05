---
title: "Estrutura do registro"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Os dados GEUL são uma sequência de registros."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Os dados GEUL são uma sequência de registros. Todo registro começa com um TAG WORD.

## Layout do registro {#레코드-레이아웃}

```
TAG WORD (16 bits)
┌──────────┬──────────┬──────────┬──────────┐
│  Prefix  │   Kind   │  Class   │  Length  │
│   3bit   │   4bit   │   5bit   │   4bit   │
│   000    │   KKKK   │  CCCCC   │   LLLL   │
└──────────┴──────────┴──────────┴──────────┘
[TAG de extensão de Length]
[TAG de extensão de Codec]
[TAG específica do Codec]
Payload
```

- O TAG WORD é `000K KKKC CCCC LLLL`. Os 4 bits superiores `KKKK` são a seção `S = w >> 9`, e uma seção tem 32 posições. `C` é o deslocamento de 5 bits dentro da seção, `(w >> 4) & 0x1F`.
- O TAG ID é escrito como `0x000L`. Os três primeiros dígitos são a posição de Codec de 9 bits (`w >> 4`) que combina a seção e `C`, e `L` é a posição de Length. No valor real do WORD, escreve-se um número na posição L (por exemplo, TRIPLE é `0x0AAL`, e o TAG WORD de um TRIPLE de 10 WORD é `0x0AA9`).
- As TAGs de extensão são colocadas apenas na ordem acima. A TAG de extensão de Length vem sempre imediatamente depois do TAG WORD.
- A composição da TAG específica do Codec e do Payload é definida pela especificação de cada Codec. O comprimento da TAG específica do Codec não é escrito no TAG WORD, pois para interpretar o Payload o codebook é necessário de qualquer forma.
- Um Codec com subformatos especifica o subformato com 1 WORD de TAG específica do Codec (Edge WORLD etc.).

## Ordem dos bytes {#바이트-순서}

- A serialização canônica é big-endian.
- Os campos de bits são dispostos a partir do bit mais significativo.
- Dentro de um WORD escreve-se primeiro o byte superior e, em valores de vários WORDs, primeiro o WORD superior.
- A representação em memória é livremente definida pela implementação.

## Kind (intervalo de seções) {#kind-섹션-구간}

| Seção | Kind | TAG ID | Definição |
|---|---|---|---|
| 0~2 | Reference | `0x000L~0x05FL` | Aponta um objeto. Identifica o objeto pelo Codec e pelo ID do objeto |
| 3·4 | Value | `0x060L~0x09FL` | Contém o próprio valor. O Codec determina a interpretação do Payload |
| 5~13 | Edge | `0x0A0L~0x1BFL` | Agrupa outros registros como componentes. O Codec determina o papel e a ordem dos componentes |
| 14·15 | Meta | `0x1C0L~0x1FFL` | Fala sobre o documento e os registros |

- O Kind é determinado por um único intervalo de seções: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, o restante Meta. Não há exceções.

- O Kind é uma propriedade imutável do Codec. Um Codec, uma vez atribuído, não muda de Kind.
- Value e Edge têm o mesmo formato «Codec + Payload». Apenas o Edge tem outros registros como componentes.
- Reference divide em tabelas de código os marcadores, os ponteiros, o sistema 5Q e REFERENCE-ISSUER. A quantificação está no código do sistema. A quantificação de REFERENCE-ISSUER é definida pelo documento do Issuer ([Reference](reference/_index.md)).

## Length (4 bits) {#length-4비트}

Length é o **número total de WORDs** que o registro ocupa. Inclui o TAG WORD, as TAGs de extensão, o Payload e o preenchimento do último WORD.

| Valor | Significado |
|---|---|
| `0000`~`1101` | 1~14 WORD (valor + 1) |
| `1110` | Comprimento estendido 1: o número total de WORDs no 1 WORD seguinte (15~65.535) |
| `1111` | Comprimento estendido 2: o número total de WORDs nos 2 WORD seguintes (65.536~2³²−1) |

- De 1 a 14 WORD, deve-se sempre escrever o comprimento diretamente. Uma notação mais larga não é a forma canônica.
- O número total de WORDs do comprimento estendido inclui a própria TAG de extensão de Length.
- Não há registros maiores que 2³²−1 WORD.
- Um registro de 1 WORD é apenas o TAG WORD, sem Payload. Só se usa quando a especificação do Codec permite (por exemplo, Meta `BODY`, `END`, sequência de bytes vazia, marcador de posição).
- Mesmo sem o codebook, é possível saltar registros com `posição do próximo registro = início do registro atual + Length`.

## Codec (seção e C, 9 bits) {#codec-섹션과-c-9비트}

| TAG ID | Nome | Significado |
|---|---|---|
| Início de cada zona de Kind | Código direto | O Codec é determinado apenas pelo TAG WORD |
| `0x05DL`, `0x09DL`, `0x1BDL` | REFERENCE-ISSUER-2WORD, VALUE-ISSUER-2WORD, EDGE-ISSUER-2WORD | Issuer de 2 WORD e número de Codec de 2 WORD na TAG de extensão de Codec |
| `0x05EL`, `0x09EL`, `0x1BEL` | REFERENCE-ISSUER-4WORD, VALUE-ISSUER-4WORD, EDGE-ISSUER-4WORD | Issuer de 4 WORD e número de Codec de 2 WORD na TAG de extensão de Codec |
| `0x05FL`, `0x09FL`, `0x1BFL` | REFERENCE-ISSUER-16WORD, VALUE-ISSUER-16WORD, EDGE-ISSUER-16WORD | Issuer de 16 WORD e número de Codec de 2 WORD na TAG de extensão de Codec |

- **As três últimas posições de cada zona de Kind são ISSUER.** A largura do Issuer são os 2 bits inferiores de C (`01` 2 WORD, `10` 4 WORD, `11` 16 WORD). Meta não tem formato Issuer.
- O `C` do código direto é independente em cada seção. Mesmo com o mesmo valor de `C`, seções diferentes são Codecs diferentes. O Codec ID de um código direto é o TAG WORD inteiro (L=0), e por isso contém o Kind.
- O número de Codec de Issuer é um único espaço por Issuer, independentemente do Kind. O Issuer o atribui de modo que não se repita dentro do seu `codecs/` ([endereço de publicação e lista de versões](publishing.md#id-표기)).
- Um Codec que não é código direto é um par `(Issuer, número de Codec)`. O número de Codec é definido por esse Issuer ([Issuer e publicação](issuer.md)). Formatos de extensão ficam sob o Issuer do organismo que os normalizou.
- Um Codec que tem código direto não é registrado separadamente como formato de Issuer.
- Os formatos de Issuer existem em Reference, Value e Edge. Meta é uma especificação comum definida apenas pelo GEUL.
- A seção do código direto de Edge (`w >> 9`) é a família. Nos códigos diretos de Value e em Meta, a família e a classe não são expressas em bits. O significado do número de Codec é definido pelo Issuer.
- Códigos diretos não podem ser recuperados. Apenas formatos de frequência confirmada ficam em código direto.

## Registro de formato Issuer {#issuer-형식-레코드}

```
TAG WORD          código ISSUER (as três últimas posições de cada zona de Kind)
[TAG de extensão de Length]
Issuer            2/4/16 WORD (o Codec determina a largura)
número de Codec   2 WORD. Definido pelo Issuer
Payload           Determinado pelo documento de Codec emitido pelo Issuer
```

- O layout é o mesmo para os três Kinds. Se os números não bastarem, obtém-se mais um Issuer.
- O Payload de Edge (EDGE-ISSUER) começa com o Edge Id, como os demais Edges. Assim, a ordem é TAG, Issuer, número de Codec, Edge Id e o restante do Payload.
- Um decodificador que não conhece o formato sabe até o Issuer e o número de Codec e salta pelo Length.

## Sequência de bytes de comprimento variável {#가변-길이-바이트열}

Para valores cujo comprimento é em bytes, como texto, URI, tag de idioma e sequência de bytes desconhecida, atribui-se o Codec (ou o número de Codec) em **pares par/ímpar**.

- Se o bit menos significativo do Codec (para código direto, o bit menos significativo de C) é `0`, o número de bytes é par; se é `1`, é ímpar.
- Número de bytes = `2 × número de WORDs do Payload − bit menos significativo`. Não há campo Byte Count.
- Se for ímpar, o byte inferior do último WORD é preenchimento `0x00`. Se não for `0x00`, rejeita-se.
- Uma sequência de bytes vazia é um registro de 1 WORD (apenas o TAG WORD) do Codec par.
- Valores de tamanho fixo, como UUID, digest e endereço, não têm par.

## Exemplo: ler um TAG WORD {#예-tag-word-읽기}

Vamos ler `0AA9`.

```
0x0AA9 = 0000 1010 1010 1001
         000 | 0101 | 01010 | 1001
Prefix 000, seção 0101(5, Edge), C 01010, Codec 0x0AAL(TRIPLE), Length 1001(10 WORD)
```

Este registro é um Edge de 10 WORD e o Codec é TRIPLE. Mesmo sem o codebook, sabe-se que o próximo registro está 10 WORD adiante.

## Marcadores de posição {#자리-표지}

Os TAG WORD `0x0000`, `0x0010` e `0x0020` são registros de 1 WORD de marcadores de posição de Reference. Não apontam um objeto, apenas preenchem a posição de um campo do registro ([marcadores de posição](slot-marker.md)).

```
0x0000, 0x0010, 0x0020 = 0000 0000 00CC 0000
                         Prefix 000, seção 0(Reference), C 0~2, LLLL 0000(1 WORD)
```

| WORD | Nome | Significado | Sobre o que fala | Lógica | Pressuposto de mundo | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | Não escrito | O documento: esta posição não foi preenchida | Sem asserção | Mundo aberto | sem snak |
| `0x0010` | UNKNOWN-VALUE | Desconhecido | O mundo: há um valor. Não se sabe qual | `∃x. P(s, x)` | Existência fechada, identidade aberta | `somevalue` |
| `0x0020` | NO-VALUE | Inexistente | O mundo: não há valor | `¬∃x. P(s, x)` | Fechado para (s, P, condição de qualificação) | `novalue` |

- Exemplo: se os filhos (P40) são ABSENT, não se sabe quantos são; se UNKNOWN-VALUE, são um ou mais; se NO-VALUE, são zero. Se o instante de término (P582) é ABSENT, não se sabe se ainda é válido; se UNKNOWN-VALUE, terminou mas não se sabe quando; se NO-VALUE, não terminou.
- O marcador só é válido se a lista de CODEC do campo tiver esse WORD exatamente. É invalid em curingas, em campos sem CODEC, nas posições de registro de HEAD e BODY e na posição do Edge Id ([CODEC](edge/0x0BEL-codec.md)).
- Obrigações de quem lê:
  1. UNKNOWN-VALUE não é um valor, mas uma asserção de existência. Não é igual nem diferente de nenhum valor, e dois UNKNOWN-VALUE também não são vistos como o mesmo valor. Um TRIPLE que contém UNKNOWN-VALUE não é mesclado como duplicado.
  2. NO-VALUE fecha-se dentro da condição de qualificação dessa proposição. Se coexistir com um TRIPLE de valor de mesmo Subject, Predicate e rank sem condição de qualificação distinguível, é uma contradição, e o verificador avisa (não rejeita).
  3. O rank se aplica igualmente. Ao escolher o valor representativo (truthy), os TRIPLEs dos dois marcadores também são candidatos.
  4. Quando usado como valor de QUALIFIER, muda o sentido dessa qualificação (`P582 = UNKNOWN`: terminou, instante desconhecido. `P582 = NONE`: não terminou).
  5. ABSENT não diz nada sobre o mundo. Um valor que não foi possível transferir não é escrito como UNKNOWN-VALUE.

## Forma canônica {#정규형}

O mesmo conteúdo deve resultar nos mesmos bytes. Só assim o hash de conteúdo e a assinatura ficam determinados de forma única.

- O comprimento usa a notação mais curta (de 1 a 14 WORD, comprimento direto).
- Inteiros são escritos com a menor largura. Segue-se a forma canônica definida pela especificação de cada Codec.
- Registros que não estão na forma canônica são rejeitados.
- Exceção: o `L=1111` do WORD de destino de [CODEC](edge/0x0BEL-codec.md) considera apenas a seção `KKKK`, independentemente do valor de `C`. Recomenda-se a primeira posição da seção (`C = 0`), e outro `C` da mesma seção não é rejeitado.
