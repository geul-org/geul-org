---
title: "Formato de fluxo"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "O fluxo GEUL é uma sequência de pacotes que começa e termina com um Meta Node. Define o escopo de TID, as referências diretas e as regras de ordem de pacotes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

O fluxo GEUL é uma **sequência de pacotes que começa e termina com um Meta Node**, constituindo um documento GEUL completo.

## Características principais

- **Limites explícitos:** STREAM_START / STREAM_END (Meta Node)
- **Escopo de TID:** Válido apenas dentro do fluxo
- **Referência direta:** Só se podem referenciar TIDs já declarados
- **Big Endian:** Network Byte Order

## Estrutura do fluxo

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← Obrigatório (Meta Node)
│          (declaração de largura TID)│     0xC000 (TID de 16 bits)
├─────────────────────────────────────┤
│          Metadados (opcional)       │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          Pacotes do corpo           │
│          - Entity Node              │
│          - Quantity Node            │
│          - Verb Edge                │
│          - Triple Edge              │
│          - Event6 Edge              │
│          - Clause Edge              │
│          - Context Edge             │
│          - Group Edge               │
│          - Faber Edge               │
├─────────────────────────────────────┤
│          STREAM_END                 │  ← Opcional (recomendado)
└─────────────────────────────────────┘
```

O fluxo mínimo é `STREAM_START`(1 palavra) + `STREAM_END`(1 palavra) = 2 palavras (4 bytes); até um fluxo vazio é válido.

## Princípios de atribuição de TID

| Regra | Descrição |
|-------|-----------|
| **Obrigatoriedade** | Cada Edge/Node no fluxo tem um TID |
| **Unicidade** | Os TIDs são únicos dentro do fluxo |
| **Escopo** | Os TIDs só são válidos dentro do seu fluxo |
| **Direção direta** | Só se podem referenciar TIDs já declarados no momento da referência |

### Posição do TID

| Tipo | Posição do TID | Posição de referência |
|------|----------------|----------------------|
| **Meta Node** | Não tem | Não tem |
| **Entity Node** | Última palavra | Não tem |
| **Quantity Node** | Última palavra | Não tem |
| **Tiny Verb Edge** | Não tem | Não tem (inline) |
| **Verb Edge** | Área de Header | Após o Payload |
| **Triple Edge** | Área de Header | Após o Payload |
| **Event6 Edge** | Área de Header | Após o Payload |
| **Clause Edge** | Área de Header | Após o Payload |
| **Context Edge** | Área de Header | Após o Payload |
| **Group Edge** | 2.ª palavra | 3.ª+ palavra |

Os **Nodes** só se definem a si próprios, por isso o TID fica no final; os **Edges** referenciam outros TIDs, por isso o TID fica antes das referências.

### TIDs reservados

| TID | Uso |
|-----|-----|
| 0x0000 | **Marcador de terminação** ([Group Edge](../group-edge/), etc.) |
| 0xFFFF | Reservado (base de 16 bits) |

## Regras de ordem de pacotes

### Ordem declaração-referência

```
Correto:
  [Entity: João, TID=0x0001]
  [Entity: Maria, TID=0x0002]
  [Verb Edge: encontrar, Subject=0x0001, Object=0x0002]

Incorreto:
  [Verb Edge: encontrar, Subject=0x0001, Object=0x0002]  ← 0x0001 não declarado
  [Entity: João, TID=0x0001]
  [Entity: Maria, TID=0x0002]
```

### Ordem recomendada

```
1. STREAM_START
2. Metadados (VERSION, CREATED_AT, CREATOR)
3. Entity Nodes (declaração de entidades)
4. Quantity Nodes (quantidades/literais)
5. Group Edges (definição de grupos)
6. Tiny Verb Edges (predicados inline)
7. Verb Edges (predicados gerais)
8. Triple Edges (propriedades/relações)
9. Event6 Edges (eventos)
10. Clause Edges (relações discursivas)
11. Context Edges (contexto)
12. Faber Edges (código/AST)
13. STREAM_END
```

É apenas a ordem recomendada; podem ser organizados livremente desde que se respeite a regra de declaração-referência.

### Proibição de referências circulares

Referências circulares do tipo A → B → A não são possíveis. Se forem necessárias relações circulares, expressam-se com Edges separados.

```
Possível:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## Exemplo de fluxo

### "João encontrou-se com a Maria"

```
1. STREAM_START (TID 16 bits)
   0xC0 0x00

2. Entity: João (TID=0x0001)
   [Pacote Entity...] 0x00 0x01

3. Entity: Maria (TID=0x0002)
   [Pacote Entity...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "João e Maria encontraram-se na escola"

```
1. STREAM_START
   0xC0 0x00

2. Entity: João (TID=0x0001)
3. Entity: Maria (TID=0x0002)
4. Entity: Escola (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Membros: 0x0001, 0x0002, 0x0000 (terminação)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (grupo)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## Validação do fluxo

### Validação obrigatória

| Elemento | Verificação |
|----------|-------------|
| Início | Começa com STREAM_START? |
| Unicidade de TID | Não há TIDs duplicados? |
| Validade de referência | Todos os TIDs referenciados estão declarados? |
| Direção direta | Os TIDs estavam declarados no momento da referência? |

### Código de validação

```python
def validate_stream(packets: list) -> dict:
    """Validação do fluxo"""
    errors = []
    declared_tids = set()

    # Validação de início
    if not packets or packets[0].type != "STREAM_START":
        errors.append("O fluxo não começa com STREAM_START")

    for packet in packets:
        # Validação de unicidade de TID
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"TID duplicado: {packet.tid}")
            declared_tids.add(packet.tid)

        # Validação de referências
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"Referência a TID não declarado: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## Fluxos múltiplos

Cada fluxo é independente, e o escopo de TID está separado por fluxo. O TID=0x0001 do Fluxo A e o TID=0x0001 do Fluxo B são entidades diferentes.

As referências cruzadas entre fluxos (Cross-reference) não são suportadas atualmente; poderão ser estendidas no futuro com a introdução de IDs de fluxo e mecanismos de Import/Export.
