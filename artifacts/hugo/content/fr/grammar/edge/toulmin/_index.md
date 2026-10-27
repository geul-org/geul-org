---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Les Edge TOULMIN (Codec 0x60~0x7B) écrivent des graphes de jugement et d'exécution selon le modèle d'argumentation de Toulmin. Cette page fixe les règles des documents TOULMIN, les champs communs, la table des codes, les règles numériques et le noyau fixe de l'auto-révision."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Les Edge de la famille TOULMIN (2 bits de poids fort du Codec `11`, codes directs `0x60`~`0x7B`) écrivent des graphes de jugement et d'exécution selon le modèle d'argumentation de Toulmin. Déclarations d'assertions, de réfutations et d'exceptions, relations d'attaque et d'exclusion, liens d'exécution et résultats de jugement sont tous des Edge. Un document TANGEUL (le langage de règles du moteur toulmin) devient un document GEUL. L'extension de fichier est `.geul`, comme les autres documents.

Ce que cette page ne fixe pas suit les règles communes d'[Edge](/fr/grammar/edge/) et d'[Enregistrement et TAG WORD](/fr/grammar/record/).

## Méta-cognition et auto-révision

TOULMIN est un Codec de GEUL pour que GEUL ait une méta-cognition de lui-même. Les règles de jugement et d'exécution doivent elles aussi être décrites en GEUL pour que TOULMIN puisse les prendre pour objet et se corriger de lui-même. TOULMIN n'est donc pas un profil d'application mais le cœur du fonctionnement de GEUL, et se place dans l'espace des codes directs d'Edge (`0x60`~`0x7B`).

- L'auto-description permet l'auto-amélioration mais fait courir le risque d'erreur circulaire. Si une règle juge elle-même sa propre révision, une révision qui relâche les critères de jugement peut aussi passer (le taux de réussite monte, la précision réelle baisse).
- On accepte la circularité comme un risque mais on la coupe par la structure.
  - **Noyau fixe** : le sens du jugement (Pass, Review, Fail ; attaque, exclusion, priorité ; évaluation à 3 valeurs et U → Review de [Juger sur l'inconnu](#juger-sur-linconnu) ci-dessous) est fixé dans cette spécification. Il ne peut pas être changé par un document TOULMIN. C'est la même place que les règles intégrées au décodeur (couche 0 de [Adresse de publication et liste des versions](/fr/grammar/publishing/#couches)).
  - **Séparation des éditions** : la révision du document de règles v(n) est jugée par les règles v(n−1) et un contrôle externe. Une règle ne se juge pas elle-même. Le résultat de jugement se place dans un autre document que la cible (le hachage du contenu de la cible ne change pas).
  - **Historique immuable** : les révisions s'accumulent en nouvelles versions (`PARENT`, hachage du contenu, signature). Les anciennes versions subsistent, ce qui permet de repérer après coup une erreur circulaire et de revenir en arrière. Le filet de sécurité de l'auto-révision est le modèle d'éditions de GEUL ([Document](/fr/grammar/document/#révision)).
  - **Critère externe** : on tient à part un ensemble de cas de test que la voie de révision ne peut pas toucher. L'adoption d'une révision se vérifie par le résultat de cet ensemble.
- Test de réfutation : on plante volontairement une règle fausse. Si le système la corrige et que le score du critère externe monte, l'auto-amélioration fonctionne. Si seul le taux de réussite monte et que le score du critère externe baisse, c'est une erreur circulaire.

## Codes

Un enregistrement TOULMIN emploie l'une de trois dispositions. La disposition est fixée par le Codec (ou le numéro de format).

| Disposition | Usage | Page |
|---|---|---|
| NODE | Nœud de graphe : cas, règle, définition, point d'entrée | [NODE](/fr/grammar/edge/toulmin/node/) |
| LINK | Relation entre nœuds (attaque, exclusion, exécution, définition) | [LINK](/fr/grammar/edge/toulmin/link/) |
| EXPR | Expression conditionnelle (prédicat) | [EXPR](/fr/grammar/edge/toulmin/expr/) |

Les enregistrements de texte original et de sections (SOURCE, TEXT, SECTION, CASE-BEGIN et CASE-END, PROSE) sont fixés par [SOURCE et sections](/fr/grammar/edge/toulmin/source/).

### Codes directs

| Codec | Nom | Disposition | TANGEUL | Sens |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/fr/grammar/edge/toulmin/node/) | NODE | `in case of` | Déclaration de cas. Graphe de jugement contenant nœuds et relations |
| `0x61` | [PREDICATE-DECLARE](/fr/grammar/edge/toulmin/expr/) | EXPR | Expression conditionnelle de Rules | Déclaration de prédicat. Expression de jugement |
| `0x62` | [SPEC-DECLARE](/fr/grammar/edge/toulmin/node/) | NODE | Élément de Definitions | Déclaration de critère de jugement (Backing). Les bits de role donnent le genre de définition |
| `0x63` | [RULE-DECLARE](/fr/grammar/edge/toulmin/node/) | NODE | general rule, nom de règle de Rules | Déclaration d'assertion (Warrant). Peut être attaquée |
| `0x64` | [COUNTER-DECLARE](/fr/grammar/edge/toulmin/node/) | NODE | counter rule | Déclaration de réfutation. Attaque avec sa propre conclusion. Level par défaut : Fail |
| `0x65` | [EXCEPT-DECLARE](/fr/grammar/edge/toulmin/node/) | NODE | except rule | Déclaration d'exception. Attaque sans conclusion propre. Level par défaut : Review |
| `0x68` | [ATTACKS](/fr/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | Relation d'attaque. Le jugement de l'attaquant entame progressivement celui de la cible |
| `0x69` | [SUPERSEDES](/fr/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | Relation d'exclusion. Si l'attaquant est Active, la cible est retirée de l'agrégation de façon déterminante. Une chaîne (`A > B > C`) s'écrit une paire à la fois |
| `0x6A` | SUPERSEDE-CHAIN | — | | Chaîne de priorité `A > B > C`. Forme abrégée de SUPERSEDES deux à deux. Seul le code est attribué, la disposition n'existe pas encore |
| `0x70` | [RUN](/fr/grammar/edge/toulmin/link/) | LINK | `run c when n` | Composition d'exécution. Si le nœud est Active, exécute le cas inférieur (DAG) |
| `0x71` | [DO](/fr/grammar/edge/toulmin/link/) | LINK | `do fn when n` | Action exécutée si le nœud est Active |
| `0x72` | [DO-ONCE](/fr/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | Action exécutée une seule fois même en cas de nouvelle tentative |
| `0x73` | [UNDO](/fr/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | Action de compensation d'un DO (saga). Si une étape ultérieure échoue, elle s'exécute dans l'ordre inverse |
| `0x74` | [CHECKING](/fr/grammar/edge/toulmin/link/) | LINK | `checking c` | Lien qui se borne à juger, sans effet de bord |
| `0x75` | [ENTRY](/fr/grammar/edge/toulmin/node/) | NODE | `provides x` | Point d'entrée externe. Exécute ou juge un cas |
| `0x76` | [TRIGGER](/fr/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | Point d'entrée d'événement ou périodique, sans appel externe |
| `0x78` | VERDICT | — | | Résultat de jugement d'un nœud ou d'un enregistrement. Résultat (Pass, Review, Fail), valeur de jugement, Activated, Excluded, Level. Seul le code est attribué, la disposition n'existe pas encore |
| `0x79` | EVIDENCE | — | | Preuve du jugement. Emplacement, valeur attendue, valeur réelle (Fact). Seul le code est attribué, la disposition n'existe pas encore |
| `0x7C`~`0x7F` | ISSUER-* | | | Format défini par un Issuer. Voir les formats ISSUER ci-dessous |

- Les codes directs absents du tableau (`0x66` et `0x67`, `0x6B`~`0x6F`, `0x77`, `0x7A` et `0x7B`) sont réservés.
- Les 2 bits de poids fort des 5 bits de poids faible du Codec forment le groupe : `00` déclarations, `01` relations, `10` exécution, `11` résultats (`0x7C`~`0x7F` sont ISSUER).
- Le jugement du document entier relève du Meta [VERDICT](/fr/grammar/meta/verification/verdict/) (`0x44`), celui des nœuds et enregistrements du TOULMIN `VERDICT` (Edge `0x78`). Ce sont deux Codec distincts, de Kind différents.

### Formats ISSUER

Les enregistrements TOULMIN pour lesquels les codes directs manquent se placent sous `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` (GEUL) avec un numéro de format. Les numéros de format sont de la famille TOULMIN (`0xC000`~`0xFFFF`, 2 bits de poids fort `11`).

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[TAG d'extension de Length]
Issuer            0x0000
Numéro de format  0xC000~0xC029
Edge Id           enregistrement Reference LOCAL
Composants        disposition fixée par le format
```

| Numéro de format | Nom | Disposition | Sens |
|---|---|---|---|
| `0xC000` | [SOURCE](/fr/grammar/edge/toulmin/source/) | ID, WORD de largeur de SPAN, Value UTF8 | Texte original rédigé |
| `0xC001` | [TEXT](/fr/grammar/edge/toulmin/source/) | ID, Value UTF8 | Nom, chaîne de caractères |
| `0xC002` | [SECTION](/fr/grammar/edge/toulmin/source/) | ID, code de section 1 WORD | Début de section |
| `0xC003` | [CASE-BEGIN](/fr/grammar/edge/toulmin/source/) | ID, REF (cas) | Début de l'étendue d'un cas |
| `0xC004` | [CASE-END](/fr/grammar/edge/toulmin/source/) | ID, REF (cas) | Fin de l'étendue d'un cas |
| `0xC005` | [PROSE](/fr/grammar/edge/toulmin/source/) | ID, SPAN | Paragraphe descriptif |
| `0xC010` | [NAMESPACE](/fr/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/fr/grammar/edge/toulmin/node/) | NODE | Référence de fonction |
| `0xC012` | [FIELD](/fr/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/fr/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/fr/grammar/edge/toulmin/node/) | NODE | Groupe d'exécution ordonné |
| `0xC020` | [REQUIRES](/fr/grammar/edge/toulmin/link/) | LINK | Cas → champ |
| `0xC021` | [MEANS](/fr/grammar/edge/toulmin/link/) | LINK | Terme défini → valeur ou type |
| `0xC022` | [HAS](/fr/grammar/edge/toulmin/link/) | LINK | Terme défini → champ |
| `0xC023` | [RUNS](/fr/grammar/edge/toulmin/link/) | LINK | Point d'entrée → cas, exécution |
| `0xC024` | [EVALUATES](/fr/grammar/edge/toulmin/link/) | LINK | Point d'entrée → cas, jugement |
| `0xC025` | [TRIGGERS](/fr/grammar/edge/toulmin/link/) | LINK | Déclencheur → cas |
| `0xC026` | [UNTIL](/fr/grammar/edge/toulmin/link/) | LINK | Déclencheur → cas (`every … until`) |
| `0xC027` | [SAME-AS](/fr/grammar/edge/toulmin/link/) | LINK | Nœud → identifiant global |
| `0xC028` | [IMPORTED-FROM](/fr/grammar/edge/toulmin/link/) | LINK | Alias → chemin (TEXT) |
| `0xC029` | [LABEL](/fr/grammar/edge/toulmin/link/) | LINK | Nœud → TEXT, notation du nom |

- L'espace des numéros de format est distinct pour chaque Kind. Le format GEUL `0xC000` de Value (OPAQUE-BYTES-EVEN) et le `0xC000` d'Edge (SOURCE) sont des formats différents.
- Les numéros de format ne font que s'ajouter. Un numéro attribué n'est pas réutilisé pour un autre format.

## Document

Un fichier `.geul` est un DOC. On ne place aucun autre octet hors du DOC.

```
DOC-1WORD/2WORD/4WORD     longueur totale
  SPEC-VERSION            0x0001 (v1, entier sans Value intégrée)
  PROFILE                 Value UTF8 "tangeul-<major>.<minor>". Actuellement "tangeul-1.0"
  [DEFAULT-LANGUAGE]      Value LANGUAGE-BCP47-CODE. Locale de rédaction ("en", "ko")
BODY
  SOURCE                  texte original rédigé. Premier enregistrement du BODY
  enregistrements de phrases …   ordre de déclaration du document
END
```

- HEAD : [SPEC-VERSION](/fr/grammar/meta/declaration/spec-version/), [PROFILE](/fr/grammar/meta/declaration/profile/), et facultativement [DEFAULT-LANGUAGE](/fr/grammar/meta/declaration/default-language/).
- Le décodeur rejette si SPEC-VERSION diffère ou si le major de PROFILE diffère. Si seul le minor diffère, il lit.
- Le premier enregistrement du BODY est SOURCE. Tout SPAN est une étendue dans ce texte original.
- L'ordre des enregistrements de phrases est identique à l'ordre de déclaration du document. L'ordre d'exécution (déclenchement de `do` et `run`, compensation de `undo` dans l'ordre inverse) s'appuie sur cet ordre. Dans un document TOULMIN, l'ordre des Edge a un sens (exception à la règle d'ordre d'[Edge](/fr/grammar/edge/)).
- Tous les enregistrements du BODY sont des Edge. On ne place pas de Value indépendante. Les valeurs sont intégrées au Payload des Edge.
- L'identité du cas et les imports emploient les Meta [DOC-ID](/fr/grammar/meta/declaration/doc-id/) et [IMPORT-DOC](/fr/grammar/meta/import/import-doc/) (Subject et See de TANGEUL).

## Champs communs

| Champ | Largeur | Description |
|---|---|---|
| ID | Enregistrement Reference LOCAL | Edge Id de l'enregistrement. Premier élément du Payload de tout enregistrement |
| REF | Enregistrement Reference LOCAL | Edge Id désignant un autre enregistrement de ce document. `0` signifie aucun |
| SPAN | Largeur fixée par SOURCE × 2 | Étendue dans le texte original rédigé. Octet de début, nombre d'octets |

- ID et REF sont des enregistrements Reference [LOCAL](/fr/grammar/reference/local/) intégrés (`0000 0LLL L000 1000` + ID sur la largeur la plus courte). La largeur est fixée par la Length de cet enregistrement et ne se déclare pas pour le document.
- REF `0` (LOCAL `0`) signifie « aucun ». C'est une règle de Codec qui emploie LOCAL `0` comme absence ([LOCAL](/fr/grammar/reference/local/)).
- Les Edge Id sont attribués à partir de 1 et ne se répètent pas dans le document. `0` étant l'« aucun » de REF, il n'est pas employé comme Edge Id.
- Les nœuds étant référencés en avant par d'autres enregistrements, ils reçoivent d'abord leur numéro dans l'ordre de déclaration du document. Les autres enregistrements (SOURCE, TEXT, LINK, FUNC, enregistrements de sections) reçoivent leur numéro de l'encodeur à partir du numéro qui suit les nœuds.
- Le décodeur ne vérifie que l'Edge Id est différent de 0 et sans doublon. L'ordre d'attribution n'entre pas dans l'interprétation.
- Les nœuds et les relations se désignent par Edge Id.
- Une Value intégrée est l'enregistrement Value tel quel, TAG WORD compris. Sa longueur est fixée par ce TAG.

## Valeurs numériques

- La valeur de jugement (−1 à 1) et le Qualifier (0 à 1) sont des Value [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/). On ne prévoit pas de format à virgule fixe à part.
- L'encodeur supprime les zéros de fin du coefficient. 0,8 est `C=8, E=−1`. Le décodeur accepte jusqu'à 4 décimales.
- Un seuil de confiance (par ex. `at least 75%`) s'écrit avec 1 WORD d'opérateur de comparaison et une Value [UNSIGNED-DECIMAL](/fr/grammar/value/decimal/unsigned-decimal/) en pourcentage (`E=0`) ([LINK](/fr/grammar/edge/toulmin/link/) F_GATE).

## Axes de déclaration des nœuds

- Une déclaration de nœud (RULE, COUNTER, EXCEPT-DECLARE) a un rôle (assertion, réfutation, exception), un Qualifier (0 à 1) et un Level (Unset, Fail, Review). Le rôle est porté par le Codec et le role de l'en-tête NODE, le Qualifier par F_QUAL, le Level par le level de l'en-tête ([NODE](/fr/grammar/edge/toulmin/node/)).
- La force (Strict, Defeasible, Defeater) est un axe distinct du rôle. Son placement n'est pas encore fixé.

## Juger sur l'inconnu

Quand un graphe de jugement reçoit des faits GEUL en entrée, les trois notions de [marqueur d'emplacement](/fr/grammar/reference/slot-marker/) (non renseigné, inconnu, aucune valeur) s'évaluent différemment. L'évaluation des opérateurs de comparaison d'[EXPR](/fr/grammar/edge/toulmin/expr/) est la suivante.

| Entrée | `is empty` | `is not empty` | `equals` / `is in` / comparaison de taille |
|---|---|---|---|
| Valeur v | faux | vrai | évalué avec v |
| NO-VALUE (aucune valeur) | **vrai** | faux | faux |
| UNKNOWN-VALUE (inconnu) | faux | **vrai** | **indéterminé (U)** |
| ABSENT (non renseigné) / pas de description | U (monde ouvert) | U | U |

- La logique est celle de Kleene à 3 valeurs fortes. `NOT U = U`, `faux AND U = faux`, `vrai OR U = vrai`. Pour les autres combinaisons, U donne U.
- `EXISTS any` est vrai si l'un des éléments est vrai. S'il n'y a pas de vrai mais un U, c'est U ; si tous sont faux, c'est faux.
- **Si le prédicat est U, le jugement du nœud n'est ni Pass ni Fail mais Review.** Quand on ne sait pas, on passe la main à un humain (ou à l'étape suivante).
- Pour traiter ABSENT comme empty plutôt que U, il faut que l'entrée **déclare** un monde fermé (injecté comme critère de jugement SPEC, par ex. « les entrées de ce cas sont complètes »). Sans déclaration, c'est U.
- Ce tableau et la correspondance U → Review sont le sens du jugement, donc **le noyau fixe**. Un document TOULMIN ne peut pas les changer.
- Exemple : la règle « ne compter que les frontières encore valides » (`P582 is empty`) exclut si P582 = UNKNOWN-VALUE (faux), inclut si P582 = NO-VALUE (vrai), et envoie en Review si P582 est absent (U).

## Résultat de jugement

- Les résultats de jugement (`VERDICT`, `EVIDENCE`) se placent dans un autre document que la cible du jugement. Le document de résultat importe le document cible par [IMPORT-DOC](/fr/grammar/meta/import/import-doc/) et le désigne par [EXTERNAL-POINTER-*](/fr/grammar/reference/external-pointer/). Juger ne change donc pas le hachage du contenu du document cible.
- Le jugement du document entier est le Meta `VERDICT`, celui des nœuds et enregistrements le TOULMIN `VERDICT`.
- Les règles qui choisissent l'édition applicable d'une révision (dispositions transitoires, choix entre loi du moment des faits et loi nouvelle) ainsi que les interprétations officielles et la jurisprudence s'écrivent aussi comme règles de jugement ([Document](/fr/grammar/document/#révision)).

## Problèmes ouverts

- Disposition de SUPERSEDE-CHAIN (`0x6A`), VERDICT (`0x78`) et EVIDENCE (`0x79`). La méthode actuelle de SUPERSEDES paire par paire suffit-elle pour les chaînes.
- Placement de la force des nœuds (Strict, Defeasible, Defeater).
- Dans EXPR, le nombre de nœuds et le nombre d'étiquettes, l'indice d'étiquette est de 1 WORD et le nombre d'enfants de 13 bits. Les plafonds sont fixes.
- Disposition de PROVENANCE (origine et prémisses des règles).
- Remplacer ou non TEXT + LABEL (`0xC029`) par les [LABEL](/fr/grammar/edge/label/) et [BIND](/fr/grammar/edge/bind/) de description pour les noms entre accents graves.
- Table des valeurs de code de predicate et mode de Claim et de VerbCode de FuncRef.
- Déclaration de monde fermé (lire ABSENT comme empty) : au niveau du critère de jugement (SPEC) ou du cas.
- [Documents de spécification de Codec](/fr/grammar/codec-spec/) des Codec TOULMIN. Les champs conditionnels de NODE et LINK et la largeur de SPAN fixée par SOURCE sont des dispositions qu'on ne peut pas déclarer par FIELD.

## Pages liées

- [NODE](/fr/grammar/edge/toulmin/node/), [LINK](/fr/grammar/edge/toulmin/link/), [EXPR](/fr/grammar/edge/toulmin/expr/), [SOURCE et sections](/fr/grammar/edge/toulmin/source/)
- [Edge](/fr/grammar/edge/), [Document](/fr/grammar/document/), [PROFILE](/fr/grammar/meta/declaration/profile/)
