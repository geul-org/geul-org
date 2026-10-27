---
title: "Visão geral"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1 é uma sequência de registros formados por palavras de 16 bits. Os registros são de quatro tipos — Reference, Value, Edge e Meta — e ficam reunidos em um único documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL (General Encoding Unified Language) é uma linguagem artificial e um formato binário para a troca inequívoca entre humanos e IA. Este documento define a gramática do GEUL v1.

## Visão geral rápida

- Todos os dados são uma sequência de **palavras de 16 bits (WORD)**, escritas em big-endian.
- A unidade de dados é o **registro**. Um registro começa com uma TAG WORD, e essa TAG WORD informa o tipo e o comprimento do registro.
- Há quatro tipos (**Kind**) de registro.

| Kind | Função | Exemplo |
|---|---|---|
| Reference | Aponta para um alvo | Q42 do Wikidata, #7 dentro deste documento |
| Value | Contém o próprio valor | data, quantidade, texto com idioma |
| Edge | Une outros registros e os descreve | "Q42 é uma pessoa", "o nome de Q42 em inglês é Douglas Adams" |
| Meta | Fala sobre o documento | versão da especificação, ID do documento, autor, assinatura |

- Os registros ficam reunidos em um **documento**. Como em HTML, o documento se divide em HEAD (Meta, mais o SOURCE da origem do documento inteiro e seus QUALIFIERs) e BODY (Reference, Value, Edge).
- O documento é emitido por um **Issuer** (emissor) e cada versão é fixada por um hash de conteúdo. Uma versão publicada não muda.

## Princípios de design

1. **Dá para pular registros sem codebook.** O tipo e o comprimento do registro estão nos 16 bits da TAG WORD. Um decodificador que não conhece o modo de interpretação (o codebook) ainda consegue contar e pular registros.
2. **Contém descrições, não fatos.** O documento registra, com Meta e Edges de fundamento, quem fez a descrição, quando e a partir de quê.
3. **A identificação é feita por Reference.** Aponta-se por ID, não por nome. O nome é anexado por um Edge.
4. **O que foi publicado não muda.** As correções saem em uma nova versão. Os IDs dentro do documento apontam para o mesmo alvo em todas as versões.
5. **Deixa-se espaço vazio.** A maior parte do espaço de bits é reservada para o futuro. Códigos diretos não podem ser recuperados, então só se atribuem os de frequência comprovada.

## Estrutura de regiões

Os bits mais altos da TAG WORD dividem as regiões.

| Prefix | Região | Proporção | Definição |
|---|---|---|---|
| `1` | Futuro distante | 50% | Reservada para o futuro distante. Não se usa |
| `01` | Futuro | 25% | Reservada para o futuro próximo. Não se usa |
| `001` | Padrão | 12,5% | Gramática oficialmente adotada e em operação |
| `000` | Livre/proposta | 12,5% | Gramática atual. Quando adotada, mantém-se o layout e só o Prefix passa para `001` |

Toda a gramática atual está na região `000`. Todas as TAG WORDs desta especificação começam com `000`.

- O decodificador v1 rejeita TAG WORDs cujo Prefix não seja `000`. As outras regiões serão definidas por versões posteriores.
- A região `000` é um espaço de propostas. Por enquanto não se aplica registro nem proteção. No entanto, o layout do formato Issuer é reservado já supondo o sistema de registro posterior ao lançamento do padrão oficial.

## O que se sabe sem codebook

| Informação | Sem codebook | Fundamento |
|---|---|---|
| Kind | Sabe | TAG WORD |
| Comprimento total do registro, posição do próximo registro | Sabe | Length da TAG WORD |
| Número do Codec | Sabe | TAG WORD (no formato Issuer, o Issuer e o número do formato da TAG estendida) |
| Família e classe | Sabe | Bits superiores do número do Codec ou do número do formato |
| Edge Id do Edge | Sabe | O primeiro componente do Edge é sempre uma Reference LOCAL |
| Marcador de posição (não informado, desconhecido, sem valor) | Sabe | A WORD vale `0`~`7` (Reference Codec `0000`, 1 WORD). [Marcador de posição](/pt/grammar/reference/slot-marker/) |
| Comprimento da TAG por Codec, início do Payload | Não sabe | codebook |
| Interpretação do Payload, papel dos componentes do Edge | Não sabe | codebook |

- Um decodificador sem codebook pode pular registros e contá-los por Kind e Codec, mas não consegue seguir a estrutura do grafo.
- Todo decodificador deve processar as classes de estrutura, definição e IMPORT do Meta. Esses Codecs pertencem ao codebook central do GEUL ([Meta](/pt/grammar/meta/)).

Os codebooks são publicados como documentos GEUL ([Documento de especificação de Codec](/pt/grammar/codec-spec/)). Por isso o decodificador só precisa obter e ler o documento de especificação de que necessita.

## Subdocumentos

| Documento | Conteúdo |
|---|---|
| [Registro e TAG WORD](/pt/grammar/record/) | layout da TAG WORD, Length, Codec, TAG estendida |
| [Documento](/pt/grammar/document/) | DOC, HEAD, BODY, END, ID do documento, hash de conteúdo, versão e revisão |
| [Reference](/pt/grammar/reference/) | identificação de alvos, LOCAL, referências externas, Quantifier, marcador de posição |
| [Value](/pt/grammar/value/) | famílias de valores, código direto, texto, quantidade, data |
| [Edge](/pt/grammar/edge/) | famílias descritiva, de fundamento, de execução e TOULMIN; TRIPLE, QUALIFIER, LABEL |
| [Meta](/pt/grammar/meta/) | estrutura, definição, proveniência, linhagem, verificação, política, IMPORT |
| [Issuer e publicação](/pt/grammar/issuer/) | níveis de Issuer, tabela de atribuição de 1 WORD, modo de divulgação, assinatura, chave de verificação |
| [Endereço de publicação e lista de versões](/pt/grammar/publishing/) | notação de ID, endereço de publicação, especificação de formato, índice de nomes, lista de versões, camadas de confiança |
| [Documento de especificação de Codec](/pt/grammar/codec-spec/) | codebook escrito com DECLARE, FIELD, ENUM e CODEC |
| [Exemplo: item do Wikidata](/pt/grammar/example/) | ler um documento palavra por palavra |

## Questões em aberto

- Kind dos casos de fronteira. Casos como a declaração sobre uma declaração, em que se divide entre Reference, Value, Edge e Meta.
