---
title: "Format de flux"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "Le flux GEUL est une sequence de paquets delimitee par des Meta Nodes de debut et de fin. Definit la portee des TID, les references en avant et les regles d'ordre des paquets."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Le flux GEUL est une **sequence de paquets delimitee par des Meta Nodes de debut et de fin**, constituant un document GEUL complet.

## Caracteristiques principales

- **Limites explicites :** STREAM_START / STREAM_END (Meta Node)
- **Portee des TID :** Valides uniquement au sein du flux
- **Reference en avant :** Seuls les TID deja declares peuvent etre references
- **Big Endian :** Network Byte Order

## Structure du flux

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← Obligatoire (Meta Node)
│          (declaration largeur TID)  │     0xC000 (TID 16 bits)
├─────────────────────────────────────┤
│          Metadonnees (optionnel)    │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          Paquets du corps           │
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
│          STREAM_END                 │  ← Optionnel (recommande)
└─────────────────────────────────────┘
```

Le flux minimal est `STREAM_START` (1 mot) + `STREAM_END` (1 mot) = 2 mots (4 octets), et meme un flux vide est valide.

## Principes d'attribution des TID

| Regle | Description |
|-------|-------------|
| **Obligatoire** | Chaque Edge/Node du flux possede un TID |
| **Unicite** | Le TID est unique au sein du flux |
| **Portee** | Le TID n'est valide que dans son flux |
| **En avant** | Seuls les TID deja declares au moment de la reference peuvent etre references |

### Position du TID

| Type | Position du TID | Position des references |
|------|----------------|------------------------|
| **Meta Node** | Aucune | Aucune |
| **Entity Node** | Dernier mot | Aucune |
| **Quantity Node** | Dernier mot | Aucune |
| **Tiny Verb Edge** | Aucune | Aucune (inline) |
| **Verb Edge** | Zone d'en-tete | Apres le payload |
| **Triple Edge** | Zone d'en-tete | Apres le payload |
| **Event6 Edge** | Zone d'en-tete | Apres le payload |
| **Clause Edge** | Zone d'en-tete | Apres le payload |
| **Context Edge** | Zone d'en-tete | Apres le payload |
| **Group Edge** | 2e mot | 3e mot et suivants |

Les **Nodes** ne definissent qu'eux-memes, donc le TID est en fin ; les **Edges** referencent d'autres TID, donc le TID precede les references.

### TID reserves

| TID | Usage |
|-----|-------|
| 0x0000 | **Marqueur de fin** ([Group Edge](../group-edge/) etc.) |
| 0xFFFF | Reserve (base 16 bits) |

## Regles d'ordre des paquets

### Ordre declaration-reference

```
Correct :
  [Entity: Jean, TID=0x0001]
  [Entity: Marie, TID=0x0002]
  [Verb Edge: rencontrer, Subject=0x0001, Object=0x0002]

Incorrect :
  [Verb Edge: rencontrer, Subject=0x0001, Object=0x0002]  ← 0x0001 non declare
  [Entity: Jean, TID=0x0001]
  [Entity: Marie, TID=0x0002]
```

### Ordre recommande

```
1. STREAM_START
2. Metadonnees (VERSION, CREATED_AT, CREATOR)
3. Entity Nodes (declaration des entites)
4. Quantity Nodes (quantites/litteraux)
5. Group Edges (definition des groupes)
6. Tiny Verb Edges (predications inline)
7. Verb Edges (predications generales)
8. Triple Edges (proprietes/relations)
9. Event6 Edges (evenements)
10. Clause Edges (relations discursives)
11. Context Edges (contextes)
12. Faber Edges (code/AST)
13. STREAM_END
```

Ceci n'est qu'un ordre recommande ; tout placement est libre tant que la regle declaration-reference est respectee.

### Interdiction des references circulaires

Les references circulaires de type A → B → A sont impossibles. Quand une relation circulaire est necessaire, elle est exprimee par des Edges separes.

```
Possible :
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## Exemple de flux

### "Jean a rencontre Marie"

```
1. STREAM_START (TID 16 bits)
   0xC0 0x00

2. Entity: Jean (TID=0x0001)
   [Paquet Entity...] 0x00 0x01

3. Entity: Marie (TID=0x0002)
   [Paquet Entity...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "Jean et Marie se sont rencontres a l'ecole"

```
1. STREAM_START
   0xC0 0x00

2. Entity: Jean (TID=0x0001)
3. Entity: Marie (TID=0x0002)
4. Entity: Ecole (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Membres: 0x0001, 0x0002, 0x0000 (fin)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (groupe)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## Validation du flux

### Validations obligatoires

| Element | Validation |
|---------|------------|
| Debut | Commence-t-il par STREAM_START ? |
| Unicite TID | Y a-t-il des TID en double ? |
| Validite des references | Tous les TID references sont-ils declares ? |
| En avant | Les TID sont-ils declares avant d'etre references ? |

### Code de validation

```python
def validate_stream(packets: list) -> dict:
    """Validation du flux"""
    errors = []
    declared_tids = set()

    # Validation du debut
    if not packets or packets[0].type != "STREAM_START":
        errors.append("Le flux ne commence pas par STREAM_START")

    for packet in packets:
        # Validation de l'unicite TID
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"TID en double: {packet.tid}")
            declared_tids.add(packet.tid)

        # Validation des references
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"Reference a un TID non declare: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## Flux multiples

Chaque flux est independant et la portee des TID est separee par flux. TID=0x0001 dans le flux A et TID=0x0001 dans le flux B designent des entites differentes.

Les references inter-flux (Cross-reference) ne sont actuellement pas supportees et pourront etre etendues a l'avenir par l'introduction d'identifiants de flux et de mecanismes Import/Export.
