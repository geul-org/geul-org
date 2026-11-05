---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value é o registro que contém o próprio valor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value é o registro que contém o próprio valor. O Codec define a interpretação do Payload.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      seções 3·4 (0x060L~0x09FL)
[TAG de extensão de Length]
[TAG de extensão de Codec]  quando é formato de Issuer
Payload
```

- `LLLL` é o número total de WORDs, incluindo o TAG WORD, menos 1. De 1 a 14 WORDs, é comprimento direto; com 15 WORDs ou mais, é comprimento estendido.
- No formato de Issuer, a TAG de extensão de Codec contém o Issuer (largura de 2/4/16 WORDs definida pelo Codec) e o número de Codec de 2 WORDs. O número de Codec é definido pelo Issuer.
- Mesmo sem conhecer o formato, o decodificador sabe até o Kind, o Length, o Issuer e o número de Codec.

## Famílias {#계열}

O número de um Value não indica a família. Os códigos diretos não expressam a família em bits, e o formato de Issuer também não tem regra de família. A família é um agrupamento por tema.

| Família | Códigos diretos |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- Valores numéricos como vetores, tensores, números complexos, frações e intervalos são NUMERIC. Como exceção, BIT-VECTOR é BINARY. Os códigos de idioma são TEXT.
- Os registros em formato de Issuer levam a TAG de extensão de Codec (Issuer e número de Codec). Se o Payload for longo (15 WORDs ou mais no total), usa-se a TAG de extensão de Length.

## Códigos diretos {#직접-코드}

| Codec | Nome | Família | Descrição |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false ou true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | inteiro em complemento de dois com o mínimo de WORDs |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | inteiro sem sinal com o mínimo de WORDs |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | latitude e longitude da Terra (WGS 84) e incerteza (Reference da unidade) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | Reference de corpo celeste, latitude e longitude, incerteza (Reference da unidade) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | quantidade numérica (inteiro, BINARY-FLOAT, decimal, fração), Reference da unidade, limites inferior e superior |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | fração que preserva a notação (registros de numerador e denominador, sem simplificar) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`, coeficiente com sinal |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`, coeficiente sem sinal |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | número de dias desde 1970-01-01 (calendário gregoriano) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | nanossegundos desde a meia-noite |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | segundos desde o Unix epoch |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | tempo decorrido (segundos) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | cadeia de data estendida ISO 8601-2 (precisão de ano e mês, incerteza, intervalo) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | cadeia de data GEDCOM 7 (outros calendários, como o juliano) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | cadeia UTF-8 sem idioma |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | URI da RFC 3986 |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | language tag BCP 47 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | texto com idioma |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | código de idioma comprimido de 1 WORD |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | UUID da RFC 9562 |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | resultado SHA-256 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | resultado SHA-1 (para identificação, como IDs de objetos git) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | sequência de bytes de significado e formato desconhecidos. Bytes pares·ímpares |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | N bits armazenados em MSB-first depois do bit-count |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | tempo decorrido (nanossegundos) |

- Os códigos emparelhados em par/ímpar são sequências de bytes de comprimento variável. O código par é o de valores com número par de bytes, e o ímpar, o de valores com número ímpar ([Registro e TAG WORD](../record.md)).
- Os códigos diretos ocupam `0x060L~0x081L` sem Reserved. `0x082L~0x09CL` são Reserved, e `0x09DL~0x09FL` são [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md).

## Formato de Issuer {#issuer-형식}

Um formato que não está nos códigos diretos fica sob o Issuer da entidade que o estabeleceu, com um número de Codec. Os formatos por convenção, sem entidade que os estabeleça, ficam sob ADHOC (`0x00000002`). Os formatos próprios de GEUL (OPAQUE-BYTES, BIT-VECTOR, DURATION-NANOSECONDS) são códigos diretos.

| Issuer | Exemplos de formato |
|---|---|
| ADHOC `0x00000002` | BFLOAT16, vetores de inteiros e de reais, tensores, números complexos, frações, intervalos, quaternions, BLAKE3 |
| IETF `0x00000007` | URI relativo, CRC32C, endereços IPv4·IPv6 |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128, timestamp POSIX em nanossegundos, endereço MAC |
| KHRONOS `0x0000000E` | pixels RGBA8·BGRA8 |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | timestamp TAI |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | timestamp GPS |

- Um decodificador que não conhece o formato sabe até o Issuer e o número de Codec e salta o resto pelo Length.
- O documento de Codec fica em `codecs/` do Issuer, com o número de Codec do registro. Exemplo: o CRC32C da IETF é `0x00000007/codecs/0x0000C000/` ([Endereço de publicação e lista de versões](../publishing.md)).
- Para valores grandes, como imagens e vídeos, recomenda-se referenciá-los por URI e SHA-256 em vez de colocá-los diretamente.
- As obras contidas na sequência de bytes seguem sua licença original. A procedência e a licença são registradas em Meta.

## Grupos de formatos {#형식-묶음}

A descrição de cada grupo está abaixo. O layout, a interpretação, a validade e os exemplos de cada formato estão no documento de cada formato.

| Grupo | Família | Formatos |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL, inteiros, ponto flutuante, coordenadas, QUANTITY, FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | data, hora, timestamp, tempo decorrido, EDTF, data GEDCOM |
| [text](#text) | TEXT | texto UTF-8, texto com idioma, URI, código de idioma |
| [binary](#binary) | BINARY | UUID, digest, CRC, endereço de rede, sequência de bytes desconhecida, vetor de bits |
| [vector](#vector) | NUMERIC | vetores densos de inteiros e de reais, pontos e caixas delimitadoras, pixels RGBA·BGRA |
| [tensor](#tensor) | NUMERIC | tensores dense·packed com formato, rank e shape |
| [etc](#etc) | NUMERIC | números complexos, frações, intervalos fechados, quaternions |

- Os grupos vector, tensor e etc são todos formatos de Issuer (ADHOC, KHRONOS) da família NUMERIC.

### numeric {#numeric}

São os formatos numéricos básicos da família NUMERIC. Ficam nos códigos diretos `0x060L~0x067L`.

- Há BOOL, inteiros com e sem sinal, ponto flutuante binary do IEEE 754, coordenadas da Terra (WGS 84) e de corpos celestes, QUANTITY, que reúne quantidade, unidade e limites, e FRACTION, uma fração na notação original.
- Os inteiros escrevem-se com o mínimo de WORDs em que o valor cabe.
- Os formatos de Issuer escalares pequenos (BFLOAT16, FP8, FP4) só têm número de Codec atribuído e não têm especificação detalhada (problema em aberto de [Value](#열린-문제)).
- Vetores, tensores, números complexos, frações irredutíveis (RATIONAL-I64) e intervalos também são da família NUMERIC, mas, por serem formatos de Issuer, ficam nos grupos [vector](#vector), [tensor](#tensor) e [etc](#etc).

### decimal {#decimal}

A família DECIMAL reúne os formatos decimais exatos. Ficam nos códigos diretos `0x068L~0x069L`.

- Os códigos diretos SIGNED-DECIMAL e UNSIGNED-DECIMAL escrevem-se como `C × 10^E` e contêm tal como estão as casas da notação original. `1.20` (`C=120, E=−2`) e `1.2` (`C=12, E=−1`) são registros diferentes. A equivalência de valor e a preservação do quantum são problemas em aberto de [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제).
- As codificações DPD·BID do IEEE 754 decimal32/64/128 são formatos do Issuer IEEE (`0x0000000D`).

### time {#time}

A família TIME reúne os formatos de data e hora. Ficam nos códigos diretos `0x06AL~0x071L` e `0x081L` (DURATION-NANOSECONDS).

| Precisão | Formato |
|---|---|
| Data (calendário gregoriano) | GREGORIAN-DATE |
| Ano e mês, incerteza, intervalo | EDTF |
| Notação original de outros calendários (juliano etc.) | GEDCOM-DATE |
| Hora | timestamps POSIX·TAI·GPS |
| Tempo decorrido | DURATION-SECONDS, DURATION-NANOSECONDS |

- Uma data que pode ser escrita com GREGORIAN-DATE não se escreve com EDTF.
- Os timestamps em nanossegundos e os formatos TAI·GPS são formatos sob os Issuers das respectivas entidades de normalização (IEEE, BIPM, GPS).

### text {#text}

A família TEXT reúne os formatos de texto e de identificadores em cadeia. Ficam nos códigos diretos `0x072L~0x07AL`.

- Uma cadeia sem idioma é UTF8-TEXT, e um texto com idioma, como nome, título ou frase, é UTF8-LANGUAGE-TEXT.
- Os códigos de idioma (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) também são da família TEXT.
- As sequências de bytes de comprimento variável usam pares de Codec par/ímpar. Se o bit menos significativo é `1`, o número de bytes é ímpar e o byte baixo do último WORD é padding `0x00` ([Registro e TAG WORD](../record.md)).

### binary {#binary}

A família BINARY reúne os formatos de sequências de bytes. Ficam nos códigos diretos `0x07BL~0x080L`.

- UUID, SHA-256, SHA-1, a sequência de bytes desconhecida (OPAQUE-BYTES) e o vetor de bits (BIT-VECTOR) são códigos diretos. Os demais digests, CRC32C e os endereços IPv4·IPv6·MAC são formatos de Issuer.
- Os valores de tamanho fixo (UUID, digest, endereço) têm tamanho determinado e não têm par par/ímpar.
- A mídia pública, como imagens e vídeos, fica como formato do Issuer IANA (`0x00000008`). Os números de Codec são atribuídos em pares par/ímpar e o Payload é uma sequência de bytes. O limite superior de Length é 2^32−1 WORDs. Para valores grandes, recomenda-se referenciá-los por URI e SHA-256 em vez de colocá-los diretamente.
- As obras contidas na sequência de bytes seguem sua licença original. A procedência e a licença são registradas em Meta.

### vector {#vector}

Os formatos de vetor são formatos de Issuer da família NUMERIC. Os vetores densos de inteiros e de reais e os pontos e caixas delimitadoras ficam sob ADHOC (`0x00000002`), números de Codec `0x00000500`~`0x0000050C`, e os formatos de pixel, sob KHRONOS (`0x0000000E`).

- Os elementos de um vetor denso são armazenados contiguamente em big-endian.
- Por serem formatos de Issuer, a TAG de extensão de Codec leva o Issuer de 2 WORDs e o número de Codec de 2 WORDs.

### tensor {#tensor}

Os formatos de tensor são formatos de Issuer da família NUMERIC. Ficam sob ADHOC (`0x00000002`), números de Codec `0x00000600`~`0x00000601`.

- DESCRIBED-DENSE-TENSOR contém o formato dos elementos, o rank, o shape e um payload dense C-contiguous.
- DESCRIBED-PACKED-TENSOR contém o formato packed, o rank, o shape e um payload packed em low-bit-first dentro do octeto.

### etc {#etc}

Os demais formatos numéricos são formatos de Issuer da família NUMERIC. Ficam sob ADHOC (`0x00000002`), números de Codec `0x00000700`~`0x00000704`.

- Há números complexos (COMPLEX64, COMPLEX128), fração normalizada (RATIONAL-I64), intervalo fechado binary64 e quaternion binary32.

## Texto {#텍스트}

Um texto com idioma e um texto sem idioma são valores diferentes. "Paris" (cadeia) e "Paris" (em francês) não são iguais.

| Formato | Onde se usa |
|---|---|
| UTF8-TEXT | cadeias sem idioma, como identificadores, códigos, nomes de arquivo e IDs externos |
| UTF8-LANGUAGE-TEXT | textos com idioma, como nomes, títulos e frases |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = texto com número ímpar de bytes)
[TAG de extensão de Length]
Idioma            registro LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE
Texto             bytes UTF-8 (se ímpar, 0x00 no final)
```

- O texto é UTF-8 bem formado (well-formed) e é preservado como no original. A normalização cabe a quem compara ou indexa.
- Um nome comum a vários idiomas escreve-se com o idioma `mul`, e um idioma indeterminado com `und`. Uma cadeia sem conteúdo linguístico é UTF8-TEXT.

Exemplo: `"Douglas Adams"@en` (13 bytes, ímpar)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   idioma en  D o  u g  l a  s ␠  A d  a m  s (padding)
```

## Decimais e quantidades {#10진수와-수량}

Um decimal exato escreve-se como `C × 10^E`. O expoente `E` tem 32 bits e o coeficiente `C` é complemento de dois com o mínimo de WORDs. Contém tal como estão as casas da notação original: `1.20` é `C=120, E=−2` e `1.2` é `C=12, E=−1`. As duas notações representam o mesmo número, mas são registros distintos, com bytes diferentes. O codificador não normaliza arbitrariamente a notação. A equivalência de valor dos dois registros e o significado do quantum (algarismos significativos) são problemas em aberto ([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

QUANTITY contém quantidade, unidade e limites num só valor.

```
TAG WORD          0000 0110 0110 LLLL
[TAG de extensão de Length]
Quantidade        registro Value numérico (inteiro, BINARY-FLOAT, decimal, fração)
Unidade           registro Reference (item da unidade); se sem unidade, 0x0000
Limite inferior   registro Value numérico; se omitido, 0x0000 ABSENT
Limite superior   registro Value numérico; se omitido, 0x0000 ABSENT
```

- A unidade faz parte do valor. Não se separa a unidade para escrevê-la noutro lugar (separada, não se saberia se `652` é km ou m).
- O valor convertido para unidades SI não é contido. Pode ser calculado a partir da unidade e da tabela de conversão.
- `0x0000` é a marca ABSENT, que indica que um campo opcional foi omitido ([Documento de especificação de Codec](../codec-spec.md)).

Exemplo: `652 km`, intervalo `[651, 653]` (km = Q828224 do Wikidata)

```
066E 0011                    TAG (comprimento estendido de 17 WORDs)
0683 0000 0000 028C          quantidade 652
0142 000C A340               unidade Q828224
0683 0000 0000 028B          limite inferior 651
0683 0000 0000 028D          limite superior 653
```

## Datas {#날짜}

| Precisão | Formato |
|---|---|
| Data (calendário gregoriano) | GREGORIAN-DATE |
| Ano e mês, incerteza (`1971~`), intervalo | EDTF |
| Notação original de outros calendários (juliano etc.) | GEDCOM-DATE |
| Hora | timestamps POSIX·TAI·GPS |

- Uma data que pode ser escrita com GREGORIAN-DATE não se escreve com EDTF.

## Problemas em aberto {#열린-문제}

- Os formatos de mídia pública (JPEG, PNG, MP4, MOV etc.) ficam como números de Codec do Issuer IANA (`0x00000008`). Como gerir a tabela de correspondência entre tipo de mídia e número de Codec.
- A lista final dos códigos diretos de Value. Será definida medindo a frequência de Values em amostras de leis e de conversas de trabalho (candidatos: valores monetários, percentuais, intervalos de datas).
- A especificação detalhada e a disposição dos 7 escalares pequenos (ADHOC BFLOAT16, 4 FP8 da ONNX, OCP FP8-E8M0FNU·FP4-E2M1FN). Ainda não se decidiu se serão movidos para códigos diretos. Por ora só têm número de Codec atribuído.
