---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta est un enregistrement qui porte non sur le contenu du monde mais sur le document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta est un enregistrement qui porte non sur le contenu du monde mais sur le document. À l'exception des enregistrements de structure du document (DOC, BODY, END), tous se placent dans le HEAD du document. Le HEAD contient aussi, outre les Meta, l'Edge de fondement du document entier [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) et son QUALIFIER.

## Disposition {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      sections 14 et 15 (0x1C0L~0x1FFL)
[TAG d'extension Length]
Payload           Valeur brute ou enregistrement Value ou Reference intégré
```

- Meta n'a pas de format d'Issuer. Meta est une spécification commune que suivent tous les Issuer, et seul GEUL la définit.
- `LLLL` est le nombre total de WORD, TAG WORD compris, moins 1. Un Codec absent du tableau est Reserved.

## Format du Payload {#payload-형식}

| Format | Quand | Exemple |
|---|---|---|
| valeur brute | Quand le format est unique. Ne s'appuie pas sur un autre Codec d'enregistrement | longueur de `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value intégrée | Quand on choisit parmi plusieurs formats. Le TAG de Value indique le format | `PROFILE`, `EFFECTIVE-*`, instants, hachage du contenu |
| Reference intégrée | Quand on désigne un objet tel qu'une personne, une organisation, un outil ou un document | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, signataire de `SIGNATURE` |
| aucun | Marqueur de 1 WORD | `BODY`, `END` |

- Un enregistrement intégré n'est pas un enregistrement indépendant ; il appartient à son Meta. Chacun trouve ses limites par sa propre Length, et la position atteinte après la lecture du dernier enregistrement doit coïncider exactement avec la fin du Meta.
- Les Meta qu'on ne peut placer qu'une fois par document et ceux qu'on peut placer plusieurs fois sont fixés par le « Nombre » de chaque document de Codec.

## Classes {#클래스}

Les numéros de Meta se suivent à partir de `0x1C0L` sans Reserved. Les bits du numéro n'indiquent pas la classe. On connaît la classe par le tableau des intervalles ci-dessous.

| Classe | Code direct | Ce qu'elle traite |
|---|---|---|
| structure | `0x1C0L~0x1C4L` | Limites et longueur du document |
| définition | `0x1C5L~0x1CAL` | Déclarations d'interprétation |
| provenance | `0x1CBL~0x1D0L` | Qui, quand, où |
| lignée | `0x1D1L~0x1DDL` | D'où et comment il provient |
| politique | `0x1DEL~0x1E3L` | Comment on le traite |
| IMPORT | `0x1E4L` | Importe un document externe |
| vérification | `0x1E5L~0x1E9L` | Peut-on s'y fier |
| Reserved (réservé à la vérification) | `0x1EAL~0x1FFL` | |

- La classe vérification est constituée des enregistrements de la section 15 avec `C >= 5`, c'est-à-dire `w >= 0x1E50`. Sans livre de codes, on reconnaît ainsi la classe vérification et on l'exclut du hachage du contenu.
- Le Reserved final `0x1EAL~0x1FFL` est réservé à la vérification. Un nouveau Meta hors vérification ne peut être inséré avant la vérification, et s'il est placé dans le Reserved final, il est exclu du hachage du contenu.
- Les classes structure, définition et IMPORT ne se lisent pas par les bits. Le décodeur les connaît par le tableau de numéros intégré.
- **Meta nécessaires à l'interprétation** : structure, définition, IMPORT. Si on les supprime, on ne peut plus lire les enregistrements ou l'interprétation change. Tous les décodeurs doivent les traiter. Ces Codec appartiennent au **livre de codes noyau de GEUL**.
- **Meta qui ne changent pas l'interprétation** : provenance, lignée, vérification, politique. Même supprimés, le contenu des énoncés reste le même. Seuls disparaissent les éléments du jugement de confiance et du traitement.
- Le fondement s'écrit non par un Meta mais par l'Edge de fondement [SOURCE](../edge/0x0C0L-source.md) et son QUALIFIER. Le fondement d'un enregistrement donné va dans le BODY ; l'origine du document entier va dans le HEAD, sous forme d'un SOURCE de Target `0` ([document](../document.md#head와-body)).

## Structure {#구조}

La classe structure de Meta (Codec `0x1C0L~0x1C4L`) fixe les limites et la longueur du document. L'unité des données GEUL est un document.

```
DOC-*                  ← début du HEAD
  Meta de définition, provenance, lignée, vérification, politique, IMPORT
  SOURCE du document entier et son QUALIFIER
BODY                   ← début du BODY
  Reference, Value, Edge
END                    ← ferme le document
```

- Tout document s'ouvre par `DOC-1WORD/2WORD/4WORD`, qui indique la longueur totale. Le décodeur peut sauter tout le document d'un coup grâce à cette longueur.
- `BODY` et `END` sont des enregistrements de 1 WORD sans Payload. `END` est obligatoire.
- Les documents ne s'imbriquent pas. Un autre document se désigne par IMPORT.
- Si le HEAD (Meta, SOURCE du document entier et son QUALIFIER) est vide, on omet `BODY`. `BODY` ne peut être placé qu'une fois par document.

La structure complète du document figure dans [document](../document.md).

| Codec | Nom | Sens |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | Ouvre le document en indiquant sa longueur totale |
| `0x1C3L` | [BODY](0x1C3L-body.md) | Termine le HEAD et ouvre le BODY |
| `0x1C4L` | [END](0x1C4L-end.md) | Ferme le document |

Les règles détaillées figurent dans [document](../document.md).

## Définition {#정의}

La classe définition de Meta (Codec `0x1C5L~0x1CAL`) regroupe les déclarations d'interprétation. Une déclaration change les règles d'interprétation, donc tous les décodeurs doivent la traiter. La portée d'une déclaration est son document.

- `SPEC-VERSION` détermine comment lire les autres enregistrements ; on y place donc un simple entier, sans Value intégrée. GEUL v1 est `0x0001` (enregistrement `1C51 0001`).
- `DOC-ID` est le `DOC-POINTER` (Issuer, ID de document, version `0`) qui désigne le document lui-même. Pour un document de codec, c'est le `CODEC-POINTER` (Issuer, Codec ID, version `0`). En son absence, le document est anonyme et ne peut être désigné que par le hachage de son contenu.
- Il n'existe pas d'adresse par nom de document. Le titre lisible par l'humain s'attache par le `LABEL` d'énoncé ([adresses de publication et liste des versions](../publishing.md#문서-이름)).

| Codec | Nom | Sens |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | Version de la spécification suivie. Un seul entier |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | Profil appliqué |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | Identifiant de ce document. DOC-POINTER (version 0) qui se désigne lui-même. CODEC-POINTER (version 0) pour un document de codec |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | Date d'entrée en vigueur de cette version. En son absence, l'instant de publication |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | Fin de la période de validité de cette version (loi temporaire). En son absence, jusqu'à l'entrée en vigueur de la version suivante |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | Langue par défaut |

- Il n'existe pas d'adresse par nom de document ([adresses de publication et liste des versions](../publishing.md#문서-이름)). Le titre lisible par l'humain s'attache par un LABEL du BODY.

## Provenance {#출처}

La classe provenance de Meta (Codec `0x1CBL~0x1D0L`) consigne qui a créé et consigné le document, et quand.

- L'auteur, le responsable de l'enregistrement et leurs instants suivent le modèle author et committer de git (`AUTHOR` et `CREATED-AT`, `RECORDED-BY` et `RECORDED-AT`).
- Même supprimée, la provenance ne change pas le contenu des énoncés. Seuls disparaissent les éléments du jugement de confiance.
- Les sources ne figurent pas dans cette classe. L'origine du document entier s'écrit dans le HEAD, celle d'un enregistrement donné dans le BODY, par l'Edge de fondement [SOURCE](../edge/0x0C0L-source.md). La portée correspondante dans le texte original, l'instant d'acquisition et le hachage du texte original sont des QUALIFIER joints à ce SOURCE (page P304, section P958, date de consultation P813, somme de contrôle P4092).
- Si l'on faisait des propriétés propres à une source (portée dans le texte original, instant d'acquisition) des Meta, on ne pourrait déterminer de quelle source elles relèvent quand il y en a plusieurs. On les écrit donc comme QUALIFIER ayant le SOURCE pour Target.

| Codec | Nom | Sens |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | Auteur (Reference) |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | Coauteur |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | Instant de rédaction |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | Instant de modification |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | Entité qui a consigné |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | Instant de consignation |

- Les sources s'écrivent non par un Meta mais par l'Edge de fondement [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) du HEAD (Target `0`), et la portée dans le texte original, l'instant d'acquisition et le hachage du texte original s'écrivent comme QUALIFIER joints à ce SOURCE.

## Lignée {#계보}

La classe lignée de Meta (Codec `0x1D1L~0x1DDL`) consigne d'où et comment provient le document. La lignée suit le modèle de commit de git, l'unité correspondant au commit étant le document.

- Le **hachage du contenu** désigne le contenu d'un exemplaire du document (git commit id). C'est le SHA-256 allant de l'enregistrement d'ouverture (`DOC-*`) jusque juste avant `END` ; les enregistrements de la classe vérification (section 15 avec `C >= 5`, `w >= 0x1E50`) sont exclus du calcul.
- L'**ID de version** est un entier de 2 WORD numéroté à partir de 1 dans l'ordre de publication au sein d'un document nommé. `0` signifie que la version n'est pas indiquée.
- Les Meta de lignée désignent une version par son hachage du contenu. Le `PARENT` du document entrant lui aussi dans le hachage, le hachage du contenu forme une chaîne de hachages qui relie tout l'historique.
- L'historique n'est pas effacé. Le contenu corrigé est publié comme nouvelle version. Un pointeur qui change, comme une branche, n'est pas placé dans le document.
- `DELTA-BASE` et `DELTA-REMOVE` sont le format qui stocke une version comme diff par rapport à une version de base. Une version est toujours définie comme un instantané.

Les règles de révision figurent dans [document](../document.md).

La lignée suit le modèle de commit de git. L'unité correspondant au commit est le document.

| Codec | Nom | Sens |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | Hachage du contenu de la version précédente. S'il y en a plusieurs, fusion |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | Dérivé de matériaux d'une autre lignée |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | Entité génératrice (personne, modèle, moteur de règles) |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | Outil de conversion et version de sa source (condensat de commit) |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | Version d'origine du changement repris |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | Version annulée |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | Version remplacée par une réécriture. La version d'origine n'est pas effacée |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | Versions d'origine fusionnées en une seule |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | Raison du changement. Un par langue |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | Nom immuable attribué à une version |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | Ce fichier est un diff par rapport à une version de base |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | Liste des LOCAL ID à retirer dans le diff |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | LOCAL ID à attribuer ensuite. Placé dans le document de liste des versions |

- L'historique n'est pas effacé. Le contenu corrigé est publié comme nouvelle version.
- Un pointeur qui change, comme une branche, n'est pas placé dans le document. Le dépôt et l'index le gèrent.

## Vérification {#검증}

La classe vérification de Meta (Codec `0x1E5L~0x1E9L`) consigne les éléments permettant de juger si l'on peut se fier au document : clé publique d'un Issuer à émission autonome, signature, confirmation du droit de contribuer, degré de confiance, résultat du verdict sur le document entier.

- La classe vérification est exclue du calcul du hachage du contenu. Ainsi, qu'on place la signature dans le document ou qu'on en ajoute plusieurs, le hachage du contenu ne change pas (même principe que le `gpgsig` de git).
- Comme la classe vérification est constituée des enregistrements de la section 15 avec `C >= 5`, c'est-à-dire `w >= 0x1E50`, on peut calculer le hachage sans livre de codes. Le Reserved final `0x1EAL~0x1FFL` est lui aussi réservé à la vérification et exclu du hachage.
- Le verdict au niveau du nœud ou de l'enregistrement relève de l'Edge `VERDICT` (`0x118L`) de [TOULMIN](../toulmin/_index.md).

| Codec | Nom | Sens |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | Algorithme de signature et clé publique d'un Issuer à émission autonome |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | Signature du hachage du contenu. Algorithme, signataire, signature |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | Confirmation du droit de contribuer |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | Degré de confiance |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | Résultat du verdict sur le document entier (Pass, Review, Fail) |

- La classe vérification est exclue du calcul du hachage du contenu. Ainsi, qu'on place la signature dans le document ou qu'on en ajoute plusieurs, le hachage du contenu ne change pas.

## Politique {#정책}

La classe politique de Meta (Codec `0x1DEL~0x1E3L`) fixe comment le document est traité : licence, étendue de diffusion, niveau de données personnelles, durée de conservation, consentement, restrictions d'usage.

- La politique ne change pas l'interprétation ; elle fixe la manière de traiter.
- La licence d'origine de l'œuvre contenue dans la suite d'octets est consignée par `LICENSE`.

| Codec | Nom | Sens |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | Licence |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | Étendue de diffusion |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | Niveau de données personnelles |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | Durée de conservation |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | Étendue du consentement et fondement |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | Restrictions d'usage |

- La politique ne change pas l'interprétation ; elle fixe la manière de traiter.

## IMPORT {#import}

La classe IMPORT de Meta (Codec `0x1E4L`) importe un document externe au moyen d'un IMPORT ID. Il n'y a qu'un Codec : `IMPORT-DOC` (`0x1E4L`).

- IMPORT n'importe que des documents. Les objets du document importé se désignent dans le BODY par la Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) ([Reference](../reference/_index.md)).
- Si l'on indique un ID de version, la liaison se fait à cette édition ; avec `0`, à la dernière édition au moment de l'interprétation. Un document publié indique la version.
- Le HEAD du document importé n'est pas importé. Les enregistrements Reference et Value ne sont pas importés mais copiés.

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[TAG d'extension Length]
Document          Enregistrement DOC-POINTER (Issuer, ID de document, ID de version). CODEC-POINTER pour un document de codec
IMPORT ID         Le reste. Entier de la largeur la plus courte
```

- On n'emploie que [IMPORT-DOC](0x1E4L-import-doc.md) (`0x1E4L`). IMPORT n'importe que des documents. Les objets du document importé se désignent dans le BODY par `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID).
- Si l'on indique un ID de version, la liaison se fait à cette édition ; avec `0`, à la dernière édition au moment de l'interprétation. Un document publié indique la version.
- Dans un même document, on n'attribue pas deux fois le même IMPORT ID.
- Le HEAD du document importé n'est pas importé. Les objets de ce document s'interprètent selon les déclarations de ce document.

Exemple : on importe, avec l'IMPORT ID 1, la dernière version du document `0x0000000000000002` de l'Issuer `0x00000002`.

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
