---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION et TOMBSTONE sont des Edge de description qui consignent la publication, la recommandation d'abandon et la suppression d'une version de document, et cette page fixe aussi la spécification du document de liste des versions écrit avec ces Edge (Codec 0x18~0x1A)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge de description qui consignent la publication, la dépréciation (deprecate) et la suppression d'un document, et spécification du document de liste des versions écrit avec ces Edge. Elle fixe le format de la liste des versions de [Adresse de publication et liste des versions](/fr/grammar/publishing/#liste-des-versions).

## Codes

| Codec | Nom | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, hachage du contenu |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, catégorie de motif |

- Ces trois codes sont intégrés au décodeur ([couche 0](/fr/grammar/publishing/#couches)). La liste des versions s'interprète sans consulter de livre de codes.
- Il n'y a pas de sous-format (TAG propres au Codec). On respecte telle quelle la règle d'[Edge](/fr/grammar/edge/) selon laquelle le premier élément du Payload est l'Edge Id.

## Disposition

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Document          enregistrement Reference DOC-POINTER (Issuer, ID de document, ID de version)
Hachage du contenu  16 WORD   (PUBLICATION)
Catégorie de motif  1 WORD    (TOMBSTONE)
```

| Champ | Largeur | Description |
|---|---|---|
| Edge Id | Enregistrement Reference LOCAL | Numéro d'ordre dans la liste. Numéroté à partir de 1 et ajouté à la suite |
| Document | Enregistrement DOC-POINTER | Une version du document publié ([DOC-POINTER](/fr/grammar/reference/doc-pointer/)). L'Issuer et l'ID de document sont ceux du document dont traite cette liste. Cela permet au document de liste de dire de quoi il est la liste même sans chemin. L'ID de version est le numéro d'ordre dans ce document ([Document](/fr/grammar/document/), versions), et `0` (dernière) n'est pas employé |
| Hachage du contenu | 16 WORD | Hachage du contenu de cette version (SHA-256, hachage du contenu de [Document](/fr/grammar/document/)) |
| Catégorie de motif | 1 WORD | Code de la catégorie du motif de suppression. La table des codes est un problème ouvert |

- La longueur après le DOC-POINTER est fixe pour chaque code (16, 0, 1 WORD). Sinon, on rejette.
- On ne met pas d'instant dans l'enregistrement. Le `RECORDED-AT` du document de liste où l'enregistrement figure pour la première fois est l'instant de publication, de dépréciation ou de suppression.

## Document de liste des versions

L'éditeur tient en ajout continu, pour chaque document, un document de liste des versions : `/<Issuer>/<ID de document>/versions.geul`. Toutes les versions de ce document publiées par cet éditeur entrent dans une seule liste.

```
DOC-1WORD/2WORD/4WORD     longueur totale
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value SHA-256-DIGEST. Hachage du contenu du document de liste précédent (absent pour la première liste)
  RECORDED-AT             Value POSIX-TIMESTAMP-SECONDS. Instant où cette liste a été émise
  NEXT-LOCAL-ID           prochain LOCAL ID à attribuer (s'il y a des versions)
  SIGNATURE               signature de l'éditeur. Objet : hachage du contenu de ce document de liste
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- Meta du HEAD : [SPEC-VERSION](/fr/grammar/meta/declaration/spec-version/), [PARENT](/fr/grammar/meta/lineage/parent/), [RECORDED-AT](/fr/grammar/meta/provenance/recorded-at/), [NEXT-LOCAL-ID](/fr/grammar/meta/lineage/next-local-id/), [SIGNATURE](/fr/grammar/meta/verification/signature/).
- Le document de liste n'a pas de `DOC-ID` (exception pour un document dont le nom ne commence pas par `0x`, [DOC-ID](/fr/grammar/meta/declaration/doc-id/)). La liste n'est pas un document publié mais un registre attaché à ce document. De quel document c'est la liste, c'est l'ID de document des enregistrements qui le dit. On sait donc de quoi c'est la liste même si on la reçoit sans chemin (`h/`, dump).
- L'ID de document des enregistrements doit toujours être celui du document dont traite la liste. On rejette les enregistrements d'un autre document.
- Le document de liste n'a pas d'IMPORT et n'emploie que des Codec de la couche 0. Il ne se place pas dans une autre liste (pas de liste de listes).
- Le nouveau document de liste garde en tête le BODY du précédent tel quel et y ajoute des enregistrements. On ne corrige, n'efface ni ne réordonne.
- L'éditeur signe la liste. Pour une publication sur geul.org, c'est geul.org (Issuer GEUL) ; pour une publication privée, c'est cet Issuer.
- L'ID de document `0x0000000000000000` est le document d'index des définitions de termes de l'Issuer ([Issuer et publication](/fr/grammar/issuer/)). L'Issuer lui-même se désigne par [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/).

## Règles

- Les ID de version de PUBLICATION sont croissants à partir de 1, sans trou. L'ID de version est attribué par l'éditeur.
- On ne republie pas le même hachage du contenu. S'il existe déjà, on renvoie son ID de version.
- DEPRECATION et TOMBSTONE ne désignent que l'ID de version d'un PUBLICATION apparu auparavant. Désigner une version inexistante est rejeté.
- L'état d'une version se calcule en appliquant les enregistrements dans l'ordre. Publiée → deprecated → supprimée. Une version supprimée n'est ni republiée ni délivrée.
- La dernière version est le plus haut ID de version ni deprecated ni supprimé.
- Quand l'ID de version atteint la fin des 2 WORD, ce document ne publie plus et l'on publie sous un nouvel ID de document.

## Nom du document

Le nom du document servant d'adresse est lié par [BIND](/fr/grammar/edge/bind/) dans l'index des noms de l'Issuer `/<Issuer>/documents.geul` ([Adresse de publication et liste des versions](/fr/grammar/publishing/#nom-du-document)). L'interpréteur ne lit que cet index.

On peut aussi placer le même BIND dans le document de liste (facultatif). Dans ce cas, on respecte ce qui suit.

- Subject est un `DOC-POINTER` (Issuer, ID de document de cette liste, version `0`). Le nom se lie au document et non à une version, donc la version est `0`.
- On ne lie qu'un document dont un PUBLICATION est apparu auparavant. On ne lie pas de nom à un document jamais publié.
- Le nom suit la règle des noms de document (slug ASCII en minuscules) et doit être identique au BIND de l'index des noms.
- Pour renommer, on ajoute un nouveau BIND. L'ancien nom subsiste et désigne le même document. Le nom représentatif est le dernier BIND.
- Le document n'écrit pas son propre nom.

## Adresse

```
/.well-known/geul/<Issuer>/<ID de document>/versions.geul             dernier document de liste (variable)
/.well-known/geul/h/<hachage du contenu>.geul                         anciens documents de liste (immuable)
```

- Seule l'adresse de la dernière liste est variable. La liste reçue se vérifie par la signature, le `RECORDED-AT` et la chaîne `PARENT`.
- Tous les anciens documents de liste restent dans `h/`. En suivant la chaîne `PARENT`, on peut retrouver la liste à n'importe quel moment.

## Vérification

- Le document de liste doit porter le `SIGNATURE` de la clé prescrite de l'éditeur.
- L'ID de document des enregistrements doit être égal à l'ID de document demandé.
- Le hachage du contenu de la liste précédente consigné dans le fichier de verrouillage doit figurer dans la chaîne `PARENT` de la nouvelle liste. Le BODY de cette liste doit être identique au début du BODY de la nouvelle liste.
- Le hachage du contenu du document reçu doit être égal à la valeur écrite par le PUBLICATION de cet ID de version, et le `DOC-ID` du document doit être égal à l'Issuer et à l'ID de document demandés.

## Problèmes ouverts

- Table des codes de catégorie de motif.
- Valeur par défaut de l'algorithme de signature et disposition du Payload de `SIGNATURE`.
- Moment et format du passage, quand la liste grossit, à un journal de Merkle (preuves d'inclusion et de cohérence).
- Fusionner ou non le BIND de la liste avec l'index des noms `documents.geul`, signature de l'index.
- Protection contre le retour en arrière à l'échelle de l'Issuer. Les listes formant une chaîne distincte par document, une attaque qui présente seulement la liste d'un document sous une forme ancienne n'est arrêtée que par la chaîne de ce document.

## Pages liées

- [Edge](/fr/grammar/edge/), [BIND](/fr/grammar/edge/bind/), [DOC-POINTER](/fr/grammar/reference/doc-pointer/)
- [Issuer et publication](/fr/grammar/issuer/), [Adresse de publication et liste des versions](/fr/grammar/publishing/), [Document](/fr/grammar/document/)
