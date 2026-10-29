---
title: "Pourquoi Wikidata"
weight: 13
date: 2026-02-26T12:00:17+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["Wikidata", "Ontologie", "wikigeul", "SIDX"]
summary: "GEUL ne rejette pas Wikidata. Il charge le dump sans perte et fait de chacune des quelque 120 millions d'entités un document GEUL contenant toutes les langues. Concevoir un identifiant sémantiquement aligné (SIDX) à partir de sa classification et de ses statistiques de fréquence reste une recherche en cours."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## GEUL ne rejette pas Wikidata. Il se dresse dessus.

---

## On ne peut pas créer une langue sans dictionnaire

Toute langue a besoin d'un vocabulaire.

Le coréen a le dictionnaire coréen.
L'anglais a le dictionnaire anglais.
Les langages de programmation ont des bibliothèques standard.

Il en va de même pour une langue artificielle.
Une liste d'entités, une liste de relations, une liste de propriétés.
Quel code représente « Samsung Electronics » dans cette langue ?
Quel code représente la relation « capitale » ?
Il faut un vocabulaire avant de pouvoir écrire une phrase.

Comment construire ce vocabulaire ?
Il y a deux approches.

Le construire à partir de zéro.
Ou utiliser ce qui existe déjà.

---

## Construire à partir de zéro : la leçon de CYC

Le projet CYC a débuté en 1984.

Son objectif était de formaliser et stocker le savoir de sens commun général.
L'ontologie a été conçue à partir de zéro.
Des concepts ont été définis, des relations ont été définies, des règles ont été définies.
Les experts les ont saisis manuellement.

Trente ans ont passé.
Des millions de règles ont été saisies.

Pourtant, cela était loin de suffire à couvrir la connaissance du monde.
Il fallait concevoir une ontologie séparée pour chaque domaine.
Maintenir la cohérence entre les domaines s'est avéré difficile.
Chaque fois qu'un nouveau concept apparaissait, l'ontologie devait être révisée.
Les révisions entraient fréquemment en conflit avec les règles existantes.

Ce que CYC a démontré, ce n'est pas son potentiel mais ses limites.
Confier à une petite équipe d'experts la conception de l'ontologie du monde
devient impossible à maintenir à grande échelle.

---

## Ce qui existe déjà : Wikidata

Wikidata a été lancé en 2012.

Une base de connaissances structurée gérée par la Fondation Wikimedia.
N'importe qui peut la modifier.
Selon le dump du 19 octobre 2026 : environ 121,97 millions d'entités.
Dont 13 991 propriétés.
Environ 1,78 milliard de déclarations.
Des libellés dans plus de 600 codes de langue.

L'échelle que CYC n'a pas pu atteindre en 30 ans avec une équipe d'experts,
Wikidata l'a atteinte en 14 ans grâce à une communauté.

Voyons ce que Wikidata fournit.

**Identifiants d'entités.** Q-ID. Samsung Electronics est Q20718. Séoul est Q8684. Yi Sun-sin est Q217300. Des identifiants uniques au niveau mondial. Indépendants de la langue.

**Identifiants de propriétés.** P-ID. « Lieu du siège social » est P159. « Date de création » est P571. « Population » est P1082. Les relations et propriétés sont identifiées de manière unique.

**Structure hiérarchique.** P31 (instance of) et P279 (subclass of) forment une hiérarchie de types. « Séoul → ville → établissement humain → entité géographique. » Le système de classification du monde est exprimé à travers ces deux propriétés.

**Libellés multilingues.** Le libellé coréen de Q20718 est « 삼성전자 », le libellé anglais est « Samsung Electronics », le libellé japonais est « サムスン電子 ». Un identifiant, des noms différents pour chaque langue.

**Validation communautaire.** Des contributeurs du monde entier. Détection du vandalisme. Exigence de sources. Pas parfait, mais plus évolutif qu'une petite équipe d'experts.

Il n'y a aucune raison de construire tout cela à partir de zéro.

---

## GEUL reprend Wikidata tel quel

GEUL n'invente pas de nouveaux identifiants pour Wikidata.
Il les utilise tels quels.

La grammaire de GEUL a des References dédiées à Wikidata.
[WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) écrit le nombre d'un Q-ID, et [WIKIDATA-PID](/fr/grammar/reference/wikidata-pid/) celui d'un P-ID, sous forme d'entier non signé.
Q42 est l'entier 42. P31 est l'entier 31.
Comme ce sont des entiers et non des chaînes, les comparer ne demande aucune normalisation.

Le chemin est le suivant.

**Étape 1 : chargement sans perte.**
[wikipg](/fr/repos/#wikipg) charge le dump JSON de Wikidata dans PostgreSQL.
Il stocke entités, libellés, descriptions, alias, déclarations, qualificatifs, références et liens de sites dans l'ordre du dump,
et conserve chaque ligne du dump telle quelle.
Le fichier du dump lui-même (URL, taille, sommes de contrôle, commit du chargeur) est aussi enregistré.
C'est seulement quand rien n'est jeté qu'on peut vérifier ensuite ce qui a été repris et ce qui a été ignoré.

**Étape 2 : un document par entité.**
[wikigeul](/fr/repos/#wikigeul) lit le dump chargé et produit un document GEUL pour chaque élément et chaque propriété.
Il contient libellés, descriptions, alias, déclarations avec leurs qualificatifs et références, et liens de sites.
Toutes les langues vont dans le même document. Rien n'est découpé par langue.

Tous les documents partagent un seul Issuer, `0x00010000` (wikidata.geul.org).
Un ID de document fait 64 bits. L'octet de poids fort est la lettre du type d'entité, et les 56 bits de poids faible sont son numéro.
Le document de Q42 est `0x510000000000002a`. `0x51` est `Q`, et `0x2a` vaut 42.
Le document de P31 est `0x500000000000001f`.
L'hexadécimal suffit pour savoir à quelle entité appartient le document.
On peut lire un vrai document du début à la fin dans [Exemple : un élément Wikidata](/fr/grammar/example/).

**Étape 3 : citer par des entiers.**
Dans les déclarations, éléments et propriétés s'écrivent comme des entiers.
« Q42 est un être humain (Q5) » est un TRIPLE de trois entiers : P31, Q42 et Q5.
Cet entier est le numéro de l'ID de document.
Depuis n'importe quelle déclaration, on va directement au document de ce qu'elle nomme.

Les références sont reprises elles aussi.
Une référence Wikidata devient un SOURCE GEUL.
L'en-tête de chaque document indique de quel dump il provient et quel outil (commit) l'a converti.

**Étape 4 : publier en archives pack.**
On ne peut pas publier 120 millions d'entités sous forme de 120 millions de fichiers.
Les documents sont regroupés dans une archive pack par Issuer, et les enregistrements sont compressés avec zstd.
Le lecteur ne récupère que les documents dont il a besoin, pas l'archive entière.

Pour l'instant, la conversion est vérifiée sur la plage Q1–Q10000.
L'aller-retour par la conversion inverse, l'archive et la complétude sont contrôlés de manière exhaustive.
La conversion complète et la publication viendront ensuite.

---

## SIDX vient ensuite

Un Q-ID est un numéro attribué dans l'ordre d'enregistrement.
Des numéros proches ne veulent pas dire des sens proches.
Q42 est Douglas Adams ; Q41 est la Grèce, et Q43 la Turquie.

GEUL étudie aussi un autre type d'identifiant.
[SIDX](/fr/grammar/reference/geul-sidx/) (Semantic-aligned Index), un identifiant sémantiquement aligné qui donne des valeurs proches à des choses de sens proche.
Le but est de mettre le sens dans les bits eux-mêmes,
pour que les bits de poids fort suffisent à dire s'il s'agit d'une personne, d'un lieu ou d'une organisation.

SIDX reste une recherche antérieure à la v1.
La grammaire ne lui réserve qu'une place : la Reference GEUL-SIDX.
Sa largeur n'est pas fixée. 64 bits, 256 bits et d'autres sont à l'étude, et le choix suivra les statistiques.
Aucun SIDX n'a encore été attribué.
C'est pourquoi les documents Wikidata actuels s'écrivent avec des Q-ID, sans SIDX.
Une fois les SIDX attribués, l'identifiant existant et le SIDX d'une même chose seront reliés par [SAME-NODE](/fr/grammar/edge/same-node/).

C'est là que Wikidata intervient de nouveau.
La recherche sur SIDX part du système de classification et des statistiques de fréquence de Wikidata.
La piste étudiée est la suivante.

**Extraction des types.**
Rassembler les Q-ID utilisés comme objets de P31 (instance of).
C'est la liste des « types ».
« Être humain (Q5) », « ville (Q515) », « pays (Q6256) », « entreprise (Q4830453) »...
Compter les instances de chaque type.

**Construction de la hiérarchie.**
Construire un arbre à partir des relations P279 (subclass of) entre types.
« Ville → établissement humain → entité géographique → entité. »
Comment traiter l'héritage multiple, quand un type appartient à plusieurs types parents, reste une question ouverte.

**Attribution des bits.**
La structure de l'arbre devient la relation de préfixes des motifs de bits.
Les sous-types d'un même parent partagent le même préfixe.
« Ville » et « village » partagent le préfixe d'« établissement humain ».
Les types qui ont beaucoup d'instances reçoivent un préfixe plus court, c'est-à-dire un espace de numéros plus large.
C'est la même idée que le codage de Huffman.

Ce n'est encore qu'une hypothèse.
Des problèmes restent à résoudre.
Un SIDX déjà attribué ne doit pas bouger quand les statistiques changent.
La même valeur ne doit jamais être attribuée à deux choses.
Il faut aussi décider du format de publication du livre de codes et du registre.

---

## Ce que Wikidata fournit

Sur ce chemin, Wikidata fournit trois choses.

**Les identifiants.**
La réponse à « que désigne-t-on dans le monde ? ».
Les Q-ID et P-ID deviennent tels quels des References entières de GEUL.
Le savoir de Wikidata peut être repris dans des documents GEUL,
et les identifiants Wikidata se lisent directement dans les documents GEUL.

**Le système de classification.**
La réponse à « quels types de choses existent dans le monde ? ».
CYC l'a fait concevoir par une équipe d'experts.
GEUL le prend dans Wikidata.
Le but de la recherche est de transformer le système de classification sur lequel les contributeurs se sont accordés pendant 14 ans
en arbre de bits SIDX.

**Les statistiques de fréquence.**
La réponse à « combien de choses de chaque type existent dans le monde ? ».
S'il y a 9 millions d'entités humaines et 1 million d'astéroïdes,
le type « être humain » devrait recevoir un code plus efficace que « astéroïde ».
La fréquence d'usage réelle devient la base de la conception des codes.

---

## Ce que Wikidata ne fournit pas

Wikidata est un dictionnaire. Un dictionnaire n'est pas une langue.

Un dictionnaire fournit une liste de mots.
Une langue fournit la grammaire pour composer des phrases à partir de mots.

Ce que Wikidata ne fournit pas, c'est ce que GEUL ajoute.

**Des faits aux affirmations.**
L'unité de base de Wikidata est un fait (Fact).
« La population de Séoul est de 9,74 millions. »
C'est soit vrai, soit faux.

L'unité de base de GEUL est une affirmation (Claim).
« Selon A, la population de Séoul est d'environ 9,74 millions. (confiance 0,9, en date de 2023) »
Qui affirme, avec quel niveau de certitude, et en date de quand — tout cela est intégré dans la déclaration.
Cette différence est traitée en détail dans [Pourquoi des affirmations, pas des faits](/fr/why/claims-not-facts/).

**Qualificateurs verbaux.**
Wikidata n'a pas de place pour exprimer les nuances des verbes.
Dans « Yi Sun-sin a remporté la bataille de Myeongnyang »,
où se trouvent le temps, l'aspect, l'évidentialité, le mode et la confiance ?
Dans Wikidata, ceux-ci sont partiellement exprimés par des qualificatifs,
mais il n'existe pas de système systématique de qualification verbale.

GEUL conçoit un système de qualification verbale qui attache structurellement à chaque déclaration
des dimensions comme le temps, l'aspect, la polarité, l'évidentialité, le mode, la volitivité et la certitude.
C'est, lui aussi, un chantier antérieur à la v1.

**Mots de 16 bits.**
La représentation de Wikidata n'a pas été conçue pour les fenêtres de contexte.
JSON-LD, RDF, SPARQL.
Lisibles par les machines, mais pas efficaces en tokens.

GEUL est une suite de mots de 16 bits.
Le premier mot d'un enregistrement (la TAG WORD) indique le type et la longueur de cet enregistrement.
On peut filtrer et sauter des enregistrements même sans livre de codes.
Un système de représentation construit sur la prémisse de fenêtres de contexte finies.
Cela a déjà été traité dans [Pourquoi pas MD/JSON/XML](/fr/why/not-md-json-xml/).

**Pipeline de contexte.**
Wikidata est un entrepôt. GEUL fait partie d'un pipeline.
Clarification, validation, filtrage, vérification de cohérence, exploration — tout ce qui a été discuté dans cette série fonctionne sur la représentation structurée de GEUL.
Wikidata ne dispose pas de ce pipeline.
Et n'en a pas besoin. L'objectif de Wikidata est différent.

---

## La relation entre un dictionnaire et une langue

En résumé :

Wikidata est le vocabulaire du monde.
Quelles entités existent,
quelles relations existent,
quels types existent et comment ils sont classés.
Une communauté l'a construit pendant 14 ans.

GEUL construit la grammaire par-dessus ce vocabulaire.
Les identifiants du vocabulaire → les References entières de GEUL.
Les entrées du vocabulaire → un document GEUL par entité.
Le système de classification et les statistiques de fréquence du vocabulaire → la matière de la recherche sur SIDX.

Et il ajoute ce qui manque au vocabulaire.
Structure des affirmations. Qualification verbale. Mots de 16 bits. Pipeline de contexte.

Pourrait-on construire GEUL sans Wikidata ?
Oui. En concevant l'ontologie à partir de zéro, comme CYC.
Mais cela a été tenté il y a 40 ans, et les résultats parlent d'eux-mêmes.

Parce que Wikidata existe, GEUL ne conçoit pas d'ontologie.
Il reprend un consensus existant.

---

## Résumé

Une langue artificielle a besoin d'un vocabulaire.
En construire un à partir de zéro est ce qu'a tenté CYC, et 30 ans ont prouvé les limites de cette approche.

Wikidata est le vocabulaire du monde, avec environ 120 millions d'entités et environ 1,78 milliard de déclarations (dump d'octobre 2026).
Une communauté l'a construit pendant 14 ans.

GEUL reprend ce vocabulaire tel quel.
wikipg charge le dump dans PostgreSQL sans perte,
et wikigeul fait de chaque entité un document GEUL qui contient toutes les langues.
Éléments et propriétés sont cités par des entiers, et les documents sont publiés en archives pack.

SIDX est la recherche qui vient ensuite.
Elle conçoit un identifiant sémantiquement aligné à partir des fréquences d'instances de P31 et de la hiérarchie de P279.
Ni sa largeur ni ses attributions ne sont encore fixées.

Wikidata est un dictionnaire ; GEUL est une langue.
Un dictionnaire fournit des mots ; une langue fournit la grammaire.
GEUL construit la structure des affirmations, la qualification verbale, les mots de 16 bits et un pipeline de contexte par-dessus le vocabulaire de Wikidata.

GEUL ne rejette pas Wikidata.
Il se dresse dessus.
