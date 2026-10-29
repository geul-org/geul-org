---
title: "Por que Wikidata"
weight: 13
date: 2026-02-26T12:00:17+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["Wikidata", "Ontologia", "wikigeul", "SIDX"]
summary: "O GEUL não rejeita o Wikidata. Carrega o dump sem perdas e transforma cada uma das cerca de 120 milhões de entidades em um documento GEUL com todos os idiomas. Projetar um identificador semanticamente alinhado (SIDX) a partir da sua classificação e das estatísticas de frequência é pesquisa em andamento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## GEUL não rejeita o Wikidata. Ergue-se sobre ele.

---

## Não se pode criar uma língua sem um dicionário

Toda língua precisa de um vocabulário.

O coreano tem o dicionário coreano.
O inglês tem o dicionário inglês.
Linguagens de programação têm bibliotecas padrão.

O mesmo vale para uma língua artificial.
Uma lista de entidades, uma lista de relações, uma lista de propriedades.
Qual código representa a "Samsung Electronics" nesta língua?
Qual código representa a relação "capital"?
É preciso ter um vocabulário antes de poder escrever uma frase.

Como se constrói esse vocabulário?
Há dois caminhos.

Construí-lo do zero.
Ou usar o que já existe.

---

## Construir do zero: a lição do CYC

O projeto CYC começou em 1984.

Seu objetivo era formalizar e armazenar conhecimento geral de senso comum.
A ontologia foi projetada do zero.
Conceitos foram definidos, relações foram definidas, regras foram definidas.
Especialistas os inseriram manualmente.

Trinta anos se passaram.
Milhões de regras foram inseridas.

Porém, estava longe de cobrir o conhecimento do mundo.
Cada domínio exigia o projeto de uma ontologia separada.
Manter a consistência entre domínios se mostrou difícil.
Sempre que um novo conceito surgia, a ontologia precisava ser revisada.
Revisões frequentemente entravam em conflito com regras existentes.

O que o CYC demonstrou não foi seu potencial, mas seus limites.
Ter uma pequena equipe de especialistas projetando a ontologia do mundo
torna-se insustentável em escala.

---

## O que já existe: Wikidata

O Wikidata foi lançado em 2012.

Uma base de conhecimento estruturada operada pela Fundação Wikimedia.
Qualquer pessoa pode editá-la.
Segundo o dump de 19 de outubro de 2026, cerca de 121,97 milhões de entidades.
Delas, 13.991 são propriedades.
Cerca de 1,78 bilhão de declarações.
Rótulos em mais de 600 códigos de idioma.

A escala que o CYC não conseguiu alcançar em 30 anos com uma equipe de especialistas,
o Wikidata alcançou em 14 anos com uma comunidade.

Veja o que o Wikidata oferece.

**Identificadores de entidades.** Q-IDs. Samsung Electronics é Q20718. Seul é Q8684. Yi Sun-sin é Q217300. Identificadores únicos globalmente. Independentes de idioma.

**Identificadores de propriedades.** P-IDs. "Localização da sede" é P159. "Data de fundação" é P571. "População" é P1082. Relações e propriedades são identificadas de forma única.

**Estrutura hierárquica.** P31 (instance of) e P279 (subclass of) formam uma hierarquia de tipos. "Seul → cidade → assentamento humano → entidade geográfica." O sistema de classificação do mundo é expresso por meio dessas duas propriedades.

**Rótulos multilíngues.** O rótulo coreano de Q20718 é "삼성전자", o rótulo em inglês é "Samsung Electronics", o rótulo em japonês é "サムスン電子". Um identificador, nomes diferentes para cada idioma.

**Validação comunitária.** Editores do mundo todo. Detecção de vandalismo. Exigência de fontes. Não é perfeito, mas é mais escalável do que uma pequena equipe de especialistas.

Não há razão para construir tudo isso do zero.

---

## O GEUL traz o Wikidata como ele é

O GEUL não inventa identificadores novos para o Wikidata.
Usa-os como são.

A gramática do GEUL tem References dedicadas ao Wikidata.
[WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/) escreve o número de um Q-ID, e [WIKIDATA-PID](/pt/grammar/reference/wikidata-pid/) o de um P-ID, como inteiro sem sinal.
Q42 é o inteiro 42. P31 é o inteiro 31.
Como são inteiros e não strings, compará-los não exige normalização.

O caminho é este.

**Passo 1: Carga sem perdas.**
O [wikipg](/pt/repos/#wikipg) carrega o dump JSON do Wikidata no PostgreSQL.
Guarda entidades, rótulos, descrições, apelidos, declarações, qualificadores, referências e links de sites na ordem do dump,
e preserva cada linha do dump literalmente.
Também registra o próprio arquivo do dump (URL, tamanho, checksums, commit do carregador).
Só quando nada é descartado é possível verificar depois o que foi trazido e o que foi pulado.

**Passo 2: Um documento por entidade.**
O [wikigeul](/pt/repos/#wikigeul) lê o dump carregado e produz um documento GEUL para cada item e cada propriedade.
Ele contém rótulos, descrições, apelidos, declarações com seus qualificadores e referências, e links de sites.
Todos os idiomas ficam no mesmo documento. Nada é dividido por idioma.

Todos os documentos compartilham um único Issuer, `0x00010000` (wikidata.geul.org).
Um ID de documento tem 64 bits. O byte superior é a letra do tipo de entidade, e os 56 bits inferiores são o seu número.
O documento de Q42 é `0x510000000000002a`. `0x51` é `Q`, e `0x2a` é 42.
O documento de P31 é `0x500000000000001f`.
Basta o hexadecimal para saber de qual entidade é o documento.
Um documento real pode ser lido do início ao fim em [Exemplo: item do Wikidata](/pt/grammar/example/).

**Passo 3: Citar por inteiros.**
Dentro das declarações, itens e propriedades são escritos como inteiros.
"Q42 é um ser humano (Q5)" é um TRIPLE de três inteiros: P31, Q42 e Q5.
Esse inteiro é o número do ID do documento.
De qualquer declaração é possível ir direto ao documento daquilo que ela nomeia.

As referências também são trazidas.
Uma referência do Wikidata vira um SOURCE do GEUL.
O cabeçalho de cada documento registra de qual dump ele veio e qual ferramenta (commit) o converteu.

**Passo 4: Publicar como arquivos pack.**
Não dá para publicar 120 milhões de entidades como 120 milhões de arquivos.
Os documentos são agrupados em um arquivo pack por Issuer, e os registros são comprimidos com zstd.
Quem lê busca só os documentos de que precisa, não o arquivo inteiro.

Neste momento a conversão está sendo verificada no intervalo Q1–Q10000.
A ida e volta pela conversão inversa, o arquivo e a completude são verificados exaustivamente.
A conversão completa e a publicação vêm depois.

---

## O SIDX vem depois

Um Q-ID é um número atribuído por ordem de registro.
Números próximos não significam significados próximos.
Q42 é Douglas Adams; Q41 é a Grécia, e Q43 é a Turquia.

O GEUL também pesquisa outro tipo de identificador.
O [SIDX](/pt/grammar/reference/geul-sidx/) (Semantic-aligned Index), um identificador semanticamente alinhado que dá valores próximos a coisas de significado próximo.
O objetivo é colocar o significado nos próprios bits,
de modo que os bits superiores bastem para dizer se algo é uma pessoa, um lugar ou uma organização.

O SIDX ainda é pesquisa anterior à v1.
A gramática só reserva um lugar para ele: a Reference GEUL-SIDX.
A largura não está decidida. 64 bits, 256 bits e outras estão em estudo, e a escolha seguirá as estatísticas.
Nenhum SIDX foi atribuído ainda.
Por isso os documentos atuais do Wikidata são escritos com Q-IDs, sem SIDX.
Quando valores SIDX forem atribuídos, o identificador existente e o SIDX da mesma coisa serão ligados com [SAME-NODE](/pt/grammar/edge/same-node/).

É aqui que o Wikidata entra de novo.
A pesquisa do SIDX parte do sistema de classificação e das estatísticas de frequência do Wikidata.
A direção em estudo é esta.

**Extração de tipos.**
Reunir os Q-IDs usados como objeto de P31 (instance of).
Essa é a lista de "tipos".
"Ser humano (Q5)", "cidade (Q515)", "país (Q6256)", "empresa (Q4830453)"...
Contar as instâncias de cada tipo.

**Construção da hierarquia.**
Construir uma árvore com as relações P279 (subclass of) entre tipos.
"Cidade → assentamento humano → entidade geográfica → entidade."
Como tratar a herança múltipla, quando um tipo pertence a vários tipos superiores, é um problema em aberto.

**Atribuição de bits.**
A estrutura da árvore vira a relação de prefixos dos padrões de bits.
Subtipos sob o mesmo tipo superior compartilham o mesmo prefixo.
"Cidade" e "vila" compartilham o prefixo de "assentamento humano".
Tipos com muitas instâncias recebem um prefixo mais curto, isto é, um espaço de números mais amplo.
É a mesma ideia da codificação de Huffman.

Isto ainda é uma hipótese.
Restam problemas a resolver.
Um SIDX já atribuído não deve se mover quando as estatísticas mudam.
O mesmo valor nunca deve ser atribuído a duas coisas.
Também é preciso decidir o formato em que o livro de códigos e o registro serão publicados.

---

## O que o Wikidata fornece

Neste caminho, o Wikidata fornece três coisas.

**Identificadores.**
A resposta a "para o que no mundo estamos apontando?".
Q-IDs e P-IDs viram, como são, References inteiras do GEUL.
O conhecimento do Wikidata pode ser levado para documentos GEUL,
e os identificadores do Wikidata podem ser lidos diretamente nos documentos GEUL.

**Sistema de classificação.**
A resposta a "que tipos de coisas existem no mundo?".
O CYC fez uma equipe de especialistas projetar isso.
O GEUL o toma do Wikidata.
O objetivo da pesquisa é transformar o sistema de classificação que os editores acordaram ao longo de 14 anos
na árvore de bits do SIDX.

**Estatísticas de frequência.**
A resposta a "quantas coisas de cada tipo existem no mundo?".
Se há 9 milhões de entidades humanas e 1 milhão de asteroides,
o tipo "ser humano" deveria receber um código mais eficiente que "asteroide".
A frequência de uso real vira a base do projeto de códigos.

---

## O que o Wikidata não fornece

O Wikidata é um dicionário. Um dicionário não é uma linguagem.

Um dicionário fornece uma lista de palavras.
Uma linguagem fornece a gramática para formar frases com palavras.

O que o Wikidata não fornece é o que o GEUL acrescenta.

**De fato a alegação.**
A unidade básica do Wikidata é o fato (Fact).
"A população de Seul é de 9,74 milhões."
É verdadeiro ou falso.

A unidade básica do GEUL é a alegação (Claim).
"Segundo A, a população de Seul é de aproximadamente 9,74 milhões. (confiança 0,9, referência 2023)"
Quem alega, com que certeza e a partir de quando fazem parte da declaração.
Essa diferença é discutida em detalhe em [Por que alegações, não fatos](/pt/why/claims-not-facts/).

**Qualificadores verbais.**
O Wikidata não tem lugar para expressar as nuances dos verbos.
Em "Yi Sun-sin venceu a Batalha de Myeongnyang",
onde estão tempo, aspecto, evidencialidade, modo e confiança?
No Wikidata, isso é expresso parcialmente por qualificadores,
mas não há um sistema sistemático de qualificação verbal.

O GEUL está projetando um sistema de qualificação verbal que acrescenta a cada declaração, de forma estrutural,
dimensões como tempo, aspecto, polaridade, evidencialidade, modo, volitividade e certeza.
Isso também é trabalho anterior à v1.

**Palavras de 16 bits.**
As representações do Wikidata não foram projetadas para janelas de contexto.
JSON-LD, RDF, SPARQL.
Legíveis por máquina, mas não eficientes em tokens.

O GEUL é uma sequência de palavras de 16 bits.
A primeira palavra de um registro (a TAG WORD) informa o tipo e o comprimento desse registro.
Registros podem ser filtrados e pulados mesmo sem livro de códigos.
É uma representação construída sobre a premissa de que a janela de contexto é finita.
Isso já foi discutido em [Por que não MD/JSON/XML](/pt/why/not-md-json-xml/).

**Pipeline de contexto.**
O Wikidata é um repositório. O GEUL é parte de um pipeline.
Clarificação, verificação, filtragem, checagem de consistência, exploração — tudo o que foi discutido nesta série
opera sobre a representação estruturada do GEUL.
O Wikidata não tem esse pipeline.
Nem precisa. O Wikidata tem outro propósito.

---

## A relação entre dicionário e linguagem

Em resumo:

O Wikidata é o vocabulário do mundo.
Que entidades existem,
que relações existem,
que tipos há e como são classificados.
Uma comunidade construiu isso ao longo de 14 anos.

O GEUL põe gramática sobre esse vocabulário.
Os identificadores do vocabulário → References inteiras do GEUL.
As entradas do vocabulário → um documento GEUL por entidade.
O sistema de classificação e as estatísticas de frequência do vocabulário → material para a pesquisa do SIDX.

E acrescenta o que falta ao vocabulário.
Estrutura de alegações. Qualificação verbal. Palavras de 16 bits. Um pipeline de contexto.

Seria possível construir o GEUL sem o Wikidata?
Sim. Seria possível projetar uma ontologia do zero, como fez o CYC.
Mas isso foi tentado há 40 anos, e os resultados estão aí.

Como o Wikidata existe, o GEUL não projeta uma ontologia.
Traz um consenso que já existe.

---

## Resumo

Uma linguagem artificial precisa de um vocabulário.
Construí-lo do zero foi o que o CYC tentou, e 30 anos provaram os limites dessa abordagem.

O Wikidata é o vocabulário do mundo, com cerca de 120 milhões de entidades e cerca de 1,78 bilhão de declarações (dump de outubro de 2026).
Uma comunidade o construiu ao longo de 14 anos.

O GEUL traz esse vocabulário como ele é.
O wikipg carrega o dump no PostgreSQL sem perdas,
e o wikigeul transforma cada entidade em um documento GEUL com todos os idiomas.
Itens e propriedades são citados como inteiros, e os documentos são publicados como arquivos pack.

O SIDX é a pesquisa que vem depois.
Ele projeta um identificador semanticamente alinhado a partir das frequências de instâncias de P31 e da hierarquia de P279.
Nem a largura nem as atribuições estão decididas ainda.

O Wikidata é um dicionário; o GEUL é uma linguagem.
Um dicionário fornece palavras; uma linguagem fornece gramática.
O GEUL constrói estrutura de alegações, qualificação verbal, palavras de 16 bits e um pipeline de contexto sobre o vocabulário do Wikidata.

O GEUL não rejeita o Wikidata.
Ergue-se sobre ele.
