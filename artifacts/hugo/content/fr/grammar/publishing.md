---
title: "Adresse de publication et liste des versions"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Un document GEUL publié est servi à une adresse fixe déterminée par son ID (Issuer, ID de document, ID de version) et vérifié par la liste des versions signée par l'éditeur. Cette page fixe la notation des ID, les adresses, la spécification de format, l'index des noms, la liste des versions et les niveaux de confiance."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL désigne un document non par une URL sous forme de chaîne, mais par un ID (Issuer, ID de document, ID de version). L'adresse est déterminée par l'ID. Cette page fixe les règles de publication nécessaires pour que encodeurs, décodeurs et interpréteurs fonctionnent ensemble. Les niveaux d'Issuer et les modes de publication sont fixés par [Issuer et publication](/fr/grammar/issuer/).

## Notation des ID

Les ID employés dans les adresses s'écrivent en hex.

- Le préfixe est `0x` en minuscules, et les chiffres hex sont aussi en minuscules.
- Le nombre de chiffres est fixé à largeur × 4. On n'omet pas les zéros de tête, et le nombre de chiffres est la largeur.
- L'ID d'Issuer s'écrit sur la largeur la plus courte qui contienne la valeur. Il n'existe pas de notation élargie comme `0x00000005` (on écrit `0x0005`).

| Objet | Largeur | Chiffres | Exemple |
|---|---|---|---|
| Issuer | 1 WORD | 4 | `0x0001` |
| Issuer | 2 WORD | 8 | `0x00010000` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 chiffres |
| ID de document | 4 WORD | 16 | `0x0000000000000000` |
| ID de version | 2 WORD | 8 | `0x00000003` |
| Hachage du contenu | 16 WORD | 64 | `0x` + 64 chiffres |

- Une requête non canonique (`0X`, majuscules, zéros omis) est redirigée en `301` vers l'adresse canonique. La clé de cache et l'objet de la signature sont ainsi uniques.
- Les règles de l'ID de version (à partir de 1, `0` = dernière, attribué par l'éditeur, nouvel ID de document quand ils sont épuisés) sont fixées par [Document](/fr/grammar/document/#versions).

## Adresse de publication

```
/.well-known/geul/<Issuer>/<ID de document>.geul              dernière version. Envoyée en 302 vers l'adresse canonique (variable)
/.well-known/geul/<Issuer>/<ID de document>/<ID de version>.geul    un exemplaire de document (immuable, adresse canonique)
/.well-known/geul/<Issuer>/<ID de document>/versions.geul     document de liste des versions (variable, signé)
/.well-known/geul/h/<hachage du contenu>.geul                 recherche par hachage du contenu (immuable)
```

Exemple : `/.well-known/geul/0x0001/0x0000000000000000.geul`

- Le chemin suit le `.well-known` de la RFC 8615. geul.org et les publications privées emploient le même chemin et ne diffèrent que par le domaine. Le seul suffixe à enregistrer est `geul`.
- Le contenu d'un document ne sort que des adresses immuables. L'adresse de la dernière version ne donne pas de contenu mais renvoie en `302` vers l'adresse canonique de cette version.
- L'adresse canonique d'une version est `/<Issuer>/<ID de document>/<ID de version>.geul`. Une autre adresse donnant le même contenu désigne l'adresse canonique par `Link: rel=canonical`.
- Les adresses immuables peuvent se placer dans des caches permanents et des CDN. Le destinataire vérifie avec le hachage du contenu de la liste des versions (ou du fichier de verrouillage).
- Un ID commence toujours par `0x`. Ainsi, les noms réservés (`h`, `keys`, `issuers.geul`, `documents.geul`, `versions.geul`) et les noms donnés par des humains ne se confondent pas avec un ID, même un mot composé uniquement de chiffres hex comme `add` ou `cafe`.
- La localisation (de quel serveur on le reçoit) ne se met pas dans le contenu du document. Sinon, le hachage du contenu changerait quand l'adresse change. La localisation est fixée par la configuration de celui qui reçoit le document.

### Spécification de format

- Si l'adresse a une extension, elle fixe le format. `.geul` est le binaire (`application/vnd.geul`).
- Sans extension, on suit l'en-tête `Accept`. On donne une vue HTML au navigateur et le binaire aux outils. Exemple : `/<Issuer>/<ID de document>/<ID de version>`
- Le binaire fait foi pour un document. Le hachage du contenu et la signature ne se calculent que sur le binaire.

### Nom de domaine

Un Issuer ayant passé la preuve de propriété d'un domaine peut employer ce domaine à la place de l'ID dans l'emplacement `<Issuer>` de l'adresse.

```
/.well-known/geul/<domaine>/<ID de document>.geul              → 302 → /<Issuer>/<ID de document>.geul
/.well-known/geul/<domaine>/<ID de document>/<ID de version>.geul    → 302 → /<Issuer>/<ID de document>/<ID de version>.geul
/.well-known/geul/<domaine>/<ID de document>/                  → 302 → /<Issuer>/<ID de document>/
```

Exemple : `/.well-known/geul/geul.org/0x0000000000001018/0x00000001.geul`

- L'adresse de domaine ne donne pas de contenu et renvoie en `302` vers l'adresse d'ID. L'adresse canonique, la clé de cache et l'objet de la signature sont l'adresse d'ID. La correspondance pouvant changer, on n'emploie pas de redirection permanente.
- Le domaine s'écrit en minuscules, et un domaine internationalisé sous forme IDNA (punycode). On n'ajoute pas de `.` final. Si ce n'est pas la forme canonique, on redirige en `301` vers elle.
- Un domaine contenant un `.`, il ne se confond pas avec un ID commençant par `0x` ni avec un nom réservé.
- Quand l'interpréteur reçoit une adresse de domaine, il vérifie la correspondance avec l'index des noms d'Issuer, la convertit en ID et la consigne dans le fichier de verrouillage.
- Les Issuer de 16 WORD, qui n'ont pas de registre, et les environnements isolés qui n'atteignent pas geul.org ne peuvent pas employer de nom de domaine. Ils emploient l'adresse d'ID.

### Nom d'Issuer

L'index des noms d'Issuer est un seul document, `/.well-known/geul/issuers.geul`.

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   nom = "geul.org"
  …
```

- Le Subject est [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/) (l'Issuer lui-même), et le nom se lie par [BIND](/fr/grammar/edge/bind/).
- Le nom est un domaine ayant passé la preuve de propriété. Il est en minuscules, et un domaine internationalisé s'écrit en IDNA (punycode). Un nom n'est lié qu'à un seul Issuer.
- Le nom d'affichage de l'Issuer lisible par l'humain (par langue) s'attache au même Subject par une description [LABEL](/fr/grammar/edge/label/).
- Il est signé par geul.org (Issuer GEUL), et quand il change on ajoute sans corriger (même règle de chaîne que la liste des versions).
- Le nom réservé `issuers.geul` contient un `.` et ressemble à un domaine. Même si un domaine de ce nom apparaît, ce chemin reste l'index des noms d'Issuer.

### Nom du document

On peut aussi employer l'adresse avec un nom de document à la place de l'ID de document. À l'emplacement `<Issuer>`, on met l'ID ou le nom de domaine.

```
/.well-known/geul/<Issuer|domaine>/<nom du document>.geul              → 302 → /<Issuer>/<ID de document>.geul
/.well-known/geul/<Issuer|domaine>/<nom du document>/<ID de version>.geul    → 302 → /<Issuer>/<ID de document>/<ID de version>.geul
/.well-known/geul/<Issuer|domaine>/<nom du document>/                  → 302 → /<Issuer>/<ID de document>/
```

Exemple : `/.well-known/geul/geul.org/publication/0x00000001.geul` → `/0x0000/0x0000000000001018/0x00000001.geul`

**Les noms de documents sont liés par BIND dans l'index des noms de l'Issuer, `/<Issuer>/documents.geul`.** L'interpréteur fait correspondre le nom à l'ID de document par cet index.

```
BODY
  BIND   Subject = DOC-POINTER(Issuer, ID de document, version 0)   nom = "publication"
  …
```

- Le Subject est un [DOC-POINTER](/fr/grammar/reference/doc-pointer/) (Issuer, ID de document, version `0`). Le nom se lie au document, non à une version.
- L'Issuer du Subject doit être le même que celui qui tient l'index. Les documents d'un autre Issuer sont ignorés.
- Un nom ne se lie qu'à un document publié.
- Un nom de document est un slug ASCII en minuscules : `a-z`, `0-9`, `-`. Il ne commence ni ne finit par `-` et ne commence pas par `0x`. Il ne se confond ainsi ni avec un ID de document (`0x…`) ni avec un nom réservé (`h`, `versions.geul`, etc.) ([BIND](/fr/grammar/edge/bind/)).
- Dans un Issuer, un nom n'est lié qu'à un seul document, et un nom une fois lié n'est pas réutilisé pour un autre document. Pour renommer, on ajoute un nouveau BIND. L'ancien nom continue de renvoyer au même document. Si le même nom apparaît plusieurs fois, le dernier BIND fait foi.
- Le document n'écrit pas son propre nom. L'adresse canonique, la clé de cache et l'objet de la signature sont l'adresse d'ID. IMPORT et les citations dans un document se font par ID seulement.
- Le titre lisible par l'humain (par langue) n'est pas un nom. On l'attache par une description `LABEL`.
- Le document de liste des versions peut aussi porter le même BIND de nom de document ([PUBLICATION](/fr/grammar/edge/publication/#nom-du-document)). S'il en porte, il doit être identique à l'index des noms. L'interpréteur ne lit que l'index des noms.

### Document supprimé

- L'adresse d'une version supprimée légalement ou d'office renvoie `410 Gone` et une pierre tombale (ID de version, hachage du contenu, date de suppression, catégorie de motif).
- Dans la liste des versions, elle subsiste sous forme d'enregistrement [TOMBSTONE](/fr/grammar/edge/publication/).

## Couches

GEUL exprime en documents GEUL jusqu'à la provenance, les métadonnées et les listes. Le minimum nécessaire pour les lire est intégré au décodeur, ce qui coupe la circularité. Chaque couche ne s'appuie que sur les couches inférieures.

| Couche | Contenu | S'appuie sur |
|---|---|---|
| Couche 0 | Règles intégrées au décodeur : cadrage, hachage du contenu, vérification de signature, Codec des enregistrements de la liste des versions (`PUBLICATION`, `DEPRECATION`, `TOMBSTONE`), vocabulaire de spécification de Codec (`DECLARE`, `FIELD`, `ENUM`, `CODEC`), [marqueurs d'emplacement](/fr/grammar/reference/slot-marker/) (`0x0000`~`0x0002`), clés de confiance reçues hors du document | Rien. Pas de consultation |
| Couche 1 | Documents de liste des versions | Couche 0 |
| Couche 2 | Documents ordinaires, livre de codes, documents de spécification de Codec, documents de clés de vérification des Issuer | Se trouvent par la couche 1 et se vérifient par la couche 0 |

- Aucune couche ne s'appuie sur elle-même ni sur une couche supérieure.
- On distingue ce qui s'exprime en GEUL de ce qui ne se lit qu'en interprétant du GEUL. La couche 0 peut s'exprimer en GEUL, mais son interprétation ne demande aucune consultation.
- Le noyau fixe qui ne peut pas être converti en documents TOULMIN, comme le sens du jugement, se place lui aussi ici ([TOULMIN](/fr/grammar/edge/toulmin/#méta-cognition-et-auto-révision)).

## Liste des versions

L'éditeur tient, pour chaque document, un document de liste des versions en ajout continu (`/<Issuer>/<ID de document>/versions.geul`). Le format des enregistrements et la structure du document sont fixés par [PUBLICATION](/fr/grammar/edge/publication/).

```
DOC-*
  SPEC-VERSION
  PARENT          hachage du contenu de la liste précédente
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
| DEPRECATION | Appose sur une version publiée une recommandation d'abandon. Elle continue d'être interprétée |
| TOMBSTONE | Supprime une version publiée (suppression légale ou d'office). Indique une catégorie de motif |

- On n'ajoute que des enregistrements. On ne corrige ni n'efface ni ne réordonne. Déprécier et supprimer ajoutent aussi des enregistrements. La nouvelle liste garde en tête le BODY de la liste précédente tel quel et y ajoute des enregistrements, et les listes sont reliées par la chaîne de hachages `PARENT`.
- Cela signifie qu'on ne corrige pas le registre de publication, ce qui diffère de la révision du contenu d'un document ([Document](/fr/grammar/document/#révision)). L'état actuel d'une version se calcule en appliquant les enregistrements dans l'ordre.
- Les ID de version sont croissants à partir de 1, sans trou. On ne republie pas le même contenu.
- La dernière version est la version la plus élevée qui n'est ni recommandée à l'abandon ni supprimée.
- Les enregistrements ne contiennent pas d'instant. Le `RECORDED-AT` de la première liste où l'enregistrement figure est l'instant de publication.
- Le document de liste n'a pas de `DOC-ID`. C'est l'ID de document des enregistrements qui dit de quoi c'est la liste.
- Le document de liste n'a pas d'IMPORT et n'emploie que des Codec de la couche 0.
- Le document de liste ne se place pas dans une autre liste (pas de liste de listes). Les listes passées ne se désignent que par le hachage du contenu (`h/<hachage du contenu>.geul`), et l'historique se relie par la chaîne `PARENT`.
- La seule adresse variable est celle de la dernière liste (`/<Issuer>/<ID de document>/versions.geul`). Un pointeur variable ne pouvant pas être fait en document, on le vérifie par la signature, le `RECORDED-AT` et le `PARENT` de la liste reçue.

### Signataire

| Signature | Signataire | Objet |
|---|---|---|
| Signature de document | L'Issuer de ce document | Hachage du contenu du document ([Issuer et publication](/fr/grammar/issuer/#signature)) |
| Signature de liste | L'éditeur qui a attribué les ID de version | Hachage du contenu du document de liste |

- Pour la publication sur geul.org, c'est geul.org (Issuer GEUL) qui attribue les ID de version et signe la liste ; pour la publication privée, c'est l'Issuer.
- L'auteur répond du contenu, l'éditeur du numéro et de l'ordre.

### Vérification

- La signature étant exclue du hachage du contenu, l'effacer laisse le hachage inchangé. On vérifie donc non par « si une signature existe, on la contrôle » mais par « il faut la signature de la clé prescrite ». Les clés exigées sont fixées par la configuration de confiance de l'interpréteur et le fichier de verrouillage.
- L'interpréteur consigne dans le fichier de verrouillage le hachage du contenu de la dernière liste vue. Si ce hachage n'est pas dans la chaîne `PARENT` d'une liste nouvellement reçue, il rejette (protection contre le retour en arrière et la bifurcation).
- Les miroirs et environnements isolés copient aussi la chaîne des documents de liste. Avec la seule clé publique, la vérification se fait hors ligne.
- Un document reçu, de quelque source qu'il vienne, se vérifie par son hachage du contenu. Il n'est pas nécessaire de faire confiance à la source.

## Résolution des dépendances

- Un document indique ses documents dépendants par [IMPORT-DOC](/fr/grammar/meta/import/import-doc/) dans le HEAD.
- Une nouvelle version ne promet pas de compatibilité avec la précédente. On ne ramène donc pas à une seule les versions d'un document dans tout le graphe (on n'emploie pas la sélection de version minimale).
- Chaque `IMPORT-DOC` est lié à l'édition qu'il a figée. Plusieurs éditions d'un même document peuvent coexister dans un graphe (un jugement qui cite l'ancienne loi et un jugement qui cite la loi en vigueur). Les références se résolvent par (document, version, LOCAL ID).
- Un import de la dernière version (version `0`) est lié à la dernière édition au moment de l'interprétation. Si l'on interprète à un instant donné, il est lié à l'édition en vigueur à cet instant ([Document](/fr/grammar/document/#révision)).
- Un import figé par ID de version est reproductible (le contenu d'un ID de version est immuable et se vérifie par le fichier de verrouillage).

## Type de média

- Le type de média d'un document GEUL est `application/vnd.geul`. L'extension est `.geul`.
- Même si l'on passe à l'arbre standard `application/geul`, on continue d'accepter `application/vnd.geul`.

## Problèmes ouverts

- Jusqu'où geul.org sert directement les documents des Issuer de 1, 2, 4 et 16 WORD, et à partir d'où il renvoie vers l'adresse du registre. Codes d'état à ce moment (canonique 308, dernière 302 ou 307).
- Traitement des divergences d'ID de version (même ID de version, contenus différents) dans les publications privées, les Issuer de 16 WORD et les environnements isolés.
- Définition de la représentation textuelle et négociation de contenu (binaire, texte ou vue HTML selon `Accept`).
- Relation entre l'index des noms de documents `documents.geul` et le BIND de la liste des versions (les fusionner ou non), signature de l'index.
- Composition du HEAD de `issuers.geul` et format de signature et de chaîne. Règle de nom pour les Issuer sans domaine (1 et 4 WORD), traitement des litiges de noms et plafond de longueur.
- Permettre ou non aux Issuer de 1 WORD de passer facultativement la preuve de domaine pour employer un nom de domaine.
- Moment et format du passage, quand la liste grossit, à un journal de Merkle (preuves d'inclusion et de cohérence) plutôt qu'à la chaîne entière.
- Meta indiquant dans le HEAD l'Issuer fournisseur de localisation.
