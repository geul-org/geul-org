---
title: "Por que anotacoes devem ser indices"
weight: 20
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["índice", "anotação", "código", "AST", "padrão-de-design"]
summary: "Comentarios sao escritos para pessoas. Mas quando ha 10.000 funcoes, as maquinas tambem precisam le-los. Ao transformar comentarios de narrativa em indice, uma varredura completa se torna uma busca instantanea."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Comentarios sao escritos para pessoas.

```go
// GetUser retrieves a user by ID from the database.
func GetUser(id string) (*User, error) {
```

Esse comentario e util quando uma pessoa o le. Mas quando uma maquina o le, ela nao entende nada. Nao sabe se "retrieves" e Read ou Search. Nao sabe que tipo de entidade e "user". Nao sabe se essa funcao segue o padrao Service ou o padrao Repository.

Porque o comentario e uma narrativa.

---

## Quando ha 10.000 funcoes

Quando ha 10 funcoes, nao importa. Uma pessoa pode ler tudo.

Quando ha 10.000 funcoes, e diferente. Quando alguem pede "mostre todas as funcoes relacionadas a pagamento", nem uma pessoa nem uma maquina consegue encontra-las. So encontra aquelas com "payment" no nome. Se nao estiver no nome, passa despercebido.

O mesmo acontece quando um agente de IA modifica codigo. Quando voce pede ao Claude Code para "corrigir o tratamento do erro PaymentFailed", o agente rele todo o codigo. Toda vez. Analisa 10.000 funcoes do zero, toda vez. Le hoje o mesmo codigo que leu ontem. Mesmo com comentarios, e a mesma coisa. Porque os comentarios sao narrativas para pessoas. Para uma maquina extrair significado de narrativa, precisa de inferencia. Isso e caro.

---

## Se os comentarios fossem indices

```go
// CreateOrder processes a new order creation.
//
// # Pattern: Service, Transactional
// # Entity: Order
// # Action: Create
// # Input: CreateOrderRequest {items:[]Item, userID:string}
//          pre: items>0 userID!=''
// # Output: *OrderResponse, error
//          errs: [StockInsufficient, PaymentFailed]
// # Deps: InventorySvc, PaymentGateway
func (s *OrderService) CreateOrder(req CreateOrderRequest) (*OrderResponse, error) {
```

Esse comentario pode ser lido tanto por pessoas quanto por maquinas.

"Todas as funcoes com padrao Service" -> busca no campo Pattern. Instantaneo.
"Todas as funcoes relacionadas a entidade Order" -> busca no campo Entity. Instantaneo.
"Funcoes que geram PaymentFailed" -> busca no campo errs. Instantaneo.

Uma varredura completa se transforma em busca por indice. O(n) se torna O(1).

---

## Nao precisa ser escrito por pessoas

Esses indices nao precisam ser escritos por pessoas.

Quando o codigo e modificado, a alteracao e detectada automaticamente. Monitoramento de arquivos.
A funcao modificada e isolada via AST. Mecanicamente.
O corpo da funcao e passado a um LLM pequeno. "Determine o padrao, a entidade e a acao desta funcao."
O resultado da analise e inserido em um formato predefinido. Mecanicamente.

A pessoa nao faz nada. Apenas escreve codigo. O indice e adicionado automaticamente.

Em todo o pipeline, o LLM intervem em apenas um ponto -- determinar o significado da funcao. Todo o resto e codigo deterministico.

---

## De inferencia para regras

Aqui vamos um passo alem.

Quando o LLM pequeno atribui repetidamente o mesmo indice ao mesmo padrao -- essa repeticao e detectada. Se "Service suffix com receiver method entao Pattern:Service" se repetiu 100 vezes, isso se consolida como uma regra. A partir dai, o LLM nao e mais chamado. A regra assume.

As chamadas ao LLM diminuem progressivamente. As regras aumentam progressivamente. O custo converge para zero.

Os comentarios mudam de narrativa para indice,
os indices mudam de manual para automatico,
e o automatico muda de inferencia para regras.

---

## Por que isso e possivel: design patterns como codebook

Ha uma razao pela qual isso e possivel.

A programacao ja possui um vocabulario semantico padronizado. Sao os design patterns.

Singleton, Factory, Observer, MVC, Service. Desde que o GoF sistematizou 23 padroes em 1994, a industria de software vem expandindo e padronizando esse vocabulario por 30 anos.

23 padroes GoF. Enterprise Application Patterns. Cloud Design Patterns. Go Concurrency Patterns. Tudo ja esta sistematizado.

Esse vocabulario nao e ambiguo. Singleton e Singleton. Nao e interpretado de forma diferente por cada desenvolvedor. A definicao e consensual, as condicoes de implementacao sao claras, e violacoes sao identificadas em code reviews.

Esse sistema de vocabulario se torna o codebook do indice. Nao e preciso criar um novo. Ja existe.

Na linguagem natural, isso nao existe. "Grande" tem uma definicao no dicionario, mas cada pessoa a usa de forma diferente. No codigo, Service nao e usado de forma diferente por cada pessoa.

---

## Por que codigo e o dominio mais facil

O pipeline de contexto do GEUL -- [clarificacao](/pt/why/clarification/), [indexacao](/pt/why/semantically-aligned-index/), [verificacao](/pt/why/mechanical-verification/), [filtragem](/pt/why/filter/), [consistencia](/pt/why/consistency-check/), [exploracao](/pt/why/exploration/) -- e dificil de aplicar a linguagem natural. Aplicar a codigo e facil.

Clarificacao: linguagem natural e ambigua. Codigo, se o compilador aceitou, tem significado determinado.
Indexacao: entidades na linguagem natural dependem de contexto. Entidades no codigo ja foram parseadas pelo AST.
Verificacao: a validade da linguagem natural nao pode ser definida. A validade do codigo e julgada pelo compilador.
Filtragem: a relevancia na linguagem natural exige um LLM. A relevancia no codigo pode ser determinada mecanicamente pelo grafo de chamadas.
Consistencia: contradicoes na linguagem natural so sao descobertas por inferencia. Contradicoes no codigo sao capturadas pelo sistema de tipos e pelos testes.
Exploracao: o conhecimento em linguagem natural e plano. Codigo ja possui uma hierarquia de pacote -> arquivo -> tipo -> metodo.

O mesmo pipeline funciona com custo muito menor no dominio do codigo. Provar primeiro onde e mais facil e expandir para onde e mais dificil. Isso e engenharia.

---

## Resumo

Comentarios eram originalmente para pessoas.
Agora tambem precisam ser para maquinas.
Comentarios que pessoas possam ler e maquinas possam buscar.
Comentarios que sao narrativa e ao mesmo tempo indice.

Codigo ja tem significado, ja tem estrutura, ja tem vocabulario.
O que falta e apenas o indice.
E os comentarios podem ser esse indice.
