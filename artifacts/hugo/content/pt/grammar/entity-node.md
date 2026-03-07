---
title: "Entity Node"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "Node de comprimento fixo de 4 palavras (64 bits) que identifica entidades como pessoas, lugares, objetos e organizações. Expressa quantificação/número com 3 bits de Mode, classifica 64 tipos superiores com 6 bits de EntityType e codifica atributos semânticos com 48 bits de Attributes."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** é um **pacote de comprimento fixo de 4 palavras (64 bits)** que identifica entidades (pessoas, lugares, objetos, organizações, conceitos, etc.) no fluxo GEUL.

## Essência do SIDX

| Característica | Descrição |
|----------------|-----------|
| **Non-unique** | Múltiplas entidades podem ter o mesmo SIDX |
| **Multi-SIDX** | Uma entidade pode ter vários SIDX (por momento/papel) |
| **Bit = significado** | A posição do bit em si representa um atributo |
| **Contínuo abstrato/concreto** | Distingue-se pelo grau de preenchimento de Mode e Attributes |

**Exemplos:**
- Trump (empresário imobiliário) → SIDX_A
- Trump (presidente) → SIDX_B (SIDX diferente)
- "Human + Male + Korea" → abstrato "homem coreano"
- "Human + Male + Korea + 1946 + Business + ..." → quase uma pessoa específica

## Princípios de design

**Renúncia ao Q-ID interno:**
- Investimento total de bits no alinhamento semântico puro
- Maximização do desempenho de filtragem SIMD do WMS
- Q-ID é conectado separadamente via [Triple](../triple-edge/): `(Entity_SIDX, P-externalID, "Q12345")`

**Bits Serial desnecessários:**
- Consultas WMS têm 2 fases: redução de alcance com SIMD → verificação de detalhe dentro do alcance
- Serial é um número sem significado, não contribui para SIMD
- Investir esses bits em alinhamento semântico permite reduzir mais na primeira fase

## Layout de bits (4 palavras = 64 bits)

```
1st WORD (16 bits)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16 bits)
┌─────────────────────────────┐
│   Attributes superiores 16 bits  │
└─────────────────────────────┘

3rd WORD (16 bits)
┌─────────────────────────────┐
│   Attributes médios 16 bits      │
└─────────────────────────────┘

4th WORD (16 bits)
┌─────────────────────────────┐
│   Attributes inferiores 16 bits  │
└─────────────────────────────┘
```

| Campo | Bits | Tamanho | Descrição |
|-------|------|---------|-----------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8 modos de quantificação/número |
| EntityType | 11-16 | 6 | 64 tipos superiores |
| Attributes | 17-64 | **48** | Esquema variável por tipo |

## Mode (3 bits)

Mode expressa de forma unificada a **quantificação e o número** da entidade em 3 bits.

| Código | Binário | Significado | Exemplo |
|--------|---------|-------------|---------|
| 0 | 000 | **Entidade registrada** | Yi Sun-sin, Samsung, BTS |
| 1 | 001 | Singular definido | "essa pessoa" |
| 2 | 010 | Poucos definidos | "esses poucos" |
| 3 | 011 | Plural definido | "essas pessoas" |
| 4 | 100 | Universal | "todos os ~" |
| 5 | 101 | Existencial | "algum ~" |
| 6 | 110 | Indefinido | "qualquer ~" |
| 7 | 111 | Genérico | "~ em geral" |

### Entidade registrada (Mode=0)

- Entidades mapeadas para IDs externos como Q-IDs do Wikidata, Synsets do WordNet, etc.
- O Q-ID é conectado via Triple: `(Entity_SIDX, P-externalID, "Q12345")`
- **Independente do conceito de número**: Samsung é "um" mas é ambíguo dizer singular, BTS é um grupo mas é uma única entidade

### Pronomes/abstratos (Mode=1~7)

- Especifica-se o alcance semântico com EntityType + Attributes
- Quanto mais bits preenchidos, mais concreto
- Exemplo: Human(Type) + Male(Attr) + Korea(Attr) = "homem coreano"

## EntityType (6 bits = 64)

Atribuem-se 64 tipos superiores com base em estatísticas de frequência do Wikidata P31 (instance of). A classificação detalhada é tratada com bits de subcategoria dentro dos Attributes.

| Faixa | Categoria | Quantidade | Tipos representativos |
|-------|-----------|------------|----------------------|
| 0x00-0x07 | Seres vivos/Pessoas | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | Química/Matéria | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | Corpos celestes | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | Geografia/Natureza | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | Lugares/Administração | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | Edificações | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | Organizações | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | Obras criativas | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | Eventos/Outros | 4 | SportsSeason, Event, Election, Other |

### Tabela de códigos (64 completos)

| Código | Tipo | Q-ID | Entidades |
|--------|------|------|-----------|
| 0x00 | Human | Q5 | 12.5M |
| 0x01 | Taxon | Q16521 | 3.8M |
| 0x02 | Gene | Q7187 | 1.2M |
| 0x03 | Protein | Q8054 | 1.0M |
| 0x04 | CellLine | Q21014462 | 154K |
| 0x05 | FamilyName | Q101352 | 662K |
| 0x06 | GivenName | Q202444 | 128K |
| 0x07 | FictionalCharacter | Q15632617 | 98K |
| 0x08 | Chemical | Q113145171 | 1.3M |
| 0x09 | Compound | Q11173 | 1.1M |
| 0x0A | Mineral | Q7946 | 62K |
| 0x0B | Drug | Q12140 | 45K |
| 0x0C | Star | Q523 | 3.6M |
| 0x0D | Galaxy | Q318 | 2.1M |
| 0x0E | Asteroid | Q3863 | 249K |
| 0x0F | Quasar | Q83373 | 178K |
| 0x10 | Planet | Q634 | 15K |
| 0x11 | Nebula | Q12057 | 8K |
| 0x12 | StarCluster | Q168845 | 5K |
| 0x13 | Moon | Q2537 | 3K |
| 0x14 | Mountain | Q8502 | 518K |
| 0x15 | Hill | Q54050 | 321K |
| 0x16 | River | Q4022 | 427K |
| 0x17 | Lake | Q23397 | 292K |
| 0x18 | Stream | Q47521 | 194K |
| 0x19 | Island | Q23442 | 153K |
| 0x1A | Bay | Q39594 | 25K |
| 0x1B | Cave | Q35509 | 20K |
| 0x1C | Settlement | Q486972 | 580K |
| 0x1D | Village | Q532 | 245K |
| 0x1E | Hamlet | Q5084 | 148K |
| 0x1F | Street | Q79007 | 711K |
| 0x20 | Cemetery | Q39614 | 298K |
| 0x21 | AdminRegion | Q15284 | 100K |
| 0x22 | Park | Q22698 | 45K |
| 0x23 | ProtectedArea | Q473972 | 35K |
| 0x24 | Building | Q41176 | 292K |
| 0x25 | Church | Q16970 | 286K |
| 0x26 | School | Q9842 | 242K |
| 0x27 | House | Q3947 | 235K |
| 0x28 | Structure | Q811979 | 216K |
| 0x29 | SportsVenue | Q1076486 | 145K |
| 0x2A | Castle | Q23413 | 42K |
| 0x2B | Bridge | Q12280 | 38K |
| 0x2C | Organization | Q43229 | 531K |
| 0x2D | Business | Q4830453 | 242K |
| 0x2E | PoliticalParty | Q7278 | 35K |
| 0x2F | SportsTeam | Q847017 | 95K |
| 0x30 | Painting | Q3305213 | 1.1M |
| 0x31 | Document | Q49848 | 45M |
| 0x32 | LiteraryWork | Q7725634 | 395K |
| 0x33 | Film | Q11424 | 335K |
| 0x34 | Album | Q482994 | 303K |
| 0x35 | MusicalWork | Q105543609 | 195K |
| 0x36 | TVEpisode | Q21191270 | 177K |
| 0x37 | VideoGame | Q7889 | 172K |
| 0x38 | TVSeries | Q5398426 | 85K |
| 0x39 | Patent | Q43305660 | 289K |
| 0x3A | Software | Q7397 | 13K |
| 0x3B | Website | Q35127 | 12K |
| 0x3C | SportsSeason | Q27020041 | 183K |
| 0x3D | Event | Q1656682 | 10K |
| 0x3E | Election | Q40231 | 11K |
| 0x3F | Other | - | Para extensão |

## Attributes (48 bits)

É um **esquema variável por tipo** que é interpretado com significado diferente para cada EntityType. Atribuem-se mais bits aos atributos de alta frequência e são utilizados diretamente na filtragem SIMD do WMS.

### Human (0x00) Attributes

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ Subcateg.│ Ocup.  │ Nacion.│ Era  │ Década │ Sexo   │ Notor.  │ Idioma   │ Região nasc│ Campo at.│
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Star (0x0C) Attributes

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ Constel.   │ Tipo espec.│ Cl. lum. │ Mag. ap. │ AR     │ Dec    │ Flags    │ Vel. rad.│ Desv.v.│ Paral. │
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**Definição dos bits de flags:**
- bit0: IR (fonte infravermelha)
- bit1: Radio (fonte de rádio)
- bit2: X-ray (fonte de raios X)
- bit3: Binary (estrela binária)
- bit4: Variable (estrela variável)
- bit5: HighPM (movimento próprio alto)

## Operações

### Criação de Entity

```python
def make_entity(
    mode: int,           # 3 bits
    entity_type: int,    # 6 bits
    attrs: int           # 48 bits
) -> bytes:
    PREFIX = 0b0001001   # 7 bits (Entity Node)

    word1 = (PREFIX << 9) | (mode << 6) | entity_type
    word2 = (attrs >> 32) & 0xFFFF
    word3 = (attrs >> 16) & 0xFFFF
    word4 = attrs & 0xFFFF

    return (
        word1.to_bytes(2, 'big') +
        word2.to_bytes(2, 'big') +
        word3.to_bytes(2, 'big') +
        word4.to_bytes(2, 'big')
    )
```

### Análise de Entity

```python
def parse_entity(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')
    word2 = int.from_bytes(data[2:4], 'big')
    word3 = int.from_bytes(data[4:6], 'big')
    word4 = int.from_bytes(data[6:8], 'big')

    prefix = (word1 >> 9) & 0x7F
    mode = (word1 >> 6) & 0x7
    entity_type = word1 & 0x3F
    attrs = (word2 << 32) | (word3 << 16) | word4

    return {
        'prefix': prefix,
        'mode': mode,
        'entity_type': entity_type,
        'attrs': attrs
    }
```

## Exemplos

### Entidade registrada: Yi Sun-sin

```python
# Yi Sun-sin (Q211789)
yi_sun_sin = make_entity(
    mode=0,              # Entidade registrada
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # Subcategoria: Military
        (0x01 << 37) |   # Ocupação: Admiral
        (0x52 << 29) |   # Nacionalidade: Korea
        (0x5 << 25) |    # Era: Early Modern
        (0x0 << 21) |    # Década: 1540s
        (0x01 << 19) |   # Sexo: Male
        (0x7 << 16)      # Notoriedade: 1000+
    )
)
# Conexão Q-ID: Triple(yi_sun_sin_SIDX, P-externalID, "Q211789")
```

### Abstrato: "todos os homens coreanos"

```python
all_korean_men = make_entity(
    mode=4,              # Universal (todos)
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # Nacionalidade: Korea
        (0x01 << 19)     # Sexo: Male
    )
)
```

## Mapeamento de subtipos

Muitos tipos do Wikidata são subtipos dos 64 EntityTypes. O codificador observa o valor P31 e o direciona para o tipo superior apropriado.

| Subtipo (P31) | Tipo superior | Entidades |
|---------------|---------------|-----------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## Cobertura

| Elemento | Valor |
|----------|-------|
| Total de entidades Wikidata | 117,419,925 |
| Internas do Wikimedia (excluídas) | 8,565,353 (7.3%) |
| Alvo SIDX | 108,854,572 (92.7%) |
| Cobertura direta de 64 tipos | 36,295,074 (33.3%) |
| Absorção de subtipos | 71,842,429 (66.0%) |
| Fallback Other | 717,069 (0.7%) |
| **Cobertura final** | **100%** |
| **Taxa de colisão** | **< 0.01%** |

## Conexão de Q-IDs

Entity Node não contém Q-IDs internamente; são conectados separadamente via [Triple Edge](../triple-edge/).

```
Subject:  Entity_SIDX (64 bits)
Property: P-externalID (ex: P-Wikidata)
Object:   "Q12345" (string ou inteiro)
```
