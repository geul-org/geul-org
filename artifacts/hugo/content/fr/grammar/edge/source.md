---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE est un Edge de fondement (Codec 0x20) qui rattache un enregistrement, ou le document entier, à son origine. Les propriétés de l'origine s'écrivent par un TRIPLE dont l'origine est le Subject, celles de la citation (date de consultation, emplacement dans l'origine, hachage du texte d'origine) par des QUALIFIER joints au SOURCE. Le SOURCE du document entier se place dans le HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE est un Edge de fondement qui rattache un enregistrement (la cible), ou le document entier, à l'origine dont il provient. Codec `0x20`. C'est le seul code direct de la famille fondement (`01`).

Une reference (groupe de sources) de Wikidata correspond à un SOURCE. Si un enregistrement a plusieurs sources, il y a plusieurs SOURCE.

## Disposition

```
TAG WORD          0001 0LLL L010 0000
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Target            enregistrement Reference LOCAL (dans le BODY, Edge Id de l'Edge auquel on attache le fondement ; dans le HEAD, 0 = document entier)
Origin            enregistrement Reference, ou marqueur d'emplacement 0x0000 ABSENT, 0x0001 UNKNOWN-VALUE
```

- Origin désigne l'origine. S'il existe une Reference adaptée à l'origine, on l'emploie (WIKIDATA-QID, DOC-POINTER ou EXTERNAL-ISSUER d'un document GEUL, etc.), sinon c'est un nœud LOCAL de ce document.
- Si la source ne décrit pas d'origine (par ex. une source de Wikidata qui n'a que « imported from » (P143) et une date de consultation), Origin est [ABSENT](/fr/grammar/reference/slot-marker/) (non renseigné). L'auteur n'a simplement pas écrit l'origine et n'affirme rien sur elle. Le reste de la source demeure tel quel dans les QUALIFIER.
- On n'emploie [UNKNOWN-VALUE](/fr/grammar/reference/slot-marker/) que lorsque l'auteur affirme « il y a une origine mais je ne sais pas laquelle » (enregistrement écrit par un humain, etc.). Un convertisseur qui transcrit depuis un document d'origine n'affirme pas ce que l'origine ne dit pas, et emploie donc ABSENT.
- Les Origin ABSENT ou UNKNOWN-VALUE sont indépendants à chaque occurrence. On ne lit pas les origines de deux SOURCE comme identiques.

## Deux couches

Les informations de provenance se divisent en deux. On ne les mélange pas.

| Couche | Quoi | Comment l'écrire | Exemple |
|---|---|---|---|
| Origine | Propriétés de l'origine elle-même. Les mêmes quel que soit le citant | [TRIPLE](/fr/grammar/edge/triple/) dont l'origine est le Subject (rank normal) | URL (P854), titre (P1476), auteur (P50, P2093), date de publication (P577), publié dans (P1433), éditeur (P123), langue (P407) |
| Citation | Propriétés de l'acte par lequel cet enregistrement cite l'origine | [QUALIFIER](/fr/grammar/edge/qualifier/) ayant l'Edge Id du SOURCE pour Target | Date de consultation (P813), emplacement dans l'origine (page P304, section P958, identifiants externes P227, P1417), lieu d'importation (P143), méthode d'inférence (P887), hachage du texte d'origine (P4092) |

- **Le sens d'un SOURCE est l'ensemble de tous les QUALIFIER qui désignent son Edge Id.** Deux sources qui ont consulté la même origine à des jours différents ont la même origine et des QUALIFIER différents.
- Un TRIPLE d'origine est une affirmation sur l'origine. Une propriété dont on ne sait pas à quelle couche elle appartient se place du côté de la citation (QUALIFIER). Mieux vaut ne pas affirmer de choses sur l'origine.
- Dans un document, une même origine est déclarée une seule fois par un LOCAL, que plusieurs SOURCE désignent ensemble.
- Une origine décrite par une seule URL se définit par [REFERENCE-NODE](/fr/grammar/edge/reference-node/) (LOCAL → URI). Même méthode que pour les pages de document sitelink.

## Interprétation et validité

- Target et Origin sont chacun exactement un enregistrement complet. Le curseur après lecture d'Origin doit coïncider avec la fin de l'Edge.
- Target est une Reference LOCAL. Le SOURCE du BODY désigne l'Edge Id d'un Edge du BODY du même document. `0` (document entier) n'est employé que par le SOURCE du HEAD ([Origine du document entier](#origine-du-document-entier)). Un SOURCE de Target `0` dans le BODY est invalid. Pour les enregistrements d'un autre document, on attache le fondement dans ce document-là.
- Origin est une Reference. Parmi les marqueurs d'emplacement, il n'accepte que `0x0000` (ABSENT) et `0x0001` (UNKNOWN-VALUE). Il n'accepte ni NO-VALUE (`0x0002`) ni Value.
- Le document de spécification de geul.org `0x0000/0x0000000000001020` (nom `source`) place sur Target le [CODEC](/fr/grammar/edge/codec/) LOCAL (`0008`) et sur Origin les CODEC `0780` (toute Reference), `0000` (ABSENT, facultatif) et `0001` (UNKNOWN-VALUE).
- L'ordre entre SOURCE d'un même Target n'a pas de sens. L'ordre des éléments à l'intérieur d'une source n'en a pas non plus (l'ordre des valeurs d'une même propriété subsiste comme ordre du document).
- SOURCE ne change pas la vérité ou la fausseté de la cible. Il indique seulement d'où elle vient. Le résultat de jugement relève de [TOULMIN](/fr/grammar/edge/toulmin/) `VERDICT`.

## Origine du document entier

L'origine du document entier (dump d'origine, édition, fichier du texte d'origine) s'écrit par **un SOURCE de Target `0` dans le HEAD**. Les QUALIFIER ayant ce SOURCE pour Target (hachage du texte d'origine P4092, instant de réception P813, étendue dans le texte d'origine, etc.) se placent aussi dans le HEAD ([Document](/fr/grammar/document/#head-et-body)).

- Ce sont les seuls Edge admis dans le HEAD. Les autres Edge vont dans le BODY.
- Les QUALIFIER du HEAD se placent après le SOURCE du HEAD qu'ils désignent. Le décodeur lit depuis le début et sépare HEAD et BODY.
- Un QUALIFIER ayant pour Target un SOURCE du HEAD est invalid dans le BODY. Les SOURCE et QUALIFIER du BODY ne désignent pas d'Edge du HEAD.
- **Les Edge Id du HEAD et du BODY partagent un seul espace de numéros.** Un Edge Id est unique dans le document, s'obtient auprès de [NEXT-LOCAL-ID](/fr/grammar/meta/lineage/next-local-id/) comme pour les autres Edge, et à la reconstruction, un contenu identique reprend le même numéro. Dans une version d'où un Edge de HEAD a disparu, ce numéro n'est pas réutilisé.
- Si Origin est un LOCAL, sa définition (REFERENCE-NODE, TRIPLE d'origine) se place dans le BODY. La portée d'un LOCAL est le document entier.
- Les Edge de HEAD n'étant pas des Meta de la classe de vérification, ils entrent dans le [hachage du contenu](/fr/grammar/document/#hachage-du-contenu). Dans un diff, ils sont remplacés en bloc avec le HEAD (ils ne s'écrivent pas dans `DELTA-REMOVE`).
- Il n'y a pas de Meta distinct pour l'origine du document entier. L'étendue dans le texte d'origine et l'instant d'acquisition écrits en Meta ne permettent pas de dire de quelle origine ils relèvent quand il y en a plusieurs. Le QUALIFIER joint au SOURCE le détermine par son Target.

Exemple : HEAD d'un document de Q42 transcrit d'un dump Wikidata (les Edge Id sont à titre d'illustration).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         édition (revision) de l'entité
#1741 SOURCE     #0     #1740                                         fichier de dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            hachage du fichier
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    instant de réception
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      instant d'enregistrement de l'édition
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  permalien de l'édition
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- L'édition et le dump étant des origines différentes, on place deux SOURCE. L'édition est l'origine du contenu (le permalien permet de recevoir à nouveau le même contenu), le dump est le fichier dont on a reçu cette édition. Le hachage du fichier et l'instant de réception sont des propriétés de la citation relatives au fichier de dump et se joignent donc au SOURCE du dump.

## Expression des autres fondements

La famille fondement ne contient que SOURCE. Les autres fondements s'écrivent par QUALIFIER.

| Fondement | Comment l'écrire | Property |
|---|---|---|
| Étendue dans le texte d'origine | QUALIFIER sur le SOURCE. Un SOURCE par étendue | Page P304, section P958, citation P1683. Étendue en caractères : terme GEUL (non fixé) |
| Instant de réception de l'origine | QUALIFIER sur le SOURCE | Date de consultation P813 |
| Hachage en octets du texte d'origine (figer l'édition) | QUALIFIER sur le SOURCE | Somme de contrôle P4092, valeur [SHA-256-DIGEST](/fr/grammar/value/binary/sha-256-digest/), etc. |
| Auteur (personne, modèle, moteur de règles) | QUALIFIER sur le SOURCE (auteur de la citation) ou sur la cible | Terme GEUL (non fixé) |
| Confiance | QUALIFIER sur la cible | Terme GEUL (non fixé), valeur de 0 à 1 comme le Meta [CONFIDENCE](/fr/grammar/meta/verification/confidence/) |
| Période d'application par article | QUALIFIER sur la cible | Début P580, fin P582 |
| Ancien enregistrement avant déplacement, scission ou fusion | QUALIFIER sur la cible, la valeur étant l'ancien Edge Id (LOCAL) | P1365 (replaces) |
| Version d'entrée initiale | Non stockée. Se calcule à partir de l'historique des versions (git blame) | |

## Exemple (non normatif)

Q42 P19 (lieu de naissance) Q350, TRIPLE cible `#178`. Dans le dump Wikidata du 2026-10-19, cette affirmation a cinq sources ; trois sont montrées. ③, un article du Telegraph (`#1358`~`#1367`), a la même forme que ②, et ⑤, Store norske leksikon (Q746368), la même que ① ; ils sont donc omis.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica : sans description d'origine, seul P248
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② article du Guardian #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND : LOCAL #1158 déclaré plus haut (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① n'a pas de description d'origine et n'a qu'un P248, donc l'origine est cet élément. `#1347` fait TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- Source avec une seule URL : `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Source qui n'a que « imported from » Wikipédia en anglais : `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000`, 1 WORD.

## Problèmes ouverts

- Termes GEUL (documents de définition de termes et ID) pour exprimer l'étendue en caractères, l'auteur et la confiance.
- Quand la description d'origine ne permet pas d'identifier l'origine (source n'ayant que la langue, etc.), partager cette description par un seul LOCAL reviendrait à affirmer que des origines différentes sont identiques.
- Liste des propriétés d'origine et de citation pour les sources hors Wikidata (lois, citations web).
- Source de la source (chaîne) : faut-il attacher à nouveau un SOURCE au LOCAL d'origine.

## Pages liées

- [Edge](/fr/grammar/edge/), [TRIPLE](/fr/grammar/edge/triple/), [QUALIFIER](/fr/grammar/edge/qualifier/), [REFERENCE-NODE](/fr/grammar/edge/reference-node/), [Marqueur d'emplacement](/fr/grammar/reference/slot-marker/)
- [Document](/fr/grammar/document/) (HEAD et BODY), [Meta — Source](/fr/grammar/meta/provenance/)
