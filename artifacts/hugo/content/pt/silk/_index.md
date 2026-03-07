---
title: "SILK — Indice Simbolico para Conhecimento de LLM"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["SILK", "search", "SIDX", "neuro-symbolic"]
summary: "Arquitetura de busca neuro-simbolica baseada em inteiros de 64 bits. Pesquisa 100 milhoes de entidades do Wikidata em menos de um segundo sem vector DB, grafos ANN ou modelos de embedding."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Symbolic Index for LLM Knowledge** — arquitetura de busca neuro-simbolica.

Pesquisa com inteiros de 64 bits. Nao requer vector DB, grafos ANN nem modelos de embedding.

<a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">Repositorio no GitHub</a>

## Proposicao central

A busca nao era um problema dificil, mas sim um **sintoma de dados sem estrutura**.
Se uma estrutura de 64 bits for atribuida no momento da escrita, o sintoma desaparece.

```python
results = index[(index & mask) == pattern]
```

100 milhoes de entidades do Wikidata em 1.3 GB de memoria, busca em menos de um segundo.
Apenas com Python (NumPy) supera vector DBs otimizadas em C++/Rust — uma vitoria da arquitetura.

## Por que nao embeddings vetoriais

Embeddings vetoriais destroem a estrutura.

```
"Vasco da Gama foi um explorador e navegador portugues do seculo XV"
 → Um humano identifica imediatamente: portugues, navegador, seculo XV

Modelo de embedding:
 [0.234, -0.891, 0.445, ..., 0.112] (384 dimensoes float)
 → Estrutura destruida. Nao se pode ler se e person ou location.

Para recuperar a estrutura destruida:
 Grafos ANN (HNSW, IVF-PQ), cross-encoders, re-rankers, filtros de metadados...
```

SILK preserva a estrutura.

```
SIDX: [Human / exploration / europe / early_modern]
 → A estrutura vive nos bits. Pode ser lida.
 → Nao ha nada para recuperar. Nunca foi destruida.
```

A chave e a inversao da ordem.

```
Convencional: primeiro escrever → estruturar depois (indexacao)
SILK:         estruturar ao escrever → a busca e gratuita
```

## Layout de bits SIDX

SIDX segue a especificacao Entity Node da [gramatica GEUL](/pt/grammar/).

```
[prefix 7 | mode 3 | entity_type 6 | attrs 48]
 MSB(63)                                  LSB(0)
```

| Campo | Bits | Tamanho | Descricao |
|-------|------|---------|-----------|
| prefix | 63-57 | 7 | Cabecalho de protocolo GEUL (`0001001` fixo, ignorado na busca) |
| mode | 56-54 | 3 | Modo de quantificacao/numero (entidade registrada=0, definido, universal, existencial, etc. 8 tipos) |
| entity_type | 53-48 | 6 | 64 tipos de nivel superior (Human=0 ~ Election=62, nao classificado=63) |
| attrs | 47-0 | 48 | Codificacao de atributos por tipo (definida por codebook) |

Alvo de busca: entity_type 6 bits + attrs 48 bits = **54 bits**.
O QID nao esta incluido no SIDX; e armazenado em um array separado.

### attrs 48 bits — esquema por tipo

```
Human(0):       subclass 5 | occupation 6 | country 8 | era 4 | decade 4 | gender 2 | notability 3 | ...
Star(12):       constellation 7 | spectral_type 4 | luminosity 3 | magnitude 4 | ra_zone 4 | dec_zone 4 | ...
Settlement(28): country 8 | admin_level 4 | admin_code 8 | lat_zone 4 | lon_zone 4 | population 4 | ...
Organization(44): country 8 | org_type 4 | legal_form 6 | industry 8 | era 4 | size 4 | ...
Film(51):       country 8 | year 7 | genre 6 | language 8 | color 2 | duration 4 | ...
```

Atualmente, os layouts de bits de atributos estao definidos para 5 tipos. Os demais codificam apenas entity_type.

## Arquitetura

SILK possui dois pipelines: **codificacao** (ao escrever) e **busca** (ao consultar).
Ambos seguem o mesmo principio: o simbolico captura a estrutura, o LLM processa o significado.

```
Pipeline de codificacao (ao escrever)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  Rotulacao   │──►│  Validacao   │──►│ Codificacao  │
│  LLM         │   │  VALID       │   │ por codebook │
│  Doc → JSON  │   │ Valores      │   │ JSON → SIDX  │
│ (classif.    │   │ validos do   │   │ (montagem    │
│  semantica)  │   │ codebook     │   │  de bits)    │
│              │   │ Alucinacao   │   │              │
│              │   │ → descarte   │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
  LLM rotula       Codigo valida     Codificacao por codebook
```

```
Pipeline de busca (ao consultar)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Interpretac. │──►│ Filtro bit   │──►│  Julgamento  │
│ da consulta  │   │ AND          │   │  LLM         │
│ Lookup no    │   │ NumPy SIMD   │   │ Apenas poucos│
│ codebook     │   │ 100M → umas  │   │ candidatos   │
│ + assist.LLM │   │ dezenas      │   │ → resposta   │
└──────────────┘   └──────────────┘   └──────────────┘
  Extrac. semantica   Filtragem ampla  Julgamento preciso
```

Estrategia central: **filtrar amplamente sem perder nada com bit AND do SIDX**, depois **o LLM julga apenas os poucos candidatos**.

```
Cada um faz o que faz melhor:
 Humano: projetar estrutura (codebook)
 LLM:    classificacao semantica (rotulacao) + julgamento semantico (busca)
 Codigo: validacao de regras (VALID) + montagem de bits
 CPU:    comparacao massiva (NumPy SIMD)
```

### Codificacao: rotulacao LLM → validacao VALID

O LLM le o documento e o rotula como JSON. VALID realiza uma verificacao mecanica baseada no codebook.
Valores fora do codebook, violacoes de consistencia entre tipos e violacoes de restricoes **fisicamente nao podem entrar no indice**.

```
Rotulacao LLM: {"type": "Human", "occupation": "exploration", "country": "portugal"}
VALID:         occupation="exploration" ∈ codebook? ✓  country="portugal" ∈ codebook? ✓
               Human com campo constellation? ✗ Descartado
Codificacao:   codebook "exploration"→6 bits, "portugal"→8 bits → montagem de bits → SIDX uint64
```

O LLM pode alucinar. Mas como VALID atua como guardiao, a possibilidade de contaminacao do indice e 0.
Apenas o JSON que passa pelo VALID e codificado como inteiro SIDX de 64 bits baseado no codebook.

### Busca: filtragem ampla, o LLM refina

```
1. Extracao semantica       Lookup no codebook 80% / assistencia LLM 20%
2. Montagem de mascara      Deterministico — algoritmo
3. Bit AND com NumPy        Deterministico — varredura completa de 100M em 20ms
4. Julgamento final LLM     Apenas poucos candidatos — julgamento semantico preciso
```

### 80% das buscas sao consultas estruturais

```
"Vasco da Gama"     → Q7318 exact match. Bit AND. Fim.
"noticias Samsung"  → org/company + doc_meta/news. Bit AND. Fim.
"cimeira Biden-Xi"  → Q6279 ∩ Q15031 ∩ meeting. Intersecao. Fim.
```

```
Consulta estrutural (80%): completada com bit AND do SILK. Sem LLM.
Consulta semantica  (15%): SILK reduz candidatos → LLM julga 5-10 itens.
Consulta generativa  (5%): SILK localiza documentos → LLM gera.
```

## Multi-SIDX

Um unico documento/evento pode ter multiplos SIDX.

```
Noticia "Reuniao de executivos da Samsung, NVIDIA e Hyundai":

SIDX[0]: [Human / business / east_asia ]  Lee Jae-yong
SIDX[1]: [Org   / company / east_asia ]  Samsung Electronics
SIDX[2]: [Human / business / n_america]  Jensen Huang
SIDX[3]: [Org   / company / n_america]  NVIDIA
SIDX[4]: [Human / business / east_asia ]  Chung Eui-sun
SIDX[5]: [Org   / company / east_asia ]  Hyundai Motor
SIDX[6]: [Event / meeting / east_asia ]  Reuniao
```

Todos sao o mesmo SIDX de 64 bits. Mesmo indice. Mesma busca por bit AND.
O campo entity_type distingue entidades (Human, Org) de eventos (Event).

## Estrutura do indice

```python
sidx_array = np.array([...], dtype=np.uint64)  # 108.8M × 8B = 870MB
qid_array  = np.array([...], dtype=np.uint32)  # 108.8M × 4B = 435MB
# Total ~1.3GB em memoria
```

```
Construcao do indice:
 Elasticsearch: tokenizacao → analise → indice invertido → merge de segmentos
 Pinecone:      embedding → grafo HNSW → clustering
 SILK:          sort
```

Sem estrutura de dados. Um unico array ordenado.

## Comparacao com vector DB

|  | SILK | Vector DB |
|------|------|-----------|
| Tamanho do indice (1B registros) | 12TB | 1.5PB (125x) |
| Construcao do indice | sort | HNSW dias |
| Arranque a frio | Imediato ao abrir arquivo | Horas construindo grafo |
| Varredura particionada | Possivel (resultado identico) | Impossivel (grafo quebrado) |
| Condicoes compostas | Intersecao (exata) | Comprimido em 1 vetor (aproximado) |
| Resultado | Exato (operacao de conjuntos) | Aproximado (ranking por similaridade) |
| Auditoria | JSON (caixa branca) | Impossivel (caixa preta) |

```
Bit AND e independente de ordem, sem estado, acumulavel.
Vector DB: o grafo inteiro deve estar em memoria. Particionar = destruir.
SILK:      funciona onde se cortar. Particionar = apenas mais lento. Mesmo resultado.
```

## Pipeline de auditoria

Embeddings vetoriais sao caixa preta: nao podem ser auditados. SIDX e JSON: pode ser auditado.

```
Fase 1 — Rotulacao com LLM pequeno     Llama 8B / GPT-4o-mini. Precisao 85-90%.
Fase 2 — Verificacao mecanica VALID     Valores validos, consistencia, restricoes. Custo $0.
Fase 3 — Auditoria com LLM grande      Apenas confidence=low. Precisao 99%+.

VALID como guardiao: alucinacoes fora dos valores validos do codebook fisicamente nao entram no indice.
```

## Licenca

MIT — <a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">GitHub</a>
