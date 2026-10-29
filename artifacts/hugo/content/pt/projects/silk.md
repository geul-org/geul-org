---
title: "SILK — Motor de indexação e busca para GEUL"
weight: 1
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SILK", "busca", "índice", "GEUL", "Go"]
summary: "Motor que indexa e consulta arquivos GEUL pack registro a registro. Como os dados são estruturados na escrita, a busca se reduz a comparações de inteiros e varreduras por intervalo. Consultas de 0,1–4 ms no Wikidata Q1–Q10000."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
aliases:
  - /pt/silk/
---

SILK é um **motor de indexação e busca dedicado ao GEUL**. Sem decodificar documentos GEUL inteiros, ele responde apenas com índices de registros a consultas como "quais documentos afirmam que a ocupação (P106) é físico (Q169470)?".

| | |
|---|---|
| Status | Desenvolvimento inicial. Os algoritmos de busca estão sendo validados, e os formatos podem mudar antes da primeira versão |
| Linguagem | Go |
| Entrada | Arquivos GEUL pack (sem compressão) |
| Licença | CC0 |
| Repositório | <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a> |

## Tese central

O difícil nunca foi buscar: **o problema eram os dados sem estrutura**.

```
Abordagem tradicional: escrever primeiro → inferir a estrutura depois (tokenização, embeddings, análise)
GEUL:                  estruturar na escrita → buscar é só comparar inteiros e varrer intervalos
```

Um registro GEUL já traz campos como sujeito, predicado, objeto e idioma em posições fixas, como IDs inteiros. O SILK apenas extrai esses campos e os mantém ordenados.

## Por que combina com GEUL

| Propriedade do GEUL | O que o SILK ganha |
|---|---|
| Um único TAG WORD de 16 bits contém o tipo (Kind, Codec) e o comprimento | Filtra e pula registros sem precisar de um livro de códigos |
| Os campos de um Edge são registros em posições fixas | Extrai as chaves pela posição. Não são necessárias regras de parsing separadas |
| O vocabulário controlado é formado por IDs inteiros (Q, P, idioma) | Compara igualdade com inteiros, sem normalizar strings |
| Um pack é composto de objetos imutáveis e gerações | O índice também é construído com segmentos imutáveis e gerações, então os snapshots são seguros |
| A conversão é determinística | A mesma entrada gera o mesmo índice. O resultado incremental pode ser comparado byte a byte com um índice construído do zero |

Os documentos GEUL nunca são reordenados. O índice é apenas uma **visão (view)** ordenada; os bytes publicados, os hashes de conteúdo e as assinaturas permanecem inalterados.

## Arquitetura

### Entrada

Lê arquivos GEUL pack por meio do [gogeul](https://github.com/geul-org/gogeul). Como o índice aponta para posições de bytes dentro dos data packs, o conjunto precisa guardar os registros sem compressão (`GEULCOMPRESS=none`). A compressão zstd serve para distribuição e arquivamento; a camada de busca usa packs sem compressão.

### Especificação de partições

Para cada tipo de TAG, declaram-se uma **chave de partição** e uma **chave de ordenação** como campos de posição fixa do registro. Nada como predicados ou idiomas fica fixo no código; a tabela abaixo mostra os valores padrão para documentos do Wikidata.

| TAG | Chave de partição | Chave de ordenação |
|---|---|---|
| TRIPLE | Predicado (Predicate) | Objeto (Object) |
| QUALIFIER | Propriedade (Property) | Valor (Value) |
| LABEL·ALIAS·DESCRIPTION | Idioma | Sujeito (Subject) |
| SOURCE | nenhuma | Origem (Origin) |
| REFERENCE-NODE | nenhuma | Objeto (Object) |

- Uma chave são os primeiros bytes (um slot) do registro de campo. Se o registro cabe no slot, a igualdade é exata; se for maior, a chave só seleciona candidatos.
- A validação da especificação rejeita como chave de partição campos cuja posição exige um livro de códigos ou campos de comprimento ilimitado.
- A especificação é identificada pelo hash do seu conteúdo. Quando ela muda, só aquele TAG é reconstruído.

### Runs, incrementos e mesclagem

| Elemento | Papel |
|---|---|
| Run ordenado | Segmento imutável ordenado por (chave de ordenação, documento, deslocamento) em cada partição. Consultado por busca binária |
| Segmento anexado | Contém só as revisões novas de uma atualização incremental (`silk index update`). Varrido sequencialmente |
| Bitmap de revisões vivas | Marca como mortas as revisões antigas de documentos alterados, em vez de apagá-las |
| Mesclagem por faixas de tamanho | Mescla runs da mesma faixa de tamanho com um merge O(n) e, se houver muitas linhas mortas, mescla até o run base |
| Geração | A geração do manifesto é trocada atomicamente. Os leitores fixam uma geração, então o snapshot se mantém mesmo durante a mesclagem |

A mesclagem pode ser restrita a períodos ociosos (`-idle`, deixando 30% da CPU e da memória livres). Ela para nos limites de partição e retoma a partir de um checkpoint.

### Consultas

1. **Condição de igualdade**: localiza a partição e faz busca binária nos runs ordenados.
2. **Várias condições**: faz merge join pelo documento (sujeito). Todas as condições devem valer dentro de um mesmo documento.
3. **Verificação precisa**: decodifica os registros candidatos com o gogeul, compara campo a campo e lê o Edge Id.

```sh
silk query -triple P106=Q169470 ARCHIVE
silk query -count -triple P31=Q5 -triple P106=Q169470 ARCHIVE
silk query -label ko -match LABEL:1=Q42 ARCHIVE
```

## Medições

Medido no Wikidata Q1–Q10000 e em 16.696 documentos de propriedades (271 MB, 7,07 milhões de registros de índice). 8 threads, melhor de 7 execuções, sem contar o tempo de inicialização do processo.

### Consultas

| Consulta | Documentos resultantes | Método anterior (varredura completa) | Índice SILK |
|---|---:|---:|---:|
| P106=Q169470 (ocupação = físico) | 55 | ~20ms | 0,12ms |
| P31=Q5 (ser humano) | 1.579 | ~19ms | ~1ms |
| ser humano + físico | 54 | ~38ms | ~1ms |
| LABEL ko | 9.746 | (impossível) | ~4ms |

- O método anterior varria por completo o mapa de registros TRIPLE.
- Em LABEL ko, a maior parte do tempo é gasta lendo os 9.746 registros do pack para a verificação precisa.

### Tamanho, construção e incrementos

| Item | Valor |
|---|---|
| Tamanho do índice | 113MB (15,7B por registro em média) |
| Construção | ~3 segundos (parsing de documentos em uma só thread) |
| Atualização incremental (4.217 revisões alteradas) | 1,8 segundo |
| Resultado incremental | Após 2 atualizações, 2 mesclagens e uma interrupção seguida de retomada, os resultados das consultas são idênticos byte a byte aos de um índice construído do zero |
| Amplificação de escrita | 1,31 acumulada (1,71 se reconstruído toda vez) |

- Extrapolado para todo o Wikidata (cerca de 7,5 bilhões de registros), o índice teria cerca de 110 GB (**estimativa**).
- O custo é o tamanho: cerca de 4 vezes maior que um mapa simples de 4 B por registro. Reduzir a largura dos slots e as assinaturas de entidade são os próximos itens a examinar.

### Varredura de assinaturas (medição preliminar para assinaturas de entidade)

Tempo, em escala, para varrer 100 milhões de assinaturas de 128 bits com máscara e padrão (i7-14700K, AVX2).

| Implementação | Tempo |
|---|---:|
| NumPy, 1 thread | ~1s |
| Go, 1 thread | ~134ms |
| Go, 8 threads | ~27ms |
| Go, 16–20 threads | ~23ms (limite da largura de banda de memória) |

O que faz a diferença não é a linguagem, e sim **loops fundidos sem arrays intermediários e o uso de várias threads**.

## Relação com a busca vetorial

Não é uma substituição, é uma divisão de tarefas.

| | SILK | Busca vetorial |
|---|---|---|
| Consultas atendidas | Consultas estruturadas (condições de predicado, objeto, idioma, entidade) | Similaridade semântica difícil de expressar como estrutura |
| Resultado | O conjunto que satisfaz as condições (exato) | Um ranking por similaridade (aproximado) |
| Pré-requisito | Os dados precisam estar estruturados em GEUL | Basta o texto original ou os embeddings |

Para consultas que procuram fatos expressos em GEUL, o SILK é exato e barato. Para texto original sem estrutura ou para buscar "algo parecido", a busca vetorial é mais adequada.

## Posição e próximos passos

O SILK é **a tecnologia de busca usada pelo WMS (o coordenador de armazenamento e recuperação do GEUL)**. Julgar se uma afirmação encontrada está correta cabe a um motor de julgamento separado.

| Próximo passo | Conteúdo |
|---|---|
| Assinaturas de entidade | Uma cadeia de bits de largura fixa de 16–128 bits por entidade. O usuário declara os campos (enumeração, one-hot, Bloom, prefixo, intervalo). É um primeiro filtro aproximado, seguido de verificação precisa. Atualmente em fase de planejamento (só uma parte está na biblioteca, ainda não no índice) |
| Especificação como documento GEUL | Declarar a especificação JSON como documento GEUL e ler o layout a partir dos documentos de especificação de codec (DECLARE, FIELD) |
| Índice de montagem de afirmações | Índice Target que encontra diretamente o TRIPLE apontado por um QUALIFIER ou SOURCE |
| Preparação para grande escala | Limites de memória para construção e mesclagem, paralelização do parsing na construção |

A concepção inicial (2026-03) era um projeto em Python e NumPy que varria identificadores de entidade de 64 bits com AND bit a bit. Hoje é um motor em Go que indexa diretamente os registros GEUL.

## Repositório e licença

- Repositório: <a href="https://github.com/geul-org/silk" target="_blank" rel="noopener">github.com/geul-org/silk</a>
- Instalação: `go install github.com/geul-org/silk/cmd/silk@latest`
- Licença: nossa obra é CC0 1.0. Componentes de terceiros seguem suas próprias licenças (NOTICE do repositório).
