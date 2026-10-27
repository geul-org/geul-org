---
title: "Marqueur d'emplacement"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "Les marqueurs d'emplacement sont un lot d'enregistrements de 1 WORD placés dans le Codec de Reference réservé 0000. 0x0000 ABSENT (non renseigné), 0x0001 UNKNOWN-VALUE (inconnu) et 0x0002 NO-VALUE (aucune valeur) occupent la place d'un champ d'enregistrement."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Un marqueur d'emplacement (slot marker) est un enregistrement de 1 WORD qui occupe la place d'un champ d'enregistrement. Il ne désigne rien. Il se place dans le Codec de Reference réservé `0000`.

À la place d'une valeur, on peut dire trois choses. On n'a pas écrit la valeur, une valeur existe mais on ne sait pas laquelle, il n'y a pas de valeur. Ces trois choses sont distinctes. Les marqueurs d'emplacement les répartissent sur trois WORD voisins.

## Disposition

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = numéro du marqueur
```

| WORD | Nom | Sens | Notation |
|---|---|---|---|
| `0x0000` | ABSENT | Non renseigné | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | Inconnu : une valeur existe. On ne sait pas laquelle | `UNKNOWN` |
| `0x0002` | NO-VALUE | Aucune valeur : il n'y a pas de valeur | `NONE` |
| `0x0003`~`0x0007` | Réservé | | |
| CCCC `0000`, LLLL ≥ `0001` | Réservé | Les marqueurs avec Payload seront fixés plus tard | |

- Les 3 bits de poids faible `MMM` sont le **numéro du marqueur, non un Quantifier**. C'est le même emplacement que `QQQ` des autres Codec de Reference, mais les sens ne se prolongent pas (exception du Quantifier dans [Reference](/fr/grammar/reference/)).
- Pas de Payload. Pas d'ID de cible non plus.
- Même un décodeur sans livre de codes sait, rien qu'au TAG WORD, que c'est une Reference de 1 WORD, et le saute. « Si la valeur du WORD est `0`~`7`, c'est un marqueur d'emplacement » se vérifie par un seul test de bits (`w & 0xFFF8 == 0`).
- Les notations `ABSENT`, `UNKNOWN` et `NONE` sont les notations textuelles de `geul show` et `geul add`.

## Trois distinctions

| | Non renseigné (ABSENT) | Inconnu (UNKNOWN-VALUE) | Aucune valeur (NO-VALUE) |
|---|---|---|---|
| De quoi parle-t-on | **Document** : cet emplacement n'a pas été rempli | **Monde** : une valeur existe. On ne sait pas laquelle | **Monde** : il n'y a pas de valeur |
| Logique | N'affirme rien | `∃x. P(s, x)`, x non identifié | `¬∃x. P(s, x)` |
| Hypothèse sur le monde | Monde ouvert (aucune information) | Existence fermée, identité ouverte | Monde fermé pour (s, P, conditions restrictives) |
| Wikidata | Pas de snak correspondant | `somevalue` | `novalue` |
| Où l'emploie-t-on | Champ facultatif dont la cible CODEC `0000` est placée (Origin de SOURCE, etc.) | Champ dont la cible CODEC `0001` est placée (Object de TRIPLE, Value de QUALIFIER, Origin de SOURCE) | Champ dont la cible CODEC `0002` est placée (Object de TRIPLE, Value de QUALIFIER) |
| « Combien d'enfants (P40) ? » | On ne sait pas | Au moins 1 | 0 |
| « Y a-t-il une date de fin (P582) ? » | On ne sait pas → on ignore si c'est encore valide | Terminé. On ignore quand | Non terminé (affirmé) |

La même distinction vaut au niveau de la proposition. **L'absence d'un TRIPLE dans le document** est un non renseigné. Un document GEUL étant un monde ouvert, l'absence de description ne signifie pas l'absence de fait. On ne peut dire « il n'y en a pas » qu'en l'**écrivant** par NO-VALUE.

## Règle d'admission

- Un marqueur d'emplacement n'est valide que si la liste [CODEC](/fr/grammar/edge/codec/) du champ comprend **le même WORD comme cible exacte**. La cible `0000` signifie « champ facultatif », `0001` « reçoit inconnu », `0002` « reçoit aucune valeur ».
- Les jokers (`0780`, `0781`, `0F80`, etc.) ne reçoivent pas de marqueur. Même un joker de Reference ne recouvre pas le Codec `0000`.
- Un champ d'enregistrement sans CODEC (« n'importe quel enregistrement ») ne reçoit pas non plus de marqueur.
- Un marqueur sur une place d'enregistrement du HEAD ou du BODY ou sur une place d'Edge Id est invalid.
- On ne peut pas employer de marqueur dans un champ en valeur brute. Une valeur brute n'a pas de TAG et il n'y a pas de place pour un marqueur de 1 WORD.
- Une liste CODEC ne contenant que des cibles de marqueur (toujours un marqueur) est invalid.
- Le sens d'un marqueur (ce qui existe et ce qui n'existe pas) est fixé par la spécification de l'Edge qui le reçoit. C'est le même principe que celui selon lequel la quantification et la négation sont fixées par l'Edge et non par Reference.
- Les marqueurs d'emplacement n'ont pas de document de spécification de Codec. Ils sont dans la [couche 0](/fr/grammar/publishing/#couches) (intégrés au décodeur). La cible Reference d'un DECLARE laissant l'emplacement du Quantifier à 0, on ne peut pas créer de document de spécification pour `0x0001` et `0x0002`, et comme aucun des trois n'a de Payload, l'intégrer ne coûte rien.

## Obligations du lecteur

1. **UNKNOWN-VALUE n'est pas une valeur mais une affirmation d'existence.** Il n'est égal à aucune autre valeur et n'en est pas différent non plus (résultat de la comparaison indéterminé). Deux UNKNOWN-VALUE ne sont pas non plus considérés comme la même valeur. C'est une quantification existentielle indépendante à chaque occurrence (comme un nœud vide de Wikidata).
   - Deux TRIPLE aux octets identiques (`P40 Q… UNKNOWN` ×2) ne sont donc pas des doublons. Il peut y avoir deux enfants comme un seul. Les TRIPLE contenant UNKNOWN-VALUE ne se fusionnent pas comme doublons.
   - Quand l'identité est établie plus tard, on publie une nouvelle version qui corrige ce TRIPLE. UNKNOWN-VALUE ne peut pas être désigné. Si une coréférence est nécessaire, on emploie une Variable LOCAL ([Reference](/fr/grammar/reference/), Variable).
2. **NO-VALUE se ferme dans les conditions restrictives de cette proposition.** Une fois des QUALIFIER joints, il ne se ferme que dans cette portée. Q30 P1304 NO-VALUE (P580 1811, P582 1816) signifie qu'il n'y a pas eu de banque centrale seulement de 1811 à 1816, et ne contredit pas le TRIPLE de valeur de la même propriété (Réserve fédérale, preferred).
   - Si, pour un même Subject et Predicate, un TRIPLE NO-VALUE et un TRIPLE de valeur coexistent avec le même rank sans que les conditions restrictives les distinguent, c'est une contradiction. Le vérificateur avertit. Il ne rejette pas. C'est un état qui existe aussi dans Wikidata, et le lecteur choisit par rank.
3. **Le rank s'applique à l'identique.** Pour choisir la valeur représentative (truthy), les TRIPLE UNKNOWN-VALUE et NO-VALUE sont aussi candidats. S'il y a un preferred, seul preferred reste.
4. **Utilisé comme valeur de QUALIFIER, il change le sens de cette restriction.** Avec `P582 = UNKNOWN`, c'est terminé et la date est inconnue. On ne lit pas la proposition comme encore valide. Avec `P582 = NONE`, on affirme que ce n'est pas terminé. S'il n'y a aucun QUALIFIER P582, on ne sait pas si c'est terminé.
5. **ABSENT ne dit rien du monde.** On ne le lit ni comme UNKNOWN-VALUE ni comme NO-VALUE. À l'inverse, il est interdit à un convertisseur d'employer UNKNOWN-VALUE pour une valeur qu'il n'a pas pu transcrire (une valeur que l'origine possède), car l'origine connaît cette valeur. Pour une place que l'origine ne dit pas non plus (par ex. l'Origin d'un [SOURCE](/fr/grammar/edge/source/) dont la source ne décrit pas d'origine), le convertisseur écrit aussi ABSENT. UNKNOWN-VALUE étant l'affirmation « il y en a un », on ne l'emploie que si l'origine le dit.

## Différence avec les autres « absences »

- La règle de Codec qui emploie [LOCAL](/fr/grammar/reference/local/) `0` comme « aucun » ([TOULMIN](/fr/grammar/edge/toulmin/), REF, etc.) est une convention interne à ce Codec. Elle diffère des marqueurs d'emplacement.
- On n'emploie pas un LOCAL Identified comme null ou sentinelle. Pour écrire un inconnu ou une absence, on met un marqueur dans un champ qui reçoit les marqueurs.

## Exemple

Frontière Q30 (États-Unis)–Q34266 (Empire russe), date de fin inconnue. Les Edge Id sont à titre d'illustration.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Banque centrale de Q30, inexistante de 1811 à 1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- La place du marqueur fait 1 WORD. Le TRIPLE fait 9 WORD (`140A`), le QUALIFIER 8 WORD (`138B`).
- Sous la forme simple, « pas d'enfant (P40) » s'écrit `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Pages liées

- [Reference](/fr/grammar/reference/), [CODEC](/fr/grammar/edge/codec/), [Documents de spécification de Codec](/fr/grammar/codec-spec/)
- [TRIPLE](/fr/grammar/edge/triple/), [QUALIFIER](/fr/grammar/edge/qualifier/), [TOULMIN](/fr/grammar/edge/toulmin/)
