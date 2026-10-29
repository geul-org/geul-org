---
title: "Pourquoi MD/JSON/XML ne suffisent pas"
weight: 9
date: 2026-02-26T12:00:15+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["format", "JSON", "XML"]
summary: "Markdown, JSON et XML ont chacun été conçus pour une époque et un but différents. Ils ont une structure, mais pas de sens unifié ni de place pour les sources. Pourquoi il faut un format à part pour enregistrer et accumuler le raisonnement de l'IA."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Les formats structures existent deja. Alors pourquoi un nouveau langage est-il necessaire ?

---

## L'objection la plus courante

Quand quelqu'un decouvre pour la premiere fois l'idee d'un langage de raisonnement pour l'IA, la premiere chose qu'il dit est :

"Les formats structures existent deja, non ?"

Il a raison. Ils existent. Beaucoup d'entre eux.

Il y a Markdown.
Il y a JSON.
Il y a XML.
YAML, TOML, Protocol Buffers, MessagePack, CSV...

Le monde deborde de formats de donnees.
Alors pourquoi l'IA raisonne-t-elle toujours en langage naturel ?

Pour repondre a cette question, nous devons identifier precisement ce que chaque format fait bien
et ce qu'il ne peut pas faire.

---

## Markdown : la memoire actuelle des agents IA

En 2026, le format le plus largement utilise par les agents IA est Markdown.

Claude Code se souvient dans des fichiers `.md`.
Les agents bases sur GPT laissent aussi des notes en Markdown.
CLAUDE.md, memory.md, notes.md.
La memoire a long terme de l'IA repose sur Markdown en ce moment meme.

Pourquoi Markdown ? La raison est simple.
Les LLM lisent et ecrivent bien le Markdown.
Le Markdown est abondant dans les donnees d'entrainement,
et sa structure est assez simple pour etre facilement generee et analysee.

Mais Markdown est **un format de document destine a etre lu par des humains.**

```markdown
# Etat du projet
## Strategie de cache
- Masque de bits SIMD adopte (decide le 28/01)
- Acceleration GPU en cours d'examen
## Non resolu
- Methode de generation de requetes a determiner
```

Comment une machine interprete-t-elle cela ?

Il y a un titre de section appele "Strategie de cache".
En dessous, il y a un element "Masque de bits SIMD adopte".
Il y a une date "(28/01)" entre parentheses.

Une machine ne peut pas comprendre cela structurellement.
Elle peut deduire de `##` que "Strategie de cache" est un titre de section,
mais la relation semantique qu'il s'agit d'"un sous-theme de l'architecture" n'existe pas en Markdown.
Un humain sait que "28/01" est une date, mais une machine doit deviner.
Le 28 janvier, ou un vingt-huitieme ?

Finalement, pour "comprendre" le Markdown, un LLM doit effectuer une interpretation en langage naturel.
Le Markdown est du langage naturel avec de l'indentation par-dessus ---
ce n'est pas de la donnee structuree.

---

## JSON : la structure sans le sens

JSON va un cran plus loin que Markdown.

```json
{
  "entity": "Yi Sun-sin",
  "birth": "1545",
  "death": "1598",
  "occupation": "naval_commander"
}
```

Il y a de la structure. Les paires cle-valeur sont explicites.
Une machine peut l'analyser. Les champs sont accessibles.

Mais il y a un probleme.

**JSON ne sait pas ce que la cle "entity" signifie.**

La personne qui a cree ce JSON sait que "entity" signifie "un objet".
Dans le JSON d'une autre personne, le meme concept pourrait etre "name", "subject" ou "item".

```json
{"name": "Yi Sun-sin"}
{"subject": "Yi Sun-sin"}
{"item": "Yi Sun-sin"}
{"entity": "Yi Sun-sin"}
```

Quatre JSON expriment la meme chose,
mais une machine ne peut pas savoir qu'ils sont identiques.

JSON manque de **semantique partagee.**
Il y a de la structure, mais il n'y a pas d'accord sur ce que cette structure signifie.

Chaque projet cree son propre schema.
Chaque API utilise ses propres noms de champs.
Connecter le schema A au schema B necessite encore une autre couche de transformation.

C'est la Tour de Babel.
La structure existe, mais personne ne comprend la structure des autres.

---

## XML : la taxe de la verbosite

XML a essaye de resoudre le probleme de JSON.

Espaces de noms, definitions de schemas (XSD), definitions de types de documents (DTD).
Il fournit des meta-structures qui definissent le sens des structures.

```xml
<entity xmlns="http://example.org/schema">
  <name>Yi Sun-sin</name>
  <birth>
    <year>1545</year>
    <calendar>lunar</calendar>
  </birth>
  <death>
    <year>1598</year>
    <cause>killed_in_action</cause>
  </death>
</entity>
```

Le sens peut etre defini. La structure peut etre imposee avec des schemas.
C'est plus rigoureux que JSON.

Mais XML a un probleme fatal.

**Il est verbeux.**

Dans le XML ci-dessus, l'information reelle est "Yi Sun-sin, 1545, 1598, killed_in_action".
Tout le reste, ce sont des balises. Les balises ouvrantes et fermantes surpassent l'information en nombre.

Pourquoi est-ce un probleme pour l'IA ?

La fenetre de contexte d'un LLM est finie.
Si transmettre la meme information necessite 3 fois plus de tokens,
la quantite d'information qui tient dans le contexte se reduit a un tiers.

XML est verbeux pour que les humains puissent le lire facilement.
Un langage de raisonnement pour l'IA ne doit pas avoir ce gaspillage.
Pour un LLM, la balise `<name>` est du gaspillage.

Et XML est une conception de la fin des années 1990.
Il a été créé à une époque où les LLM n'existaient pas, pour les humains et les logiciels traditionnels.
Il n'a jamais été conçu comme langage de raisonnement pour l'IA.

---

## La limite commune

Markdown, JSON, XML.
Chacun des trois formats a ses points forts, mais ils partagent des limites.

**Ils sont textuels.**
Tous se sérialisent en chaînes de caractères.
Une machine doit les analyser pour les traiter.
L'analyse a un coût.

GEUL est une suite de mots de 16 bits.
Le premier mot de chaque enregistrement indique son type et sa longueur ;
les frontières des enregistrements sont donc connues immédiatement, sans interpréter de chaînes.

**Ils ont été conçus avant l'ère des LLM.**
Markdown date de 2004. JSON de 2001. XML de 1998.
Ils ont été conçus à une époque où la notion de LLM n'existait pas,
pour les humains ou les logiciels traditionnels.

Un langage de raisonnement pour l'IA doit être conçu à l'ère des LLM, pour les LLM.
Dimensionner le mot de 16 bits sur les vocabulaires des LLM
présuppose l'existence des LLM.

**Leur système sémantique unifié est absent ou incomplet.**
Markdown n'a aucun système sémantique.
JSON a une structure mais pas de sens.
XML peut définir des schémas, mais ils ne sont pas unifiés.

GEUL désigne les cibles par identifiant, et non par nom :
des Reference comme un QID de Wikidata ou un identifiant de document émis par un Issuer.
Où qu'il soit utilisé, le même identifiant désigne la même cible. Aucune conversion nécessaire.

---

## Resume

| Format | Structure | Sens | Adapté aux LLM | Binaire | Place pour les sources | Qualificatifs |
|--------|-----------|---------|---------------|--------|---------------|----------------|
| Markdown | Faible | Aucun | Élevé | Non | Aucune | Aucun |
| JSON | Oui | Aucun | Moyen | Non | Aucune | Aucun |
| XML | Oui | Partiel | Faible | Non | Aucune | Aucun |
| **Langage de raisonnement idéal** | **Oui** | **Oui** | **Élevé** | **Oui** | **Oui** | **Oui** |

Un nouveau format est necessaire non pas parce que les formats existants sont mauvais.
C'est parce que les formats existants ont ete faits a une epoque differente, pour un objectif different.

Markdown a ete fait pour les documents que les humains lisent.
JSON a ete fait pour l'echange de donnees dans les API web.
XML a ete fait pour la serialisation generique de documents et de donnees.

Un format pour enregistrer et accumuler le raisonnement de l'IA. Cela n'existe pas encore.

Quand l'objectif est different, l'outil doit etre different.
