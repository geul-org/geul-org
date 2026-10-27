---
title: "示例：Wikidata 条目"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "从头到尾阅读一个 63 WORD 的 GEUL 文档，其中包含 Wikidata Q42（Douglas Adams）的一个名称、两个命题和一个限定条件。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

从头到尾读一个关于 Wikidata 条目 Q42（Douglas Adams）的小文档。包含的内容如下。

- 英文名称：Douglas Adams
- Q42 是人（Q5）的实例（P31）。
- Q42 就读于 St John's College（Q691283）（P69）。开始时点（P580）是 1971 年。

文档是 Issuer `0x00010000` 的文档 `0x510000000000002a`，共 63 WORD（126 字节）。

## 全文

```
1880 003f 1890 0001 1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
180e
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
180f
```

## HEAD

```
1880 003f
```

`1880` 是 Meta（`11`）、Length 2 WORD、Codec `0x00`（DOC-1WORD）。值 `003f`（63）是整个文档的 WORD 数。解码器凭这个值预先知道文档的结尾。

```
1890 0001
```

Meta `0x10` SPEC-VERSION。是本文档所遵循的规范版次。v1 是 `0001`。

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID，共 10 WORD。Payload 是一个 DOC-POINTER Reference。

| WORD | 含义 |
|---|---|
| `0438` | Reference，9 WORD，Codec `0111`（DOC-POINTER），Quantifier `000` |
| `0001 0000` | Issuer `0x00010000`（2 WORD） |
| `5100 0000 0000 002a` | 文档 ID `0x510000000000002a` |
| `0000 0000` | 版本 `0`（自身） |

```
180e
```

BODY。HEAD 结束，BODY 开始。

## BODY

### #1 LABEL — 英文名称

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | 含义 |
|---|---|
| `1704` | Edge，Length `1110`（扩展），Codec `0x04` LABEL |
| `0010` | 扩展长度：共 16 WORD |
| `0088 0001` | Edge Id：LOCAL 1 |
| `00a0 002a` | Subject：Wikidata Q42 |
| `0ccb` | Object：UTF8-LANGUAGE-TEXT，10 WORD，奇数字节（`0x4B`） |
| `08c6 656e` | 语言：BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13 字节 + 填充 `00` |

### #2 TRIPLE — Q42 是人

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | 含义 |
|---|---|
| `148a` | Edge，10 WORD，Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id：LOCAL 2 |
| `00a8 001f` | Predicate：P31 (instance of) |
| `00a0 002a` | Subject：Q42 |
| `00a0 0005` | Object：Q5（人） |
| `0000` | Rank：normal |

### #3 TRIPLE — Q42 就读于 St John's College

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | 含义 |
|---|---|
| `150a` | Edge，11 WORD，TRIPLE |
| `0088 0003` | Edge Id：LOCAL 3 |
| `00a8 0045` | Predicate：P69 (educated at) |
| `00a0 002a` | Subject：Q42 |
| `0120 000a 8c53` | Object：Q691283。值超过 16 位，所以是 3 WORD Reference |
| `0000` | Rank：normal |

### #4 QUALIFIER — 开始时点 1971 年

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | 含义 |
|---|---|
| `148b` | Edge，10 WORD，Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id：LOCAL 4 |
| `00a8 0244` | Property：P580 (start time) |
| `0088 0003` | Target：#3（上面的 TRIPLE） |
| `0924 3139 3731` | Value：EDTF `1971`（精度为年，所以不是 GREGORIAN-DATE 而是 EDTF） |

#3 的含义是 #3 本身与所有指向 #3 的 QUALIFIER 的总和："Q42 自 1971 年起就读于 St John's College。"

```
180f
```

END。到这里正好是 63 WORD。

## 不用 codebook 来读

不知道 codebook 的解码器也能知道以下内容。

- 文档为 63 WORD，HEAD 中有 2 个 Meta，BODY 中有 4 个 Edge。
- 每个 Edge 的 Codec（LABEL、TRIPLE、TRIPLE、QUALIFIER）和 Edge Id（1、2、3、4）。
- 每条记录之后下一条记录的位置。

构成要素的角色（Predicate、Subject、Object、Rank）必须阅读各 Codec 的[规格文档](/zh/grammar/codec-spec/)才能知道。

## 内容哈希

本文档的内容哈希（SHA-256）如下。公布后，版本列表中会把这个哈希与版本 ID 一起记录。

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
