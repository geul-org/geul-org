---
title: "Adresse de publication et liste des versions"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL désigne un document non par une chaîne URL mais par un ID (Issuer, ID de document, ID de version)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL désigne un document non par une chaîne URL mais par un ID (Issuer, ID de document, ID de version). L'adresse découle de l'ID. Cette page fixe les règles de publication nécessaires pour que l'encodeur, le décodeur et l'interpréteur fonctionnent ensemble. Les catégories d'Issuer et les modes de publication sont fixés par [Issuer et publication](issuer.md).

## Notation des ID {#id-표기}

Les ID utilisés dans les adresses s'écrivent en hexadécimal.

- Le préfixe est `0x` en minuscules. L'hexadécimal s'écrit avec A-F en majuscules. L'interpréteur convertit en majuscules une adresse écrite en minuscules avant de la chercher.
- Le nombre de chiffres est fixé à largeur × 4. On n'omet pas les zéros initiaux, et le nombre de chiffres vaut la largeur.
- Dans une adresse, l'Issuer s'écrit avec le nombre de chiffres de sa largeur d'émission : 8 chiffres pour 2 WORD, 16 pour 4 WORD, 64 pour 16 WORD.
- À la lecture, l'Issuer est accepté en 8, 16 ou 64 chiffres. Une notation longue obtenue en ajoutant des zéros devant un ID d'Issuer court est cherchée comme le même Issuer (`0x00000001` et `0x0000000000000001` sont le même Issuer, [Issuer et publication](issuer.md#issuer-등급)).

| Objet | Largeur | Chiffres | Exemple |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 chiffres |
| ID de Codec | 2 WORD | 8 | `0x00000AA0` |
| ID de document | 4 WORD | 16 | `0x0000000000000000` |
| ID de version | 2 WORD | 8 | `0x00000003` |
| Hachage du contenu | 16 WORD | 64 | `0x` + 64 chiffres |

- L'ID de Codec d'un code direct GEUL est son TAG WORD (L=0) écrit sur 32 bits (TRIPLE `0x0AAL` → `0x00000AA0`). Le Kind étant contenu dans le TAG, il n'y a pas de chevauchement.
- Un Codec au format ISSUER d'un autre Issuer se place sous le `codecs/` de cet Issuer avec le numéro de Codec de l'enregistrement. Exemple : CRC32C de l'IETF est `0x00000007/codecs/0x0000C000/`.
- L'ID de Codec d'un Codec d'Issuer est le numéro de Codec de l'enregistrement (2 WORD). L'Issuer attribue les numéros de Codec sans chevauchement dans son propre `<Issuer>/codecs/`, quel que soit le Kind (Reference, Value, Edge). L'adresse n'est pas répartie par Kind (il n'y a pas de dossiers comme `references/`, `values/`, `edges/`).
- L'interpréteur considère comme une erreur le cas où le Kind de l'enregistrement diffère du Kind de la cible du [DECLARE](edge/0x0BBL-declare.md) de son document de Codec.
- La publication refuse de déposer un autre Codec sous le même ID de Codec.
- Les règles de l'ID de version (à partir de 1, `0` pour la dernière, attribué par l'éditeur, nouvel ID de document quand l'espace est épuisé) sont fixées par [Document](document.md#버전).

## Adresse de publication {#공표-주소}

```
/.well-known/geul/issuers/latest.geul                              dernière liste des Issuer
/.well-known/geul/issuers/<ID de version>.geul                     liste des Issuer, version indiquée
/.well-known/geul/issuers/versions.geul                            liste des versions de la liste des Issuer
/.well-known/geul/<Issuer>/codecs/<ID de Codec>/latest.geul        dernier Codec
/.well-known/geul/<Issuer>/codecs/<ID de Codec>/<ID de version>.geul   Codec, version indiquée
/.well-known/geul/<Issuer>/codecs/<ID de Codec>/versions.geul      liste des versions du Codec
/.well-known/geul/<Issuer>/docs/<ID de document>/latest.geul       dernier document
/.well-known/geul/<Issuer>/docs/<ID de document>/<ID de version>.geul  document, version indiquée
/.well-known/geul/<Issuer>/docs/<ID de document>/versions.geul     liste des versions du document
/.well-known/geul/<Issuer>/hashes/<hachage du contenu>.geul        recherche par hachage du contenu
```

Exemple : `/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- Le chemin suit le `.well-known` de la RFC 8615. geul.org et la publication privée utilisent le même chemin et ne diffèrent que par le domaine. Le seul suffixe à enregistrer est `geul`.
- La liste des Issuer est `issuers/`. Les Codecs, les documents ordinaires et les hachages se répartissent sous le dossier de l'Issuer en `codecs/<ID de Codec>/`, `docs/<ID de document>/` et `hashes/`. La liste des Issuer commence elle aussi à la version 1 et possède un `versions.geul` ([documents de liste](#목록-문서)).
- `latest.geul` est un mot réservé et un alias. Il n'est pas stocké. On cherche la version la plus récente dans le `versions.geul` du même emplacement et l'on renvoie tels quels les octets de cette version. Il n'y a pas de redirection. Tous les `latest.geul` (liste des Issuer, Codec, document) sont identiques.
- L'adresse canonique d'une version est `/<Issuer>/docs/<ID de document>/<ID de version>.geul`. Pour un Codec, `/<Issuer>/codecs/<ID de Codec>/<ID de version>.geul`. Une autre adresse donnant le même contenu désigne l'adresse canonique par `Link: rel=canonical`.
- Une adresse à version indiquée et une adresse par hachage du contenu sont immuables. Les adresses immuables peuvent être placées dans un cache permanent et un CDN. Le récepteur vérifie avec le hachage du contenu de la liste des versions (ou de l'enregistrement de verrouillage).
- Pour chercher par hachage du contenu, il faut connaître l'Issuer. Il n'existe pas de recherche globale par le seul hachage.
- Un document de Codec n'a pas d'ID de document. Il se désigne lui-même, avec sa version, par un [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, ID de Codec, ID de version).
- Un ID commence toujours par `0x`. Ainsi les noms réservés (`issuers`, `codecs`, `docs`, `hashes`, `latest.geul`, `versions.geul`) et les noms donnés par des humains ne chevauchent jamais un ID, même s'ils sont des mots composés uniquement d'hexadécimal comme `add` ou `cafe`.
- L'emplacement (depuis quel serveur on reçoit) n'entre pas dans le contenu du document. S'il y entrait, le hachage du contenu changerait quand l'adresse change. L'emplacement est fixé par la configuration de celui qui reçoit le document.

### Forme de publication et recherche {#공표-형태와-조회}

- L'adresse est une adresse logique. L'éditeur peut publier en fichiers individuels ou en pack ; pour un pack, on ne peut pas le recevoir directement par l'URL de l'adresse et on le lit avec un interpréteur GEUL.
- Que le stockage soit en fichiers individuels, en pack ou en pack zstd, on le retrouve par la même adresse. Une adresse hors des 10 formes ci-dessus, ou inexistante, donne 404 (introuvable).

Outil en ligne de commande `geul` ([gogeul](https://github.com/geul-org/gogeul)) :

```
geul get <adresse>     écrit sur la sortie standard le binaire du document GEUL pur
geul show <adresse>    montre le document en texte
```

- `geul get` accepte les adresses `file://` et `https://`. Une adresse hors des 10 formes ou inexistante se termine par 404 (introuvable).

Le `pkg/resolve` de la bibliothèque Go gogeul a une fonction de recherche par adresse. Toutes renvoient un binaire GEUL pur (`[]byte`). L'ID de version commençant à 1, `Latest` (0) désigne la dernière. Une adresse inexistante donne l'erreur d'absence (`ErrNotFound`).

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // format hors des 10 formes : 404 (introuvable)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → sortie standard
```

### Désignation du format {#형식-지정}

- Une adresse de publication se termine par `.geul` et est un binaire (`application/vnd.geul`).
- Le binaire fait foi pour un document. Le hachage du contenu et la signature se calculent uniquement sur le binaire.

### Documents de liste {#목록-문서}

Le document de liste est unique : la liste des Issuer `issuers/`. Elle lie les Issuer et les domaines ([liste des Issuer](#issuer-목록)). Elle commence à la version 1 et possède un `versions.geul`. L'ID de document de la liste est l'ID de document réservé `0xFFFFFFFFFFFFFFFF` (Issuer geul.org `0x00000000`). Tout Issuer réserve les ID de document `0x0000000000000000` et `0xFFFFFFFFFFFFFFFF` ([Issuer et publication](issuer.md#용어-정의-문서)).

- `latest.geul` est un alias non stocké. On cherche la version la plus récente dans `versions.geul` et l'on renvoie ses octets.
- Les PUBLICATION, DEPRECATION et TOMBSTONE de `issuers/versions.geul` désignent la version de la liste par un DOC-POINTER (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, ID de version). Ainsi, même reçu par `hashes/`, on sait de quoi il est la liste ([PUBLICATION](edge/0x0B8L-publication.md#목록-문서의-버전-목록)).
- L'ID de document `0xFFFFFFFFFFFFFFFF` n'est reçu pour aucun Issuer à l'adresse `<Issuer>/docs/<ID de document>/` (404). L'autre ID de document réservé, `0x0000000000000000`, se place sous `docs/` comme document d'index des définitions de termes de cet Issuer ([Issuer et publication](issuer.md#용어-정의-문서)).
- Un document de liste n'a pas de `DOC-ID`. Ce dont il est la liste est indiqué par le DOC-POINTER de l'enregistrement ([DOC-ID](meta/0x1C7L-doc-id.md)).
- Les documents et les Codecs se retrouvent directement par l'ID calculé à partir de l'enregistrement, sans liste ([nom de document](#문서-이름)).

### Nom de domaine {#도메인-이름}

Un nom de domaine n'est pas une adresse URL de publication. Une adresse qui met un domaine à la place de `<Issuer>` ou un nom à la place d'un ID est hors des 10 formes ci-dessus, donc 404 (introuvable). Il n'y a pas non plus de redirection d'un nom vers une adresse par ID.

- Le nom de domaine est une entrée de l'interpréteur et de la CLI. L'interpréteur convertit le domaine en ID d'Issuer par le BIND de la liste des Issuer `issuers/`. L'ID obtenu est consigné dans l'enregistrement de verrouillage. Il n'y a pas d'adresse par nom de document ([nom de document](#문서-이름)).
- L'adresse canonique, la clé de cache et la cible de signature sont l'adresse par ID.
- Le domaine s'écrit en minuscules et un domaine internationalisé sous forme IDNA (punycode). On n'ajoute pas de `.` final.
- Un Issuer de 16 WORD, qui n'a pas de registre, et un environnement isolé qui ne peut joindre geul.org ne peuvent pas utiliser de nom de domaine. Ils utilisent l'ID.

### Liste des Issuer {#issuer-목록}

La liste des Issuer est un document sous `/.well-known/geul/issuers/` (la dernière est `issuers/latest.geul`). Elle lie les Issuer et leurs noms (domaines).

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   nom = "geul.org"
  …
```

- Le Subject est un [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) (l'Issuer lui-même) et le nom est lié par [BIND](edge/0x0A3L-bind.md).
- Le nom est un domaine ayant passé la preuve de propriété. Il est en minuscules et un domaine internationalisé s'écrit en IDNA (punycode). Un nom n'est lié qu'à un seul Issuer.
- Le nom d'affichage de l'Issuer lisible par l'humain (par langue) s'attache au même Subject par un Edge d'énoncé [LABEL](edge/0x0A4L-label.md).
- Il est signé par geul.org (Issuer GEUL), et lorsqu'il change, on ajoute et l'on ne corrige pas (même règle de chaîne que la liste des versions).

### Nom de document {#문서-이름}

**Il n'existe pas d'adresse par nom de document.** Les documents et les Codecs se retrouvent par ID.

- On ne tient pas d'index convertissant un nom de document ou un nom de Codec en ID. La liste des versions ne place pas non plus de [BIND](edge/0x0A3L-bind.md) de nom de document ([PUBLICATION](edge/0x0B8L-publication.md#버전-목록-문서)).
- L'index que l'humain parcourt est produit par un outil (visionneuse) à partir de l'inventaire des packs.
- L'adresse canonique, la clé de cache et la cible de signature sont l'adresse par ID. IMPORT et les citations dans un document se font uniquement par ID.
- Le titre lisible par l'humain (par langue) s'attache par un Edge d'énoncé [LABEL](edge/0x0A4L-label.md).

### Documents supprimés {#삭제된-문서}

- L'adresse d'une version abandonnée par suppression légale ou d'office (TOMBSTONE) donne elle aussi 404 (introuvable), comme les autres adresses inexistantes.
- Une version dont l'abandon est recommandé (DEPRECATION) ne donne pas 404. Elle continue d'être servie à l'adresse de cette version.
- La suppression est consignée dans la liste des versions par un enregistrement [TOMBSTONE](edge/0x0BAL-tombstone.md) (DOC-POINTER de cette version, catégorie de motif).

## Couches {#층}

GEUL exprime en documents GEUL jusqu'à la provenance, les Meta et les listes. Le minimum nécessaire pour les lire est intégré au décodeur pour rompre la circularité. Chaque couche ne s'appuie que sur les couches inférieures.

| Couche | Contenu | S'appuie sur |
|---|---|---|
| Couche 0 | Règles intégrées au décodeur : cadrage, hachage du contenu, vérification de signature, Codecs d'enregistrement de la liste des versions (`PUBLICATION`, `DEPRECATION`, `TOMBSTONE`), vocabulaire de spécification de Codec (`DECLARE`, `FIELD`, `ENUM`, `CODEC`), [marqueurs d'emplacement](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`), clés de confiance reçues hors du document | Rien. Pas de recherche |
| Couche 1 | Documents de liste des versions | Couche 0 |
| Couche 2 | Documents ordinaires, livres de codes, documents de spécification de Codec, documents de clés de vérification des Issuer | Trouvés par la couche 1 et vérifiés par la couche 0 |

- Aucune couche ne s'appuie sur sa propre couche ni sur une couche supérieure.
- On distingue ce qui s'exprime en GEUL de ce qui ne se lit qu'en interprétant du GEUL. La couche 0 peut s'exprimer en GEUL, mais son interprétation n'exige aucune recherche.
- Le noyau fixe qui ne peut pas être converti en document TOULMIN, comme le sens d'un verdict, se place aussi ici ([TOULMIN](toulmin/_index.md#메타-인지와-자기-개정)).

## Liste des versions {#버전-목록}

L'éditeur tient à la suite, pour chaque document, un document de liste des versions (`/<Issuer>/docs/<ID de document>/versions.geul`, pour un Codec `/<Issuer>/codecs/<ID de Codec>/versions.geul`, pour la liste des Issuer `issuers/versions.geul`). Le format des enregistrements et la structure du document sont fixés par [PUBLICATION](edge/0x0B8L-publication.md).

```
DOC-*
  SPEC-VERSION
  PARENT          hachage du contenu de la liste des versions précédente
  RECORDED-AT     instant où cette liste a été émise
  NEXT-LOCAL-ID   prochain LOCAL ID à attribuer
  SIGNATURE       signature de l'éditeur
BODY
  PUBLICATION     #1  document@1  hachage du contenu
  PUBLICATION     #2  document@2  hachage du contenu
  DEPRECATION     #3  document@1
  …
END
```

| Edge | Sens |
|---|---|
| PUBLICATION | Publie une version du document et son hachage du contenu |
| DEPRECATION | Marque une version publiée d'une recommandation d'abandon. Elle continue d'être interprétée |
| TOMBSTONE | Supprime une version publiée (suppression légale ou d'office). On note la catégorie de motif |

- On ne fait qu'ajouter des enregistrements. On ne corrige, ne supprime ni ne réordonne. Une dépréciation ou une suppression s'ajoute aussi comme enregistrement. La nouvelle liste place telle quelle en tête le BODY de la liste précédente et y ajoute des enregistrements, et les listes sont reliées entre elles par la chaîne de hachages `PARENT`.
- Cela signifie qu'on ne corrige pas l'enregistrement de publication, ce qui diffère de la révision du contenu d'un document ([Document](document.md#개정)). L'état courant d'une version se calcule en appliquant les enregistrements dans l'ordre.
- Les ID de version croissent à partir de 1 sans trou. On ne republie pas le même contenu.
- La dernière version est la plus haute version qui n'est ni dépréciée ni supprimée.
- On ne met pas d'instant dans l'enregistrement. L'instant de publication est le `RECORDED-AT` de la première liste où cet enregistrement figure.
- La liste des versions n'a pas de `DOC-ID`. Le DOC-POINTER des enregistrements (ID de document, ou ID de document réservé pour la liste des Issuer) dit de quoi elle est la liste.
- La liste des versions ne place pas d'IMPORT et n'utilise que des Codecs de la couche 0. Le BODY ne contient que PUBLICATION, DEPRECATION et TOMBSTONE.
- Les listes de versions passées ne sont désignées que par le hachage du contenu (`<Issuer>/hashes/<hachage du contenu>.geul`), et l'historique est relié par la chaîne `PARENT`.
- Les adresses variables sont `latest.geul` et `versions.geul`. Un pointeur variable ne pouvant pas être fait en document, on le vérifie par la signature de la liste reçue, `RECORDED-AT` et `PARENT`.

### Signataire {#서명-주체}

| Signature | Signataire | Cible |
|---|---|---|
| Signature de document | L'Issuer de ce document | Hachage du contenu du document ([Issuer et publication](issuer.md#서명)) |
| Signature de liste | L'éditeur qui a attribué les ID de version | Hachage du contenu de la liste des versions |

- Pour la publication geul.org, c'est geul.org (Issuer GEUL), et pour la publication privée, cet Issuer, qui attribue les ID de version et signe la liste.
- L'auteur répond du contenu, l'éditeur du numéro et de l'ordre.

### Vérification {#검증}

- La signature étant exclue du hachage du contenu, la supprimer laisse le hachage inchangé. On vérifie donc non pas « si une signature existe, on la contrôle » mais « une signature de la clé prescrite doit exister ». La clé exigée est fixée par la configuration de confiance de l'interpréteur et l'enregistrement de verrouillage.
- L'interpréteur consigne dans l'enregistrement de verrouillage le hachage du contenu de la dernière liste vue. Si ce hachage ne figure pas dans la chaîne `PARENT` d'une liste nouvellement reçue, on rejette (prévention du retour en arrière et de la bifurcation).
- Les miroirs et les environnements isolés copient aussi la chaîne des listes de versions. Avec la seule clé publique, la vérification se fait hors ligne.
- Un document reçu, d'où qu'il vienne, se vérifie par le hachage du contenu. Il n'est pas nécessaire de faire confiance à la source.

## Résolution des dépendances {#의존성-해석}

- Un document note ses documents dépendants par [IMPORT-DOC](meta/0x1E4L-import-doc.md) dans le HEAD.
- Une nouvelle version ne promet aucune compatibilité avec la précédente. On ne réunit donc pas en une seule les versions d'un document dans tout le graphe (on n'utilise pas la sélection de version minimale).
- Chaque `IMPORT-DOC` est lié à l'édition qu'il a fixée. Plusieurs éditions d'un même document peuvent coexister dans un graphe (un jugement citant l'ancienne loi et un jugement citant la loi en vigueur). Une référence se résout par (document, version, LOCAL ID).
- Une importation de la dernière version (version `0`) est liée à la dernière édition au moment de l'interprétation. Si l'on interprète à un instant donné, elle est liée à l'édition en vigueur à cet instant ([Document](document.md#개정)).
- Une importation fixée par ID de version est reproductible (le contenu d'un ID de version est immuable et se vérifie par l'enregistrement de verrouillage).

## Type de média {#미디어-타입}

- Le type de média d'un document GEUL est `application/vnd.geul`. L'extension est `.geul`.
- Même si l'on passe à l'arbre standard `application/geul`, on continue d'accepter `application/vnd.geul`.

## Problèmes ouverts {#열린-문제}

- Le traitement des divergences d'ID de version (même ID de version, contenu différent) en publication privée, pour les Issuer de 16 WORD et en environnement isolé.
- La composition du HEAD de la liste des Issuer `issuers/` et le format de signature et de chaîne. Les règles de nom pour les Issuer sans domaine (4 WORD), le traitement des litiges de nom et la limite de longueur.
- Le moment et le format du passage, quand les listes grossissent, de la chaîne entière à un journal de Merkle (preuves d'inclusion et de cohérence).
- Un Meta notant dans le HEAD l'Issuer qui fournit l'emplacement.
