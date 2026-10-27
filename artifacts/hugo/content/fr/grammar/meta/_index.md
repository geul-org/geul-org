---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta est un enregistrement portant sur le document, non sur le monde. Il se divise en sept classes (structure, définition, source, lignée, vérification, politique, IMPORT) et se place dans le HEAD du document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta est un enregistrement qui porte sur le document, non sur un contenu relatif au monde. À l'exception des enregistrements de structure du document (DOC, BODY, END), tous se placent dans le HEAD du document. Le HEAD contient, outre les Meta, l'Edge de fondement [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du document entier et ses QUALIFIER.

## Disposition

```
TAG WORD          0001 1LLL LCCC CCCC
[TAG d'extension de Length]
Payload           valeur brute, ou enregistrements Value ou Reference intégrés
```

- Meta n'a pas de format d'Issuer. Meta est une spécification commune que suivent tous les Issuer, définie par GEUL seul.
- `LLLL` est le nombre total de WORD, TAG WORD compris, moins 1. Les Codec absents du tableau sont réservés.

## Format du Payload

| Format | Quand | Exemple |
|---|---|---|
| Valeur brute | Quand le format est unique. Ne s'appuie pas sur le Codec d'un autre enregistrement | Longueur de `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value intégrée | Quand il faut choisir entre plusieurs formats. Le TAG de la Value indique le format | `PROFILE`, `EFFECTIVE-*`, instants, hachage du contenu |
| Reference intégrée | Quand on désigne une personne, une organisation, un outil ou un document | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, le signataire de `SIGNATURE` |
| Aucun | Marqueur de 1 WORD | `BODY`, `END` |

- Un enregistrement intégré n'est pas un enregistrement indépendant mais appartient à son Meta. Chacun trouve ses limites par sa Length, et la position atteinte après lecture du dernier enregistrement doit coïncider exactement avec la fin du Meta.
- Les Meta qu'on ne peut placer qu'une fois par document et ceux qu'on peut placer plusieurs fois sont fixés par le « Nombre » du document de chaque Codec.

## Classes

Les 3 bits de poids fort du Codec forment la classe.

| 3 bits de poids fort | Classe | Code direct | Objet |
|---|---|---|---|
| `000` | Structure | `0x00`~`0x0F` | Limites et longueur du document |
| `001` | Définition | `0x10`~`0x1F` | Déclarations d'interprétation |
| `010` | Source | `0x20`~`0x2F` | Qui, quand, où |
| `011` | Lignée | `0x30`~`0x3F` | D'où cela provient et comment |
| `100` | Vérification | `0x40`~`0x4F` | Est-ce digne de confiance |
| `101` | Politique | `0x50`~`0x5F` | Comment cela se traite |
| `110` | IMPORT | `0x60`~`0x6F` | Importe un document externe |
| `111` | Réservé | `0x70`~`0x7F` | |

- **Meta nécessaires à l'interprétation** : structure, définition, IMPORT. Si on les efface, on ne peut plus lire les enregistrements ou l'interprétation change. Tout décodeur doit les traiter. Ces Codec appartiennent au **livre de codes central de GEUL**.
- **Meta qui ne changent pas l'interprétation** : source, lignée, vérification, politique. Si on les efface, le contenu décrit reste intact. Seuls disparaissent les éléments du jugement de confiance et de la manière de traiter.
- Les fondements s'écrivent non par Meta mais par l'Edge de fondement [SOURCE](/fr/grammar/edge/source/) et les QUALIFIER. Le fondement d'un enregistrement individuel va dans le BODY, l'origine du document entier dans le HEAD par un SOURCE de Target `0` ([Document](/fr/grammar/document/#head-et-body)).

## Structure

Document de groupe : [Meta — Structure](/fr/grammar/meta/structure/)

| Codec | Nom | Sens |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/fr/grammar/meta/structure/doc/) | Ouvre le document en indiquant sa longueur totale |
| `0x0E` | [BODY](/fr/grammar/meta/structure/body/) | Termine le HEAD et ouvre le BODY |
| `0x0F` | [END](/fr/grammar/meta/structure/end/) | Ferme le document |

Les règles détaillées se trouvent dans [Document](/fr/grammar/document/).

## Définition

Document de groupe : [Meta — Définition](/fr/grammar/meta/declaration/)

| Codec | Nom | Sens |
|---|---|---|
| `0x10` | [SPEC-VERSION](/fr/grammar/meta/declaration/spec-version/) | Édition de la spécification suivie. Un seul entier |
| `0x11` | [PROFILE](/fr/grammar/meta/declaration/profile/) | Profil appliqué |
| `0x12` | [DOC-ID](/fr/grammar/meta/declaration/doc-id/) | Identifiant de ce document. DOC-POINTER qui le désigne lui-même (version 0) |
| `0x13` | [EFFECTIVE-FROM](/fr/grammar/meta/declaration/effective-from/) | Date d'entrée en vigueur de cette version. À défaut, l'instant de publication |
| `0x14` | [EFFECTIVE-UNTIL](/fr/grammar/meta/declaration/effective-until/) | Fin de validité de cette version (loi temporaire). À défaut, jusqu'à l'entrée en vigueur de la version suivante |
| `0x16` | [DEFAULT-LANGUAGE](/fr/grammar/meta/declaration/default-language/) | Langue par défaut |

- Le nom du document servant d'adresse ne se place pas en Meta. C'est l'index des noms de l'Issuer `documents.geul` qui l'attache par BIND ([Adresse de publication et liste des versions](/fr/grammar/publishing/#nom-du-document)). Le titre lisible par l'humain s'attache par LABEL dans le BODY.

## Source

Document de groupe : [Meta — Source](/fr/grammar/meta/provenance/)

| Codec | Nom | Sens |
|---|---|---|
| `0x20` | [AUTHOR](/fr/grammar/meta/provenance/author/) | Auteur (Reference) |
| `0x21` | [CO-AUTHOR](/fr/grammar/meta/provenance/co-author/) | Co-auteur |
| `0x22` | [CREATED-AT](/fr/grammar/meta/provenance/created-at/) | Instant de création |
| `0x23` | [MODIFIED-AT](/fr/grammar/meta/provenance/modified-at/) | Instant de modification |
| `0x24` | [RECORDED-BY](/fr/grammar/meta/provenance/recorded-by/) | Entité qui a enregistré |
| `0x25` | [RECORDED-AT](/fr/grammar/meta/provenance/recorded-at/) | Instant d'enregistrement |
| `0x26`~`0x2F` | Reserved | |

- Le document d'origine s'écrit non par Meta mais par l'Edge de fondement [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du HEAD (Target `0`), et l'étendue dans le texte d'origine, l'instant d'acquisition et le hachage du texte d'origine par des QUALIFIER joints à ce SOURCE.

## Lignée

Document de groupe : [Meta — Lignée](/fr/grammar/meta/lineage/)

La lignée suit le modèle des commits de git. L'unité correspondant à un commit est le document.

| Codec | Nom | Sens |
|---|---|---|
| `0x30` | [PARENT](/fr/grammar/meta/lineage/parent/) | Hachage du contenu de la version précédente. Plusieurs : fusion |
| `0x31` | [DERIVED-FROM](/fr/grammar/meta/lineage/derived-from/) | Dérivé de documents d'une autre lignée |
| `0x32` | [GENERATED-BY](/fr/grammar/meta/lineage/generated-by/) | Entité génératrice (personne, modèle, moteur de règles) |
| `0x33` | [TRANSFORMED-BY](/fr/grammar/meta/lineage/transformed-by/) | Outil de transformation et version de sa source (digest de commit) |
| `0x34` | [CHERRY-PICKED-FROM](/fr/grammar/meta/lineage/cherry-picked-from/) | Version d'origine de la modification reprise |
| `0x35` | [REVERTS](/fr/grammar/meta/lineage/reverts/) | Version dont la modification est annulée |
| `0x36` | [REPLACES](/fr/grammar/meta/lineage/replaces/) | Version réécrite. La version d'origine n'est pas effacée |
| `0x37` | [SQUASHED-FROM](/fr/grammar/meta/lineage/squashed-from/) | Versions d'origine fusionnées en une |
| `0x38` | [MESSAGE](/fr/grammar/meta/lineage/message/) | Raison de la modification. Une par langue |
| `0x39` | [TAG](/fr/grammar/meta/lineage/tag/) | Nom immuable attaché à une version |
| `0x3A` | [DELTA-BASE](/fr/grammar/meta/lineage/delta-base/) | Ce fichier est un diff par rapport à une version de base |
| `0x3B` | [DELTA-REMOVE](/fr/grammar/meta/lineage/delta-remove/) | Liste des LOCAL ID à retirer dans un diff |
| `0x3C` | [NEXT-LOCAL-ID](/fr/grammar/meta/lineage/next-local-id/) | Prochain LOCAL ID à attribuer. Placé dans le document de liste des versions |

- L'historique ne s'efface pas. Une correction paraît comme une nouvelle version.
- Les pointeurs mobiles comme branch ne se placent pas dans le document. Le dépôt et l'index les gèrent.

## Vérification

Document de groupe : [Meta — Vérification](/fr/grammar/meta/verification/)

| Codec | Nom | Sens |
|---|---|---|
| `0x40` | [ISSUER-KEY](/fr/grammar/meta/verification/issuer-key/) | Algorithme de signature et clé publique d'un Issuer auto-émis |
| `0x41` | [SIGNATURE](/fr/grammar/meta/verification/signature/) | Signature du hachage du contenu. Algorithme, signataire, signature |
| `0x42` | [SIGNED-OFF](/fr/grammar/meta/verification/signed-off/) | Confirmation du droit de contribuer |
| `0x43` | [CONFIDENCE](/fr/grammar/meta/verification/confidence/) | Degré de confiance |
| `0x44` | [VERDICT](/fr/grammar/meta/verification/verdict/) | Résultat de jugement du document entier (Pass, Review, Fail) |

- La classe de vérification est exclue du calcul du hachage du contenu. Placer la signature dans le document, ou en ajouter plusieurs, ne change donc pas le hachage du contenu.

## Politique

Document de groupe : [Meta — Politique](/fr/grammar/meta/policy/)

| Codec | Nom | Sens |
|---|---|---|
| `0x50` | [LICENSE](/fr/grammar/meta/policy/license/) | Licence |
| `0x51` | [ACCESS](/fr/grammar/meta/policy/access/) | Étendue de diffusion |
| `0x52` | [PRIVACY](/fr/grammar/meta/policy/privacy/) | Niveau de données personnelles |
| `0x53` | [RETENTION](/fr/grammar/meta/policy/retention/) | Durée de conservation |
| `0x54` | [CONSENT](/fr/grammar/meta/policy/consent/) | Étendue et fondement du consentement |
| `0x55` | [USAGE](/fr/grammar/meta/policy/usage/) | Restrictions d'usage |

- La politique ne change pas l'interprétation, elle fixe la manière de traiter.

## IMPORT

Document de groupe : [Meta — IMPORT](/fr/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[TAG d'extension de Length]
Document          enregistrement DOC-POINTER (Issuer, ID de document, ID de version)
IMPORT ID         le reste. Entier sur la largeur la plus courte
```

- On n'emploie que [IMPORT-DOC](/fr/grammar/meta/import/import-doc/) (`0x60`). IMPORT n'importe que des documents. Une cible d'un document importé se désigne dans le BODY par `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID).
- Avec un ID de version, on est lié à cette édition ; avec `0`, à la dernière édition au moment de l'interprétation. Les documents publiés indiquent la version.
- Dans un document, on n'attribue pas deux fois le même IMPORT ID.
- Le HEAD du document importé n'est pas importé. Les cibles de ce document s'interprètent selon les déclarations de ce document.

Exemple : de l'Issuer `0x0001`, importer la dernière version du document `0x0000000000000002` avec l'IMPORT ID 1.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
