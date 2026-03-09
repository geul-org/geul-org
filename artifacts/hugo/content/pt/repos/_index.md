---
title: "Repositórios"
date: 2026-02-28T12:00:00+09:00
summary: "Repositórios do GitHub que compõem o projeto GEUL. Especificação da linguagem, livros de códigos gramaticais, busca, DSL e site."
image: "/images/og-default.webp"
---

Todos os repositórios estão na organização [geul-org](https://github.com/geul-org) do GitHub.

---

## Linguagem

### geul

Uma linguagem artificial semanticamente alinhada e formato de fluxo binário para IA.

Um sistema linguístico de 2 bytes (65.536 símbolos) projetado para comunicação inequívoca entre humanos e IA. Cada enunciado carrega sua fonte, marca temporal e nível de confiança. Cada entidade tem um identificador único. O formato de fluxo opera em unidades de 16 bits, definindo 10 tipos de pacotes (Verb Edge, Entity Node, Triple Edge, etc.) sob um esquema de prefixo de 10 bits.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| Linguagem | Go, Python |
| Licença | MIT |

---

## Gramática

### geul-verb

Livro de códigos de verbos SIDX de 16 bits (baseado em WordNet).

Mapeia synsets de verbos do WordNet para códigos de 16 bits para uso em pacotes GEUL Verb Edge. Fornece o vocabulário verbal que o formato de fluxo consome.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| Linguagem | Python |
| Licença | MIT |

### geul-entity

Livro de códigos de entidades SIDX de 48 bits (baseado em Wikidata).

Codifica entidades do Wikidata em identificadores estruturados de 48 bits. Define tipos de entidades, projeta esquemas de atributos por tipo e constrói os livros de códigos que o SILK consome.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| Linguagem | Python |
| Licença | MIT |

### geul-quantities

Livro de códigos de nós de quantidade.

Define o esquema de codificação para valores de quantidade — números com unidades, intervalos e precisão — usados em pacotes GEUL Quantity Node.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| Linguagem | Python |
| Licença | MIT |

### geul-ast

Livro de códigos de arestas AST.

Define o esquema de codificação para arestas de árvores de sintaxe abstrata, permitindo representação estruturada de código dentro do formato de fluxo GEUL.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| Linguagem | Python |
| Licença | MIT |

---

## Busca

### silk

SILK (Symbolic Index for LLM Knowledge) — uma arquitetura de busca neuro-simbólica.

Busca com inteiros de 64 bits. Não requer banco de dados vetorial, nem grafo ANN, nem modelo de embeddings. Uma única operação AND bit a bit com NumPy busca em 100 milhões de registros, e a afirmação central é que Python sozinho supera buscas vetoriais otimizadas em C++/Rust. Fornece um pipeline de consultas híbrido combinando busca em livros de códigos com assistência de LLM.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Linguagem | Python |
| Licença | MIT |

---

## DSL

### fullend

Full-stack SSOT Orchestrator — valida a consistência entre 5 fontes SSOT (STML, OpenAPI, SSaC, SQL DDL, Terraform) e gera código a partir delas.

Chama as ferramentas de validação individuais de cada camada e depois faz validação cruzada dos limites entre camadas. Após a validação, orquestra a geração de código a partir de sqlc, oapi-codegen, SSaC e STML, e produz o código de ligação.

| | |
|---|---|
| GitHub | [geul-org/fullend](https://github.com/geul-org/fullend) |
| Linguagem | Go |
| Licença | MIT |

### ssac

Service Sequences as Code — analisa lógica de serviço declarativa em comentários Go e gera código de implementação em Go via CLI.

Define fluxos de serviço como comentários estruturados em arquivos fonte Go. O CLI lê essas declarações e gera o código de implementação correspondente, eliminando código repetitivo enquanto mantém a lógica legível e sob controle de versão.

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| Linguagem | Go |
| Licença | MIT |

### stml

SSOT Template Markup Language — vinculação declarativa UI-API com atributos HTML5 data-*, validação simbólica contra OpenAPI e geração de código React.

Vincula templates de UI a schemas de API usando atributos HTML5 data. Valida simbolicamente contra especificações OpenAPI em tempo de build e gera componentes React com tipos seguros. Uma única fonte de verdade do schema à tela.

| | |
|---|---|
| GitHub | [geul-org/stml](https://github.com/geul-org/stml) |
| Linguagem | TypeScript |
| Licença | MIT |

---

## Site

### geul-org

O código-fonte deste site.

Um gerador de sites estáticos Hugo com suporte a 12 idiomas. Implantado via S3 + CloudFront, com uma CloudFront Function para detecção de idioma e URLs limpas.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Linguagem | Hugo (Go Templates), CSS |
| Licença | MIT |
