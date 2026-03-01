---
title: "Pourquoi il faut laisser vide"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["réservé", "extensibilité", "64-bit", "principe-de-conception", "IPv4"]
summary: "GEUL laisse vide 75% de son espace 64 bits. Les leçons d'IPv4, Unicode et ASCII nous enseignent : le coût de remplir est irréversible, mais le coût de laisser vide est zéro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

64 bits, c'est 18 446 744 073 709 551 616 adresses. 18,4 trillions. GEUL en laisse 75 % vides.

```
bit1 = 1:    50%    futur lointain
bit1-2 = 01: 25%    futur proche
bit1-3 = 001: 12.5% standard
bit1-4 = 0001: 6.25% proposition actuelle
```

L'espace actuellement utilisé est de 6,25 %. Des 93,75 % restants, 12,5 % seront utilisés quand le standard sera établi, et 75 % sont réservés pour les générations qui ne sont pas encore nées.

Pourquoi ?

---

## La leçon d'IPv4

En 1981, les concepteurs d'IPv4 pensaient que 32 bits suffiraient. 4,3 milliards d'adresses. À l'époque, il n'y avait que quelques centaines d'ordinateurs dans le monde. 4,3 milliards, cela semblait éternel.

En 2011, les adresses IPv4 ont été épuisées.

30 ans. À peine 30 ans.

Ce que l'humanité a dû faire ensuite : NAT, CGNAT, marchés de revente d'adresses, double pile IPv6. Des décennies de dépenses se chiffrant en milliers de milliards. Tout cela aurait été inutile « si on avait laissé de l'espace vide dès le début ».

IPv6 a adopté 128 bits. 3,4 × 10^38 adresses. 6,7 × 10^17 par mètre carré de surface terrestre. Cette fois, c'est suffisant ? Probablement. Mais même eux n'en étaient pas certains — c'est pourquoi ils ont choisi 128 bits.

---

## La leçon d'Unicode

En 1991, Unicode 1.0 pensait que 16 bits suffiraient. 65 536 caractères. De quoi contenir tous les systèmes d'écriture du monde, pensait-on.

Ce n'était pas assez. Extensions CJK, emojis, écritures anciennes, symboles musicaux. Le seuil des 16 bits a été dépassé.

Le résultat : les paires de substitution UTF-16. L'un des hacks les plus laids de l'histoire du logiciel. Windows, Java et JavaScript portent encore cet héritage.

Unicode a finalement été étendu à 21 bits (1 114 112 points de code). Le taux d'utilisation actuel est d'environ 10 %. Le reste est laissé vide. Cette fois, la leçon a été retenue.

---

## La leçon d'ASCII

En 1963, ASCII utilisait 7 bits. 128 caractères. Seul l'anglais avait été pris en compte.

Le résultat : 60 ans d'enfer des encodages pour l'humanité. EUC-KR, Shift_JIS, Big5, la série ISO-8859, CP949. Le même octet représentant des caractères différents selon les systèmes. Du coréen corrompu. Du japonais corrompu. Des points d'interrogation dans les objets d'e-mail.

Un seul bit de plus aurait suffi. Si l'on avait sécurisé 8 bits complets en disant « le reste, c'est pour plus tard ». L'histoire aurait été différente.

---

## L'arrogance du concepteur

Tous ces cas ont un point commun : **le jugement « ce dont nous avons besoin maintenant suffit ».**

Les concepteurs d'IPv4 étaient-ils des imbéciles ? Non. C'étaient les meilleurs ingénieurs de leur époque. Ils ont simplement sous-estimé l'avenir. Chaque génération a fait la même erreur.

« 640 Ko devraient suffire à tout le monde. » Que Bill Gates ait réellement prononcé cette phrase est sujet à débat, mais le fait que les ingénieurs de toutes les époques soient tombés dans ce piège est indéniable.

GEUL cherche à éviter ce piège. La méthode est simple. **Ne pas utiliser.**

---

## Jamais deux sans trois

En France, on dit « jamais deux sans trois ». Les occasions se présentent trois fois.

```
Première occasion : 001 (standard)
  Quand les humains établissent un standard.
  Qu'il s'agisse d'un organisme international, d'un consortium industriel
  ou d'une communauté.
  Un espace qui sera rempli au rythme du consensus humain.

Deuxième occasion : 01 (futur)
  Après S1. Quand la superintelligence apparaîtra.
  Une entité qui structurera la connaissance de manières
  que les humains ne peuvent pas prédire.
  Elle pourrait utiliser nos structures telles quelles,
  ou les redéfinir d'une façon que nous ne pouvons imaginer.
  Cet espace est pour cette entité.

Troisième occasion : 1 (futur lointain)
  Nul ne sait quand.
  Peut-être quand K1 sera atteint et que nous serons
  une civilisation interstellaire.
  Peut-être quand la forme même de la conscience aura changé.
  Peut-être quelque chose que nous ne pouvons aujourd'hui
  qu'imaginer dans la science-fiction.
  Si quelqu'un lit ce bit depuis l'autre côté d'Orion's Arm*,
  cet espace est le leur.
```

Réserver 50 % pour le futur lointain, c'est céder la moitié des possibilités à « ce que nous ne connaissons pas ».

---

## Le coût de laisser vide

Laisser vide a-t-il un coût ?

```
75 % réservés sur 64 bits = 48 bits inutilisés.
Les 16 bits restants (6,25 %) = 1 152 921 504 606 846 976 adresses.

11,5 trillions.
10 millions de fois la totalité de Wikidata (108 millions d'entités).
Largement suffisant pour contenir toutes les données existantes.
```

Laisser vide ne crée aucune pénurie. 6,25 % suffisent pour les besoins actuels. Le coût de laisser vide est zéro.

Le coût de remplir ? IPv4 l'a démontré. C'est irréversible.

---

## Principe de conception

Article premier des principes de conception de GEUL Grammar v0.11 :

> **Extensibilité à long terme :** ne pas détourner les bits réservés pour un usage temporaire. Préserver l'espace que les générations futures utiliseront.

Ce n'est pas une décision technique. C'est une décision éthique.

Ne pas utiliser un espace disponible aujourd'hui, c'est déclarer que la liberté future prime sur le confort présent. C'est refuser de transmettre aux générations suivantes la dette que les concepteurs d'IPv4 nous ont léguée.

---

## La conception la plus humble

```
"Je connais l'avenir" → utiliser les 64 bits en entier.
"Je ne connais pas l'avenir" → laisser 75 % vides.
```

Laisser vide, c'est de l'humilité. C'est admettre que nous, aujourd'hui, ne pouvons pas connaître l'avenir. Et cette humilité produit la conception la plus robuste.

IPv4 était le produit de la confiance. 32 bits suffisent. Ce n'était pas suffisant.

GEUL est le produit de l'humilité. 6,25 % de 64 bits suffisent-ils ? Nous ne savons pas. Mais si nous laissons 75 % vides, même si nous nous trompons, ce n'est pas grave.

---

*Il a fallu beaucoup de mots pour expliquer pourquoi laisser vide. L'acte lui-même tient en une ligne :*

```
if (bit1 == 1): reserved  // 50 %. Futur lointain.
```

*Une ligne de code protège la moitié du monde.*

---

<small>

\* Orion's Arm — le bras spiral de la Voie lactée auquel appartient notre système solaire. C'est aussi le nom de l'[Orion's Arm Universe Project](https://www.orionsarm.com/), un projet collaboratif de hard SF qui imagine un futur situé 10 000 ans après notre époque dans ce bras spiral. Il explore des thèmes comme la superintelligence, les civilisations interstellaires et la transformation de la conscience avec une rigueur scientifique, et a été construit par des centaines de contributeurs depuis l'an 2000. Ce que GEUL appelle le « futur lointain », ils l'imaginent déjà.

</small>
