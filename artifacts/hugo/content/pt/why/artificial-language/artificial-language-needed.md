---
title: "Por que uma linguagem artificial é necessária?"
weight: 7
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["linguagem artificial", "linguagem natural", "alucinação", "LLVM IR"]
summary: "A linguagem natural evoluiu para a comunicação humana. Ambiguidade, redundância e implicação são vantagens para humanos, mas causas de alucinação para a IA. Nem linguagens de programação nem frameworks semânticos existentes são a resposta. É necessária uma nova linguagem artificial que satisfaça seis condições simultaneamente."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

## A linguagem natural trouxe a humanidade até aqui. Mas não pode levá-la adiante.

---

## A Linguagem Natural: A Grande Invenção

A maior tecnologia que o ser humano já criou é a linguagem natural.

Não a descoberta do fogo, nem a invenção da roda, nem a invenção do semicondutor.
O que tornou tudo isso possível foi a linguagem natural.

Graças à linguagem natural, o conhecimento pôde ser transmitido.
Graças à linguagem natural, a cooperação se tornou possível.
Graças à linguagem natural, os vivos puderam herdar os pensamentos dos mortos.

A razão pela qual o Homo sapiens dominou a Terra não foram seus músculos, mas sua linguagem.
Por dezenas de milhares de anos, a linguagem natural foi o meio de toda atividade intelectual humana.

E agora, a linguagem natural se tornou o gargalo da era da IA.

---

## Por que a linguagem natural surgiu?

Para entender esse problema, é preciso voltar ao propósito original da linguagem natural.

A linguagem natural evoluiu para a **comunicação em tempo real entre humanos**.

Quando os humanos primitivos caçavam na savana,
o necessário para transmitir "Tem um leão ali!" não era
uma estrutura lógica precisa, mas velocidade de transmissão.

Essa pressão evolutiva determinou todas as características da linguagem natural.

**A ambiguidade é uma funcionalidade.**
Não importa quantos metros exatamente "ali" significa.
Quando o ouvinte vira a cabeça, o leão está visível.
O contexto compensa a ambiguidade.

**A redundância é uma funcionalidade.**
O significado precisa ser transmitido mesmo que o vento engula metade das palavras.
Por isso a linguagem natural expressa o mesmo significado de múltiplas formas.

**A implicação é uma funcionalidade.**
"Já almoçou?" em português pode ser uma simples saudação,
porque o contexto cultural compartilhado decodifica a implicação.

Todas essas características são vantagens na comunicação entre humanos.
Rápidas, flexíveis, adaptáveis ao contexto.

O problema surge quando tentamos usar isso com a IA.

---

## O que a linguagem natural significa para a IA?

Os LLMs atuais recebem linguagem natural, raciocinam em linguagem natural e produzem linguagem natural.

É como realizar um experimento químico
registrando todas as medições como "bastante", "um pouco", "mais ou menos isso".

"Dom Pedro I foi grandioso."

O que acontece quando a IA processa essa frase?

Quem disse que ele foi grandioso? O falante? Os historiadores? A sociedade brasileira?
Por qual critério grandioso? Militar? Moral? Impacto histórico?
Em que época? Na sua era? Hoje?
Com que grau de certeza? Fato? Opinião? Suposição?

A linguagem natural não especifica nenhuma dessas coisas.
Tudo está implícito sob "entenda pelo contexto".

Os humanos possuem hardware evolutivo de dezenas de milhares de anos para decodificar essas implicações.
Expressões faciais, tom de voz, experiências compartilhadas, bagagem cultural.
A IA não tem nada disso. Tem apenas texto.

Por isso a IA adivinha. E expressa suas adivinhações como se fossem certezas.
Chamamos isso de "alucinação (Hallucination)".

A alucinação não é um bug. Enquanto a linguagem natural for usada
como linguagem de raciocínio da IA, é um resultado estruturalmente inevitável.

---

## A alucinação nasce da ambiguidade da linguagem natural

Vamos ser mais precisos neste ponto.

Quando um LLM responde que "Dom Pedro I proclamou a independência do Brasil em 1822",
qual é a base dessa frase?

Porque padrões semelhantes a essa frase apareceram com alta frequência nos dados de treinamento.

Porém, de que fonte vieram esses padrões,
quão confiável é essa fonte,
qual é a referência temporal dessa informação,
se existem relatos contraditórios ---
nada disso pode ser contido estruturalmente na saída em linguagem natural.

Não há lugar para metadados na linguagem natural.

"Dom Pedro I proclamou a independência em 1822" e
"Registros históricos indicam que Dom Pedro I proclamou a independência em 1822"
são, em linguagem natural, apenas duas frases de comprimentos diferentes.

Porém, epistemologicamente são tipos completamente distintos de declaração.
Uma é uma alegação factual, a outra é um relato com fonte explícita.

A linguagem natural não distingue essa diferença estruturalmente.
Por isso a IA também não distingue.
Por isso ocorrem alucinações.

---

## Linguagens de programação não são a resposta

"Então por que não usar uma linguagem de programação?"

Linguagens de programação não são ambíguas. São estruturadas. São precisas.
Mas linguagens de programação são **linguagens para descrever procedimentos**,
não **linguagens para descrever o mundo**.

Tente expressar "Dom Pedro I foi grandioso" em Python:

```python
is_great("Dom Pedro I") == True
```

Isso não é uma descrição, é um julgamento booleano.
Quem julgou? Com que evidência? Em que contexto? Com que grau de certeza?
Linguagens de programação não têm estrutura para conter isso.

Formatos de dados como JSON, XML e RDF são iguais.
Têm estrutura, mas não há um sistema unificado para definir o significado dessa estrutura.
Cada projeto cria seu próprio schema,
e esses schemas não são compatíveis entre si.

A linguagem natural é rica em significado mas sem estrutura.
Linguagens de programação têm estrutura mas sem significado.
Formatos de dados têm estrutura e significado, mas não são unificados.

O que se precisa é de um tipo diferente de linguagem.

---

## O caminho que o LLVM mostrou

Há um precedente exato na ciência da computação.

Nos anos 1990, existiam dezenas de linguagens de programação
e dezenas de arquiteturas de processadores.
Para cada linguagem suportar cada arquitetura,
eram necessários N × M compiladores.

A solução do LLVM foi a representação intermediária (IR, Intermediate Representation).

Todas as linguagens são traduzidas para LLVM IR.
LLVM IR é traduzida para todas as arquiteturas.
Bastam N + M conversores.

O usuário não vê o LLVM IR.
Escreve em C++ e recebe um executável.
O LLVM IR trabalha nos bastidores.

GEUL é o LLVM IR para a IA.

Todas as linguagens naturais são traduzidas para GEUL.
GEUL é armazenada no WMS, usada no raciocínio e traduzida de volta para linguagem natural.
O usuário não vê GEUL.
Pergunta em linguagem natural e recebe a resposta em linguagem natural.
GEUL trabalha nos bastidores.

---

## Condições que a linguagem artificial deve satisfazer

Para superar os limites da linguagem natural sem perder sua expressividade,
a linguagem artificial deve satisfazer simultaneamente as seguintes condições:

**1. Eliminação da ambiguidade**

Ao inserir "Dom Pedro I foi grandioso",
deve ser estruturalmente explícito "quem, em que contexto, com que evidência, com que grau de certeza fez essa descrição".
Se há um campo vazio, deve ser marcado como vazio.
Sem dependência de implicações.

**2. Metadados incorporados**

Toda descrição deve incluir fonte, momento, grau de confiança e ponto de vista (POV)
não como anotação separada, mas como parte da própria estrutura da descrição.
Sem isso, uma IA White-box é impossível.

**3. Compatibilidade com LLMs**

O LLM deve ser capaz de "aprender" essa linguagem.
Não precisa ser fácil para humanos entenderem.
O importante é que seja tokenizável, com padrões regulares
e que siga uma estrutura fixa.

**4. Expressividade de grafos**

O mundo é um grafo, não uma tabela.
Entidades são nós, relações são arestas.
A linguagem artificial deve ser capaz de serializar grafos naturalmente.

**5. Separação entre fato e relato**

"Dom Pedro I morreu em 1834" não é um fato por si só.
"Registros históricos indicam que Dom Pedro I morreu em 1834" são os dados primários.
A linguagem artificial deve impor estruturalmente essa distinção.

**6. Extensibilidade futura**

O sistema definido hoje deve permanecer extensível
mantendo compatibilidade retroativa
daqui a 10 anos, 100 anos, e em um futuro inimaginável.

---

## Por que as tentativas anteriores são insuficientes?

Esta não é a primeira tentativa.

**O Esperanto** foi uma linguagem artificial para humanos.
Estruturada, mas não projetada para conter o raciocínio da IA.
Priorizou a facilidade de aprendizado sobre a precisão semântica.

**OWL/RDF** foi um sistema de representação semântica para máquinas.
Logicamente rigoroso, mas projetado na era pré-LLM.
Difícil de converter de e para linguagem natural, e verboso na expressão.
E fatalmente lento. Raciocínio em larga escala é impraticável.

**Grafos de conhecimento (Wikidata, Freebase)** representaram o mundo como grafo.
Mas armazenam "fatos", não "relatos".
Armazenam "Dom Pedro I foi imperador" como tripla,
mas não contêm quem fez essa alegação, nem com que grau de certeza.

**Chain-of-Thought** registra o processo de raciocínio do LLM em linguagem natural.
Direção correta, mas como o meio de registro é linguagem natural,
não resolve fundamentalmente o problema da ambiguidade.

Todas essas tentativas satisfazem uma ou duas condições,
mas nenhuma satisfaz as seis simultaneamente.

---

## GEUL: A interseção das seis condições

GEUL está na interseção dessas seis condições.

Formato de stream baseado em palavras de 16 bits.
Toda descrição incorpora estruturalmente contexto, fonte e grau de certeza.
Serializa grafos através de pacotes de nós e arestas.
Segue padrões fixos mapeáveis 1:1 com tokens de LLM.
Trata relatos (Claims), não fatos, como dados primários.
Reserva 50% do espaço de endereçamento total para o futuro.

GEUL não é visível para o usuário.
O usuário fala em linguagem natural e recebe a resposta em linguagem natural.
Nos bastidores, GEUL estrutura o raciocínio,
registra, acumula e torna reutilizável.

---

## A era da linguagem natural não vai acabar

Há algo que não deve ser mal-interpretado.

GEUL não substitui a linguagem natural.
Os humanos continuarão falando, escrevendo e pensando em linguagem natural.
A linguagem natural sobreviverá eternamente como a linguagem da humanidade.

O que GEUL substitui é
o papel que a linguagem natural desempenhava dentro da IA.

O meio do raciocínio.
O formato de armazenamento do conhecimento.
O protocolo de comunicação entre sistemas.

Nesse papel, a linguagem natural já atingiu seus limites.
Esses limites se manifestam como alucinação, caixa-preta e ineficiência.

A linguagem natural trouxe a humanidade até aqui.
Esse mérito é eterno.
Mas para ir ao próximo estágio, é necessária uma nova linguagem.

É por isso que uma linguagem artificial é necessária.

---

## Resumo

A ambiguidade da linguagem natural é uma funcionalidade na comunicação humana, mas um defeito no raciocínio da IA.

1. Não há lugar estrutural para metadados na linguagem natural.
2. Por isso a IA raciocina sem fonte, sem grau de certeza, sem contexto.
3. Por isso ocorrem alucinações. Não é um bug, é uma inevitabilidade estrutural.
4. Linguagens de programação descrevem procedimentos, não descrevem o mundo.
5. Os sistemas de representação semântica existentes satisfazem apenas uma ou duas condições.
6. É necessária uma nova linguagem artificial que satisfaça seis condições simultaneamente.

Assim como o LLVM IR é uma ponte invisível entre linguagens de programação e hardware,
GEUL é uma ponte invisível entre a linguagem natural e o raciocínio da IA.
