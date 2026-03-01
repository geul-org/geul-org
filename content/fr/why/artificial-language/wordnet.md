---
title: "Pourquoi WordNet ?"
weight: 14
date: 2026-03-01T14:00:00+09:00
lastmod: 2026-03-01T14:00:00+09:00
tags: ["WordNet", "verbes", "primitifs sémantiques", "synset"]
summary: "Construire un système de verbes à partir de zéro signifie des lacunes, des choix arbitraires et aucune justification. WordNet est une base de données lexicale de 40 ans avec 13 767 synsets de verbes créés par des linguistes. Nous empruntons le dictionnaire et construisons la grammaire par-dessus."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Nous avions besoin de verbes.

Pour qu'une IA puisse décrire le monde, il lui faut des verbes. Dans la phrase « Yi Sun-sin a construit le bateau-tortue » — l'amiral coréen du XVIe siècle et son célèbre navire blindé —, sans « a construit », il n'y a pas de phrase.

Pour l'identification des entités, il y a Wikidata. Yi Sun-sin est Q28090. Le bateau-tortue est Q249845. L'identification est déjà faite.

Pour les verbes, il n'existe rien d'équivalent. « construire » n'a pas d'identifiant. Savoir si « construire », « fabriquer » et « produire » ont le même sens ou un sens différent — il n'y a pas de critère consensuel.

Tout projet qui traite des verbes — qu'il s'agisse de graphes de connaissances, de recherche sémantique ou de conception de langage structuré — finit par rencontrer cette question. D'où tirer le système de verbes.

---

## Construire soi-même

On peut concevoir une liste de verbes à partir de rien.

move, give, think, feel, say. On fixe une cinquantaine de verbes de base, puis on ajoute des verbes subordonnés. Sous move : walk, run, crawl. Sous give : donate, bestow, grant.

Trois problèmes apparaissent.

Premièrement, des oublis. Quand on énumère des verbes de mémoire, il y a toujours des manques. On oublie « adsorber », on oublie « ruminer », on oublie « se résigner ». Au moment où le verbe manquant est nécessaire, le système se brise.

Deuxièmement, pas de critère. Walk et stroll sont-ils des verbes distincts ou des variantes du même verbe ? Si l'on construit soi-même, cette décision repose sur l'intuition du concepteur. L'intuition varie d'une personne à l'autre.

Troisièmement, la hiérarchie est arbitraire. On a placé walk sous move, mais walk pourrait aussi être un sous-type de travel. Le choix revient au concepteur. Ce choix n'a pas de justification.

Un système de verbes construit à la main est parfait dans l'esprit de son concepteur. Pour quiconque d'autre, c'est « pourquoi cette classification ? ».

---

## L'héritage WordNet

Une base de données lexicale de l'anglais, développée à l'Université de Princeton depuis 1985.

Pendant 40 ans, des linguistes ont regroupé les mots anglais en unités de sens (synset) et les ont reliés par des relations hiérarchiques. Rien que pour les verbes, il y a 13 767 synsets. Chaque synset possède un identifiant unique, une définition et des relations explicites avec d'autres synsets.

« donate » et « bestow » sont dans le même synset. Cela signifie qu'ils ont le même sens.
« donate » est un troponym de « give ». Cela signifie que c'est une forme spécifique de give.
« give » est un troponym de « transfer ». Cela signifie que c'est une forme spécifique de transfer.

Cette hiérarchie est déjà établie pour 13 767 verbes.

Pas de lacunes. Parce que les linguistes l'ont enrichie pendant 40 ans.
Un critère existe. Parce que les définitions et les relations des synsets sont explicites.
La hiérarchie est fondée. Parce que les relations de troponymie reposent sur l'analyse linguistique.

---

## Dictionnaire et grammaire sont distincts

Si WordNet est le dictionnaire des verbes, comment les utiliser est une question séparée.

WordNet indique le sens de « give » et sa relation avec « donate ». Mais il ne précise pas comment utiliser « give » dans une phrase — qui donne, quoi, à qui — cette structure n'y figure pas.

C'est la même relation qu'avec Wikidata. Wikidata indique que Yi Sun-sin est Q28090. Mais comment composer une phrase à propos de Yi Sun-sin n'est pas du ressort de Wikidata.

On emprunte le dictionnaire, mais on construit la grammaire soi-même.

Ce que l'on prend de WordNet : les identifiants de synset, les définitions sémantiques, l'arbre hiérarchique des troponyms. Les verb frames, les structures de participants et les patrons syntaxiques que WordNet fournit également, chaque projet a intérêt à les concevoir lui-même. L'information syntaxique de WordNet est liée à l'anglais, et le système sémantique des verbes et leur mode d'emploi sont des problèmes distincts.

---

## De 13 767 à 10

Énumérer les 13 767 verbes de WordNet n'a pas de sens en soi. Il faut une structure.

En remontant l'arbre des troponyms de WordNet, on atteint des nœuds terminaux sans parent. Les verbes racines. Il y en a 559.

En regroupant ces 559 par sens, on obtient 68 sous-primitifs (sub-primitive).
En regroupant encore ces 68, on obtient 10 primitifs (primitive).

```
13 767 verbes → 559 racines → 68 sous-primitifs → 10 primitifs

BE          — existence, possession, localisation
PERCEIVE    — perception, détection, découverte
FEEL        — émotion, préférence, désir
THINK       — pensée, jugement, mémoire
CHANGE      — changement, début, fin
CAUSE       — action, création, destruction
MOVE        — déplacement, arrivée, départ
COMMUNICATE — parole, indication, accord
TRANSFER    — transmission, réception, échange
SOCIAL      — coopération, compétition, appartenance
```

Ces 10 éléments sont les primitifs sémantiques des verbes humains. Ils ne proviennent pas de l'intuition d'une seule personne, mais de la structure de 40 ans d'accumulation WordNet, 13 767 points de données.

Cette hiérarchie à 4 niveaux — primitif, sous-primitif, racine, verbe individuel — permet de régler la résolution. Vue grossière : 10 types d'actions. Vue fine : 13 767 types d'actions. Il suffit de couper à la résolution nécessaire.

---

## Extension et compression

13 767 ne suffisent pas ? On peut ajouter de nouveaux verbes. Verbes multilingues, néologismes, termes spécialisés. Il suffit de les rattacher au sous-primitif approprié. Le système existant ne se brise pas.

13 767, c'est trop ? On peut fusionner les synsets synonymes. Rediriger donate → give. Les données précédemment enregistrées sous donate pointent vers give. Le même principe qu'un HTTP 301.

Ce qui compte, c'est l'ordre. D'abord tout inclure, puis faire tourner le système, examiner les données d'utilisation, et ensuite élaguer. Élaguer sur le papier sans données revient à supprimer des distinctions nécessaires.

---

## Au-delà : les atomes sémantiques

Les 13 767 verbes de WordNet sont la liste des verbes nommés par les humains. Exhaustive, mais pas la totalité.

On peut décomposer « give » davantage. CAUSE + HAVE + MOVE. Une décomposition en atomes sémantiques (semantic primitive). Une fois cette décomposition achevée, même les verbes absents de la liste peuvent s'exprimer par combinaison d'atomes.

Si WordNet est la bibliothèque standard, le système d'atomes sémantiques est le compilateur. Tout comme un compilateur peut créer des fonctions absentes de la bibliothèque standard.

C'est un vaste sujet de recherche, à aborder une fois le système basé sur WordNet opérationnel. Pour l'instant, la bibliothèque standard suffit.

---

## Synthèse

Tout projet qui cherche à établir un système de verbes rencontre la même question. D'où le tirer.

Construire soi-même : des lacunes, de l'arbitraire, pas de justification.
Construire sur WordNet : pas de lacunes, un consensus, des données comme fondement.

WordNet est le dictionnaire des verbes de l'humanité, accumulé par des linguistes pendant 40 ans.
Emprunter les mots de ce dictionnaire, mais construire la grammaire soi-même.
C'est la raison pour laquelle on utilise Wikidata pour les entités, et WordNet pour les verbes.
