---
title: "Gramática do GEUL"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "SIDX", "specification"]
summary: "Especificação do formato de fluxo binário baseado no identificador semântico global de 64 bits SIDX. Define os princípios de design, o sistema de Prefix, os 9 tipos de pacotes e as regras de codificação."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

A gramática do GEUL (General Encoding Unified Language) é um formato de fluxo binário baseado no SIDX (Semantic-aligned Index), um identificador semântico global de 64 bits.

## Princípios de design

1. **Extensibilidade a longo prazo:** Não se atribuem usos temporários aos bits reservados. Preserva-se o espaço para as gerações futuras.
2. **Permanência semântica:** O significado de um padrão de bits definido não é alterado. Se um novo significado for necessário, atribui-se um novo padrão.
3. **Compatibilidade retroativa:** Qualquer versão do GEUL deve poder interpretar completamente todas as versões anteriores.
4. **Complexidade linear:** O processamento simbólico do GEUL mantém O(n) em relação ao comprimento.

## Resumo do SIDX

SIDX é um identificador semântico global de 64 bits. Ramifica-se sequencialmente a partir do bit mais significativo para determinar a região.

| Prefix | Região | Proporção | Uso |
|--------|--------|-----------|-----|
| `1` | Far Future | 50% | Reservado para o futuro distante |
| `01` | Future | 25% | Reservado para o futuro próximo |
| `001` | Standard | 12.5% | Região padrão oficial |
| `000` | Free | 12.5% | Completamente livre |

`0001` é o espaço convencional utilizado por esta proposta dentro da região livre (000).

## Sistema de Prefix

```
bit1
├─ 1: Far Future
│
└─ 0
    └─ bit2
        ├─ 1 (01): Future
        │
        └─ 0
            └─ bit3
                ├─ 1 (001): Standard
                │     └─ bit4~
                │         ├─ 1           (001 1)        → Tiny Verb Edge
                │         ├─ 01          (001 01)       → Verb Edge
                │         ├─ 001         (001 001)      → Entity Node
                │         └─ 000         (001 000)      → Região unificada de 9 bits
                │
                └─ 0 (000): Free
                      └─ 0001: Proposal (espelho do Standard)
```

## Tipos de pacotes

O fluxo GEUL consiste em 9 tipos de pacotes. São listados na ordem de alocação de bits do Prefix (= prioridade).

| Tipo | Prefix | Palavras | Descrição |
|------|--------|----------|-----------|
| Tiny Verb Edge | `0001 1` | 2 | Predicados simples de alta frequência |
| [Verb Edge](../verb-edge/) | `0001 01` | 3~5 | 559 raízes → 13.767 verbos WordNet |
| [Entity Node](../entity-node/) | `0001 001` | 4 | 64 EntityType, 48 bits de atributos |
| [Triple Edge](../triple-edge/) | `0001 000 110` | 4~5 | Propriedades/relações, Top63 + extensão |
| [Clause Edge](../clause-edge/) | `0001 000 101` | 4 | 16 relações discursivas/lógicas baseadas em RST |
| [Event6 Edge](../event6-edge/) | `0001 000 100` | 3~8 | Evento das 6 perguntas fundamentais |
| [Context Edge](../context-edge/) | `0001 000 011` | 3 | 64 tipos de cosmovisão/contexto |
| [Quantity Node](../quantity-node/) | `0001 000 010` | 4~7 | 64 códigos de unidade, SI/moeda/timestamp |
| [AST Edge](../ast-edge/) | `0001 000 001` | 3+ | 64 linguagens de programação, 256 tipos de nó AST |
| [Group Edge](../group-edge/) | `0001 000 000 111` | 4+ | 7 tipos de conjunto/grupo |

### Especificações comuns

| Documento | Descrição |
|-----------|-----------|
| [Formato de fluxo](../stream-format/) | Regras de formato de fluxo, escopo de TID, ordem de pacotes |

## Regras de codificação

| Elemento | Regra |
|----------|-------|
| Ordem de bytes | Big Endian |
| Ordem de bits | MSB First (bit1 = MSB) |
| Tamanho da palavra | 16 bits (2 bytes) |

Todos os campos são alinhados em limites de palavra de 16 bits, e o tamanho do pacote é sempre em unidades de palavra (múltiplos de 2 bytes). Se necessário preenchimento, completa-se com 0x00.
