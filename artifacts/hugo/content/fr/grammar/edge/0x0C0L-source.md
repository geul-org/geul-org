---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE est l'Edge de fondement qui relie un enregistrement (la cible) ou un document entier à la source dont il provient."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Rubrique | Valeur |
|---|---|
| Nom | `SOURCE` (document de spécification BIND `SOURCE`) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| Document de spécification | `0x00000000/codecs/0x00000C00/` (cible DECLARE `0C00`) |
| Section | 6 `0110` (fondement des Edge), décalage dans la section C = 0 |
| Kind | Edge · famille : fondement |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Relie un enregistrement ou un document entier à sa source. Target (Edge Id du BODY ; dans le HEAD, `0` = document entier), Origin (Reference, ABSENT ou UNKNOWN-VALUE). La nature de la source s'écrit par un TRIPLE dont la source est le Subject ; la nature de la citation (date de consultation, position, hachage du texte original) s'écrit par des QUALIFIER attachés au SOURCE. Le SOURCE d'un document entier et son QUALIFIER se placent dans le HEAD |
| Côté Hugo | `edge/source.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par un FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | enregistrement | `0050` LOCAL |  |
| 2 | `origin` | #3 | enregistrement | `000F` section 0 entière (joker, Reference), `020F` section 1 entière (joker, Reference), `040F` section 2 entière (joker, Reference), `0010` UNKNOWN-VALUE, `0000` ABSENT (champ facultatif) |  |

SOURCE est l'Edge de fondement qui relie un enregistrement (la cible) ou un document entier à la source dont il provient. Codec `0x0C0L`. C'est l'unique code direct de la famille fondement (`01`).

Une reference Wikidata (groupe de provenance) correspond à un SOURCE. Si un enregistrement a plusieurs provenances, il a plusieurs SOURCE.

## Disposition {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[TAG d'extension Length]
Edge Id           enregistrement LOCAL Reference
Target            enregistrement LOCAL Reference (dans le BODY, l'Edge Id de l'Edge auquel on attache le fondement ; dans le HEAD, 0 = document entier)
Origin            enregistrement Reference, ou marqueur d'emplacement 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

- Origin désigne la source. S'il existe une Reference adaptée à la source, on l'emploie (WIKIDATA-QID, DOC-POINTER ou EXTERNAL-ISSUER d'un document GEUL, etc.) ; sinon, c'est un nœud LOCAL de ce document.
- Si la provenance ne décrit pas de source (par exemple une provenance qui ne contient que « imported from » (P143) de Wikidata et une date de consultation), Origin est [ABSENT](../slot-marker.md) (non renseigné). L'auteur n'a simplement pas écrit la source ; il n'affirme rien à son sujet. Le reste de la provenance figure tel quel dans les QUALIFIER.
- [UNKNOWN-VALUE](../slot-marker.md) ne s'emploie que lorsque l'auteur affirme que « la source existe mais qu'on ignore laquelle » (note écrite par une personne, etc.). Un convertisseur qui transpose un matériau source n'affirme pas ce que la source ne dit pas ; il emploie donc ABSENT.
- Chaque occurrence d'un Origin ABSENT ou UNKNOWN-VALUE est indépendante. On ne lit pas les sources de deux SOURCE comme identiques.

## Deux couches {#두-층}

L'information de provenance se divise en deux. On ne les mélange pas.

| Couche | Quoi | Manière d'écrire | Exemple |
|---|---|---|---|
| Source | Nature de la source elle-même, identique quel que soit le citant | [TRIPLE](0x0AAL-triple.md) dont la source est le Subject (rank normal) | URL (P854), titre (P1476), auteur (P50·P2093), date de publication (P577), support de publication (P1433), éditeur (P123), langue (P407) |
| Citation | Nature de l'acte par lequel cet enregistrement cite la source | [QUALIFIER](0x0ABL-qualifier.md) dont la Target est l'Edge Id du SOURCE | date de consultation (P813), position dans la source (page P304, section P958, identifiant externe P227·P1417), origine de l'import (P143), méthode d'inférence (P887), hachage du texte original (P4092) |

- **Le sens d'un SOURCE est l'ensemble des QUALIFIER qui pointent vers son Edge Id.** Deux provenances consultées à des dates différentes ont la même source mais des QUALIFIER différents.
- Un TRIPLE de source est une assertion sur la source. Une propriété dont on ne peut décider la couche se place du côté de la citation (QUALIFIER). Mieux vaut ne rien affirmer sur la source.
- Dans un document, une même source est déclarée une seule fois par un LOCAL, que plusieurs SOURCE désignent ensemble.
- Une source décrite par une seule URL se définit par un [REFERENCE-NODE](0x0A0L-reference-node.md) (LOCAL → URI), comme la page de document sitelink.

## Interprétation et validité {#해석과-유효성}

- Target et Origin sont chacun exactement un enregistrement complet. Le curseur qui a lu Origin doit coïncider avec la fin de l'Edge.
- Target est une Reference LOCAL. Le SOURCE du BODY désigne l'Edge Id d'un Edge du BODY du même document. `0` (document entier) n'est employé que par le SOURCE du HEAD ([provenance du document entier](#문서-전체의-출처)). Un SOURCE de Target `0` dans le BODY est invalid. Pour un enregistrement d'un autre document, on attache le fondement à l'intérieur de ce document.
- Origin est une Reference. Pour les marqueurs d'emplacement, seuls `0x0000` (ABSENT) et `0x0010` (UNKNOWN-VALUE) sont admis. NO-VALUE (`0x0020`) et les Value ne le sont pas.
- Le document de spécification geul.org `0x00000000/codecs/0x00000C00` (nom `source`) place sur Target le [CODEC](0x0BEL-codec.md) LOCAL (`0050`), et sur Origin les CODEC `000F`·`020F`·`040F` (toute Reference), `0000` (ABSENT, facultatif) et `0010` (UNKNOWN-VALUE).
- L'ordre entre SOURCE de même Target n'a pas de sens. L'ordre des éléments à l'intérieur d'une provenance n'en a pas non plus (l'ordre des valeurs d'une même propriété subsiste comme ordre du document).
- SOURCE ne change pas la vérité ou la fausseté de la cible. Il note seulement d'où elle vient. Le résultat du jugement relève de [TOULMIN](../toulmin/_index.md) `VERDICT`.

## Provenance du document entier {#문서-전체의-출처}

La source du document entier (dump original, édition, fichier de texte original) s'écrit par **un SOURCE de Target `0` dans le HEAD**. Les QUALIFIER dont la Target est ce SOURCE (hachage du texte original P4092, heure de réception P813, étendue du texte original, etc.) se placent aussi dans le HEAD ([document](../document.md#head와-body)).

- Ces deux seuls Edge peuvent figurer dans le HEAD. Tous les autres vont dans le BODY.
- Le QUALIFIER du HEAD se place après le SOURCE du HEAD qu'il désigne. Le décodeur lit depuis le début et sépare ainsi HEAD et BODY.
- Un QUALIFIER dans le BODY dont la Target est un SOURCE du HEAD est invalid. Les SOURCE·QUALIFIER du BODY ne pointent pas vers un Edge du HEAD.
- **L'Edge Id est une seule plage de numéros pour le HEAD et le BODY.** Il est unique dans le document, reçu de [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) comme pour les autres Edge, et à la reconstruction, un contenu identique reprend le même numéro. Dans une version où un Edge du HEAD a disparu, ce numéro n'est pas réutilisé.
- Si Origin est un LOCAL, sa définition (REFERENCE-NODE, TRIPLE de source) se place dans le BODY. La portée d'un LOCAL est le document entier.
- Les Edge du HEAD ne sont pas des Meta de la classe vérification ; ils entrent donc dans le [hachage du contenu](../document.md#내용-해시). Dans un diff, ils changent d'un bloc avec le HEAD (on ne les note pas dans `DELTA-REMOVE`).
- Il n'existe pas de Meta propre à la provenance du document entier. L'étendue du texte original ou l'heure d'acquisition écrites comme Meta ne permettent pas de décider de quelle source il s'agit lorsqu'il y en a plusieurs. Le QUALIFIER attaché à un SOURCE le détermine par sa Target.

Exemple : le HEAD d'un document Q42 transposé d'un dump Wikidata (les Edge Id sont donnés à titre d'explication).

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         édition de l'entité (revision)
#1741 SOURCE     #0     #1740                                         fichier de dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            hachage du fichier
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    heure de réception
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      heure d'enregistrement de l'édition
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  adresse permanente de l'édition
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- L'édition et le dump sont des sources différentes ; on pose donc deux SOURCE. L'édition est la source du contenu (l'adresse permanente permet de recevoir de nouveau le même contenu), et le dump est le fichier dans lequel cette édition a été reçue. Le hachage du fichier et l'heure de réception sont des propriétés du côté citation relatives au fichier de dump ; ils s'attachent donc au SOURCE du dump.

## Expression des autres fondements {#다른-근거의-표현}

La famille fondement ne contient que SOURCE. Les autres fondements s'écrivent par QUALIFIER.

| Fondement | Manière d'écrire | Property |
|---|---|---|
| Étendue dans le texte original | QUALIFIER sur le SOURCE. Un SOURCE par étendue | page P304, section P958, citation P1683. L'étendue en caractères est un terme GEUL (non fixé) |
| Heure de réception du matériau source | QUALIFIER sur le SOURCE | date de consultation P813 |
| Hachage d'octets du texte original (fixation de l'édition) | QUALIFIER sur le SOURCE | somme de contrôle P4092, valeur [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), etc. |
| Agent producteur (personne, modèle, moteur de règles) | QUALIFIER sur le SOURCE (l'agent qui a produit la citation) ou sur la cible | terme GEUL (non fixé) |
| Fiabilité | QUALIFIER sur la cible | terme GEUL (non fixé), valeur de 0 à 1 comme le Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) |
| Période de vigueur par article | QUALIFIER sur la cible | début P580, fin P582 |
| Ancien enregistrement avant déplacement, scission ou fusion | QUALIFIER sur la cible, la valeur est l'ancien Edge Id (LOCAL) | P1365 (replaces) |
| Version d'entrée initiale | Non stockée. Calculée à partir de l'historique des versions (git blame) | |

## Exemple (non normatif) {#예시-비규범}

Q42 P19 (lieu de naissance) Q350, TRIPLE cible `#178`. Dans le dump Wikidata du 2026-10-19, cette proposition a cinq provenances, dont trois sont montrées. ③ l'article du Telegraph (`#1358`~`#1367`) est de même forme que ②, et ⑤ Store norske leksikon (Q746368) de même forme que ① ; ils sont omis.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica : P248 seul, sans description de source
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

- ① n'a pas de description de source et P248 est unique ; la source est donc cet élément. `#1347` fait TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `0C07`.

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- Provenance faite d'une seule URL : `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Provenance avec seulement « imported from » Wikipédia en anglais : `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` fait 1 WORD.

## Problèmes ouverts {#열린-문제}

- Termes GEUL pour exprimer l'étendue en caractères, l'agent producteur et la fiabilité (document de définition des termes et ID).
- Lorsque la description d'une source ne l'identifie pas (provenance avec seulement la langue, etc.), partager cette description par un seul LOCAL reviendrait à affirmer que des sources différentes sont identiques.
- Liste de propriétés de source et de citation pour les provenances hors Wikidata (lois, citations web).
- Provenance de la provenance (chaîne) : faut-il attacher de nouveau un SOURCE au LOCAL de la source.

## Pages liées {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [QUALIFIER](0x0ABL-qualifier.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [marqueur d'emplacement](../slot-marker.md)
- [Document](../document.md) (HEAD et BODY), [Meta — provenance](../meta/_index.md#출처)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000C00/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
