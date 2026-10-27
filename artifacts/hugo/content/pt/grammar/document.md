---
title: "Documento"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "A unidade dos dados GEUL é o documento. O documento é aberto com o comprimento declarado e fechado com END, e se divide em HEAD (Meta e a origem do documento inteiro) e BODY (Reference, Value, Edge). Cada versão é fixada por um hash de conteúdo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A unidade dos dados GEUL é um documento (DOC). Um arquivo (`.geul`, tipo de mídia `application/vnd.geul`) é um documento.

## Estrutura

```
DOC-*            ← abre o documento (comprimento total)
  Meta …         ← HEAD: registros sobre o documento
  SOURCE …       ←   (origem do documento inteiro e seus QUALIFIERs)
BODY             ← encerra o HEAD e abre o BODY
  Reference, Value, Edge …
END              ← fecha o documento
```

| Registro | TAG | Significado |
|---|---|---|
| DOC-1WORD | `1880` + 1 WORD | abre o documento com o comprimento total em 1 WORD |
| DOC-2WORD | `1901` + 2 WORD | comprimento total em 2 WORDs |
| DOC-4WORD | `1A02` + 4 WORD | comprimento total em 4 WORDs |
| BODY | `180E` | 1 WORD. Encerra o HEAD e inicia o BODY |
| END | `180F` | 1 WORD. Fecha o documento |

- O valor de DOC-* é o número total de WORDs, do início do registro de abertura até o fim de END. Usa-se a menor largura em que o valor cabe.
- END é obrigatório. Se a posição de END não coincidir com o comprimento de DOC-*, o documento é rejeitado. Se a entrada acabar sem END, o documento está truncado.
- O decodificador pode pular o documento inteiro de uma vez pelo comprimento de DOC-*.
- Não há como abrir um documento sem saber o comprimento. Dados em tempo real, cujo fim não se conhece de antemão, são cortados em unidades de comprimento conhecido e enviados como vários documentos.
- Se o HEAD estiver vazio, o BODY é omitido. Um documento sem registros de BODY é todo BODY. O BODY aparece uma só vez. Se o HEAD tiver pelo menos um registro (Meta ou HEAD Edge), o BODY deve estar presente.
- Documentos não se aninham. Outro documento é apontado por [IMPORT](/pt/grammar/meta/) ou por uma Reference de indicação.

## HEAD e BODY

- O HEAD contém apenas Meta e **HEAD Edge**. Ambos são descrições do **documento** que os contém.
  - Meta: estrutura, definição, proveniência, linhagem, verificação, política e IMPORT do documento.
  - HEAD Edge: o Edge de fundamento [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) (Target `0`), que registra a fonte do documento inteiro, e o [QUALIFIER](/pt/grammar/edge/qualifier/) que tem esse SOURCE como Target (hash do texto original, instante de recebimento, faixa do texto original etc.). O QUALIFIER vem depois desse SOURCE.
- O BODY contém apenas Reference, Value e Edge. A fonte de cada registro é escrita com o Edge de fundamento [SOURCE](/pt/grammar/edge/source/) dentro do BODY; outros fundamentos, como o grau de confiança, vão em QUALIFIERs ligados ao registro. Um SOURCE com Target `0` e um QUALIFIER que tenha o SOURCE do HEAD como Target não podem estar no BODY.
- O decodificador lê o HEAD do início e classifica. Meta é HEAD. Um SOURCE com Target `0` é HEAD e o seu Edge Id é memorizado. Um QUALIFIER que tenha como Target o SOURCE memorizado é HEAD. Quando aparece qualquer outro registro: se o HEAD está vazio, o BODY foi omitido (o BODY começa nesse registro); caso contrário, falta o BODY e o documento é invalid.
- **O Edge Id usa um único espaço de números para HEAD e BODY.** É único dentro do documento e, como os Edges do BODY, é obtido de [NEXT-LOCAL-ID](/pt/grammar/meta/lineage/next-local-id/). Se o Origin de um HEAD Edge for LOCAL, a sua definição fica no BODY (LOCAL tem o documento inteiro como âmbito).
- Um Meta pode conter Value no Payload. O Value contido não é um registro independente, mas parte desse Meta.
- O âmbito de uma declaração (classe de definição do Meta) é o seu documento.

## Declarações básicas

Ambas as declarações aparecem no máximo uma vez. As condições abaixo determinam em quais documentos devem estar presentes.

| Meta | Significado | Documento em que deve existir |
|---|---|---|
| [SPEC-VERSION](/pt/grammar/meta/declaration/spec-version/) | Versão da especificação seguida. Define como ler os demais registros. Se a versão for desconhecida, rejeita-se ou avisa-se. O valor em documentos v1 é `0x0001` | Documentos publicados. Se não existir, lê-se na versão que o decodificador conhece |
| [DOC-ID](/pt/grammar/meta/declaration/doc-id/) | Identificador do próprio documento. Necessário para apontar, de fora, para este documento e para os alvos dentro dele | Documentos em `.well-known/geul/` cujo nome começa com `0x` (documentos de versão, documentos de especificação). Não se coloca na lista de versões nem no índice de nomes |

- `SPEC-VERSION` contém só um inteiro, para que qualquer versão de decodificador possa lê-lo (na v1, `1890 0001`). Não depende de um código de Value.
- `DOC-ID` é um DOC-POINTER que aponta para o próprio documento (Issuer, ID do documento, versão `0`). O ID do documento tem 4 WORDs.
- Um documento sem `DOC-ID` é um documento sem nome. Só pode ser apontado pelo hash de conteúdo.

## Hash de conteúdo

Uma cópia de documento é apontada pelo **hash de conteúdo** (papel igual ao do ID de commit do git).

- É o SHA-256 do registro de abertura (DOC-*) até imediatamente antes de END. 16 WORDs.
- Os Meta da classe de verificação (assinaturas etc.) ficam fora do cálculo. Assim, colocar a assinatura dentro do documento não cria circularidade.
- No cálculo, o comprimento de DOC-* é substituído pelo comprimento sem os registros de verificação, e a largura também passa à menor largura adequada a esse comprimento. Assim o hash de conteúdo é o mesmo antes e depois de anexar a assinatura.
- O hash de conteúdo não é gravado no documento; é calculado. Só se escreve como valor para apontar para outra versão (`PARENT` etc.).
- O `PARENT` dentro do documento também entra no cálculo, de modo que o hash de conteúdo forma uma cadeia de hashes que liga todo o histórico.
- Um Meta anexado depois, de fora do documento (anotações em outro repositório etc.), não altera o hash de conteúdo (como git notes).
- A forma canônica do documento é binária. Hash de conteúdo e assinatura são calculados só sobre o binário.

## Versão

Um documento com nome (um documento com `DOC-ID`) tem versões.

- O **ID de versão** é um inteiro de 2 WORDs numerado a partir de 1 na ordem de publicação dentro de um documento. `0` significa "versão não informada" e é tratado como a versão mais recente.
- O ID de versão é atribuído pelo local de publicação no momento da publicação. A correspondência entre ID de versão e hash de conteúdo fica na lista de versões assinada pelo local de publicação ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#lista-de-versões)).
- O mesmo conteúdo não se publica de novo. Se o hash de conteúdo já existe, devolve-se o ID de versão existente.
- Se os 2 WORDs se esgotarem, publica-se com um novo ID de documento.
- As versões a partir da v2 registram no HEAD o `PARENT` (hash de conteúdo da versão imediatamente anterior). Como entra no hash de conteúdo, as versões se encadeiam em uma cadeia de hashes. A primeira versão não o tem.

## Revisão

Os documentos GEUL são revisados como as leis.

- **A versão é imutável.** Uma versão publicada não se altera nem se apaga. As únicas exceções são a exclusão legal e a exclusão de ofício ([TOMBSTONE](/pt/grammar/edge/publication/)).
- O histórico não se apaga. O que foi corrigido sai em uma nova versão, sem sobrescrever a versão original (preservação da lei antiga). Uma versão reescrita liga-se à versão original por [REPLACES](/pt/grammar/meta/lineage/replaces/).
- Ponteiros mutáveis, como branch, HEAD e reflog, não ficam no documento. São geridos fora dele (repositório, índice).
- Uma nova versão pode criar, revisar e excluir definições. Não promete compatibilidade com a versão anterior. Mudar a definição de um mesmo termo também é revisão (ex.: no Código Civil coreano, "maior de idade" passou de 20 para 19 anos; no Código Penal coreano, o objeto do crime de estupro passou de "mulher" para "pessoa").
- **O LOCAL ID é uma identidade que atravessa versões** (como o número de um artigo). O mesmo LOCAL ID aponta para o mesmo alvo em versões diferentes.
  - Criação: recebe-se um novo LOCAL ID. Como o ID não tem sentido de ordem, não é preciso inserir, por exemplo, um "artigo X-2". O novo número vem do `NEXT-LOCAL-ID` da lista de versões (auto increment).
  - Revisão: altera-se o conteúdo sob o mesmo LOCAL ID.
  - Exclusão: o LOCAL ID é retirado da nova versão. **Um ID excluído não se reutiliza.**
  - Mudança de lugar, divisão e fusão: recebe-se um novo LOCAL ID e acrescenta-se ao novo registro um QUALIFIER P1365 (replaces, valor = LOCAL ID antigo) que liga ao ID antigo. Como o ID antigo não é reutilizado, continua apontando para esse registro na versão anterior.
- Ferramentas que refazem o documento a partir de material de origem também seguem esta regra. Dá-se o mesmo LOCAL ID às descrições iguais às da versão imediatamente anterior e só se dão números novos às descrições que mudaram ou surgiram. Não se pode renumerar tudo a partir de 1 a cada vez.
- A citação identifica uma edição. Uma citação com versão fixa fica presa a essa versão; uma citação à mais recente (versão `0`) fica presa à versão vigente no momento da interpretação. Um documento que trata de fatos passados cita fixando a versão que estava em vigor naquele momento.
- Publicação e vigência são coisas distintas. O instante de publicação é registrado pela lista de versões; o período de vigência, pelo documento.
  - [EFFECTIVE-FROM](/pt/grammar/meta/declaration/effective-from/) e [EFFECTIVE-UNTIL](/pt/grammar/meta/declaration/effective-until/): período de vigência da versão inteira
  - QUALIFIER P580 (início) e P582 (fim) do Edge de um artigo: quando a data de vigência difere por artigo
- **A edição em vigor no instante T é a maior versão cuja data de vigência é menor ou igual a T.** Se houver QUALIFIERs P580 e P582 por artigo, eles têm precedência. Uma edição cujo prazo de validade (`EFFECTIVE-UNTIL`) já passou não está em vigor.
- As regras que decidem qual edição aplicar, como as disposições transitórias ("aplica-se a regra anterior"), a lei vigente à época do ato e a escolha da lei nova mais favorável ao réu, ficam a cargo do julgamento ([TOULMIN](/pt/grammar/edge/toulmin/)). A informação de vigência é a matéria-prima dele.
- Quando uma interpretação ou jurisprudência restringe ou amplia a interpretação de um termo, isso não é revisão do documento, e sim uma regra de julgamento. Quando a interpretação é fixada por legislação (ex.: a introdução da definição de "1 semana" na Lei de Normas Trabalhistas coreana), é uma revisão.
- O layout binário (wire) de Codecs e números de formato não é revisado. Isso porque registros codificados por número de formato são lidos sem fixar a versão do codebook. Para mudar um layout, atribui-se um novo número. Um número de formato excluído não se reutiliza para outro formato.

## Armazenamento de diff

A versão é sempre definida como o documento inteiro (snapshot). O diff é apenas um formato para armazenar e transmitir esse snapshot de forma mais compacta.

- Só pode ser guardado como diff um documento que tenha `DOC-ID` e cujo BODY seja todo de Edges. `versions.geul`, `documents.geul` e `issuers.geul`, que não têm gestão de versões, e os documentos sem nome não têm diff.
- Um documento diff é um documento GEUL comum e tem no HEAD um [DELTA-BASE](/pt/grammar/meta/lineage/delta-base/) (ID da versão base).
- A exclusão é escrita com [DELTA-REMOVE](/pt/grammar/meta/lineage/delta-remove/) (lista de LOCAL IDs a retirar); a adição e a revisão, com Edges no BODY. Não há marca separada de adição ou revisão: se o Edge Id existe na base é revisão, se não existe é adição.
- A restauração do snapshot deve ser determinística (para que o hash confira).
  1. Restaura-se o snapshot da versão base. Se a base também for um diff, restaura-se recursivamente.
  2. O HEAD é substituído por inteiro pelo HEAD do diff sem `DELTA-BASE` e `DELTA-REMOVE`. Os HEAD Edges mudam junto (não se escrevem em `DELTA-REMOVE`).
  3. O BODY mantém a ordem da base. Retiram-se os IDs de `DELTA-REMOVE`; se o Edge Id de um Edge do BODY do diff existir na base, ele é trocado naquele lugar.
  4. Os Edge Ids que não estão na base são anexados ao final, na ordem em que aparecem no diff.
  5. O hash de conteúdo do resultado deve ser igual ao hash desta versão na lista de versões. Se for diferente, é invalid.
- Reutilizar no diff um LOCAL ID excluído é invalid. O Edge Id de um HEAD Edge que saiu também não se reutiliza.
- Hash de conteúdo, lista de versões e assinatura são todos calculados sobre o snapshot restaurado.
