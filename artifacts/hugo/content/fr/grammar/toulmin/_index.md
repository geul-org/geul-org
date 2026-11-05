---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Écrit des graphes de verdict et d'exécution selon le modèle d'argumentation de Toulmin."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Écrit des graphes de verdict et d'exécution selon le modèle d'argumentation de Toulmin. C'est la famille centrale par laquelle GEUL décrit ses propres règles en GEUL et se corrige lui-même.

| Groupe | Codec |
|---|---|
| Déclaration | [CASE-DECLARE](0x100L-case-declare.md) (cas), [PREDICATE-DECLARE](0x101L-predicate-declare.md) (prédicat), [SPEC-DECLARE](0x102L-spec-declare.md) (critère de jugement), [RULE-DECLARE](0x103L-rule-declare.md) (affirmation), [COUNTER-DECLARE](0x104L-counter-declare.md) (réfutation), [EXCEPT-DECLARE](0x105L-except-declare.md) (exception) — [NODE](#node) |
| Relation | [ATTACKS](0x108L-attacks.md) (attaque), [SUPERSEDES](0x109L-supersedes.md) (exclusion) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (chaîne de priorité, disposition non fixée) |
| Exécution | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| Résultat | [VERDICT](0x118L-verdict.md) (résultat de verdict : Pass, Review, Fail), [EVIDENCE](0x119L-evidence.md) (preuve du verdict) — disposition non fixée |

- Le texte original, les divisions, ainsi que les nœuds et relations auxiliaires sont les codes directs `0x120L~0x134L` de la famille de format TOULMIN ([SOURCE et divisions](#source와-구획), [TOULMIN](#toulmin-형식)).
- Les résultats de verdict se placent dans un autre document que la cible du verdict. Le document de résultat importe le document cible et le désigne. Juger ne change donc pas le hachage du contenu du document cible.

Les Edge de la famille TOULMIN (codes directs `0x100L~0x11BL` ; enregistrements auxiliaires dans la famille de format TOULMIN `0x120L~0x134L`) écrivent des graphes de verdict et d'exécution selon le modèle d'argumentation de Toulmin. Déclarations d'affirmations, de réfutations et d'exceptions, relations d'attaque et d'exclusion, liens d'exécution et résultat de verdict sont tous des Edge. Un document TANGEUL (le langage de règles du moteur toulmin) devient un document GEUL. L'extension de fichier est `.geul`, comme les autres documents.

Ce que ce document ne fixe pas suit les règles communes d'[Edge](../edge/_index.md) et d'[Enregistrement et TAG WORD](../record.md).

## Méta-cognition et auto-révision {#메타-인지와-자기-개정}

TOULMIN est un Codec de GEUL pour que GEUL ait une méta-cognition de lui-même. Les règles de verdict et d'exécution doivent elles aussi être décrites en GEUL pour que TOULMIN puisse les prendre pour objet et se corriger de lui-même. TOULMIN n'est donc pas un profil d'application mais le cœur du fonctionnement de GEUL, et se place dans l'espace des codes directs d'Edge (`0x100L~0x11BL`).

- L'auto-description permet l'auto-amélioration mais fait courir le risque d'erreur circulaire. Si une règle juge elle-même sa propre révision, une révision qui relâche les critères de verdict peut aussi passer (le taux de réussite monte, la précision réelle baisse).
- On accepte la circularité comme un risque mais on la coupe par la structure.
  - **Noyau fixe** : le sens du verdict (Pass, Review, Fail ; attaque, exclusion, priorité ; évaluation à 3 valeurs et U → Review de [Juger sur l'inconnu](#미상-위에서-판정하기) ci-dessous) est fixé dans cette spécification. Il ne peut pas être changé par un document TOULMIN. C'est la même place que les règles intégrées au décodeur (couche 0 de [Adresse de publication et liste des versions](../publishing.md#층)).
  - **Séparation des éditions** : la révision du document de règles v(n) est jugée par les règles v(n−1) et un contrôle externe. Une règle ne se juge pas elle-même. Le résultat de verdict se place dans un autre document que la cible (le hachage du contenu de la cible ne change pas).
  - **Historique immuable** : les révisions s'accumulent en nouvelles versions (`PARENT`, hachage du contenu, signature). Les anciennes versions subsistent, ce qui permet de repérer après coup une erreur circulaire et de revenir en arrière. Le filet de sécurité de l'auto-révision est le modèle d'éditions de GEUL ([Document](../document.md#개정)).
  - **Critère externe** : on tient à part un ensemble de cas de test que la voie de révision ne peut pas toucher. L'adoption d'une révision se vérifie par le résultat de cet ensemble.
- Test de réfutation : on plante volontairement une règle fausse. Si le système la corrige et que le score du critère externe monte, l'auto-amélioration fonctionne. Si seul le taux de réussite monte et que le score du critère externe baisse, c'est une erreur circulaire.

## Codes {#코드}

Un enregistrement TOULMIN emploie l'une de trois dispositions. La disposition est fixée par le Codec.

| Disposition | Usage | Page |
|---|---|---|
| NODE | Nœud de graphe : cas, règle, définition, point d'entrée | [NODE](#node) |
| LINK | Relation entre nœuds (attaque, exclusion, exécution, définition) | [LINK](#link) |
| EXPR | Expression conditionnelle (prédicat) | [EXPR](0x101L-predicate-declare.md) |

Les enregistrements de texte original et de divisions (SOURCE, TEXT, SECTION, CASE-BEGIN et CASE-END, PROSE) sont fixés par [SOURCE et divisions](#source와-구획).

### Codes directs {#직접-코드}

| Codec | Nom | Disposition | TANGEUL | Sens |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | Déclaration de cas. Graphe de verdict contenant nœuds et relations |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | Expression conditionnelle de Rules | Déclaration de prédicat. Expression de verdict |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | Entrée de Definitions | Déclaration de critère de jugement (Backing). Les bits role donnent le genre de définition |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, nom de règle de Rules | Déclaration d'affirmation (Warrant). Peut être attaquée |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | Déclaration de réfutation. Attaque avec sa propre conclusion. Level par défaut : Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | Déclaration d'exception. Attaque sans conclusion propre. Level par défaut : Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | Relation d'attaque. Le verdict de l'attaquant réduit progressivement le verdict de la cible de la force d'attaque (0~1, 1 par défaut) |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | Relation d'exclusion. Si l'attaquant est Active, la cible est retirée de l'agrégation de façon déterministe. Une chaîne (`A > B > C`) s'écrit avec une relation par paire |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | Chaîne de priorité `A > B > C`. Abréviation des SUPERSEDES par paires. Seul le code est attribué, il n'y a pas encore de disposition |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | Composition d'exécution. Si le nœud est Active, exécute le cas inférieur (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | Action exécutée quand le nœud est Active |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | Action exécutée une seule fois même en cas de nouvelle tentative |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | Action de compensation de DO (saga). Si une étape suivante échoue, s'exécute en ordre inverse |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | Lien qui ne fait que juger, sans effet de bord |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | Point d'entrée externe. Exécute ou juge un cas |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | Point d'entrée par événement ou périodique, sans appel externe |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | Résultat de verdict d'un nœud ou d'un enregistrement. Résultat (Pass, Review, Fail), valeur de verdict, Activated, Excluded, Level. Seul le code est attribué, il n'y a pas encore de disposition |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | Preuve du verdict. Position, valeur attendue, valeur réelle (Fact). Seul le code est attribué, il n'y a pas encore de disposition |
| `0x11CL~0x11FL` | Reserved | | | |

- Les codes directs absents du tableau (`0x106L`·`0x107L`, `0x10BL`~`0x10FL`, `0x117L`, `0x11AL`·`0x11BL`) sont Reserved.
- Les groupes sont : `0x100L~0x107L` déclaration, `0x108L~0x10FL` relation, `0x110L~0x117L` exécution, `0x118L~0x11FL` résultat (`0x11CL~0x11FL` sont Reserved).
- Le verdict d'un document entier revient au Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`), celui d'un nœud ou d'un enregistrement au `VERDICT` TOULMIN (Edge `0x118L`). Ce sont deux Codec distincts, de Kind différents.

### Format TOULMIN {#toulmin-형식}

Le texte original, les divisions, ainsi que les nœuds et relations auxiliaires sont dans les codes directs `0x120L~0x134L` de la famille de format TOULMIN d'Edge. Il n'y a pas de champ Issuer ni de numéro de Codec : le Payload suit directement le TAG.

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). Même place pour les autres codes
[TAG d'extension Length]
Edge Id           enregistrement LOCAL Reference
composants        disposition fixée par le format
```

| Codec | Nom | Disposition | Sens |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, WORD de largeur SPAN, Value UTF8 | Texte original d'écriture |
| `0x121L` | [TEXT](0x121L-text.md) | ID, Value UTF8 | Nom ou chaîne |
| `0x122L` | [SECTION](0x122L-section.md) | ID, code de section 1 WORD | Début de section |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (cas) | Début de la portée d'un cas |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (cas) | Fin de la portée d'un cas |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | Paragraphe descriptif |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | Référence de fonction |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | Groupe d'exécution ordonné |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | cas → champ |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | entrée de définition → valeur ou type |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | entrée de définition → champ |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | point d'entrée → cas, exécution |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | point d'entrée → cas, verdict |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | déclencheur → cas |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | déclencheur → cas (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | nœud → identifiant global |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | alias → chemin (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | nœud → TEXT, notation du nom |

## Document {#문서}

Un fichier `.geul` est un DOC. On ne place aucun autre octet en dehors du DOC.

```
DOC-1WORD/2WORD/4WORD     longueur totale
  SPEC-VERSION            0x0001 (v1, entier sans Value intégrée)
  PROFILE                 Value UTF8 "tangeul-<major>.<minor>". Actuellement "tangeul-1.0"
  [DEFAULT-LANGUAGE]      Value LANGUAGE-BCP47-CODE. Locale d'écriture ("en", "ko")
BODY
  SOURCE                  texte original d'écriture. Premier enregistrement du BODY
  enregistrements de phrase …   ordre de déclaration du document
END
```

- HEAD : [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PROFILE](../meta/0x1C6L-profile.md), et en option [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md).
- Le décodeur refuse le document si SPEC-VERSION diffère ou si le major de PROFILE diffère. Si seul le minor diffère, il le lit.
- Le premier enregistrement du BODY est SOURCE. Tout SPAN est une plage à l'intérieur de ce texte original.
- L'ordre des enregistrements de phrase est le même que l'ordre de déclaration du document. L'ordre d'exécution (émission de `do` et `run`, compensation inverse de `undo`) s'appuie sur cet ordre. Dans un document TOULMIN, l'ordre des Edge a un sens (exception à la règle d'ordre de la [disposition d'Edge](../edge/_index.md#레이아웃)).
- Tous les enregistrements du BODY sont des Edge. On ne place pas d'enregistrement Value indépendant. Les valeurs sont intégrées au Payload de l'Edge.
- L'identité du cas et l'import emploient Meta [DOC-ID](../meta/0x1C7L-doc-id.md) et [IMPORT-DOC](../meta/0x1E4L-import-doc.md) (Subject et See de TANGEUL).

## Champs communs {#공통-필드}

| Champ | Largeur | Description |
|---|---|---|
| ID | enregistrement LOCAL Reference | Edge Id de l'enregistrement. Premier élément du Payload de tout enregistrement |
| REF | enregistrement LOCAL Reference | Edge Id désignant un autre enregistrement de ce document. `0` signifie aucun |
| SPAN | largeur fixée par SOURCE × 2 | Plage dans le texte original d'écriture. Octet de début, nombre d'octets |

- ID et REF sont des enregistrements Reference [LOCAL](../reference/0x005L-local.md) intégrés (`0000 0000 0101 LLLL` + ID de la largeur la plus courte). La largeur est fixée par le Length de cet enregistrement et n'est pas déclarée par document.
- REF `0` (LOCAL `0`) signifie « aucun ». C'est une règle de Codec qui emploie LOCAL `0` pour « aucun » ([LOCAL](../reference/0x005L-local.md)).
- Les Edge Id sont attribués à partir de 1 et ne sont pas dupliqués dans le document. `0` étant le « aucun » de REF, il n'est pas employé comme Edge Id.
- Les nœuds sont référencés en avant par d'autres enregistrements, ils reçoivent donc leur numéro en premier, dans l'ordre de déclaration du document. Les autres enregistrements (SOURCE, TEXT, LINK, FUNC, enregistrements de division) reçoivent de l'encodeur les numéros suivant les nœuds.
- Le décodeur vérifie seulement que l'Edge Id n'est pas 0 et qu'il n'y a pas de doublon. L'ordre d'attribution n'intervient pas dans l'interprétation.
- Nœuds et relations sont désignés par Edge Id.
- Une Value intégrée est un enregistrement Value tel quel, TAG WORD compris. La longueur est fixée par ce TAG.

## Valeurs numériques {#수치}

- La valeur de verdict (−1~1), le Qualifier (0~1) et la force d'attaque (0~1) sont des Value [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md). On ne prévoit pas de format à virgule fixe à part.
- L'encodeur supprime les 0 finals du coefficient. 0,8 s'écrit `C=8, E=−1`. Le décodeur accepte jusqu'à 4 décimales.
- Une barrière de confiance (par ex. `at least 75%`) s'écrit avec 1 WORD d'opérateur de comparaison et une Value [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) de pourcentage (`E=0`) ([LINK](#link) F_GATE).
- La force d'attaque est le champ F_FORCE d'ATTACKS ([LINK](#공격-세기)). Hors de la plage, on refuse.

## Axes de la déclaration de nœud {#노드-선언의-축}

- Une déclaration de nœud (RULE·COUNTER·EXCEPT-DECLARE) a un rôle (affirmation, réfutation, exception), un Qualifier (0~1) et un Level (Unset, Fail, Review). Le rôle est porté par le Codec et par le role de l'en-tête NODE, le Qualifier par F_QUAL, le Level par le level de l'en-tête ([NODE](#node)).
- La rigueur (Strict, Defeasible, Defeater) est un axe distinct du rôle. Son emplacement n'est pas encore fixé.
- La force d'attaque (Force) n'est pas celle d'un nœud mais une valeur de l'arête ATTACKS ([LINK](#공격-세기) F_FORCE). C'est un axe différent de la rigueur.

## Juger sur l'inconnu {#미상-위에서-판정하기}

Quand un graphe de verdict reçoit des faits GEUL en entrée, les trois notions de [marqueur d'emplacement](../slot-marker.md) (non écrit, inconnu, inexistant) s'évaluent différemment. L'évaluation des opérateurs de comparaison d'[EXPR](0x101L-predicate-declare.md) est la suivante.

| Entrée | `is empty` | `is not empty` | `equals` / `is in` / comparaison de taille |
|---|---|---|---|
| valeur v | faux | vrai | évalué sur v |
| NO-VALUE (inexistant) | **vrai** | faux | faux |
| UNKNOWN-VALUE (inconnu) | faux | **vrai** | **indéterminé (U)** |
| ABSENT (non écrit) / pas d'énoncé | U (monde ouvert) | U | U |

- La logique est la logique forte à 3 valeurs de Kleene. `NOT U = U`, `faux AND U = faux`, `vrai OR U = vrai`. Pour les autres combinaisons, le U reste U.
- `EXISTS any` est vrai si un seul élément est vrai. S'il n'y a aucun vrai et au moins un U, c'est U ; si tous sont faux, c'est faux.
- **Si le prédicat est U, le verdict de ce nœud n'est ni Pass ni Fail mais Review.** Dans le doute, on passe la main à une personne (ou à l'étape suivante).
- Pour lire ABSENT comme empty plutôt que comme U, le côté entrée doit **déclarer** un monde clos (injection par un critère de jugement SPEC, par ex. « l'entrée de ce cas est complète »). Sans déclaration, c'est U.
- Ce tableau et la correspondance U → Review sont le sens du verdict, donc le **noyau fixe**. Un document TOULMIN ne peut pas les changer.
- Exemple : la règle « ne compter que les frontières encore en vigueur » (`P582 is empty`) exclut le cas P582 = UNKNOWN-VALUE (faux), inclut le cas P582 = NO-VALUE (vrai), et envoie en Review le cas où P582 est absent (U).

## Résultat de verdict {#판정-결과}

- Les résultats de verdict (`VERDICT`, `EVIDENCE`) se placent dans un autre document que la cible du verdict. Le document de résultat importe le document cible par [IMPORT-DOC](../meta/0x1E4L-import-doc.md) et le désigne par [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md). Juger ne change donc pas le hachage du contenu du document cible.
- Le verdict d'un document entier est le Meta `VERDICT`, celui d'un nœud ou d'un enregistrement est le `VERDICT` TOULMIN.
- Les règles qui choisissent l'édition applicable d'une révision (dispositions transitoires, choix entre loi applicable à l'acte et loi nouvelle), ainsi que les interprétations et la jurisprudence, s'emploient aussi comme règles de verdict ([Document](../document.md#개정)).

## Problèmes ouverts {#열린-문제}

- Les dispositions de SUPERSEDE-CHAIN (`0x10AL`), VERDICT (`0x118L`), EVIDENCE (`0x119L`). La méthode actuelle, qui écrit SUPERSEDES par paire, suffit-elle pour une chaîne ?
- L'emplacement de la rigueur des nœuds (Strict, Defeasible, Defeater).
- Un ATTACKS écrit avec une force d'attaque 1 et un ATTACKS sans force donnent le même verdict mais des octets différents. Pour savoir si le verdict est le même, il faut comparer les valeurs interprétées et non les octets.
- Dans EXPR, le nombre de nœuds, le nombre d'étiquettes et l'indice d'étiquette sont sur 1 WORD, et le nombre d'enfants sur 13 bits. Les bornes sont fixes.
- La disposition de PROVENANCE (provenance et prémisses d'une règle).
- Faut-il exprimer les noms entre accents graves par [LABEL](../edge/0x0A4L-label.md)·[BIND](../edge/0x0A3L-bind.md) d'énoncé plutôt que par TEXT + LABEL (`0x134L`) ?
- Table des valeurs de code de predicate et mode de Claim, et des valeurs de code VerbCode de FuncRef.
- Faut-il faire la déclaration de monde clos (lire ABSENT comme empty) par critère de jugement (SPEC) ou par cas ?
- Le [document de spécification de Codec](../codec-spec.md) du Codec TOULMIN. Les champs conditionnels de NODE et LINK et la largeur de SPAN fixée par SOURCE sont des dispositions qu'on ne peut pas déclarer par FIELD.

## Pages liées {#관련-페이지}

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE et divisions](#source와-구획)
- [Document](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE est la disposition qui écrit les nœuds du graphe de verdict et d'exécution TOULMIN. Le genre de nœud est fixé par le Codec, et 1 WORD d'en-tête fixe le rôle, le Level, la forme de Claim et les champs conditionnels.

### Codec {#codec}

| Codec | Nom | TANGEUL | Nœud |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | Cas |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | Entrée de Definitions (`means`, `has`) | Critère de jugement (Backing). role est le genre de définition |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | Affirmation (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | Réfutation (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | Exception (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | Point d'entrée externe |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | Point d'entrée par événement ou périodique |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | Espace de noms du document |
| `0x127L` | [FUNC](0x127L-func.md) | Référence de fonction | Fonction externe (par ex. `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | Champ obligatoire |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | Alias de paquet importé |
| `0x12AL` | [GROUP](0x12AL-group.md) | liste ordonnée `1.` | Groupe d'exécution ordonné |

`0x126L~0x12AL` sont des codes directs de la famille de format TOULMIN d'Edge ([TOULMIN](#toulmin-형식)).

### Disposition {#레이아웃}

```
ID               enregistrement LOCAL Reference (Edge Id)
en-tête 1 WORD   role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | genre d'object 2b | flags 7b
[F_FUNC]         FuncRef : REF (ALIAS, 0 si absent) + VerbCode 1 WORD
[F_QUAL]         Value SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF (cas)
[F_CLAIM]        Claim : REF (subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      Value SIGNED-DECIMAL. Valeur initiale du verdict
[F_WITH]         nombre (Value UNSIGNED-INTEGER) + REF (TEXT) × nombre
[F_GROUNDS]      nombre (Value UNSIGNED-INTEGER) + REF (TEXT) × nombre
SPAN             largeur fixée par SOURCE × 2 (octet de début, nombre d'octets)
```

#### WORD d'en-tête {#헤더-word}

| Bits | Champ | Valeur |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | Il y a une liste de fondements |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | genre d'object | Forme de l'object de Claim. 0 REF, 1 Value UNSIGNED-INTEGER, 2 SPAN |
| 6–0 | flags | Tableau ci-dessous |

| Bit | flag | Sens |
|---|---|---|
| b0 | F_FUNC | Il y a un champ FuncRef |
| b1 | F_QUAL | Il y a un champ Qualifier |
| b2 | F_CHECK | Il y a un champ de cas cible de `checking` |
| b3 | F_CLAIM | Il y a un champ Claim |
| b4 | F_VERDICT | Il y a un champ de valeur initiale du verdict |
| b5 | F_STRIKE | Déclaration barrée. Pas de champ |
| b6 | F_WITH | Il y a un champ de liste de critères |

- Les champs conditionnels sont placés dans l'ordre des flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Un champ dont le flag est éteint n'occupe pas de place.
- Si un flag est allumé sans le champ, on refuse. La position atteinte en lisant les champs à la suite, après SPAN, doit coïncider exactement avec la fin de l'enregistrement.

### Champs {#필드}

| Champ | Description |
|---|---|
| FuncRef | Place de la fonction. REF est l'enregistrement ALIAS qui a importé cette fonction, et `0` s'il s'agit d'une fonction de ce document. VerbCode est un code de 1 WORD, pas encore attribué (`0x0000` autorisé). La notation originale de la fonction s'écrit à part par TEXT + [LABEL](#link) |
| Qualifier | Confiance du nœud (0~1) |
| cas | F_CHECK : cas que ce nœud ne fait que juger (`checking c`) |
| Claim | Proposition portée par le nœud. REF de subject, predicate 1 WORD, object, mode 1 WORD. La forme de l'object est fixée par le genre d'object de l'en-tête |
| valeur de verdict | Valeur initiale du verdict (−1~1) |
| F_WITH | Critères de verdict au moment de la déclaration (`기준으로 하는`). Liste de REF d'enregistrements TEXT |
| F_GROUNDS | Noms de faits externes résolus au moment de l'évaluation (`근거로 하는`). Liste de REF d'enregistrements TEXT |
| SPAN | Plage du texte original dont est issue cette déclaration |

- La notation de la valeur de verdict et du Qualifier suit les règles numériques de [TOULMIN](#수치).
- Le nombre d'une liste est un enregistrement Value [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) intégré.
- La forme de base d'un Claim d'énoncé a subject et predicate à `0` et l'object en SPAN (genre d'object 2). Il est fixé sur la notation du texte original.

### Interprétation et validité {#해석과-유효성}

- Pour RULE·COUNTER·EXCEPT-DECLARE, role doit être identique au Codec (0 general, 1 counter, 2 except). Pour SPEC-DECLARE, c'est le genre de définition. Pour les autres Codec, c'est 0.
- Si level vaut 0 (Unset), on emploie la valeur par défaut du moteur : Fail pour COUNTER-DECLARE, Review pour EXCEPT-DECLARE.
- La règle de fonction hôte de `tangl:규칙` de TANGEUL (`쓰는 규칙이다`) s'écrit en NODE RULE-DECLARE hors d'un cas. La fonction est F_FUNC, les critères F_WITH, les fondements F_GROUNDS. Pour une règle à expression conditionnelle seulement, on place devant un [PREDICATE-DECLARE](0x101L-predicate-declare.md).
- Les bits Reserved (13–12) doivent valoir 0. Si un bit Reserved est allumé ou si role ne correspond pas au Codec, on refuse.

### Pages liées {#관련-페이지-1}

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE et divisions](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK est la disposition qui écrit les relations entre nœuds dans le graphe TOULMIN. Le genre de relation est fixé par le Codec.

### Codec {#codec-1}

| Codec | Nom | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | règle → règle. Réduit progressivement le verdict de la force d'attaque |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | règle → règle. Si Active, retire la cible de l'agrégation |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | règle → cas |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | règle → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | règle → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | règle → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | règle → cas. Verdict sans effet de bord |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | cas → champ |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | entrée de définition → valeur ou type |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | entrée de définition → champ |
| `0x12EL` | [RUNS](0x12EL-runs.md) | point d'entrée `run c` | point d'entrée → cas (exécution) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | point d'entrée `check c` | point d'entrée → cas (verdict) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | déclencheur `run c` | déclencheur → cas |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | déclencheur → cas |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | nœud → identifiant global |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | alias → chemin (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | nom entre accents graves | nœud → TEXT. Notation du nom |

### Disposition {#레이아웃-1}

```
ID               enregistrement LOCAL Reference (Edge Id)
src              REF
dst              REF. Pour DO·DO-ONCE·UNDO, FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         opérateur 1 WORD (2 bits de poids fort) + Value UNSIGNED-DECIMAL (pourcentage)
[F_FORCE]        Value SIGNED-DECIMAL. Force d'attaque (0~1). ATTACKS seulement
SPAN             largeur fixée par SOURCE × 2
```

| flag | Sens |
|---|---|
| b0 F_ONCE | S'exécute une seule fois (`once` d'UNDO) |
| b1 F_GATE | Il y a un champ de barrière de confiance |
| b2 F_STRIKE | Relation barrée |
| b3 F_ORDERED | Appartient à une liste ordonnée `1.` |
| b4 F_FORCE | Il y a un champ de force d'attaque. ATTACKS seulement |

| Opérateur de barrière | Sens |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Les champs conditionnels sont placés dans l'ordre des flags (F_GATE, F_FORCE). Un champ dont le flag est éteint n'occupe pas de place.

### Force d'attaque {#공격-세기}

La force d'attaque (F_FORCE) n'est employée que par [ATTACKS](0x108L-attacks.md#공격-세기). L'expression de verdict, la notation et les exemples sont sur cette page.

### Interprétation et validité {#해석과-유효성-1}

- REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](#공통-필드)).
- La forme de dst est fixée par le Codec. Pour DO·DO-ONCE·UNDO, c'est FuncRef (REF(ALIAS, 0 si absent) + VerbCode 1 WORD, [NODE](#필드)) ; pour LABEL·IMPORTED-FROM, le REF d'un enregistrement TEXT ; pour les autres, le REF d'un nœud.
- `do … once` est exprimé par le Codec DO-ONCE. Dans les flags de DO-ONCE, on n'emploie pas F_ONCE (s'il est allumé, on refuse). Le `once` d'UNDO s'écrit par F_ONCE.
- L'opérateur de barrière occupe les 2 bits de poids fort du WORD d'opérateur, les 14 autres bits valent 0. Le pourcentage est une Value UNSIGNED-DECIMAL avec `E=0`, de 0 à 100.
- Les bits b5~b15 de flags sont Reserved et doivent valoir 0. Sinon, on refuse.
- F_FORCE n'est employé que par ATTACKS. S'il est allumé dans un autre Codec (SUPERSEDES, liens d'exécution et de verdict, relations du format TOULMIN), on refuse.
- On refuse si la force d'attaque n'est pas une Value SIGNED-DECIMAL, si elle sort de 0~1, ou si elle ne peut pas s'exprimer exactement avec 4 décimales.
- Une chaîne `A > B > C` de SUPERSEDES s'écrit avec un SUPERSEDES par paire.

### Pages liées {#관련-페이지-2}

- [TOULMIN](_index.md), [NODE](#node), [SOURCE et divisions](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE et divisions {#source와-구획}

Enregistrements qui écrivent le texte original et les divisions d'un document TOULMIN. Tous sont des codes directs `0x120L~0x125L` de la famille de format TOULMIN d'Edge ([TOULMIN](#toulmin-형식)). Il n'y a pas de champ Issuer ni de numéro de Codec : le Payload suit directement le TAG.

### Format {#형식}

| Codec | Nom | Disposition |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, WORD de largeur SPAN, Value UTF8 |
| `0x121L` | [TEXT](0x121L-text.md) | ID, Value UTF8 |
| `0x122L` | [SECTION](0x122L-section.md) | ID, code de section 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (cas) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (cas) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID est l'Edge Id, REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](#공통-필드)).
- Une Value UTF8 est un enregistrement Value [UTF8-TEXT](../value/0x072L-utf8-text.md). Elle contient les octets tels quels.

### Pages par format {#형식별-쪽}

La disposition, le tableau des codes de section et l'interprétation ont chacun leur page par format.

- [SOURCE](0x120L-source.md) : texte original d'écriture. Premier enregistrement du BODY, fixe la largeur de SPAN
- [TEXT](0x121L-text.md) : nom ou chaîne
- [SECTION](0x122L-section.md) : début de section et code de section
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md) : portée d'un cas
- [PROSE](0x125L-prose.md) : paragraphe descriptif

### Pages liées {#관련-페이지-3}

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
