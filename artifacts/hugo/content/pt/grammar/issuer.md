---
title: "Issuer e publicação"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "O GEUL não concentra o sistema de identificação em um único lugar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

O GEUL não concentra o sistema de identificação em um único lugar. Cada Issuer define seus objetos e formatos, e os demais documentos usam as definições publicadas. As definições podem ser mantidas confidenciais, publicadas em geul.org (CC0) ou publicadas de forma privada (com a licença que o Issuer determinar). Em qual definição confiar é decisão do usuário.

O endereço de publicação, a especificação de formato, a lista de Issuers, a lista de versões e as camadas de confiança são definidos em [endereço de publicação e lista de versões](publishing.md).

## O que o Issuer define {#issuer가-정의하는-것}

| Objeto | Método |
|---|---|
| Objetos (entidades, conceitos, termos) | Declarados como LOCAL no próprio documento |
| Formato de Reference | Definido por um número de Codec de 2 WORD sob o código do Issuer |
| Formato de Value | Definido por um número de Codec de 2 WORD sob o código do Issuer |
| Formato de Edge | Definido por um número de Codec de 2 WORD sob o código do Issuer |

- As definições dos formatos de Reference, Value e Edge também são publicadas como documentos.

## Princípios {#원칙}

- Um objeto definido por um Issuer é um LOCAL de um documento publicado por esse Issuer. Outros documentos o citam diretamente com uma declaração indicativa (`EXTERNAL-ISSUER-*`) ou o importam com `IMPORT-DOC` e o apontam com `EXTERNAL-POINTER-*`. O significado de um registro [REFERENCE-ISSUER](reference/_index.md#reference-issuer) é determinado pelo documento de Codec emitido pelo Issuer.
- Para objetos que precisam ser apontados de fora do documento, emite-se um LOCAL do documento publicado. Esse documento deve ter [DOC-ID](meta/0x1C7L-doc-id.md).

## Níveis de Issuer {#issuer-등급}

| Largura | Intervalo de valores | Emissão |
|---|---|---|
| 2 WORD | `0x00000000`~`0xFFFFFFFF` | Registro em geul.org. Passa por prova de propriedade do domínio. Os números que geul.org atribui a organismos de normalização e instituições principais também têm esta largura ([tabela de atribuições de 2 WORD](#2-word-배정표)) |
| 4 WORD | `2^32`~`2^64−1` | Registro em geul.org. Sem prova de propriedade |
| 16 WORD | `2^64` ou mais | Autoemissão. Calculado a partir da chave pública |

- **O Issuer ID é um valor inteiro.** Valores iguais são o mesmo Issuer. A largura não faz parte do identificador.
- **A notação mais longa de um Issuer ID curto, com zeros à esquerda, é o mesmo Issuer** (2 → 4, 2 → 16, 4 → 16 WORD). `0x00000001` e `0x0000000000000001` são o mesmo Issuer. Por isso não se atribui `0x00000000XXXXXXXX` a um Issuer de 4 WORD, nem valores com os 12 WORD superiores iguais a 0 a um Issuer de 16 WORD.
- **A forma canônica é a menor largura.** Nos registros, escreve-se com a menor largura em que o valor cabe, e a notação com largura maior é rejeitada. Por isso, a atribuição de cada largura começa no valor seguinte ao fim do intervalo da largura imediatamente inferior. 2 WORD é a menor largura. Ao usar em um endereço de publicação, escreve-se com o número de dígitos da largura de emissão (8 dígitos para 2 WORD, 16 para 4 WORD, 64 para 16 WORD) em hexadecimal maiúsculo (um endereço em minúsculas também é procurado convertido para maiúsculas); ao ler, a notação ampliada também é aceita como o mesmo Issuer ([endereço de publicação e lista de versões](publishing.md#id-표기)).

## Tabela de atribuições de 2 WORD {#2-word-배정표}

geul.org atribui números de Issuer de 2 WORD, em ordem a partir do início, a organismos de normalização e instituições principais. Formatos que são padrões de fato ou convenções sem organismo de normalização ficam sob `ADHOC` (`adhoc.geul.org`). Os formatos próprios projetados pelo GEUL são códigos diretos. O Issuer de um organismo de normalização é um Issuer de subdomínio de geul.org. O nome do subdomínio é o nome da instituição em minúsculas (`<nome da instituição>.geul.org`, por exemplo `iso.geul.org`, `iec.geul.org`). Os domínios constam da tabela abaixo.

| Issuer | Nome | Domínio | Organismo | Formatos representativos |
|---|---|---|---|---|
| `0x00000000` | GEUL | `geul.org` | geul.org | Documentos de especificação de códigos diretos (codebook) |
| `0x00000001` | wikidata.geul.org | `wikidata.geul.org` | geul.org | Documentos de itens e propriedades do Wikidata |
| `0x00000002` | ADHOC | `adhoc.geul.org` | geul.org | Formatos por convenção sem organismo de normalização. BFLOAT16, BLAKE3, números complexos, frações, intervalos, quatérnios, vetores e tensores |
| `0x00000003` | ISO | `iso.geul.org` | International Organization for Standardization | ISO 8601, ISO 4217 (moedas), ISO 3166 (países) |
| `0x00000004` | IEC | `iec.geul.org` | International Electrotechnical Commission | IEC 80000 (notação de unidades) |
| `0x00000005` | ISO-IEC-JTC1 | `iso-iec-jtc1.geul.org` | ISO/IEC Joint Technical Committee 1 | Normas ISO/IEC de tecnologia da informação |
| `0x00000006` | ITU-T | `itu-t.geul.org` | ITU Telecommunication Standardization Sector | X.509, X.690 (codificação ASN.1) |
| `0x00000007` | IETF | `ietf.geul.org` | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4 e IPv6 |
| `0x00000008` | IANA | `iana.geul.org` | Internet Assigned Numbers Authority | Tipos de mídia, registro de subtags de idioma |
| `0x00000009` | W3C | `w3c.geul.org` | World Wide Web Consortium | Tipos de dados XML Schema, RDF |
| `0x0000000A` | WHATWG | `whatwg.geul.org` | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0000000B` | UNICODE | `unicode.geul.org` | Unicode Consortium | Codificação de caracteres, normalização, CLDR |
| `0x0000000C` | ECMA | `ecma.geul.org` | Ecma International | JSON (ECMA-404) |
| `0x0000000D` | IEEE | `ieee.geul.org` | Institute of Electrical and Electronics Engineers | Ponto flutuante e decimal IEEE 754, endereço MAC (802) |
| `0x0000000E` | KHRONOS | `khronos.geul.org` | Khronos Group | Formatos de pixel (RGBA8·BGRA8 UNORM), glTF |
| `0x0000000F` | OGC | `ogc.geul.org` | Open Geospatial Consortium | Coordenadas e caixas delimitadoras, família GeoJSON |
| `0x00000010` | ONNX | `onnx.geul.org` | ONNX (LF AI & Data Foundation) | FP8 E4M3FN·E4M3FNUZ·E5M2·E5M2FNUZ |
| `0x00000011` | OCP | `ocp.geul.org` | Open Compute Project | Formatos Microscaling (E8M0, FP4 E2M1) |
| `0x00000012` | OASIS | `oasis.geul.org` | OASIS Open | Normas de documentos e de segurança |
| `0x00000013` | BIPM | `bipm.geul.org` | Bureau International des Poids et Mesures | Unidades SI, TAI |
| `0x00000014` | IERS | `iers.geul.org` | International Earth Rotation and Reference Systems Service | Segundo intercalar, UTC−TAI |
| `0x00000015` | NIST | `nist.geul.org` | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x00000016` | GPS | `gps.geul.org` | Entidade governamental operadora do GPS | Hora GPS |
| `0x00000017` | KATS | `kats.geul.org` | Agência Coreana de Tecnologia e Padrões (국가기술표준원) | Normas KS |

- Formatos de extensão ficam sob o Issuer do organismo que os normalizou. Os números de Codec sob um Issuer são definidos por cada Issuer.
- O número de Codec é definido pelo Issuer. O GEUL não determina seu significado. Os números de Codec não se repetem dentro do Issuer, independentemente do Kind ([endereço de publicação e lista de versões](publishing.md#id-표기)).
- Se um organismo de normalização não gerencia diretamente os números de Codec do GEUL, geul.org registra suas normas por números em seu lugar. O número é registrado junto com o identificador do documento da norma.
- Um novo organismo de normalização recebe o próximo número livre.
- **Os domínios podem mudar.** A ligação entre Issuer e domínio pode mudar depois. O Issuer ID não muda. Quando a instituição passar a gerenciá-lo diretamente, troca-se pelo domínio oficial da instituição.
- **Os subdomínios de geul.org não são editores oficiais.** Um subdomínio de geul.org que usa o nome de um organismo de normalização não é o editor oficial dessa instituição. Por exemplo, `iso.geul.org` não é o editor oficial da ISO.

## Issuer de 16 WORD {#16-word-issuer}

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID do algoritmo de assinatura (2 bytes) ‖ chave pública)
```

- Os 32 bytes do resultado são escritos nos 16 WORD, a partir do byte mais significativo.
- Qualquer pessoa pode criar um sem registro. A propriedade é provada pela assinatura da chave privada correspondente.
- A chave pública e o algoritmo são declarados com [ISSUER-KEY](meta/0x1E5L-issuer-key.md) no HEAD do documento. O ID de algoritmo de assinatura `0x0001` é Ed25519, e os demais valores são Reserved.
- O prefixo `GEUL-ISSUER-v1` impede que a mesma chave gere o mesmo ID quando usada para outra finalidade (separação de uso).
- Mesmo que o algoritmo de assinatura mude (por exemplo, Ed25519 → ML-DSA), a largura do ID continua sendo 16 WORD.
- Se o resultado for menor que `2^64` (probabilidade praticamente nula), não se cria um Issuer com essa chave, pois colidiria com a regra da menor largura.

## Prova de domínio {#도메인-증명}

- A prova de propriedade do domínio de um Issuer de 2 WORD é verificada apenas no momento do registro. Depois, a gestão do domínio é responsabilidade do Issuer.
- Um domínio corresponde a um único Issuer. Um Issuer pode ter vários domínios. A correspondência é escrita com BIND na lista de Issuers `issuers/` ([endereço de publicação e lista de versões](publishing.md#issuer-목록)).
- Mesmo que o domínio expire ou mude de dono, a correspondência permanece com o Issuer que o provou primeiro. O novo dono não pode usar esse domínio como nome de Issuer.
- O nome de domínio serve para entrada e exibição em resolvedores e na CLI. Não é um endereço URL de publicação ([endereço de publicação e lista de versões](publishing.md#도메인-이름)). Dentro de um documento GEUL escreve-se apenas o Issuer ID.

## Documento de definição de termos {#용어-정의-문서}

- Os termos definidos por um Issuer (ferramentas, programas, papéis, conceitos dentro de uma organização) são mantidos em **um documento por termo**. O termo é o LOCAL desse documento, o nome é ligado por [BIND](edge/0x0A3L-bind.md), e o objeto externo apontado (URI etc.) é ligado por [REFERENCE-NODE](edge/0x0A0L-reference-node.md).
- Outros documentos apontam o termo com `EXTERNAL-ISSUER-*` (Issuer, ID do documento, LOCAL ID). A mesma definição não é repetida em cada documento. Exemplo: a ferramenta de [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md).
- O intervalo de IDs de documento para documentos de definição de termos é determinado pelo Issuer. geul.org (`0x00000000`) usa `0x0001xxxx xxxxxxxx`.
- Todo Issuer reserva os IDs de documento `0x0000000000000000` e `0xFFFFFFFFFFFFFFFF`. Os usos atuais são os dois a seguir.
- O ID de documento `0x0000000000000000` é o lugar do **documento de índice de definição de termos** daquele Issuer: `<Issuer>/docs/0x0000000000000000/`. É o lugar que lista os documentos de definição de termos.
- O ID de documento `0xFFFFFFFFFFFFFFFF` é usado na lista de Issuers `issuers/` do Issuer geul.org (`0x00000000`). Outros Issuers não usam este ID. Este ID não é obtido em nenhum Issuer pelo endereço `<Issuer>/docs/<ID do documento>/` (404) ([endereço de publicação e lista de versões](publishing.md#목록-문서)).
- O documento de índice é **recomendado** a todo Issuer. Não é obrigatório.
- Ordem para apontar um objeto externo: (1) se há um Codec de Reference adequado, usá-lo (WIKIDATA-QID etc.); (2) se há um documento GEUL que define o objeto, usá-lo (DOC-POINTER, EXTERNAL-ISSUER); (3) caso contrário, defini-lo como LOCAL no próprio documento de definição de termos e apontá-lo.

## Formas de publicação de documentos {#문서-공개-방식}

| Forma | Destino | Licença | Gestão de versões | Permanência |
|---|---|---|---|---|
| Confidencial | Todos os Issuers | Interna do Issuer | Issuer | Depende do Issuer |
| Publicação em geul.org | Issuer de 2 WORD | CC0 | geul.org | geul.org preserva |
| Publicação privada | Todos os Issuers | Definida pelo Issuer | Issuer | Depende do Issuer |

### Publicação em geul.org {#geulorg-공표}

- Um Issuer de 2 WORD pode registrar documentos em geul.org e publicá-los. Os documentos registrados são CC0. Registrado, é publicado de imediato, e os problemas são tratados a posteriori.
- As definições que podem ser publicadas são conceitos e Codecs. **Uma Reference que aponte uma pessoa física não pode ser publicada em geul.org.** Faz-se de forma confidencial ou por publicação privada.
  - Exceção: apontar uma pessoa física com [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) é permitido.
- Uma versão registrada não é alterada nem apagada, e o documento permanece mesmo que o Issuer desapareça (preservação da lei antiga). As exceções são a exclusão legal e a exclusão de ofício ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- O Issuer só pode marcar uma definição com recomendação de descontinuação (deprecated). Uma definição desaconselhada continua sendo interpretada.
- Uma nova versão do mesmo documento pode criar, revisar ou excluir definições ([documento](document.md#개정)). **IDs de entidade e números de Codec excluídos não são reutilizados para outros objetos.** O layout wire de um número de Codec não é revisado.

### Publicação privada {#사설-공표}

- Um Issuer que queira publicar com licença diferente de CC0 serve os documentos em uma rede privada (domínio próprio etc.). A licença é declarada por [LICENSE](meta/0x1DEL-license.md) no HEAD do documento.
- A publicação privada usa os mesmos caminhos de geul.org ([endereço de publicação e lista de versões](publishing.md)).
- Gestão de versões, disponibilidade, manutenção do domínio e condições de licença são definidas pelo Issuer. geul.org não interfere nem garante a publicação privada.

### Confidencial {#대외비}

- Documentos confidenciais não são publicados. Aplica-se controle de acesso e marca-se com [ACCESS](meta/0x1DFL-access.md).
- Se um documento que usa definições confidenciais é enviado para fora, o receptor não consegue interpretar essas Reference, Value e Edge, e os salta. As definições a trocar com o exterior devem ser publicadas.

### Escolha do usuário {#사용자의-선택}

- O usuário escolhe os documentos a usar observando a licença declarada e a possibilidade de permanência do Issuer.
- Definições com licenças excessivamente restritivas ou de Issuers de permanência incerta não serão usadas.
- Para referências que precisam ser preservadas por muito tempo, usam-se documentos publicados em geul.org.

## Assinatura {#서명}

- A assinatura é obrigatória em documentos publicados. Fica no HEAD como [SIGNATURE](meta/0x1E6L-signature.md). Um documento sem assinatura também é um documento GEUL válido, e os documentos confidenciais e internos também são assinados, se possível.
- O objeto da assinatura é o **hash de conteúdo** do documento ([documento](document.md#내용-해시)). Não se assina apenas o BODY.
  - O HEAD contém regras de interpretação. Se o destino de um `IMPORT-DOC` mudar, o mesmo BODY passa a apontar outro objeto.
  - Se `LICENSE` e `PARENT` não forem assinados, a licença e o histórico podem ser falsificados.
- Um documento pode ter várias assinaturas. Como todas assinam o mesmo hash de conteúdo, acrescentar assinaturas não altera o hash de conteúdo.
- Verificação da chave de assinatura:
  - Issuer de 2 e 4 WORD: a chave registrada em geul.org (chaves de verificação publicadas abaixo).
  - Issuer de 16 WORD: o `ISSUER-KEY` do mesmo documento. O Issuer ID calculado a partir dessa chave pública deve ser igual ao do assinante.
- O leitor reduz a confiança se não há assinatura e a reduz ainda mais se há assinatura mas a verificação falha, pois é evidência de adulteração ou de falsificação de identidade.
- A assinatura do documento é feita pelo Issuer do documento, e a assinatura da lista de versões, pelo publicador que atribuiu os IDs de versão ([endereço de publicação e lista de versões](publishing.md#서명-주체)).

## Publicação das chaves de verificação {#검증키-공개}

- geul.org publica as chaves de verificação de assinatura dos Issuers registrados (2 e 4 WORD).
- A lista de chaves é emitida como documento publicado do Issuer GEUL (`0x00000000`). É CC0 e assinada por geul.org.
  - Itens: Issuer, ID do algoritmo de assinatura, chave pública, instante de início da validade, instante e motivo da revogação.
- Chaves revogadas também não são apagadas. As assinaturas passadas são verificadas com a chave que era válida no momento da assinatura.
- A troca de chave é registrada assinando a nova chave com a antiga. Quem verifica pode confirmar a continuidade da chave sem confiar em geul.org.
- O registro de alterações de chave é mantido em um log somente de acréscimo (como Certificate Transparency e Go sumdb). Alterar o histórico fica evidente.
- Se a chave foi perdida e não é possível assinar com a antiga, geul.org reconfirma a identidade e registra a nova chave. O Issuer de 2 WORD passa novamente pela prova de propriedade do domínio. Neste caso é preciso confiar em geul.org, e o motivo é registrado no log.
- Não se aplica a Issuers de 16 WORD. Como o Issuer ID é calculado a partir da chave pública, verifica-se apenas com o `ISSUER-KEY` dentro do documento.

## Importação {#가져오기}

IMPORT importa apenas documentos.

```
IMPORT-DOC                      DOC-POINTER(Issuer + ID do documento + ID da versão) + IMPORT ID
                                documento de Codec: CODEC-POINTER(Issuer + Codec ID + ID da versão) + IMPORT ID
EXTERNAL-POINTER-1/2/4WORD      IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-2/4/16WORD      Issuer + ID do documento + LOCAL ID (sem IMPORT)
ISSUER-POINTER                  Issuer (o próprio Issuer)
DOC-POINTER                     Issuer + ID do documento + ID da versão (2 WORD, 0 é a mais recente)
CODEC-POINTER                   Issuer + Codec ID + ID da versão (2 WORD, 0 é a mais recente)
```

- Um Issuer de qualquer largura e seus documentos podem ser apontados por declaração indicativa sem IMPORT. O próprio Issuer é `ISSUER-POINTER`, o próprio documento é `DOC-POINTER` e o LOCAL de um documento é `EXTERNAL-ISSUER-*`. A declaração indicativa segue a versão mais recente; para fixar a versão, usam-se `IMPORT-DOC` (ID da versão) e `EXTERNAL-POINTER-*`.
- Uma Reference do corpo que aponta um objeto de um documento externo usa apenas IMPORT ID + ID do objeto, em vez do caminho completo (Issuer + documento + ID do objeto). [REFERENCE-ISSUER](reference/_index.md#reference-issuer) escreve o Issuer e o número de Codec.
- A largura do IMPORT ID é determinada pelo comprimento em `IMPORT-DOC` e pelo Codec em `EXTERNAL-POINTER-*` ([IMPORT-DOC](meta/0x1E4L-import-doc.md)).
- Importar sem ID de versão segue a versão mais recente. Com ID de versão, fica fixado nessa versão. Documentos publicados escrevem o ID da versão.

## Licença {#라이선스}

- Os documentos publicados em geul.org e os documentos do Issuer GEUL (`0x00000000`) são CC0.
- A licença dos documentos de publicação privada é definida pelo Issuer. O GEUL não a impõe.
- **Licença dos formatos de Issuer.** Apenas os códigos diretos e as publicações fornecidos por geul.org são CC0. A licença dos formatos de um Issuer é definida por esse Issuer.
- **Exibição do Issuer.** O GEUL faz o Resolve depender da exibição do Issuer. Em um documento que usa Codecs de outro Issuer, esse Issuer é sempre exibido.
- Os produtos centrais do GEUL não copiam o conteúdo de documentos de Issuers que não sejam CC0.

## Problemas em aberto {#열린-문제}

- O método de prova de propriedade do domínio (DNS TXT `_geul.<domínio>`, HTTP `.well-known`) e se o valor da prova deve incluir a impressão digital da chave de assinatura.
- Resposta ao sequestro de domínio na recuperação de chave perdida. Se a nova chave for registrada apenas com nova prova do domínio, quem sequestrou o domínio pode tomar o Issuer. Examinam-se a confirmação do contato de registro, um período de carência com objeção pela chave antiga e a aplicação do resultado da disputa de domínio.
- O formato dos registros do documento de índice de definição de termos (ID de documento `0`) (Edges que listam os documentos de definição de termos).
- O valor padrão do algoritmo de assinatura (Ed25519 recomendado).
