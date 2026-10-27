---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE é o Edge de fundamento que liga um registro, ou o documento inteiro, à sua fonte (Codec 0x20). As propriedades da fonte vão num TRIPLE que tem a fonte como Subject; as propriedades da citação (data de consulta, posição dentro da fonte, hash do texto original) vão em QUALIFIERs ligados ao SOURCE. O SOURCE do documento inteiro fica no HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE é o Edge de fundamento que liga um registro (o alvo) ou o documento inteiro à fonte de onde veio. Codec `0x20`. É o único código direto da família de fundamento (`01`).

Uma reference (conjunto de fontes) do Wikidata é um SOURCE. Se um registro tem várias fontes, há vários SOURCEs.

## Layout

```
TAG WORD          0001 0LLL L010 0000
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Target            registro Reference LOCAL (no BODY, o Edge Id do Edge ao qual se anexa o fundamento; no HEAD, 0 = documento inteiro)
Origin            registro Reference, ou marcador de posição 0x0000 ABSENT · 0x0001 UNKNOWN-VALUE
```

- O Origin aponta para a fonte. Se houver uma Reference adequada à fonte, usa-se essa (WIKIDATA-QID, DOC-POINTER ou EXTERNAL-ISSUER de um documento GEUL etc.); se não, um nó LOCAL deste documento.
- Se a origem não descreve uma fonte (por exemplo, uma origem do Wikidata com apenas "imported from" (P143) e data de consulta), o Origin é [ABSENT](/pt/grammar/reference/slot-marker/) (não informado). Quem escreve apenas não informou a fonte, e nada afirma sobre ela. O restante da origem permanece nos QUALIFIERs.
- [UNKNOWN-VALUE](/pt/grammar/reference/slot-marker/) só se usa quando quem escreve afirma que "há uma fonte, mas não se sabe qual" (registros escritos por pessoas etc.). Um conversor que transcreve de um material de origem não afirma o que a origem não diz, e por isso usa ABSENT.
- Um Origin que é ABSENT ou UNKNOWN-VALUE é independente a cada ocorrência. Não se lê que as fontes de dois SOURCEs são a mesma.

## Duas camadas

A informação sobre a origem divide-se em duas. Não se misturam.

| Camada | O quê | Como escrever | Exemplo |
|---|---|---|---|
| Fonte | Propriedades da própria fonte. São as mesmas, não importa quem cite | [TRIPLE](/pt/grammar/edge/triple/) que tem a fonte como Subject (rank normal) | URL (P854), título (P1476), autor (P50, P2093), data de publicação (P577), veículo (P1433), editora (P123), idioma (P407) |
| Citação | Propriedades do ato em que este registro citou a fonte | [QUALIFIER](/pt/grammar/edge/qualifier/) que tem o Edge Id do SOURCE como Target | data de consulta (P813), posição dentro da fonte (página P304, seção P958, identificador externo P227, P1417), de onde foi importado (P143), método de inferência (P887), hash do texto original (P4092) |

- **O significado de um SOURCE é a soma de todos os QUALIFIERs que apontam para o seu Edge Id.** Duas origens que consultam a mesma fonte em dias diferentes têm a mesma fonte e QUALIFIERs diferentes.
- O TRIPLE da fonte é uma afirmação sobre a fonte. Uma propriedade que não se consegue atribuir a uma camada fica do lado da citação (QUALIFIER). É mais seguro não afirmar nada sobre a fonte.
- No documento, a mesma fonte é declarada uma só vez com um LOCAL, e vários SOURCEs apontam para ele.
- Uma fonte descrita apenas por uma URL é definida com [REFERENCE-NODE](/pt/grammar/edge/reference-node/) (LOCAL → URI). É o mesmo modo das páginas de documento de sitelink.

## Interpretação e validade

- Target e Origin são, cada um, exatamente um registro completo. O cursor depois de ler o Origin deve coincidir com o fim do Edge.
- O Target é uma Reference LOCAL. O SOURCE do BODY aponta para um Edge Id do BODY do mesmo documento. O `0` (documento inteiro) só se usa no SOURCE do HEAD ([Origem do documento inteiro](#origem-do-documento-inteiro)). Um SOURCE com Target `0` no BODY é invalid. Para um registro de outro documento, o fundamento é anexado dentro desse documento.
- O Origin é uma Reference. Dos marcadores de posição, só aceita `0x0000` (ABSENT) e `0x0001` (UNKNOWN-VALUE). Não aceita NO-VALUE (`0x0002`) nem Value.
- O documento de especificação `0x0000/0x0000000000001020` (nome `source`) do geul.org põe em Target o LOCAL de [CODEC](/pt/grammar/edge/codec/) (`0008`) e em Origin os CODEC `0780` (qualquer Reference), `0000` (ABSENT, opcional) e `0001` (UNKNOWN-VALUE).
- A ordem entre SOURCEs de um mesmo Target não tem significado. A ordem dos itens dentro de uma origem também não tem (a ordem dos valores de uma mesma propriedade permanece como ordem do documento).
- O SOURCE não muda a verdade ou falsidade do alvo. Apenas registra de onde ele veio. O resultado do julgamento fica a cargo do `VERDICT` de [TOULMIN](/pt/grammar/edge/toulmin/).

## Origem do documento inteiro

A fonte do documento inteiro (dump original, edição, arquivo de texto original) escreve-se com **um SOURCE de Target `0` no HEAD**. Os QUALIFIERs que têm esse SOURCE como Target (hash do texto original P4092, instante de recebimento P813, faixa do texto original etc.) também ficam no HEAD ([Documento](/pt/grammar/document/#head-e-body)).

- Esses são os únicos Edges que podem ficar no HEAD. Os demais Edges ficam no BODY.
- O QUALIFIER do HEAD vem depois do SOURCE do HEAD a que se refere. O decodificador lê do início e separa HEAD e BODY.
- Um QUALIFIER que tenha o SOURCE do HEAD como Target e esteja no BODY é invalid. O SOURCE e o QUALIFIER do BODY não apontam para Edges do HEAD.
- **O Edge Id usa um único espaço de números para HEAD e BODY.** É único no documento, é obtido de [NEXT-LOCAL-ID](/pt/grammar/meta/lineage/next-local-id/) como os outros Edges e, ao refazer o documento, o mesmo conteúdo herda o mesmo número. Mesmo numa versão em que um HEAD Edge saiu, esse número não se reutiliza.
- Se o Origin for LOCAL, a sua definição (REFERENCE-NODE, TRIPLE da fonte) fica no BODY. O LOCAL tem o documento inteiro como âmbito.
- Como os HEAD Edges não são Meta da classe de verificação, entram no [hash de conteúdo](/pt/grammar/document/#hash-de-conteúdo). No diff, mudam por inteiro junto com o HEAD (não se escrevem em `DELTA-REMOVE`).
- Não há um Meta específico para a origem do documento inteiro. Com a faixa do texto original e o instante de obtenção escritos como Meta, não se consegue determinar de qual fonte tratam quando há várias. O QUALIFIER ligado a um SOURCE determina isso pelo Target.

Exemplo: HEAD de um documento de Q42 transcrito de um dump do Wikidata (os Edge Ids são ilustrativos).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         edição (revision) da entidade
#1741 SOURCE     #0     #1740                                         arquivo de dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            hash do arquivo
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    instante de recebimento
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      instante em que a edição foi salva
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  endereço permanente da edição
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- A edição e o dump são fontes diferentes, por isso há dois SOURCEs. A edição é a fonte do conteúdo (o mesmo conteúdo pode ser obtido de novo pelo endereço permanente) e o dump é o arquivo em que essa edição foi recebida. O hash do arquivo e o instante de recebimento são propriedades da citação referentes ao arquivo de dump, e por isso se anexam ao SOURCE do dump.

## Outras formas de expressar o fundamento

A família de fundamento só tem SOURCE. Os outros fundamentos escrevem-se com QUALIFIER.

| Fundamento | Como escrever | Property |
|---|---|---|
| Faixa dentro do texto original | QUALIFIER no SOURCE. Um SOURCE por faixa | página P304, seção P958, citação textual P1683. A faixa de caracteres é um termo GEUL (a definir) |
| Instante em que se obteve o material de origem | QUALIFIER no SOURCE | data de consulta P813 |
| Hash dos bytes do texto original (fixa a edição) | QUALIFIER no SOURCE | checksum P4092, com valor como [SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/) etc. |
| Quem fez (pessoa, modelo, motor de regras) | QUALIFIER no SOURCE (quem fez a citação) ou no alvo | termo GEUL (a definir) |
| Grau de confiança | QUALIFIER no alvo | termo GEUL (a definir), com valor de 0 a 1 como o Meta [CONFIDENCE](/pt/grammar/meta/verification/confidence/) |
| Período de vigência por artigo | QUALIFIER no alvo | início P580, fim P582 |
| Registro antigo, antes de mudança de lugar, divisão ou fusão | QUALIFIER no alvo, com valor = Edge Id antigo (LOCAL) | P1365 (replaces) |
| Versão em que entrou pela primeira vez | Não se armazena. Calcula-se a partir do histórico de versões (git blame) | |

## Exemplo (não normativo)

Q42 P19 (local de nascimento) Q350, TRIPLE alvo `#178`. Quatro origens do dump do Wikidata de 2026-10-19.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: sem descrição da fonte, só um P248
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② artigo do Guardian #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: LOCAL #1158 declarado antes (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① não tem descrição da fonte e só tem um P248, de modo que a fonte é esse item. `#1347` tem TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORDs, TAG `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- Origem com apenas uma URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Origem com apenas "imported from" a Wikipédia em inglês: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. O Origin `0x0000` é 1 WORD.

## Questões em aberto

- Termos GEUL (documento de definição de termos e ID) para expressar faixa de caracteres, quem fez e grau de confiança.
- Quando a descrição da fonte não identifica a fonte (origem só com idioma etc.), compartilhar a mesma descrição em um LOCAL levaria a afirmar que fontes diferentes são a mesma.
- Lista de propriedades de fonte e de citação para origens fora do Wikidata (legislação, citações da web).
- Origem da origem (cadeia): se se anexa um SOURCE de novo ao LOCAL da fonte.

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [TRIPLE](/pt/grammar/edge/triple/), [QUALIFIER](/pt/grammar/edge/qualifier/), [REFERENCE-NODE](/pt/grammar/edge/reference-node/), [Marcador de posição](/pt/grammar/reference/slot-marker/)
- [Documento](/pt/grammar/document/) (HEAD e BODY), [Meta — Proveniência](/pt/grammar/meta/provenance/)
