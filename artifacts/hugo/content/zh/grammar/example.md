---
title: "示例：Wikidata 条目"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "从头到尾阅读一个关于 Wikidata 条目 Q42（Douglas Adams）的小文档。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

从头到尾阅读一个关于 Wikidata 条目 Q42（Douglas Adams）的小文档。包含的内容如下。

- 英文名称：Douglas Adams
- Q42 是人（Q5）的实例（P31）。
- Q42 就读于 St John's College（Q691283）（P69）。开始时点（P580）是 1971 年。

文档是 Issuer `0x00000001` 的文档 `0x510000000000002A`，共 63 WORD（126 字节）。

## 全文 {#전체}

```
1C01 003F 1C51 0001 1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
1C30
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
1C40
```

## HEAD {#head}

```
1C01 003F
```

`1C01` 是 Meta（章节 14）、Codec `0x1C0L`（DOC-1WORD）、Length 2 WORD。值 `003F`（63）是整个文档的 WORD 数。解码器凭这个值预先知道文档的结尾。

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION。是本文档所遵循的规范版次。v1 是 `0001`。

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID，共 10 WORD。Payload 是一个 DOC-POINTER Reference。

| WORD | 含义 |
|---|---|
| `0418` | Reference，Codec `0x041L`（DOC-POINTER），9 WORD |
| `0000 0001` | Issuer `0x00000001`（2 WORD） |
| `5100 0000 0000 002A` | 文档 ID `0x510000000000002A` |
| `0000 0000` | 版本 `0`（自身） |

```
1C30
```

BODY。HEAD 结束，BODY 开始。

## BODY {#body}

### #1 LABEL — 英文名称 {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | 含义 |
|---|---|
| `0A4E` | Edge，Codec `0x0A4L` LABEL，Length `1110`（扩展） |
| `0010` | 扩展长度：共 16 WORD |
| `0051 0001` | Edge Id：LOCAL 1 |
| `0141 002A` | Subject：Wikidata Q42 |
| `0799` | Object：UTF8-LANGUAGE-TEXT，奇数字节（`0x079L`），10 WORD |
| `0761 656E` | 语言：BCP 47 `en` |
| `446F … 7300` | `Douglas Adams` 13 字节 + 填充 `00` |

### #2 TRIPLE — Q42 是人 {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | 含义 |
|---|---|
| `0AA9` | Edge，Codec `0x0AAL` TRIPLE，10 WORD |
| `0051 0002` | Edge Id：LOCAL 2 |
| `0191 001F` | Predicate：P31 (instance of) |
| `0141 002A` | Subject：Q42 |
| `0141 0005` | Object：Q5（人） |
| `0000` | Rank：normal |

### #3 TRIPLE — Q42 就读于 St John's College {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | 含义 |
|---|---|
| `0AAA` | Edge，TRIPLE，11 WORD |
| `0051 0003` | Edge Id：LOCAL 3 |
| `0191 0045` | Predicate：P69 (educated at) |
| `0141 002A` | Subject：Q42 |
| `0142 000A 8C53` | Object：Q691283。值超过 16 位，因此是 3 WORD 的 Reference |
| `0000` | Rank：normal |

### #4 QUALIFIER — 开始时点 1971 年 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | 含义 |
|---|---|
| `0AB9` | Edge，Codec `0x0ABL` QUALIFIER，10 WORD |
| `0051 0004` | Edge Id：LOCAL 4 |
| `0191 0244` | Property：P580 (start time) |
| `0051 0003` | Target：#3（上面的 TRIPLE） |
| `06E2 3139 3731` | Value：EDTF `1971`（精度为年，因此用 EDTF 而不是 GREGORIAN-DATE） |

#3 的含义是把 #3 自身以及所有指向 #3 的 QUALIFIER 合起来：“Q42 自 1971 年起就读于 St John's College。”

```
1C40
```

END。到此为止共 63 WORD。

## 不借助 Codec 手册来读 {#코덱북-없이-읽으면}

不了解 Codec 手册的解码器也能知道以下内容。

- 文档共 63 WORD，HEAD 中有 2 个 Meta，BODY 中有 4 个 Edge。
- 每个 Edge 的 Codec（LABEL、TRIPLE、TRIPLE、QUALIFIER）和 Edge Id（1、2、3、4）。
- 每条记录之后下一条记录的位置。

成分的角色（Predicate、Subject、Object、Rank）需要阅读各 Codec 的[规格文档](codec-spec.md)才能知道。

## 内容哈希 {#내용-해시}

本文档的内容哈希（SHA-256）如下。公布后，版本列表中会把该哈希与版本 ID 一并记录。

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
