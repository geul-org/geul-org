---
title: "TOMBSTONE (0x0BAL)"
weight: 186
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION·DEPRECATION·TOMBSTONE 是记录文档版本的公布、停用建议、删除的陈述 Edge，本页同时规定用这些 Edge 书写的版本列表文档的规格（Codec 0x0B8L~0x0BAL）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION·DEPRECATION·TOMBSTONE 是记录文档版本的公布、停用建议、删除的陈述 Edge，本页同时规定用这些 Edge 书写的版本列表文档的规格（Codec 0x0B8L~0x0BAL）。

| 项目 | 值 |
|---|---|
| 名称 | `TOMBSTONE`（规格文档 BIND `TOMBSTONE`） |
| TAG ID | `0x0BAL` |
| Codec ID | `0x00000BA0` |
| 规格文档 | `0x00000000/codecs/0x00000BA0/`（DECLARE 目标 `0BA0`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 26 |
| Kind | Edge · 系列：陈述，分组：其他 |
| TAG WORD | `0000 1011 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 已公布版本的删除（墓碑）。DOC-POINTER、理由类别 |
| Hugo 侧 | `edge/publication.md`（该侧同时介绍 [PUBLICATION](0x0B8L-publication.md)、[DEPRECATION](0x0B9L-deprecation.md)） |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | 记录 | `0410` DOC-POINTER，`0420` CODEC-POINTER |  |
| 2 | `reason` | #4 | 原始值 1 WORD |  |  |

这是记录文档的公布、deprecate、删除的陈述 Edge，以及用这些 Edge 书写的版本列表文档的规格。规定[公布地址与版本列表](../publishing.md#버전-목록)中的版本列表格式。

## 码 {#코드}

| Codec | 名称 | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id、DOC-POINTER、内容哈希 |
| `0x0B9L` | DEPRECATION | Edge Id、DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id、DOC-POINTER、理由类别 |

- 这三个码内置于解码器（[第 0 层](../publishing.md#층)）。版本列表无需查询 codebook 即可解释。
- 不设子格式（Codec 专属 TAG）。原样遵守 [Edge](_index.md) 中 Payload 第一个元素是 Edge Id 的规则。

## 布局 {#레이아웃}

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
文档              DOC-POINTER Reference 记录 (Issuer, 文档 ID, 版本 ID)。Codec 的版本列表用 CODEC-POINTER
内容哈希          16 WORD   (PUBLICATION)
理由类别          1 WORD    (TOMBSTONE)
```

| 字段 | 宽度 | 说明 |
|---|---|---|
| Edge Id | LOCAL Reference 记录 | 列表内序号。从 1 开始编号并依次延续 |
| 文档 | DOC-POINTER 记录 | 所公布文档的某个版本（[DOC-POINTER](../reference/0x041L-doc-pointer.md)）。Issuer、文档 ID 与该列表所涉及的文档相同。使列表文档即使没有路径也能说明它是什么的列表。版本 ID 是该文档内的序号（[文档](../document.md)版本），不使用 `0`（最新）。Codec 的版本列表使用 [CODEC-POINTER](../reference/0x042L-codec-pointer.md)（Issuer、Codec ID、版本 ID） |
| 内容哈希 | 16 WORD | 该版本的内容哈希（SHA-256，[文档](../document.md)内容哈希） |
| 理由类别 | 1 WORD | 删除理由的类别码。码表是未决问题 |

- DOC-POINTER 之后的长度对每个码都是固定的（16、0、1 WORD）。不同则拒绝。
- 时刻不放进记录。该记录首次载入的列表文档的 `RECORDED-AT` 就是公布、deprecate、删除的时刻。

## 版本列表文档 {#버전-목록-문서}

公布处为每个文档续写一个版本列表文档：`/<Issuer>/docs/<文档 ID>/versions.geul`（Codec 为 `/<Issuer>/codecs/<Codec ID>/versions.geul`，Issuer 列表见[下文](#목록-문서의-버전-목록)）。该文档在该公布处公布的所有版本都包含在同一个列表中。

```
DOC-1WORD/2WORD/4WORD     全部长度
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value。上一个列表文档的内容哈希 (首个列表则没有)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value。发布此列表的时刻
  NEXT-LOCAL-ID           下一个要分配的 LOCAL ID (有版本时)
  SIGNATURE               公布处的签名。对象是此列表文档的内容哈希
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- HEAD Meta：[SPEC-VERSION](../meta/0x1C5L-spec-version.md)、[PARENT](../meta/0x1D1L-parent.md)、[RECORDED-AT](../meta/0x1D0L-recorded-at.md)、[NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md)、[SIGNATURE](../meta/0x1E6L-signature.md)。
- 版本列表文档中不放 `DOC-ID`（列表文档的例外，[DOC-ID](../meta/0x1C7L-doc-id.md)）。列表不是公布文档，而是附属于该文档的记录。是哪个文档的列表，由记录的 DOC-POINTER（文档 ID）说明。因此即使不通过路径（`hashes/`，转储）收到，也知道它是什么的列表。
- 记录的文档 ID 必须全部是该列表所涉及的文档。其他文档的记录予以拒绝。
- 版本列表文档不放 IMPORT，只使用第 0 层 Codec。BODY 中只放 PUBLICATION·DEPRECATION·TOMBSTONE。不放文档名称 BIND（[公布地址与版本列表](../publishing.md#문서-이름)）。
- 新列表文档把上一个列表文档的 BODY 原样放在前面，并追加记录。不修改、不删除、不改变顺序。
- 公布处对列表签名。geul.org 公布由 geul.org（GEUL Issuer）签名，私有公布由该 Issuer 签名。
- 文档 ID `0x0000000000000000` 是 Issuer 的术语定义索引文档（[Issuer 与公布](../issuer.md)）。Issuer 自身用 [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) 指向。

## 列表文档的版本列表 {#목록-문서의-버전-목록}

列表文档是 Issuer 列表 `issuers/` 一个（[公布地址与版本列表](../publishing.md#목록-문서)）。Issuer 列表也从版本 1 开始，并设有版本列表 `issuers/versions.geul`。记录用保留文档 ID 的 DOC-POINTER（`0x00000000`、`0xFFFFFFFFFFFFFFFF`、版本 ID）指向列表版本。

- 记录格式同上。因此通过 `hashes/` 收到也知道它是什么的列表。
- 列表文档自身（`<版本 ID>.geul`）也不放 `DOC-ID`。
- 文档 ID `0xFFFFFFFFFFFFFFFF` 在任何 Issuer 中都不通过 `<Issuer>/docs/<文档 ID>/` 地址接收（404）。
- 列表的 `latest.geul` 是不存储的别名。从此版本列表中找出最近的版本并给出其字节。

## 规则 {#규칙}

- PUBLICATION 的版本 ID 从 1 开始无空缺地升序。版本 ID 由公布处分配。
- 不重复公布相同的内容哈希。已有则返回该版本 ID。
- DEPRECATION·TOMBSTONE 只指向前面出现过的 PUBLICATION 的版本 ID。指向不存在的版本则拒绝。
- 版本的状态通过依次应用记录来计算。已公布 → deprecated → 已删除。已删除的版本不再公布，也不再提供。
- 最新版本是既非 deprecated 也非已删除的最高版本 ID。
- 版本 ID 到达 2 WORD 的末尾时，该文档不再公布，改用新的文档 ID 发布。

## 地址 {#주소}

```
/.well-known/geul/<Issuer>/docs/<文档 ID>/versions.geul        最新列表文档 (可变)
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul     Codec 的最新列表文档 (可变)
/.well-known/geul/issuers/versions.geul                       Issuer 列表的最新版本列表 (可变)
/.well-known/geul/<Issuer>/hashes/<内容哈希>.geul              过去的列表文档 (不可变)
```

- 可变的是最新列表地址。收到的列表用签名、`RECORDED-AT`、`PARENT` 链来验证。
- 过去的列表文档全部保留在 `<Issuer>/hashes/` 中。沿着 `PARENT` 链可以回溯任何时点的列表。

## 验证 {#검증}

- 列表文档必须带有指定公布处密钥的 `SIGNATURE`。
- 记录的文档 ID 必须与请求的文档 ID 相同。
- 锁定记录中保留的上一个列表的内容哈希必须在新列表的 `PARENT` 链中。该列表的 BODY 必须与新列表 BODY 的开头部分相同。
- 收到的文档的内容哈希必须与该版本 ID 的 PUBLICATION 所记载的值相同，文档的 `DOC-ID` 必须与请求的 Issuer、文档 ID 相同。列表文档没有 `DOC-ID`。

## 未决问题 {#열린-문제}

- 理由类别码表。
- 签名算法默认值和 `SIGNATURE` Payload 布局。
- 列表变大时迁移到 Merkle 日志（包含、一致性证明）的时机和格式。
- Issuer 级别的回滚防范。由于列表按文档各自形成链，只拿出某个文档旧列表的攻击只能靠该文档的链来阻止。

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[BIND](0x0A3L-bind.md)、[DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer 与公布](../issuer.md)、[公布地址与版本列表](../publishing.md)、[文档](../document.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000BA0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BA000000000
BODY
#1 DECLARE 0x0BA0
#2 FIELD #1 record
#9 CODEC #2 0x0410
#4 FIELD #1 0x0001
#5 BIND #1 "TOMBSTONE"
#6 BIND #2 "doc"
#8 BIND #4 "reason"
#10 CODEC #2 0x0420
```
