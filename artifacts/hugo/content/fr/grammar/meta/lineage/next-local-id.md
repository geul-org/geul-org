---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID est un Meta de lignée qui consigne dans la liste de versions le LOCAL ID que la prochaine version du document attribuera à une nouvelle description (auto increment)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Consigne le LOCAL ID que la prochaine version du document attribuera à une nouvelle description (auto increment d'un SGBD, `AUTO_INCREMENT` de MySQL). Tous les LOCAL ID attribués dans n'importe quelle version du document sont inférieurs à cette valeur.

## Disposition

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           prochain LOCAL ID à attribuer, entier non signé de la largeur la plus courte
```

- Codec : Meta `0x3C`, classe de lignée (`011`)
- Payload : valeur brute (entier non signé de la largeur la plus courte)
- Nombre : au plus un
- Emplacement : HEAD du document de liste de versions `versions.geul` ([PUBLICATION](/fr/grammar/edge/publication/))

## Interprétation et validité

- Un LOCAL ID (y compris un Edge Id) est une identité qui traverse les versions ([Révision](/fr/grammar/document/#révision)). Une nouvelle description reçoit cette valeur, puis la valeur augmente de 1. Un LOCAL ID supprimé n'est pas réutilisé. Ainsi, même si la description portant la valeur maximale est supprimée, cette valeur ne diminue pas.
- Le LOCAL ID `0` n'est pas attribué ; la valeur initiale est donc `1`. S'il n'y a pas encore de version, ce Meta n'est pas placé et le prochain numéro est `1`.
- Quand le lieu de publication publie une version, il l'écrit mis à jour dans le nouveau document de liste. Elle doit être supérieure à tout LOCAL ID utilisé dans les versions publiées. Si elle est inférieure ou égale, invalid.
- La valeur ne fait que croître. Si elle est inférieure à celle du document de liste précédent ([PARENT](/fr/grammar/meta/lineage/parent/)), invalid.
- Elle n'existe pas dans les documents sans gestion de versions (documents sans `versions.geul`, documents anonymes). Ces documents n'ont pas non plus de diff ([DELTA-BASE](/fr/grammar/meta/lineage/delta-base/)).
- Elle n'est pas placée dans le corps du document (document de version). La mémoire des numéros n'est pas un contenu du document mais un état du lieu de publication qui prolonge le document (non pas les commits de git, mais du côté des refs).

## Exemple

Prochain numéro à attribuer 524 :

```
18BC 020C
```

- TAG `18BC` (Meta `0x3C`, `LLLL=0001`, 2 WORD), Payload `020C`.
