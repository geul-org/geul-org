---
title: "Pourquoi il faut laisser vide"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["réservé", "extensibilité", "TAG WORD", "principe-de-conception", "IPv4"]
summary: "GEUL laisse vide 75 % de l'espace de la TAG WORD de 16 bits qui ouvre chaque enregistrement. Les leçons d'IPv4, d'Unicode et d'ASCII : le coût du remplissage est irréversible, celui du vide n'est que de trois bits par enregistrement."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Chaque enregistrement GEUL commence par une seule TAG WORD de 16 bits. Les bits de tête de la TAG WORD la divisent en régions. GEUL laisse vide 75 % de cet espace.

```
1xx:  50%    Futur lointain
01x:  25%    Futur proche
001:  12.5%  Standard
000:  12.5%  Grammaire actuelle (libre / proposition)
```

Toute la grammaire actuelle se trouve dans la région `000`, à l'intérieur des 12,5 %. Lorsqu'un standard officiel sera lancé, les dispositions adoptées resteront telles quelles et seuls les bits de tête passeront à `001`. Les 75 % restants sont laissés aux générations qui ne sont pas encore nées.

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

## Le coût du vide

Laisser de l'espace vide coûte-t-il quelque chose ?

```
TAG WORD de 16 bits = région de 3 bits + 13 bits

Les 13 bits de la région actuelle 000 :
  Kind    2 bits   Reference · Value · Edge · Meta
  Length  4 bits   1–14 WORD, jusqu'à 2³²−1 WORD en extension
  Codec   7 bits   124 codes directs + 4 formes d'Issuer
```

13 bits, n'est-ce pas trop peu ? Non. Un format qui n'obtient pas de code direct s'écrit comme format d'Issuer. Chaque entité qui définit des formats (Issuer) dispose de ses propres numéros de format de 16 bits ; le nombre de formats n'a donc pratiquement pas de limite. Le prix : quelques WORD de TAG d'extension. Les formats fréquents sont courts, les formats rares un peu plus longs.

Le coût du vide, ce sont trois bits de la TAG WORD par enregistrement. Ces trois bits réservent pour l'avenir six fois l'espace utilisé aujourd'hui.

Le coût du remplissage ? IPv4 nous l'a montré. Il est irréversible.

---

## Principe de conception

Le cinquième principe de conception de la [grammaire](/fr/grammar/overview/) GEUL v1 :

> **Laisser vide.** La plus grande partie de l'espace de bits est gardée pour l'avenir. Les codes directs ne peuvent pas être récupérés ; seuls les formats à fréquence confirmée en reçoivent un.

La grammaire fixe ce principe en règle. Un décodeur v1 rejette toute TAG WORD dont les bits de tête ne sont pas `000`. Le chemin pour emprunter l'espace vide à des fins temporaires est fermé dès le départ.

Ce n'est pas une décision technique. C'est une décision éthique.

Choisir de ne pas utiliser l'espace qui pourrait l'être maintenant, c'est déclarer que la liberté du futur prime sur la commodité du présent. La dette que la génération qui a conçu IPv4 nous a laissée, nous ne la laisserons pas à la génération suivante.

---

## La conception la plus humble

```
"Je connais l'avenir" -> Utiliser les 16 bits.
"Je ne connais pas l'avenir" -> Laisser 75 % vide.
```

Laisser de l'espace vide, c'est de l'humilité. C'est reconnaître que nous ne pouvons pas connaître l'avenir. Et cette humilité produit la conception la plus robuste.

IPv4 était le produit de la confiance. 32 bits suffisent. Ils n'ont pas suffi.

GEUL est le produit de l'humilité. Nous ne savons pas si les 12,5 % utilisés aujourd'hui suffisent. Mais si nous laissons 75 % vide, il n'est pas grave de se tromper.

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
