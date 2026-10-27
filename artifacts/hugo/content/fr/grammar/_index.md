---
title: "Grammaire GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Spécification de la grammaire GEUL v1. Elle définit les enregistrements sur des mots de 16 bits, les quatre Kind et tous les Codec, la structure du document, l'Issuer et les règles de publication."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

Spécification de la grammaire GEUL v1. Pour une première lecture, suivez l'ordre ci-dessous.

1. [Aperçu](/fr/grammar/overview/) — ce qu'est GEUL et selon quels principes il est conçu
2. [Enregistrement et TAG WORD](/fr/grammar/record/) — TAG WORD de 16 bits, Kind, Length, Codec
3. [Document](/fr/grammar/document/) — HEAD et BODY, hachage du contenu, versions et révisions
4. [Reference](/fr/grammar/reference/), [Value](/fr/grammar/value/), [Edge](/fr/grammar/edge/), [Meta](/fr/grammar/meta/) — les quatre Kind
5. [Issuer et publication](/fr/grammar/issuer/) — l'entité qui émet documents et formats, table d'attribution des 1 WORD, mode de publication, signature et clé de vérification
6. [Adresse de publication et liste des versions](/fr/grammar/publishing/) — notation des ID, adresse de publication, spécification de format, index des noms, liste des versions, niveaux de confiance
7. [Documents de spécification de Codec](/fr/grammar/codec-spec/) — écrire la disposition d'un Codec comme un document GEUL
8. [Exemple : un élément Wikidata](/fr/grammar/example/) — un document réel complet

Cette page est l'index de tous les Codec. Cliquez sur un nom pour accéder à la page détaillée de ce Codec. Un nom sans lien n'a pas encore de page détaillée. Les codes directs absents des tableaux sont réservés.

## Kind

Le TAG WORD est `000K KLLL LCCC CCCC`. `KK` est le Kind, `LLLL` la Length, `CCC CCCC` le Codec sur 7 bits. Pour Reference toutefois, le Codec fait 4 bits et le Quantifier 3 bits.

| Valeur | Catégorie | Description |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/fr/grammar/reference/) | Enregistrement qui désigne une cible. `QQQ` est le Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/fr/grammar/value/) | Enregistrement de valeur |
| `0001 0LLL LCCC CCCC` | [Edge](/fr/grammar/edge/) | Enregistrement de composition |
| `0001 1LLL LCCC CCCC` | [Meta](/fr/grammar/meta/) | Enregistrement portant sur le document et les enregistrements |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/fr/grammar/reference/)

### Codec (`CCCC`)

| CCCC | Nom | Catégorie | ID de la cible |
|---|---|---|---|
| `0000` | [Marqueur d'emplacement](/fr/grammar/reference/slot-marker/) | Réservé | Lot de marqueurs de 1 WORD qui ne désignent aucune cible. Les 3 bits de poids faible forment le numéro du marqueur (tableau ci-dessous) |
| `0001` | [LOCAL](/fr/grammar/reference/local/) | Déclaration | ID émis par ce document |
| `0010` | [GEUL](/fr/grammar/reference/geul/) | Déclaration | Entité émise en CC0 par geul.org. Les petits numéros sont attribués aux entités très fréquentes |
| `0011` | [GEUL-SIDX](/fr/grammar/reference/geul-sidx/) | Déclaration | GEUL SIDX (Semantic-aligned Index). Identifiant dont les bits portent du sens |
| `0100` | [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) | Déclaration | Élément Wikidata. Entier qui suit `Q` |
| `0101` | [WIKIDATA-PID](/fr/grammar/reference/wikidata-pid/) | Déclaration | Propriété Wikidata. Entier qui suit `P` |
| `0110` | [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/) | Pointeur-déclaration | L'Issuer lui-même. Le Payload se réduit à l'Issuer (1/2/4/16 WORD) et il n'y a pas d'ID de cible |
| `0111` | [DOC-POINTER](/fr/grammar/reference/doc-pointer/) | Pointeur-déclaration | Une version d'un document d'un Issuer. Issuer + ID de document 4 WORD + ID de version 2 WORD, sans ID de cible |
| `1000` | [EXTERNAL-POINTER-1WORD](/fr/grammar/reference/external-pointer/) | Pointeur | LOCAL ID d'un document importé par `IMPORT-DOC`. IMPORT ID de 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/fr/grammar/reference/external-pointer/) | Pointeur | Idem. IMPORT ID de 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/fr/grammar/reference/external-pointer/) | Pointeur | Idem. IMPORT ID de 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/fr/grammar/reference/external-pointer/) | Pointeur | Idem. IMPORT ID de 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/fr/grammar/reference/external-issuer/) | Pointeur-déclaration | LOCAL ID d'un document d'un Issuer de 1 WORD |
| `1101` | [EXTERNAL-ISSUER-2WORD](/fr/grammar/reference/external-issuer/) | Pointeur-déclaration | LOCAL ID d'un document d'un Issuer de 2 WORD |
| `1110` | [EXTERNAL-ISSUER-4WORD](/fr/grammar/reference/external-issuer/) | Pointeur-déclaration | LOCAL ID d'un document d'un Issuer de 4 WORD |
| `1111` | [EXTERNAL-ISSUER-16WORD](/fr/grammar/reference/external-issuer/) | Pointeur-déclaration | LOCAL ID d'un document d'un Issuer de 16 WORD |

### Marqueur d'emplacement (Codec `0000`)

`0000 0000 0000 0MMM` — [Marqueur d'emplacement](/fr/grammar/reference/slot-marker/). Il n'apparaît à cet emplacement que si la liste CODEC du champ admet exactement ce WORD.

| WORD | Nom | Sens | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/fr/grammar/reference/slot-marker/) | Non renseigné. Un champ facultatif est omis. Rien n'est affirmé sur le monde | pas de snak |
| `0x0001` | [UNKNOWN-VALUE](/fr/grammar/reference/slot-marker/) | Inconnu. Une valeur existe mais on ne sait pas laquelle | `somevalue` |
| `0x0002` | [NO-VALUE](/fr/grammar/reference/slot-marker/) | Aucune valeur. Il n'y a pas de valeur | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | Nom | Signification | Exemple |
|---|---|---|---|
| `000` | Identified | Individu identifié | Elon Musk, la France |
| `001` | Generic | Énoncé général ou définitoire sur toute une espèce. Admet des exceptions. | Le soldat obéit aux ordres |
| `010` | Free-choice | N'importe quelle cible satisfaisant la condition | N'importe quel soldat |
| `011` | Universal | Toutes les cibles appartenant à l'étendue donnée | Tous les soldats |
| `100` | Variable | Variable de discours | cette personne, cette femme |
| `101`~`111` | Reserved |  |  |

- Avec le Codec `0000` (marqueur d'emplacement), les 3 bits de poids faible ne sont pas un Quantifier mais le numéro du marqueur.

## Issuer

L'Issuer est l'entité qui définit documents et formats — [Issuer et publication](/fr/grammar/issuer/)

| Emplacement | Sens |
|---|---|
| Codes ISSUER de Value et Edge (`0x7C`~`0x7F`) | Format défini par cet Issuer |
| Meta `DOC-ID` | Issuer qui a émis ce document |
| Meta `IMPORT-DOC` | Issuer qui a émis le document importé |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER` | Issuer qui a émis le document désigné (1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | L'Issuer désigné lui-même (1/2/4/16 WORD) |

| Largeur de l'Issuer | Attribution |
|---|---|
| 1 WORD | geul.org l'attribue aux organismes de normalisation et aux grandes institutions ([Table des Issuer de 1 WORD](/fr/grammar/issuer/#table-des-issuer-de-1-word)). |
| 2 WORD | Enregistré auprès de geul.org. Issuer ayant passé la preuve de propriété d'un domaine (par ex. company.com) |
| 4 WORD | Enregistré auprès de geul.org. Issuer enregistré sans preuve de propriété |
| 16 WORD | Auto-émis. Calculé à partir de la clé publique, sans enregistrement. Suit les règles de génération ci-dessous. |

### Algorithmes de signature de l'Issuer de 16 WORD

| ID d'algorithme de signature | Algorithme |
|---|---|
| `0x0001` | Ed25519 |
| Autres | Réservé |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/fr/grammar/edge/)

Les 2 bits de poids fort du Codec forment la famille. Le code direct (7 bits) et le numéro de format ISSUER (16 bits) suivent la même règle.

| 2 bits de poids fort | Famille | Code direct | Numéro de format |
|---|---|---|---|
| `00` | Description | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | Fondement | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | Exécution | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/fr/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Description (`00`)

| CCCCC | Codec | Nom | Sous-format | Description |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/fr/grammar/edge/reference-node/) |  | Liaison orientée où un Subject de type Reference désigne un Object |
| `00001` | `0x01` | [SAME-NODE](/fr/grammar/edge/same-node/) |  | Identité : deux Reference désignent la même cible |
| `00010` | `0x02` | [DIFFERENT-NODE](/fr/grammar/edge/different-node/) |  | Non-identité : deux Reference désignent des cibles différentes |
| `00011` | `0x03` | [BIND](/fr/grammar/edge/bind/) |  | Lie au Subject un nom (`UTF8-TEXT-*`) auquel la machine se conforme. Unique dans son étendue, doit correspondre exactement, sans langue |
| `00100` | `0x04` | [LABEL](/fr/grammar/edge/label/) |  | Associe au Subject son libellé (label) dans une langue. L'Object est UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/fr/grammar/edge/alias/) |  | Associe au Subject un autre nom (alias). Disposition identique à LABEL |
| `00110` | `0x06` | [DESCRIPTION](/fr/grammar/edge/description/) |  | Associe au Subject sa description dans une langue. Disposition identique à LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | Forme abrégée de la description verbale |
| `01001` | `0x09` | VERB |  | Description verbale |
| `01010` | `0x0A` | [TRIPLE](/fr/grammar/edge/triple/) |  | Proposition dans l'ordre Predicate, Subject, Object, avec rank. L'Object est une valeur ou un marqueur UNKNOWN-VALUE ou NO-VALUE. Son sens est l'ensemble de tous les QUALIFIER qui désignent cet Edge Id |
| `01011` | `0x0B` | [QUALIFIER](/fr/grammar/edge/qualifier/) |  | Une condition qui restreint la proposition d'un autre Edge. Property, Target (Edge Id), Value (valeur ou marqueur UNKNOWN-VALUE ou NO-VALUE). Fait partie de la proposition |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | Oui | Structure pour exprimer une vision du monde |
| `10001` | `0x11` | TIMELINE | Oui | Structure exprimant l'ordre des mondes et des événements |
| `10010` | `0x12` | SCENE | Oui | Structure de scène pour décrire des caractéristiques de scénario |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/fr/grammar/edge/publication/) |  | Publication du document. DOC-POINTER, hachage du contenu |
| `11001` | `0x19` | DEPRECATION |  | Dépréciation (deprecate) d'une version publiée. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | Suppression (pierre tombale) d'une version publiée. DOC-POINTER, catégorie de motif |
| `11011` | `0x1B` | [DECLARE](/fr/grammar/edge/declare/) |  | Déclaration de la composition du Payload d'un Codec. Kind et Codec cibles |
| `11100` | `0x1C` | [FIELD](/fr/grammar/edge/field/) |  | Un champ du Payload. DECLARE d'appartenance, largeur : enregistrement (Length du TAG) ou valeur brute de n WORD |
| `11101` | `0x1D` | [ENUM](/fr/grammar/edge/enum/) |  | Une valeur de code d'un champ en valeur brute. Champ, valeur de code |
| `11110` | `0x1E` | [CODEC](/fr/grammar/edge/codec/) |  | Un Kind·Codec admis par un champ. Champ, WORD cible (`000K KLLL LCCC CCCC`, LLLL 0000 exact, 1111 joker ; un marqueur d'emplacement seulement comme cible exacte `0000`~`0002`). Un champ d'enregistrement en admet plusieurs (liste fermée), un champ en valeur brute un seul (cette Value sans TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| 2 bits de poids fort de CCCCC | Groupe |
|---|---|
| `00` | Désignation et noms |
| `01` | Propositions |
| `10` | Structures |
| `11` | Divers |

### Fondement (`01`)

| Codec | Nom | Sous-format | Description |
|---|---|---|---|
| `0x20` | [SOURCE](/fr/grammar/edge/source/) |  | Rattache un enregistrement, ou le document entier, à son origine. Target (Edge Id du BODY ; dans le HEAD, `0` = document entier), Origin (Reference, ABSENT ou UNKNOWN-VALUE). Les propriétés de l'origine s'écrivent par un TRIPLE dont l'origine est le Subject, celles de la citation (date de consultation, emplacement, hachage du texte d'origine) par des QUALIFIER joints au SOURCE. Le SOURCE du document entier et ses QUALIFIER se placent dans le HEAD |
| `0x21`~`0x3F` | Reserved |  |  |

- L'étendue dans le texte d'origine, l'auteur, la confiance, la période d'application par article et les anciens enregistrements s'écrivent par QUALIFIER ; la version d'entrée initiale se calcule à partir de l'historique des versions ([SOURCE](/fr/grammar/edge/source/#expression-des-autres-fondements)).

### Exécution (`10`)

| CCCCC | Codec | Nom | Description |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | Déclaration de fonction. Symbole, liste des symboles de paramètres, type de retour, corps (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | Déclaration de type. Symbole et composition (liste des symboles de champs, valeurs d'énumération, cible d'alias) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | Expression constante. Une Value intégrée |
| `01001` | `0x49` | UNARY | Expression unaire. Opérateur 1 WORD, opérande |
| `01010` | `0x4A` | BINARY | Expression binaire. Opérateur 1 WORD, gauche, droite |
| `01011` | `0x4B` | CALL | Appel. Fonction cible, nombre d'arguments, argument × nombre d'arguments |
| `01100` | `0x4C` | MEMBER | Accès à un membre. Cible, symbole du champ |
| `01101` | `0x4D` | INDEX | Accès par indice. Cible, indice |
| `01110` | `0x4E` | CONSTRUCT | Construction d'une valeur composée (liste, enregistrement). Type, nombre d'éléments, élément × nombre d'éléments |
| `01111` | `0x4F` | CONDITIONAL | Expression conditionnelle. Condition, valeur si vrai, valeur si faux |
| `10000` | `0x50` | BLOCK | Suite ordonnée d'instructions. Nombre d'instructions, instruction × nombre d'instructions |
| `10001` | `0x51` | ASSIGN | Affectation. Cible (symbole, MEMBER, INDEX), valeur |
| `10010` | `0x52` | IF | Branchement conditionnel. Condition, BLOCK vrai, faux (BLOCK ou IF, 0 s'il n'y en a pas) |
| `10011` | `0x53` | SWITCH | Branchement multiple. Cible, nombre de branches, (valeur, BLOCK) × nombre de branches, BLOCK par défaut (0 s'il n'y en a pas) |
| `10100` | `0x54` | WHILE | Boucle conditionnelle. Condition, BLOCK du corps |
| `10101` | `0x55` | FOREACH | Boucle d'itération. Symbole de l'élément, cible, BLOCK du corps |
| `10110` | `0x56` | JUMP | Contrôle de boucle. Genre 1 WORD (break, continue), boucle cible |
| `10111` | `0x57` | RETURN | Retour. Valeur (0 s'il n'y en a pas) |
| `11000` | `0x58` | RAISE | Levée d'erreur. Valeur d'erreur |
| `11001` | `0x59` | TRY | Gestion d'erreur. BLOCK du corps, symbole d'erreur, BLOCK de traitement, BLOCK de finalisation (0 s'il n'y en a pas) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| 2 bits de poids fort de CCCCC | Groupe |
|---|---|
| `00` | Déclarations |
| `01` | Expressions |
| `10` | Instructions |
| `11` | Erreurs |

### TOULMIN (`11`)

Détails : [TOULMIN](/fr/grammar/edge/toulmin/)

| CCCCC | Codec | Nom | Description |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/fr/grammar/edge/toulmin/node/) | Déclaration de cas. Graphe de jugement contenant nœuds et relations |
| `00001` | `0x61` | [PREDICATE-DECLARE](/fr/grammar/edge/toulmin/expr/) | Déclaration de prédicat. Fonction ou expression de jugement, critère de jugement (Spec), contrat de faits (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/fr/grammar/edge/toulmin/node/) | Déclaration de critère de jugement. Constantes, listes (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/fr/grammar/edge/toulmin/node/) | Déclaration d'assertion. Pose un prédicat comme règle générale (Warrant) dans un cas. Peut être attaquée. |
| `00100` | `0x64` | [COUNTER-DECLARE](/fr/grammar/edge/toulmin/node/) | Déclaration de réfutation. Attaque avec sa propre conclusion. Level par défaut : Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/fr/grammar/edge/toulmin/node/) | Déclaration d'exception. Attaque sans conclusion propre. Level par défaut : Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/fr/grammar/edge/toulmin/link/) | Relation d'attaque. Le jugement de l'attaquant entame progressivement celui de la cible. |
| `01001` | `0x69` | [SUPERSEDES](/fr/grammar/edge/toulmin/link/) | Relation d'exclusion. Si l'attaquant est Active, la cible est retirée de l'agrégation de façon déterminante. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | Chaîne de priorité `A > B > C`. Forme abrégée de SUPERSEDES deux à deux. Disposition non fixée |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/fr/grammar/edge/toulmin/link/) | Composition d'exécution. Si le nœud est Active, exécute le cas inférieur (DAG). |
| `10001` | `0x71` | [DO](/fr/grammar/edge/toulmin/link/) | Action exécutée si le nœud est Active |
| `10010` | `0x72` | [DO-ONCE](/fr/grammar/edge/toulmin/link/) | Action exécutée une seule fois même en cas de nouvelle tentative |
| `10011` | `0x73` | [UNDO](/fr/grammar/edge/toulmin/link/) | Action de compensation d'un DO (saga). Si une étape ultérieure échoue, elle s'exécute dans l'ordre inverse. |
| `10100` | `0x74` | [CHECKING](/fr/grammar/edge/toulmin/link/) | Lien qui se borne à juger, sans effet de bord |
| `10101` | `0x75` | [ENTRY](/fr/grammar/edge/toulmin/node/) | Point d'entrée externe. Exécute ou juge un cas |
| `10110` | `0x76` | [TRIGGER](/fr/grammar/edge/toulmin/node/) | Point d'entrée d'événement ou périodique, sans appel externe |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | Résultat de jugement d'un nœud ou d'un enregistrement. Résultat (Pass, Review, Fail), valeur de jugement, Activated, Excluded, Level. Disposition non fixée. Le jugement du document entier est le Meta [VERDICT](/fr/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | Preuve du jugement. Emplacement, valeur attendue, valeur réelle (Fact). Disposition non fixée |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Format défini par un Issuer |

| 2 bits de poids fort de CCCCC | Groupe |
|---|---|
| `00` | Déclarations |
| `01` | Relations |
| `10` | Exécution |
| `11` | Résultats (`0x7C`~`0x7F` sont ISSUER) |

### Formats ISSUER d'Edge

Après `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD), le TAG d'extension de Codec porte l'Issuer et le numéro de format. Les 2 bits de poids fort du numéro de format forment la famille. L'espace des numéros de format est distinct de celui de Value.

| Issuer | Numéro de format | Nom | Famille | Description |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/fr/grammar/edge/toulmin/source/) | TOULMIN | Texte original rédigé. Largeur de SPAN et Value UTF8 |
| `0x0000` GEUL | `0xC001` | [TEXT](/fr/grammar/edge/toulmin/source/) | TOULMIN | Nom, chaîne de caractères |
| `0x0000` GEUL | `0xC002` | [SECTION](/fr/grammar/edge/toulmin/source/) | TOULMIN | Début de section. Code de section |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/fr/grammar/edge/toulmin/source/) | TOULMIN | Début de l'étendue d'un cas |
| `0x0000` GEUL | `0xC004` | [CASE-END](/fr/grammar/edge/toulmin/source/) | TOULMIN | Fin de l'étendue d'un cas |
| `0x0000` GEUL | `0xC005` | [PROSE](/fr/grammar/edge/toulmin/source/) | TOULMIN | Paragraphe descriptif (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/fr/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/fr/grammar/edge/toulmin/node/) | TOULMIN | NODE. Référence de fonction |
| `0x0000` GEUL | `0xC012` | [FIELD](/fr/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/fr/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/fr/grammar/edge/toulmin/node/) | TOULMIN | NODE. Groupe d'exécution ordonné |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Cas → champ |
| `0x0000` GEUL | `0xC021` | [MEANS](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Terme défini → valeur ou type |
| `0x0000` GEUL | `0xC022` | [HAS](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Terme défini → champ |
| `0x0000` GEUL | `0xC023` | [RUNS](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Point d'entrée → cas, exécution |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Point d'entrée → cas, jugement |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Déclencheur → cas |
| `0x0000` GEUL | `0xC026` | [UNTIL](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Déclencheur → cas (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Nœud → identifiant global |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Alias → chemin (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/fr/grammar/edge/toulmin/link/) | TOULMIN | LINK. Nœud → TEXT, notation du nom |

## Value

`0000 1LLL LCCC CCCC` — [Value](/fr/grammar/value/)

Les 2 bits de poids fort du Codec forment la famille. NUMERIC/DECIMAL se subdivisent par le 3e bit de poids fort (`000` NUMERIC, `001` DECIMAL).

| 2 bits de poids fort | Famille | Code direct | Numéro de format |
|---|---|---|---|
| `00` | [NUMERIC](/fr/grammar/value/numeric/)/[DECIMAL](/fr/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/fr/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/fr/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/fr/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Codes directs

| Codec | Nom | Famille | Description |
|---|---|---|---|
| `0x00` | [BOOL](/fr/grammar/value/numeric/bool/) | NUMERIC | false ou true, 1 WORD fixe |
| `0x01` | [SIGNED-INTEGER](/fr/grammar/value/numeric/signed-integer/) | NUMERIC | Entier signé en complément à deux sur le nombre minimal de WORD |
| `0x02` | [UNSIGNED-INTEGER](/fr/grammar/value/numeric/unsigned-integer/) | NUMERIC | Entier de magnitude non signée big-endian sur le nombre minimal de WORD |
| `0x03` | [BINARY-FLOAT](/fr/grammar/value/numeric/binary-float/) | NUMERIC | Scalaire IEEE 754 binary16/32/64/128, Payload de 1/2/4/8 WORD |
| `0x04` | [COORDINATE-EARTH](/fr/grammar/value/numeric/coordinate-earth/) | NUMERIC | Latitude et longitude terrestres (WGS 84) en binary64, incertitude en binary32 et Reference de son unité (ABSENT = inconnue) |
| `0x05` | [COORDINATE-GEO](/fr/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference d'un corps céleste, latitude et longitude en binary64, incertitude en binary32 et Reference de son unité |
| `0x06` | [QUANTITY](/fr/grammar/value/numeric/quantity/) | NUMERIC | amount Value numérique (entier, BINARY-FLOAT, décimal, fraction), Reference de l'unité, bornes inférieure et supérieure. L'unité et les bornes peuvent être omises (ABSENT `0x0000`) |
| `0x07` | [FRACTION](/fr/grammar/value/numeric/fraction/) | NUMERIC | Fraction qui conserve la notation d'origine : numérateur entier ou décimal, dénominateur entier ou décimal non signé. Non simplifiée |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` avec exposant signé `E` et coefficient `C` en complément à deux sur le nombre minimal de WORD |
| `0x11` | [UNSIGNED-DECIMAL](/fr/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` avec exposant signé `E` et coefficient non signé `C` sur le nombre minimal de WORD |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/) | TIME | Nombre signé de jours depuis le `1970-01-01` du calendrier grégorien proleptique |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/fr/grammar/value/time/civil-time-nanoseconds/) | TIME | Nombre de nanosecondes non signé après minuit du jour civil |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/fr/grammar/value/time/posix-timestamp-seconds/) | TIME | Nombre signé de secondes depuis l'epoch Unix/POSIX |
| `0x23` | [DURATION-SECONDS](/fr/grammar/value/time/duration-seconds/) | TIME | Durée écoulée signée en secondes SI, sans epoch |
| `0x24`/`0x25` | [EDTF](/fr/grammar/value/time/edtf/) | TIME | Chaîne de date EDTF (ISO 8601-2). Nombre d'octets pair ou impair. On ne l'utilise pas pour une date exprimable en GREGORIAN-DATE |
| `0x26`/`0x27` | [GEDCOM-DATE](/fr/grammar/value/time/gedcom-date/) | TIME | Chaîne de valeur de date GEDCOM 7. Conserve la notation d'origine d'autres calendriers (julien, etc.). Nombre d'octets pair ou impair |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/fr/grammar/value/text/utf8-text/) | TEXT | Suite d'octets UTF-8 valide n'impliquant aucune normalisation. Nombre d'octets pair |
| `0x41` | [UTF8-TEXT-ODD](/fr/grammar/value/text/utf8-text/) | TEXT | Idem. Nombre d'octets impair |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/fr/grammar/value/text/uri/) | TEXT | Octets ASCII de la production `URI` de la RFC 3986. Nombre d'octets pair |
| `0x45` | [URI-ODD](/fr/grammar/value/text/uri/) | TEXT | Idem. Nombre d'octets impair |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/fr/grammar/value/text/language-bcp47-code/) | TEXT | Octets ASCII d'une balise de langue BCP 47 complète en casse canonique. Nombre d'octets pair |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/fr/grammar/value/text/language-bcp47-code/) | TEXT | Idem. Nombre d'octets impair |
| `0x48` | [LANGUAGE-SHORT-CODE](/fr/grammar/value/text/language-short-code/) | TEXT | Code compressé de langue primaire GEUL, Payload fixe de 1 WORD |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/) | TEXT | Texte accompagné d'une langue. Enregistrement Value de langue (LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE) et octets UTF-8. Parité du nombre d'octets du texte |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/fr/grammar/value/binary/uuid/) | BINARY | UUID de 128 bits (RFC 9562), Payload fixe de 8 WORD |
| `0x61` | [SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/) | BINARY | Résultat SHA-256, Payload fixe de 16 WORD |
| `0x62` | [SHA1-DIGEST](/fr/grammar/value/binary/sha1-digest/) | BINARY | Résultat SHA-1, Payload fixe de 10 WORD. Seulement pour l'identification, comme les ID d'objets git |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Format défini par un Issuer. Voir les formats ISSUER de Value ci-dessous |

### Formats ISSUER de Value

Après `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD), le TAG d'extension de Codec porte l'Issuer et le numéro de format. Les 2 bits de poids fort du numéro de format forment la famille.

| Issuer | Numéro de format | Nom | Famille | Description |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/fr/grammar/value/time/duration-nanoseconds/) | TIME | Durée écoulée signée en nanosecondes, sans epoch |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/fr/grammar/value/binary/opaque-bytes/) | BINARY | Suite d'octets de sens et de format inconnus. Nombre d'octets pair |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/fr/grammar/value/binary/opaque-bytes/) | BINARY | Idem. Nombre d'octets impair |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/fr/grammar/value/binary/bit-vector/) | BINARY | N bits stockés MSB-first après le bit-count |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | Bits d'interchange BF16, Payload fixe de 1 WORD |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/fr/grammar/value/vector/dense-i16-vector/) | NUMERIC | Vecteur contigu d'int16 big-endian |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/fr/grammar/value/vector/dense-u16-vector/) | NUMERIC | Vecteur contigu d'uint16 big-endian |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/fr/grammar/value/vector/dense-i32-vector/) | NUMERIC | Vecteur contigu d'int32 big-endian |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/fr/grammar/value/vector/dense-u32-vector/) | NUMERIC | Vecteur contigu d'uint32 big-endian |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/fr/grammar/value/vector/dense-i64-vector/) | NUMERIC | Vecteur contigu d'int64 big-endian |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/fr/grammar/value/vector/dense-u64-vector/) | NUMERIC | Vecteur contigu d'uint64 big-endian |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/fr/grammar/value/vector/dense-binary16-vector/) | NUMERIC | Vecteur contigu IEEE 754 binary16 |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/fr/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | Vecteur contigu BF16 |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/fr/grammar/value/vector/dense-binary32-vector/) | NUMERIC | Vecteur contigu IEEE 754 binary32 |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/fr/grammar/value/vector/dense-binary64-vector/) | NUMERIC | Vecteur contigu IEEE 754 binary64 |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/fr/grammar/value/vector/point2-binary64/) | NUMERIC | Vecteur 2D IEEE binary64 dans l'ordre `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/fr/grammar/value/vector/point3-binary64/) | NUMERIC | Vecteur 3D IEEE binary64 dans l'ordre `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/fr/grammar/value/vector/bbox2-binary64/) | NUMERIC | Vecteur IEEE binary64 dans l'ordre `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/fr/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format, rank, shape et Payload dense C-contiguous |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/fr/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format, rank, shape et Payload packed low-bit-first dans l'octet |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/fr/grammar/value/etc/complex64/) | NUMERIC | Deux binary32 dans l'ordre `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/fr/grammar/value/etc/complex128/) | NUMERIC | Deux binary64 dans l'ordre `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/fr/grammar/value/etc/rational-i64/) | NUMERIC | numerator int64 normalisé et denominator int64 positif |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/fr/grammar/value/etc/closed-interval-binary64/) | NUMERIC | Intervalle fermé binary64 avec `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/fr/grammar/value/etc/quaternion-binary32/) | NUMERIC | Quatre binary32 dans l'ordre `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/fr/grammar/value/binary/blake3-256-digest/) | BINARY | Résultat BLAKE3 par défaut, Payload fixe de 16 WORD |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/fr/grammar/value/text/uri-relative-ref/) | TEXT | Octets ASCII d'un relative-ref de la RFC 3986. Nombre d'octets pair |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/fr/grammar/value/text/uri-relative-ref/) | TEXT | Idem. Nombre d'octets impair |
| `0x0020` IETF | `0xC000` | [CRC32C](/fr/grammar/value/binary/crc32c/) | BINARY | Résultat CRC-32C de Castagnoli, Payload fixe de 2 WORD |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/fr/grammar/value/binary/ipv4-address/) | BINARY | Adresse IPv4 de 32 bits, Payload fixe de 2 WORD |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/fr/grammar/value/binary/ipv6-address/) | BINARY | Adresse IPv6 de 128 bits, Payload fixe de 8 WORD |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/fr/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE 754 decimal32 DPD, Payload fixe de 2 WORD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/fr/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE 754 decimal64 DPD, Payload fixe de 4 WORD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/fr/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE 754 decimal128 DPD, Payload fixe de 8 WORD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/fr/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE 754 decimal32 BID, Payload fixe de 2 WORD |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/fr/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE 754 decimal64 BID, Payload fixe de 4 WORD |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/fr/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE 754 decimal128 BID, Payload fixe de 8 WORD |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/fr/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | Nombre signé de nanosecondes depuis l'epoch Unix/POSIX |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/fr/grammar/value/binary/mac-48-address/) | BINARY | Adresse MAC IEEE 802 de 48 bits, Payload fixe de 3 WORD |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/fr/grammar/value/vector/rgba8-unorm/) | NUMERIC | Vecteur packed fixe de 4×UNORM8 dans l'ordre R, G, B, A |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/fr/grammar/value/vector/bgra8-unorm/) | NUMERIC | Vecteur packed fixe de 4×UNORM8 dans l'ordre B, G, R, A |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | Scalaire ONNX E4M3FN dans l'octet de poids fort du Payload |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | Scalaire ONNX E4M3FNUZ dans l'octet de poids fort du Payload |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | Scalaire ONNX E5M2 dans l'octet de poids fort du Payload |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | Scalaire ONNX E5M2FNUZ dans l'octet de poids fort du Payload |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Scalaire E8M0FNU non signé à exposant seul dans l'octet de poids fort du Payload |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | Scalaire ONNX/DLPack E2M1FN dans le quartet de poids fort du Payload |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/fr/grammar/value/time/tai-timestamp-seconds/) | TIME | Nombre signé de secondes SI depuis `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/fr/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | Nombre signé de nanosecondes depuis la même epoch TAI |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/fr/grammar/value/binary/sha-512-digest/) | BINARY | Résultat SHA-512, Payload fixe de 32 WORD |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/fr/grammar/value/binary/sha3-256-digest/) | BINARY | Résultat SHA3-256, Payload fixe de 16 WORD |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/fr/grammar/value/time/gps-timestamp-seconds/) | TIME | Nombre signé de secondes depuis l'epoch GPS |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/fr/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | Nombre signé de nanosecondes depuis l'epoch GPS |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/fr/grammar/meta/)

Les 3 bits de poids fort du Codec forment la classe. Meta n'a pas de code ISSUER.

| 3 bits de poids fort | Classe | Code direct | Objet |
|---|---|---|---|
| `000` | [Structure](/fr/grammar/meta/structure/) | `0x00`~`0x0F` | Limites et longueur du document |
| `001` | [Définition](/fr/grammar/meta/declaration/) | `0x10`~`0x1F` | Déclarations d'interprétation |
| `010` | [Source](/fr/grammar/meta/provenance/) | `0x20`~`0x2F` | Qui, quand, où |
| `011` | [Lignée](/fr/grammar/meta/lineage/) | `0x30`~`0x3F` | D'où cela provient et comment |
| `100` | [Vérification](/fr/grammar/meta/verification/) | `0x40`~`0x4F` | Est-ce digne de confiance |
| `101` | [Politique](/fr/grammar/meta/policy/) | `0x50`~`0x5F` | Comment cela se traite |
| `110` | [IMPORT](/fr/grammar/meta/import/) | `0x60`~`0x6F` | Importe un document externe par IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### Structure (`000`)

| Codec | Nom | Description |
|---|---|---|
| `0x00` | [DOC-1WORD](/fr/grammar/meta/structure/doc/) | Début de document dont la longueur totale est indiquée dans un Payload de 1 WORD |
| `0x01` | [DOC-2WORD](/fr/grammar/meta/structure/doc/) | Début de document dont la longueur totale est indiquée dans un Payload de 2 WORD |
| `0x02` | [DOC-4WORD](/fr/grammar/meta/structure/doc/) | Début de document dont la longueur totale est indiquée dans un Payload de 4 WORD |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/fr/grammar/meta/structure/body/) | 1 WORD. Termine le HEAD du document et commence le BODY. |
| `0x0F` | [END](/fr/grammar/meta/structure/end/) | 1 WORD. Ferme le document. |

### Définition (`001`)

| Codec | Nom | Description |
|---|---|---|
| `0x10` | [SPEC-VERSION](/fr/grammar/meta/declaration/spec-version/) | Édition de la spécification GEUL suivie. Le Payload est lui-même l'entier non signé de largeur minimale. v1 vaut `0x0001` (enregistrement `0x1890 0x0001`) |
| `0x11` | [PROFILE](/fr/grammar/meta/declaration/profile/) | Profil appliqué |
| `0x12` | [DOC-ID](/fr/grammar/meta/declaration/doc-id/) | Identifiant de ce document. Reference intégrée `DOC-POINTER` (Issuer, ID de document, version 0) |
| `0x13` | [EFFECTIVE-FROM](/fr/grammar/meta/declaration/effective-from/) | Date d'entrée en vigueur de cette version. Value GREGORIAN-DATE ou POSIX-TIMESTAMP. À défaut, l'instant de publication |
| `0x14` | [EFFECTIVE-UNTIL](/fr/grammar/meta/declaration/effective-until/) | Fin de validité de cette version (loi temporaire). À défaut, jusqu'à l'entrée en vigueur de la version suivante |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/fr/grammar/meta/declaration/default-language/) | Langue par défaut |
| `0x17`~`0x1F` | Reserved |  |

### Source (`010`)

| Codec | Nom | Description |
|---|---|---|
| `0x20` | [AUTHOR](/fr/grammar/meta/provenance/author/) | Auteur. Reference (git author) |
| `0x21` | [CO-AUTHOR](/fr/grammar/meta/provenance/co-author/) | Co-auteur. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/fr/grammar/meta/provenance/created-at/) | Instant de création. Value TIME (git author date) |
| `0x23` | [MODIFIED-AT](/fr/grammar/meta/provenance/modified-at/) | Instant de modification. Value TIME |
| `0x24` | [RECORDED-BY](/fr/grammar/meta/provenance/recorded-by/) | Entité qui a enregistré. Reference (git committer) |
| `0x25` | [RECORDED-AT](/fr/grammar/meta/provenance/recorded-at/) | Instant d'enregistrement. Value TIME (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- Le document d'origine, son étendue, son instant d'acquisition et son hachage ne s'écrivent pas en Meta mais par l'Edge de fondement [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du HEAD (Target `0`) et ses QUALIFIER.

### Lignée (`011`)

| Codec | Nom | Description |
|---|---|---|
| `0x30` | [PARENT](/fr/grammar/meta/lineage/parent/) | Hachage du contenu de la version précédente (git parent). Absent : version initiale ; plusieurs : fusion (git merge commit). |
| `0x31` | [DERIVED-FROM](/fr/grammar/meta/lineage/derived-from/) | Dérivé d'enregistrements ou de documents d'une autre lignée. Pour figer sur une version précise d'une ressource externe, on joint au [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du HEAD un QUALIFIER de hachage du texte d'origine (P4092) (git submodule). |
| `0x32` | [GENERATED-BY](/fr/grammar/meta/lineage/generated-by/) | Entité génératrice. Personne, modèle, moteur de règles |
| `0x33` | [TRANSFORMED-BY](/fr/grammar/meta/lineage/transformed-by/) | Méthode de transformation. Outil, règle, version |
| `0x34` | [CHERRY-PICKED-FROM](/fr/grammar/meta/lineage/cherry-picked-from/) | Hachage du contenu de la version d'origine dont une modification d'une autre lignée a été reprise (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/fr/grammar/meta/lineage/reverts/) | Hachage du contenu de la version dont la modification est annulée (git revert) |
| `0x36` | [REPLACES](/fr/grammar/meta/lineage/replaces/) | Hachage du contenu de la version réécrite (git amend, rebase). La version d'origine n'est pas effacée. |
| `0x37` | [SQUASHED-FROM](/fr/grammar/meta/lineage/squashed-from/) | Hachages du contenu des versions d'origine fusionnées en une (git squash) |
| `0x38` | [MESSAGE](/fr/grammar/meta/lineage/message/) | Raison de la modification. Value UTF8-LANGUAGE-TEXT, une par langue (git commit message) |
| `0x39` | [TAG](/fr/grammar/meta/lineage/tag/) | Nom immuable attaché à une version. Value TEXT et hachage du contenu (git annotated tag) |
| `0x3A` | [DELTA-BASE](/fr/grammar/meta/lineage/delta-base/) | Le fichier de cette version est un diff par rapport à une version de base du même document (ID de version de 2 WORD) (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/fr/grammar/meta/lineage/delta-remove/) | Liste des LOCAL ID (Edge Id) à retirer du BODY de base dans un diff |
| `0x3C` | [NEXT-LOCAL-ID](/fr/grammar/meta/lineage/next-local-id/) | Prochain LOCAL ID à attribuer (auto increment). Placé dans le HEAD de la liste des versions `versions.geul` |
| `0x3D`~`0x3F` | Reserved |  |

### Vérification (`100`)

| Codec | Nom | Description |
|---|---|---|
| `0x40` | [ISSUER-KEY](/fr/grammar/meta/verification/issuer-key/) | Déclaration de l'ID d'algorithme de signature et de la clé publique d'un Issuer auto-émis |
| `0x41` | [SIGNATURE](/fr/grammar/meta/verification/signature/) | Signature d'une cible. La signature d'un document porte sur son hachage du contenu (git signed commit, tag) |
| `0x42` | [SIGNED-OFF](/fr/grammar/meta/verification/signed-off/) | Confirmation du droit de contribuer. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/fr/grammar/meta/verification/confidence/) | Degré de confiance |
| `0x44` | [VERDICT](/fr/grammar/meta/verification/verdict/) | Résultat de jugement du document entier. Pass, Review, Fail. Par nœud ou enregistrement : [TOULMIN](/fr/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### Politique (`101`)

| Codec | Nom | Description |
|---|---|---|
| `0x50` | [LICENSE](/fr/grammar/meta/policy/license/) | Licence. Reference |
| `0x51` | [ACCESS](/fr/grammar/meta/policy/access/) | Étendue de diffusion |
| `0x52` | [PRIVACY](/fr/grammar/meta/policy/privacy/) | Niveau de données personnelles |
| `0x53` | [RETENTION](/fr/grammar/meta/policy/retention/) | Durée de conservation |
| `0x54` | [CONSENT](/fr/grammar/meta/policy/consent/) | Étendue et fondement du consentement |
| `0x55` | [USAGE](/fr/grammar/meta/policy/usage/) | Restrictions d'usage |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | Nom | Description |
|---|---|---|
| `0x60` | [IMPORT-DOC](/fr/grammar/meta/import/import-doc/) | Importe un document externe par IMPORT ID. Reference intégrée `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
