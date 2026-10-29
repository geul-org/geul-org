---
title: "Por que devemos deixar vazio"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["reservado", "extensibilidade", "TAG WORD", "princípio-de-design", "IPv4"]
summary: "O GEUL deixa vazios 75% do espaço da TAG WORD de 16 bits que abre cada registro. As lições do IPv4, do Unicode e do ASCII: o custo de preencher é irreversível, enquanto o de deixar vazio é de três bits por registro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Todo registro GEUL começa com uma única TAG WORD de 16 bits. Os bits iniciais da TAG WORD a dividem em regiões. O GEUL deixa 75% desse espaço vazio.

```
1xx:  50%    Futuro distante
01x:  25%    Futuro próximo
001:  12.5%  Padrão
000:  12.5%  Gramática atual (livre / proposta)
```

Toda a gramática atual fica na região `000`, dentro dos 12.5%. Quando um padrão oficial for lançado, os layouts adotados permanecem como estão e apenas os bits iniciais passam para `001`. Os 75% restantes ficam para gerações que ainda não nasceram.

Por quê?

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

Deixar espaço vazio custa alguma coisa?

```
TAG WORD de 16 bits = região de 3 bits + 13 bits

Os 13 bits da região atual 000:
  Kind    2 bits   Reference · Value · Edge · Meta
  Length  4 bits   1–14 WORD, até 2³²−1 WORD se estendido
  Codec   7 bits   124 códigos diretos + 4 formas de Issuer
```

13 bits não são pouco? Não. Um formato que não recebe código direto é escrito como formato de Issuer. Cada entidade que define formatos (Issuer) tem seus próprios números de formato de 16 bits, então na prática não há limite para o número de formatos. O preço são algumas WORD de TAG de extensão. Formatos frequentes são curtos; os raros, um pouco mais longos.

O custo de deixar vazio são três bits da TAG WORD por registro. Esses três bits guardam para o futuro seis vezes o espaço usado hoje.

O custo de preencher? O IPv4 nos mostrou. É irreversível.

---

## Princípio de design

O quinto princípio de design da [gramática](/pt/grammar/overview/) GEUL v1:

> **Deixar vazio.** A maior parte do espaço de bits é guardada para o futuro. Códigos diretos não podem ser recuperados, então só os recebem formatos com frequência confirmada.

A gramática fixa esse princípio como regra. Um decodificador v1 rejeita qualquer TAG WORD cujos bits iniciais não sejam `000`. O caminho para pegar emprestado o espaço vazio para uso temporário está fechado desde o início.

Esta não é uma decisão técnica. É uma decisão ética.

Escolher não usar o espaço que poderia ser usado agora é uma declaração de que a liberdade do futuro tem precedência sobre a conveniência do presente. A dívida que a geração que projetou o IPv4 nos deixou, não a deixaremos para a próxima geração.

---

## O design mais humilde

```
"Eu conheço o futuro" -> Usar todos os 16 bits.
"Eu não conheço o futuro" -> Deixar 75% vazio.
```

Deixar espaço vazio é humildade. É o ato de reconhecer que não podemos conhecer o futuro. E essa humildade produz o design mais robusto.

O IPv4 foi produto da confiança. 32 bits são suficientes. Não foram.

O GEUL é produto da humildade. Não sabemos se os 12.5% usados hoje são suficientes. Mas se deixarmos 75% vazio, tudo bem errar.

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
