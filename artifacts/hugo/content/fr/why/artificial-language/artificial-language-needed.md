---
title: "Pourquoi un langage artificiel est-il nécessaire ?"
weight: 7
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["langage artificiel", "langage naturel", "hallucination", "LLVM IR"]
summary: "Le langage naturel a évolué pour la communication humaine. L'ambiguïté, la redondance et l'implicite sont des atouts pour les humains, mais des causes d'hallucination pour l'IA. Ni les langages de programmation ni les cadres sémantiques existants ne sont la réponse. Un nouveau langage artificiel satisfaisant six conditions simultanément est nécessaire."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

## Le langage naturel nous a amenes jusqu'ici. Mais il ne peut pas aller plus loin.

---

## La grande invention du langage naturel

La plus grande technologie que l'humanite ait creee est le langage naturel.

Ce n'est ni la decouverte du feu, ni l'invention de la roue, ni l'invention du semiconducteur.
C'est le langage naturel qui a rendu tout cela possible.

Parce que le langage naturel existait, le savoir pouvait etre transmis.
Parce que le langage naturel existait, la cooperation etait possible.
Parce que le langage naturel existait, les pensees des morts pouvaient etre heritees par les vivants.

La raison pour laquelle Homo sapiens domine la Terre n'est pas la force musculaire --- c'est le langage.
Pendant des dizaines de milliers d'annees, le langage naturel a ete le medium de toute activite intellectuelle humaine.

Et maintenant, le langage naturel est devenu le goulot d'etranglement de l'ere de l'IA.

---

## Pourquoi le langage naturel est-il apparu ?

Pour comprendre ce probleme, il faut revenir a la finalite originelle du langage naturel.

Le langage naturel a evolue pour la **communication en temps reel entre humains**.

Quand nos ancetres primitifs chassaient dans la savane,
ce qu'il fallait pour transmettre "Il y a un lion la-bas !" n'etait pas
une structure logique precise, mais une transmission rapide.

Cette pression evolutive a determine toutes les caracteristiques du langage naturel.

**L'ambiguite est une fonctionnalite.**
Peu importe si "la-bas" designe exactement combien de metres.
L'auditeur tourne la tete et voit le lion.
Le contexte compense l'ambiguite.

**La redondance est une fonctionnalite.**
Meme si la moitie du message est couverte par le bruit du vent, le sens doit etre transmis.
C'est pourquoi le langage naturel exprime la meme idee de multiples facons.

**L'implicite est une fonctionnalite.**
Si "Ca va ?" peut servir de salutation au lieu d'une vraie question sur la sante,
c'est parce que le contexte culturel partage decode l'implicite.

Toutes ces caracteristiques sont des avantages dans la communication entre humains.
C'est rapide, flexible, et cela s'adapte au contexte.

Le probleme survient lorsqu'on essaie d'appliquer cela a l'IA.

---

## Qu'est-ce que le langage naturel pour l'IA ?

Les LLM actuels recoivent du langage naturel en entree, raisonnent en langage naturel, et produisent du langage naturel en sortie.

C'est comme faire une experience de chimie
en enregistrant toutes les mesures par "pas mal", "un peu", "a peu pres ca".

"Napoleon etait grand."

Que se passe-t-il lorsque l'IA traite cette phrase ?

Qui dit qu'il etait grand ? Le locuteur ? Les historiens ? La societe francaise ?
Selon quels criteres est-il grand ? Militaire ? Moral ? Impact historique ?
A quelle epoque ? De son vivant ? Aujourd'hui ?
Avec quel degre de certitude ? Fait ? Opinion ? Speculation ?

Rien de tout cela n'est precise dans le langage naturel.
Tout est simplement implicite : "deduisez-le du contexte."

Les humains disposent de dizaines de milliers d'annees de hardware evolutif pour decoder ces implicites.
Expressions faciales, ton de la voix, experiences partagees, arriere-plan culturel.
L'IA n'a rien de tout cela. Elle n'a que le texte.

C'est pourquoi l'IA suppose. Et elle presente ses suppositions comme des certitudes.
Nous appelons cela "Hallucination".

L'hallucination n'est pas un bug. Tant que le langage naturel est utilise comme langage de raisonnement de l'IA,
c'est un resultat structurellement inevitable.

---

## L'hallucination nait de l'ambiguite du langage naturel

Precisons davantage ce point.

Quand un LLM repond "Napoleon est mort a Sainte-Helene le 5 mai 1821",
quelle est la base de cette phrase ?

C'est parce que des motifs similaires a cette phrase sont apparus avec une forte probabilite dans les donnees d'entrainement.

Cependant, de quelle source provient ce motif,
a quel point cette source est-elle fiable,
a quand remonte cette information,
y a-t-il d'autres recits contradictoires ---
tout cela ne peut pas etre structurellement contenu dans une sortie en langage naturel.

Le langage naturel n'a pas de place pour les metadonnees.

"Napoleon est mort a Sainte-Helene" et
"Les registres officiels britanniques indiquent que Napoleon est mort a Sainte-Helene"
ne sont en langage naturel que deux phrases de longueurs differentes.

Pourtant, d'un point de vue epistemologique, ce sont des types d'enonces completement differents.
L'un est une affirmation factuelle, l'autre est un recit avec source explicite.

Le langage naturel ne peut pas distinguer structurellement cette difference.
Donc l'IA ne peut pas la distinguer non plus.
Donc l'hallucination se produit.

---

## Les langages de programmation ne sont pas la reponse

"Alors pourquoi ne pas utiliser un langage de programmation ?"

Les langages de programmation ne sont pas ambigus. Ils sont structurels. Ils sont precis.
Mais les langages de programmation sont des **langages pour decrire des procedures**,
pas des **langages pour decrire le monde**.

Essayez d'exprimer "Napoleon etait grand" en Python.

```python
is_great("Napoleon") == True
```

Ceci n'est pas une description --- c'est un jugement booleen.
Qui a juge ? Sur quelle base ? Dans quel contexte ? Avec quel degre de certitude ?
Les langages de programmation n'ont pas de structure pour contenir cela.

Les formats de donnees comme JSON, XML, RDF sont les memes.
Ils ont une structure, mais il n'y a pas de systeme unifie definissant la semantique de cette structure.
Chaque projet cree son propre schema,
et ces schemas sont incompatibles entre eux.

Le langage naturel est riche en sens mais manque de structure.
Les langages de programmation ont une structure mais manquent de sens.
Les formats de donnees ont structure et sens, mais ne sont pas unifies.

Ce dont on a besoin est un type de langage different.

---

## La voie montree par LLVM

Il existe un precedent exact en informatique.

Dans les annees 1990, il y avait des dizaines de langages de programmation
et des dizaines d'architectures de processeurs.
Pour que chaque langage supporte chaque architecture,
il fallait N x M compilateurs.

La solution de LLVM etait une representation intermediaire (IR, Intermediate Representation).

Tous les langages sont traduits en LLVM IR.
LLVM IR est traduit vers toutes les architectures.
Il suffit de N + M convertisseurs.

Les utilisateurs ne voient pas LLVM IR.
Ils ecrivent du C++ et recoivent un executable.
LLVM IR travaille dans l'ombre.

GEUL est le LLVM IR pour l'IA.

Tous les langages naturels sont traduits en GEUL.
GEUL est stocke dans le WMS, utilise pour le raisonnement, puis retraduit en langage naturel.
Les utilisateurs ne voient pas GEUL.
Ils posent des questions en langage naturel et recoivent des reponses en langage naturel.
GEUL travaille dans l'ombre.

---

## Les conditions qu'un langage artificiel doit remplir

Pour depasser les limites du langage naturel sans perdre son expressivite,
un langage artificiel doit satisfaire simultanement les conditions suivantes.

**1. Elimination de l'ambiguite**

Quand "Napoleon etait grand" est saisi,
"qui, dans quel contexte, sur quelle base, avec quel degre de certitude a fait cette description"
doit etre structurellement precise.
Si un champ est vide, il doit etre marque comme vide.
Aucune dependance a l'implicite.

**2. Metadonnees integrees**

Pour chaque description, la source, le moment, le degre de confiance et le point de vue (POV)
doivent etre inclus non pas comme annotations separees, mais dans la structure meme de la description.
Sans cela, une IA boite blanche est impossible.

**3. Compatibilite LLM**

Le LLM doit pouvoir "apprendre" ce langage.
Il n'a pas besoin d'etre facile a comprendre pour les humains.
Ce qui importe c'est qu'il soit tokenisable, que les motifs soient reguliers,
et qu'il suive une structure fixe.

**4. Expressivite graphique**

Le monde est un graphe, pas un tableau.
Les entites sont des noeuds, et les relations sont des aretes.
Le langage artificiel doit pouvoir serialiser naturellement des graphes.

**5. Separation des faits et des descriptions**

"Napoleon est mort en 1821" n'est pas un fait.
"Les registres officiels britanniques indiquent que Napoleon est mort en 1821" est la donnee primaire.
Le langage artificiel doit imposer structurellement cette distinction.

**6. Extensibilite future**

Le systeme defini aujourd'hui doit pouvoir s'etendre avec retrocompatibilite
dans 10 ans, 100 ans, et dans un avenir inimaginable.

---

## Pourquoi les tentatives existantes sont insuffisantes

Ce n'est pas la premiere tentative de ce genre.

**L'esperanto** etait un langage artificiel pour les humains.
Il est structurel, mais n'a pas ete concu pour le raisonnement de l'IA.
Il a privilegie la facilite d'apprentissage plutot que la precision semantique.

**OWL/RDF** etait un systeme de representation semantique pour les machines.
Logiquement rigoureux, mais concu avant l'ere des LLM.
La conversion depuis/vers le langage naturel est difficile, et l'expression est verbeuse.
Et, de maniere fatale, c'est lent. Le raisonnement a grande echelle n'est pas realiste.

**Les graphes de connaissances (Wikidata, Freebase)** ont represente le monde sous forme de graphe.
Mais ils stockent des "faits", pas des "descriptions".
Ils stockent "Napoleon etait empereur" sous forme de triplet,
mais ne contiennent pas qui l'a affirme ni avec quel degre de certitude.

**Chain-of-Thought** enregistre le processus de raisonnement du LLM en langage naturel.
C'est une bonne direction, mais comme le medium d'enregistrement est le langage naturel,
il ne resout pas fondamentalement le probleme de l'ambiguite.

Toutes ces tentatives satisfont chacune une ou deux conditions,
mais aucune ne satisfait les six simultanement.

---

## GEUL : l'intersection des six conditions

GEUL se situe a l'intersection de ces six conditions.

Un format de flux base sur des mots de 16 bits.
Le contexte, la source et le degre de certitude sont structurellement integres dans chaque description.
Les graphes sont serialises sous forme de paquets de noeuds et d'aretes.
Il suit un motif fixe pouvant etre mappe 1:1 avec les tokens du LLM.
Il traite les descriptions (Claims) comme donnees primaires, pas les faits.
50% de l'espace d'adressage total est reserve pour l'avenir.

GEUL n'est pas visible pour l'utilisateur.
L'utilisateur parle en langage naturel et recoit des reponses en langage naturel.
Entre les deux, GEUL structure le raisonnement,
l'enregistre, l'accumule et le rend reutilisable.

---

## L'ere du langage naturel ne prend pas fin

Il y a un malentendu a eviter.

GEUL ne remplace pas le langage naturel.
Les humains continueront de parler, d'ecrire et de penser en langage naturel.
Le langage naturel survivra eternellement en tant que langage de l'humanite.

Ce que GEUL remplace,
c'est le role que le langage naturel occupait a l'interieur de l'IA.

Le medium du raisonnement.
Le format de stockage des connaissances.
Le protocole de communication entre systemes.

Dans ce role, le langage naturel a deja atteint ses limites.
Ces limites se manifestent par l'hallucination, la boite noire et l'inefficacite.

Le langage naturel a amene l'humanite jusqu'ici.
Ce merite est eternel.
Mais pour passer a l'etape suivante, un nouveau langage est necessaire.

C'est pourquoi un langage artificiel est necessaire.

---

## Resume

L'ambiguite du langage naturel est une fonctionnalite dans la communication humaine, mais un defaut dans le raisonnement de l'IA.

1. Le langage naturel n'a pas de place structurelle pour les metadonnees.
2. L'IA raisonne donc sans source, sans degre de certitude, sans contexte.
3. L'hallucination en resulte. Ce n'est pas un bug, mais une necessite structurelle.
4. Les langages de programmation decrivent des procedures, pas le monde.
5. Les systemes de representation semantique existants ne satisfont chacun qu'une ou deux conditions.
6. Un nouveau langage artificiel satisfaisant les six conditions simultanement est necessaire.

De meme que LLVM IR est le pont invisible entre les langages de programmation et le materiel,
GEUL est le pont invisible entre le langage naturel et le raisonnement de l'IA.
