---
title: "Structure d'un enregistrement"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Les données GEUL sont une suite d'enregistrements."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Les données GEUL sont une suite d'enregistrements. Tout enregistrement commence par un TAG WORD.

## Disposition d'un enregistrement {#레코드-레이아웃}

```
TAG WORD (16 bits)
┌──────────┬──────────┬──────────┬──────────┐
│  Prefix  │   Kind   │  Class   │  Length  │
│   3bit   │   4bit   │   5bit   │   4bit   │
│   000    │   KKKK   │  CCCCC   │   LLLL   │
└──────────┴──────────┴──────────┴──────────┘
[TAG d'extension de Length]
[TAG d'extension de Codec]
[TAG propre au Codec]
Payload
```

- Le TAG WORD est `000K KKKC CCCC LLLL`. Les 4 bits de poids fort `KKKK` forment la section `S = w >> 9`, et une section compte 32 cases. `C` est le décalage de 5 bits dans la section, `(w >> 4) & 0x1F`.
- Le TAG ID s'écrit `0x000L`. Les trois premiers chiffres forment l'emplacement Codec de 9 bits (`w >> 4`), qui réunit la section et `C`, et `L` est l'emplacement Length. Dans la valeur réelle du WORD, on met un chiffre à la place de L (exemple : TRIPLE est `0x0AAL`, et le TAG WORD d'un TRIPLE de 10 WORD est `0x0AA9`).
- Les TAG d'extension ne se placent que dans l'ordre ci-dessus. Le TAG d'extension de Length vient toujours juste après le TAG WORD.
- La composition du TAG propre au Codec et du Payload est fixée par la spécification de chaque Codec. La longueur du TAG propre au Codec n'est pas notée dans le TAG WORD, car interpréter le Payload exige de toute façon le livre de codes.
- Un Codec ayant des sous-formats les désigne par un TAG propre au Codec de 1 WORD (Edge WORLD, etc.).

## Ordre des octets {#바이트-순서}

- La sérialisation canonique est big-endian.
- Les champs de bits sont disposés à partir du bit de poids fort.
- Dans un WORD, l'octet de poids fort vient en premier ; pour une valeur de plusieurs WORD, le WORD de poids fort vient en premier.
- La représentation en mémoire est laissée à l'implémentation.

## Kind (plage de sections) {#kind-섹션-구간}

| Section | Kind | TAG ID | Définition |
|---|---|---|---|
| 0~2 | Reference | `0x000L~0x05FL` | Désigne un objet. Identifie l'objet par le Codec et l'ID de l'objet |
| 3·4 | Value | `0x060L~0x09FL` | Contient la valeur elle-même. Le Codec fixe l'interprétation du Payload |
| 5~13 | Edge | `0x0A0L~0x1BFL` | Réunit d'autres enregistrements comme composants. Le Codec fixe le rôle et l'ordre des composants |
| 14·15 | Meta | `0x1C0L~0x1FFL` | Parle du document et des enregistrements |

- Le Kind se détermine par une seule plage de sections : `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, le reste Meta. Il n'y a pas d'exception.

- Le Kind est une propriété immuable du Codec. Un Codec une fois attribué ne change pas de Kind.
- Value et Edge ont le même format « Codec + Payload ». Seul Edge a d'autres enregistrements comme composants.
- Reference répartit en tableaux de codes les marqueurs, les pointeurs, le système 5Q et REFERENCE-ISSUER. La quantification est dans les codes du système. La quantification de REFERENCE-ISSUER est fixée par le document de l'Issuer ([Reference](reference/_index.md)).

## Length (4 bits) {#length-4비트}

Length est le **nombre total de WORD** que l'enregistrement occupe. Il inclut le TAG WORD, les TAG d'extension, le Payload et le bourrage du dernier WORD.

| Valeur | Sens |
|---|---|
| `0000`~`1101` | 1 à 14 WORD (valeur + 1) |
| `1110` | Longueur étendue 1 : le nombre total de WORD dans le WORD suivant (15 à 65 535) |
| `1111` | Longueur étendue 2 : le nombre total de WORD dans les 2 WORD suivants (65 536 à 2³²−1) |

- De 1 à 14 WORD, on écrit impérativement la longueur directe. Une notation plus large n'est pas la forme canonique.
- Le nombre total de WORD de la longueur étendue inclut le TAG d'extension de Length lui-même.
- Aucun enregistrement ne dépasse 2³²−1 WORD.
- Un enregistrement de 1 WORD est un TAG WORD seul, sans Payload. On ne l'utilise que si la spécification du Codec l'autorise (exemples : Meta `BODY`, `END`, séquence d'octets vide, marqueur d'emplacement).
- Même sans livre de codes, on peut sauter un enregistrement par `position de l'enregistrement suivant = début de l'enregistrement courant + Length`.

## Codec (section et C, 9 bits) {#codec-섹션과-c-9비트}

| TAG ID | Nom | Sens |
|---|---|---|
| Début de chaque zone de Kind | Code direct | Le Codec est fixé par le seul TAG WORD |
| `0x05DL`, `0x09DL`, `0x1BDL` | REFERENCE-ISSUER-2WORD, VALUE-ISSUER-2WORD, EDGE-ISSUER-2WORD | Issuer de 2 WORD et numéro de Codec de 2 WORD dans le TAG d'extension de Codec |
| `0x05EL`, `0x09EL`, `0x1BEL` | REFERENCE-ISSUER-4WORD, VALUE-ISSUER-4WORD, EDGE-ISSUER-4WORD | Issuer de 4 WORD et numéro de Codec de 2 WORD dans le TAG d'extension de Codec |
| `0x05FL`, `0x09FL`, `0x1BFL` | REFERENCE-ISSUER-16WORD, VALUE-ISSUER-16WORD, EDGE-ISSUER-16WORD | Issuer de 16 WORD et numéro de Codec de 2 WORD dans le TAG d'extension de Codec |

- **Les trois dernières cases de chaque zone de Kind sont ISSUER.** La largeur de l'Issuer est donnée par les 2 bits de poids faible de C (`01` 2 WORD, `10` 4 WORD, `11` 16 WORD). Meta n'a pas de format d'Issuer.
- Le `C` d'un code direct existe séparément pour chaque section. Une même valeur de `C` dans une autre section désigne un autre Codec. L'ID de Codec d'un code direct est le TAG WORD entier (L=0), donc il contient le Kind.
- Le numéro de Codec d'Issuer forme un seul espace par Issuer, quel que soit le Kind. L'Issuer l'attribue sans chevauchement dans son propre `codecs/` ([adresse de publication et liste des versions](publishing.md#id-표기)).
- Un Codec qui n'est pas un code direct est un couple `(Issuer, numéro de Codec)`. Le numéro de Codec est défini par cet Issuer ([Issuer et publication](issuer.md)). Les formats d'extension se placent sous l'Issuer de l'organisme qui a établi ce format.
- Un Codec qui a un code direct n'est pas inscrit séparément sous forme d'Issuer.
- Les formats d'Issuer existent pour Reference, Value et Edge. Meta est une spécification commune que seul GEUL définit.
- La section d'un code direct d'Edge (`w >> 9`) est la famille. Pour les codes directs de Value et pour Meta, la famille et la classe ne sont pas représentées par des bits. Le sens du numéro de Codec est fixé par l'Issuer.
- Un code direct ne peut pas être repris. On ne place en code direct que les formats dont la fréquence est confirmée.

## Enregistrement de format d'Issuer {#issuer-형식-레코드}

```
TAG WORD          code ISSUER (les trois dernières cases de chaque zone de Kind)
[TAG d'extension de Length]
Issuer            2/4/16 WORD (le Codec fixe la largeur)
numéro de Codec   2 WORD. Défini par l'Issuer
Payload           fixé par le document de Codec émis par l'Issuer
```

- Les trois Kind ont la même disposition. Si les numéros viennent à manquer, on obtient un Issuer de plus.
- Le Payload d'un Edge (EDGE-ISSUER) commence par l'Edge Id comme celui des autres Edge. L'ordre est donc TAG, Issuer, numéro de Codec, Edge Id, reste du Payload.
- Un décodeur qui ignore le format lit jusqu'à l'Issuer et au numéro de Codec, puis saute grâce à Length.

## Séquences d'octets de longueur variable {#가변-길이-바이트열}

Pour les valeurs dont la longueur est en octets, comme le texte, l'URI, la balise de langue ou une séquence d'octets inconnue, on attribue le Codec (ou le numéro de Codec) en **paire pair/impair**.

- Si le bit de poids faible du Codec (pour un code direct, celui de C) vaut `0`, le nombre d'octets est pair ; s'il vaut `1`, il est impair.
- Nombre d'octets = `2 × nombre de WORD du Payload − bit de poids faible`. Il n'y a pas de champ Byte Count.
- S'il est impair, l'octet de poids faible du dernier WORD est un bourrage `0x00`. S'il n'est pas `0x00`, on rejette.
- Une séquence d'octets vide est un enregistrement de 1 WORD (le TAG WORD seul) du Codec pair.
- Les valeurs de taille fixe, comme un UUID, un condensat ou une adresse, n'ont pas de paire.

## Exemple : lire un TAG WORD {#예-tag-word-읽기}

Lisons `0AA9`.

```
0x0AA9 = 0000 1010 1010 1001
         000 | 0101 | 01010 | 1001
Prefix 000, section 0101 (5, Edge), C 01010, Codec 0x0AAL (TRIPLE), Length 1001 (10 WORD)
```

Cet enregistrement est un Edge de 10 WORD et son Codec est TRIPLE. Même sans livre de codes, on sait que l'enregistrement suivant se trouve 10 WORD plus loin.

## Marqueur d'emplacement {#자리-표지}

Les TAG WORD `0x0000`, `0x0010` et `0x0020` sont des enregistrements de 1 WORD, marqueurs d'emplacement de Reference. Ils ne désignent aucun objet et occupent l'emplacement d'un champ enregistrement ([marqueur d'emplacement](slot-marker.md)).

```
0x0000, 0x0010, 0x0020 = 0000 0000 00CC 0000
                         Prefix 000, section 0 (Reference), C 0~2, LLLL 0000 (1 WORD)
```

| WORD | Nom | Sens | De quoi parle-t-il | Logique | Hypothèse sur le monde | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | non renseigné | Le document : cet emplacement n'a pas été rempli | aucune assertion | monde ouvert | pas de snak |
| `0x0010` | UNKNOWN-VALUE | inconnu | Le monde : une valeur existe. On ignore laquelle | `∃x. P(s, x)` | existence fermée, identité ouverte | `somevalue` |
| `0x0020` | NO-VALUE | aucune valeur | Le monde : il n'y a pas de valeur | `¬∃x. P(s, x)` | fermé pour (s, P, condition de restriction) | `novalue` |

- Exemple : si le nombre d'enfants (P40) est ABSENT, on ne sait pas combien ; avec UNKNOWN-VALUE, 1 ou plus ; avec NO-VALUE, 0. Si la date de fin (P582) est ABSENT, on ne sait pas si c'est encore valide ; avec UNKNOWN-VALUE, c'est terminé mais on ignore quand ; avec NO-VALUE, ce n'est pas terminé.
- Un marqueur n'est valide que si la liste des CODEC du champ contient exactement ce WORD. Il est invalid pour les jokers, les champs sans CODEC, les emplacements d'enregistrement du HEAD et du BODY et l'emplacement de l'Edge Id ([CODEC](edge/0x0BEL-codec.md)).
- Obligations du lecteur :
  1. UNKNOWN-VALUE n'est pas une valeur mais une assertion d'existence. Il n'est égal à aucune valeur ni différent d'aucune valeur, et deux UNKNOWN-VALUE ne sont pas non plus considérés comme la même valeur. On ne fusionne pas de doublons pour un TRIPLE contenant UNKNOWN-VALUE.
  2. NO-VALUE est fermé dans la condition de restriction de cette proposition. S'il coexiste avec un TRIPLE de valeur de même Subject, Predicate et rank dont la condition de restriction ne se distingue pas, c'est une contradiction, et le vérificateur avertit (il ne rejette pas).
  3. rank s'applique de la même façon. Pour choisir la valeur représentative (truthy), les TRIPLE des deux marqueurs sont aussi candidats.
  4. S'ils servent de valeur de QUALIFIER, ils changent le sens de cette restriction (`P582 = UNKNOWN` : terminé, date inconnue. `P582 = NONE` : non terminé).
  5. ABSENT ne dit rien sur le monde. On n'emploie pas UNKNOWN-VALUE pour une valeur qu'on n'a pas pu transcrire.

## Forme canonique {#정규형}

Un même contenu doit donner les mêmes octets. C'est ce qui rend le hachage du contenu et la signature uniques.

- Pour la longueur, on utilise la notation la plus courte (de 1 à 14 WORD, longueur directe).
- Un entier s'écrit avec la plus étroite largeur. On suit la forme canonique fixée par la spécification de chaque Codec.
- Un enregistrement qui n'est pas en forme canonique est rejeté.
- Exception : le `L=1111` du WORD cible de [CODEC](edge/0x0BEL-codec.md) ne regarde que la section `KKKK`, quelle que soit la valeur de `C`. On recommande la première case de la section (`C = 0`), et l'on ne rejette pas un autre `C` de la même section.
