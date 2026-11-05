---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta são registros sobre o documento, não conteúdo sobre o mundo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta são registros sobre o documento, não conteúdo sobre o mundo. Exceto os registros de estrutura do documento (DOC, BODY, END), todos ficam no HEAD do documento. No HEAD, além de Meta, também vêm o Edge de fundamento [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) do documento inteiro e o seu QUALIFIER.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      Seções 14 e 15 (0x1C0L~0x1FFL)
[TAG de extensão de Length]
Payload           valor bruto, ou registros Value·Reference embutidos
```

- Meta não tem formato Issuer. Meta é uma especificação comum que todos os Issuers seguem, e só o GEUL a define.
- `LLLL` é o número total de WORDs, incluindo a TAG WORD, menos 1. Os Codecs que não constam da tabela são Reserved.

## Formato do Payload {#payload-형식}

| Formato | Quando | Exemplo |
|---|---|---|
| valor bruto | Quando o formato é único. Não depende do Codec de outro registro | comprimento de `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value embutido | Quando se escolhe entre vários formatos. A TAG do Value indica o formato | `PROFILE`, `EFFECTIVE-*`, instantes, hash de conteúdo |
| Reference embutida | Quando se aponta para um alvo como pessoa, organização, ferramenta ou documento | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, o signatário de `SIGNATURE` |
| nenhum | Marca de 1 WORD | `BODY`, `END` |

- Um registro embutido não é um registro independente; pertence ao seu Meta. Cada um encontra a sua fronteira pelo próprio Length, e a posição após a leitura do último registro deve coincidir exatamente com o fim do Meta.
- Quais Meta podem aparecer uma só vez no documento e quais podem aparecer várias vezes é definido pela «Quantidade» no documento de cada Codec.

## Classes {#클래스}

Os números de Meta continuam sem Reserved a partir de `0x1C0L`. Os bits do número não indicam a classe. A classe se conhece pela tabela de intervalos abaixo.

| Classe | Código direto | O que trata |
|---|---|---|
| estrutura | `0x1C0L~0x1C4L` | Fronteira e comprimento do documento |
| definição | `0x1C5L~0x1CAL` | Declarações de interpretação |
| proveniência | `0x1CBL~0x1D0L` | Quem, quando, onde |
| linhagem | `0x1D1L~0x1DDL` | De onde e como surgiu |
| política | `0x1DEL~0x1E3L` | Como é tratado |
| IMPORT | `0x1E4L` | Importa um documento externo |
| verificação | `0x1E5L~0x1E9L` | É confiável |
| Reserved (exclusivo de verificação) | `0x1EAL~0x1FFL` | |

- A classe de verificação é formada pelos registros da seção 15 com `C >= 5`, isto é, `w >= 0x1E50`. Com isso, sem livro de Codecs, sabe-se qual é a classe de verificação e ela é excluída do hash de conteúdo.
- O Reserved final `0x1EAL~0x1FFL` é exclusivo de verificação. Um novo Meta fora de verificação não pode ser inserido antes de verificação, e se for colocado no Reserved final fica de fora do hash de conteúdo.
- As classes de estrutura, definição e IMPORT não se leem por bits. O decodificador as conhece pela tabela de números embutida.
- **Meta necessários à interpretação**: estrutura, definição, IMPORT. Se apagados, não se consegue ler os registros ou a interpretação muda. Todo decodificador deve tratá-los. Esses Codecs pertencem ao **livro de Codecs central do GEUL**.
- **Meta que não alteram a interpretação**: proveniência, linhagem, verificação, política. Mesmo apagados, o conteúdo dos enunciados permanece. Somem apenas os materiais do juízo de confiança e do tratamento.
- O fundamento não é escrito como Meta, e sim com o Edge de fundamento [SOURCE](../edge/0x0C0L-source.md) e QUALIFIER. O fundamento de cada registro vai no BODY, e a origem do documento inteiro vai no HEAD como SOURCE com Target `0` ([documento](../document.md#head와-body)).

## Estrutura {#구조}

A classe de estrutura de Meta (Codecs `0x1C0L~0x1C4L`) define a fronteira e o comprimento do documento. A unidade dos dados GEUL é um documento.

```
DOC-*                  ← início do HEAD
  Meta de definição, proveniência, linhagem, verificação, política e IMPORT
  SOURCE do documento inteiro e seu QUALIFIER
BODY                   ← início do BODY
  Reference, Value, Edge
END                    ← fecha o documento
```

- Todo documento é aberto com `DOC-1WORD/2WORD/4WORD`, que indica o comprimento total. O decodificador pode saltar o documento inteiro de uma vez usando esse comprimento.
- `BODY` e `END` são registros de 1 WORD sem Payload. `END` é obrigatório.
- Documentos não se aninham. Outros documentos são apontados por IMPORT.
- Se o HEAD (Meta, SOURCE do documento inteiro e seu QUALIFIER) estiver vazio, omite-se o `BODY`. O `BODY` só pode aparecer uma vez por documento.

A estrutura completa do documento está em [documento](../document.md).

| Codec | Nome | Significado |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | Abre o documento indicando o comprimento total |
| `0x1C3L` | [BODY](0x1C3L-body.md) | Encerra o HEAD e abre o BODY |
| `0x1C4L` | [END](0x1C4L-end.md) | Fecha o documento |

As regras detalhadas estão em [documento](../document.md).

## Definição {#정의}

A classe de definição de Meta (Codecs `0x1C5L~0x1CAL`) reúne declarações de interpretação. Como as declarações alteram as regras de interpretação, todo decodificador deve tratá-las. O escopo de uma declaração é o seu documento.

- `SPEC-VERSION` determina como ler os demais registros, por isso usa apenas um inteiro, sem Value embutido. O GEUL v1 é `0x0001` (registro `1C51 0001`).
- `DOC-ID` é o `DOC-POINTER` (Issuer, ID do documento, versão `0`) que aponta para o próprio documento. Documentos de Codec usam `CODEC-POINTER` (Issuer, Codec ID, versão `0`). Se ausente, é um documento sem nome, que só pode ser apontado pelo hash de conteúdo.
- Não existe endereço por nome de documento. O título legível por pessoas é posto como `LABEL` de enunciado ([endereço de publicação e lista de versões](../publishing.md#문서-이름)).

| Codec | Nome | Significado |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | Edição da especificação seguida. Um só inteiro |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | Perfil aplicado |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | Identificador deste documento. DOC-POINTER que aponta para si mesmo (versão 0). Documentos de Codec usam CODEC-POINTER (versão 0) |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | Data de entrada em vigor desta versão. Se ausente, o instante de publicação |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | Fim do período de vigência desta versão (lei temporária). Se ausente, até que a próxima versão entre em vigor |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | Idioma padrão |

- Não existe endereço por nome de documento ([endereço de publicação e lista de versões](../publishing.md#문서-이름)). O título legível por pessoas é posto como LABEL no BODY.

## Proveniência {#출처}

A classe de proveniência de Meta (Codecs `0x1CBL~0x1D0L`) registra quem criou e registrou o documento, e quando.

- O autor, o registrador e seus instantes seguem o modelo author e committer do git (`AUTHOR` e `CREATED-AT`, `RECORDED-BY` e `RECORDED-AT`).
- Mesmo que a proveniência seja apagada, o conteúdo dos enunciados não muda. Somem apenas os materiais do juízo de confiança.
- O material de origem não está nesta classe. A origem do documento inteiro vai no HEAD, e a de cada registro vai no BODY, com o Edge de fundamento [SOURCE](../edge/0x0C0L-source.md). A faixa correspondente no original, o instante de obtenção e o hash do original são QUALIFIER anexados a esse SOURCE (página P304 e seção P958, data de consulta P813, soma de verificação P4092).
- Se as propriedades que acompanham a origem (faixa no original, instante de obtenção) fossem postas como Meta, não se poderia determinar de qual origem são quando há várias. Por isso são escritas como QUALIFIER que tem o SOURCE como Target.

| Codec | Nome | Significado |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | Autor (Reference) |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | Coautor |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | Instante de redação |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | Instante de modificação |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | Agente do registro |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | Instante do registro |

- O material de origem não é escrito como Meta, e sim como Edge de fundamento [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) do HEAD (Target `0`); a faixa no original, o instante de obtenção e o hash do original são escritos como QUALIFIER anexados a esse SOURCE.

## Linhagem {#계보}

A classe de linhagem de Meta (Codecs `0x1D1L~0x1DDL`) registra de onde e como o documento surgiu. A linhagem segue o modelo de commit do git, e a unidade equivalente ao commit é o documento.

- O **hash de conteúdo** aponta para o conteúdo de um exemplar do documento (git commit id). É o SHA-256 desde o registro de abertura (`DOC-*`) até imediatamente antes de `END`, e os registros da classe de verificação (`C >= 5` na seção 15, `w >= 0x1E50`) são excluídos do cálculo.
- O **ID de versão** é um inteiro de 2 WORDs numerado a partir de 1 na ordem de publicação dentro de um documento com nome. `0` significa que a versão não foi indicada.
- Os Meta de linhagem apontam para versões pelo hash de conteúdo. Como o `PARENT` dentro do documento também entra no hash, o hash de conteúdo forma uma cadeia de hashes que liga todo o histórico.
- O histórico não é apagado. O conteúdo corrigido sai como nova versão. Ponteiros mutáveis como branch não são postos no documento.
- `DELTA-BASE` e `DELTA-REMOVE` são o formato que armazena uma versão como diff em relação a uma versão-base. A versão é sempre definida como snapshot.

As regras de revisão estão em [documento](../document.md).

A linhagem segue o modelo de commit do git. A unidade equivalente ao commit é o documento.

| Codec | Nome | Significado |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | Hash de conteúdo da versão imediatamente anterior. Se vários, é mesclagem |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | Derivado de material de outra linhagem |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | Agente gerador (pessoa, modelo, motor de regras) |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | Ferramenta de conversão e sua versão-fonte (digest do commit) |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | Versão original da alteração trazida |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | Versão revertida |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | Versão reescrita. A versão original não é apagada |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | Versões originais fundidas em uma só |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | Motivo da alteração. Um por idioma |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | Nome imutável atribuído a uma versão |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | Este arquivo é um diff em relação à versão-base |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | Lista de LOCAL ID a retirar do diff |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | Próximo LOCAL ID a atribuir. Fica no documento de lista de versões |

- O histórico não é apagado. O conteúdo corrigido sai como nova versão.
- Ponteiros mutáveis como branch não são postos no documento. Quem os gerencia são o repositório e o índice.

## Verificação {#검증}

A classe de verificação de Meta (Codecs `0x1E5L~0x1E9L`) registra os materiais para julgar se o documento é confiável: a chave pública de um Issuer autoemitido, assinaturas, confirmação do direito de contribuir, grau de confiança e o resultado do julgamento do documento inteiro.

- A classe de verificação é excluída do cálculo do hash de conteúdo. Assim, mesmo que a assinatura seja posta dentro do documento, ou que várias assinaturas sejam acrescentadas, o hash de conteúdo não muda (como o `gpgsig` do git).
- A classe de verificação é formada pelos registros da seção 15 com `C >= 5`, isto é, `w >= 0x1E50`, de modo que o hash pode ser calculado sem livro de Codecs. O Reserved final `0x1EAL~0x1FFL` também é exclusivo de verificação e fica fora do hash.
- O julgamento por nó ou registro cabe ao Edge `VERDICT` (`0x118L`) de [TOULMIN](../toulmin/_index.md).

| Codec | Nome | Significado |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | Algoritmo de assinatura e chave pública de um Issuer autoemitido |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | Assinatura sobre o hash de conteúdo. Algoritmo, signatário, assinatura |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | Confirmação do direito de contribuir |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | Grau de confiança |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | Resultado do julgamento do documento inteiro (Pass, Review, Fail) |

- A classe de verificação é excluída do cálculo do hash de conteúdo. Assim, mesmo que a assinatura seja posta dentro do documento, ou que várias assinaturas sejam acrescentadas, o hash de conteúdo não muda.

## Política {#정책}

A classe de política de Meta (Codecs `0x1DEL~0x1E3L`) define como o documento é tratado: licença, nível de divulgação, nível de dados pessoais, prazo de conservação, consentimento e restrição de uso.

- A política não altera a interpretação; define o modo de tratamento.
- A licença original de uma obra contida na sequência de bytes é registrada com `LICENSE`.

| Codec | Nome | Significado |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | Licença |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | Nível de divulgação |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | Nível de dados pessoais |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | Prazo de conservação |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | Escopo e fundamento do consentimento |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | Restrição de uso |

- A política não altera a interpretação; define o modo de tratamento.

## IMPORT {#import}

A classe IMPORT de Meta (Codec `0x1E4L`) importa um documento externo por IMPORT ID. O Codec é um só: `IMPORT-DOC` (`0x1E4L`).

- O IMPORT importa apenas documentos. Os alvos dentro do documento importado são apontados no BODY pela Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) ([Reference](../reference/_index.md)).
- Se um ID de versão for indicado, liga-se a essa edição; se for `0`, liga-se à edição mais recente no momento da interpretação. Documentos publicados indicam a versão.
- O HEAD do documento importado não é importado. Os registros Reference e Value não são importados, mas copiados.

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[TAG de extensão de Length]
Documento         Registro DOC-POINTER (Issuer, ID do documento, ID de versão). Documentos de Codec usam CODEC-POINTER
IMPORT ID         Restante. Inteiro na menor largura
```

- Usa-se apenas [IMPORT-DOC](0x1E4L-import-doc.md) (`0x1E4L`). O IMPORT importa apenas documentos. Os alvos dentro do documento importado são apontados no BODY por `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID).
- Se um ID de versão for indicado, liga-se a essa edição; se for `0`, liga-se à edição mais recente no momento da interpretação. Documentos publicados indicam a versão.
- Num mesmo documento, não se atribui o mesmo IMPORT ID duas vezes.
- O HEAD do documento importado não é importado. Os alvos desse documento são interpretados conforme as declarações desse documento.

Exemplo: importa-se a versão mais recente do documento `0x0000000000000002` do Issuer `0x00000002` com o IMPORT ID 1.

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
