---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference est un enregistrement qui désigne une cible. Un Codec sur 4 bits fixe le système d'identification (LOCAL, Wikidata, document externe, etc.) et un Quantifier sur 3 bits la quantification (identifié, générique, universel, variable, etc.). Le Codec réservé 0000 est le lot des marqueurs d'emplacement."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference est un enregistrement qui désigne une cible. La cible peut être une entité, un concept, un document ou un autre Edge. On désigne par ID, non par nom.

## Disposition

```
TAG WORD          0000 0LLL LCCC CQQQ
[TAG d'extension de Length]
[IMPORT ID]       pour EXTERNAL-POINTER (1/2/4/8 WORD)
[Issuer]          pour EXTERNAL-ISSUER (1/2/4/16 WORD)
[ID de document]  pour EXTERNAL-ISSUER (4 WORD)
ID de cible       tout le reste
```

- `LLLL` est le nombre total de WORD, TAG WORD compris, moins 1 ([Enregistrement et TAG WORD](/fr/grammar/record/)).
- Le Codec fait 4 bits `CCCC`, le Quantifier 3 bits `QQQ`. Les 7 bits de poids faible du TAG WORD valent `CCCC << 3 | QQQ`.
- L'ID de cible est un entier non signé big-endian écrit sur la **largeur la plus courte**. La largeur est ce qui reste de la Length après les champs précédents.
- L'ID de cible `0` s'écrit en 1 WORD `0x0000`. Dans les autres cas, on ne place pas de WORD `0x0000` en tête.
- Deux ID de même valeur entière sont le même ID. La largeur ne fait pas partie de l'ID.
- Tous les Codec emploient la largeur la plus courte. Aucun Codec ne fixe la largeur de l'ID de cible.
- [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/) et [DOC-POINTER](/fr/grammar/reference/doc-pointer/) ne suivent pas cette disposition. Ils n'ont pas d'ID de cible, seulement l'Issuer (et l'ID de document et l'ID de version).

## Codec (`CCCC`)

| CCCC | Nom | Catégorie | Cible |
|---|---|---|---|
| `0000` | [Marqueur d'emplacement](/fr/grammar/reference/slot-marker/) | Réservé | Ne désigne aucune cible. On n'emploie que des marqueurs de 1 WORD dont les 3 bits de poids faible forment le numéro du marqueur : `0x0000` ABSENT (non renseigné), `0x0001` UNKNOWN-VALUE (inconnu), `0x0002` NO-VALUE (aucune valeur) |
| `0001` | [LOCAL](/fr/grammar/reference/local/) | Déclaration | ID émis par ce document |
| `0010` | [GEUL](/fr/grammar/reference/geul/) | Déclaration | Entité émise par geul.org |
| `0011` | [GEUL-SIDX](/fr/grammar/reference/geul-sidx/) | Déclaration | Identifiant aligné sur le sens, dont les bits portent du sens |
| `0100` | [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) | Déclaration | Élément Wikidata. Entier qui suit `Q` |
| `0101` | [WIKIDATA-PID](/fr/grammar/reference/wikidata-pid/) | Déclaration | Propriété Wikidata. Entier qui suit `P` |
| `0110` | [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/) | Pointeur-déclaration | L'Issuer lui-même |
| `0111` | [DOC-POINTER](/fr/grammar/reference/doc-pointer/) | Pointeur-déclaration | Une version d'un document publié par un Issuer |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/fr/grammar/reference/external-pointer/) | Pointeur | LOCAL ID d'un document importé par IMPORT |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/fr/grammar/reference/external-issuer/) | Pointeur-déclaration | LOCAL ID d'un document publié par un Issuer |

- Une **déclaration** identifie directement une cible par un ID fixé par l'entité émettrice.
- Un **pointeur** désigne un LOCAL d'un document importé par IMPORT ID. Les 2 bits de poids faible donnent la largeur de l'IMPORT ID (`00`=1, `01`=2, `10`=4, `11`=8 WORD).
- Un **pointeur-déclaration** désigne, en un seul enregistrement et sans IMPORT, un autre document et une cible qu'il contient.
- Si le bit de poids fort vaut `0`, la cible est identifiée directement (LOCAL de ce document, ID émis, Issuer ou document lui-même) ; s'il vaut `1`, on désigne un LOCAL d'un autre document.
- Le Codec `0000` est réservé et ne s'emploie pas comme Reference désignant une cible. L'exception est un seul lot : les WORD `0x0000`~`0x0007` (Codec `0000`, 1 WORD) sont des [marqueurs d'emplacement](/fr/grammar/reference/slot-marker/). On en emploie trois pour l'instant (`0x0000` ABSENT, `0x0001` UNKNOWN-VALUE, `0x0002` NO-VALUE). Un marqueur n'est valide qu'à la place d'un champ d'enregistrement dont la liste CODEC comprend exactement ce WORD. Les jokers et les champs sans CODEC n'en reçoivent pas, et sur une place d'enregistrement du HEAD ou du BODY et sur une place d'Edge Id, il est invalid. `0x0003`~`0x0007` et le Codec `0000` avec un Payload sont réservés.
- Les systèmes d'identification qui ne sont pas en CC0 (WordNet, etc.) ne se placent pas en Codec de Reference. Reference n'a pas non plus de code ISSUER, donc pas d'endroit où les transposer en format d'Issuer.

### TAG fréquents

| Enregistrement | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Q5 de Wikidata (être humain) | `00A0 0005` |
| Q691283 de Wikidata | `0120 000a 8c53` |
| P31 de Wikidata (instance of) | `00A8 001f` |
| Marqueurs d'emplacement ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL est un ID émis par ce document. Il n'a de sens qu'à l'intérieur du document.

- **Il est unique.** Dans un document, un LOCAL ID ne désigne qu'une seule cible.
- **0 n'est pas attribué.** Les ID de cible sont attribués à partir de 1.
- **On recommande d'attribuer en croissant** (auto increment). Le grand ou le petit d'un ID n'a pas de sens.
- Il désigne la même cible d'une version à l'autre. Un ID supprimé n'est pas réutilisé ([Document](/fr/grammar/document/), révision).
- Pour désigner depuis l'extérieur du document, il faut que le document ait un `DOC-ID`.
- Deux LOCAL ID différents ne signifient pas que ce sont des cibles différentes dans la réalité. Si elles sont identiques, on les relie par un Edge `SAME-NODE`, si elles sont différentes, par un Edge `DIFFERENT-NODE`.

### Edge Id

Tout Edge place une Reference LOCAL comme premier élément de son Payload. Ce LOCAL ID est l'**Edge Id**.

- On peut lire l'Edge Id sans connaître le livre de codes.
- Un LOCAL à la place de l'Edge Id est une déclaration, un LOCAL à une autre place de l'Edge est une mention.
- Le Quantifier du LOCAL qui déclare un Edge Id est toujours `000`.
- Un autre Edge se désigne par son Edge Id. Les Edge de ce document par LOCAL, ceux d'un autre document par une Reference de pointeur.

## Désigner un autre document

| Quoi | Comment |
|---|---|
| L'Issuer lui-même | `ISSUER-POINTER` (Issuer) |
| Une version d'un document | `DOC-POINTER` (Issuer, ID de document sur 4 WORD, ID de version sur 2 WORD). La version `0` est la dernière |
| Une cible dans un document publié (dernière) | `EXTERNAL-ISSUER-*` (Issuer, ID de document, LOCAL ID) |
| Une cible dans un document importé (édition figée) | On attribue un IMPORT ID par le Meta `IMPORT-DOC`, puis `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- Le document lui-même, qu'on soit à l'intérieur ou à l'extérieur, se désigne par un seul DOC-POINTER. Il se désigne lui-même par le DOC-POINTER de son `DOC-ID`.
- EXTERNAL-ISSUER suit la dernière version. Pour figer l'édition, on emploie IMPORT.
- L'Issuer s'écrit sur la largeur la plus courte qui contienne la valeur (1/2/4/16 WORD), et l'on choisit le Codec correspondant à cette largeur.
- L'ID de document `0` de chaque Issuer est réservé au document d'index des termes (outils, rôles, etc.) définis par cet Issuer. Le document d'index est recommandé à tous les Issuer et n'est pas obligatoire ([Issuer et publication](/fr/grammar/issuer/#document-de-définition-de-terme)).

Exemple : LOCAL 7 dans le document de l'Issuer `0x0001`, d'ID `0x0000000000000002`

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | Nom | Sens | Exemple |
|---|---|---|---|
| `000` | Identified | Individu identifié | Elon Musk, la France |
| `001` | Generic | Énoncé général sur toute une espèce. Admet des exceptions | Le soldat obéit aux ordres |
| `010` | Free-choice | N'importe quelle cible satisfaisant la condition | N'importe quel soldat |
| `011` | Universal | Toutes les cibles dans l'étendue | Tous les soldats |
| `100` | Variable | Variable de discours | cette personne, cette femme |
| `101`~`111` | Réservé | | |

- **Exception : avec le Codec `0000` (marqueur d'emplacement), les 3 bits de poids faible ne sont pas un Quantifier mais le numéro du marqueur.** Le numéro du marqueur n'a pas de lien avec le sens du Quantifier (`0x0001` UNKNOWN-VALUE n'est pas Generic). Les Quantifier de ce tableau ne s'appliquent qu'aux Codec `0001`~`1111`.
- Generic ne signifie pas, contrairement à Universal, que cela s'applique sans exception à toute cible individuelle. Une expression définitoire comme « qu'est-ce qu'un soldat ? » peut s'écrire en Generic. Si une définition rigoureuse de concept ou de classification est nécessaire, on la précise par une relation à part.
- L'étendue d'application et la négation d'une quantification sont fixées non par Reference mais par l'Edge qui l'emploie.
- **Variable** est une cible du discours dont on connaît l'espèce mais qui n'est pas encore identifiée.
  - Une variable nommée place Variable sur un LOCAL. Un même LOCAL ID est la même variable. L'espèce se relie par un Edge.
  - Une variable anonyme place Variable sur un Codec de déclaration qui désigne l'espèce (GEUL, WIKIDATA-*) (par ex. « président » de Wikidata + Variable). On ne suit pas la coréférence et l'on ne peut plus la désigner à nouveau. Deux variables anonymes ne sont pas considérées comme la même variable.
  - Quand la cible est confirmée plus tard, on relie la variable à cette cible par `SAME-NODE`. Toutes les expressions qui désignent la même variable s'interprètent alors ensemble comme cette cible.
  - Même deux variables distinctes ne signifient pas que les cibles réelles sont différentes. Si elles sont identiques, `SAME-NODE`, si elles sont différentes, `DIFFERENT-NODE`.
  - Une variable n'est valide qu'à l'intérieur de ce document et ne s'emploie pas comme identifiant permanent.
  - Une Variable des Codec de pointeur externe (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) est une variable LOCAL du document désigné.
  - Exemple : dans « le président a prononcé un discours », si la personne n'est pas déterminée, on emploie Variable « président ». Pour y revenir, on place une Variable LOCAL et l'on relie l'espèce « président » par un Edge. Si l'on confirme plus tard qu'il s'agit d'Obama, on relie cette variable à Obama Identified par `SAME-NODE`. Toutes les expressions qui désignent la même variable s'interprètent ensemble comme Obama.
- Exemple : Q5 de Wikidata (être humain) en Generic donne `00A1 0005` (« l'être humain … »).
