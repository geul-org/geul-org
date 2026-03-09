---
title: "STML — SSOT Template Markup Language"
weight: 1
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "Un langage de déclaration d'UI indépendant du framework. Définit ce que les pages affichent et font avec des attributs HTML5 data-*, valide symboliquement contre OpenAPI et génère du code React."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — déclaration d'UI indépendante du framework.

Le code frontend mélange deux choses : **vos décisions** et **le câblage du framework**. Quelle API appeler, quels champs afficher, dans quel ordre, sous quelles conditions — ces décisions sont enterrées dans les React hooks ou les Vue composables. En changeant de framework ou en refactorisant, les décisions sont réinterprétées ou perdues.

STML les sépare. Les décisions restent dans du HTML standard avec des attributs `data-*`. Le câblage du framework est généré ou délégué.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">Dépôt GitHub</a>

## Ce qui est préservé

Tout dans le HTML STML est une décision utilisateur :

- **Quels endpoints API** appeler (`data-fetch`, `data-action`)
- **Quels champs** afficher ou collecter (`data-bind`, `data-field`)
- **Dans quel ordre** les éléments apparaissent (structure DOM)
- **L'apparence** (classes Tailwind, balises HTML)
- **Quel texte** les utilisateurs voient (titres, placeholders, libellés de boutons)
- **Quelles conditions** contrôlent la visibilité (`data-state`)
- **Quels composants** gèrent l'UX spécial (`data-component`)
- **Le comportement des listes** — pagination, tri, filtrage

Ce n'est pas React. Ce n'est pas Vue. C'est ce que fait votre page, déclaré en HTML5 standard.

## Validation

Le validateur intégré vérifie STML contre OpenAPI avant de générer du code :

- L'operationId existe-t-il ? La méthode HTTP est-elle correcte ?
- Les champs de requête, réponse et paramètres correspondent-ils au schéma ?
- Les colonnes de tri/filtre/inclusion sont-elles dans les listes autorisées ?
- Les composants référencés existent-ils ?

Détecte les incompatibilités frontend-API au CI, pas au runtime.

```bash
stml validate specs/my-project    # 12 vérifications symboliques contre OpenAPI
```

## Attributs data-*

| Attribut | Ce qu'il déclare |
|---|---|
| `data-fetch` | Charge des données depuis un endpoint GET |
| `data-action` | Envoie des données vers un endpoint POST/PUT/DELETE |
| `data-field` | Collecte un champ du corps de la requête |
| `data-bind` | Affiche un champ de la réponse |
| `data-param-*` | L'opération nécessite un paramètre de chemin/requête |
| `data-each` | Itère sur un champ tableau |
| `data-state` | Affichage conditionnel |
| `data-component` | Délègue à un composant personnalisé |
| `data-paginate` | Liste paginée |
| `data-sort` | Liste triable (colonne et direction par défaut) |
| `data-filter` | Liste filtrable (quelles colonnes) |
| `data-include` | Inclut des ressources liées |

## Licence

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
