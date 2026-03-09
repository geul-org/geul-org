---
title: "Quantity Node"
weight: 70
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "quantity", "SI", "currency"]
summary: "Node de comprimento variável de 4 a 7 palavras que representa grandezas físicas, valores numéricos, moedas e literais. Codifica unidades base/derivadas do SI, moedas e literais especiais com 6 bits de Unit, e prefixos SI com 4 bits de Scale."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Quantity Node é um tipo de Node de comprimento variável que representa **grandezas físicas, valores numéricos, moedas e literais**.

| Característica | Descrição |
|----------------|-----------|
| **Comprimento variável** | 4~N palavras (conforme tamanho do valor) |
| **Unidade explícita** | SI base/derivado + não-SI (moeda, tempo, etc.) |
| **Suporte de escala** | Prefixo como potência de 10 |
| **Literais especiais** | Tempo (timestamp), string (UTF-16), cor (RGBA) |
| **TID no final** | Característica de Node (consistência com [Entity](../entity-node/)) |

**Usos:** Object do [Triple Edge](../triple-edge/), participante do Verb Edge, participante do [Event6](../event6-edge/), nome/rótulo de entidade, representação temporal, etc.

## Estrutura do pacote

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │       Unit         │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌──────┬──────┬──────┬────────────────────┐
│ Sign │ Size │ Type │      Scale         │
│ 1bit │ 2bit │ 1bit │       4bit         │
├──────┴──────┴──────┴────────────────────┤
│              Reserved (8bit)            │
└─────────────────────────────────────────┘

3rd+ WORD: Value (variável, 1/2/4 palavras conforme Size)

Last WORD (16 bits)
┌─────────────────────────────────────────┐
│                  TID                    │
│                 16bit                   │
└─────────────────────────────────────────┘
```

| Campo | Bits | Tamanho | Descrição |
|-------|------|---------|-----------|
| Prefix | 1-10 | 10 | `0001 000 010` (Quantity Node) |
| Unit | 11-16 | 6 | 64 códigos de unidade |
| Sign | 17 | 1 | 0=positivo, 1=negativo |
| Size | 18-19 | 2 | Número de palavras do Value |
| Type | 20 | 1 | 0=inteiro, 1=ponto flutuante |
| Scale | 21-24 | 4 | Potência de 10 (offset 8) |
| Reserved | 25-32 | 8 | Reservado (código de moeda quando é divisa) |

### Tamanho do pacote por Size

| Size | Palavras do Value | Total de palavras |
|------|-------------------|-------------------|
| 00 | 1 (16 bits) | 4 |
| 01 | 2 (32 bits) | 5 |
| 10 | 4 (64 bits) | 7 |

## Códigos de unidade (6 bits = 64)

### Unidades base SI (0x00~0x06)

| Código | Unidade | Símbolo | Grandeza |
|--------|---------|---------|----------|
| 0x00 | meter | m | Comprimento |
| 0x01 | kilogram | kg | Massa |
| 0x02 | second | s | Tempo |
| 0x03 | ampere | A | Corrente elétrica |
| 0x04 | kelvin | K | Temperatura |
| 0x05 | mole | mol | Quantidade de substância |
| 0x06 | candela | cd | Intensidade luminosa |

### Unidades derivadas SI (0x07~0x1C)

| Código | Unidade | Símbolo | Grandeza |
|--------|---------|---------|----------|
| 0x07 | hertz | Hz | Frequência |
| 0x08 | newton | N | Força |
| 0x09 | pascal | Pa | Pressão |
| 0x0A | joule | J | Energia |
| 0x0B | watt | W | Potência |
| 0x0C | coulomb | C | Carga elétrica |
| 0x0D | volt | V | Tensão |
| 0x0E | farad | F | Capacitância |
| 0x0F | ohm | Ω | Resistência |
| 0x10 | siemens | S | Condutância |
| 0x11 | weber | Wb | Fluxo magnético |
| 0x12 | tesla | T | Campo magnético |
| 0x13 | henry | H | Indutância |
| 0x14 | celsius | °C | Temperatura |
| 0x15 | lumen | lm | Fluxo luminoso |
| 0x16 | lux | lx | Iluminância |
| 0x17 | becquerel | Bq | Radioatividade |
| 0x18 | gray | Gy | Dose absorvida |
| 0x19 | sievert | Sv | Dose equivalente |
| 0x1A | katal | kat | Atividade catalítica |
| 0x1B | radian | rad | Ângulo plano |
| 0x1C | steradian | sr | Ângulo sólido |

### Unidades não-SI (0x20~0x2F)

| Código | Unidade | Uso |
|--------|---------|-----|
| 0x20 | CURRENCY | Moeda (extensão de código de divisa) |
| 0x21 | percent | % (proporção) |
| 0x22 | degree | ° (ângulo) |
| 0x23~0x28 | minute~year | Unidades de tempo |
| 0x29 | bit | Quantidade de informação |
| 0x2A | byte | Quantidade de informação |
| 0x2B~0x2F | COUNT~INDEX | Valores sem unidade |

### Literais especiais (0x30~0x3F)

| Código | Tipo | Payload | Uso |
|--------|------|---------|-----|
| 0x30 | TIMESTAMP_SEC | 2/4 palavras | Timestamp Unix (segundos) |
| 0x31 | TIMESTAMP_MS | 4 palavras | Timestamp Unix (milissegundos) |
| 0x32 | UTF16 | 2+N palavras | String UTF-16 |
| 0x33 | RGBA | 2 palavras | Cor (32 bits) |

## Scale (4 bits)

Potência de 10. Aplica-se um offset de 8. **Cálculo:** `valor real = Value × 10^(Scale - 8)`

| Código | Valor | Prefixo | Código | Valor | Prefixo |
|--------|-------|---------|--------|-------|---------|
| 0000 | 10⁻⁸ | - | 1000 | **10⁰ (base)** | - |
| 0010 | 10⁻⁶ | μ | 1001 | 10¹ | da |
| 0101 | 10⁻³ | m | 1011 | 10³ | k |
| 0110 | 10⁻² | c | 1110 | 10⁶ | M |

## Extensão de moeda (Unit = 0x20)

Quando é CURRENCY, os 8 bits Reserved são usados como código de divisa.

| Código | Moeda | ISO | Código | Moeda | ISO |
|--------|-------|-----|--------|-------|-----|
| 0x00 | Dólar americano | USD | 0x05 | Won coreano | KRW |
| 0x01 | Euro | EUR | 0x06 | Franco suíço | CHF |
| 0x02 | Iene japonês | JPY | 0x07 | Dólar australiano | AUD |
| 0x03 | Libra esterlina | GBP | 0x08 | Dólar canadense | CAD |
| 0x04 | Yuan chinês | CNY | 0x80 | Bitcoin | BTC |

## Exemplos

### "100kg" → 4 palavras

```
1st: [Prefix] + [0x01(kg)]
2nd: +, 1 palavra, int, ×1     → 0x0800
3rd: 0x0064 (100)
4th: TID
Interpretação: +100 × 10⁰ kg = 100kg
```

### "$2.500.000" → 4 palavras (uso de escala)

```
1st: [Prefix] + [0x20(CURRENCY)]
2nd: +, 1 palavra, int, ×10³, USD  → 0x0B00
3rd: 0x09C4 (2500)
4th: TID
Interpretação: +2500 × 10³ USD = $2,500,000
```
