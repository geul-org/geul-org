---
title: "Por que devemos deixar vazio"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["reservado", "extensibilidade", "64-bit", "princípio-de-design", "IPv4"]
summary: "GEUL deixa vazio 75% do seu espaço de 64 bits. As lições do IPv4, Unicode e ASCII nos dizem — o custo de preencher é irreversível, mas o custo de deixar vazio é zero."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

64 bits comportam 18.446.744.073.709.551.616 enderecos. 18,4 quintilhoes. GEUL deixa 75% deles vazios.

```
bit1 = 1:    50%    futuro distante
bit1-2 = 01: 25%    futuro proximo
bit1-3 = 001: 12,5% padrao
bit1-4 = 0001: 6,25% proposta atual
```

O espaco atualmente em uso e de 6,25%. Dos 93,75% restantes, 12,5% serao usados quando os padroes forem estabelecidos, e 75% sao reservados para geracoes que ainda nao nasceram.

Por que?

---

## A licao do IPv4

Em 1981, os projetistas do IPv4 acharam que 32 bits seriam suficientes. 4,3 bilhoes de enderecos. Na epoca, havia apenas algumas centenas de computadores no mundo. 4,3 bilhoes pareciam eternos.

Em 2011, os enderecos IPv4 se esgotaram.

30 anos. Apenas 30 anos.

O que a humanidade fez apos o esgotamento: NAT, CGNAT, mercados de negociacao de enderecos, pilha dupla IPv6. Decadas e trilhoes em custos. Tudo "desnecessario se houvessem deixado espaco vazio desde o inicio".

O IPv6 adotou 128 bits. 3,4 × 10^38 enderecos. 6,7 × 10^17 por metro quadrado da superficie terrestre. Desta vez sera suficiente? Provavelmente. Mas nem eles tinham certeza, por isso escolheram 128 bits.

---

## A licao do Unicode

Em 1991, o Unicode 1.0 achou que 16 bits seriam suficientes. 65.536 caracteres. Parecia possivel conter todos os caracteres do mundo.

Nao bastou. Extensoes de caracteres chineses, emojis, escritas antigas, simbolos musicais. Ultrapassaram os 16 bits.

O resultado: pares substitutos de UTF-16. Um dos hacks mais feios da historia do software. Windows, Java e JavaScript ainda carregam esse legado.

O Unicode acabou se expandindo para 21 bits (1.114.112 pontos de codigo). O uso atual e de aproximadamente 10%. O restante foi deixado vazio. Desta vez, a licao foi aprendida.

---

## A licao do ASCII

Em 1963, o ASCII usou 7 bits. 128 caracteres. So pensaram no ingles.

Como resultado, a humanidade viveu 60 anos num inferno de codificacoes. EUC-KR, Shift_JIS, Big5, a serie ISO-8859, CP949. O mesmo byte representava caracteres diferentes dependendo do sistema. Caracteres coreanos corrompidos. Caracteres japoneses corrompidos. Pontos de interrogacao nos assuntos dos e-mails.

Se tivessem usado apenas mais 1 bit. Se tivessem garantido 8 bits completos e dito "o resto fica para depois". A historia teria sido diferente.

---

## A arrogancia do projetista

Todos esses casos tem algo em comum: **a suposicao de que "o que precisamos agora e suficiente".**

Os projetistas do IPv4 eram tolos? Nao. Eram os melhores engenheiros da sua epoca. Apenas subestimaram o futuro. Todas as geracoes fizeram isso.

"640 KB devem ser suficientes para qualquer um." Ha debate sobre se Bill Gates realmente disse isso, mas e fato que engenheiros de todas as epocas cairam nessa armadilha.

GEUL tenta evitar essa armadilha. O metodo e simples. **Nao usar.**

---

## A terceira e de vez

Ha um ditado que diz "a terceira e de vez". A oportunidade decisiva e a terceira.

```
Primeira oportunidade: 001 (padrao)
  Quando os humanos estabelecerem padroes.
  Seja um organismo internacional, um consorcio industrial ou uma comunidade.
  Um espaco que sera preenchido na velocidade em que as pessoas conseguem chegar a acordos.

Segunda oportunidade: 01 (futuro)
  Apos S1. Quando a superinteligencia surgir.
  Uma entidade que estruturara o conhecimento de formas que os humanos nao conseguem prever.
  Pode usar nossa estrutura como esta,
  ou redefini-la de maneiras que nao podemos imaginar.
  Um espaco para essa entidade.

Terceira oportunidade: 1 (futuro distante)
  Nao sabemos quando sera.
  Talvez quando K1 for alcancado e surgir uma civilizacao interestelar,
  talvez quando a propria forma da consciencia mudar,
  talvez algo que hoje so podemos imaginar como ficcao cientifica.
  Se alguem alem do Braco de Orion* estiver lendo este bit,
  este espaco e deles.
```

Reservar 50% para o futuro distante significa ceder metade das possibilidades para "o que nao conhecemos".

---

## O custo de deixar vazio

Deixar vazio tem algum custo?

```
75% reservado de 64 bits = 48 bits nao utilizados.
Os 16 bits restantes (6,25%) = 1.152.921.504.606.846.976 enderecos.

11,5 quintilhoes.
10 milhoes de vezes o total do Wikidata (108 milhoes).
Suficiente para conter todos os dados existentes e muito mais.
```

Deixar vazio nao significa ficar sem espaco. 6,25% e suficiente para as necessidades atuais. O custo de deixar vazio e 0.

E o custo de preencher? O IPv4 mostrou. E irreversivel.

---

## Principio de design

O artigo 1 dos principios de design do GEUL Grammar v0.11:

> **Extensibilidade de longo prazo:** Bits reservados nao sao reatribuidos para usos temporarios. O espaco e preservado para que geracoes futuras possam utiliza-lo.

Esta nao e uma decisao tecnica, mas uma decisao etica.

Deixar sem uso um espaco que poderia ser usado agora e uma declaracao de que a liberdade do futuro importa mais do que a conveniencia do presente. A divida que a geracao que projetou o IPv4 nos deixou, nos nao a deixaremos para a proxima geracao.

---

## O design mais humilde

```
"Eu conheco o futuro" → Uso todos os 64 bits.
"Eu nao conheco o futuro" → Deixo 75% vazio.
```

Deixar vazio e humildade. E reconhecer que nos, aqui e agora, nao podemos conhecer o futuro. E essa humildade produz o design mais robusto.

O IPv4 foi produto da confianca. 32 bits sao suficientes. Nao foram.

GEUL e produto da humildade. Nao sabemos se 6,25% de 64 bits sera suficiente. Mas se deixarmos 75% vazio, tudo bem se estivermos errados.

---

*Explicar por que deixar vazio exigiu tantas palavras. O ato de deixar vazio cabe em uma unica linha:*

```
if (bit1 == 1): reserved  // 50%. Futuro distante.
```

*Uma unica linha de codigo protege metade do mundo.*

---

<small>

\* Orion's Arm — o braco espiral da Via Lactea ao qual pertence o nosso sistema solar. Tambem e o nome do [Orion's Arm Universe Project](https://www.orionsarm.com/), um projeto colaborativo de ficcao cientifica hard que imagina um futuro mais de dez mil anos a frente, ambientado neste braco espiral. Explora temas como superinteligencia, civilizacoes interestelares e transformacao da consciencia com rigor cientifico, e foi construido por centenas de colaboradores desde o ano 2000. O que GEUL chama de "futuro distante", eles ja estao imaginando.

</small>
