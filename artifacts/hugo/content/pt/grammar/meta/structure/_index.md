---
title: "Meta — Estrutura"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "A classe de estrutura do Meta (3 bits superiores `000`, `0x00`~`0x0F`) define os limites e o comprimento do documento. Abre-se com DOC-1WORD/2WORD/4WORD, encerra-se o HEAD com BODY e fecha-se com END."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A classe de estrutura do Meta (3 bits superiores `000`, Codec `0x00`~`0x0F`) define os limites e o comprimento do documento. A unidade dos dados GEUL é um documento.

```
DOC-*                  ← início do HEAD
  Meta de definição, proveniência, linhagem, verificação, política e IMPORT
  SOURCE do documento inteiro e seus QUALIFIERs
BODY                   ← início do BODY
  Reference, Value, Edge
END                    ← fecha o documento
```

- Todo documento é aberto com `DOC-1WORD/2WORD/4WORD`, que indica o comprimento total. O decodificador pode pular o documento inteiro de uma vez por esse comprimento.
- `BODY` e `END` são registros de 1 WORD sem Payload. `END` é obrigatório.
- Os documentos não se aninham. Outro documento é apontado por IMPORT.
- Se o HEAD (Meta, SOURCE do documento inteiro e seus QUALIFIERs) estiver vazio, o `BODY` é omitido. O `BODY` só pode aparecer uma vez por documento.

A estrutura completa do documento está em [Documento](/pt/grammar/document/).
