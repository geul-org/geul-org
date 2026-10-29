---
title: "Pourquoi WordNet ?"
weight: 14
date: 2026-03-01T14:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["WordNet", "verbes", "primitifs sémantiques", "synset"]
summary: "Construire soi-même un système de verbes, c'est accepter des lacunes, de l'arbitraire et l'absence de fondement. GEUL en a appris la structure en bâtissant un livre de codes provisoire à partir des 13 767 verbes de WordNet, accumulés en 40 ans. WordNet n'étant ni CC0 ni indépendant de l'anglais, cette édition provisoire sera remplacée par un livre de codes de verbes sans WordNet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Nous avions besoin de verbes.

Pour qu'une IA puisse décrire le monde, il lui faut des verbes. Dans la phrase « Yi Sun-sin a construit le bateau-tortue » — l'amiral coréen du XVIe siècle et son célèbre navire blindé —, sans « a construit », il n'y a pas de phrase.

Pour l'identification des entités, il y a Wikidata. Yi Sun-sin est Q50184. Le bateau-tortue est Q695959. L'identification est déjà faite.

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

C'est la même relation qu'avec Wikidata. Wikidata indique que Yi Sun-sin est Q50184. Mais comment composer une phrase à propos de Yi Sun-sin n'est pas du ressort de Wikidata.

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

Les 13 767 verbes de WordNet sont la liste des verbes que les humains ont nommés. Elle est exhaustive, mais ce n'est pas tout.

« give » peut être décomposé davantage : CAUSE + HAVE + MOVE. C'est la décomposition en primitives sémantiques (semantic primitives). Une fois cette décomposition achevée, même les verbes absents de la liste peuvent s'exprimer comme des combinaisons d'atomes.

Si WordNet est la bibliothèque standard, le système d'atomes sémantiques est le compilateur. Tout comme un compilateur peut produire des fonctions absentes de la bibliothèque standard.

C'est un vaste chantier de recherche, à entreprendre après avoir réellement mis en service un livre de codes de verbes.

---

## Pourquoi c'est provisoire

GEUL a bâti sur cette structure un livre de codes de verbes : [wordnet-verb](/fr/repos/#wordnet-verb), qui attribue à chacun des 13 767 synsets verbaux de WordNet 3.0 un code de 16 bits, avec des codes proches pour des sens proches. Mais c'est une édition provisoire, de référence. Il y a trois raisons.

**Licence.** WordNet relève de la WordNet 3.0 License. Les productions publiques de GEUL sont en CC0. Des listes et définitions dérivées de WordNet ne peuvent pas être reprises dans un livre de codes CC0.

**Anglais.** Un synset est une unité de sens de mots anglais. GEUL a besoin d'un système de verbes qui ne soit lié à aucune langue particulière.

**Place.** La manière de porter les codes de verbes dans les enregistrements GEUL n'est pas encore décidée.

Cette édition provisoire sera donc remplacée par un livre de codes de verbes pur, sans WordNet. Ce que WordNet nous a appris demeure : la couverture doit être complète, les critères explicites, la hiérarchie fondée.

---

## Résumé

Tout projet qui cherche à bâtir un système de verbes se heurte à la même question : où le trouver ?

Le construire soi-même, c'est accepter des lacunes, de l'arbitraire et l'absence de fondement.
Partir de WordNet, c'est n'avoir pas de lacunes, un consensus et un ancrage dans les données.

GEUL est donc parti de WordNet. Mais ce n'est qu'un point de départ.
Les productions publiques doivent être en CC0, et un système de verbes ne doit pas être lié à l'anglais.
Apprendre la structure avec WordNet, puis la reconstruire à partir de sources CC0 et de données d'usage réelles.
Le principe reste le même : emprunter le dictionnaire, construire la grammaire soi-même.
