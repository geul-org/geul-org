---
title: "Issuer e publicação"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "O Issuer é a entidade que define documentos e formatos. O modo de emissão varia conforme a largura (1, 2, 4 ou 16 WORDs). Esta página define os níveis de Issuer, a tabela de atribuição de 1 WORD, o modo de divulgação dos documentos, a assinatura e a publicação das chaves de verificação."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

O GEUL não concentra o sistema de identificação em um só lugar. Cada Issuer define seus alvos e formatos, e os outros documentos usam as definições publicadas. A definição pode ser mantida confidencial, publicada no geul.org (CC0) ou publicada em caráter privado (com a licença que o Issuer determinar). Qual definição merece confiança é decisão do usuário.

Endereço de publicação, especificação de formato, índice de nomes, lista de versões e camadas de confiança são definidos em [Endereço de publicação e lista de versões](/pt/grammar/publishing/).

## O que o Issuer define

| Objeto | Método |
|---|---|
| Alvos (entidades, conceitos, termos) | declarados como LOCAL do seu próprio documento |
| Formato de Value | definido por um número de formato sob o código do Issuer |
| Formato de Edge | definido por um número de formato sob o código do Issuer |

- A definição de formatos de Value e Edge também é publicada como documento.

## Princípios

- Todo ID tem o documento como âmbito. O LOCAL ID (inclusive Edge Id e variáveis) e o IMPORT ID só valem dentro desse documento.
- O alvo definido por um Issuer é o LOCAL de um documento publicado por esse Issuer. Outros documentos o citam diretamente por indicação-declaração (`EXTERNAL-ISSUER-*`) ou o importam com `IMPORT-DOC` e o apontam com `EXTERNAL-POINTER-*`.
- Para um alvo que precisa ser apontado de fora do documento, emite-se um LOCAL em um documento publicado. Esse documento deve ter [DOC-ID](/pt/grammar/meta/declaration/doc-id/).

## Níveis de Issuer

| Largura | Faixa de valores | Emissão |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | atribuído pelo geul.org a entidades de normalização e a grandes instituições ([tabela de atribuição de 1 WORD](#tabela-de-atribuição-de-1-word)) |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | registro no geul.org. Passa por prova de propriedade do domínio |
| 4 WORD | `2^32`~`2^64−1` | registro no geul.org. Sem prova de propriedade |
| 16 WORD | `2^64` ou mais | autoemissão. Calculado a partir da chave pública |

- **O Issuer ID é um valor inteiro.** Valores iguais são o mesmo Issuer (`0x0001` e `0x00000001` são o mesmo valor). A largura não faz parte do identificador.
- **A forma canônica é a menor largura.** Escreve-se na menor largura em que o valor cabe, e a notação em largura maior é rejeitada. Por isso a atribuição de cada largura começa no valor seguinte ao fim da faixa da largura imediatamente inferior (2 WORD começa em `0x00010000`).

## Tabela de atribuição de 1 WORD

Os Issuers de 1 WORD são atribuídos pelo geul.org a entidades de normalização e a grandes instituições. Os formatos próprios projetados pelo GEUL ficam em `GEUL`; os formatos de fato ou por convenção, sem entidade normativa, ficam em `ADHOC`.

| Issuer | Nome | Entidade | Formatos representativos |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | formatos próprios do GEUL, codebooks |
| `0x0001` | ADHOC | geul.org | formatos por convenção sem entidade normativa. BFLOAT16, BLAKE3, complexos, frações, intervalos, quaternions, vetores e tensores |
| `0x0002`~`0x000F` | reservado | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601, ISO 4217 (moedas), ISO 3166 (países) |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000 (notação de unidades) |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | normas de tecnologia da informação ISO/IEC |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509, X.690 (codificação ASN.1) |
| `0x0014`~`0x001F` | reservado | entidades internacionais de normalização | |
| `0x0020` | IETF | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4 e IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | tipos de mídia, registro de subtags de idioma |
| `0x0022` | W3C | World Wide Web Consortium | tipos de dados XML Schema, RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0024` | UNICODE | Unicode Consortium | codificação de caracteres, normalização, CLDR |
| `0x0025` | ECMA | Ecma International | JSON (ECMA-404) |
| `0x0026`~`0x003F` | reservado | entidades de normalização da internet e da web | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | ponto flutuante e decimal IEEE 754, endereço MAC (802) |
| `0x0041` | KHRONOS | Khronos Group | formatos de pixel (RGBA8, BGRA8 UNORM), glTF |
| `0x0042` | OGC | Open Geospatial Consortium | coordenadas e caixas delimitadoras, família GeoJSON |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN, E4M3FNUZ, E5M2, E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | formatos Microscaling (E8M0, FP4 E2M1) |
| `0x0045` | OASIS | OASIS Open | normas de documentos e segurança |
| `0x0046`~`0x005F` | reservado | entidades de normalização industrial | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | unidades SI, TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | segundo intercalar, UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x0063` | GPS | entidade governamental que opera o GPS | tempo GPS |
| `0x0064`~`0x00FF` | reservado | instituições de metrologia e governamentais | |
| `0x0100` | KATS | Agência Coreana de Tecnologia e Normas (KATS) | normas KS |
| `0x0101`~`0x01FF` | reservado | instituições nacionais de normalização | |
| `0x0200`~`0xFFFF` | reservado | atribuição posterior | |

- Os formatos de extensão ficam sob o Issuer da entidade que normatizou o formato. Os números de formato sob um Issuer são definidos por cada Issuer.
- Os bits superiores do número de formato devem seguir a regra de famílias do Kind correspondente. Assim a família é conhecida sem codebook.
- Se uma entidade de normalização não administra diretamente os números de formato do GEUL, o geul.org registra a norma dela com um número em seu lugar. O número é registrado junto com o identificador do documento da norma.
- A atribuição é feita dos números menores para os maiores, dentro da faixa de cada categoria de entidade. A faixa serve à conveniência de classificação, e o decodificador não é obrigado a interpretá-la.

## Issuer de 16 WORD

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID do algoritmo de assinatura (2 bytes) ‖ chave pública)
```

- Os 32 bytes do resultado são escritos nas 16 WORDs, a partir do byte mais significativo.
- Qualquer pessoa pode criá-lo sem registro. A propriedade é provada pela assinatura com a chave privada.
- A chave pública e o algoritmo são declarados no HEAD do documento com [ISSUER-KEY](/pt/grammar/meta/verification/issuer-key/). O algoritmo de assinatura `0x0001` é Ed25519; os demais valores são reservados.
- O prefixo `GEUL-ISSUER-v1` evita que a mesma chave gere o mesmo ID quando usada para outra finalidade (separação de uso).
- Mesmo que o algoritmo de assinatura mude (ex.: Ed25519 → ML-DSA), a largura do ID continua sendo 16 WORDs.
- Se o resultado for menor que `2^64` (probabilidade praticamente nula), não se cria um Issuer com essa chave, porque colidiria com a regra da menor largura.

## Prova de domínio

- A prova de propriedade do domínio de um Issuer de 2 WORD é verificada apenas no momento do registro. Depois, a gestão do domínio é responsabilidade do Issuer.
- Um domínio corresponde a um só Issuer. Um Issuer pode ter vários domínios. A correspondência é escrita com BIND no índice de nomes de Issuer `issuers.geul` ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#nome-do-issuer)).
- Mesmo que o domínio expire ou mude de mãos, a correspondência permanece com o Issuer que o provou primeiro. O novo titular não pode usar esse domínio como nome de Issuer.
- O nome de domínio serve para digitar e exibir endereços. Dentro de um documento GEUL escreve-se apenas o Issuer ID.

## Documento de definição de termos

- Os termos definidos por um Issuer (ferramentas, programas, papéis, conceitos dentro da organização) ficam em **um documento por termo**. O termo é o LOCAL desse documento; o nome é ligado por [BIND](/pt/grammar/edge/bind/) e o alvo externo apontado (URI etc.) por [REFERENCE-NODE](/pt/grammar/edge/reference-node/).
- Os outros documentos apontam para o termo com `EXTERNAL-ISSUER-*` (Issuer, ID do documento, LOCAL ID). A mesma definição não se repete em cada documento. Exemplo: a ferramenta de [TRANSFORMED-BY](/pt/grammar/meta/lineage/transformed-by/).
- A faixa de IDs de documentos de definição de termos é decidida pelo Issuer. O geul.org (`0x0000`) usa `0x0001xxxx xxxxxxxx` ([Documento de especificação de Codec](/pt/grammar/codec-spec/#id-de-documento-do-issuer-geul)).
- O ID de documento `0x0000000000000000` de cada Issuer é reservado ao seu **documento de índice de definição de termos**: `<Issuer>/0x0000000000000000/`. É o lugar onde se listam os documentos de definição de termos.
- O documento de índice é **recomendado** a todos os Issuers, mas não é obrigatório. Sem índice, os documentos de definição de termos são encontrados pelo índice de nomes `documents.geul`.
- Ordem para apontar um alvo externo: (1) se houver um Reference Codec adequado, usá-lo (WIKIDATA-QID etc.); (2) se houver um documento GEUL que defina esse alvo, usá-lo (DOC-POINTER, EXTERNAL-ISSUER); (3) se não houver, defini-lo como LOCAL no próprio documento de definição de termos e apontar para ele.

## Modo de divulgação dos documentos

| Modo | Para quem | Licença | Gestão de versões | Permanência |
|---|---|---|---|---|
| Confidencial | todos os Issuers | interna do Issuer | Issuer | depende do Issuer |
| Publicação no geul.org | Issuers de 1 e 2 WORD | CC0 | geul.org | preservado pelo geul.org |
| Publicação privada | todos os Issuers | definida pelo Issuer | Issuer | depende do Issuer |

### Publicação no geul.org

- Os Issuers de 1 e 2 WORD podem registrar documentos no geul.org e publicá-los. Os documentos registrados são CC0.
  - O Issuer de 1 WORD publica após análise prévia do geul.org.
  - O Issuer de 2 WORD é publicado logo ao registrar, e os problemas são tratados depois.
- O que se pode publicar são definições de conceitos e Codecs. **Uma Reference que aponte para uma pessoa natural não pode ser publicada no geul.org.** Usa-se o modo confidencial ou a publicação privada.
  - Exceção: apontar uma pessoa natural por [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/) é permitido.
- Uma versão registrada não se altera nem se apaga, e o documento permanece mesmo que o Issuer desapareça (preservação da lei antiga). As exceções são a exclusão legal e a exclusão de ofício ([TOMBSTONE](/pt/grammar/edge/publication/)).
- O Issuer só pode marcar numa definição uma recomendação de descontinuação (deprecated). A definição desaconselhada continua a ser interpretada.
- Uma nova versão do mesmo documento pode criar, revisar e excluir definições ([Documento](/pt/grammar/document/#revisão)). **O ID de entidade e o número de formato excluídos não são reutilizados para outros alvos.** O layout wire de um número de formato não é revisado.

### Publicação privada

- O Issuer que quer publicar com uma licença diferente de CC0 serve os documentos em rede privada (domínio próprio etc.). A licença é declarada no HEAD do documento com [LICENSE](/pt/grammar/meta/policy/license/).
- A publicação privada usa os mesmos caminhos do geul.org ([Endereço de publicação e lista de versões](/pt/grammar/publishing/)).
- Gestão de versões, disponibilidade, manutenção do domínio e condições de licença são decididos pelo Issuer. O geul.org não interfere na publicação privada nem a garante.

### Confidencial

- Documentos confidenciais não são publicados. Aplica-se controle de acesso e marca-se com [ACCESS](/pt/grammar/meta/policy/access/).
- Se um documento que usa definições confidenciais for enviado para fora, quem o recebe não consegue interpretar essas Reference, Value e Edge e as pula. As definições que serão trocadas com o exterior devem ser publicadas.

### Escolha do usuário

- O usuário escolhe os documentos a usar observando a licença declarada e a probabilidade de permanência do Issuer.
- As definições de licenças excessivamente restritivas ou de Issuers de permanência incerta acabam não sendo usadas.
- Para referências que precisam ser preservadas por muito tempo, usam-se documentos publicados no geul.org.

## Assinatura

- A assinatura é obrigatória em documentos publicados. Fica no HEAD como [SIGNATURE](/pt/grammar/meta/verification/signature/). Um documento sem assinatura também é um documento GEUL válido; documentos confidenciais e internos também devem ser assinados sempre que possível.
- O alvo da assinatura é o **hash de conteúdo** do documento ([Documento](/pt/grammar/document/#hash-de-conteúdo)). Não se assina apenas o BODY.
  - O HEAD contém regras de interpretação. Se o alvo de `IMPORT-DOC` mudar, o mesmo BODY passa a apontar para outro alvo.
  - Se `LICENSE` e `PARENT` não forem assinados, a licença e o histórico podem ser falsificados.
- Um documento pode ter várias assinaturas. Como todas assinam o mesmo hash de conteúdo, acrescentar assinaturas não altera o hash de conteúdo.
- Verificação da chave de assinatura:
  - Issuers de 1, 2 e 4 WORD: a chave registrada no geul.org (publicação das chaves de verificação, abaixo).
  - Issuers de 16 WORD: o `ISSUER-KEY` do mesmo documento. O Issuer ID calculado a partir dessa chave pública deve ser igual ao do signatário.
- Quem lê reduz a confiança quando não há assinatura; e quando há assinatura mas a verificação falha, reduz ainda mais, pois é indício de adulteração ou falsificação de identidade.
- A assinatura do documento é feita pelo Issuer desse documento, e a da lista de versões é feita pelo local de publicação que atribuiu os IDs de versão ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#entidade-de-assinatura)).

## Publicação das chaves de verificação

- O geul.org publica as chaves de verificação de assinatura dos Issuers registrados (1, 2 e 4 WORD).
- A lista de chaves sai como documento publicado do Issuer GEUL (`0x0000`). É CC0 e assinada pelo geul.org.
  - Itens: Issuer, ID do algoritmo de assinatura, chave pública, instante de início da validade, instante e motivo da revogação.
- Chaves revogadas também não são apagadas. Assinaturas antigas são verificadas com a chave que era válida no momento da assinatura.
- A troca de chave é registrada assinando a nova chave com a chave antiga. Quem verifica pode confirmar a continuidade da chave sem precisar confiar no geul.org.
- O histórico de mudanças de chave é mantido em um log somente de acréscimo (como Certificate Transparency e o sumdb do Go). Se o histórico for alterado, isso fica evidente.
- Se a chave for perdida e não for possível assinar com a chave antiga, o geul.org verifica novamente a identidade e registra a nova chave. O Issuer de 2 WORD passa de novo pela prova de propriedade do domínio. Nesse caso é preciso confiar no geul.org, e o motivo é registrado no log.
- Não se aplica ao Issuer de 16 WORD. Como o Issuer ID é calculado a partir da chave pública, a verificação se faz apenas com o `ISSUER-KEY` dentro do documento.

## Importação

O IMPORT importa apenas documentos.

```
IMPORT-DOC                      DOC-POINTER(Issuer + ID do documento + ID da versão) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + ID do documento + LOCAL ID (sem IMPORT)
ISSUER-POINTER                  Issuer (o próprio Issuer)
DOC-POINTER                     Issuer + ID do documento + ID da versão (2 WORD, 0 = mais recente)
```

- O Issuer de qualquer largura e o seu documento podem ser apontados sem IMPORT, por indicação-declaração. O próprio Issuer é `ISSUER-POINTER`, o próprio documento é `DOC-POINTER` e o LOCAL de um documento é `EXTERNAL-ISSUER-*`. A indicação-declaração segue a versão mais recente; para fixar a versão, usam-se `IMPORT-DOC` (ID de versão) e `EXTERNAL-POINTER-*`.
- As Reference do corpo usam apenas IMPORT ID + ID do alvo, em vez do caminho completo (Issuer + documento + ID do alvo).
- A largura do IMPORT ID é determinada pelo comprimento em `IMPORT-DOC` e pelo Codec em `EXTERNAL-POINTER-*`. Só vale dentro desse documento ([IMPORT-DOC](/pt/grammar/meta/import/import-doc/)).
- Importar sem ID de versão segue a versão mais recente. Escrever o ID de versão fixa nessa versão. Os documentos publicados escrevem o ID de versão.

## Licença

- Os documentos publicados no geul.org e os documentos do Issuer GEUL (`0x0000`) são CC0.
- A licença dos documentos de publicação privada é decidida pelo Issuer. O GEUL não a impõe.
- Os artefatos centrais do GEUL não copiam o conteúdo de documentos de Issuers que não sejam CC0.

## Questões em aberto

- Se Issuers de 4 WORD e 16 WORD podem publicar no geul.org.
- Método de prova de propriedade do domínio (DNS TXT `_geul.<domínio>`, HTTP `.well-known`) e se vale vincular a impressão digital da chave de assinatura ao valor da prova.
- Resposta ao sequestro de domínio na recuperação de chave perdida. Se a nova chave for registrada só com nova prova de domínio, quem sequestrou o domínio pode tomar o Issuer. Examinam-se a confirmação do contato de registro, um período de carência com contestação pela chave antiga e a aplicação do resultado de disputas de domínio.
- Formato do registro do documento de índice de definição de termos (ID de documento `0`) (o Edge que lista os documentos de definição de termos).
- Valor padrão do algoritmo de assinatura (recomenda-se Ed25519).
