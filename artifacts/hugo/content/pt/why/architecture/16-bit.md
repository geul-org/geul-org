---
title: "Por Que 16 Bits?"
weight: 17
date: 2026-02-26T12:00:04+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["16-bit", "binario", "stream"]
summary: "Uma única palavra de 16 bits foi projetada para ser a unidade de três mundos: o fluxo de rede, o formato de arquivo e o vocabulário do LLM. Por que 16 bits, e não 8, 32 ou comprimento variável."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Uma Unica Palavra Atravessa Tres Mundos

---

## Tres Mundos

Existem tres mundos na ciencia da computacao.

**O mundo das redes.**
Os dados fluem como streams de bytes.
Bytes entram por sockets TCP e bytes saem.
O vocabulario do engenheiro de redes e: pacotes, cabecalhos e payloads.

**O mundo do armazenamento.**
Os dados sao persistidos em formatos de arquivo.
Escritos em disco, lidos do disco.
O vocabulario do engenheiro de armazenamento e: blocos, offsets e alinhamento.

**O mundo da IA.**
Os dados sao processados como sequencias de tokens.
LLMs recebem tokens e produzem tokens.
O vocabulario do engenheiro de IA e: embeddings, atencao e contexto.

Esses tres mundos falam linguas diferentes.
E entre eles, a traducao e sempre necessaria.

---

## O Custo da Traducao

Vamos rastrear o caminho que os dados percorrem em um sistema de IA moderno.

O conhecimento e armazenado em um arquivo. Como JSON ou texto puro.

Para entregar isso a uma IA:

1. Abrir o arquivo e ler o texto.
2. Parsear o texto. Se for JSON, interpretar a estrutura e extrair os campos.
3. Alimentar o texto extraido em um tokenizador.
4. O tokenizador converte o texto em uma sequencia de IDs de tokens.
5. A sequencia de tokens e alimentada no LLM.

Quando a IA gera uma resposta:

6. O LLM produz uma sequencia de tokens.
7. Decodificar os tokens de volta para texto.
8. Serializar o texto em um formato estruturado.
9. Escrever os dados serializados em um arquivo.

Uma simples operacao de "ler e escrever" requer nove etapas.

Cada etapa custa tempo.
Cada etapa custa memoria.
Cada etapa arrisca perda de informacao.

As etapas 3 e 4 -- o processo de tokenizacao -- sao notoriamente problematicas.
Como os limites de palavras da linguagem natural nao se alinham com os limites de tokens do tokenizador,
um nome proprio como "Yi Sun-sin" pode ser dividido em fragmentos arbitrarios,
ou uma unica unidade semantica acaba espalhada por multiplos tokens.

Esse e o preco de tres mundos falando linguas diferentes.

---

## E se uma única unidade atravessasse os três mundos?

Nesta linguagem, uma palavra tem 16 bits (2 bytes).

Uma única palavra de 16 bits foi projetada para desempenhar três papéis ao mesmo tempo.

**Unidade do fluxo de bytes.**
Palavras de 16 bits chegam em fluxo contínuo pela rede.
Big Endian. Alinhadas a 2 bytes.
Basta lê-las na ordem em que chegam.

**Unidade do formato de arquivo.**
Grave o fluxo do jeito que está no disco, e isso é o seu arquivo.
Leia os bytes do disco e envie-os do jeito que estão pela rede, e isso é o seu fluxo.
Sem serialização. Sem desserialização.

**Unidade do vocabulário do LLM.**
16 bits = 65.536 símbolos distintos.
O tamanho do vocabulário dos LLMs modernos vai de dezenas a centenas de milhares.
O GPT-2 usa cerca de 50.000; modelos recentes, algo entre 100.000 e 200.000.
65.536 fica dentro dessa faixa.
Uma palavra de 16 bits é uma unidade de um tamanho que um LLM consegue aprender como vocabulário.

Três mundos compartilhando a mesma unidade.
A tradução diminui.

---

## O fluxo é o arquivo

Vejamos o que isso significa concretamente.

**Abordagem convencional: 9 etapas**

```
[Arquivo] -> Ler -> Analisar -> Extrair texto -> Tokenizar -> [LLM]
[LLM] -> Decodificar -> Serializar -> Gravar -> [Arquivo]
```

**A abordagem GEUL**

```
[Fluxo] = [Arquivo]                             mesmos bytes
[Arquivo] -> ler registro a registro, pulando   sem livro de códigos
```

Grave um fluxo como está e é um arquivo. Envie um arquivo como está e é um fluxo.
Sem serialização nem desserialização.
A primeira palavra de cada registro (a TAG WORD) informa o tipo e o comprimento,
então os registros de que você não precisa são pulados sem ser interpretados.

O lado do LLM ainda é uma meta.
Uma palavra não é o mesmo que um token.
Um registro ocupa várias palavras, e o texto vai como sequência de bytes.
Ainda assim, quando a unidade é fixa em 16 bits,
o tokenizador não precisa adivinhar fronteiras; segue fronteiras já dadas.
"Yi Sun-sin" não é partido num lugar arbitrário, porque é um único registro Reference que aponta para o Wikidata Q50184.

---

## Por Que Nao 8 Bits?

8 bits dao 256 simbolos distintos.

256 simbolos sao poucos demais para representar o mundo.
Atribua o alfabeto, digitos e pontuacao basica, e metade do espaco ja se foi.

Se voce usar 8 bits como sua unidade fundamental,
a maioria dos tokens significativos acaba exigindo 2 ou mais bytes.
Isso forca codificacao de comprimento variavel,
e comprimento variavel torna o parsing complexo.

Adequado como unidade de stream de bytes,
mas insuficiente como unidade de token.

---

## Por que não 32 bits?

32 bits dão cerca de 4,3 bilhões de símbolos distintos.

O poder expressivo é mais do que suficiente.
Mas o problema é a eficiência.

O menor registro desta linguagem tem 1 palavra: marcadores como BODY e END, formados por uma única TAG WORD.
Uma Reference ao Wikidata Q42 tem 2 palavras,
e um TRIPLE que diz "Q42 é um ser humano" tem 10.
Com palavras de 16 bits, esse TRIPLE ocupa 20 bytes. Com palavras de 32 bits, ocuparia 40.
O mesmo registro dobra de tamanho.

Do ponto de vista do LLM também há um problema.
Um vocabulário de 32 bits, com 4,3 bilhões de símbolos, é dezenas de milhares de vezes maior que qualquer vocabulário de LLM.
Não há dados nem modelos para aprender um vocabulário desse tamanho.

Uma palavra de 32 bits é excessiva como unidade desta linguagem.

---

## Por Que Nao Comprimento Variavel?

UTF-8 e uma codificacao de comprimento variavel.
O comprimento do caractere varia de 1 byte a 4 bytes dependendo do caractere.

Isso oferece vantagens em eficiencia de armazenamento,
mas introduz uma fraqueza fatal na eficiencia de processamento.

Para encontrar o n-esimo caractere, voce precisa contar desde o inicio.
Acesso aleatorio e impossivel.
Processamento paralelo SIMD se torna dificil.

Esta linguagem usa palavras de 16 bits de largura fixa como sua unidade fundamental.
A posicao da n-esima palavra e sempre n * 2 bytes.
Acesso aleatorio e O(1).
SIMD pode comparar multiplas palavras em uma unica instrucao.
GPUs podem escanear bilhoes de palavras em paralelo.

Ainda assim, no nível do registro, o comprimento variável é permitido.
Os registros vão de 1 palavra a 2³²−1 palavras, e o comprimento está escrito na primeira palavra.
A unidade de palavra é fixa, mas a unidade de registro é flexível.

A eficiencia de processamento da largura fixa combinada com a expressividade do comprimento variavel.
A palavra de 16 bits alcanca ambos simultaneamente.

---

## O caminho que o Unicode provou

O Unicode é o padrão de codificação mais bem-sucedido que a humanidade já criou.

A unidade básica do UTF-16 é de 16 bits (2 bytes).
Ele representa os caracteres do Plano Multilíngue Básico (BMP) em uma única palavra
e estende os demais com pares substitutos (2 palavras = 4 bytes).

O GEUL segue a mesma estrutura.
Formatos frequentes vão como código direto dentro de uma única TAG WORD,
e os raros são estendidos com TAGs de extensão.

Assim como o Unicode expressa todos os caracteres do mundo
sobre a unidade básica "um caractere = 2 bytes",
o GEUL expressa afirmações, suas fontes e seus fundamentos
sobre a unidade básica "uma palavra = 2 bytes".

---

## Compatibilidade Retroativa e Extensao Superior

Outra forca dos 16 bits e o alinhamento.

16 e multiplo de 8, divisor de 32, divisor de 64 e divisor de 128.

Isso significa que o alinhamento nunca se quebra, nao importa em qual direcao voce estenda.

E se a arquitetura do transformer mudar no futuro
e os tokens se tornarem 32 bits?
Duas palavras de 16 bits fazem um token. Sem problemas de alinhamento.

E 64 bits?
Quatro palavras de 16 bits fazem um token. Ainda sem problemas de alinhamento.

Por outro lado, e se um sistema embarcado de 8 bits processar este formato?
Simplesmente leia cada palavra de 16 bits como um byte alto e um byte baixo.

A compatibilidade retroativa deve ser mantida absolutamente.
A palavra de 16 bits garante isso no nivel fisico.

Nao podemos prever o tamanho de palavra das inteligencias futuras,
mas o alinhamento multiplo de 16 bits garante compatibilidade com qualquer tamanho.

---

## A estrutura tripla

Resumindo.

Uma única palavra de 16 bits foi projetada para ser a unidade de três mundos.

| Mundo | Papel de uma palavra |
|-------|---------------------|
| Rede | Unidade do fluxo de bytes |
| Armazenamento | Unidade do formato de arquivo |
| IA | Unidade do vocabulário do LLM (meta) |

Uma única unidade atravessa os três mundos.

Armazene um fluxo como está e é um arquivo.
Envie um arquivo como está e é um fluxo.
Fazê-la se encaixar com os LLMs palavra a palavra é o próximo passo.

Menos conversão.
Menos tradução.
Menos perda.

É por isso que 16 bits.
Nem 8, nem 32, nem comprimento variável.
O número que fica exatamente na interseção de três mundos.

16.
