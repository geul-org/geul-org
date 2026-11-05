---
title: "DEPRECATION (0x0B9L)"
weight: 185
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION et TOMBSTONE sont des Edge d'énoncé qui consignent la publication, la recommandation d'abandon et la suppression d'une version de document, et cette page fixe aussi la spécification du document de liste des versions écrit avec ces Edge (Codec 0x0B8L~0x0BAL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION, DEPRECATION et TOMBSTONE sont des Edge d'énoncé qui consignent la publication, la recommandation d'abandon et la suppression d'une version de document, et cette page fixe aussi la spécification du document de liste des versions écrit avec ces Edge (Codec 0x0B8L~0x0BAL).

| Élément | Valeur |
|---|---|
| Nom | `DEPRECATION` (BIND du document de spécification `DEPRECATION`) |
| TAG ID | `0x0B9L` |
| Codec ID | `0x00000B90` |
| Document de spécification | `0x00000000/codecs/0x00000B90/` (cible de DECLARE `0B90`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 25 |
| Kind | Edge · famille : énoncé, groupe : divers |
| TAG WORD | `0000 1011 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Dépréciation (deprecate) d'une version publiée. DOC-POINTER |
| Côté Hugo | `edge/publication.md` (cette page traite aussi de [PUBLICATION](0x0B8L-publication.md) et de [TOMBSTONE](0x0BAL-tombstone.md)) |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | enregistrement | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

Edge d'énoncé qui consigne la publication, la dépréciation (deprecate) et la suppression d'un document, et spécification du document de liste des versions écrit avec ces Edge. Elle fixe le format de la liste des versions de l'[adresse de publication et liste des versions](../publishing.md#버전-목록).

## Codes {#코드}

| Codec | Nom | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, DOC-POINTER, hachage du contenu |
| `0x0B9L` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, DOC-POINTER, catégorie de motif |

- Ces trois codes sont intégrés au décodeur ([couche 0](../publishing.md#층)). La liste des versions est interprétée sans consulter de codebook.
- On ne place pas de sous-format (TAG propre au Codec). On respecte telle quelle la règle d'[Edge](_index.md) selon laquelle le premier élément du Payload est l'Edge Id.

## Disposition {#레이아웃}

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
document          enregistrement Reference DOC-POINTER (Issuer, ID de document, ID de version). CODEC-POINTER pour la liste des versions d'un codec
hachage contenu   16 WORD   (PUBLICATION)
catégorie motif   1 WORD    (TOMBSTONE)
```

| Champ | Largeur | Description |
|---|---|---|
| Edge Id | enregistrement Reference LOCAL | Numéro d'ordre dans la liste. Numéroté à partir de 1, à la suite |
| document | enregistrement DOC-POINTER | Une version du document publié ([DOC-POINTER](../reference/0x041L-doc-pointer.md)). L'Issuer et l'ID de document sont ceux du document que traite cette liste. Cela permet au document de liste de dire de quoi il est la liste, même sans chemin. L'ID de version est le numéro d'ordre dans ce document (version de [document](../document.md)) et `0` (la plus récente) n'est pas utilisé. La liste des versions d'un codec utilise [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID de version) |
| hachage du contenu | 16 WORD | Hachage du contenu de cette version (SHA-256, hachage du contenu de [document](../document.md)) |
| catégorie de motif | 1 WORD | Code de catégorie du motif de suppression. La table des codes est un problème ouvert |

- La longueur après DOC-POINTER est fixe pour chaque code (16, 0, 1 WORD). Sinon, rejet.
- On ne met pas d'instant dans l'enregistrement. Le `RECORDED-AT` du document de liste où cet enregistrement figure pour la première fois est l'instant de publication, de deprecate ou de suppression.

## Document de liste des versions {#버전-목록-문서}

Le lieu de publication tient à la suite, pour chaque document, un document de liste des versions : `/<Issuer>/docs/<ID de document>/versions.geul` (pour un codec, `/<Issuer>/codecs/<Codec ID>/versions.geul` ; pour la liste des Issuer, voir [ci-dessous](#목록-문서의-버전-목록)). Toutes les versions de ce document publiées à ce lieu de publication entrent dans une seule liste.

```
DOC-1WORD/2WORD/4WORD     longueur totale
  SPEC-VERSION            0x0001 (v1)
  PARENT                  Value SHA-256-DIGEST. Hachage du contenu du document de liste précédent (absent pour la première liste)
  RECORDED-AT             Value POSIX-TIMESTAMP-SECONDS. Instant où cette liste a été émise
  NEXT-LOCAL-ID           prochain ID LOCAL à attribuer (s'il y a des versions)
  SIGNATURE               signature du lieu de publication. Cible : le hachage du contenu de ce document de liste
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- Meta de HEAD : [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- Le document de liste des versions ne contient pas de `DOC-ID` (exception pour les documents de liste, [DOC-ID](../meta/0x1C7L-doc-id.md)). La liste n'est pas un document publié mais un enregistrement attaché à ce document. De quel document c'est la liste, c'est le DOC-POINTER (ID de document) des enregistrements qui le dit. On sait donc de quoi c'est la liste même si on la reçoit sans chemin (`hashes/`, dump).
- Les ID de document des enregistrements doivent tous être celui du document que traite cette liste. Les enregistrements d'un autre document sont rejetés.
- Le document de liste des versions ne contient pas d'IMPORT et n'utilise que les Codec de la couche 0. BODY ne contient que PUBLICATION·DEPRECATION·TOMBSTONE. On n'y met pas de BIND de nom de document ([adresse de publication et liste des versions](../publishing.md#문서-이름)).
- Un nouveau document de liste reprend tel quel en tête le BODY du document de liste précédent et y ajoute des enregistrements. On ne modifie, ne supprime ni ne réordonne.
- Le lieu de publication signe la liste. Pour une publication geul.org, c'est geul.org (Issuer GEUL) qui signe ; pour une publication privée, c'est cet Issuer.
- L'ID de document `0x0000000000000000` est le document d'index de définition des termes de l'Issuer ([Issuer et publication](../issuer.md)). L'Issuer lui-même est désigné par [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).

## Liste des versions du document de liste {#목록-문서의-버전-목록}

Le document de liste est la liste des Issuer `issuers/` ([adresse de publication et liste des versions](../publishing.md#목록-문서)). La liste des Issuer commence elle aussi à la version 1 et a une liste des versions `issuers/versions.geul`. Les enregistrements désignent la version de la liste par un DOC-POINTER d'ID de document réservé (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, ID de version).

- Le format des enregistrements est le même que ci-dessus. On sait donc de quoi c'est la liste même si on la reçoit par `hashes/`.
- Le document de liste lui-même (`<ID de version>.geul`) ne contient pas non plus de `DOC-ID`.
- L'ID de document `0xFFFFFFFFFFFFFFFF` n'est reçu à l'adresse `<Issuer>/docs/<ID de document>/` d'aucun Issuer (404).
- `latest.geul` de la liste est un alias non stocké. On trouve la version la plus récente dans cette liste des versions et l'on émet ses octets.

## Règles {#규칙}

- Les ID de version de PUBLICATION vont de 1 en ordre croissant, sans trou. L'ID de version est attribué par le lieu de publication.
- On ne republie pas le même hachage de contenu. S'il existe déjà, on renvoie son ID de version.
- DEPRECATION et TOMBSTONE ne désignent que l'ID de version d'un PUBLICATION apparu auparavant. Désigner une version inexistante est rejeté.
- L'état d'une version se calcule en appliquant les enregistrements dans l'ordre. Publiée → deprecated → supprimée. Une version supprimée n'est ni republiée ni délivrée.
- La version la plus récente est l'ID de version le plus élevé qui n'est ni deprecated ni supprimé.
- Quand l'ID de version atteint la fin de 2 WORD, ce document ne publie plus et l'on émet sous un nouvel ID de document.

## Adresses {#주소}

```
/.well-known/geul/<Issuer>/docs/<ID de document>/versions.geul        dernier document de liste (variable)
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul            dernier document de liste du codec (variable)
/.well-known/geul/issuers/versions.geul                               dernière liste des versions de la liste des Issuer (variable)
/.well-known/geul/<Issuer>/hashes/<hachage du contenu>.geul           documents de liste passés (immuable)
```

- Ce qui est variable est l'adresse de la dernière liste. On vérifie la liste reçue par la signature, `RECORDED-AT` et la chaîne `PARENT`.
- Tous les documents de liste passés restent dans `<Issuer>/hashes/`. En suivant la chaîne `PARENT`, on peut retracer la liste à n'importe quel moment.

## Vérification {#검증}

- Le document de liste doit avoir la `SIGNATURE` de la clé du lieu de publication prescrite.
- L'ID de document des enregistrements doit être égal à l'ID de document demandé.
- Le hachage du contenu de la liste précédente, conservé dans le journal de verrouillage, doit se trouver dans la chaîne `PARENT` de la nouvelle liste. Le BODY de cette liste doit être identique au début du BODY de la nouvelle.
- Le hachage du contenu du document reçu doit être égal à la valeur écrite par le PUBLICATION de cet ID de version, et le `DOC-ID` du document doit être égal à l'Issuer et à l'ID de document demandés. Le document de liste n'a pas de `DOC-ID`.

## Problèmes ouverts {#열린-문제}

- Table des codes de catégorie de motif.
- Algorithme de signature par défaut et disposition du Payload de `SIGNATURE`.
- Moment et format du passage à un journal Merkle (preuves d'inclusion et de cohérence) quand la liste grossit.
- Protection contre le retour en arrière par Issuer. Comme chaque document a sa propre chaîne de listes, une attaque qui présente comme ancienne la seule liste d'un document n'est bloquée que par la chaîne de ce document.

## Pages liées {#관련-페이지}

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer et publication](../issuer.md), [adresse de publication et liste des versions](../publishing.md), [document](../document.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000B90/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B9000000000
BODY
#1 DECLARE 0x0B90
#2 FIELD #1 record
#6 CODEC #2 0x0410
#4 BIND #1 "DEPRECATION"
#5 BIND #2 "doc"
#7 CODEC #2 0x0420
```
