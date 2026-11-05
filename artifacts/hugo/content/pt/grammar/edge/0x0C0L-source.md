---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE é o Edge de fundamento que liga um registro (o alvo) ou o documento inteiro à origem de onde ele veio."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `SOURCE` (BIND `SOURCE` do documento de especificação) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| Documento de especificação | `0x00000000/codecs/0x00000C00/` (alvo do DECLARE `0C00`) |
| Seção | 6 `0110` (Edge de fundamento), deslocamento C = 0 dentro da seção |
| Kind | Edge · família: fundamento |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição de índice | Liga um registro ou o documento inteiro à sua origem. Target (Edge Id do BODY; no HEAD, `0` = documento inteiro), Origin (Reference, ABSENT ou UNKNOWN-VALUE). A natureza da origem é um TRIPLE que tem a origem como Subject; a natureza da citação (data de consulta, posição, hash do original) é um QUALIFIER anexado ao SOURCE. O SOURCE do documento inteiro e seu QUALIFIER ficam no HEAD |
| Lado Hugo | `edge/source.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)). O Edge Id de um Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | registro | `0050` LOCAL |  |
| 2 | `origin` | #3 | registro | `000F` seção 0 inteira (curinga, Reference), `020F` seção 1 inteira (curinga, Reference), `040F` seção 2 inteira (curinga, Reference), `0010` UNKNOWN-VALUE, `0000` ABSENT (campo opcional) |  |

SOURCE é o Edge de fundamento que liga um registro (o alvo) ou o documento inteiro à origem de onde ele veio. Codec `0x0C0L`. É o único código direto da família de fundamento (`01`).

Uma reference do Wikidata (grupo de proveniência) corresponde a um SOURCE. Se um registro tem várias proveniências, há vários SOURCE.

## Layout {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[TAG estendida de Length]
Edge Id           registro LOCAL Reference
Target            registro LOCAL Reference (no BODY, o Edge Id do Edge ao qual se anexa o fundamento; no HEAD, 0 = documento inteiro)
Origin            registro Reference, ou marcador de posição 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

- Origin aponta para a origem. Se existe uma Reference adequada à origem, usa-se ela (WIKIDATA-QID, DOC-POINTER e EXTERNAL-ISSUER de um documento GEUL etc.); se não, usa-se um nó LOCAL deste documento.
- Se a proveniência não descreve a origem (por exemplo, uma proveniência que só tem “imported from” (P143) do Wikidata e a data de consulta), Origin é [ABSENT](../slot-marker.md) (não escrito). Quem escreve apenas não registrou a origem; não afirma nada sobre ela. O restante da proveniência permanece nos QUALIFIER.
- [UNKNOWN-VALUE](../slot-marker.md) só é usado quando quem escreve afirma que “há uma origem, mas não se sabe qual” (por exemplo, registros escritos por pessoas). Um conversor que transcreve de um material de origem não afirma o que a origem não disse, e por isso usa ABSENT.
- Cada ocorrência de Origin ABSENT ou UNKNOWN-VALUE é independente. Não se lê a origem de dois SOURCE como a mesma.

## Duas camadas {#두-층}

A informação sobre proveniência divide-se em duas. Não se misturam.

| Camada | O quê | Como escrever | Exemplo |
|---|---|---|---|
| Origem | Natureza da própria origem. É a mesma, quem quer que a cite | [TRIPLE](0x0AAL-triple.md) que tem a origem como Subject (rank normal) | URL (P854), título (P1476), autor (P50·P2093), data de publicação (P577), veículo de publicação (P1433), editora (P123), idioma (P407) |
| Citação | Natureza do ato de este registro citar a origem | [QUALIFIER](0x0ABL-qualifier.md) que tem o Edge Id do SOURCE como Target | data de consulta (P813), posição dentro da origem (página P304, seção P958, identificador externo P227·P1417), de onde foi importado (P143), método de inferência (P887), hash do original (P4092) |

- **O significado de um SOURCE é o conjunto de todos os QUALIFIER que apontam para o seu Edge Id.** Duas proveniências que consultaram a mesma origem em dias diferentes têm a mesma origem e QUALIFIER diferentes.
- Um TRIPLE de origem é uma afirmação sobre a origem. Uma propriedade cuja camada não se pode decidir fica do lado da citação (QUALIFIER). É mais seguro não afirmar nada sobre a origem.
- Dentro de um documento, a mesma origem é declarada uma só vez como um LOCAL, e vários SOURCE apontam para ele.
- Uma origem descrita apenas por uma URL é definida com [REFERENCE-NODE](0x0A0L-reference-node.md) (LOCAL → URI), do mesmo modo que a página de documento de um sitelink.

## Interpretação e validade {#해석과-유효성}

- Target e Origin são, cada um, exatamente um registro completo. O cursor que leu Origin deve coincidir com o fim do Edge.
- Target é uma Reference LOCAL. O SOURCE do BODY aponta para um Edge Id do BODY do mesmo documento. `0` (documento inteiro) só é usado pelo SOURCE do HEAD ([proveniência do documento inteiro](#문서-전체의-출처)). Um SOURCE com Target `0` no BODY é invalid. Para um registro de outro documento, o fundamento é anexado dentro desse documento.
- Origin é uma Reference. Dos marcadores de posição, aceita apenas `0x0000` (ABSENT) e `0x0010` (UNKNOWN-VALUE). Não aceita NO-VALUE (`0x0020`) nem Value.
- O documento de especificação geul.org `0x00000000/codecs/0x00000C00` (nome `source`) coloca em Target o [CODEC](0x0BEL-codec.md) LOCAL (`0050`) e em Origin os CODEC `000F`·`020F`·`040F` (qualquer Reference), `0000` (ABSENT, opcional) e `0010` (UNKNOWN-VALUE).
- A ordem entre SOURCE do mesmo Target não tem significado. A ordem dos itens dentro de uma proveniência também não (a ordem dos valores da mesma propriedade permanece como ordem do documento).
- SOURCE não altera a verdade ou falsidade do alvo. Apenas registra de onde o alvo veio. O resultado do julgamento fica a cargo do `VERDICT` do [TOULMIN](../toulmin/_index.md).

## Proveniência do documento inteiro {#문서-전체의-출처}

A origem do documento inteiro (dump original, edição, arquivo do texto original) é escrita como um **SOURCE com Target `0` no HEAD**. Os QUALIFIER que têm esse SOURCE como Target (hash do original P4092, hora de recebimento P813, intervalo do original etc.) também ficam no HEAD ([documento](../document.md#head와-body)).

- Estes dois são os únicos Edge que podem ficar no HEAD. Os demais Edge ficam no BODY.
- Os QUALIFIER do HEAD vêm depois do SOURCE do HEAD a que apontam. O decodificador lê desde o início e separa HEAD e BODY.
- Um QUALIFIER que tem um SOURCE do HEAD como Target e fica no BODY é invalid. SOURCE e QUALIFIER do BODY não apontam para Edge do HEAD.
- **HEAD e BODY usam um único espaço de numeração de Edge Id.** O Edge Id é único dentro do documento, é recebido de [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) como nos demais Edge, e, ao refazer o documento, o mesmo conteúdo herda o mesmo número. Mesmo numa versão sem um Edge do HEAD, esse número não é reutilizado.
- Se Origin é um LOCAL, sua definição (REFERENCE-NODE, TRIPLE de origem) fica no BODY. O escopo de um LOCAL é o documento inteiro.
- Como os Edge do HEAD não são Meta da classe de verificação, entram no [hash de conteúdo](../document.md#내용-해시). No diff, mudam em bloco junto com o HEAD (não se escrevem em `DELTA-REMOVE`).
- Não há Meta específico para a proveniência do documento inteiro. O intervalo do original e o instante de obtenção escritos como Meta não permitem decidir a qual origem se referem quando há várias. O QUALIFIER anexado a um SOURCE decide isso pelo Target.

Exemplo: HEAD de um documento Q42 transcrito de um dump do Wikidata (os Edge Id são só para ilustração).

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         edição (revision) da entidade
#1741 SOURCE     #0     #1740                                         arquivo de dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            hash do arquivo
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    hora de recebimento
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      hora de gravação da edição
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  endereço permanente da edição
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- A edição e o dump são origens diferentes, por isso há dois SOURCE. A edição é a origem do conteúdo (o mesmo conteúdo pode ser obtido de novo pelo endereço permanente), e o dump é o arquivo em que essa edição foi recebida. O hash do arquivo e a hora de recebimento são propriedades do lado da citação sobre o arquivo de dump, por isso se anexam ao SOURCE do dump.

## Representação de outros fundamentos {#다른-근거의-표현}

Na família de fundamento só existe o SOURCE. Os outros fundamentos são escritos com QUALIFIER.

| Fundamento | Como escrever | Property |
|---|---|---|
| Intervalo dentro do original | QUALIFIER no SOURCE. Um SOURCE por intervalo | página P304, seção P958, citação P1683. Intervalo de caracteres: termo GEUL (indefinido) |
| Instante de recebimento do material de origem | QUALIFIER no SOURCE | data de consulta P813 |
| Hash dos bytes do original (fixa a edição) | QUALIFIER no SOURCE | checksum P4092, valor [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) etc. |
| Agente que produziu (pessoa, modelo, motor de regras) | QUALIFIER no SOURCE (o agente que produziu a citação) ou no alvo | termo GEUL (indefinido) |
| Grau de confiança | QUALIFIER no alvo | termo GEUL (indefinido), valor de 0 a 1 como o Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) |
| Período de vigência por artigo | QUALIFIER no alvo | início P580, fim P582 |
| Registro antigo antes de mover, dividir ou fundir | QUALIFIER no alvo, valor é o Edge Id antigo (LOCAL) | P1365 (replaces) |
| Versão em que entrou pela primeira vez | não se armazena. Calcula-se a partir do histórico de versões (git blame) | |

## Exemplo (não normativo) {#예시-비규범}

Q42 P19 (local de nascimento) Q350, TRIPLE alvo `#178`. No dump do Wikidata de 2026-10-19, esta proposição tem cinco proveniências, das quais três são mostradas. ③ o artigo do Telegraph (`#1358` a `#1367`) tem a mesma forma que ②, e ⑤ Store norske leksikon (Q746368) a mesma que ①, por isso foram omitidos.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: apenas P248, sem descrição da origem
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

- ① não tem descrição da origem e P248 é único, então a origem é esse item. `#1347` ocupa TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `0C07`.

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- Proveniência só com uma URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- Proveniência só com “imported from” da Wikipédia em inglês: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` ocupa 1 WORD.

## Problemas em aberto {#열린-문제}

- Termos GEUL para intervalo de caracteres, agente que produziu e grau de confiança (documento de definição de termo e ID).
- Quando a descrição da origem não identifica a origem (proveniência só com idioma etc.), compartilhar a mesma descrição em um único LOCAL levaria a afirmar que origens diferentes são a mesma.
- Lista de propriedades de origem e de citação para proveniências fora do Wikidata (leis, citações da web).
- Proveniência da proveniência (cadeia): se se deve anexar outro SOURCE ao LOCAL da origem.

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [QUALIFIER](0x0ABL-qualifier.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [marcador de posição](../slot-marker.md)
- [Documento](../document.md) (HEAD e BODY), [Meta — proveniência](../meta/_index.md#출처)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000C00/latest.geul` lido com `geul show` (hexadecimais em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
