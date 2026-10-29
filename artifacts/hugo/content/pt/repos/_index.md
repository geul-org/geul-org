---
title: "Repositórios"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "Repositórios públicos do GEUL no GitHub: a biblioteca Go e a CLI geul, carga e conversão do Wikidata, o motor de busca SILK, codebooks anteriores à v1 e este site."
image: "/images/og-default.webp"
---

Os repositórios públicos do GEUL estão na organização [geul-org](https://github.com/geul-org) do GitHub. A gramática normativa é a [Gramática do GEUL](/pt/grammar/) deste site.

Um documento GEUL é uma sequência de WORDs de 16 bits. A unidade de dados é o registro, que começa com um TAG WORD, e os registros ficam em um documento. Os documentos são publicados por um Issuer, e cada versão é fixada por um hash de conteúdo. Os repositórios abaixo são ferramentas para escrever, ler, converter e buscar esses documentos.

---

## Biblioteca

### gogeul

A biblioteca Go do GEUL e a ferramenta de linha de comando `geul`.

Escreve, lê, verifica e publica documentos GEUL (`.geul`). Seus pacotes oferecem verificação de formato, decodificação de registros por meio de documentos de especificação de Codec, diferenças entre versões, resolução de dependências IMPORT e o Codec TOULMIN. A CLI `geul` cobre edição (`new`, `add`), publicação (`publish`), consulta (`ls`, `log`, `show`, `diff`, `check`), um visualizador no navegador (`serve`, `build`) e arquivos pack (`pack build`, `pack unpack`). Os arquivos pack podem guardar registros comprimidos com zstd.

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| Linguagem | Go |
| Licença | CC0 |

---

## Wikidata

### wikigeul

Conversão Wikidata → GEUL (antigo nome gogeulwiki).

Lê um dump do Wikidata que o wikipg carregou no PostgreSQL e publica um documento GEUL por item ou propriedade, com rótulos, descrições, apelidos, declarações com seus qualificadores e referências, e links de sites em todos os idiomas. Todos os documentos são publicados sob o Issuer `wikidata.geul.org` (`0x00010000`).

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| Linguagem | Go |
| Licença | CC0 |

### wikipg

Carga sem perdas de dumps JSON do Wikidata no PostgreSQL.

Armazena entidades, rótulos, descrições, apelidos, declarações, qualificadores, referências, links de sites e Lexemes na ordem do dump, e preserva literalmente cada linha do dump. O próprio dump (arquivo, URL, tamanho, somas de verificação, commit do carregador) também é registrado. O wikipg não depende do GEUL.

| | |
|---|---|
| GitHub | [geul-org/wikipg](https://github.com/geul-org/wikipg) |
| Linguagem | Go |
| Licença | CC0 |

---

## Busca

### silk

[SILK](/pt/projects/silk/) — um motor de indexação e busca feito para o GEUL.

Constrói índices particionados e ordenados dos registros de um arquivo pack do GEUL e responde a consultas como "quais documentos afirmam que a ocupação (P106) de alguém é físico (Q169470)?" sem decodificar todos os documentos. Delimita registros e seus campos apenas pelos TAG WORDs, sem codebook. Está em desenvolvimento inicial, validando seus algoritmos de busca, e seus formatos podem mudar antes da primeira versão.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Linguagem | Go |
| Licença | CC0 |

---

## Codebooks (anteriores à v1)

Os dois repositórios abaixo foram projetados antes da gramática v1 atual. Algumas partes não correspondem a ela.

### sidx

Pesquisa sobre a atribuição de SIDX (Semantic-aligned Index).

Material de pesquisa para atribuir SIDX, um endereço semântico que dá números próximos a entidades de significado próximo, a partir de estatísticas de uso do Wikidata. Contém o antigo esquema de atributos de Entity de 48 bits, scripts codificadores e codebooks; ainda não foi produzida nenhuma atribuição de SIDX. A definição normativa de SIDX é [GEUL-SIDX](/pt/grammar/reference/geul-sidx/) na gramática.

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| Linguagem | Python |
| Licença | CC0 |

### wordnet-verb

Edição provisória de um codebook de verbos de 16 bits baseado no WordNet 3.0.

Atribui um código de 16 bits a cada um dos 13.767 synsets verbais do WordNet 3.0, com códigos próximos para verbos de significado próximo. É uma edição provisória a ser substituída por um codebook que não use o WordNet, e ainda não foi decidido como os códigos seriam levados nos registros GEUL.

Contém material derivado do WordNet, portanto **não é um produto CC0.** As partes derivadas do WordNet seguem a WordNet 3.0 License; apenas as partes próprias do projeto GEUL, como os códigos e a classificação, são CC0.

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| Linguagem | Python |
| Licença | WordNet 3.0 License (partes derivadas) · CC0 (partes próprias) |

---

## Site

### geul-org

Código-fonte deste site, geul.org.

Site estático Hugo em 12 idiomas, publicado com S3 + CloudFront.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Linguagem | Hugo |
| Licença | CC0 |

---

## Repositórios relacionados

Repositórios fora da organização geul-org.

### toulmin

Um motor de regras baseado no modelo de argumentação de Toulmin (TypeScript, Python, Go, C).

As regras são funções e as exceções são relações de ataque em um grafo. O Edge [TOULMIN](/pt/grammar/edge/toulmin/) da gramática GEUL (códigos diretos `0x60`–`0x7B`) escreve esses grafos de julgamento e execução como documentos GEUL.

| | |
|---|---|
| GitHub | [park-jun-woo/toulmin](https://github.com/park-jun-woo/toulmin) |
| Licença | MIT |
