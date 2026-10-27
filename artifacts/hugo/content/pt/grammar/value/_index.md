---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value é um registro que contém o próprio valor. Os 2 bits superiores do Codec são a família (números e decimais, tempo, texto, binário); os formatos de uso frequente são códigos diretos e os demais ficam em formatos Issuer das entidades de normalização."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value é um registro que contém o próprio valor. O Codec determina a interpretação do Payload.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC
[TAG estendida de Length]
[TAG estendida de Codec]  no formato Issuer
Payload
```

- `LLLL` é o número total de WORDs, incluindo a TAG WORD, menos 1. De 1 a 14 WORD é comprimento direto; de 15 WORD em diante, comprimento estendido.
- No formato Issuer, a TAG estendida de Codec contém o Issuer (largura 1/2/4/16 WORD determinada pelo Codec) e 1 WORD de número de formato. Os 2 bits superiores do número de formato são a família.
- O decodificador conhece a família e o Length mesmo sem conhecer o formato.

## Famílias

Os 2 bits superiores do Codec são a família. O código direto (7 bits) e o número de formato do Issuer (16 bits) seguem a mesma regra. Assim a família é conhecida sem codebook.

| 2 bits superiores | Família | Código direto | Número de formato |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL se dividem de novo pelo terceiro bit. `000` é NUMERIC e `001` é DECIMAL.
- Valores numéricos como vetores, tensores, números complexos, frações e intervalos são NUMERIC. Como exceção, BIT-VECTOR é BINARY. Os códigos de idioma são TEXT.
- Os registros de formato Issuer levam a TAG estendida de Codec (Issuer e número de formato). Se o Payload for longo (15 WORD ou mais no total), usa-se a TAG estendida de Length.

## Códigos diretos

| Codec | Nome | Família | Descrição |
|---|---|---|---|
| `0x00` | [BOOL](/pt/grammar/value/numeric/bool/) | NUMERIC | false ou true |
| `0x01` | [SIGNED-INTEGER](/pt/grammar/value/numeric/signed-integer/) | NUMERIC | Inteiro em complemento de dois no mínimo de WORDs |
| `0x02` | [UNSIGNED-INTEGER](/pt/grammar/value/numeric/unsigned-integer/) | NUMERIC | Inteiro sem sinal no mínimo de WORDs |
| `0x03` | [BINARY-FLOAT](/pt/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/pt/grammar/value/numeric/coordinate-earth/) | NUMERIC | Latitude e longitude na Terra (WGS 84) e incerteza (Reference da unidade) |
| `0x05` | [COORDINATE-GEO](/pt/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference de corpo celeste, latitude, longitude e incerteza (Reference da unidade) |
| `0x06` | [QUANTITY](/pt/grammar/value/numeric/quantity/) | NUMERIC | Quantidade numérica (inteiro, BINARY-FLOAT, decimal, fração), Reference da unidade, limite inferior e superior |
| `0x07` | [FRACTION](/pt/grammar/value/numeric/fraction/) | NUMERIC | Fração que preserva a notação (registros de numerador e denominador, sem simplificar) |
| `0x10` | [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`, coeficiente com sinal |
| `0x11` | [UNSIGNED-DECIMAL](/pt/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`, coeficiente sem sinal |
| `0x20` | [GREGORIAN-DATE](/pt/grammar/value/time/gregorian-date/) | TIME | Número de dias desde 1970-01-01 (calendário gregoriano) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/pt/grammar/value/time/civil-time-nanoseconds/) | TIME | Nanossegundos desde a meia-noite |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/pt/grammar/value/time/posix-timestamp-seconds/) | TIME | Segundos desde a epoch Unix |
| `0x23` | [DURATION-SECONDS](/pt/grammar/value/time/duration-seconds/) | TIME | Tempo decorrido (segundos) |
| `0x24`/`0x25` | [EDTF](/pt/grammar/value/time/edtf/) | TIME | Cadeia de data estendida ISO 8601-2 (precisão de ano e mês, incerteza, intervalo) |
| `0x26`/`0x27` | [GEDCOM-DATE](/pt/grammar/value/time/gedcom-date/) | TIME | Cadeia de data GEDCOM 7 (outros calendários, como o juliano) |
| `0x40`/`0x41` | [UTF8-TEXT](/pt/grammar/value/text/utf8-text/) | TEXT | Cadeia UTF-8 sem idioma |
| `0x44`/`0x45` | [URI](/pt/grammar/value/text/uri/) | TEXT | URI da RFC 3986 |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/pt/grammar/value/text/language-bcp47-code/) | TEXT | Language tag BCP 47 |
| `0x48` | [LANGUAGE-SHORT-CODE](/pt/grammar/value/text/language-short-code/) | TEXT | Código de idioma comprimido de 1 WORD |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/) | TEXT | Texto com idioma |
| `0x60` | [UUID](/pt/grammar/value/binary/uuid/) | BINARY | UUID da RFC 9562 |
| `0x61` | [SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/) | BINARY | Resultado SHA-256 |
| `0x62` | [SHA1-DIGEST](/pt/grammar/value/binary/sha1-digest/) | BINARY | Resultado SHA-1 (apenas para identificação, como IDs de objetos git) |

- Os códigos em pares par/ímpar são sequências de bytes de comprimento variável. O código par tem número par de bytes e o código ímpar, número ímpar ([Registro e TAG WORD](/pt/grammar/record/)).
- Os códigos diretos que não estão na tabela são reservados.

## Formatos Issuer

Os formatos que não estão nos códigos diretos ficam sob o Issuer da entidade que normatizou o formato, com um número de formato. Os formatos por convenção, sem entidade normativa, ficam sob ADHOC (`0x0001`), e os formatos próprios do GEUL sob GEUL (`0x0000`).

| Issuer | Exemplos de formato |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, vetores de inteiros e reais, tensores, complexos, frações, intervalos, quaternions, BLAKE3 |
| IETF `0x0020` | URI relativa, CRC32C, endereços IPv4 e IPv6 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, timestamp POSIX em nanossegundos, endereço MAC |
| KHRONOS `0x0041` | pixels RGBA8 e BGRA8 |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | timestamp TAI |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | timestamp GPS |

- Um decodificador que não conhece o formato sabe só a família do número de formato e pula o Payload.
- Para valores grandes, como imagens e vídeos, recomenda-se referenciá-los por URI e SHA-256, em vez de embuti-los.
- As obras contidas na sequência de bytes seguem a sua licença original. A origem e a licença registram-se com Meta.

## Conjuntos de formatos

O layout, a interpretação, a validade e os exemplos de cada formato estão nos documentos de cada conjunto.

| Conjunto | Família | Formatos |
|---|---|---|
| [numeric](/pt/grammar/value/numeric/) | NUMERIC | BOOL, inteiros, ponto flutuante, coordenadas, QUANTITY, FRACTION |
| [decimal](/pt/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/pt/grammar/value/time/) | TIME | data, hora, timestamp, tempo decorrido, EDTF, data GEDCOM |
| [text](/pt/grammar/value/text/) | TEXT | texto UTF-8, texto com idioma, URI, códigos de idioma |
| [binary](/pt/grammar/value/binary/) | BINARY | UUID, digest, CRC, endereços de rede, sequência de bytes desconhecida, bit vector |
| [vector](/pt/grammar/value/vector/) | NUMERIC | vetores densos de inteiros e reais, pontos e caixas delimitadoras, pixels RGBA e BGRA |
| [tensor](/pt/grammar/value/tensor/) | NUMERIC | tensores dense e packed com formato, rank e shape |
| [etc](/pt/grammar/value/etc/) | NUMERIC | complexos, frações, intervalos fechados, quaternions |

- Os conjuntos vector, tensor e etc são todos formatos Issuer (ADHOC, KHRONOS) da família NUMERIC.

## Texto

Um texto com idioma e um texto sem idioma são valores diferentes. "Paris" (cadeia) e "Paris" (francês) não são iguais.

| Formato | Onde se usa |
|---|---|
| UTF8-TEXT | cadeias sem idioma, como identificadores, códigos, nomes de arquivo e IDs externos |
| UTF8-LANGUAGE-TEXT | textos com idioma, como nomes, títulos e frases |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = o texto tem número ímpar de bytes)
[TAG estendida de Length]
Idioma            registro LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE
Texto             bytes UTF-8 (se ímpar, 0x00 no final)
```

- O texto é UTF-8 bem formado e preservado tal como o original. A normalização fica a cargo de quem compara e indexa.
- Um nome comum a vários idiomas escreve-se com o idioma `mul`, e um idioma indefinido com `und`. Uma cadeia sem conteúdo de idioma é UTF8-TEXT.

Exemplo: `"Douglas Adams"@en` (13 bytes, ímpar)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   idioma en  D o  u g  l a  s ␠  A d  a m  s (preenchimento)
```

## Decimais e quantidades

Um decimal exato escreve-se como `C × 10^E`. O expoente `E` é de 32 bits e o coeficiente `C` é em complemento de dois no mínimo de WORDs. Guarda-se tal como está o número de dígitos da notação original: `1.20` é `C=120, E=−2` e `1.2` é `C=12, E=−1`. As duas notações representam o mesmo número, mas são registros distintos, com bytes diferentes. O codificador não normaliza a notação arbitrariamente. A equivalência de valor entre os dois registros e o significado de quantum (algarismos significativos) são questões em aberto ([SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/#questões-em-aberto)).

QUANTITY contém quantidade, unidade e limites num só valor.

```
TAG WORD          0000 1LLL L000 0110
[TAG estendida de Length]
Quantidade        registro Value numérico (inteiro, BINARY-FLOAT, decimal, fração)
Unidade           registro Reference (item de unidade); 0x0000 se não houver unidade
Limite inferior   registro Value numérico; 0x0000 ABSENT se omitido
Limite superior   registro Value numérico; 0x0000 ABSENT se omitido
```

- A unidade faz parte do valor. Não se separa a unidade para escrevê-la em outro lugar (separada, não se sabe se `652` é km ou m).
- Não se guarda o valor convertido para unidades SI. Pode ser calculado a partir da unidade e da tabela de conversão.
- `0x0000` é ABSENT, a marca de que se omitiu um campo opcional ([Documento de especificação de Codec](/pt/grammar/codec-spec/)).

Exemplo: `652 km`, faixa `[651, 653]` (km = Q828224 do Wikidata)

```
0F06 0011                    TAG (comprimento estendido de 17 WORD)
0990 0000 0000 028C          quantidade 652
0120 000C A340               unidade Q828224
0990 0000 0000 028B          limite inferior 651
0990 0000 0000 028D          limite superior 653
```

## Datas

| Precisão | Formato |
|---|---|
| data (calendário gregoriano) | GREGORIAN-DATE |
| ano e mês, incerta (`1971~`), intervalo | EDTF |
| notação original de outro calendário (juliano etc.) | GEDCOM-DATE |
| hora | timestamps POSIX, TAI e GPS |

- Uma data que se pode escrever como GREGORIAN-DATE não se escreve como EDTF.

## Questões em aberto

- Os formatos de mídia públicos (JPEG, PNG, MP4, MOV etc.) ficam como números de formato BINARY do Issuer IANA (`0x0021`). Como gerir a tabela de correspondência entre tipos de mídia e números de formato.
- A lista final de códigos diretos de Value. Decide-se medindo a frequência dos Values em amostras de legislação e de conversas de trabalho (candidatos: valores monetários, porcentagens, intervalos de datas).
- A especificação detalhada e a colocação dos 7 escalares pequenos (BFLOAT16 do ADHOC, 4 FP8 do ONNX, FP8-E8M0FNU e FP4-E2M1FN do OCP). Ainda não se decidiu se serão movidos para a faixa reservada dos códigos diretos NUMERIC (`0x08`~`0x0F`). Por ora, só foram atribuídos números de formato.
