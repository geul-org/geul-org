---
title: "Issuer et publication"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "L'Issuer est l'entité qui définit documents et formats. Le mode d'émission dépend de la largeur (1, 2, 4 ou 16 WORD). Cette page fixe les niveaux d'Issuer et la table d'attribution des 1 WORD, le mode de publication des documents, la signature et la publication des clés de vérification."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL ne concentre pas le système d'identification en un seul lieu. Chaque Issuer définit ses cibles et ses formats, et les autres documents reprennent les définitions publiées. Une définition peut rester confidentielle, être publiée sur geul.org (CC0) ou faire l'objet d'une publication privée (licence fixée par l'Issuer). C'est à l'utilisateur de décider quelle définition croire et utiliser.

L'adresse de publication, la spécification de format, l'index des noms, la liste des versions et les niveaux de confiance sont fixés par [Adresse de publication et liste des versions](/fr/grammar/publishing/).

## Ce que définit l'Issuer

| Objet | Méthode |
|---|---|
| Cibles (entités, concepts, termes) | Se déclarent par un LOCAL de son propre document |
| Formats de Value | Se définissent par un numéro de format sous le code d'Issuer |
| Formats d'Edge | Se définissent par un numéro de format sous le code d'Issuer |

- La définition des formats de Value et d'Edge est elle aussi publiée sous forme de document.

## Principes

- Tout ID a pour portée le document. Les LOCAL ID (Edge Id, variables comprises) et les IMPORT ID ne valent qu'à l'intérieur de ce document.
- Une cible définie par un Issuer est un LOCAL d'un document publié par cet Issuer. Les autres documents la citent directement par un pointeur-déclaration (`EXTERNAL-ISSUER-*`), ou l'importent par `IMPORT-DOC` et la désignent par `EXTERNAL-POINTER-*`.
- Pour une cible qu'il faut pouvoir désigner depuis l'extérieur d'un document, on émet un LOCAL d'un document publié. Ce document doit avoir un [DOC-ID](/fr/grammar/meta/declaration/doc-id/).

## Niveaux d'Issuer

| Largeur | Plage de valeurs | Attribution |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | geul.org l'attribue aux organismes de normalisation et aux grandes institutions ([Table des Issuer de 1 WORD](#table-des-issuer-de-1-word)) |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | Enregistré auprès de geul.org. Passe la preuve de propriété d'un domaine |
| 4 WORD | `2^32`~`2^64−1` | Enregistré auprès de geul.org. Sans preuve de propriété |
| 16 WORD | `2^64` et plus | Auto-émis. Calculé à partir de la clé publique |

- **L'ID d'Issuer est une valeur entière.** Une même valeur désigne le même Issuer (`0x0001` et `0x00000001` sont la même valeur). La largeur ne fait pas partie de l'identifiant.
- **La forme canonique est la largeur la plus courte.** On écrit sur la largeur la plus courte qui contienne la valeur, et la notation sur une largeur plus grande est rejetée. L'attribution de chaque largeur commence donc à la valeur qui suit la fin de la plage de la largeur immédiatement inférieure (les 2 WORD à partir de `0x00010000`).

## Table des Issuer de 1 WORD

Les Issuer de 1 WORD sont attribués par geul.org aux organismes de normalisation et aux grandes institutions. Les formats propres conçus par GEUL se placent sous `GEUL`, les normes de fait ou formats d'usage sans organisme normalisateur sous `ADHOC`.

| Issuer | Nom | Organisme | Formats représentatifs |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | Formats propres à GEUL, livre de codes |
| `0x0001` | ADHOC | geul.org | Formats d'usage sans organisme normalisateur. BFLOAT16, BLAKE3, complexes, fractions, intervalles, quaternions, vecteurs, tenseurs |
| `0x0002`~`0x000F` | Réservé | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601, ISO 4217 (monnaies), ISO 3166 (pays) |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000 (notation des unités) |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | Normes ISO/IEC des technologies de l'information |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509, X.690 (encodage ASN.1) |
| `0x0014`~`0x001F` | Réservé | Organismes de normalisation internationaux | |
| `0x0020` | IETF | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4 et IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | Types de médias, registre des sous-balises de langue |
| `0x0022` | W3C | World Wide Web Consortium | Types de données XML Schema, RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0024` | UNICODE | Unicode Consortium | Encodage des caractères, normalisation, CLDR |
| `0x0025` | ECMA | Ecma International | JSON (ECMA-404) |
| `0x0026`~`0x003F` | Réservé | Organismes de normalisation de l'internet et du web | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | Virgule flottante et decimal IEEE 754, adresses MAC (802) |
| `0x0041` | KHRONOS | Khronos Group | Formats de pixels (RGBA8 et BGRA8 UNORM), glTF |
| `0x0042` | OGC | Open Geospatial Consortium | Coordonnées et boîtes englobantes, famille GeoJSON |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN, E4M3FNUZ, E5M2, E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | Formats Microscaling (E8M0, FP4 E2M1) |
| `0x0045` | OASIS | OASIS Open | Normes de documents et de sécurité |
| `0x0046`~`0x005F` | Réservé | Organismes de normalisation industriels | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | Unités SI, TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | Secondes intercalaires, UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x0063` | GPS | Entité gouvernementale exploitant le GPS | Temps GPS |
| `0x0064`~`0x00FF` | Réservé | Organismes de métrologie et gouvernementaux | |
| `0x0100` | KATS | Agence coréenne de la technologie et des normes | Normes KS |
| `0x0101`~`0x01FF` | Réservé | Organismes nationaux de normalisation | |
| `0x0200`~`0xFFFF` | Réservé | Attributions ultérieures | |

- Un format d'extension se place sous l'Issuer de l'organisme qui a établi ce format. Les numéros de format sous un Issuer sont définis par chaque Issuer.
- Les bits de poids fort d'un numéro de format doivent suivre la règle de famille du Kind concerné. On connaît ainsi la famille sans livre de codes.
- Si un organisme de normalisation ne gère pas lui-même les numéros de format GEUL, geul.org répertorie ses normes à sa place sous forme de numéros. Le numéro est consigné avec l'identifiant du document normatif.
- L'attribution se fait des numéros bas vers les numéros hauts dans la plage de l'organisme. Les plages sont un confort de classement, et le décodeur n'a pas l'obligation de les interpréter.

## Issuer de 16 WORD

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID d'algorithme de signature (2 octets) ‖ clé publique)
```

- Les 32 octets du résultat s'écrivent sur 16 WORD, octet de poids fort en premier.
- N'importe qui peut en créer un sans enregistrement. La propriété se prouve par la signature de la clé privée.
- La clé publique et l'algorithme se déclarent par [ISSUER-KEY](/fr/grammar/meta/verification/issuer-key/) dans le HEAD du document. L'algorithme de signature `0x0001` est Ed25519 ; les autres valeurs sont réservées.
- Le préfixe `GEUL-ISSUER-v1` évite d'obtenir le même ID quand la même clé sert à un autre usage (séparation des usages).
- Même si l'algorithme de signature change (par ex. Ed25519 → ML-DSA), la largeur de l'ID reste de 16 WORD.
- Si le résultat est inférieur à `2^64` (probabilité quasi nulle), on ne crée pas d'Issuer avec cette clé, car cela entrerait en conflit avec la règle de la largeur la plus courte.

## Preuve de domaine

- La preuve de propriété de domaine d'un Issuer de 2 WORD n'est vérifiée qu'au moment de l'enregistrement. La gestion ultérieure du domaine relève de la responsabilité de l'Issuer.
- Un domaine ne correspond qu'à un seul Issuer. Un Issuer peut avoir plusieurs domaines. La correspondance s'écrit par BIND dans l'index des noms d'Issuer `issuers.geul` ([Adresse de publication et liste des versions](/fr/grammar/publishing/#nom-dissuer)).
- Même si le domaine expire ou change de mains, la correspondance reste à l'Issuer qui l'a prouvé en premier. Le nouveau propriétaire ne peut pas utiliser ce domaine comme nom d'Issuer.
- Le nom de domaine sert à la saisie et à l'affichage d'adresses. Dans un document GEUL, on n'écrit que l'ID d'Issuer.

## Document de définition de terme

- Les termes définis par un Issuer (outils, programmes, rôles, concepts internes à une organisation) se placent à raison d'**un document par terme**. Le terme est le LOCAL de ce document, son nom se lie par [BIND](/fr/grammar/edge/bind/), et la cible externe qu'il désigne (URI, etc.) se relie par [REFERENCE-NODE](/fr/grammar/edge/reference-node/).
- Les autres documents désignent un terme par `EXTERNAL-ISSUER-*` (Issuer, ID de document, LOCAL ID). On ne répète pas la même définition dans chaque document. Exemple : l'outil de [TRANSFORMED-BY](/fr/grammar/meta/lineage/transformed-by/).
- La plage d'ID de document des documents de définition de termes est fixée par l'Issuer. geul.org (`0x0000`) emploie `0x0001xxxx xxxxxxxx` ([Documents de spécification de Codec](/fr/grammar/codec-spec/#id-de-document-de-lissuer-geul)).
- L'ID de document `0x0000000000000000` de chaque Issuer est réservé au **document d'index des définitions de termes** de cet Issuer : `<Issuer>/0x0000000000000000/`. C'est l'endroit où l'on énumère les documents de définition de termes.
- Le document d'index est **recommandé** à tous les Issuer. Il n'est pas obligatoire. À défaut, les documents de définition de termes se trouvent par l'index des noms `documents.geul`.
- Ordre pour désigner une cible externe : (1) un Codec de Reference adapté s'il existe (WIKIDATA-QID, etc.), (2) un document GEUL qui définit cette cible s'il existe (DOC-POINTER, EXTERNAL-ISSUER), (3) sinon, on la définit comme LOCAL dans son propre document de définition de terme et on la désigne.

## Mode de publication des documents

| Mode | Concerne | Licence | Gestion des versions | Pérennité |
|---|---|---|---|---|
| Confidentiel | Tout Issuer | Interne à l'Issuer | Issuer | Dépend de l'Issuer |
| Publication sur geul.org | Issuer de 1 et 2 WORD | CC0 | geul.org | Conservé par geul.org |
| Publication privée | Tout Issuer | Fixée par l'Issuer | Issuer | Dépend de l'Issuer |

### Publication sur geul.org

- Les Issuer de 1 et 2 WORD peuvent enregistrer et publier leurs documents sur geul.org. Les documents enregistrés sont en CC0.
  - Un Issuer de 1 WORD publie après examen préalable par geul.org.
  - Un Issuer de 2 WORD est publié dès l'enregistrement, et les problèmes sont traités après coup.
- Les définitions publiables sont les concepts et les codecs. **Une Reference désignant une personne physique ne peut pas être publiée sur geul.org.** On passe par le mode confidentiel ou la publication privée.
  - Exception : désigner une personne physique par [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) est autorisé.
- Une version enregistrée ne se modifie ni ne s'efface, et le document reste même si l'Issuer disparaît (conservation du droit ancien). Les exceptions sont la suppression légale et la suppression d'office ([TOMBSTONE](/fr/grammar/edge/publication/)).
- L'Issuer ne peut apposer sur une définition qu'une recommandation d'abandon (deprecated). Une définition ainsi recommandée continue d'être interprétée.
- Une nouvelle version du même document peut créer, réviser ou supprimer des définitions ([Document](/fr/grammar/document/#révision)). **Un ID d'entité ou un numéro de format supprimé n'est pas réutilisé pour une autre cible.** La disposition wire d'un numéro de format ne se révise pas.

### Publication privée

- Un Issuer qui veut publier sous une licence autre que CC0 sert ses documents sur un réseau privé (domaine propre, etc.). La licence se déclare par [LICENSE](/fr/grammar/meta/policy/license/) dans le HEAD du document.
- La publication privée emploie les mêmes chemins que geul.org ([Adresse de publication et liste des versions](/fr/grammar/publishing/)).
- La gestion des versions, la disponibilité, la conservation du domaine et les conditions de licence sont fixées par l'Issuer. geul.org n'intervient pas dans la publication privée et ne la garantit pas.

### Confidentiel

- Un document confidentiel n'est pas publié. On applique un contrôle d'accès et on l'indique par [ACCESS](/fr/grammar/meta/policy/access/).
- Si l'on envoie à l'extérieur un document utilisant des définitions confidentielles, le destinataire ne peut pas interpréter ces Reference, Value et Edge et les saute. Les définitions à échanger avec l'extérieur se publient.

### Le choix de l'utilisateur

- L'utilisateur choisit les documents à employer d'après la licence déclarée et la pérennité probable de l'Issuer.
- Les définitions sous une licence trop restrictive, ou d'un Issuer dont la pérennité est incertaine, ne seront pas utilisées.
- Pour les références qui doivent se conserver longtemps, on emploie les documents publiés sur geul.org.

## Signature

- La signature est obligatoire pour les documents publiés. On la place dans le HEAD par [SIGNATURE](/fr/grammar/meta/verification/signature/). Un document sans signature est aussi un document GEUL valide, et les documents confidentiels ou internes sont eux aussi signés si possible.
- L'objet de la signature est le **hachage du contenu** du document ([Document](/fr/grammar/document/#hachage-du-contenu)). On ne signe pas le BODY seul.
  - Le HEAD contient des règles d'interprétation. Si l'on change la cible d'un `IMPORT-DOC`, le même BODY désigne une autre cible.
  - Sans signer `LICENSE` et `PARENT`, on pourrait falsifier la licence et l'historique.
- Un document peut porter plusieurs signatures. Elles signent toutes le même hachage du contenu, donc ajouter une signature ne change pas le hachage du contenu.
- Vérification de la clé de signature :
  - Issuer de 1, 2 ou 4 WORD : la clé enregistrée auprès de geul.org (publication des clés de vérification ci-dessous).
  - Issuer de 16 WORD : l'`ISSUER-KEY` du même document. L'ID d'Issuer calculé à partir de cette clé publique doit être égal au signataire.
- Sans signature, le lecteur abaisse la confiance ; si la signature existe mais que la vérification échoue, c'est une preuve de falsification ou d'usurpation, et il l'abaisse davantage.
- La signature d'un document est faite par l'Issuer de ce document, celle de la liste des versions par l'éditeur qui a attribué les ID de version ([Adresse de publication et liste des versions](/fr/grammar/publishing/#signataire)).

## Publication des clés de vérification

- geul.org publie les clés de vérification de signature des Issuer enregistrés (1, 2, 4 WORD).
- La liste des clés paraît comme document publié de l'Issuer GEUL (`0x0000`). Elle est en CC0 et signée par geul.org.
  - Éléments : Issuer, ID d'algorithme de signature, clé publique, instant de début de validité, instant et motif de révocation.
- Les clés révoquées ne sont pas effacées. Les signatures passées se vérifient avec la clé valide au moment de la signature.
- Le changement de clé s'enregistre en signant la nouvelle clé avec l'ancienne. Celui qui vérifie peut constater la continuité des clés sans faire confiance à geul.org.
- L'historique des changements de clé est conservé dans un journal en ajout seul (comme Certificate Transparency ou Go sumdb). Modifier l'historique se verrait.
- Si une clé est perdue et qu'on ne peut plus signer avec l'ancienne, geul.org revérifie l'identité et enregistre une nouvelle clé. Un Issuer de 2 WORD repasse par la preuve de propriété du domaine. Dans ce cas, il faut faire confiance à geul.org, et le motif est consigné dans le journal.
- Les Issuer de 16 WORD ne sont pas concernés. L'ID d'Issuer étant calculé à partir de la clé publique, ils se vérifient par le seul `ISSUER-KEY` du document.

## Import

IMPORT n'importe que des documents.

```
IMPORT-DOC                      DOC-POINTER (Issuer + ID de document + ID de version) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + ID de document + LOCAL ID (sans IMPORT)
ISSUER-POINTER                  Issuer (l'Issuer lui-même)
DOC-POINTER                     Issuer + ID de document + ID de version (2 WORD, 0 = dernière)
```

- On peut désigner un Issuer de n'importe quelle largeur et ses documents sans IMPORT, par un pointeur-déclaration. L'Issuer lui-même par `ISSUER-POINTER`, le document lui-même par `DOC-POINTER`, un LOCAL du document par `EXTERNAL-ISSUER-*`. Un pointeur-déclaration suit la dernière version ; pour figer la version, on emploie `IMPORT-DOC` (ID de version) et `EXTERNAL-POINTER-*`.
- Les Reference du corps n'emploient pas le chemin complet (Issuer + document + ID de cible) mais seulement IMPORT ID + ID de cible.
- La largeur de l'IMPORT ID est fixée par la longueur dans `IMPORT-DOC` et par le Codec dans `EXTERNAL-POINTER-*`. Elle ne vaut qu'à l'intérieur de ce document ([IMPORT-DOC](/fr/grammar/meta/import/import-doc/)).
- Importé sans ID de version, on suit la dernière version. Si l'on indique un ID de version, on est figé sur cette version. Les documents publiés indiquent un ID de version.

## Licence

- Les documents publiés sur geul.org et les documents de l'Issuer GEUL (`0x0000`) sont en CC0.
- La licence d'un document à publication privée est fixée par l'Issuer. GEUL ne l'impose pas.
- Les productions centrales de GEUL ne reproduisent pas le contenu des documents d'Issuer qui ne sont pas en CC0.

## Problèmes ouverts

- Faut-il autoriser la publication sur geul.org pour les Issuer de 4 et 16 WORD.
- Méthode de preuve de propriété du domaine (DNS TXT `_geul.<domaine>`, HTTP `.well-known`) et lier ou non l'empreinte de la clé de signature à la valeur de preuve.
- Parade au détournement de domaine lors de la récupération d'une clé perdue. Si l'on enregistre une nouvelle clé sur la seule revérification du domaine, un voleur de domaine peut s'emparer de l'Issuer. On étudie la vérification du contact d'enregistrement, un délai de grâce avec objection de l'ancienne clé, et l'application du résultat des litiges de domaine.
- Format d'enregistrement du document d'index des définitions de termes (ID de document `0`) (Edge énumérant les documents de définition de termes).
- Valeur par défaut de l'algorithme de signature (Ed25519 recommandé).
