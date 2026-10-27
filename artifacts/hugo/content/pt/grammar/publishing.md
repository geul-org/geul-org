---
title: "Endereço de publicação e lista de versões"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Um documento GEUL publicado é servido num endereço fixo determinado pelo ID (Issuer, ID do documento, ID da versão) e verificado por uma lista de versões assinada pelo local de publicação. Esta página define a notação de ID, o endereço, a especificação de formato, o índice de nomes, a lista de versões e as camadas de confiança."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

O GEUL aponta para um documento não por uma URL em texto, mas por um ID (Issuer, ID do documento, ID da versão). O endereço é determinado a partir do ID. Esta página define as regras de publicação de que codificadores, decodificadores e resolvedores precisam para funcionar em conjunto. Os níveis de Issuer e o modo de divulgação são definidos em [Issuer e publicação](/pt/grammar/issuer/).

## Notação de ID

Os IDs usados no endereço são escritos em hex.

- O prefixo é `0x` em minúsculas, e os dígitos hex também são minúsculos.
- O número de dígitos é fixo: largura × 4. Não se omitem zeros à esquerda, e o número de dígitos é a própria largura.
- O Issuer ID é escrito na menor largura em que o valor cabe. Não há notação alargada como `0x00000005` (usa-se `0x0005`).

| Alvo | Largura | Dígitos | Exemplo |
|---|---|---|---|
| Issuer | 1 WORD | 4 | `0x0001` |
| Issuer | 2 WORD | 8 | `0x00010000` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 dígitos |
| ID do documento | 4 WORD | 16 | `0x0000000000000000` |
| ID da versão | 2 WORD | 8 | `0x00000003` |
| Hash de conteúdo | 16 WORD | 64 | `0x` + 64 dígitos |

- Um pedido que não esteja na forma canônica (`0X`, maiúsculas, zeros omitidos) é redirecionado com `301` para o endereço canônico. Assim a chave de cache e o alvo da assinatura ficam unívocos.
- As regras do ID da versão (a partir de 1, `0` = mais recente, atribuído pelo local de publicação, novo ID de documento ao se esgotar) são definidas em [Documento](/pt/grammar/document/#versão).

## Endereço de publicação

```
/.well-known/geul/<Issuer>/<ID do documento>.geul              versão mais recente. Envia por 302 ao endereço canônico (mutável)
/.well-known/geul/<Issuer>/<ID do documento>/<ID da versão>.geul    uma cópia do documento (imutável, endereço canônico)
/.well-known/geul/<Issuer>/<ID do documento>/versions.geul     documento da lista de versões (mutável, assinado)
/.well-known/geul/h/<hash de conteúdo>.geul                    consulta por hash de conteúdo (imutável)
```

Exemplo: `/.well-known/geul/0x0001/0x0000000000000000.geul`

- O caminho segue o `.well-known` da RFC 8615. O geul.org e a publicação privada usam o mesmo caminho e só o domínio muda. O único sufixo a registrar é `geul`.
- O conteúdo do documento só sai dos endereços imutáveis. O endereço da versão mais recente não entrega conteúdo: envia por `302` ao endereço canônico dessa versão.
- O endereço canônico de uma versão é `/<Issuer>/<ID do documento>/<ID da versão>.geul`. Outros endereços que entregam o mesmo conteúdo apontam para o endereço canônico com `Link: rel=canonical`.
- Os endereços imutáveis podem ficar em cache permanente e em CDN. Quem recebe verifica pelo hash de conteúdo da lista de versões (ou do registro de bloqueio).
- O ID sempre começa com `0x`. Por isso, nomes reservados (`h`, `keys`, `issuers.geul`, `documents.geul`, `versions.geul`) ou nomes dados por pessoas não colidem com um ID, mesmo que sejam palavras só de hex como `add` ou `cafe`.
- A localização (de qual servidor se recebe) não entra no conteúdo do documento. Se entrasse, o hash de conteúdo mudaria quando o endereço mudasse. A localização é determinada pela configuração de quem recebe o documento.

### Especificação de formato

- Se houver extensão, o formato está especificado. `.geul` é binário (`application/vnd.geul`).
- Sem extensão, segue-se o cabeçalho `Accept`. Entrega-se uma visualização HTML ao navegador e o binário às ferramentas. Exemplo: `/<Issuer>/<ID do documento>/<ID da versão>`
- A forma canônica do documento é binária. Hash de conteúdo e assinatura são calculados só sobre o binário.

### Nome de domínio

O Issuer que passou pela prova de propriedade do domínio pode usar esse domínio, em vez do ID, na posição `<Issuer>` do endereço.

```
/.well-known/geul/<domínio>/<ID do documento>.geul              → 302 → /<Issuer>/<ID do documento>.geul
/.well-known/geul/<domínio>/<ID do documento>/<ID da versão>.geul    → 302 → /<Issuer>/<ID do documento>/<ID da versão>.geul
/.well-known/geul/<domínio>/<ID do documento>/                  → 302 → /<Issuer>/<ID do documento>/
```

Exemplo: `/.well-known/geul/geul.org/0x0000000000001018/0x00000001.geul`

- O endereço por domínio não entrega conteúdo: envia por `302` ao endereço por ID. O endereço canônico, a chave de cache e o alvo da assinatura são o endereço por ID. Como a correspondência pode mudar, não se usa redirecionamento permanente.
- O domínio é escrito em minúsculas, e domínios internacionalizados em IDNA (punycode). Não se acrescenta o `.` final. Se não estiver na forma canônica, é redirecionado com `301` para a forma canônica.
- Como o domínio contém `.`, não colide com IDs que começam com `0x` nem com nomes reservados.
- Ao receber um endereço por domínio, o resolvedor confirma a correspondência pelo índice de nomes de Issuer, converte-o em ID e o registra no registro de bloqueio.
- Issuers de 16 WORD, que não têm registro, e ambientes isolados que não alcançam o geul.org não podem usar nomes de domínio. Usam o endereço por ID.

### Nome do Issuer

O índice de nomes de Issuer é um único documento, `/.well-known/geul/issuers.geul`.

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   nome = "geul.org"
  …
```

- O Subject é [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/) (o próprio Issuer) e o nome é ligado por [BIND](/pt/grammar/edge/bind/).
- O nome é o domínio que passou pela prova de propriedade. Escreve-se em minúsculas, e domínios internacionalizados em IDNA (punycode). Um nome liga-se a um único Issuer.
- O nome de exibição do Issuer legível por pessoas (por idioma) é ligado ao mesmo Subject por um [LABEL](/pt/grammar/edge/label/) descritivo.
- É assinado pelo geul.org (Issuer GEUL); quando muda, acrescenta-se e não se corrige (mesma regra de cadeia da lista de versões).
- O nome reservado `issuers.geul` tem `.` e parece um domínio. Mesmo que surja um domínio com o mesmo nome, este caminho continua sendo o índice de nomes de Issuer.

### Nome do documento

Também se pode usar o nome do documento, em vez do ID, no endereço. Na posição `<Issuer>` usa-se o ID ou o nome de domínio.

```
/.well-known/geul/<Issuer|domínio>/<nome do documento>.geul              → 302 → /<Issuer>/<ID do documento>.geul
/.well-known/geul/<Issuer|domínio>/<nome do documento>/<ID da versão>.geul    → 302 → /<Issuer>/<ID do documento>/<ID da versão>.geul
/.well-known/geul/<Issuer|domínio>/<nome do documento>/                  → 302 → /<Issuer>/<ID do documento>/
```

Exemplo: `/.well-known/geul/geul.org/publication/0x00000001.geul` → `/0x0000/0x0000000000001018/0x00000001.geul`

**O nome do documento é ligado por BIND no índice de nomes do Issuer, `/<Issuer>/documents.geul`.** O resolvedor faz corresponder o nome ao ID do documento por esse índice.

```
BODY
  BIND   Subject = DOC-POINTER(Issuer, ID do documento, versão 0)   nome = "publication"
  …
```

- O Subject é [DOC-POINTER](/pt/grammar/reference/doc-pointer/) (Issuer, ID do documento, versão `0`). O nome liga-se ao documento, não à versão.
- O Issuer do Subject deve ser o mesmo que mantém o índice. Documentos de outro Issuer são ignorados.
- O nome só se liga a documentos publicados.
- O nome do documento é um slug ASCII em minúsculas: `a-z`, `0-9`, `-`. Não começa nem termina com `-` e não começa com `0x`. Assim não colide com um ID de documento (`0x…`) nem com nomes reservados (`h`, `versions.geul` etc.) ([BIND](/pt/grammar/edge/bind/)).
- Dentro de um Issuer, um nome se liga a um só documento, e um nome já ligado não se reutiliza para outro documento. Ao mudar o nome, acrescenta-se um novo BIND. O nome antigo continua encaminhando ao mesmo documento. Se o mesmo nome aparecer várias vezes, o último BIND é o representativo.
- O documento não escreve o próprio nome. O endereço canônico, a chave de cache e o alvo da assinatura são o endereço por ID. IMPORT e as citações dentro do documento usam apenas o ID.
- O título legível por pessoas (por idioma) não é o nome. Liga-se com um `LABEL` descritivo.
- O documento da lista de versões também pode ter o mesmo BIND de nome de documento ([PUBLICATION](/pt/grammar/edge/publication/#nome-do-documento)). Se existir, deve ser igual ao do índice de nomes. O resolvedor lê apenas o índice de nomes.

### Documentos excluídos

- O endereço de uma versão excluída legalmente ou de ofício devolve `410 Gone` e uma lápide (ID da versão, hash de conteúdo, data da exclusão, categoria do motivo).
- Na lista de versões, permanece como um registro [TOMBSTONE](/pt/grammar/edge/publication/).

## Camadas

O GEUL expressa até a origem, o meta e as listas como documentos GEUL. O mínimo necessário para lê-los é incorporado ao decodificador, para quebrar a circularidade. Cada camada só depende das camadas abaixo.

| Camada | Conteúdo | Depende de |
|---|---|---|
| Camada 0 | Regras incorporadas ao decodificador: enquadramento, hash de conteúdo, verificação de assinatura, os Codecs de registro da lista de versões (`PUBLICATION`, `DEPRECATION`, `TOMBSTONE`), o vocabulário de especificação de Codec (`DECLARE`, `FIELD`, `ENUM`, `CODEC`), os [marcadores de posição](/pt/grammar/reference/slot-marker/) (`0x0000`~`0x0002`) e as chaves de confiança recebidas de fora do documento | Nada. Não se consulta nada |
| Camada 1 | Documento da lista de versões | Camada 0 |
| Camada 2 | Documentos comuns, codebooks, documentos de especificação de Codec, documentos de chaves de verificação de Issuer | Encontrados pela camada 1 e verificados pela camada 0 |

- Nenhuma camada depende de si mesma nem de uma camada superior.
- Distingue-se o que se expressa em GEUL do que só se lê interpretando em GEUL. A camada 0 pode ser expressa em GEUL, mas sua interpretação não exige consulta.
- O núcleo fixo que não pode ser convertido em documentos TOULMIN, como o significado do julgamento, também fica aqui ([TOULMIN](/pt/grammar/edge/toulmin/#metacognição-e-autorrevisão)).

## Lista de versões

O local de publicação mantém, para cada documento, um documento de lista de versões ao qual só se acrescenta (`/<Issuer>/<ID do documento>/versions.geul`). O formato dos registros e a estrutura do documento são definidos por [PUBLICATION](/pt/grammar/edge/publication/).

```
DOC-*
  SPEC-VERSION
  PARENT          hash de conteúdo do documento de lista anterior
  RECORDED-AT     instante em que esta lista foi emitida
  NEXT-LOCAL-ID   próximo LOCAL ID a atribuir
  SIGNATURE       assinatura do local de publicação
BODY
  PUBLICATION     #1  documento@1  hash de conteúdo
  PUBLICATION     #2  documento@2  hash de conteúdo
  DEPRECATION     #3  documento@1
  …
END
```

| Edge | Significado |
|---|---|
| PUBLICATION | Publica uma versão do documento e o seu hash de conteúdo |
| DEPRECATION | Marca numa versão publicada a recomendação de descontinuação. Continua a ser interpretada |
| TOMBSTONE | Exclui uma versão publicada (exclusão legal ou de ofício). Registra a categoria do motivo |

- Só se acrescentam registros. Não se corrige, não se apaga e não se muda a ordem. Deprecar e excluir também acrescentam registros. A nova lista mantém na frente o BODY da lista anterior, tal como estava, e acrescenta registros; as listas se encadeiam por uma cadeia de hashes `PARENT`.
- Isso significa que o registro de publicação não é corrigido, o que é diferente da revisão do conteúdo do documento ([Documento](/pt/grammar/document/#revisão)). O estado atual de uma versão é calculado aplicando os registros em sequência.
- O ID da versão é crescente a partir de 1, sem lacunas. O mesmo conteúdo não se publica de novo.
- A versão mais recente é a de maior número que não é nem desaconselhada nem excluída.
- Os registros não levam instante. O `RECORDED-AT` da primeira lista em que o registro aparece é o instante da publicação.
- O documento de lista não tem `DOC-ID`. O ID de documento nos registros diz de que é a lista.
- O documento de lista não tem IMPORT e só usa Codecs da camada 0.
- O documento de lista não é incluído em outra lista (não há lista de listas). As listas anteriores são apontadas só pelo hash de conteúdo (`h/<hash de conteúdo>.geul`), e o histórico se liga pela cadeia `PARENT`.
- O único endereço mutável é o da lista mais recente (`/<Issuer>/<ID do documento>/versions.geul`). Como um ponteiro mutável não pode ser feito como documento, a lista recebida é verificada por sua assinatura, `RECORDED-AT` e `PARENT`.

### Entidade de assinatura

| Assinatura | Entidade | Alvo |
|---|---|---|
| Assinatura do documento | o Issuer desse documento | hash de conteúdo do documento ([Issuer e publicação](/pt/grammar/issuer/#assinatura)) |
| Assinatura da lista | o local de publicação que atribuiu os IDs de versão | hash de conteúdo do documento de lista |

- Na publicação do geul.org, quem atribui os IDs de versão e assina a lista é o geul.org (Issuer GEUL); na publicação privada, é o próprio Issuer.
- O autor responde pelo conteúdo; o local de publicação responde pelos números e pela ordem.

### Verificação

- Como a assinatura fica fora do hash de conteúdo, apagá-la não altera o hash. Por isso a verificação não é "se houver assinatura, confere-se", e sim "tem de haver a assinatura de uma chave determinada". A chave exigida é determinada pela configuração de confiança do resolvedor e pelo registro de bloqueio.
- O resolvedor registra no registro de bloqueio o hash de conteúdo da última lista que viu. Se esse hash não estiver na cadeia `PARENT` de uma lista recém-recebida, ela é rejeitada (evita rebobinar e bifurcar).
- Espelhos e ambientes isolados copiam junto a cadeia de documentos de lista. Com a chave pública, a verificação é possível offline.
- Um documento recebido, de qualquer origem, é verificado pelo hash de conteúdo. Não é preciso confiar na origem.

## Resolução de dependências

- O documento escreve seus documentos dependentes no HEAD com [IMPORT-DOC](/pt/grammar/meta/import/import-doc/).
- Uma nova versão não promete compatibilidade com a anterior. Por isso não se unifica a versão de um documento em todo o grafo (não se usa a seleção de versão mínima).
- Cada `IMPORT-DOC` fica vinculado à edição que fixou. Várias edições de um mesmo documento podem coexistir num grafo (uma sentença que cita a lei antiga e outra que cita a lei vigente). A referência é resolvida por (documento, versão, LOCAL ID).
- A importação da mais recente (versão `0`) vincula-se à edição mais recente no momento da interpretação. Se a interpretação for feita em um instante determinado, vincula-se à edição em vigor nesse instante ([Documento](/pt/grammar/document/#revisão)).
- A importação fixada por ID de versão é reprodutível (o conteúdo de um ID de versão é imutável e verificado pelo registro de bloqueio).

## Tipo de mídia

- O tipo de mídia dos documentos GEUL é `application/vnd.geul`. A extensão é `.geul`.
- Mesmo que se migre para a árvore padrão `application/geul`, continua-se aceitando `application/vnd.geul`.

## Questões em aberto

- Até onde o geul.org serve diretamente os documentos de Issuers de 1, 2, 4 e 16 WORD, e a partir de onde os envia ao endereço de um registro. Os códigos de estado nesse caso (canônico 308, mais recente 302·307).
- Tratamento da divergência de IDs de versão (mesmo ID de versão, conteúdo diferente) na publicação privada, em Issuers de 16 WORD e em ambientes isolados.
- Definição da representação em texto e negociação de conteúdo (conforme `Accept`: binário, texto, visualização HTML).
- Relação entre o índice de nomes de documentos `documents.geul` e o BIND da lista de versões (se serão unificados), e a assinatura do índice.
- Composição do HEAD de `issuers.geul` e formato de assinatura e cadeia. Regras de nome para Issuers sem domínio (1 e 4 WORD), tratamento de disputas de nomes e limite de comprimento.
- Se também o Issuer de 1 WORD pode, opcionalmente, passar pela prova de domínio e usar nome de domínio.
- Quando e em que formato, com listas grandes, passar da cadeia completa para um log Merkle (provas de inclusão e consistência).
- Meta que registra no HEAD o Issuer que fornece a localização.
