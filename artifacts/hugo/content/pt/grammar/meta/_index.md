---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta são registros sobre o documento, não sobre o mundo. Dividem-se em sete classes (estrutura, definição, proveniência, linhagem, verificação, política e IMPORT) e ficam no HEAD do documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta são registros sobre o documento, não conteúdo sobre o mundo. Exceto os registros de estrutura do documento (DOC, BODY, END), todos ficam no HEAD do documento. No HEAD, além de Meta, também vêm o Edge de fundamento [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do documento inteiro e os seus QUALIFIERs.

## Layout

```
TAG WORD          0001 1LLL LCCC CCCC
[TAG estendida de Length]
Payload           valor bruto, ou registros Value·Reference embutidos
```

- Meta não tem formato Issuer. Meta é uma especificação comum que todos os Issuers seguem, e só o GEUL a define.
- `LLLL` é o número total de WORDs, incluindo a TAG WORD, menos 1. Os Codecs que não estão na tabela são reservados.

## Formato do Payload

| Formato | Quando | Exemplo |
|---|---|---|
| valor bruto | quando o formato é único. Não depende do Codec de outro registro | comprimento de `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value embutido | quando se escolhe entre vários formatos. A TAG do Value informa o formato | `PROFILE`, `EFFECTIVE-*`, instantes, hash de conteúdo |
| Reference embutida | quando aponta para um alvo, como pessoa, organização, ferramenta ou documento | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, o signatário de `SIGNATURE` |
| nenhum | marcador de 1 WORD | `BODY`, `END` |

- Os registros embutidos não são registros independentes; pertencem a esse Meta. Cada um acha a sua fronteira pelo próprio Length, e a posição depois de ler o último registro deve coincidir exatamente com o fim do Meta.
- Quais Meta podem aparecer uma só vez em um documento e quais podem aparecer várias vezes é determinado pela "quantidade" no documento de cada Codec.

## Classes

Os 3 bits superiores do Codec são a classe.

| 3 bits superiores | Classe | Código direto | O que trata |
|---|---|---|---|
| `000` | estrutura | `0x00`~`0x0F` | limites e comprimento do documento |
| `001` | definição | `0x10`~`0x1F` | declarações de interpretação |
| `010` | proveniência | `0x20`~`0x2F` | quem, quando, onde |
| `011` | linhagem | `0x30`~`0x3F` | de que e como surgiu |
| `100` | verificação | `0x40`~`0x4F` | se é confiável |
| `101` | política | `0x50`~`0x5F` | como é tratado |
| `110` | IMPORT | `0x60`~`0x6F` | importa um documento externo |
| `111` | reservado | `0x70`~`0x7F` | |

- **Meta necessários para a interpretação**: estrutura, definição e IMPORT. Se forem apagados, os registros não podem ser lidos ou a interpretação muda. Todos os decodificadores devem processá-los. Esses Codecs pertencem ao **codebook central do GEUL**.
- **Meta que não mudam a interpretação**: proveniência, linhagem, verificação e política. Mesmo apagados, o conteúdo descrito permanece. Só desaparece a matéria-prima para o julgamento de confiança e o tratamento.
- O fundamento não se escreve com Meta, e sim com o Edge de fundamento [SOURCE](/pt/grammar/edge/source/) e com QUALIFIER. O fundamento de cada registro vai no BODY, e a fonte do documento inteiro vai no HEAD, com um SOURCE de Target `0` ([Documento](/pt/grammar/document/#head-e-body)).

## Estrutura

Documento do conjunto: [Meta — Estrutura](/pt/grammar/meta/structure/)

| Codec | Nome | Significado |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/pt/grammar/meta/structure/doc/) | Abre o documento indicando o comprimento total |
| `0x0E` | [BODY](/pt/grammar/meta/structure/body/) | Encerra o HEAD e abre o BODY |
| `0x0F` | [END](/pt/grammar/meta/structure/end/) | Fecha o documento |

As regras de detalhe estão em [Documento](/pt/grammar/document/).

## Definição

Documento do conjunto: [Meta — Definição](/pt/grammar/meta/declaration/)

| Codec | Nome | Significado |
|---|---|---|
| `0x10` | [SPEC-VERSION](/pt/grammar/meta/declaration/spec-version/) | Versão da especificação seguida. Um inteiro |
| `0x11` | [PROFILE](/pt/grammar/meta/declaration/profile/) | Perfil aplicado |
| `0x12` | [DOC-ID](/pt/grammar/meta/declaration/doc-id/) | Identificador deste documento. DOC-POINTER que aponta para si mesmo (versão 0) |
| `0x13` | [EFFECTIVE-FROM](/pt/grammar/meta/declaration/effective-from/) | Data de entrada em vigor desta versão. Se não houver, o instante da publicação |
| `0x14` | [EFFECTIVE-UNTIL](/pt/grammar/meta/declaration/effective-until/) | Fim da validade desta versão (lei temporária). Se não houver, até a entrada em vigor da próxima versão |
| `0x16` | [DEFAULT-LANGUAGE](/pt/grammar/meta/declaration/default-language/) | Idioma padrão |

- O nome de um documento para o endereço não é posto como Meta. O índice de nomes do Issuer `documents.geul` o liga por BIND ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#nome-do-documento)). O título legível por pessoas liga-se com um LABEL no BODY.

## Proveniência

Documento do conjunto: [Meta — Proveniência](/pt/grammar/meta/provenance/)

| Codec | Nome | Significado |
|---|---|---|
| `0x20` | [AUTHOR](/pt/grammar/meta/provenance/author/) | Autor (Reference) |
| `0x21` | [CO-AUTHOR](/pt/grammar/meta/provenance/co-author/) | Coautor |
| `0x22` | [CREATED-AT](/pt/grammar/meta/provenance/created-at/) | Instante de criação |
| `0x23` | [MODIFIED-AT](/pt/grammar/meta/provenance/modified-at/) | Instante de modificação |
| `0x24` | [RECORDED-BY](/pt/grammar/meta/provenance/recorded-by/) | Quem registrou |
| `0x25` | [RECORDED-AT](/pt/grammar/meta/provenance/recorded-at/) | Instante do registro |
| `0x26`~`0x2F` | Reserved | |

- O material de origem não se escreve com Meta, e sim com o Edge de fundamento [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do HEAD (Target `0`); a faixa do texto original, o instante de obtenção e o hash do texto original escrevem-se com os QUALIFIERs ligados a esse SOURCE.

## Linhagem

Documento do conjunto: [Meta — Linhagem](/pt/grammar/meta/lineage/)

A linhagem segue o modelo de commit do git. A unidade equivalente ao commit é o documento.

| Codec | Nome | Significado |
|---|---|---|
| `0x30` | [PARENT](/pt/grammar/meta/lineage/parent/) | Hash de conteúdo da versão imediatamente anterior. Se houver várias, é um merge |
| `0x31` | [DERIVED-FROM](/pt/grammar/meta/lineage/derived-from/) | Derivado de material de outra linhagem |
| `0x32` | [GENERATED-BY](/pt/grammar/meta/lineage/generated-by/) | Quem gerou (pessoa, modelo, motor de regras) |
| `0x33` | [TRANSFORMED-BY](/pt/grammar/meta/lineage/transformed-by/) | Ferramenta de transformação e versão do seu código-fonte (digest do commit) |
| `0x34` | [CHERRY-PICKED-FROM](/pt/grammar/meta/lineage/cherry-picked-from/) | Versão original da mudança trazida |
| `0x35` | [REVERTS](/pt/grammar/meta/lineage/reverts/) | Versão alvo que foi desfeita |
| `0x36` | [REPLACES](/pt/grammar/meta/lineage/replaces/) | Versão alvo que foi reescrita. A versão original não é apagada |
| `0x37` | [SQUASHED-FROM](/pt/grammar/meta/lineage/squashed-from/) | Versões originais reunidas em uma |
| `0x38` | [MESSAGE](/pt/grammar/meta/lineage/message/) | Motivo da mudança. Um por idioma |
| `0x39` | [TAG](/pt/grammar/meta/lineage/tag/) | Nome imutável dado a uma versão |
| `0x3A` | [DELTA-BASE](/pt/grammar/meta/lineage/delta-base/) | Este arquivo é um diff em relação à versão base |
| `0x3B` | [DELTA-REMOVE](/pt/grammar/meta/lineage/delta-remove/) | Lista de LOCAL IDs a retirar no diff |
| `0x3C` | [NEXT-LOCAL-ID](/pt/grammar/meta/lineage/next-local-id/) | Próximo LOCAL ID a atribuir. Fica no documento da lista de versões |

- O histórico não se apaga. O que foi corrigido sai em uma nova versão.
- Ponteiros mutáveis, como branch, não ficam no documento. Os gerem o repositório e o índice.

## Verificação

Documento do conjunto: [Meta — Verificação](/pt/grammar/meta/verification/)

| Codec | Nome | Significado |
|---|---|---|
| `0x40` | [ISSUER-KEY](/pt/grammar/meta/verification/issuer-key/) | Algoritmo de assinatura e chave pública de um Issuer autoemitido |
| `0x41` | [SIGNATURE](/pt/grammar/meta/verification/signature/) | Assinatura sobre o hash de conteúdo. Algoritmo, signatário, assinatura |
| `0x42` | [SIGNED-OFF](/pt/grammar/meta/verification/signed-off/) | Confirmação do direito de contribuir |
| `0x43` | [CONFIDENCE](/pt/grammar/meta/verification/confidence/) | Grau de confiança |
| `0x44` | [VERDICT](/pt/grammar/meta/verification/verdict/) | Resultado do julgamento do documento inteiro (Pass, Review, Fail) |

- A classe de verificação fica fora do cálculo do hash de conteúdo. Por isso, o hash de conteúdo não muda mesmo que se ponha a assinatura dentro do documento ou se acrescentem várias assinaturas.

## Política

Documento do conjunto: [Meta — Política](/pt/grammar/meta/policy/)

| Codec | Nome | Significado |
|---|---|---|
| `0x50` | [LICENSE](/pt/grammar/meta/policy/license/) | Licença |
| `0x51` | [ACCESS](/pt/grammar/meta/policy/access/) | Âmbito de divulgação |
| `0x52` | [PRIVACY](/pt/grammar/meta/policy/privacy/) | Nível de dados pessoais |
| `0x53` | [RETENTION](/pt/grammar/meta/policy/retention/) | Prazo de retenção |
| `0x54` | [CONSENT](/pt/grammar/meta/policy/consent/) | Âmbito e fundamento do consentimento |
| `0x55` | [USAGE](/pt/grammar/meta/policy/usage/) | Restrições de uso |

- A política não muda a interpretação; define como tratar.

## IMPORT

Documento do conjunto: [Meta — IMPORT](/pt/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[TAG estendida de Length]
Documento         registro DOC-POINTER (Issuer, ID do documento, ID da versão)
IMPORT ID         o restante. Inteiro na menor largura
```

- Usa-se apenas [IMPORT-DOC](/pt/grammar/meta/import/import-doc/) (`0x60`). O IMPORT importa só documentos. Os alvos dentro do documento importado são apontados no BODY por `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID).
- Se o ID da versão for escrito, vincula-se a essa edição; se for `0`, à edição mais recente no momento da interpretação. Os documentos publicados escrevem a versão.
- Num documento, o mesmo IMPORT ID não se atribui duas vezes.
- O HEAD do documento importado não é importado. Os alvos desse documento são interpretados conforme as declarações dele.

Exemplo: importa a versão mais recente do documento do Issuer `0x0001`, `0x0000000000000002`, com o IMPORT ID 1.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
