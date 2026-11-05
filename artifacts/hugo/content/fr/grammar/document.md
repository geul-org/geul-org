---
title: "Document"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "L'unité des données GEUL est le document (DOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

L'unité des données GEUL est le document (DOC). Un fichier (`.geul`, type de média `application/vnd.geul`) est un document.

## Structure {#구조}

```
DOC-*            ← ouvre le document (longueur totale)
  Meta …         ← HEAD : enregistrements portant sur le document
  SOURCE …       ←   (provenance du document entier et ses QUALIFIER)
BODY             ← termine le HEAD et ouvre le BODY
  Reference, Value, Edge …
END              ← ferme le document
```

| Enregistrement | TAG | Sens |
|---|---|---|
| DOC-1WORD | `1C01` + 1 WORD | ouvre le document en donnant la longueur totale sur 1 WORD |
| DOC-2WORD | `1C12` + 2 WORD | longueur totale sur 2 WORD |
| DOC-4WORD | `1C24` + 4 WORD | longueur totale sur 4 WORD |
| BODY | `1C30` | 1 WORD. Termine le HEAD et commence le BODY |
| END | `1C40` | 1 WORD. Ferme le document |

- La valeur de DOC-* est le nombre total de WORD depuis le début de l'enregistrement d'ouverture jusqu'à la fin de END. On utilise la plus étroite des largeurs qui contient la valeur.
- END est obligatoire. Si la position de END ne correspond pas à la longueur de DOC-*, on rejette. Si l'entrée s'achève sans END, le document est tronqué.
- Le décodeur peut sauter le document entier d'un coup grâce à la longueur de DOC-*.
- Il n'existe aucun moyen d'ouvrir un document sans connaître sa longueur. Les données en temps réel dont la fin n'est pas connue d'avance sont découpées en unités de longueur connue et envoyées en plusieurs documents.
- Si le HEAD est vide, le BODY est omis. Un document sans enregistrement BODY est entièrement BODY. Le BODY n'apparaît qu'une fois. Dès que le HEAD contient au moins un enregistrement (Meta ou HEAD Edge), on place le BODY.
- Les documents ne s'imbriquent pas. On désigne un autre document par [IMPORT](meta/_index.md) ou par une Reference de désignation.

## HEAD et BODY {#head와-body}

- Le HEAD ne contient que des Meta et des **HEAD Edge**. Tous sont des énoncés sur le **document** qui les contient.
  - Meta : structure, définition, provenance, lignée, vérification, politique et IMPORT du document.
  - HEAD Edge : l'Edge de fondement [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (Target `0`) qui note l'origine du document entier, puis les [QUALIFIER](edge/0x0ABL-qualifier.md) ayant ce SOURCE pour Target (hachage du texte original, heure de réception, étendue du texte original, etc.). Le QUALIFIER se place après ce SOURCE.
- Le BODY ne contient que des Reference, Value et Edge. La provenance d'un enregistrement individuel s'écrit avec l'Edge de fondement [SOURCE](edge/0x0C0L-source.md) dans le BODY, et les autres fondements comme la fiabilité s'écrivent avec un QUALIFIER attaché à cet enregistrement. Un SOURCE de Target `0` et un QUALIFIER ayant pour Target le SOURCE du HEAD ne peuvent pas figurer dans le BODY.
- Le décodeur lit le HEAD depuis le début et fait le tri. Un Meta est du HEAD. Un SOURCE de Target `0` est du HEAD et le décodeur retient son Edge Id. Un QUALIFIER ayant pour Target le SOURCE retenu est du HEAD. Quand arrive un autre enregistrement : si le HEAD est vide, le BODY a été omis (le BODY commence à cet enregistrement) ; sinon, le BODY manque et le document est invalid.
- **Le HEAD et le BODY partagent un seul espace de numéros d'Edge Id.** L'Edge Id est unique dans le document et, comme pour les Edge du BODY, s'obtient auprès de [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md). Si l'Origin d'un HEAD Edge est LOCAL, sa définition se place dans le BODY (LOCAL a pour portée le document entier).
- Un Meta peut contenir des enregistrements Value dans son Payload. Une Value ainsi contenue n'est pas un enregistrement indépendant mais une partie de ce Meta.
- La portée d'une déclaration (classe de définition de Meta) est ce document.

## Déclarations de base {#기본-선언}

Chacune des deux déclarations est présente au plus une fois. Les conditions ci-dessous fixent dans quels documents elles doivent figurer.

| Meta | Sens | Documents où il doit figurer |
|---|---|---|
| [SPEC-VERSION](meta/0x1C5L-spec-version.md) | Édition de la spécification suivie. Détermine comment lire les autres enregistrements. Si l'édition est inconnue, on rejette ou on avertit. La valeur d'un document v1 est `0x0001` | Documents publiés. En son absence, le décodeur lit selon l'édition qu'il connaît |
| [DOC-ID](meta/0x1C7L-doc-id.md) | Identifiant du document lui-même. Il doit exister pour désigner, depuis l'extérieur, ce document et les objets qu'il contient | Documents de version sous `docs/<ID de document>/` et `codecs/<ID de Codec>/` de `.well-known/geul/` (y compris les documents de spécification). On ne le place pas dans la liste des versions `versions.geul` ni dans les documents de liste (`issuers/`) |

- `SPEC-VERSION` ne contient qu'un seul entier, pour que le décodeur de toute édition puisse le lire (en v1, `1C51 0001`). On ne s'appuie pas sur un code Value.
- `DOC-ID` est un DOC-POINTER qui désigne le document lui-même (Issuer, ID de document, version `0`). L'ID de document fait 4 WORD. Un document de Codec n'a pas d'ID de document et utilise un [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, ID de Codec, version `0`). Tout Issuer réserve les ID de document `0x0000000000000000` et `0xFFFFFFFFFFFFFFFF` ([Issuer et publication](issuer.md#용어-정의-문서)).
- Un document sans `DOC-ID` est un document sans nom. On ne peut le désigner que par son hachage du contenu.

## Hachage du contenu {#내용-해시}

Une instance de document se désigne par son **hachage du contenu** (même rôle que l'ID de commit de git).

- C'est le SHA-256 depuis l'enregistrement d'ouverture (DOC-*) jusqu'à juste avant END. 16 WORD.
- Les Meta de la classe vérification (signatures, etc. ; dans la section 15, ceux avec `C >= 5`, c'est-à-dire `w >= 0x1E50`) sont exclus du calcul. Ainsi, placer la signature dans le document ne crée pas de circularité.
- Au calcul, la longueur de DOC-* est remplacée par la longueur sans les enregistrements de vérification, et sa largeur par la plus étroite adaptée à cette longueur. Le hachage du contenu est donc le même avant et après l'ajout de la signature.
- Le hachage du contenu n'est pas enregistré dans le document mais calculé. On ne l'écrit comme valeur que pour désigner une autre version (`PARENT`, etc.).
- Le `PARENT` d'un document entre aussi dans le calcul, si bien que le hachage du contenu forme une chaîne de hachages reliant tout l'historique.
- Un Meta ajouté après coup hors du document (annotation dans un dépôt séparé, etc.) ne change pas le hachage du contenu (comme git notes).
- Le binaire fait foi pour un document. Le hachage du contenu et la signature se calculent uniquement sur le binaire.

## Version {#버전}

Un document nommé (un document ayant un `DOC-ID`) possède des versions.

- L'**ID de version** est un entier de 2 WORD, numéroté à partir de 1 dans l'ordre de publication au sein d'un document. `0` signifie « version non indiquée » et est traité comme la dernière version.
- L'ID de version est attribué par l'éditeur au moment de la publication. La correspondance entre ID de version et hachage du contenu figure dans la liste des versions signée par l'éditeur ([adresse de publication et liste des versions](publishing.md#버전-목록)).
- On ne republie pas le même contenu. Si le hachage du contenu existe déjà, on renvoie son ID de version.
- Quand les 2 WORD sont épuisés, on publie sous un nouvel ID de document.
- À partir de la v2, le HEAD note `PARENT` (hachage du contenu de la version précédente). Comme il entre dans le hachage du contenu, les versions sont reliées en chaîne de hachages. On ne le place pas dans la première version.

## Révision {#개정}

Un document GEUL est révisé comme une loi.

- **Une version est immuable.** On ne modifie ni ne supprime une version publiée. Les seules exceptions sont la suppression légale et la suppression d'office ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- On n'efface pas l'historique. Le contenu corrigé paraît dans une nouvelle version, sans écraser la version d'origine (conservation de l'ancienne loi). Une version réécrite est reliée à la version d'origine par [REPLACES](meta/0x1D7L-replaces.md).
- Les pointeurs mutables comme branch, HEAD ou reflog ne se placent pas dans le document. On les gère hors du document (dépôt, index).
- Une nouvelle version peut créer, réviser ou supprimer des définitions. Elle ne promet aucune compatibilité avec la version précédente. Un changement de la définition d'un même terme est aussi une révision (exemple : « majeur » du Code civil coréen, de 20 à 19 ans ; l'objet du viol dans le Code pénal, « femme » devenu « personne »).
- **Un LOCAL ID est une identité qui traverse les versions** (comme un numéro d'article). Un même LOCAL ID désigne le même objet quelle que soit la version.
  - Création : on reçoit un nouveau LOCAL ID. L'ID n'ayant pas de sens d'ordre, il n'y a pas besoin d'insertions du type « article X bis ». Le nouveau numéro s'obtient auprès de `NEXT-LOCAL-ID` de la liste des versions (auto increment).
  - Révision : on change le contenu du même LOCAL ID.
  - Suppression : on retire ce LOCAL ID de la nouvelle version. **Un ID supprimé n'est plus réutilisé.**
  - Déplacement, scission, fusion : on reçoit un nouveau LOCAL ID, et l'on relie l'ancien ID en attachant au nouvel enregistrement un QUALIFIER P1365 (replaces, dont la valeur est l'ancien LOCAL ID). L'ancien ID n'étant plus réutilisé, il désigne cet enregistrement de la version précédente.
- Les outils qui reconstruisent un document à partir de données sources respectent aussi cette règle. Un énoncé identique à celui de la version précédente reçoit le même LOCAL ID, et seuls les énoncés modifiés ou nouveaux reçoivent un nouveau numéro. On ne doit pas renuméroter à partir de 1 à chaque fois.
- Une citation précise l'édition. Une citation à version fixe se lie à cette version, une citation à la dernière version (version `0`) se lie à la version en vigueur au moment de l'interprétation. Un document traitant d'un événement passé cite en fixant la version en vigueur à ce moment-là.
- Publication et entrée en vigueur sont distinctes. L'heure de publication est notée par la liste des versions, la période de vigueur par le document.
  - [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) et [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) : période de vigueur de la version entière
  - QUALIFIER P580 (début) et P582 (fin) de l'Edge d'article : quand la date d'entrée en vigueur diffère selon l'article
- **L'édition en vigueur à l'instant T est la version la plus haute dont la date d'entrée en vigueur est antérieure ou égale à T.** S'il existe des QUALIFIER P580 et P582 par article, ils prévalent. Une édition dont la durée de validité (`EFFECTIVE-UNTIL`) est dépassée n'est pas en vigueur.
- Les règles qui décident quelle édition appliquer, comme les dispositions transitoires (« on suit les dispositions antérieures »), la loi applicable au moment des faits et le choix de la loi nouvelle plus favorable à l'accusé, relèvent du verdict ([TOULMIN](toulmin/_index.md)). Les informations de vigueur en sont la matière.
- Le fait qu'une interprétation administrative ou une jurisprudence restreigne ou élargisse l'interprétation d'un terme n'est pas une révision du document mais une règle de verdict. Lorsque l'interprétation est fixée par la législation (exemple : la création de la définition de « 1 semaine » dans la loi sur les normes du travail), c'est une révision.
- La disposition binaire (wire) des Codecs et des numéros de Codec n'est pas révisée. En effet, un enregistrement encodé par numéro de Codec se lit sans fixer la version du livre de codes. Pour changer la disposition, on attribue un nouveau numéro. Un numéro de Codec supprimé n'est pas réutilisé pour un autre format.

## Stockage en diff {#diff-저장}

Une version se définit toujours comme le document entier (instantané). Le diff n'est qu'un format permettant de stocker et transmettre cet instantané en moins d'espace.

- Seul un document ayant un `DOC-ID` et dont le BODY n'est composé que d'Edge peut être mis en diff. La liste des versions `versions.geul`, qui n'a pas de `DOC-ID`, les documents de liste (versions de `issuers/`) et les documents sans nom n'ont pas de diff.
- Un document diff est un document GEUL ordinaire, et son HEAD contient [DELTA-BASE](meta/0x1DBL-delta-base.md) (ID de la version de base).
- La suppression s'écrit avec [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) (liste des LOCAL ID à retirer), l'ajout et la révision avec des Edge du BODY. Il n'y a pas de marque distincte pour ajout ou révision : si l'Edge Id existe dans la base, c'est une révision, sinon un ajout.
- La restauration de l'instantané doit être déterministe (sinon le hachage ne concorde pas).
  1. On restaure l'instantané de la version de base. Si la base est elle-même un diff, on restaure récursivement.
  2. Le HEAD est remplacé en bloc par le HEAD du diff privé de `DELTA-BASE` et `DELTA-REMOVE`. Les HEAD Edge changent aussi avec lui (on ne les note pas dans `DELTA-REMOVE`).
  3. Le BODY conserve l'ordre de la base. On retire les ID de `DELTA-REMOVE`, et si l'Edge Id d'un Edge du BODY du diff existe dans la base, on le remplace à sa place.
  4. Les Edge Id absents de la base sont ajoutés à la fin dans l'ordre où ils apparaissent dans le diff.
  5. Le hachage du contenu du résultat doit être égal au hachage de cette version dans la liste des versions. Sinon, invalid.
- Réutiliser dans le diff un LOCAL ID supprimé est invalid. On ne réutilise pas non plus l'Edge Id d'un HEAD Edge retiré.
- Le hachage du contenu, la liste des versions et la signature se rapportent tous à l'instantané restauré.
