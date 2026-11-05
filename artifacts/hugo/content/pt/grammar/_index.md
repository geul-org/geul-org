---
title: "Gramática do GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Especificação da gramática do GEUL v1. Define os registros sobre palavras de 16 bits, os quatro Kinds, a estrutura do documento, o Issuer e as regras de publicação."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL (General Encoding Unified Language) é uma língua artificial e um formato binário para que pessoas e IA troquem informação sem ambiguidade.

Estes documentos definem a gramática do GEUL v1. A edição atual é um rascunho anterior à publicação e pode mudar. A especificação é aberta sob [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## Visão geral {#한눈에-보기}

- Todos os dados são uma sequência de **palavras de 16 bits (WORD)**, escritas em big-endian.
- A unidade de dados é o **registro**. Um registro começa com um único TAG WORD, e esse TAG WORD indica o tipo e o comprimento do registro.
- Há quatro tipos de registro (**Kind**).

| Kind | Função | Exemplo |
|---|---|---|
| Reference | Aponta para um alvo | Q42 do Wikidata, #7 dentro deste documento |
| Value | Contém o próprio valor | data, quantidade, texto com idioma |
| Edge | Liga outros registros para enunciar algo | "Q42 é uma pessoa", "O nome em inglês de Q42 é Douglas Adams" |
| Meta | Fala sobre o documento | edição da especificação, ID do documento, autor, assinatura |

- Os registros ficam reunidos em um **documento**. Como em HTML, o documento se divide em HEAD (Meta, mais a SOURCE de todo o documento e seu QUALIFIER) e BODY (Reference, Value, Edge).
- O documento é emitido por um **Issuer** (entidade emissora) e cada versão é fixada por um hash de conteúdo. Uma versão publicada não é alterada.

## Princípios de projeto {#설계-원칙}

1. **É possível pular registros sem livro de códigos.** O tipo e o comprimento do registro estão nos 16 bits do TAG WORD. Um decodificador que não conhece o método de interpretação (o livro de códigos) ainda consegue contar e pular registros.
2. **Registra-se o enunciado, não o fato.** O documento anota, por meio de Meta e de Edges de fundamento, quem fez o enunciado, quando e a partir de quê.
3. **A identificação é feita por Reference.** Aponta-se por ID, não por nome. O nome é anexado por um Edge.
4. **O que foi publicado não muda.** As correções saem em uma nova versão. Os IDs dentro do documento apontam para o mesmo alvo entre versões.
5. **Deixa-se espaço vazio.** A maior parte do espaço de bits é reservada ao futuro. Códigos diretos não podem ser recuperados, por isso só se atribuem os de frequência comprovada.

## Documentos relacionados {#하위-문서}

Se for a primeira leitura, leia a tabela de cima para baixo.

| Documento | Conteúdo |
|---|---|
| [Estrutura do registro](record.md) | layout do TAG WORD, Length, Codec, TAG estendida |
| [Issuer e publicação](issuer.md) | níveis de Issuer, tabela de atribuição de 2 WORD, forma de divulgação, assinatura, chave de verificação |
| [Endereço de publicação e lista de versões](publishing.md) | notação de ID, endereço de publicação, especificação de formato, lista de Issuers, lista de versões, camadas de confiança |
| [Documento de especificação de Codec](codec-spec.md) | livro de códigos escrito com DECLARE, FIELD, ENUM e CODEC |
| [Documento geral](document.md) | DOC, HEAD, BODY, END, ID do documento, hash de conteúdo, versões e revisões |
| [Índice de códigos](codec-index.md) | todas as 227 casas atribuídas, tabelas de Codec por Kind e família |
| [Disposição das seções](layout.md) | 16 seções e disposição das casas, intervalos atribuídos e Reserved |
| [Marcador de posição](slot-marker.md) | ABSENT, UNKNOWN-VALUE, NO-VALUE, regras de aceitação |
| [Reference](reference/_index.md) | identificação de alvos, LOCAL, referência externa, Quantifier, marcador de posição |
| [Value](value/_index.md) | famílias de valores, código direto, texto, quantidade, data |
| [Meta](meta/_index.md) | estrutura, definição, proveniência, linhagem, verificação, política, IMPORT |
| [Edge](edge/_index.md) | famílias de enunciado, fundamento, execução e TOULMIN, TRIPLE, QUALIFIER, LABEL |
| [TOULMIN](toulmin/_index.md) | família de grafos de julgamento e execução, layouts de NODE, LINK, SOURCE |
| [Exemplo: item do Wikidata](example.md) | leitura de um documento palavra por palavra |

## O que se sabe sem livro de códigos {#코덱북-없이-알-수-있는-것}

| Informação | Sem livro de códigos | Fundamento |
|---|---|---|
| Kind | Sabe-se | faixa da seção `w >> 9` do TAG WORD (Reference 0~2, Value 3·4, Edge 5~13, Meta 14·15) |
| Comprimento total do registro, posição do próximo registro | Sabe-se | Length do TAG WORD |
| Número do Codec | Sabe-se | TAG WORD (no formato Issuer, o Issuer e o número do Codec da TAG estendida) |
| Família e classe | Em parte | Só a família do código direto de Edge é conhecida pelos bits. A família do código direto de Value e do formato Issuer e a classe de Meta não são conhecidas pelos bits. No formato Issuer conhecem-se o Issuer e o número do Codec. A classe de verificação de Meta é reconhecida por `C >= 5` (`w >= 0x1E50`) na seção 15 |
| Edge Id do Edge | Sabe-se | o primeiro componente de um Edge (seções 5~13) é sempre uma Reference LOCAL |
| Marcador de posição (não escrito, desconhecido, inexistente) | Sabe-se | o valor do WORD é `0x0000`, `0x0010`, `0x0020` (Reference, C < 3, L 0). [Marcador de posição](slot-marker.md) |
| Quantifier | Sabe-se | pelo deslocamento `C` dentro da seção: na seção 0, `5 <= C < 30`; na seção 1, `C < 30`, vale `C % 5` |
| Comprimento do TAG por Codec, posição inicial do Payload | Não se sabe | livro de códigos |
| Interpretação do Payload, papel dos componentes do Edge | Não se sabe | livro de códigos |

- Um decodificador sem livro de códigos pode pular registros e contá-los por Kind e Codec, mas não consegue seguir a estrutura do grafo.
- Todo decodificador deve processar as classes estrutura, definição e IMPORT de Meta. Esses Codecs pertencem ao livro de códigos central do GEUL, e o decodificador os conhece por uma tabela de números embutida ([Meta](meta/_index.md)).

O livro de códigos é publicado como documento GEUL ([Documento de especificação de Codec](codec-spec.md)). Assim, o decodificador só precisa obter e ler o documento de especificação de que necessita.

## Estrutura das regiões {#영역-구조}

Os bits superiores do TAG WORD dividem as regiões.

| Prefix | Região | Proporção | Definição |
|---|---|---|---|
| `1` | futuro distante | 50% | Reserved (futuro distante). Não se usa |
| `01` | futuro | 25% | Reserved (futuro próximo). Não se usa |
| `001` | padrão | 12.5% | gramática oficialmente adotada e em operação |
| `000` | livre/proposta | 12.5% | gramática atual. Quando adotada, mantém-se o layout e só o Prefix passa para `001` |

Toda a gramática atual está na região `000`. Todos os TAG WORDs desta especificação começam com `000`.

- O decodificador v1 rejeita TAG WORDs cujo Prefix não seja `000`. As demais regiões serão definidas por edições posteriores.
- A região `000` é um espaço de propostas. No momento, não se aplicam registro nem proteção.
