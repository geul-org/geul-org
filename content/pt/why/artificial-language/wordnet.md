---
title: "Por que WordNet?"
weight: 14
date: 2026-03-01T14:00:00+09:00
lastmod: 2026-03-01T14:00:00+09:00
tags: ["WordNet", "verbos", "primitivos semânticos", "synset"]
summary: "Construir um sistema de verbos do zero significa lacunas, escolhas arbitrárias e falta de fundamento. WordNet é um banco de dados lexical de 40 anos com 13.767 synsets de verbos criados por linguistas. Emprestamos o dicionário e construímos a gramática por cima."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verbos eram necessários.

Para que a IA descreva o mundo, é preciso haver verbos. Na frase "O almirante coreano Yi Sun-sin construiu o navio-tartaruga", sem "construiu" não há frase.

Para identificação de entidades existe a Wikidata. Yi Sun-sin é Q28090. O navio-tartaruga é Q249845. A identificação já está feita.

Para verbos não existe equivalente. Não há um ID para "construir". Não há critério consensual que determine se "construir", "fabricar" e "produzir" têm o mesmo sentido ou sentidos diferentes.

Todo projeto que lida com verbos — seja grafo de conhecimento, busca semântica ou design de linguagem estruturada — inevitavelmente encontra esta pergunta: de onde trazer o sistema de verbos?

---

## Construir do zero

É possível projetar uma lista de verbos desde o início.

move, give, think, feel, say. Definimos uns 50 verbos básicos e adicionamos verbos subordinados. Abaixo de move: walk, run, crawl. Abaixo de give: donate, bestow, grant.

Surgem três problemas.

Primeiro, lacunas. Quando uma pessoa enumera verbos de cabeça, inevitavelmente falta algo. Esquece "adsorver", esquece "ruminar", esquece "resignar-se". No momento em que o verbo ausente é necessário, o sistema quebra.

Segundo, falta de critério. walk e stroll são verbos separados ou variações do mesmo verbo? Ao construir manualmente, esse julgamento depende da intuição do projetista. E a intuição varia de pessoa para pessoa.

Terceiro, a hierarquia é arbitrária. Colocamos walk abaixo de move, mas walk também pode ser subordinado a travel. O projetista decide onde colocar. Essa decisão não tem fundamento objetivo.

Um sistema de verbos construído manualmente parece perfeito na cabeça de seu criador. Quando outra pessoa olha, a reação é: "Por que foi classificado assim?"

---

## O legado WordNet

Um banco de dados lexical do inglês cuja construção começou na Universidade de Princeton em 1985.

Durante 40 anos, linguistas agruparam palavras inglesas em unidades de significado (synset) e as conectaram por relações hierárquicas. Só de verbos são 13.767 synsets. Cada synset tem um ID único, uma definição e relações explícitas com outros synsets.

"donate" e "bestow" estão agrupados no mesmo synset. Significa que têm o mesmo sentido.
"donate" é um troponym de "give". Significa que é uma forma específica de give.
"give" é um troponym de "transfer". Significa que é uma forma específica de transfer.

Essa hierarquia já está organizada para 13.767 verbos.

Sem lacunas. Porque linguistas a preencheram durante 40 anos.
Com critérios. Porque as definições e relações dos synsets são explícitas.
Com hierarquia fundamentada. Porque as relações de troponym são baseadas em análise linguística.

---

## Dicionário e gramática são coisas diferentes

Se WordNet é o dicionário de verbos, como usar esses verbos é uma questão separada.

WordNet nos diz qual é o significado de "give" e qual sua relação com "donate". Mas não nos diz a estrutura de uso de "give" numa frase — quem dá, o que é dado, a quem é dado.

Isso é análogo à relação com Wikidata. Wikidata nos diz que Yi Sun-sin é Q28090. Mas como compor uma frase sobre Yi Sun-sin não é responsabilidade da Wikidata.

Emprestamos o dicionário, mas construímos a gramática nós mesmos.

O que pegamos da WordNet: IDs de synset, definições semânticas e a árvore hierárquica de troponym. Os verb frames, estruturas de participantes e padrões sintáticos que WordNet também fornece são melhor projetados por cada projeto individualmente. Porque as informações sintáticas da WordNet estão vinculadas ao inglês, e o sistema semântico do verbo e seu modo de uso são questões independentes.

---

## De 13.767 a 10

Listar todos os 13.767 verbos da WordNet não tem utilidade. É preciso estrutura.

Subindo pela árvore de troponym da WordNet, chegamos a nós de topo que não têm superior. Os verbos raiz. São 559.

Agrupando os 559 semanticamente, obtemos 68 sub-primitivos (sub-primitive).
Agrupando os 68 mais, obtemos 10 primitivos (primitive).

```
13.767 verbos → 559 raízes → 68 sub-primitivos → 10 primitivos

BE        — existência, posse, localização
PERCEIVE  — percepção, detecção, descoberta
FEEL      — emoção, preferência, desejo
THINK     — pensamento, julgamento, memória
CHANGE    — mudança, início, fim
CAUSE     — ação, criação, destruição
MOVE      — movimento, chegada, partida
COMMUNICATE — fala, indicação, acordo
TRANSFER  — entrega, recebimento, troca
SOCIAL    — cooperação, competição, pertencimento
```

Esses 10 são os primitivos semânticos dos verbos humanos. Não vêm da intuição de um indivíduo, mas da estrutura de 40 anos de acumulação da WordNet e 13.767 pontos de dados.

Essa hierarquia de quatro camadas — primitivos, sub-primitivos, raízes, verbos individuais — permite ajuste de resolução. Numa visão ampla, há 10 tipos de ações; numa visão detalhada, 13.767. Basta ler na resolução necessária.

---

## Expansão e compressão

Se 13.767 não bastam? Novos verbos podem ser adicionados. Verbos multilíngues, neologismos, termos técnicos. Adiciona-se ao sub-primitivo correspondente. O sistema existente não se quebra.

Se 13.767 são demais? Synsets sinônimos podem ser fundidos em um. Redireciona-se donate para give. Dados previamente registrados como donate encontram give. Mesmo princípio do HTTP 301.

O importante é a ordem. Primeiro incluir tudo, rodar na prática, observar os dados de uso e depois reduzir. Reduzir no papel sem dados elimina distinções necessárias.

---

## Além: átomos semânticos

Os 13.767 verbos da WordNet são a lista de verbos nomeados por humanos. Abrangente, mas não é tudo.

"give" pode ser decomposto ainda mais: CAUSE + HAVE + MOVE. Decomposição em átomos semânticos (semantic primitive). Quando essa decomposição estiver completa, verbos que não constam na lista poderão ser expressos por combinação de átomos.

Se WordNet é uma biblioteca padrão, o sistema de átomos semânticos é o compilador. Assim como o compilador pode criar funções que não existem na biblioteca padrão.

Isso é um grande desafio de pesquisa, a ser tentado depois que o sistema baseado em WordNet estiver funcionando. Por enquanto, a biblioteca padrão é suficiente.

---

## Resumo

Todo projeto que busca construir um sistema de verbos encontra a mesma pergunta: de onde trazê-lo?

Construir do zero significa lacunas, arbitrariedade e falta de fundamento.
Construir sobre WordNet significa sem lacunas, consenso e base em dados.

WordNet é o dicionário de verbos da humanidade, acumulado por linguistas durante 40 anos.
Emprestamos as palavras desse dicionário, mas construímos a gramática nós mesmos.
É por isso que usamos Wikidata para entidades e WordNet para verbos.
