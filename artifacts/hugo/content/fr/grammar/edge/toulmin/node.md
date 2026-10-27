---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE est la disposition qui écrit les nœuds d'un graphe TOULMIN (cas, règle, définition, point d'entrée, déclencheur, fonction, champ, alias, groupe). Les flags d'un WORD d'en-tête fixent les champs conditionnels qui suivent."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE est la disposition qui écrit les nœuds d'un graphe TOULMIN de jugement et d'exécution. Le genre de nœud est fixé par le Codec (ou le numéro de format ISSUER de GEUL), et 1 WORD d'en-tête fixe le rôle, le Level, la forme de Claim et les champs conditionnels.

## Codec

| Codec | Nom | TANGEUL | Nœud |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | Cas |
| `0x62` | SPEC-DECLARE | Élément de Definitions (`means`, `has`) | Critère de jugement (Backing). role est le genre de définition |
| `0x63` | RULE-DECLARE | general rule | Assertion (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | Réfutation (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | Exception (Defeater) |
| `0x75` | ENTRY | `provides x` | Point d'entrée externe |
| `0x76` | TRIGGER | `on`, `every`, `until` | Point d'entrée d'événement ou périodique |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | Espace de noms du document |
| ISSUER `0x0000`/`0xC011` | FUNC | Référence de fonction | Fonction extérieure (par ex. `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | Champ obligatoire |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | Alias d'un paquet importé |
| ISSUER `0x0000`/`0xC014` | GROUP | Liste ordonnée `1.` | Groupe d'exécution ordonné |

Pour un format ISSUER, le TAG d'extension de Codec qui suit `ISSUER-1WORD` (`0x7C`) contient l'Issuer `0x0000` et le numéro de format ([TOULMIN](/fr/grammar/edge/toulmin/)).

## Disposition

```
ID               enregistrement Reference LOCAL (Edge Id)
En-tête 1 WORD   role 2b | réservé 2b | F_GROUNDS 1b | level 2b | genre d'object 2b | flags 7b
[F_FUNC]         FuncRef : REF(ALIAS, 0 s'il n'y en a pas) + VerbCode 1 WORD
[F_QUAL]         Value SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF(cas)
[F_CLAIM]        Claim : REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      Value SIGNED-DECIMAL. Valeur initiale du jugement
[F_WITH]         nombre (Value UNSIGNED-INTEGER) + REF(TEXT) × nombre
[F_GROUNDS]      nombre (Value UNSIGNED-INTEGER) + REF(TEXT) × nombre
SPAN             largeur fixée par SOURCE × 2 (octet de début, nombre d'octets)
```

### WORD d'en-tête

| Bits | Champ | Valeur |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Réservé | 0 |
| 11 | F_GROUNDS | Il y a une liste de fondements |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 réservé) |
| 8–7 | genre d'object | Forme de l'object de Claim. 0 REF, 1 Value UNSIGNED-INTEGER, 2 SPAN |
| 6–0 | flags | Tableau ci-dessous |

| Bit | flag | Sens |
|---|---|---|
| b0 | F_FUNC | Il y a un champ FuncRef |
| b1 | F_QUAL | Il y a un champ Qualifier |
| b2 | F_CHECK | Il y a un champ de cas cible de `checking` |
| b3 | F_CLAIM | Il y a un champ Claim |
| b4 | F_VERDICT | Il y a un champ de valeur initiale du jugement |
| b5 | F_STRIKE | Déclaration barrée. Pas de champ |
| b6 | F_WITH | Il y a un champ de liste de critères |

- Les champs conditionnels se placent dans l'ordre des flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Un champ dont le flag est éteint n'occupe pas de place.
- Si un flag est allumé sans le champ, on rejette. La position atteinte après lecture successive des champs doit, après SPAN, coïncider exactement avec la fin de l'enregistrement.

## Champs

| Champ | Description |
|---|---|
| FuncRef | Emplacement de fonction. REF est l'enregistrement ALIAS qui a importé cette fonction, et `0` s'il s'agit d'une fonction de ce document. VerbCode est un code de 1 WORD, pas encore attribué (`0x0000` admis). L'écriture d'origine de la fonction s'écrit à part par TEXT + [LABEL](/fr/grammar/edge/toulmin/link/) |
| Qualifier | Degré de confiance du nœud (0 à 1) |
| Cas | F_CHECK : cas que ce nœud se borne à juger (`checking c`) |
| Claim | Proposition que contient le nœud. subject REF, predicate 1 WORD, object, mode 1 WORD. La forme d'object est fixée par le genre d'object de l'en-tête |
| Valeur de jugement | Valeur initiale du jugement (−1 à 1) |
| F_WITH | Critères de jugement au moment de la déclaration (`기준으로 하는`, « se fondant sur le critère »). Liste de REF d'enregistrements TEXT |
| F_GROUNDS | Noms de faits externes interprétés au moment de l'évaluation (`근거로 하는`, « se fondant sur le fait »). Liste de REF d'enregistrements TEXT |
| SPAN | Étendue du texte original dont provient cette déclaration |

- La notation de la valeur de jugement et du Qualifier suit les règles de [valeurs numériques](/fr/grammar/edge/toulmin/#valeurs-numériques) de TOULMIN.
- Le nombre d'une liste est une Value [UNSIGNED-INTEGER](/fr/grammar/value/numeric/unsigned-integer/) intégrée.
- La forme de base d'un Claim descriptif a subject et predicate à `0` et object en SPAN (genre d'object 2). Il est fixé sur la notation du texte original.

## Interprétation et validité

- Pour RULE, COUNTER et EXCEPT-DECLARE, role doit être égal à celui du Codec (0 general, 1 counter, 2 except). Pour SPEC-DECLARE, c'est le genre de définition. Pour les autres Codec, il vaut 0.
- Si level vaut 0 (Unset), on emploie la valeur par défaut du moteur : Fail pour COUNTER-DECLARE, Review pour EXCEPT-DECLARE.
- La règle de fonction hôte de TANGEUL `tangl:규칙` (« règle ») (`쓰는 규칙이다`, « est une règle qui emploie ») s'écrit en NODE RULE-DECLARE hors d'un cas. La fonction est F_FUNC, le critère F_WITH, le fondement F_GROUNDS. Seule une règle à expression conditionnelle est précédée d'un [PREDICATE-DECLARE](/fr/grammar/edge/toulmin/expr/).
- Les bits réservés (13–12) doivent valoir 0. Si un bit réservé est allumé ou si role ne correspond pas au Codec, on rejette.

## Pages liées

- [TOULMIN](/fr/grammar/edge/toulmin/), [LINK](/fr/grammar/edge/toulmin/link/), [EXPR](/fr/grammar/edge/toulmin/expr/), [SOURCE et sections](/fr/grammar/edge/toulmin/source/)
- [LOCAL](/fr/grammar/reference/local/), [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/)
