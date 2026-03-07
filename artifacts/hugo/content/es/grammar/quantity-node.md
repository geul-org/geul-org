---
title: "Quantity Node"
weight: 70
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "quantity", "SI", "currency"]
summary: "Node de longitud variable de 4 a 7 palabras que representa magnitudes físicas, valores numéricos, monedas y literales. Codifica unidades base/derivadas del SI, monedas y literales especiales con 6 bits de Unit, y prefijos SI con 4 bits de Scale."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Quantity Node es un tipo de Node de longitud variable que representa **magnitudes físicas, valores numéricos, monedas y literales**.

| Característica | Descripción |
|----------------|-------------|
| **Longitud variable** | 4~N palabras (según tamaño del valor) |
| **Unidad explícita** | SI base/derivado + no-SI (moneda, tiempo, etc.) |
| **Soporte de escala** | Prefijo como potencia de 10 |
| **Literales especiales** | Tiempo (timestamp), cadena (UTF-16), color (RGBA) |
| **TID al final** | Característica de Node (consistencia con [Entity](../entity-node/)) |

**Usos:** Object de [Triple Edge](../triple-edge/), participante de Verb Edge, participante de [Event6](../event6-edge/), nombre/etiqueta de entidad, representación temporal, etc.

## Estructura de paquete

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

3rd+ WORD: Value (variable, 1/2/4 palabras según Size)

Last WORD (16 bits)
┌─────────────────────────────────────────┐
│                  TID                    │
│                 16bit                   │
└─────────────────────────────────────────┘
```

| Campo | Bits | Tamaño | Descripción |
|-------|------|--------|-------------|
| Prefix | 1-10 | 10 | `0001 000 010` (Quantity Node) |
| Unit | 11-16 | 6 | 64 códigos de unidad |
| Sign | 17 | 1 | 0=positivo, 1=negativo |
| Size | 18-19 | 2 | Número de palabras del Value |
| Type | 20 | 1 | 0=entero, 1=punto flotante |
| Scale | 21-24 | 4 | Potencia de 10 (offset 8) |
| Reserved | 25-32 | 8 | Reservado (código de moneda cuando es divisa) |

### Tamaño de paquete por Size

| Size | Palabras del Value | Total de palabras |
|------|-------------------|-------------------|
| 00 | 1 (16 bits) | 4 |
| 01 | 2 (32 bits) | 5 |
| 10 | 4 (64 bits) | 7 |

## Códigos de unidad (6 bits = 64)

### Unidades base SI (0x00~0x06)

| Código | Unidad | Símbolo | Magnitud |
|--------|--------|---------|----------|
| 0x00 | meter | m | Longitud |
| 0x01 | kilogram | kg | Masa |
| 0x02 | second | s | Tiempo |
| 0x03 | ampere | A | Corriente eléctrica |
| 0x04 | kelvin | K | Temperatura |
| 0x05 | mole | mol | Cantidad de sustancia |
| 0x06 | candela | cd | Intensidad luminosa |

### Unidades derivadas SI (0x07~0x1C)

| Código | Unidad | Símbolo | Magnitud |
|--------|--------|---------|----------|
| 0x07 | hertz | Hz | Frecuencia |
| 0x08 | newton | N | Fuerza |
| 0x09 | pascal | Pa | Presión |
| 0x0A | joule | J | Energía |
| 0x0B | watt | W | Potencia |
| 0x0C | coulomb | C | Carga eléctrica |
| 0x0D | volt | V | Voltaje |
| 0x0E | farad | F | Capacitancia |
| 0x0F | ohm | Ω | Resistencia |
| 0x10 | siemens | S | Conductancia |
| 0x11 | weber | Wb | Flujo magnético |
| 0x12 | tesla | T | Campo magnético |
| 0x13 | henry | H | Inductancia |
| 0x14 | celsius | °C | Temperatura |
| 0x15 | lumen | lm | Flujo luminoso |
| 0x16 | lux | lx | Iluminancia |
| 0x17 | becquerel | Bq | Radiactividad |
| 0x18 | gray | Gy | Dosis absorbida |
| 0x19 | sievert | Sv | Dosis equivalente |
| 0x1A | katal | kat | Actividad catalítica |
| 0x1B | radian | rad | Ángulo plano |
| 0x1C | steradian | sr | Ángulo sólido |

### Unidades no-SI (0x20~0x2F)

| Código | Unidad | Uso |
|--------|--------|-----|
| 0x20 | CURRENCY | Moneda (extensión de código de divisa) |
| 0x21 | percent | % (proporción) |
| 0x22 | degree | ° (ángulo) |
| 0x23~0x28 | minute~year | Unidades de tiempo |
| 0x29 | bit | Cantidad de información |
| 0x2A | byte | Cantidad de información |
| 0x2B~0x2F | COUNT~INDEX | Valores sin unidad |

### Literales especiales (0x30~0x3F)

| Código | Tipo | Payload | Uso |
|--------|------|---------|-----|
| 0x30 | TIMESTAMP_SEC | 2/4 palabras | Timestamp Unix (segundos) |
| 0x31 | TIMESTAMP_MS | 4 palabras | Timestamp Unix (milisegundos) |
| 0x32 | UTF16 | 2+N palabras | Cadena UTF-16 |
| 0x33 | RGBA | 2 palabras | Color (32 bits) |

## Scale (4 bits)

Potencia de 10. Se aplica un offset de 8. **Cálculo:** `valor real = Value × 10^(Scale - 8)`

| Código | Valor | Prefijo | Código | Valor | Prefijo |
|--------|-------|---------|--------|-------|---------|
| 0000 | 10⁻⁸ | - | 1000 | **10⁰ (base)** | - |
| 0010 | 10⁻⁶ | μ | 1001 | 10¹ | da |
| 0101 | 10⁻³ | m | 1011 | 10³ | k |
| 0110 | 10⁻² | c | 1110 | 10⁶ | M |

## Extensión de moneda (Unit = 0x20)

Cuando es CURRENCY, los 8 bits Reserved se usan como código de divisa.

| Código | Moneda | ISO | Código | Moneda | ISO |
|--------|--------|-----|--------|--------|-----|
| 0x00 | Dólar estadounidense | USD | 0x05 | Won coreano | KRW |
| 0x01 | Euro | EUR | 0x06 | Franco suizo | CHF |
| 0x02 | Yen japonés | JPY | 0x07 | Dólar australiano | AUD |
| 0x03 | Libra esterlina | GBP | 0x08 | Dólar canadiense | CAD |
| 0x04 | Yuan chino | CNY | 0x80 | Bitcoin | BTC |

## Ejemplos

### "100kg" → 4 palabras

```
1st: [Prefix] + [0x01(kg)]
2nd: +, 1 palabra, int, ×1     → 0x0800
3rd: 0x0064 (100)
4th: TID
Interpretación: +100 × 10⁰ kg = 100kg
```

### "$2,500,000" → 4 palabras (uso de escala)

```
1st: [Prefix] + [0x20(CURRENCY)]
2nd: +, 1 palabra, int, ×10³, USD  → 0x0B00
3rd: 0x09C4 (2500)
4th: TID
Interpretación: +2500 × 10³ USD = $2,500,000
```
