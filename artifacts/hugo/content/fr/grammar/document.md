---
title: "Document"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "L'unité des données GEUL est le document. Il s'ouvre en indiquant sa longueur, se ferme par END, et se divise en HEAD (Meta et origine du document entier) et BODY (Reference, Value, Edge). Chaque version est figée par son hachage du contenu."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

L'unité des données GEUL est un document (DOC). Un fichier (`.geul`, type de média `application/vnd.geul`) est un document.

## Structure

```
DOC-*            ← ouvre le document (longueur totale)
  Meta …         ← HEAD : enregistrements portant sur le document
  SOURCE …       ←   (origine du document entier et ses QUALIFIER)
BODY             ← termine le HEAD et ouvre le BODY
  Reference, Value, Edge …
END              ← ferme le document
```

| Enregistrement | TAG | Sens |
|---|---|---|
| DOC-1WORD | `1880` + 1 WORD | Ouvre le document avec la longueur totale sur 1 WORD |
| DOC-2WORD | `1901` + 2 WORD | Longueur totale sur 2 WORD |
| DOC-4WORD | `1A02` + 4 WORD | Longueur totale sur 4 WORD |
| BODY | `180E` | 1 WORD. Termine le HEAD et commence le BODY |
| END | `180F` | 1 WORD. Ferme le document |

- La valeur de DOC-* est le nombre total de WORD depuis le début de l'enregistrement d'ouverture jusqu'à la fin de END. On emploie la largeur la plus étroite qui contienne la valeur.
- END est obligatoire. Si la position de END ne correspond pas à la longueur de DOC-*, on rejette. Si l'entrée s'arrête sans END, le document est tronqué.
- Le décodeur peut sauter tout le document d'un coup grâce à la longueur de DOC-*.
- Il n'existe aucun moyen d'ouvrir un document sans connaître sa longueur. Les données en temps réel dont on ignore la fin sont découpées en unités de longueur connue et envoyées dans plusieurs documents.
- Si le HEAD est vide, BODY est omis. Un document sans enregistrement BODY est entièrement BODY. BODY n'apparaît qu'une fois. Dès que le HEAD contient un enregistrement (Meta ou Edge de HEAD), on place BODY.
- Les documents ne s'imbriquent pas. Un autre document se désigne par [IMPORT](/fr/grammar/meta/) ou par une Reference de pointeur.

## HEAD et BODY

- Le HEAD ne contient que des Meta et des **Edge de HEAD**. Tous sont des descriptions du **document** qui les contient.
  - Meta : structure, définition, source, lignée, vérification, politique, IMPORT du document.
  - Edge de HEAD : l'Edge de fondement [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) (Target `0`) qui consigne l'origine du document entier, puis les [QUALIFIER](/fr/grammar/edge/qualifier/) ayant ce SOURCE pour Target (hachage du texte d'origine, instant de réception, étendue dans le texte d'origine, etc.). Les QUALIFIER se placent après ce SOURCE.
- Le BODY ne contient que des Reference, Value et Edge. L'origine d'un enregistrement individuel s'écrit par un Edge de fondement [SOURCE](/fr/grammar/edge/source/) dans le BODY, les autres fondements comme la confiance par un QUALIFIER joint à cet enregistrement. Un SOURCE de Target `0` et un QUALIFIER ayant pour Target le SOURCE du HEAD ne peuvent pas figurer dans le BODY.
- Le décodeur lit le HEAD depuis le début et trie. Un Meta est du HEAD. Un SOURCE de Target `0` est du HEAD, et l'on retient son Edge Id. Un QUALIFIER ayant pour Target un SOURCE retenu est du HEAD. Si un autre enregistrement arrive : si le HEAD est vide, BODY a été omis (ce BODY commence à cet enregistrement) ; sinon, c'est un BODY manquant et le document est invalid.
- **Les Edge Id du HEAD et du BODY partagent un seul espace de numéros.** Un Edge Id est unique dans le document et, comme pour les Edge du BODY, s'obtient auprès de [NEXT-LOCAL-ID](/fr/grammar/meta/lineage/next-local-id/). Si l'Origin d'un Edge de HEAD est LOCAL, sa définition se place dans le BODY (la portée d'un LOCAL est le document entier).
- Un Meta peut contenir des enregistrements Value dans son Payload. Une Value ainsi contenue n'est pas un enregistrement indépendant mais une partie de ce Meta.
- La portée d'une déclaration (classe de définition de Meta) est ce document.

## Déclarations de base

Les deux déclarations ne figurent qu'une fois au plus. Les conditions ci-dessous fixent dans quel document chacune est obligatoire.

| Meta | Sens | Documents où elle est requise |
|---|---|---|
| [SPEC-VERSION](/fr/grammar/meta/declaration/spec-version/) | Édition de la spécification suivie. Elle fixe comment lire les autres enregistrements. Si l'édition est inconnue, on rejette ou on avertit. La valeur d'un document v1 est `0x0001` | Documents publiés. À défaut, le décodeur lit selon l'édition qu'il connaît |
| [DOC-ID](/fr/grammar/meta/declaration/doc-id/) | Identifiant du document lui-même. Il faut l'avoir pour désigner, depuis l'extérieur, ce document et ce qu'il contient | Documents sous `.well-known/geul/` dont le nom commence par `0x` (documents de version, documents de spécification). Non placé dans la liste des versions ni dans l'index des noms |

- `SPEC-VERSION` ne contient qu'un entier, pour que le décodeur de n'importe quelle édition puisse le lire (en v1, `1890 0001`). Il ne s'appuie pas sur un code de Value.
- `DOC-ID` est un DOC-POINTER qui désigne le document lui-même (Issuer, ID de document, version `0`). L'ID de document fait 4 WORD.
- Un document sans `DOC-ID` est un document sans nom. On ne peut le désigner que par son hachage du contenu.

## Hachage du contenu

On désigne un exemplaire de document par son **hachage du contenu** (même rôle que l'ID de commit de git).

- C'est le SHA-256 depuis l'enregistrement d'ouverture (DOC-*) jusqu'à juste avant END. 16 WORD.
- Les Meta de la classe de vérification (signatures, etc.) sont exclus du calcul. Placer la signature dans le document ne crée donc pas de circularité.
- Pour le calcul, la longueur de DOC-* est remplacée par la longueur sans les enregistrements de vérification, et la largeur par la plus étroite qui convienne à cette longueur. Le hachage du contenu est ainsi le même avant et après l'ajout de la signature.
- Le hachage du contenu n'est pas consigné dans le document, il se calcule. On ne l'écrit comme valeur que pour désigner une autre version (`PARENT`, etc.).
- Le `PARENT` du document entrant dans le calcul, le hachage du contenu forme une chaîne de hachages reliant tout l'historique.
- Un Meta ajouté plus tard hors du document (annotation dans un dépôt séparé) ne change pas le hachage du contenu (comme git notes).
- Le binaire fait foi pour un document. Le hachage du contenu et la signature ne se calculent que sur le binaire.

## Versions

Un document nommé (ayant un `DOC-ID`) a des versions.

- L'**ID de version** est un entier de 2 WORD numéroté à partir de 1 dans l'ordre de publication au sein d'un document. `0` signifie « version non indiquée » et se traite comme la dernière version.
- L'ID de version est attribué par l'éditeur à la publication. La correspondance entre ID de version et hachage du contenu se trouve dans la liste des versions signée par l'éditeur ([Adresse de publication et liste des versions](/fr/grammar/publishing/#liste-des-versions)).
- On ne republie pas le même contenu. Si le hachage du contenu existe déjà, on renvoie son ID de version.
- Quand les 2 WORD sont épuisés, on publie sous un nouvel ID de document.
- À partir de la v2, le HEAD porte `PARENT` (hachage du contenu de la version précédente). Comme il entre dans le hachage du contenu, les versions sont reliées en chaîne de hachages. On ne le place pas dans la version initiale.

## Révision

Les documents GEUL se révisent comme les lois.

- **Les versions sont immuables.** Une version publiée ne se modifie ni ne s'efface. Les seules exceptions sont la suppression légale et la suppression d'office ([TOMBSTONE](/fr/grammar/edge/publication/)).
- L'historique ne s'efface pas. Une correction paraît comme une nouvelle version et n'écrase pas la version d'origine (conservation du droit ancien). Une version réécrite se relie à la version d'origine par [REPLACES](/fr/grammar/meta/lineage/replaces/).
- Les pointeurs mobiles (branch, HEAD, reflog) ne se placent pas dans le document. Ils se gèrent hors du document (dépôt, index).
- Une nouvelle version peut créer, réviser ou supprimer des définitions. Elle ne promet aucune compatibilité avec la version précédente. Un changement de définition d'un même terme est aussi une révision (par ex. « majeur » du Code civil coréen passe de 20 à 19 ans ; l'objet de l'infraction de viol du Code pénal passe de « femme » à « personne »).
- **Le LOCAL ID est une identité qui traverse les versions** (comme le numéro d'article). Un même LOCAL ID désigne la même cible d'une version à l'autre.
  - Création : on reçoit un nouveau LOCAL ID. L'ID n'ayant pas de sens d'ordre, il n'y a pas besoin d'insertions du genre « article X bis ». Le nouveau numéro s'obtient auprès du `NEXT-LOCAL-ID` de la liste des versions (auto increment).
  - Révision : on modifie le contenu du même LOCAL ID.
  - Suppression : on retire ce LOCAL ID de la nouvelle version. **Un ID supprimé ne se réutilise pas.**
  - Déplacement, scission, fusion : on reçoit un nouveau LOCAL ID et l'on joint au nouvel enregistrement un QUALIFIER P1365 (replaces, la valeur étant l'ancien LOCAL ID) pour relier l'ancien ID. Comme l'ancien ID n'est plus réutilisé, il désigne cet enregistrement de la version précédente.
- Un outil qui reconstruit un document à partir d'un document d'origine respecte la même règle. Il donne le même LOCAL ID aux descriptions identiques à la version précédente et un nouveau numéro seulement à celles qui ont changé ou qui sont nouvelles. Il ne faut pas renuméroter à partir de 1 à chaque fois.
- Une citation précise une édition. Une citation à version figée se lie à cette version, une citation à la dernière version (version `0`) se lie à la version en vigueur au moment de l'interprétation. Un document qui traite d'événements passés cite en figeant la version en vigueur à ce moment-là.
- Publication et entrée en vigueur sont distinctes. L'instant de publication est consigné par la liste des versions, la période d'application par le document.
  - [EFFECTIVE-FROM](/fr/grammar/meta/declaration/effective-from/) et [EFFECTIVE-UNTIL](/fr/grammar/meta/declaration/effective-until/) : période d'application de la version entière
  - QUALIFIER P580 (début) et P582 (fin) de l'Edge d'article : quand les dates d'entrée en vigueur diffèrent selon l'article
- **L'édition en vigueur à l'instant T est la version la plus élevée dont la date d'entrée en vigueur est inférieure ou égale à T.** S'il existe des QUALIFIER P580 et P582 par article, ils priment. Une édition dont la durée de validité (`EFFECTIVE-UNTIL`) est dépassée n'est pas en vigueur.
- Les règles qui déterminent l'édition à appliquer, telles que les dispositions transitoires (« on suit les dispositions antérieures »), la loi du moment des faits et le choix de la loi nouvelle plus favorable au prévenu, relèvent du jugement ([TOULMIN](/fr/grammar/edge/toulmin/)). Les informations d'entrée en vigueur en sont la matière.
- Quand une interprétation officielle ou une jurisprudence restreint ou élargit l'interprétation d'un terme, ce n'est pas une révision du document mais une règle de jugement. Quand l'interprétation est fixée par la loi (par ex. création de la définition de « 1 semaine » dans la loi coréenne sur les normes du travail), c'est une révision.
- On ne révise pas la disposition binaire (wire) des Codec et des numéros de format. En effet, un enregistrement encodé par un numéro de format se lit sans figer la version du livre de codes. Pour changer la disposition, on attribue un nouveau numéro. Un numéro de format supprimé n'est pas réutilisé pour un autre format.

## Stockage du diff

Une version se définit toujours comme le document entier (instantané). Le diff n'est qu'un format pour stocker et transmettre cet instantané en moins d'espace.

- Seul un document ayant un `DOC-ID` et dont le BODY ne contient que des Edge peut être placé en diff. Les `versions.geul`, `documents.geul` et `issuers.geul`, qui n'ont pas de gestion de versions, et les documents sans nom ne sont pas mis en diff.
- Un document diff est un document GEUL ordinaire, dont le HEAD contient [DELTA-BASE](/fr/grammar/meta/lineage/delta-base/) (ID de version de base).
- Les suppressions s'écrivent par [DELTA-REMOVE](/fr/grammar/meta/lineage/delta-remove/) (liste des LOCAL ID à retirer), les ajouts et révisions par les Edge du BODY. Il n'y a pas de marqueur distinct d'ajout ou de révision. Si l'Edge Id existe dans la base, c'est une révision ; sinon, un ajout.
- La restitution de l'instantané doit être déterministe (sinon le hachage ne correspond pas).
  1. On restitue l'instantané de la version de base. Si la base est aussi un diff, on restitue récursivement.
  2. Le HEAD est remplacé en bloc par le HEAD du diff privé de `DELTA-BASE` et `DELTA-REMOVE`. Les Edge de HEAD changent aussi (ils ne s'écrivent pas dans `DELTA-REMOVE`).
  3. Le BODY garde l'ordre de la base. Les ID de `DELTA-REMOVE` sont retirés ; si l'Edge Id d'un Edge du BODY du diff existe dans la base, il le remplace à sa place.
  4. Les Edge Id absents de la base sont ajoutés à la fin dans l'ordre d'apparition dans le diff.
  5. Le hachage du contenu du résultat doit être égal au hachage de cette version dans la liste des versions. Sinon, invalid.
- Réutiliser dans un diff un LOCAL ID supprimé est invalid. On ne réutilise pas non plus l'Edge Id d'un Edge de HEAD disparu.
- Hachage du contenu, liste des versions et signatures se rapportent tous à l'instantané restitué.
