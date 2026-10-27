---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION·DEPRECATION·TOMBSTONE 是记录文档版本的公布·停用建议·删除的叙述 Edge，本页同时规定用这些 Edge 书写的版本列表文档的规格（Codec 0x18~0x1A）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

这是记录文档的公布·deprecate·删除的叙述 Edge，以及用这些 Edge 书写的版本列表文档的规格。规定[公布地址与版本列表](/zh/grammar/publishing/#版本列表)的版本列表格式。

## 码

| Codec | 名称 | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id、DOC-POINTER、内容哈希 |
| `0x19` | DEPRECATION | Edge Id、DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id、DOC-POINTER、原因类别 |

- 这三个码内置于解码器（[0 层](/zh/grammar/publishing/#层)）。版本列表无需查询 codebook 即可解读。
- 不设子格式（Codec 专属 TAG）。原样遵守 [Edge](/zh/grammar/edge/) 的规则：Payload 的第一个元素是 Edge Id。

## 布局

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
文档              DOC-POINTER Reference 记录 (Issuer, 文档 ID, 版本 ID)
内容哈希          16 WORD   (PUBLICATION)
原因类别          1 WORD    (TOMBSTONE)
```

| 字段 | 宽度 | 说明 |
|---|---|---|
| Edge Id | LOCAL Reference 记录 | 列表内的序号。从 1 开始依次追加 |
| 文档 | DOC-POINTER 记录 | 已公布文档的某一版本（[DOC-POINTER](/zh/grammar/reference/doc-pointer/)）。Issuer·文档 ID 与该列表所涉及的文档相同。使列表文档即使没有路径也能说明这是什么的列表。版本 ID 是该文档内的序号（[文档](/zh/grammar/document/)版本），不使用 `0`（最新） |
| 内容哈希 | 16 WORD | 该版本的内容哈希（SHA-256，[文档](/zh/grammar/document/)内容哈希） |
| 原因类别 | 1 WORD | 删除原因的类别码。码表是未决问题 |

- DOC-POINTER 之后的长度对每个码是固定的（16、0、1 WORD）。不同则拒绝。
- 记录中不放时刻。该记录首次出现的那个列表文档的 `RECORDED-AT` 就是公布·deprecate·删除的时刻。

## 版本列表文档

公布方为每个文档续写一个版本列表文档：`/<Issuer>/<文档 ID>/versions.geul`。该公布方公布的该文档的所有版本都放入一个列表。

```
DOC-1WORD/2WORD/4WORD     总长度
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value。上一个列表文档的内容哈希 (第一个列表则没有)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value。发布本列表的时刻
  NEXT-LOCAL-ID           下一个要分配的 LOCAL ID (有版本时)
  SIGNATURE               公布方的签名。对象是本列表文档的内容哈希
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- HEAD Meta：[SPEC-VERSION](/zh/grammar/meta/declaration/spec-version/)、[PARENT](/zh/grammar/meta/lineage/parent/)、[RECORDED-AT](/zh/grammar/meta/provenance/recorded-at/)、[NEXT-LOCAL-ID](/zh/grammar/meta/lineage/next-local-id/)、[SIGNATURE](/zh/grammar/meta/verification/signature/)。
- 列表文档不放 `DOC-ID`（名称不以 `0x` 开头的文档的例外，[DOC-ID](/zh/grammar/meta/declaration/doc-id/)）。列表不是公布文档，而是附属于该文档的记录。这是哪个文档的列表，由记录中的文档 ID 说明。因此即使没有路径（`h/`、转储）收到，也知道这是什么的列表。
- 记录的文档 ID 必须全是该列表所涉及的文档。拒绝其他文档的记录。
- 列表文档不放 IMPORT，只使用 0 层 Codec。不放入其他列表（没有列表的列表）。
- 新的列表文档原样保留上一个列表文档的 BODY 放在前面，再追加记录。不修改、不删除、不改顺序。
- 公布方对列表签名。geul.org 公布由 geul.org（GEUL Issuer）、私有公布由该 Issuer 签名。
- 文档 ID `0x0000000000000000` 是 Issuer 的术语定义索引文档（[Issuer 与公布](/zh/grammar/issuer/)）。Issuer 自身用 [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/) 指向。

## 规则

- PUBLICATION 的版本 ID 从 1 起无遗漏地升序。版本 ID 由公布方分配。
- 不重复公布相同的内容哈希。如果已存在，则返回该版本 ID。
- DEPRECATION·TOMBSTONE 只指向前面已出现的 PUBLICATION 的版本 ID。指向不存在的版本则拒绝。
- 版本的状态通过依次应用记录计算得出。已公布 → deprecated → 已删除。已删除的版本不再重新公布，也不再提供。
- 最新版本是既未 deprecated 也未删除的最高版本 ID。
- 版本 ID 到达 2 WORD 的末尾时，该文档不再公布，而以新的文档 ID 发布。

## 文档名称

文档的寻址名称由 Issuer 的名称索引 `/<Issuer>/documents.geul` 用 [BIND](/zh/grammar/edge/bind/) 绑定（[公布地址与版本列表](/zh/grammar/publishing/#文档名称)）。解析器只读这个索引。

列表文档中也可以放置同样的 BIND（可选）。放置时要遵守以下规则。

- Subject 是 `DOC-POINTER`（Issuer、该列表的文档 ID、版本 `0`）。名称绑定到文档而不是版本，所以版本为 `0`。
- 只绑定到前面已出现 PUBLICATION 的文档。不把名称绑定到从未公布过的文档。
- 名称遵循文档名称规则（小写 ASCII slug），且必须与名称索引中的 BIND 相同。
- 更改名称时追加新的 BIND。旧名称保持原样，仍指向同一文档。代表名称是最后一个 BIND。
- 文档内不写自己的名称。

## 地址

```
/.well-known/geul/<Issuer>/<文档 ID>/versions.geul             最新列表文档 (可变)
/.well-known/geul/h/<内容哈希>.geul                            过去的列表文档 (不可变)
```

- 可变的只有最新列表地址这一个。收到的列表用签名、`RECORDED-AT`、`PARENT` 链验证。
- 过去的列表文档全部保留在 `h/` 中。沿着 `PARENT` 链可以回溯任何时点的列表。

## 验证

- 列表文档必须有指定公布方密钥的 `SIGNATURE`。
- 记录的文档 ID 必须与请求的文档 ID 相同。
- 锁定记录中保存的上一个列表的内容哈希，必须在新列表的 `PARENT` 链中。该列表的 BODY 必须与新列表 BODY 的前部相同。
- 收到的文档的内容哈希必须与该版本 ID 的 PUBLICATION 所写的值相同，文档的 `DOC-ID` 必须与请求的 Issuer·文档 ID 相同。

## 未决问题

- 原因类别码表。
- 签名算法默认值与 `SIGNATURE` Payload 布局。
- 列表变大时，迁移到 Merkle 日志（包含·一致性证明）的时点与格式。
- 是否把列表的 BIND 与名称索引 `documents.geul` 合并为一个，以及索引的签名。
- 以 Issuer 为单位的防回滚。因为列表在每个文档上各自成链，所以只拿出某个文档过时列表的攻击，只能靠该文档的链来阻止。

## 相关页面

- [Edge](/zh/grammar/edge/)、[BIND](/zh/grammar/edge/bind/)、[DOC-POINTER](/zh/grammar/reference/doc-pointer/)
- [Issuer 与公布](/zh/grammar/issuer/)、[公布地址与版本列表](/zh/grammar/publishing/)、[文档](/zh/grammar/document/)
