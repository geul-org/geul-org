---
title: "Index des codes"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "Cette page est l'index de tous les Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Cette page est l'index de tous les Codec. Cliquez sur un nom pour accéder à la page détaillée de ce Codec. Les codes directs absents des tableaux sont Reserved.

## Kind {#kind}

Le TAG WORD est `000K KKKC CCCC LLLL`. Les 4 bits de poids fort `KKKK` forment la section, `C` est le décalage sur 5 bits dans la section et `LLLL` est la Length. Les 9 bits formés par la section et `C` constituent l'emplacement du Codec. Le TAG ID s'écrit `0x000L` : les trois premiers chiffres sont ces 9 bits (`w >> 4`) et `L` est l'emplacement de la Length ([Enregistrement et TAG WORD](record.md)).

| Section | TAG ID | Catégorie | Description |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | Enregistrement qui désigne une cible |
| 3 et 4 | `0x060L~0x09FL` | [Value](value/_index.md) | Enregistrement de valeur |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | Enregistrement de composition |
| 14 et 15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | Enregistrement portant sur le document et les enregistrements |

- La section est `S = w >> 9` (4 bits) et une section compte 32 cases.
- Le Kind se détermine par une seule plage de sections : `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, le reste Meta. Il n'y a pas d'exception.
- Les trois dernières cases des zones Reference, Value et Edge sont ISSUER (`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). Meta n'a pas d'ISSUER.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | Nom | Catégorie | ID de la cible |
|---|---|---|---|
| `0x000L~0x002L` | [Marqueur d'emplacement](slot-marker.md) | Marqueur d'emplacement | Lot de marqueurs de 1 WORD qui ne désignent aucune cible (tableau ci-dessous) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | Déclaration | ID émis par ce document |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | Déclaration | Entité émise en CC0 par geul.org. Les petits numéros sont attribués aux entités très fréquentes |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | Déclaration | GEUL SIDX (Semantic-aligned Index). Identifiant dont les bits portent du sens |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | Déclaration | Élément Wikidata. Entier qui suit `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | Déclaration | Propriété Wikidata. Entier qui suit `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | Pointeur | LOCAL ID d'un document importé par `IMPORT-DOC`. IMPORT ID de 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | Pointeur | Idem. IMPORT ID de 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | Pointeur | Idem. IMPORT ID de 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | Pointeur-déclaration | LOCAL ID d'un document d'un Issuer de 2 WORD |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | Pointeur-déclaration | LOCAL ID d'un document d'un Issuer de 4 WORD |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | Pointeur-déclaration | LOCAL ID d'un document d'un Issuer de 16 WORD |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | Pointeur-déclaration | L'Issuer lui-même. Le Payload se réduit à l'Issuer (2/4/16 WORD) et il n'y a pas d'ID de cible |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | Pointeur-déclaration | Une version d'un document d'un Issuer. Issuer + ID de document 4 WORD + ID de version 2 WORD, sans ID de cible |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | Pointeur-déclaration | Une version d'un Codec d'un Issuer. Issuer + ID de Codec 2 WORD + ID de version 2 WORD, sans ID de cible |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | Format Issuer | Issuer de 2 WORD et numéro de Codec de 2 WORD. La catégorie et la cible sont fixées par le document de l'Issuer |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | Format Issuer | Issuer de 4 WORD et numéro de Codec de 2 WORD. Idem |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | Format Issuer | Issuer de 16 WORD et numéro de Codec de 2 WORD. Idem |

- Reference compte trois sections. Section 0 entités `0x000L~0x01FL` (marqueurs d'emplacement, système 5Q), section 1 EXTERNAL `0x020L~0x03FL`, section 2 divers `0x040L~0x05FL` (pointeurs, REFERENCE-ISSUER). Les Reserved sont `0x003L~0x004L`, `0x01EL~0x01FL`, `0x03EL~0x03FL` et `0x043L~0x05CL`.
- Les lots de 5 cases (de LOCAL à EXTERNAL-ISSUER-16WORD) prennent une case chacun, dans l'ordre des Quantifier ci-dessous. Exemple : WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### Marqueurs d'emplacement (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000`, `0x0010`, `0x0020` — [Marqueur d'emplacement](slot-marker.md). Ils ne peuvent figurer à un emplacement que si la liste des CODEC du champ contient exactement ce WORD.

| WORD | Nom | Sens | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | Non noté. Un champ facultatif a été omis. Rien n'est affirmé sur le monde | pas de snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | Inconnu. Une valeur existe mais on ne sait pas laquelle | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | Aucun. Il n'y a pas de valeur | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | Nom | Sens | Exemple |
|---|---|---|---|
| `0` | Identified | Entité identifiée | Elon Musk, la Corée du Sud |
| `1` | Generic | Énoncé général ou définitoire sur toute une espèce. Admet des exceptions. | Les soldats obéissent aux ordres |
| `2` | Free-choice | N'importe quel objet satisfaisant la condition | n'importe quel soldat |
| `3` | Universal | Tout objet appartenant à la portée donnée | tous les soldats |
| `4` | Variable | Variable de discours | cette personne, cette femme |

- La quantification se lit par le décalage `C` dans la section. En section 0, si `5 <= C < 30`, la quantification est `C % 5` et le système `C / 5` (1~5). En section 1, si `C < 30`, la quantification est `C % 5` et le système `6 + C / 5` (6~11). Elle ne s'applique pas aux marqueurs (section 0, `C < 3`) ni à la section 2 (pointeurs, REFERENCE-ISSUER).
- ISSUER-POINTER, DOC-POINTER et CODEC-POINTER sont des cases uniques sans quantification. La quantification de REFERENCE-ISSUER est fixée par le document de Codec publié par l'Issuer.

## Issuer {#issuer}

Un Issuer est l'entité qui définit documents et formats — [Issuer et publication](issuer.md)

| Emplacement | Sens |
|---|---|
| Codes ISSUER de Reference, Value, Edge (trois dernières cases de chaque zone) | Format défini par cet Issuer |
| Meta `DOC-ID` | Issuer qui a émis ce document |
| Meta `IMPORT-DOC` | Issuer qui a émis le document importé |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER`, `CODEC-POINTER` | Issuer qui a émis le document ou le Codec désigné (2/4/16 WORD) |
| Reference `ISSUER-POINTER` | L'Issuer désigné lui-même (2/4/16 WORD) |

| Largeur de l'Issuer | Émission |
|---|---|
| 2 WORD | Enregistrement auprès de geul.org. Issuer ayant prouvé la propriété d'un domaine (ex. company.com). Les numéros que geul.org attribue aux organismes de normalisation et aux grandes institutions ont aussi cette largeur ([table d'attribution des 2 WORD](issuer.md#2-word-배정표)). |
| 4 WORD | Enregistrement auprès de geul.org. Issuer enregistré sans preuve de propriété |
| 16 WORD | Auto-émis. Calculé à partir de la clé publique, sans enregistrement. Suit la règle de génération ci-dessous. |

### Algorithme de signature de l'Issuer de 16 WORD {#16-word-issuer-서명-알고리즘}

| ID de l'algorithme de signature | Algorithme |
|---|---|
| `0x0001` | Ed25519 |
| autres | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

La famille d'un code direct est `(code − 0xA0) >> 5` (le code est constitué des trois premiers chiffres du TAG ID). Une famille compte 32 cases et correspond à la section `w >> 9` moins 5. Les codes directs attribués se répartissent dans les cinq familles ci-dessous. `0x135L~0x1BCL` est Reserved (les sections 10~12 sont entièrement Reserved). Il n'y a pas de règle de famille pour le format Issuer.

| Section | Famille | Codes directs |
|---|---|---|
| 5 | énoncé | `0x0A0L~0x0BFL` |
| 6 | fondement | `0x0C0L~0x0DFL` |
| 7 | exécution | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | format [TOULMIN](toulmin/_index.md) | `0x120L~0x134L` |

- `0x11CL~0x11FL` est Reserved.
- `0x1BDL~0x1BFL` (les trois dernières cases de la section 13) est EDGE-ISSUER (format Edge ISSUER ci-dessous).

### Énoncé (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | Nom | Sous-format | Description |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | Liaison orientée où un Subject de type Reference désigne un Object |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | Identité : deux Reference désignent la même cible |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | Non-identité : deux Reference désignent des cibles différentes |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | Associe au Subject un nom que la machine fait correspondre (`UTF8-TEXT-*`). Unique dans la portée, correspondance exacte exigée, sans langue |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | Associe au Subject un nom dans une langue (label). L'Object est UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | Associe au Subject un autre nom (alias). Disposition identique à LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | Associe au Subject une description dans une langue (description). Disposition identique à LABEL |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | Énoncé verbal abrégé |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | Énoncé verbal |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | Proposition dans l'ordre Predicate, Subject, Object, avec rank. L'Object est une valeur ou un marqueur UNKNOWN-VALUE ou NO-VALUE. Le sens est l'ensemble des QUALIFIER qui désignent son Edge Id |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | Une condition qui restreint la proposition d'un autre Edge. Property, Target (Edge Id), Value (valeur ou marqueur UNKNOWN-VALUE ou NO-VALUE). Fait partie de la proposition |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | oui | Structure pour exprimer une vision du monde |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | oui | Structure exprimant l'ordre des mondes et des événements |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | oui | Structure de scène pour l'énoncé de caractéristiques de scénario |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | Publication d'un document. DOC-POINTER, hachage du contenu |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | Deprecate d'une version publiée. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | Suppression d'une version publiée (pierre tombale). DOC-POINTER, catégorie de motif |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | Déclaration de la composition du Payload d'un Codec. Kind et Codec cibles |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | Un champ du Payload. DECLARE d'appartenance, largeur : enregistrement (Length du TAG) ou valeur brute de n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | Une valeur de code d'un champ de valeur brute. Champ, valeur de code |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | Un Kind et un Codec acceptés par un champ. Champ, WORD cible (`000K KKKC CCCC LLLL`, LLLL 0000 exact, 1111 joker (les 32 cases de la section), les marqueurs d'emplacement uniquement comme cibles exactes `0000`, `0010`, `0020`). Un champ d'enregistrement en admet plusieurs (liste fermée), un champ de valeur brute un seul (cette Value sans TAG) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | Groupe |
|---|---|
| `0x0A0L~0x0A7L` | Désignation et noms |
| `0x0A8L~0x0AFL` | Propositions |
| `0x0B0L~0x0B7L` | Structures |
| `0x0B8L~0x0BFL` | Divers |

### Fondement (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | Nom | Sous-format | Description |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | Relie un enregistrement, ou le document entier, à son origine. Target (Edge Id du BODY ; dans le HEAD, `0` = document entier), Origin (Reference, ABSENT ou UNKNOWN-VALUE). La nature de l'origine s'exprime par un TRIPLE dont l'origine est le Subject ; la nature de la citation (date de consultation, position, hachage du texte) par un QUALIFIER attaché au SOURCE. Le SOURCE du document entier et son QUALIFIER se placent dans le HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- La portée du texte original, l'auteur, la fiabilité, la période d'application par article et les anciens enregistrements s'écrivent avec des QUALIFIER ; la version d'entrée initiale se calcule à partir de l'historique des versions ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### Exécution (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | Nom | Description |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | Déclaration de fonction. Symbole, liste des symboles de paramètres, type de retour, corps (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | Déclaration de type. Symbole et composition (liste des symboles de champs, valeurs d'énumération, cible de l'alias) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | Expression constante. Une Value intégrée |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | Expression unaire. Opérateur 1 WORD, opérande |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | Expression binaire. Opérateur 1 WORD, gauche, droite |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | Appel. Fonction cible, nombre d'arguments, argument × nombre d'arguments |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | Accès à un membre. Cible, symbole du champ |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | Accès par indice. Cible, indice |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | Construction d'une valeur composite (liste, enregistrement). Type, nombre d'éléments, élément × nombre d'éléments |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | Expression conditionnelle. Condition, valeur si vrai, valeur si faux |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | Suite ordonnée d'instructions. Nombre d'instructions, instruction × nombre d'instructions |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | Affectation. Cible (symbole, MEMBER, INDEX), valeur |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | Branchement conditionnel. Condition, BLOCK si vrai, sinon (BLOCK ou IF, 0 si absent) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | Branchement multiple. Cible, nombre de branches, (valeur, BLOCK) × nombre de branches, BLOCK par défaut (0 si absent) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | Boucle conditionnelle. Condition, BLOCK du corps |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | Boucle de parcours. Symbole de l'élément, cible, BLOCK du corps |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | Contrôle de boucle. Genre 1 WORD (break, continue), boucle cible |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | Retour. Valeur (0 si absente) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | Levée d'erreur. Valeur d'erreur |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | Traitement d'erreur. BLOCK du corps, symbole d'erreur, BLOCK de traitement, BLOCK de finalisation (0 si absent) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | Groupe |
|---|---|
| `0x0E0L~0x0E7L` | Déclarations |
| `0x0E8L~0x0EFL` | Expressions |
| `0x0F0L~0x0F7L` | Instructions |
| `0x0F8L~0x0FFL` | Erreurs |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

En détail : [TOULMIN](toulmin/_index.md)

| Codec | Nom | Description |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | Déclaration de cas. Graphe de verdict contenant nœuds et relations |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | Déclaration de prédicat. Fonction ou expression de verdict, critère de jugement (Spec), contrat de faits (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | Déclaration de critère de jugement. Constantes et listes (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | Déclaration d'affirmation. Pose un prédicat comme règle générale (Warrant) dans un cas. Peut être attaquée. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | Déclaration de réfutation. Attaque avec sa propre conclusion. Level par défaut : Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | Déclaration d'exception. Attaque sans conclusion propre. Level par défaut : Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | Relation d'attaque. Le verdict de l'attaquant entame progressivement celui de la cible. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | Relation d'exclusion. Si l'attaquant est Active, la cible est retirée de l'agrégation de façon décisive. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | Chaîne de priorité `A > B > C`. Abréviation de SUPERSEDES par paires. Disposition à fixer |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | Composition d'exécution. Si le nœud est Active, exécute un cas subordonné (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | Action effectuée si le nœud est Active |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | Action effectuée une seule fois, même en cas de nouvel essai |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | Action de compensation d'un DO (saga). Effectuée en ordre inverse si une étape suivante échoue. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | Liaison qui ne fait que juger, sans effet de bord |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | Point d'entrée externe. Exécute ou juge un cas |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | Point d'entrée par événement ou périodique, sans appel externe |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | Résultat du verdict d'un nœud ou d'un enregistrement. Résultat (Pass, Review, Fail), valeur du verdict, Activated, Excluded, Level. Disposition à fixer. Le verdict du document entier est Meta [VERDICT](meta/0x1E9L-verdict.md) (`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | Preuve du verdict. Position, valeur attendue, valeur réelle (Fact). Disposition à fixer |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | Groupe |
|---|---|
| `0x100L~0x107L` | Déclarations |
| `0x108L~0x10FL` | Relations |
| `0x110L~0x117L` | Exécution |
| `0x118L~0x11FL` | Résultats (`0x11CL~0x11FL` est Reserved) |

### Format TOULMIN (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

Nœuds et relations du texte original, des divisions et auxiliaires d'un document [TOULMIN](toulmin/_index.md).

| Codec | Nom | Description |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | Texte original rédigé. Largeur SPAN et Value UTF8 |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | Noms et chaînes |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | Début de section. Code de section |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | Début de la portée d'un cas |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | Fin de la portée d'un cas |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | Paragraphe narratif (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. Référence de fonction |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. Groupe d'exécution ordonné |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. Cas → champ |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. Élément de définition → valeur ou type |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. Élément de définition → champ |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. Point d'entrée → cas, exécution |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. Point d'entrée → cas, jugement |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. Déclencheur → cas |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. Déclencheur → cas (`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. Nœud → identifiant global |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. Alias → chemin (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. Nœud → TEXT, notation du nom |

- `0x135L~0x1BCL` est Reserved.

### Format Edge ISSUER {#edge-issuer-형식}

Après `0x1BDL`~`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), [-4WORD](edge/0x1BEL-edge-issuer-4word.md), [-16WORD](edge/0x1BFL-edge-issuer-16word.md)), le TAG d'extension du Codec contient l'Issuer et un numéro de Codec de 2 WORD. Aucun format Edge ISSUER n'est actuellement répertorié.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

Un numéro de Value n'indique pas une famille. Les codes directs occupent `0x060L~0x081L` sans Reserved. `0x082L~0x09CL` est Reserved et `0x09DL~0x09FL` est VALUE-ISSUER. Les noms de famille (NUMERIC, DECIMAL, TIME, TEXT, BINARY) sont des regroupements thématiques. Les paires pair-impair commencent à un code pair.

| Famille | Codes directs |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### Codes directs {#직접-코드}

| Codec | Nom | Famille | Description |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | false ou true sur 1 WORD fixe |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | Entier signé en complément à deux sur le minimum de WORD |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | Entier en magnitude non signée big-endian sur le minimum de WORD |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | Scalaire IEEE 754 binary16/32/64/128 avec un Payload de 1/2/4/8 WORD |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | Latitude et longitude terrestres (WGS 84) en binary64, incertitude en binary32 et Reference de son unité (ABSENT = inconnue) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Reference d'un corps céleste, latitude et longitude en binary64, incertitude en binary32 et Reference de son unité |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | Value numérique amount (entier, BINARY-FLOAT, décimal, fraction), Reference de l'unité, bornes inférieure et supérieure. L'unité et les bornes sont omissibles (ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | Fraction conservant la notation d'origine : numérateur entier ou décimal, dénominateur entier non signé ou décimal. Non simplifiée |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | `C×10^E` avec un exposant signé `E` et un coefficient `C` en complément à deux sur le minimum de WORD |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | `C×10^E` avec un exposant signé `E` et un coefficient `C` non signé sur le minimum de WORD |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | Nombre signé de jours depuis `1970-01-01` du calendrier grégorien proleptique |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | Nombre non signé de nanosecondes depuis minuit du jour civil |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | Nombre signé de secondes depuis l'epoch Unix/POSIX |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | Durée écoulée en secondes SI signées, sans epoch |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | Chaîne de date EDTF (ISO 8601-2). Nombre pair ou impair d'octets. Une date exprimable en GREGORIAN-DATE ne s'écrit pas ainsi |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | Chaîne de valeur de date GEDCOM 7. Conserve la notation d'origine d'autres calendriers (julien, etc.). Nombre pair ou impair d'octets |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | Suite d'octets UTF-8 valide n'impliquant aucune normalisation. Nombre pair d'octets |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | Idem. Nombre impair d'octets |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | Suite d'octets ASCII de la production `URI` de la RFC 3986. Nombre pair d'octets |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | Idem. Nombre impair d'octets |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | Suite d'octets ASCII d'une balise de langue BCP 47 complète à la casse canonique. Nombre pair d'octets |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | Idem. Nombre impair d'octets |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | Texte accompagné d'une langue. Enregistrement Value de langue (LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE) et octets UTF-8. Parité du nombre d'octets du texte |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | Balise BCP 47 écrite avec un numéro du GEUL Language Registry (Payload 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | UUID RFC 9562 de 128 bits, Payload fixe de 8 WORD |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | Résultat SHA-256, Payload fixe de 16 WORD |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | Résultat SHA-1, Payload fixe de 10 WORD. Uniquement à des fins d'identification, comme les ID d'objets git |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | Suite d'octets de sens et de format inconnus. Nombre pair d'octets |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | Idem. Nombre impair d'octets |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N bits stockés MSB-first après bit-count |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | Durée écoulée en nanosecondes signées, sans epoch |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | Format défini par un Issuer. Voir Format Value ISSUER ci-dessous |

### Format Value ISSUER {#value-issuer-형식}

Après `0x09DL`~`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md)), le TAG d'extension du Codec contient l'Issuer et un numéro de Codec de 2 WORD. Le document de Codec se place sous `codecs/` de cet Issuer, sous le numéro de Codec de l'enregistrement. Exemple : IETF CRC32C est `0x00000007/codecs/0x0000C000/` ([Adresse de publication et liste des versions](publishing.md)).

| Issuer | Numéro de Codec | Nom | Description |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | Bits d'échange BF16, Payload fixe de 1 WORD |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | Vecteur contigu d'int16 big-endian |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | Vecteur contigu d'uint16 big-endian |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | Vecteur contigu d'int32 big-endian |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | Vecteur contigu d'uint32 big-endian |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | Vecteur contigu d'int64 big-endian |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | Vecteur contigu d'uint64 big-endian |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | Vecteur contigu IEEE 754 binary16 |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | Vecteur contigu BF16 |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | Vecteur contigu IEEE 754 binary32 |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | Vecteur contigu IEEE 754 binary64 |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | Vecteur IEEE binary64 à 2 dimensions dans l'ordre `(x,y)` |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | Vecteur IEEE binary64 à 3 dimensions dans l'ordre `(x,y,z)` |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | Vecteur IEEE binary64 dans l'ordre `(minX,minY,maxX,maxY)` |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format, rank, shape et Payload dense C-contiguous |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format, rank, shape et Payload packed low-bit-first dans l'octet |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | Deux binary32 dans l'ordre `(real, imag)` |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | Deux binary64 dans l'ordre `(real, imag)` |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | Numerator int64 normalisé et denominator int64 positif |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | Intervalle fermé binary64 avec `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | Quatre binary32 dans l'ordre `(x,y,z,w)` |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | Résultat BLAKE3 par défaut, Payload fixe de 16 WORD |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | Suite d'octets ASCII relative-ref de la RFC 3986. Nombre pair d'octets |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | Idem. Nombre impair d'octets |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | Résultat CRC-32C de Castagnoli, Payload fixe de 2 WORD |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | Adresse IPv4 de 32 bits, Payload fixe de 2 WORD |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | Adresse IPv6 de 128 bits, Payload fixe de 8 WORD |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | IEEE 754 decimal32 DPD, Payload fixe de 2 WORD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | IEEE 754 decimal64 DPD, Payload fixe de 4 WORD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | IEEE 754 decimal128 DPD, Payload fixe de 8 WORD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | IEEE 754 decimal32 BID, Payload fixe de 2 WORD |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | IEEE 754 decimal64 BID, Payload fixe de 4 WORD |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | IEEE 754 decimal128 BID, Payload fixe de 8 WORD |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | Nombre signé de nanosecondes depuis l'epoch Unix/POSIX |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | Adresse MAC IEEE 802 de 48 bits, Payload fixe de 3 WORD |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | Vecteur packed fixe de 4×UNORM8 dans l'ordre R, G, B, A |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | Vecteur packed fixe de 4×UNORM8 dans l'ordre B, G, R, A |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | Scalaire ONNX E4M3FN dans l'octet de poids fort du Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | Scalaire ONNX E4M3FNUZ dans l'octet de poids fort du Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | Scalaire ONNX E5M2 dans l'octet de poids fort du Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | Scalaire ONNX E5M2FNUZ dans l'octet de poids fort du Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | Scalaire E8M0FNU à exposant seul, non signé, dans l'octet de poids fort du Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | Scalaire ONNX/DLPack E2M1FN dans le quartet de poids fort du Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | Nombre signé de secondes SI depuis `1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | Nombre signé de nanosecondes depuis la même epoch TAI |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | Résultat SHA-512, Payload fixe de 32 WORD |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | Résultat SHA3-256, Payload fixe de 16 WORD |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | Nombre signé de secondes depuis l'epoch GPS |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | Nombre signé de nanosecondes depuis l'epoch GPS |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

Un numéro de Meta n'indique pas la classe par ses bits. La classe se connaît par le tableau de plages ci-dessous. La classe de vérification est celle des enregistrements de la section 15 avec `C >= 5`, soit `w >= 0x1E50`, et se connaît sans codebook. Meta n'a pas de code ISSUER.

| Classe | Codes directs | Objet |
|---|---|---|
| [structure](meta/_index.md#구조) | `0x1C0L~0x1C4L` | Limites et longueur du document |
| [définition](meta/_index.md#정의) | `0x1C5L~0x1CAL` | Déclarations d'interprétation |
| [provenance](meta/_index.md#출처) | `0x1CBL~0x1D0L` | Qui, quand, où |
| [lignée](meta/_index.md#계보) | `0x1D1L~0x1DDL` | D'où cela vient et comment |
| [politique](meta/_index.md#정책) | `0x1DEL~0x1E3L` | Comment le traiter |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | Importe un document externe par IMPORT ID (`IMPORT-DOC`) |
| [vérification](meta/_index.md#검증) | `0x1E5L~0x1E9L` | Est-ce digne de confiance |
| Reserved (réservé à la vérification) | `0x1EAL~0x1FFL` |  |

- Les numéros se suivent à partir de `0x1C0L` sans Reserved. Un nouveau Meta hors vérification ne peut pas être inséré avant la vérification. Le Reserved final `0x1EAL~0x1FFL` est réservé à la vérification. Un Meta hors vérification placé ici serait exclu du hachage du contenu.

### Structure (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | Nom | Description |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | Début de document dont la longueur totale est donnée dans un Payload de 1 WORD |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | Début de document dont la longueur totale est donnée dans un Payload de 2 WORD |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | Début de document dont la longueur totale est donnée dans un Payload de 4 WORD |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. Termine le HEAD du document et commence le BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. Ferme le document. |

### Définition (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | Nom | Description |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | Version de la spécification GEUL suivie. Le Payload est lui-même l'entier non signé de largeur minimale. v1 est `0x0001` (enregistrement `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | Profil appliqué |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | Identifiant de ce document. Reference intégrée `DOC-POINTER` (Issuer, ID de document, version 0). Pour un document de Codec, `CODEC-POINTER` (Issuer, ID de Codec, version 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | Date d'entrée en vigueur de cette version. Value GREGORIAN-DATE ou POSIX-TIMESTAMP. À défaut, l'heure de publication |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | Fin de la période de validité de cette version (loi temporaire). À défaut, jusqu'à l'entrée en vigueur de la version suivante |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | Langue par défaut |

### Provenance (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | Nom | Description |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | Auteur. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | Coauteur. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | Moment de rédaction. Value TIME (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | Moment de modification. Value TIME |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | Entité qui a enregistré. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | Moment de l'enregistrement. Value TIME (git commit date) |

- Les matériaux d'origine, leur portée, leur moment d'acquisition et leur hachage s'écrivent non pas dans Meta mais avec l'Edge de fondement [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) du HEAD (Target `0`) et son QUALIFIER.

### Lignée (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | Nom | Description |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | Hachage du contenu de la version précédente (git parent). À défaut, c'est la première version ; s'il y en a plusieurs, c'est une fusion (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | Dérivé d'enregistrements ou de matériaux d'une autre lignée. Pour figer sur une version précise d'un matériau externe, on ajoute un QUALIFIER de hachage du texte original (P4092) au [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) du HEAD (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | Entité génératrice. Humain, modèle, moteur de règles |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | Méthode de transformation. Outil, règle, version |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | Hachage du contenu de la version d'origine dont un changement d'une autre lignée a été repris (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | Hachage du contenu de la version cible dont le changement a été annulé (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | Hachage du contenu de la version cible réécrite (git amend, rebase). La version d'origine n'est pas effacée. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | Hachages du contenu des versions d'origine fusionnées en une seule (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | Raison du changement. Value UTF8-LANGUAGE-TEXT, une par langue (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | Nom immuable attaché à une version. Value TEXT et hachage du contenu (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | Le fichier de cette version est un diff par rapport à une version de base (ID de version de 2 WORD) du même document (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | Liste des LOCAL ID (Edge Id) à retirer du BODY de base dans le diff |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | Prochain LOCAL ID à attribuer (auto increment). Placé dans le HEAD de la liste des versions `versions.geul` |

### Politique (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | Nom | Description |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | Licence. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | Portée de la divulgation |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | Niveau de données personnelles |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | Durée de conservation |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | Portée et fondement du consentement |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | Restrictions d'usage |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | Nom | Description |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | Importe un document externe par IMPORT ID. Reference intégrée `DOC-POINTER` (`CODEC-POINTER` pour un document de Codec) + IMPORT ID |

### Vérification (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | Nom | Description |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | Déclaration de l'ID de l'algorithme de signature et de la clé publique d'un Issuer auto-émis |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | Signature d'une cible. La signature d'un document signe son hachage du contenu (git signed commit, tag) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | Confirmation du droit de contribuer. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | Niveau de confiance |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | Résultat du verdict du document entier. Pass, Review, Fail. Au niveau d'un nœud ou d'un enregistrement, c'est [TOULMIN](toulmin/_index.md) `VERDICT` (Edge `0x118L`) |

## Table d'attribution complète {#전체-배정표}

227 cases attribuées, 176 md. Les systèmes 5Q et les paires pair-impair occupent une ligne par membre, et le md est celui de tête du groupe.

| TAG ID | Codec ID | Nom | Kind | Section | md | Groupe |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | pair-impair `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | pair-impair `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | pair-impair `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | pair-impair `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | pair-impair `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | pair-impair `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | pair-impair `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | pair-impair `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | pair-impair `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | pair-impair `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | pair-impair `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | pair-impair `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | pair-impair `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | pair-impair `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
