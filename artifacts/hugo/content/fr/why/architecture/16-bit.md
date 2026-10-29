---
title: "Pourquoi 16 bits ?"
weight: 17
date: 2026-02-26T12:00:04+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["16-bit", "binaire", "flux"]
summary: "Un seul mot de 16 bits est conçu pour être l'unité de trois mondes : le flux réseau, le format de fichier et le vocabulaire du LLM. Pourquoi 16 bits, et non 8, 32 ou une longueur variable."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Un seul mot traverse trois mondes

---

## Trois mondes

Il existe trois mondes en informatique.

**Le monde des reseaux.**
Les donnees circulent sous forme de flux d'octets.
Les octets arrivent par les sockets TCP, et les octets en repartent.
Le vocabulaire de l'ingenieur reseau : paquets, en-tetes et charges utiles.

**Le monde du stockage.**
Les donnees sont persistees sous forme de formats de fichiers.
Ecrites sur disque, lues depuis le disque.
Le vocabulaire de l'ingenieur stockage : blocs, decalages et alignement.

**Le monde de l'IA.**
Les donnees sont traitees sous forme de sequences de tokens.
Les LLM recoivent des tokens en entree et produisent des tokens en sortie.
Le vocabulaire de l'ingenieur IA : embeddings, attention et contexte.

Ces trois mondes parlent des langues differentes.
Et entre eux, une traduction est toujours necessaire.

---

## Le cout de la traduction

Suivons le chemin que parcourent les donnees dans un systeme d'IA moderne.

Le savoir est stocke dans un fichier. En JSON ou en texte brut.

Pour le transmettre a une IA :

1. Ouvrir le fichier et lire le texte.
2. Analyser le texte. S'il s'agit de JSON, interpreter la structure et extraire les champs.
3. Injecter le texte extrait dans un tokeniseur.
4. Le tokeniseur convertit le texte en une sequence d'identifiants de tokens.
5. La sequence de tokens est injectee dans le LLM.

Lorsque l'IA genere une reponse :

6. Le LLM produit une sequence de tokens.
7. Decoder les tokens en texte.
8. Serialiser le texte dans un format structure.
9. Ecrire les donnees serialisees dans un fichier.

Une simple operation de "lecture et ecriture" necessite neuf etapes.

Chaque etape coute du temps.
Chaque etape coute de la memoire.
Chaque etape risque une perte d'information.

Les etapes 3 et 4 -- le processus de tokenisation -- sont notoirement problematiques.
Parce que les frontieres de mots du langage naturel ne s'alignent pas avec les frontieres de tokens du tokeniseur,
un nom propre comme "Yi Sun-sin" peut etre decoupe en fragments arbitraires,
ou une unite semantique unique se retrouve dispersee sur plusieurs tokens.

Tel est le prix de trois mondes qui parlent des langues differentes.

---

## Et si une seule unité traversait les trois mondes ?

Dans ce langage, un mot fait 16 bits (2 octets).

Un seul mot de 16 bits est conçu pour jouer trois rôles à la fois.

**Unité du flux d'octets.**
Les mots de 16 bits arrivent en flux continu sur le réseau.
Big Endian. Alignés sur 2 octets.
Il suffit de les lire dans l'ordre d'arrivée.

**Unité du format de fichier.**
Écrivez le flux tel quel sur le disque : c'est votre fichier.
Lisez les octets du disque et envoyez-les tels quels sur le réseau : c'est votre flux.
Pas de sérialisation. Pas de désérialisation.

**Unité du vocabulaire du LLM.**
16 bits = 65 536 symboles distincts.
La taille du vocabulaire des LLM modernes va de quelques dizaines à quelques centaines de milliers.
GPT-2 en utilise environ 50 000 ; les modèles récents, entre 100 000 et 200 000 environ.
65 536 se situe dans cette fourchette.
Un mot de 16 bits est une unité d'une taille qu'un LLM peut apprendre comme vocabulaire.

Trois mondes partagent la même unité.
La traduction diminue.

---

## Le flux est le fichier

Voyons concrètement ce que cela signifie.

**Approche conventionnelle : 9 étapes**

```
[Fichier] -> Lire -> Analyser -> Extraire le texte -> Tokeniser -> [LLM]
[LLM] -> Décoder -> Sérialiser -> Écrire -> [Fichier]
```

**L'approche GEUL**

```
[Flux] = [Fichier]                                mêmes octets
[Fichier] -> lecture enregistrement par           sans livre de codes
             enregistrement, avec sauts
```

Écrivez un flux tel quel : c'est un fichier. Envoyez un fichier tel quel : c'est un flux.
Ni sérialisation ni désérialisation.
Le premier mot de chaque enregistrement (la TAG WORD) donne son type et sa longueur ;
les enregistrements inutiles sont donc sautés sans être interprétés.

Côté LLM, c'est encore un objectif.
Un mot n'est pas un token.
Un enregistrement s'étend sur plusieurs mots, et le texte est porté comme suite d'octets.
Mais lorsque l'unité est fixée à 16 bits,
le tokeniseur n'a pas à deviner les frontières : il suit des frontières déjà données.
« Yi Sun-sin » n'est pas coupé à un endroit arbitraire, car c'est un unique enregistrement Reference qui pointe vers Wikidata Q50184.

---

## Pourquoi pas 8 bits ?

8 bits donnent 256 symboles distincts.

256 symboles sont bien trop peu pour representer le monde.
Assignez l'alphabet, les chiffres et la ponctuation de base, et la moitie de l'espace est deja epuisee.

Si vous utilisez 8 bits comme unite fondamentale,
la plupart des tokens significatifs necessitent 2 octets ou plus.
Cela impose un encodage a longueur variable,
et la longueur variable rend l'analyse complexe.

Adequat comme unite de flux d'octets,
mais insuffisant comme unite de token.

---

## Pourquoi pas 32 bits ?

32 bits donnent environ 4,3 milliards de symboles distincts.

La puissance expressive est plus que suffisante.
Mais le problème, c'est l'efficacité.

Le plus petit enregistrement de ce langage fait 1 mot : des marqueurs comme BODY et END, constitués d'une seule TAG WORD.
Une Reference vers Wikidata Q42 fait 2 mots,
et un TRIPLE disant « Q42 est un être humain » en fait 10.
Avec des mots de 16 bits, ce TRIPLE occupe 20 octets. Avec des mots de 32 bits, il en occuperait 40.
Le même enregistrement double de taille.

Du point de vue du LLM, il y a aussi un problème.
Un vocabulaire de 32 bits, soit 4,3 milliards de symboles, est des dizaines de milliers de fois plus grand que n'importe quel vocabulaire de LLM.
Il n'existe ni les données ni les modèles pour apprendre un vocabulaire aussi vaste.

Un mot de 32 bits est excessif comme unité de ce langage.

---

## Pourquoi pas une longueur variable ?

UTF-8 est un encodage a longueur variable.
La longueur d'un caractere varie de 1 a 4 octets selon le caractere.

Cela offre des avantages en efficacite de stockage,
mais introduit une faiblesse fatale en efficacite de traitement.

Pour trouver le n-ieme caractere, il faut compter depuis le debut.
L'acces aleatoire est impossible.
Le traitement parallele SIMD devient difficile.

Ce langage utilise des mots fixes de 16 bits comme unite fondamentale.
La position du n-ieme mot est toujours n * 2 octets.
L'acces aleatoire est O(1).
SIMD peut comparer plusieurs mots en une seule instruction.
Les GPU peuvent analyser des milliards de mots en parallele.

Pourtant, au niveau de l'enregistrement, la longueur variable reste permise.
Les enregistrements vont de 1 mot à 2³²−1 mots, et la longueur est écrite dans le premier mot.
L'unité de mot est fixe, mais l'unité d'enregistrement est flexible.

L'efficacite de traitement de la largeur fixe combinee a l'expressivite de la longueur variable.
Le mot de 16 bits realise les deux simultanement.

---

## Le chemin prouvé par Unicode

Unicode est la norme d'encodage la plus réussie que l'humanité ait créée.

L'unité de base d'UTF-16 est de 16 bits (2 octets).
Les caractères du plan multilingue de base (BMP) tiennent dans un seul mot,
et les autres sont étendus par des paires de substitution (2 mots = 4 octets).

GEUL suit la même structure.
Les formats fréquents sont portés par un code direct à l'intérieur d'une seule TAG WORD,
et les formats rares sont étendus par des TAG d'extension.

De même qu'Unicode exprime tous les caractères du monde
sur l'unité de base « un caractère = 2 octets »,
GEUL exprime des énoncés, leurs sources et leurs fondements
sur l'unité de base « un mot = 2 octets ».

---

## Retrocompatibilite et extension ascendante

Un autre atout de 16 bits est l'alignement.

16 est un multiple de 8, un diviseur de 32, un diviseur de 64 et un diviseur de 128.

Cela signifie que l'alignement ne se brise jamais, quelle que soit la direction dans laquelle on etend.

Que se passe-t-il si l'architecture transformer change a l'avenir
et que les tokens deviennent 32 bits ?
Deux mots de 16 bits forment un token. Aucun probleme d'alignement.

Et 64 bits ?
Quatre mots de 16 bits forment un token. Toujours aucun probleme d'alignement.

Inversement, que se passe-t-il si un systeme embarque 8 bits traite ce format ?
Il suffit de lire chaque mot de 16 bits comme un octet de poids fort et un octet de poids faible.

La retrocompatibilite doit etre maintenue de maniere absolue.
Le mot de 16 bits la garantit au niveau physique.

Nous ne pouvons pas predire la taille de mot des intelligences futures,
mais l'alignement multiple de 16 bits garantit la compatibilite avec toute taille.

---

## La triple structure

Résumons.

Un seul mot de 16 bits est conçu pour être l'unité de trois mondes.

| Monde | Rôle d'un mot |
|-------|---------------------|
| Réseau | Unité du flux d'octets |
| Stockage | Unité du format de fichier |
| IA | Unité du vocabulaire du LLM (objectif) |

Une seule unité traverse les trois mondes.

Stockez un flux tel quel : c'est un fichier.
Envoyez un fichier tel quel : c'est un flux.
L'engrener mot à mot avec les LLM est la prochaine étape.

Moins de conversion.
Moins de traduction.
Moins de perte.

Voilà pourquoi 16 bits.
Ni 8, ni 32, ni une longueur variable.
Le nombre qui se trouve exactement à l'intersection de trois mondes.

16.
