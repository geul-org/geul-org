---
title: "Repositórios"
date: 2026-02-28T12:00:00+09:00
summary: "Repositórios do GitHub que compõem o projeto GEUL. Design da linguagem, pipeline de codificação, motor de busca e site."
image: "/images/og-default.webp"
---

O projeto GEUL é composto por quatro repositórios.

Projetar a linguagem (geul), codificar as entidades do mundo em 64 bits (geul-sidx), buscar nesse índice (silk) e explicar por que tudo isso é necessário (geul-org).

---

## geul

Uma linguagem artificial semanticamente alinhada e formato de fluxo binário para IA.

Um sistema linguístico de 2 bytes (65.536 símbolos) projetado para comunicação inequívoca entre humanos e IA. Cada enunciado carrega sua fonte, marca temporal e nível de confiança. Cada entidade tem um identificador único. O formato de fluxo opera em unidades de 16 bits, definindo 10 tipos de pacotes (Verb Edge, Entity Node, Triple Edge, etc.) sob um esquema de prefixo de 10 bits.

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| Linguagem | Go, Python |
| Licença | MIT |

---

## geul-sidx

Construtor de livros de códigos e pipeline de codificação SIDX (Semantic-aligned Index).

Codifica 108,8 milhões de entidades do Wikidata em identificadores estruturados de 64 bits. Define 63 tipos de entidades, projeta esquemas de atributos de 48 bits por tipo, constrói livros de códigos e valida os resultados de codificação (VALID). É o produtor dos índices e livros de códigos que o SILK consome.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| Linguagem | Python |
| Licença | MIT |

---

## silk

SILK (Symbolic Index for LLM Knowledge) — uma arquitetura de busca neuro-simbólica.

Busca com inteiros de 64 bits. Não requer banco de dados vetorial, nem grafo ANN, nem modelo de embeddings. Uma única operação AND bit a bit com NumPy busca em 100 milhões de registros, e a afirmação central é que Python sozinho supera buscas vetoriais otimizadas em C++/Rust. Fornece um pipeline de consultas híbrido combinando busca em livros de códigos com assistência de LLM.

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| Linguagem | Python |
| Licença | MIT |

---

## geul-org

O código-fonte deste site.

Um gerador de sites estáticos Hugo com suporte a 12 idiomas. Implantado via S3 + CloudFront, com uma CloudFront Function para detecção de idioma e URLs limpas.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| Linguagem | Hugo (Go Templates), CSS |
| Licença | MIT |
