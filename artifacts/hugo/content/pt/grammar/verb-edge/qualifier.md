---
title: "Qualificadores semânticos"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "qualifier", "tense", "aspect"]
summary: "Qualificadores semânticos do Verb Edge. Codificam informação gramatical e pragmática do predicado em 14 categorias: evidencialidade, modo, modalidade, tempo, aspecto, cortesia, polaridade, intencionalidade, confiança e iteratividade."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge codifica diversos qualificadores semânticos além do corpo verbal. Juntamente com os [participantes](../semantic-role/), constituem o significado completo do predicado.

## Lista de qualificadores

| Categoria | Nome em inglês | Tipo de dados | Mapeamento de valores |
|-----------|---------------|---------------|----------------------|
| Verbo central | Core Verb | Identificador | Identificador absoluto de alinhamento semântico |
| Lista de [participantes](../semantic-role/) | Participant List | Lista de tipo composto | {entidade, papel gramatical, papel semântico} |
| Falante | Speaker | Referência | Sujeito do predicado (obrigatório) |
| Ouvinte | Listener | Referência | Destinatário do predicado (nullable) |
| Evidencialidade | Evidentiality | Float [-1.0~1.0] | -1=inferência, 0=experiência direta, 1=testemunho |
| Modo | Mood | Float [-1.0~1.0] | -1=hipotético, 0=declarativo, 1=imperativo |
| Modalidade | Modality | Float [0.0~1.0] | Grau de vontade |
| Tempo | Tense | Float [-1.0~1.0] | -1=passado, 0=presente, 1=futuro |
| Aspecto | Aspect | Máscara de bits | 1:progressivo, 2:perfectivo, 4:resultativo |
| Cortesia | Politeness | Float [-1.0~1.0] | -1=informal, 0=neutro, 1=formal |
| Polaridade | Polarity | Float [-1.0~1.0] | -1=negativo, 0=indeterminado, 1=positivo |
| Intencionalidade | Volitionality | Float [-1.0~1.0] | -1=não intencional, 0=indeterminado, 1=intencional |
| Confiança | Confidence | Float [-1.0~1.0] | -1=especulação, 0=indeterminado, 1=certeza |
| Iteratividade | Iterativity | Inteiro | 0=indeterminado, 1=uma vez, MAX=infinito |

## Evidencialidade (Evidentiality)

Expressa a fonte da informação.

| Valor | Significado | Exemplo |
|-------|-------------|---------|
| -1.0 | Inferência | "parece que ~" |
| 0.0 | Experiência direta | "~fez" |
| 1.0 | Testemunho | "dizem que ~" |

## Modo (Mood)

Expressa a função do enunciado.

| Valor | Significado | Exemplo |
|-------|-------------|---------|
| -1.0 | Hipotético/contrafactual | "se tivesse ~" |
| 0.0 | Declarativo/factual | "~é" |
| 1.0 | Imperativo/pedido | "faça ~!" |

## Tempo (Tense)

Expressa a localização temporal do evento.

| Valor | Significado | Exemplo |
|-------|-------------|---------|
| -1.0 | Passado | "~fez" |
| 0.0 | Presente | "~faz" |
| 1.0 | Futuro | "~fará" |

## Aspecto (Aspect)

Expressa a estrutura temporal interna do evento por máscara de bits.

| Bits | Significado | Exemplo |
|------|-------------|---------|
| 001 | Progressivo | "está ~ndo" |
| 010 | Perfectivo | "tem ~do" |
| 100 | Resultativo | "tem ~do (resultado)" |
| 011 | Progressivo+perfectivo | "tem estado a ~" |

## Cortesia (Politeness)

Expressa a relação social entre falante e ouvinte.

| Valor | Significado | Exemplo |
|-------|-------------|---------|
| -1.0 | Informal/coloquial | "faz isso" |
| 0.0 | Neutro | "faça isso" |
| 1.0 | Formal/respeitoso | "faça o favor de fazer isso" |

## Princípios de design

- **Valores contínuos:** Expressos como Float em vez de classificação discreta, permitindo representar gradações
- **Bipolar:** A maioria utiliza o intervalo [-1.0, 1.0] para expressar ambos os extremos
- **Indeterminado:** 0.0 pode significar tanto "neutro" como "indeterminado" (Polarity, Volitionality, Confidence)
- **Combinação:** Representação de significados complexos pela mistura de máscara de bits (Aspect) + Float
