---
title: "Meta — Structure"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "La classe Meta de structure (3 bits de poids fort `000`, `0x00` à `0x0F`) fixe les limites et la longueur du document. Elle l'ouvre par DOC-1WORD/2WORD/4WORD, termine le HEAD par BODY et le ferme par END."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La classe Meta de structure (3 bits de poids fort `000`, Codec `0x00` à `0x0F`) fixe les limites et la longueur du document. L'unité des données GEUL est un document.

```
DOC-*                  ← début du HEAD
  Meta de définition, source, lignée, vérification, politique, IMPORT
  SOURCE du document entier et ses QUALIFIER
BODY                   ← début du BODY
  Reference, Value, Edge
END                    ← ferme le document
```

- Tout document est ouvert par `DOC-1WORD/2WORD/4WORD`, qui indique sa longueur totale. Le décodeur peut ainsi sauter tout le document d'un coup.
- `BODY` et `END` sont des enregistrements de 1 WORD sans Payload. `END` est obligatoire.
- Les documents ne s'imbriquent pas. Un autre document se désigne par IMPORT.
- Si le HEAD (les Meta, le SOURCE du document entier et ses QUALIFIER) est vide, `BODY` est omis. `BODY` ne peut apparaître qu'une fois par document.

La structure complète du document est décrite dans [Document](/fr/grammar/document/).
