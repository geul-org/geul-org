---
title: "Issuer et publication"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL ne rassemble pas le système d'identification en un seul lieu."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL ne rassemble pas le système d'identification en un seul lieu. Chaque Issuer définit ses objets et ses formats, et les autres documents reprennent les définitions publiées. Une définition peut rester confidentielle, être publiée sur geul.org (CC0) ou publiée à titre privé (sous la licence que fixe l'Issuer). C'est l'utilisateur qui décide quelle définition croire et utiliser.

L'adresse de publication, la désignation des formats, la liste des Issuer, la liste des versions et les couches de confiance sont fixées par [adresse de publication et liste des versions](publishing.md).

## Ce que définit un Issuer {#issuer가-정의하는-것}

| Objet | Méthode |
|---|---|
| Objet (entité, concept, terme) | Déclaré comme LOCAL de son propre document |
| Format de Reference | Défini sous le code de l'Issuer par un numéro de Codec de 2 WORD |
| Format de Value | Défini sous le code de l'Issuer par un numéro de Codec de 2 WORD |
| Format d'Edge | Défini sous le code de l'Issuer par un numéro de Codec de 2 WORD |

- La définition des formats de Reference, Value et Edge est elle aussi publiée sous forme de document.

## Principes {#원칙}

- Un objet défini par un Issuer est un LOCAL du document publié par cet Issuer. Les autres documents le citent directement par une déclaration de désignation (`EXTERNAL-ISSUER-*`), ou l'importent par `IMPORT-DOC` et le désignent par `EXTERNAL-POINTER-*`. Le sens d'un enregistrement [REFERENCE-ISSUER](reference/_index.md#reference-issuer) est fixé par le document de Codec que l'Issuer a émis.
- Pour un objet qui doit être désigné depuis l'extérieur d'un document, on attribue un LOCAL du document publié. Ce document doit posséder un [DOC-ID](meta/0x1C7L-doc-id.md).

## Catégories d'Issuer {#issuer-등급}

| Largeur | Plage de valeurs | Attribution |
|---|---|---|
| 2 WORD | `0x00000000`~`0xFFFFFFFF` | Enregistrement auprès de geul.org. Passe par une preuve de propriété du domaine. Les numéros que geul.org attribue aux organismes de normalisation et aux grandes institutions ont aussi cette largeur ([table d'attribution des 2 WORD](#2-word-배정표)) |
| 4 WORD | `2^32`~`2^64−1` | Enregistrement auprès de geul.org. Sans preuve de propriété |
| 16 WORD | `2^64` et plus | Auto-émission. Calculé à partir de la clé publique |

- **L'ID d'Issuer est une valeur entière.** Deux valeurs égales désignent le même Issuer. La largeur ne fait pas partie de l'identifiant.
- **Une notation longue obtenue en ajoutant des zéros devant un ID d'Issuer court désigne le même Issuer** (2 → 4, 2 → 16, 4 → 16 WORD). `0x00000001` et `0x0000000000000001` désignent le même Issuer. C'est pourquoi on n'attribue pas `0x00000000XXXXXXXX` à un Issuer de 4 WORD, ni une valeur dont les 12 WORD de poids fort sont nuls à un Issuer de 16 WORD.
- **La forme canonique est la largeur la plus courte.** Dans un enregistrement, on écrit avec la plus courte largeur qui contient la valeur, et l'on rejette la notation d'une largeur plus grande. L'attribution de chaque largeur commence donc à la valeur qui suit la fin de la plage de la largeur immédiatement inférieure. 2 WORD est la largeur la plus courte. Dans une adresse de publication, on écrit avec le nombre de chiffres de la largeur d'émission (8 chiffres pour 2 WORD, 16 pour 4 WORD, 64 pour 16 WORD) et en hexadécimal majuscule (une adresse écrite en minuscules est convertie en majuscules pour la recherche) ; à la lecture, on accepte aussi la notation élargie comme le même Issuer ([adresse de publication et liste des versions](publishing.md#id-표기)).

## Table d'attribution des 2 WORD {#2-word-배정표}

geul.org attribue dans l'ordre, à partir du début, des numéros d'Issuer de 2 WORD aux organismes de normalisation et aux grandes institutions. Les normes de fait et les formats conventionnels sans organisme de normalisation se placent sous `ADHOC` (`adhoc.geul.org`). Les formats propres conçus par GEUL sont des codes directs. L'Issuer d'un organisme de normalisation est un Issuer de sous-domaine de geul.org. Le nom du sous-domaine est le nom de l'organisme en minuscules (`<nom de l'organisme>.geul.org`, par exemple `iso.geul.org`, `iec.geul.org`). Les domaines figurent dans le tableau ci-dessous.

| Issuer | Nom | Domaine | Organisme | Formats représentatifs |
|---|---|---|---|---|
| `0x00000000` | GEUL | `geul.org` | geul.org | Documents de spécification des codes directs (livre de codes) |
| `0x00000001` | wikidata.geul.org | `wikidata.geul.org` | geul.org | Documents d'éléments et de propriétés Wikidata |
| `0x00000002` | ADHOC | `adhoc.geul.org` | geul.org | Formats conventionnels sans organisme de normalisation. BFLOAT16, BLAKE3, nombres complexes, fractions, intervalles, quaternions, vecteurs, tenseurs |
| `0x00000003` | ISO | `iso.geul.org` | International Organization for Standardization | ISO 8601, ISO 4217 (monnaies), ISO 3166 (pays) |
| `0x00000004` | IEC | `iec.geul.org` | International Electrotechnical Commission | IEC 80000 (notation des unités) |
| `0x00000005` | ISO-IEC-JTC1 | `iso-iec-jtc1.geul.org` | ISO/IEC Joint Technical Committee 1 | Normes ISO/IEC des technologies de l'information |
| `0x00000006` | ITU-T | `itu-t.geul.org` | ITU Telecommunication Standardization Sector | X.509, X.690 (encodage ASN.1) |
| `0x00000007` | IETF | `ietf.geul.org` | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4 et IPv6 |
| `0x00000008` | IANA | `iana.geul.org` | Internet Assigned Numbers Authority | Types de médias, registre des sous-balises de langue |
| `0x00000009` | W3C | `w3c.geul.org` | World Wide Web Consortium | Types de données XML Schema, RDF |
| `0x0000000A` | WHATWG | `whatwg.geul.org` | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0000000B` | UNICODE | `unicode.geul.org` | Unicode Consortium | Encodage des caractères, normalisation, CLDR |
| `0x0000000C` | ECMA | `ecma.geul.org` | Ecma International | JSON (ECMA-404) |
| `0x0000000D` | IEEE | `ieee.geul.org` | Institute of Electrical and Electronics Engineers | IEEE 754 virgule flottante et decimal, adresse MAC (802) |
| `0x0000000E` | KHRONOS | `khronos.geul.org` | Khronos Group | Formats de pixels (RGBA8, BGRA8 UNORM), glTF |
| `0x0000000F` | OGC | `ogc.geul.org` | Open Geospatial Consortium | Coordonnées, boîtes englobantes, famille GeoJSON |
| `0x00000010` | ONNX | `onnx.geul.org` | ONNX (LF AI & Data Foundation) | FP8 E4M3FN, E4M3FNUZ, E5M2, E5M2FNUZ |
| `0x00000011` | OCP | `ocp.geul.org` | Open Compute Project | Formats Microscaling (E8M0, FP4 E2M1) |
| `0x00000012` | OASIS | `oasis.geul.org` | OASIS Open | Normes de documents et de sécurité |
| `0x00000013` | BIPM | `bipm.geul.org` | Bureau International des Poids et Mesures | Unités SI, TAI |
| `0x00000014` | IERS | `iers.geul.org` | International Earth Rotation and Reference Systems Service | Seconde intercalaire, UTC−TAI |
| `0x00000015` | NIST | `nist.geul.org` | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x00000016` | GPS | `gps.geul.org` | Entité gouvernementale exploitant le GPS | Temps GPS |
| `0x00000017` | KATS | `kats.geul.org` | Korean Agency for Technology and Standards (국가기술표준원) | Normes KS |

- Les formats d'extension se placent sous l'Issuer de l'organisme qui a établi ce format. Les numéros de Codec sous un Issuer sont définis par chaque Issuer.
- Les numéros de Codec sont fixés par l'Issuer. GEUL n'en fixe pas le sens. Un numéro de Codec ne se chevauche pas au sein de cet Issuer, quel que soit le Kind ([adresse de publication et liste des versions](publishing.md#id-표기)).
- Si un organisme de normalisation ne gère pas lui-même les numéros de Codec GEUL, geul.org inscrit ses normes en son nom sous forme de numéros. Le numéro est enregistré avec l'identifiant du document normatif.
- Un nouvel organisme de normalisation reçoit le prochain numéro libre.
- **Les domaines peuvent changer.** Le lien entre un Issuer et un domaine peut changer par la suite. L'ID d'Issuer ne change pas. Lorsque l'organisme gère lui-même son Issuer, on remplace par son domaine officiel.
- **Les sous-domaines de geul.org ne sont pas des éditeurs officiels.** Un sous-domaine de geul.org portant le nom d'un organisme de normalisation n'est pas l'éditeur officiel de cet organisme. Par exemple, `iso.geul.org` n'est pas l'éditeur officiel de l'ISO.

## Issuer de 16 WORD {#16-word-issuer}

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID de l'algorithme de signature (2 octets) ‖ clé publique)
```

- Les 32 octets du résultat s'écrivent sur 16 WORD, octet de poids fort d'abord.
- Tout le monde peut en créer un sans enregistrement. La propriété se prouve par la signature de la clé privée.
- La clé publique et l'algorithme sont déclarés par [ISSUER-KEY](meta/0x1E5L-issuer-key.md) dans le HEAD du document. L'algorithme de signature `0x0001` est Ed25519, les autres valeurs sont Reserved.
- Le préfixe `GEUL-ISSUER-v1` évite d'obtenir le même ID quand la même clé sert à un autre usage (séparation des usages).
- Même si l'algorithme de signature change (par exemple Ed25519 → ML-DSA), la largeur de l'ID reste de 16 WORD.
- Si le résultat est inférieur à `2^64` (probabilité pratiquement nulle), on ne crée pas d'Issuer avec cette clé, car cela empiéterait sur la règle de la plus courte largeur.

## Preuve de domaine {#도메인-증명}

- La preuve de propriété du domaine d'un Issuer de 2 WORD n'est vérifiée qu'au moment de l'enregistrement. Ensuite, la gestion du domaine relève de la responsabilité de l'Issuer.
- Un domaine ne correspond qu'à un seul Issuer. Un Issuer peut avoir plusieurs domaines. La correspondance s'écrit par BIND dans la liste des Issuer `issuers/` ([adresse de publication et liste des versions](publishing.md#issuer-목록)).
- Même si le domaine expire ou change de main, la correspondance reste attachée à l'Issuer qui l'a prouvé en premier. Le nouveau propriétaire ne peut pas utiliser ce domaine comme nom d'Issuer.
- Le nom de domaine sert à la saisie et à l'affichage pour l'interpréteur et la CLI. Ce n'est pas une adresse URL de publication ([adresse de publication et liste des versions](publishing.md#도메인-이름)). Dans un document GEUL, on n'écrit que l'ID d'Issuer.

## Documents de définition de termes {#용어-정의-문서}

- Les termes définis par un Issuer (outils, programmes, rôles, concepts internes à une organisation) ont **un document par terme**. Le terme est un LOCAL de ce document ; son nom est lié par [BIND](edge/0x0A3L-bind.md) et l'objet externe qu'il désigne (URI, etc.) est relié par [REFERENCE-NODE](edge/0x0A0L-reference-node.md).
- Les autres documents désignent le terme par `EXTERNAL-ISSUER-*` (Issuer, ID de document, LOCAL ID). On ne répète pas la même définition dans chaque document. Exemple : l'outil de [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md).
- La plage d'ID de document des documents de définition de termes est fixée par l'Issuer. geul.org (`0x00000000`) utilise `0x0001xxxx xxxxxxxx`.
- Tout Issuer réserve les ID de document `0x0000000000000000` et `0xFFFFFFFFFFFFFFFF`. Leurs usages actuels sont les deux suivants.
- L'ID de document `0x0000000000000000` est la place du **document d'index des définitions de termes** de cet Issuer : `<Issuer>/docs/0x0000000000000000/`. C'est la place où l'on énumère les documents de définition de termes.
- L'ID de document `0xFFFFFFFFFFFFFFFF` sert à la liste des Issuer `issuers/` de l'Issuer geul.org (`0x00000000`). Les autres Issuer n'utilisent pas cet ID. Cet ID n'est reçu pour aucun Issuer à l'adresse `<Issuer>/docs/<ID de document>/` (404) ([adresse de publication et liste des versions](publishing.md#목록-문서)).
- Le document d'index est **recommandé** à tous les Issuer. Il n'est pas obligatoire.
- Ordre pour désigner un objet externe : (1) s'il existe un Codec Reference adapté, celui-ci (WIKIDATA-QID, etc.) ; (2) s'il existe un document GEUL qui définit cet objet, celui-ci (DOC-POINTER, EXTERNAL-ISSUER) ; (3) sinon, on le définit comme LOCAL dans son propre document de définition de termes et on le désigne.

## Modes de publication des documents {#문서-공개-방식}

| Mode | Cible | Licence | Gestion des versions | Pérennité |
|---|---|---|---|---|
| Confidentiel | Tous les Issuer | Interne à l'Issuer | Issuer | Dépend de l'Issuer |
| Publication geul.org | Issuer de 2 WORD | CC0 | geul.org | Conservé par geul.org |
| Publication privée | Tous les Issuer | Fixée par l'Issuer | Issuer | Dépend de l'Issuer |

### Publication geul.org {#geulorg-공표}

- Un Issuer de 2 WORD peut publier un document en l'enregistrant sur geul.org. Les documents enregistrés sont CC0. Une fois enregistré, il est aussitôt publié, et les problèmes sont traités a posteriori.
- Les définitions publiables sont les concepts et les Codecs. **Une Reference désignant une personne physique ne peut pas être publiée sur geul.org.** On passe par le mode confidentiel ou la publication privée.
  - Exception : désigner une personne physique par [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) est permis.
- Une version enregistrée n'est ni modifiée ni supprimée, et le document subsiste même si l'Issuer disparaît (conservation de l'ancienne loi). Les exceptions sont la suppression légale et la suppression d'office ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- L'Issuer peut seulement marquer une définition d'une recommandation d'abandon (deprecated). Une définition ainsi recommandée continue d'être interprétée.
- Une nouvelle version d'un même document peut créer, réviser ou supprimer des définitions ([Document](document.md#개정)). **Les ID d'entité et numéros de Codec supprimés ne sont pas réutilisés pour d'autres objets.** La disposition wire d'un numéro de Codec n'est pas révisée.

### Publication privée {#사설-공표}

- Un Issuer qui veut publier sous une licence autre que CC0 sert ses documents sur un réseau privé (domaine propre, etc.). La licence est déclarée par [LICENSE](meta/0x1DEL-license.md) dans le HEAD du document.
- La publication privée utilise les mêmes chemins que geul.org ([adresse de publication et liste des versions](publishing.md)).
- La gestion des versions, la disponibilité, le maintien du domaine et les conditions de licence sont fixés par l'Issuer. geul.org n'intervient pas dans la publication privée et ne la garantit pas.

### Confidentiel {#대외비}

- Un document confidentiel n'est pas publié. On le soumet à un contrôle d'accès et on l'indique par [ACCESS](meta/0x1DFL-access.md).
- Si l'on envoie à l'extérieur un document qui utilise une définition confidentielle, le destinataire ne peut pas interpréter ces Reference, Value et Edge et les saute. Les définitions à échanger avec l'extérieur doivent être publiées.

### Choix de l'utilisateur {#사용자의-선택}

- L'utilisateur choisit les documents à utiliser d'après la licence déclarée et la pérennité probable de l'Issuer.
- Les définitions sous une licence trop restrictive, ou d'un Issuer dont la pérennité est incertaine, ne sont pas utilisées.
- Pour une référence qui doit être conservée longtemps, on utilise un document publié sur geul.org.

## Signature {#서명}

- La signature est obligatoire pour un document publié. On la place dans le HEAD par [SIGNATURE](meta/0x1E6L-signature.md). Un document sans signature reste un document GEUL valide, et l'on signe aussi si possible les documents confidentiels et internes.
- Ce qui est signé est le **hachage du contenu** du document ([Document](document.md#내용-해시)). On ne signe pas le BODY seul.
  - Le HEAD contient des règles d'interprétation. Si l'on change la cible d'un `IMPORT-DOC`, le même BODY désigne une autre cible.
  - Si `LICENSE` et `PARENT` ne sont pas signés, on peut falsifier la licence et l'historique.
- Un document peut porter plusieurs signatures. Toutes signent le même hachage du contenu, donc ajouter une signature ne change pas le hachage du contenu.
- Vérification de la clé de signature :
  - Issuer de 2 ou 4 WORD : clé enregistrée auprès de geul.org (clés de vérification publiées ci-dessous).
  - Issuer de 16 WORD : `ISSUER-KEY` du même document. L'ID d'Issuer calculé à partir de cette clé publique doit être égal au signataire.
- Le lecteur abaisse la confiance en l'absence de signature, et l'abaisse davantage si une signature présente échoue à la vérification, car c'est la preuve d'une falsification ou d'une usurpation.
- La signature d'un document est faite par l'Issuer de ce document, et celle de la liste des versions par l'éditeur qui a attribué les ID de version ([adresse de publication et liste des versions](publishing.md#서명-주체)).

## Publication des clés de vérification {#검증키-공개}

- geul.org publie les clés de vérification de signature des Issuer enregistrés (2 et 4 WORD).
- La liste des clés est émise comme document publié de l'Issuer GEUL (`0x00000000`). Elle est CC0 et signée par geul.org.
  - Entrées : Issuer, ID de l'algorithme de signature, clé publique, instant de début de validité, instant et motif de révocation.
- Une clé révoquée n'est pas non plus effacée. Une signature passée se vérifie avec la clé qui était valide à l'instant de la signature.
- Le remplacement d'une clé s'enregistre en signant la nouvelle clé avec l'ancienne. Le vérificateur peut ainsi confirmer la continuité de la clé sans faire confiance à geul.org.
- L'historique des changements de clé est conservé dans un journal en ajout seul (comme Certificate Transparency ou Go sumdb). Toute modification de l'historique se voit.
- Si une clé est perdue et qu'on ne peut plus signer avec l'ancienne, geul.org revérifie l'identité et enregistre la nouvelle clé. Un Issuer de 2 WORD repasse par la preuve de propriété du domaine. Dans ce cas, il faut faire confiance à geul.org, et le motif est consigné dans le journal.
- Les Issuer de 16 WORD ne sont pas concernés. L'ID d'Issuer étant calculé à partir de la clé publique, on vérifie uniquement avec l'`ISSUER-KEY` du document.

## Importation {#가져오기}

IMPORT n'importe que des documents.

```
IMPORT-DOC                      DOC-POINTER(Issuer + ID de document + ID de version) + ID d'IMPORT
                                un document de Codec : CODEC-POINTER(Issuer + ID de Codec + ID de version) + ID d'IMPORT
EXTERNAL-POINTER-1/2/4WORD      ID d'IMPORT + LOCAL ID
EXTERNAL-ISSUER-2/4/16WORD      Issuer + ID de document + LOCAL ID (sans IMPORT)
ISSUER-POINTER                  Issuer (l'Issuer lui-même)
DOC-POINTER                     Issuer + ID de document + ID de version (2 WORD, 0 = dernière)
CODEC-POINTER                   Issuer + ID de Codec + ID de version (2 WORD, 0 = dernière)
```

- Un Issuer de n'importe quelle largeur et ses documents peuvent être désignés sans IMPORT par une déclaration de désignation. L'Issuer lui-même par `ISSUER-POINTER`, le document lui-même par `DOC-POINTER`, un LOCAL du document par `EXTERNAL-ISSUER-*`. Une déclaration de désignation suit la dernière version ; pour fixer la version, on utilise `IMPORT-DOC` (ID de version) et `EXTERNAL-POINTER-*`.
- Une Reference du corps désignant un objet d'un document externe n'écrit que l'ID d'IMPORT + l'ID de l'objet, au lieu du chemin complet (Issuer + document + ID de l'objet). [REFERENCE-ISSUER](reference/_index.md#reference-issuer) écrit l'Issuer et le numéro de Codec.
- La largeur de l'ID d'IMPORT est fixée par la longueur dans `IMPORT-DOC` et par le Codec dans `EXTERNAL-POINTER-*` ([IMPORT-DOC](meta/0x1E4L-import-doc.md)).
- Importé sans ID de version, on suit la dernière version. Avec un ID de version, on est fixé sur cette version. Les documents publiés indiquent l'ID de version.

## Licence {#라이선스}

- Les documents publiés sur geul.org et les documents de l'Issuer GEUL (`0x00000000`) sont CC0.
- La licence d'un document publié à titre privé est fixée par l'Issuer. GEUL ne l'impose pas.
- **Licence des formats d'Issuer.** Seuls les codes directs et les publications fournis par geul.org sont CC0. La licence d'un format d'Issuer est fixée par cet Issuer.
- **Indication de l'Issuer.** GEUL fait reposer Resolve sur l'indication de l'Issuer. Dans un document qui utilise le Codec d'un autre Issuer, cet Issuer est toujours indiqué.
- Les produits centraux de GEUL ne reproduisent pas le contenu des documents d'Issuer non CC0.

## Problèmes ouverts {#열린-문제}

- La méthode de preuve de propriété du domaine (DNS TXT `_geul.<domaine>`, HTTP `.well-known`) et la question de lier l'empreinte de la clé de signature à la valeur de preuve.
- La parade au détournement de domaine lors de la récupération d'une clé perdue. Si l'on enregistre une nouvelle clé par la seule nouvelle preuve de domaine, l'auteur du détournement peut s'emparer de l'Issuer. On étudie la vérification du contact d'enregistrement, un délai de grâce avec contestation par l'ancienne clé, et l'application mutatis mutandis du résultat d'un litige de domaine.
- Le format d'enregistrement du document d'index des définitions de termes (ID de document `0`) (l'Edge qui énumère les documents de définition de termes).
- La valeur par défaut de l'algorithme de signature (Ed25519 recommandé).
