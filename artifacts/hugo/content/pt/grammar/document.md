---
title: "Documento"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "A unidade dos dados GEUL é um único documento (DOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A unidade dos dados GEUL é um único documento (DOC). Um arquivo (`.geul`, tipo de mídia `application/vnd.geul`) é um documento.

## Estrutura {#구조}

```
DOC-*            ← abre o documento (comprimento total)
  Meta …         ← HEAD: registros sobre o documento
  SOURCE …       ←   (procedência do documento inteiro e seu QUALIFIER)
BODY             ← encerra o HEAD e abre o BODY
  Reference, Value, Edge …
END              ← fecha o documento
```

| Registro | TAG | Significado |
|---|---|---|
| DOC-1WORD | `1C01` + 1 WORD | abre o documento com o comprimento total em 1 WORD |
| DOC-2WORD | `1C12` + 2 WORD | comprimento total em 2 WORD |
| DOC-4WORD | `1C24` + 4 WORD | comprimento total em 4 WORD |
| BODY | `1C30` | 1 WORD. Encerra o HEAD e inicia o BODY |
| END | `1C40` | 1 WORD. Fecha o documento |

- O valor de DOC-* é o número total de WORDs desde o início do registro de abertura até o fim de END. Usa-se a menor largura em que o valor cabe.
- END é obrigatório. Se a posição de END não coincide com o comprimento de DOC-*, o documento é rejeitado. Se a entrada termina sem END, o documento está truncado.
- O decodificador pode saltar o documento inteiro de uma vez usando o comprimento de DOC-*.
- Não há como abrir um documento sem conhecer o comprimento. Dados em tempo real cujo fim não se conhece de antemão são cortados em unidades de comprimento conhecido e enviados como vários documentos.
- Se o HEAD está vazio, o BODY é omitido. Um documento sem registros BODY é inteiramente BODY. O BODY aparece uma só vez. Se o HEAD tem ao menos um registro (Meta ou Edge de HEAD), o BODY é obrigatório.
- Documentos não se aninham. Outros documentos são indicados por [IMPORT](meta/_index.md) ou por uma Reference de indicação.

## HEAD e BODY {#head와-body}

- O HEAD contém apenas Meta e **Edge de HEAD**. Ambos descrevem o **documento** que os contém.
  - Meta: estrutura, definição, procedência, linhagem, verificação, política e IMPORT do documento.
  - Edge de HEAD: o Edge de fundamento [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) que registra a origem do documento inteiro (Target `0`), e o [QUALIFIER](edge/0x0ABL-qualifier.md) que tem esse SOURCE como Target (hash do texto original, hora de recebimento, intervalo do texto original etc.). O QUALIFIER vem depois desse SOURCE.
- O BODY contém apenas Reference, Value e Edge. A procedência de cada registro é escrita com o Edge de fundamento [SOURCE](edge/0x0C0L-source.md) dentro do BODY, e outros fundamentos, como a confiabilidade, com um QUALIFIER anexado a esse registro. Um SOURCE com Target `0` e um QUALIFIER que tenha como Target o SOURCE do HEAD não podem ficar no BODY.
- O decodificador lê o HEAD desde o início e classifica. Meta é HEAD. Um SOURCE com Target `0` é HEAD, e seu Edge Id é memorizado. Um QUALIFIER que tenha como Target o SOURCE memorizado é HEAD. Quando aparece qualquer outro registro: se o HEAD está vazio, o BODY foi omitido (o BODY começa nesse registro); caso contrário, é invalid por falta do BODY.
- **O Edge Id usa um único espaço de numeração para HEAD e BODY.** É único dentro do documento e, como nos Edges do BODY, é obtido de [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md). Se a Origin de um Edge de HEAD é LOCAL, sua definição fica no BODY (o escopo de LOCAL é o documento inteiro).
- Um Meta pode conter registros Value no Payload. O Value contido não é um registro independente, mas parte desse Meta.
- O escopo de uma declaração (classe de definição de Meta) é o seu documento.

## Declarações básicas {#기본-선언}

Cada uma das duas declarações ocorre no máximo uma vez. Em quais documentos devem existir é determinado pelas condições abaixo.

| Meta | Significado | Documentos em que deve existir |
|---|---|---|
| [SPEC-VERSION](meta/0x1C5L-spec-version.md) | Edição da especificação seguida. Determina como ler os demais registros. Se a edição é desconhecida, rejeita ou avisa. O valor em documentos v1 é `0x0001` | Documentos publicados. Se ausente, lê-se na edição que o decodificador conhece |
| [DOC-ID](meta/0x1C7L-doc-id.md) | Identificador do próprio documento. É necessário para apontar este documento e seus objetos a partir de fora | Documentos de versão (incluindo documentos de especificação) em `docs/<ID do documento>/` e `codecs/<Codec ID>/` sob `.well-known/geul/`. Não se coloca na lista de versões `versions.geul` nem nos documentos de lista (`issuers/`) |

- `SPEC-VERSION` contém apenas um inteiro, para que o decodificador de qualquer edição possa lê-lo (v1 é `1C51 0001`). Não depende de códigos Value.
- `DOC-ID` é um DOC-POINTER que aponta para o próprio documento (Issuer, ID do documento, versão `0`). O ID do documento tem 4 WORD. Documentos de Codec não têm ID de documento e usam [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, versão `0`). Todo Issuer reserva os IDs de documento `0x0000000000000000` e `0xFFFFFFFFFFFFFFFF` ([Issuer e publicação](issuer.md#용어-정의-문서)).
- Um documento sem `DOC-ID` é um documento sem nome. Só pode ser apontado pelo hash de conteúdo.

## Hash de conteúdo {#내용-해시}

Uma cópia do documento é apontada pelo **hash de conteúdo** (papel equivalente ao ID de commit do git).

- É o SHA-256 desde o registro de abertura (DOC-*) até imediatamente antes de END. 16 WORD.
- Os Meta da classe de verificação (assinatura etc., registros com `C >= 5` na seção 15, isto é, `w >= 0x1E50`) são excluídos do cálculo. Assim, não surge circularidade ao colocar a assinatura dentro do documento.
- No cálculo, o comprimento de DOC-* é substituído pelo comprimento sem os registros de verificação, e a largura também é substituída pela menor largura adequada a esse comprimento. Assim, o hash de conteúdo é o mesmo antes e depois de anexar a assinatura.
- O hash de conteúdo não é registrado no documento: é calculado. Só é escrito como valor ao apontar para outra versão (`PARENT` etc.).
- O `PARENT` dentro do documento também entra no cálculo, de modo que o hash de conteúdo forma uma cadeia de hashes que liga todo o histórico.
- Um Meta anexado depois, fora do documento (anotação em repositório separado etc.), não altera o hash de conteúdo (como git notes).
- A forma canônica do documento é o binário. O hash de conteúdo e a assinatura são calculados apenas sobre o binário.

## Versão {#버전}

Um documento com nome (um documento com `DOC-ID`) tem versões.

- O **ID da versão** é um inteiro de 2 WORD numerado a partir de 1 na ordem de publicação dentro de um documento. `0` significa «versão não indicada» e é tratado como a versão mais recente.
- O ID da versão é atribuído pelo publicador na publicação. A correspondência entre ID da versão e hash de conteúdo fica na lista de versões assinada pelo publicador ([endereço de publicação e lista de versões](publishing.md#버전-목록)).
- O mesmo conteúdo não é publicado de novo. Se o hash de conteúdo já existe, devolve-se o ID da versão correspondente.
- Se os 2 WORD se esgotam, emite-se com um novo ID de documento.
- As versões a partir da v2 registram no HEAD o `PARENT` (hash de conteúdo da versão imediatamente anterior). Como entra no hash de conteúdo, as versões se ligam em cadeia de hashes. Na primeira versão, não se coloca.

## Revisão {#개정}

Os documentos GEUL são revisados como as leis.

- **A versão é imutável.** Uma versão publicada não é alterada nem apagada. As únicas exceções são a exclusão legal e a exclusão de ofício ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- O histórico não é apagado. O conteúdo corrigido sai como nova versão, sem sobrescrever a original (preservação da lei antiga). Uma versão reescrita liga-se à original por [REPLACES](meta/0x1D7L-replaces.md).
- Ponteiros mutáveis como branch, HEAD e reflog não ficam no documento. São gerenciados fora do documento (repositório, índice).
- Uma nova versão pode criar, revisar ou excluir definições. Não promete compatibilidade com a versão anterior. Mudar a definição do mesmo termo também é revisão (exemplo: no Código Civil coreano, «maioridade» de 20 para 19 anos; no Código Penal coreano, o objeto do crime de estupro de «mulher» (부녀) para «pessoa» (사람)).
- **O LOCAL ID é uma identidade que atravessa versões** (como o número de um artigo de lei). O mesmo LOCAL ID aponta para o mesmo objeto mesmo em versões diferentes.
  - Criação: recebe um novo LOCAL ID. Como o ID não tem sentido de ordem, não é preciso inserções como «artigo X-2». O novo número é obtido do `NEXT-LOCAL-ID` da lista de versões (auto increment).
  - Revisão: muda-se o conteúdo do mesmo LOCAL ID.
  - Exclusão: retira-se esse LOCAL ID da nova versão. **O ID excluído não é reutilizado.**
  - Movimento, divisão, fusão: recebe um novo LOCAL ID, e o novo registro leva um QUALIFIER P1365 (replaces, com o valor sendo o LOCAL ID antigo) que liga ao ID antigo. Como o ID antigo não é reutilizado, aponta para esse registro na versão anterior.
- Ferramentas que refazem o documento a partir de dados de origem também seguem esta regra. Dá-se o mesmo LOCAL ID a enunciados iguais aos da versão anterior e novos números apenas aos enunciados alterados ou novos. Não se pode renumerar tudo a partir de 1 a cada vez.
- Uma citação determina a edição. Uma citação com versão fixada liga-se a essa versão; uma citação à mais recente (versão `0`) liga-se à versão vigente no momento da interpretação. Um documento que trata de eventos passados cita fixando a versão que estava em vigor naquele momento.
- Publicação e vigência são coisas diferentes. A hora de publicação é registrada pela lista de versões, e o período de vigência pelo documento.
  - [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) e [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md): período de vigência da versão inteira
  - QUALIFIER P580 (início) e P582 (fim) no Edge de artigo: quando a data de vigência difere por artigo
- **A edição em vigor no momento T é a versão mais alta cuja data de vigência é menor ou igual a T.** Se há QUALIFIERs P580 e P582 por artigo, estes têm precedência. Uma edição cujo prazo de validade (`EFFECTIVE-UNTIL`) passou não está em vigor.
- Regras que decidem qual edição aplicar, como as disposições transitórias («aplica-se a regra anterior»), a lei vigente à época do ato e a escolha da lei nova mais favorável ao réu, ficam a cargo do julgamento ([TOULMIN](toulmin/_index.md)). A informação de vigência é a sua matéria-prima.
- Estreitar ou ampliar a interpretação de um termo por meio de interpretações oficiais ou jurisprudência não é revisão de documento, mas regra de julgamento. Quando a interpretação é fixada por legislação (exemplo: a criação da definição de «1 semana» na Lei de Normas Trabalhistas coreana), é revisão.
- O layout binário (wire) de um Codec e de um número de Codec não é revisado. Isso porque os registros codificados com um número de Codec são lidos sem fixar a versão do codebook. Para alterar o layout, atribui-se um novo número. Um número de Codec excluído não é reutilizado para outro formato.

## Armazenamento de diff {#diff-저장}

A versão é sempre definida como o documento inteiro (instantâneo). O diff é apenas um formato para armazenar e transmitir esse instantâneo com menos espaço.

- Só pode ser guardado como diff um documento que tenha `DOC-ID` e cujo BODY seja inteiramente de Edges. A lista de versões `versions.geul`, que não tem `DOC-ID`, os documentos de lista (versões de `issuers/`) e os documentos sem nome não têm diff.
- Um documento diff é um documento GEUL comum e coloca no HEAD o [DELTA-BASE](meta/0x1DBL-delta-base.md) (ID da versão base).
- A exclusão é escrita com [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) (lista de LOCAL IDs a retirar), e a adição e a revisão com Edges no BODY. Não há marca separada de adição ou revisão. Se o Edge Id existe na base, é revisão; se não, é adição.
- A restauração do instantâneo deve ser determinística (para que o hash confira).
  1. Restaura-se o instantâneo da versão base. Se a base também é diff, restaura-se recursivamente.
  2. O HEAD é substituído por inteiro pelo HEAD do diff sem `DELTA-BASE` e `DELTA-REMOVE`. Os Edges de HEAD também são trocados (não se escrevem em `DELTA-REMOVE`).
  3. O BODY mantém a ordem da base. Os IDs de `DELTA-REMOVE` são retirados e, se o Edge Id de um Edge do BODY do diff existe na base, é trocado naquela posição.
  4. Os Edge Ids que não existem na base são anexados ao final, na ordem em que aparecem no diff.
  5. O hash de conteúdo do resultado deve ser igual ao hash desta versão na lista de versões. Se for diferente, é invalid.
- Reutilizar em um diff um LOCAL ID excluído é invalid. O Edge Id de um Edge de HEAD retirado também não é reutilizado.
- O hash de conteúdo, a lista de versões e a assinatura são todos calculados sobre o instantâneo restaurado.
