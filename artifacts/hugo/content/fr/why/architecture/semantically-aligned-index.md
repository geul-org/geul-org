---
title: "Pourquoi un index semantiquement aligne ?"
weight: 16
date: 2026-02-26T12:00:03+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SIDX", "alignement semantique", "index"]
summary: "Si un identifiant était une connaissance et non une adresse, une seule opération sur les bits suffirait à réduire les candidats, sans aucun JOIN. Cet essai présente SIDX, l'identifiant sémantiquement aligné que GEUL étudie, et explique pourquoi sa largeur sera fixée par les statistiques d'usage."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Ce qui se passe quand un identifiant est un savoir, pas une adresse

---

## Une adresse ne sait rien

Pour trouver Yi Sun-sin dans une base de donnees, il faut un identifiant.

Dans Wikidata, l'identifiant de Yi Sun-sin est `Q50184`.

Ce numero pointe vers Yi Sun-sin.
Mais la chaine `Q50184` elle-meme ne sait rien.

Elle ne sait pas s'il s'agit d'une personne ou d'un batiment.
Elle ne sait pas s'il s'agit d'un Coreen ou d'un citoyen francais.
Elle ne sait pas s'il s'agit d'un personnage du XVIe siecle ou du XXIe siecle.
Elle ne sait pas s'il est vivant ou mort.

`Q50184` est une adresse.
Un facteur qui livre le courrier n'a aucune idee de ce qui est ecrit dans l'enveloppe.
Il regarde simplement l'adresse sur l'enveloppe et livre.

UUID, c'est pareil. `550e8400-e29b-41d4-a716-446655440000`.
128 bits de nombres aleatoires. Unique seulement pour eviter les collisions --
cela ne dit rien sur ce a quoi il fait reference.

Depuis cinquante ans, les identifiants de bases de donnees fonctionnent ainsi.
Un identifiant est une adresse, et pour apprendre quoi que ce soit, il faut suivre cette adresse et lire les donnees.

---

## Il faut suivre pour savoir

Pourquoi est-ce un probleme ?

Supposons que vous vouliez trouver "un philosophe masculin de nationalite allemande ne au XIXe siecle".

Dans une base de donnees traditionnelle, voici comment cela se passe :

```
1. Filtrer la table des personnes ou gender = 'male'
2. JOIN avec la table des nationalites et filtrer country = 'Germany'
3. JOIN avec la table des dates de naissance et filtrer year BETWEEN 1800 AND 1899
4. JOIN avec la table des professions et filtrer occupation = 'philosopher'
```

Quatre operations JOIN.
Chaque JOIN compare les lignes de deux tables.
Si les tables sont grandes, on parcourt un index ; s'il n'y a pas d'index, on fait un balayage complet.
Avec un milliard d'enregistrements, ce processus prend des secondes a des dizaines de secondes.

Pourquoi est-ce si complexe ?

Parce que l'identifiant ne sait rien.
En regardant `Q50184`, on ne peut pas dire s'il s'agit d'un Allemand ou d'un Coreen,
il faut donc aller dans une autre table pour recuperer cette information.

Pour chaque question, il faut suivre l'adresse de l'identifiant.
C'est le cout que les bases de donnees paient depuis cinquante ans.

---

## Et si l'identifiant savait deja ?

Inversons la premisse.

Et si l'identifiant lui-meme contenait les informations essentielles ?

Et si, simplement en regardant l'identifiant,
on pouvait dire s'il fait reference a un humain, de quel pays il vient,
a quelle epoque il appartient et comment il est classifie ?

Pour trouver "un philosophe allemand masculin du XIXe siecle",
les JOIN deviennent inutiles.

En parcourant un milliard d'identifiants,
on peut instantanement determiner si chacun correspond en examinant ses bits.

C'est l'idee centrale de l'index semantiquement aligne.

---

## Aligner le sens dans l'identifiant

SIDX (Semantically-Aligned Index) est une recherche visant à construire un tel identifiant.
La grammaire GEUL possède déjà un emplacement de Reference qui désigne une cible par SIDX ([GEUL-SIDX](/fr/grammar/reference/geul-sidx/)).
Mais sa largeur et sa méthode d'attribution ne sont pas encore décidées. Elles seront fixées à partir des statistiques d'usage accumulées.
Ci-dessous, 64 bits servent d'exemple pour l'explication.

Les bits d'un SIDX ne sont pas un nombre aléatoire.
Chaque position de bit reçoit un sens.

Les bits de poids fort portent l'information la plus importante.
De quel type d'entité s'agit-il ? Une personne, un lieu, un événement, un concept ?

Les bits suivants portent la classification.
S'il s'agit d'une personne : de quelle époque ? De quelle région ?

Plus on descend vers les bits de poids faible, plus l'information est précise.

Le principe clé est le suivant :

> L'ordre des bits est l'ordre d'importance de l'information.

La classification la plus fondamentale en haut,
les distinctions les plus fines en bas.

Ce n'est pas un simple tri.
C'est une philosophie de conception.

---

## D'un milliard à dix mille, en un seul passage

La puissance pratique de SIDX se voit dans les chiffres.

Supposons un milliard d'entités, chacune avec un SIDX de 64 bits.
Taille totale : 1 milliard × 8 octets = 8 Go.

Ces 8 Go tiennent entièrement en mémoire.

Vous voulez trouver « les entités humaines originaires d'Asie de l'Est ».
Si les bits de poids fort contiennent un indicateur « humain » et un code « Asie de l'Est »,
un seul masque de bits suffit pour filtrer.

```
mask   = 0xFF00_0000_0000_0000  (8 bits de poids fort : type + région)
target = 0x8100_0000_0000_0000  (humain + Asie de l'Est)

for each sidx in 1_milliard:
    if (sidx & mask) == target:
        ajouter aux candidats
```

Cette opération se parallélise avec SIMD.
La limite n'est pas le calcul mais la bande passante mémoire.
Lors d'une mesure préliminaire pour [SILK](/fr/projects/silk/), balayer avec un masque 100 millions de signatures de 128 bits (1,6 Go) a pris environ 27 millisecondes sur 8 threads Go.
Au même rythme, un milliard de SIDX de 64 bits (8 Go) prendraient un peu plus de 0,1 seconde.

Un milliard d'enregistrements réduits à dix mille.
Filtrer en détail les dix mille restants est instantané.

Zéro JOIN.
Zéro parcours d'arbre d'index.
Un seul ET bit à bit.

---

## Quelle largeur faut-il ?

Au début, je pensais qu'il fallait plus d'espace.

32 octets (256 bits). Un vecteur FP16 à 32 dimensions.
J'ai essayé de faire tenir dans l'identifiant tous les attributs clés d'une entité.
Humain ou non, genre, nationalité, époque, profession, région, vivant ou non, chemin de classification...

Mais j'ai compris une chose.

**L'identifiant n'a pas besoin de tout savoir.**

Il suffit de réduire un milliard d'enregistrements à dix mille.
La vérification précise s'occupe du reste.

C'est comme un poste de contrôle.
À un péage d'autoroute, pour savoir d'après la plaque
que « ce véhicule va vers la province de Gyeonggi »,
il n'est pas nécessaire de savoir ce qu'il y a dans le coffre.

Alors 64 bits suffiraient peut-être.
Avec les bits de poids fort pour le type et la grande classification,
et ceux de poids faible pour la classification fine,
réduire un milliard d'enregistrements à dix mille semble largement à portée.
64 bits = quatre mots de 16 bits. Léger même dans un flux.

Mais ce n'est encore qu'une hypothèse.
GEUL ne fixe pas la largeur sur le papier.
Entre des candidats comme 4 WORD (64 bits) et 16 WORD, il tranchera d'après des statistiques d'usage réelles.
D'ici là, les cibles sont désignées par des identifiants attribués séquentiellement,
et, une fois un SIDX attribué, les deux identifiants sont reliés comme désignant la même cible.

---

## Degradation gracieuse : le sens survit meme quand les bits sont tronques

Un autre atout de l'alignement semantique est ses caracteristiques de degradation.

Parce que les bits de SIDX sont ordonnes du plus important au moins important,
meme si les bits de poids faible sont endommages ou tronques,
l'information essentielle dans les bits de poids fort est preservee.

```
64 bits complets :  "Yi Sun-sin, commandant naval du Joseon du XVIe siecle"
48 bits :           "Officier militaire du Joseon du XVIe siecle"
32 bits :           "Humain d'Asie de l'Est du XVIe siecle"
16 bits :           "Humain"
8 bits :            "Entite physique"
```

A mesure que l'information est tronquee, la specificite est perdue,
mais la classification la plus fondamentale survit jusqu'au bout.

C'est une implementation au niveau des bits du principe de "degradation gracieuse".

Meme si une interruption reseau ne livre que des donnees partielles,
le systeme sait "je ne sais pas exactement qui c'est, mais c'est au moins une histoire a propos d'un humain"
et peut continuer a raisonner.

Un contour flou vaut mieux que le silence total.
Une comprehension partielle vaut mieux qu'un echec complet.

---

## Une requête devient un identifiant

La possibilité la plus fascinante qu'ouvre l'indexation sémantiquement alignée :

et si une requête en langage naturel pouvait devenir un SIDX temporaire ?

Un utilisateur demande : « Qui est le général qui a vaincu la marine japonaise pendant la guerre d'Imjin ? »

L'encodeur analyse la question.
Humain. Asie de l'Est. XVIe siècle. Domaine militaire.
En assemblant ces attributs en bits, on obtient un SIDX temporaire.

Ce SIDX temporaire balaie un milliard de SIDX.
Les entités dont les motifs de bits sont les plus proches remontent comme candidates.
Yi Sun-sin, Won Gyun, Gwon Yul, Yi Eok-gi...

En confrontant les informations détaillées à ces candidats, on obtient la réponse finale.

La recherche et la liaison d'entités (entity linking) pourraient devenir un seul mécanisme.
Sans moteur de recherche distinct,
sans chaîne de NER (reconnaissance d'entités nommées) distincte,
avec une seule comparaison de SIDX.

---

## Pourquoi pas un B-Tree ?

Les bases de données traditionnelles utilisent des index B-Tree.

Les B-Tree excellent à trouver une valeur précise dans des données triées en O(log n).
Pour « trouver Q50184 », ils sont optimaux.

Mais pour « trouver toutes les entités humaines originaires d'Asie de l'Est », ils sont faibles.
Les recherches à conditions composées exigent de croiser plusieurs index,
et le coût de ce croisement explose avec le volume de données.

Le balayage exhaustif SIDX + SIMD est une autre approche.

Si un B-Tree est un annuaire qui répond vite à « qui habite à cette adresse »,
un balayage SIDX est un profilage qui répond vite à « qui a ces caractéristiques ».

La nature de la question diffère, et donc la structure de données optimale aussi.

| Type de requête | B-Tree | Balayage SIDX |
|-----------|--------|-----------|
| Recherche par identifiant précis | O(log n), optimal | Inutile (réglé par hachage) |
| Filtrage à conditions composées | JOIN requis, lent | Un ET bit à bit, rapide |
| Recherche d'entités similaires | Impossible | Possible par similarité de bits |
| Insertion | O(log n), rééquilibrage | O(1), ajout |
| Complexité d'implémentation | Élevée | Faible |

Les deux se partagent le travail au lieu de rivaliser.
Aujourd'hui, SILK répond aux requêtes exactes comme « les documents dont le prédicat est P106 et l'objet Q169470 » avec des séquences triées et une recherche dichotomique.
Le balayage de signatures de bits, comme premier filtre en amont, est prévu pour l'étape suivante.

Simple. Force brute. Rapide.

---

## La sagesse de Huffman

L'attribution des bits de SIDX suit le principe du codage de Huffman.

Dans le codage de Huffman, les symboles fréquents reçoivent des codes courts,
et les symboles rares des codes plus longs.

Dans SIDX, l'information de classification la plus souvent nécessaire occupe les bits de poids fort,
et les détails rarement nécessaires les bits de poids faible.

L'attribution des Codec dans la grammaire GEUL suit le même principe.
Les formats à fréquence confirmée reçoivent un code direct court dans la TAG WORD,
et les formats rares passent par des formats d'Issuer avec TAG d'extension.

La sagesse de Huffman traverse toute cette conception.
Le coût le plus faible pour ce qui sert le plus.

---

## Résumé

Un identifiant traditionnel est une adresse. Une adresse ne sait rien.

1. Si l'identifiant ne porte pas de sens, il faut le suivre jusqu'aux données à chaque fois. C'est un JOIN.
2. Quatre JOIN sur un milliard d'enregistrements, c'est lent.
3. SIDX est une recherche visant à encoder le sens dans l'identifiant lui-même par alignement sémantique.
4. Un seul ET avec un masque de bits peut réduire un milliard d'enregistrements à dix mille. Zéro JOIN.
5. L'identifiant n'a pas besoin de tout savoir : il suffit de réduire les candidats. La largeur sera fixée par les statistiques d'usage.
6. Comme l'information la plus importante est dans les bits de poids fort, l'essentiel du sens survit même si des bits sont tronqués.
7. Si une requête en langage naturel peut devenir un SIDX temporaire, la recherche devient une opération sur les bits.

Au moment où un identifiant cesse d'être une adresse pour devenir une connaissance,
les règles de la base de données changent.
