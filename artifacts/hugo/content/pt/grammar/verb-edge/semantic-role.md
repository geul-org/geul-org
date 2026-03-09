---
title: "Papéis de participantes"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "16 Participants que definem papéis semânticos dentro de um evento. Codificação de 4 bits que abrange desde papéis essenciais como Agent, Theme e Recipient até papéis adicionais como Cause e Purpose."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Participant** é um Edge que especifica o **papel semântico** das entidades envolvidas num evento dentro de uma predicação.

```
Event Node (verbo)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## Princípios de design

### Princípio de separação

| Categoria | Pertença | Exemplo |
|-----------|----------|---------|
| **Participante** | Nível de evento | Agent, Theme, Recipient |
| **Informação pragmática** | Nível de Context/Claim | Speaker, Listener, Evidentiality |

Speaker (falante), Listener (ouvinte) e Source (fonte de informação) não são participantes, mas são processados nos **[qualificadores semânticos](../qualifier/)** ou em Context/Claim.

### Codificação

- **4 bits** (0x0~0xF), máximo de 16 papéis semânticos
- Correspondência de padrões possível por operações SIMD de bits

## Lista de papéis semânticos (16)

### Participantes essenciais (Core Participants)

| ID | Código | Papel | Definição | Exemplo |
|----|--------|-------|-----------|---------|
| 0x0 | **AGT** | Agent (agente) | Sujeito que realiza a ação intencionalmente | "**João** chutou a bola" |
| 0x1 | **EXP** | Experiencer (experienciador) | Sujeito que experimenta emoção/cognição/percepção | "**Maria** estava triste" |
| 0x2 | **THM** | Theme (tema) | Objeto que se move ou cujo estado se descreve | "João chutou **a bola**" |
| 0x3 | **PAT** | Patient (paciente) | Objeto cujo estado muda pela ação | "**O vidro** quebrou" |
| 0x4 | **RCP** | Recipient (receptor) | Destinatário que recebe algo | "Deu um livro **para Maria**" |
| 0x5 | **BNF** | Beneficiary (beneficiário) | Quem obtém benefício da ação | "Fez isso **para a criança**" |

### Instrumentos e meios (Instruments & Means)

| ID | Código | Papel | Definição | Exemplo |
|----|--------|-------|-----------|---------|
| 0x6 | **INS** | Instrument (instrumento) | Ferramenta utilizada para realizar a ação | "Pregou o prego **com o martelo**" |
| 0x7 | **MNR** | Manner (maneira) | Forma como a ação é realizada | "Correu **rapidamente**" |

### Espacial (Spatial)

| ID | Código | Papel | Definição | Exemplo |
|----|--------|-------|-----------|---------|
| 0x8 | **LOC** | Location (localização) | Lugar onde o evento ocorre | "Viveu **em Lisboa**" |
| 0x9 | **SRC** | Source (origem) | Ponto de partida do movimento | "Saiu **de casa**" |
| 0xA | **DST** | Destination (destino) | Ponto de chegada do movimento | "Foi **para a escola**" |
| 0xB | **PTH** | Path (trajeto) | Ponto intermediário do movimento | "Passou **pelo parque**" |

### Causal (Causal)

| ID | Código | Papel | Definição | Exemplo |
|----|--------|-------|-----------|---------|
| 0xC | **CAU** | Cause (causa) | Causa do evento | "Foi cancelado **por causa da chuva**" |
| 0xD | **PRP** | Purpose (propósito) | Finalidade da ação | "Foi **para fazer exercício**" |

### Outros (Others)

| ID | Código | Papel | Definição | Exemplo |
|----|--------|-------|-----------|---------|
| 0xE | **COM** | Comitative (companhia) | Acompanhante | "Foi **com o amigo**" |
| 0xF | **ATR** | Attribute (atributo) | Predicado de estado/propriedade | "O céu está **azul**" |

## Estrutura do Participant Edge

```
PARTICIPANT Edge {
    source:     Event SIDX       // nó verbal
    target:     Entity SIDX      // nó de entidade
    role:       4-bit            // papel semântico (0x0~0xF)
    gram_role:  2-bit (optional) // papel gramatical (sujeito/objeto/complemento)
    focus:      4-bit (optional) // grau de ênfase (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // referência de quantificador
}
```

| Campo | Bits | Descrição |
|-------|------|-----------|
| role | 4 | Papel semântico (obrigatório) |
| gram_role | 2 | 0=não especificado, 1=sujeito, 2=objeto, 3=complemento |
| focus | 4 | Importância informacional (0=fundo, 15=ênfase máxima) |
| quant_ref | 16 | TID de quantificador como "todos", "a maioria" |

## Theme vs Patient

| Papel | Mudança de estado | Exemplo |
|-------|-------------------|---------|
| Theme | Nenhuma (movimento/descrição) | "**Lançou** a bola" (a bola permanece igual) |
| Patient | Sim (afetado) | "**Quebrou** o vidro" (o vidro muda de estado) |

Na prática, podem ser unificados como Theme e distinguidos pelo significado verbal quando necessário.

## Exemplos

### Frase simples: "João deu um livro para Maria"

```
Event: give.v.01
├─ PARTICIPANT (AGT) → João
├─ PARTICIPANT (THM) → livro
└─ PARTICIPANT (RCP) → Maria
```

### Frase complexa: "Por causa da chuva, foi correndo rápido com o amigo de casa para a escola"

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [falante]
├─ PARTICIPANT (CAU) → chuva
├─ PARTICIPANT (COM) → amigo
├─ PARTICIPANT (SRC) → casa
├─ PARTICIPANT (DST) → escola
└─ PARTICIPANT (MNR) → rapidamente
```

### Descrição de estado: "O céu está muito azul"

```
Event: be.v.01
├─ PARTICIPANT (THM) → céu
└─ PARTICIPANT (ATR) → azul (focus=15)
```

## Normalização ativa/passiva

| Forma superficial | Agent | Theme |
|-------------------|-------|-------|
| "A Apple adquiriu a Tesla" | Apple | Tesla |
| "A Tesla foi adquirida pela Apple" | Apple | Tesla |

Normaliza-se na fase de análise para processar com o mesmo padrão.
