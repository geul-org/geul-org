---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta 是关于文档而非关于世界的记录。分为结构·定义·出处·谱系·验证·策略·IMPORT 七个类，放在文档的 HEAD 中。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 不是关于世界的内容，而是关于文档的记录。除文档结构记录（DOC·BODY·END）外，其余都放在文档的 HEAD 中。HEAD 中除 Meta 外，还可以放整个文档的依据 Edge [SOURCE](/zh/grammar/edge/source/#整个文档的来源) 及其 QUALIFIER。

## 布局

```
TAG WORD          0001 1LLL LCCC CCCC
[Length 扩展 TAG]
Payload           原始值，或内置 Value·Reference 记录
```

- Meta 没有 Issuer 格式。Meta 是所有 Issuer 共同遵循的通用规范，只由 GEUL 定义。
- `LLLL` 是包含 TAG WORD 在内的总 WORD 数 − 1。表中没有的 Codec 为保留。

## Payload 格式

| 格式 | 何时使用 | 例 |
|---|---|---|
| 原始值 | 格式唯一确定时。不依赖其他记录 Codec | `DOC-*` 长度、`SPEC-VERSION`、`ISSUER-KEY` |
| 内置 Value | 需要在多种格式中选择时。由 Value TAG 指明格式 | `PROFILE`、`EFFECTIVE-*`、时刻、内容哈希 |
| 内置 Reference | 指向人·组织·工具·文档等目标时 | `DOC-ID`、`AUTHOR`、`CO-AUTHOR`、`RECORDED-BY`、`SIGNED-OFF`、`SIGNATURE` 的签名者 |
| 无 | 1 WORD 标记 | `BODY`、`END` |

- 内置记录不是独立记录，而是属于该 Meta。各自靠 Length 找到边界，读完最后一条记录的位置必须与 Meta 的末尾恰好吻合。
- 一个文档中只能放一个的 Meta 与可以放多个的 Meta，由各 Codec 文档中的"数量"规定。

## 类

Codec 的高 3 位是类。

| 高 3 位 | 类 | 直接码 | 涉及内容 |
|---|---|---|---|
| `000` | 结构 | `0x00`~`0x0F` | 文档的边界与长度 |
| `001` | 定义 | `0x10`~`0x1F` | 解读声明 |
| `010` | 出处 | `0x20`~`0x2F` | 谁、何时、在哪里 |
| `011` | 谱系 | `0x30`~`0x3F` | 从什么、如何而来 |
| `100` | 验证 | `0x40`~`0x4F` | 是否可信 |
| `101` | 策略 | `0x50`~`0x5F` | 如何处理 |
| `110` | IMPORT | `0x60`~`0x6F` | 导入外部文档 |
| `111` | 保留 | `0x70`~`0x7F` | |

- **解读所需的 Meta**：结构、定义、IMPORT。删掉它们就无法读取记录，或解读会改变。所有解码器都必须处理。这些 Codec 属于 **GEUL 核心 codebook**。
- **不改变解读的 Meta**：出处、谱系、验证、策略。删掉后叙述内容不变，只是丢失信任判断与处理方式的素材。
- 依据不用 Meta，而用依据 Edge [SOURCE](/zh/grammar/edge/source/) 与 QUALIFIER 来写。单条记录的依据放在 BODY 中，整个文档的来源放在 HEAD 中 Target 为 `0` 的 SOURCE 里（[文档](/zh/grammar/document/#head-与-body)）。

## 结构

合集文档：[Meta — 结构](/zh/grammar/meta/structure/)

| Codec | 名称 | 含义 |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/zh/grammar/meta/structure/doc/) | 指定总长度来开启文档 |
| `0x0E` | [BODY](/zh/grammar/meta/structure/body/) | 结束 HEAD，开启 BODY |
| `0x0F` | [END](/zh/grammar/meta/structure/end/) | 关闭文档 |

详细规则见[文档](/zh/grammar/document/)。

## 定义

合集文档：[Meta — 定义](/zh/grammar/meta/declaration/)

| Codec | 名称 | 含义 |
|---|---|---|
| `0x10` | [SPEC-VERSION](/zh/grammar/meta/declaration/spec-version/) | 所遵循的规范版次。一个整数 |
| `0x11` | [PROFILE](/zh/grammar/meta/declaration/profile/) | 适用的 Profile |
| `0x12` | [DOC-ID](/zh/grammar/meta/declaration/doc-id/) | 本文档的标识符。指向自身的 DOC-POINTER（版本 0） |
| `0x13` | [EFFECTIVE-FROM](/zh/grammar/meta/declaration/effective-from/) | 本版本的施行日。没有则为公布时刻 |
| `0x14` | [EFFECTIVE-UNTIL](/zh/grammar/meta/declaration/effective-until/) | 本版本有效期的终点（有期限法规）。没有则持续到下一版本施行 |
| `0x16` | [DEFAULT-LANGUAGE](/zh/grammar/meta/declaration/default-language/) | 默认语言 |

- 文档的寻址名称不作为 Meta 放置。由 Issuer 的名称索引 `documents.geul` 以 BIND 附加（[公布地址与版本列表](/zh/grammar/publishing/#文档名称)）。人可读的标题以 BODY 中的 LABEL 附加。

## 出处

合集文档：[Meta — 出处](/zh/grammar/meta/provenance/)

| Codec | 名称 | 含义 |
|---|---|---|
| `0x20` | [AUTHOR](/zh/grammar/meta/provenance/author/) | 作者（Reference） |
| `0x21` | [CO-AUTHOR](/zh/grammar/meta/provenance/co-author/) | 共同作者 |
| `0x22` | [CREATED-AT](/zh/grammar/meta/provenance/created-at/) | 创作时刻 |
| `0x23` | [MODIFIED-AT](/zh/grammar/meta/provenance/modified-at/) | 修改时刻 |
| `0x24` | [RECORDED-BY](/zh/grammar/meta/provenance/recorded-by/) | 记录主体 |
| `0x25` | [RECORDED-AT](/zh/grammar/meta/provenance/recorded-at/) | 记录时刻 |
| `0x26`~`0x2F` | Reserved | |

- 来源资料不用 Meta，而用 HEAD 中的依据 Edge [SOURCE](/zh/grammar/edge/source/#整个文档的来源)（Target `0`）来写，原文范围·获取时刻·原文哈希用附在该 SOURCE 上的 QUALIFIER 来写。

## 谱系

合集文档：[Meta — 谱系](/zh/grammar/meta/lineage/)

谱系遵循 git 的提交模型。相当于提交的单位是文档。

| Codec | 名称 | 含义 |
|---|---|---|
| `0x30` | [PARENT](/zh/grammar/meta/lineage/parent/) | 上一版本的内容哈希。有多个则为合并 |
| `0x31` | [DERIVED-FROM](/zh/grammar/meta/lineage/derived-from/) | 派生自其他谱系的资料 |
| `0x32` | [GENERATED-BY](/zh/grammar/meta/lineage/generated-by/) | 生成主体（人、模型、规则引擎） |
| `0x33` | [TRANSFORMED-BY](/zh/grammar/meta/lineage/transformed-by/) | 转换工具及其源码版本（提交摘要） |
| `0x34` | [CHERRY-PICKED-FROM](/zh/grammar/meta/lineage/cherry-picked-from/) | 所挑选变更的原版本 |
| `0x35` | [REVERTS](/zh/grammar/meta/lineage/reverts/) | 被撤销的目标版本 |
| `0x36` | [REPLACES](/zh/grammar/meta/lineage/replaces/) | 被改写的目标版本。不删除原版本 |
| `0x37` | [SQUASHED-FROM](/zh/grammar/meta/lineage/squashed-from/) | 合并为一个的原版本们 |
| `0x38` | [MESSAGE](/zh/grammar/meta/lineage/message/) | 变更原因。每种语言一条 |
| `0x39` | [TAG](/zh/grammar/meta/lineage/tag/) | 附在版本上的不可变名称 |
| `0x3A` | [DELTA-BASE](/zh/grammar/meta/lineage/delta-base/) | 该文件是相对基准版本的 diff |
| `0x3B` | [DELTA-REMOVE](/zh/grammar/meta/lineage/delta-remove/) | 要从 diff 中去除的 LOCAL ID 列表 |
| `0x3C` | [NEXT-LOCAL-ID](/zh/grammar/meta/lineage/next-local-id/) | 下一个要分配的 LOCAL ID。放在版本列表文档中 |

- 历史不删除。修改的内容以新版本发布。
- 像 branch 这样会变化的指针不放在文档中，由仓库和索引管理。

## 验证

合集文档：[Meta — 验证](/zh/grammar/meta/verification/)

| Codec | 名称 | 含义 |
|---|---|---|
| `0x40` | [ISSUER-KEY](/zh/grammar/meta/verification/issuer-key/) | 自行颁发的 Issuer 的签名算法与公钥 |
| `0x41` | [SIGNATURE](/zh/grammar/meta/verification/signature/) | 对内容哈希的签名。算法、签名者、签名 |
| `0x42` | [SIGNED-OFF](/zh/grammar/meta/verification/signed-off/) | 贡献权利确认 |
| `0x43` | [CONFIDENCE](/zh/grammar/meta/verification/confidence/) | 可信度 |
| `0x44` | [VERDICT](/zh/grammar/meta/verification/verdict/) | 整个文档的判定结果（Pass、Review、Fail） |

- 验证类不参与内容哈希计算。因此即使把签名放进文档，或追加多个签名，内容哈希也不会改变。

## 策略

合集文档：[Meta — 策略](/zh/grammar/meta/policy/)

| Codec | 名称 | 含义 |
|---|---|---|
| `0x50` | [LICENSE](/zh/grammar/meta/policy/license/) | 许可证 |
| `0x51` | [ACCESS](/zh/grammar/meta/policy/access/) | 公开范围 |
| `0x52` | [PRIVACY](/zh/grammar/meta/policy/privacy/) | 个人信息等级 |
| `0x53` | [RETENTION](/zh/grammar/meta/policy/retention/) | 保存期限 |
| `0x54` | [CONSENT](/zh/grammar/meta/policy/consent/) | 同意范围与依据 |
| `0x55` | [USAGE](/zh/grammar/meta/policy/usage/) | 使用限制 |

- 策略不改变解读，只规定处理方式。

## IMPORT

合集文档：[Meta — IMPORT](/zh/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length 扩展 TAG]
文档              DOC-POINTER 记录 (Issuer, 文档 ID, 版本 ID)
IMPORT ID         其余部分。最短宽度的整数
```

- 只使用 [IMPORT-DOC](/zh/grammar/meta/import/import-doc/)（`0x60`）一个。IMPORT 只导入文档。被导入文档中的目标，在 BODY 中用 `EXTERNAL-POINTER-*`（IMPORT ID、LOCAL ID）指向。
- 写明版本 ID 则绑定到该版本，为 `0` 则绑定到解读时刻的最新版本。公布的文档要写明版本。
- 同一文档中不要两次分配相同的 IMPORT ID。
- 不导入被导入文档的 HEAD。该文档的目标按该文档自身的声明解读。

例：以 IMPORT ID 1 导入 Issuer `0x0001` 的文档 `0x0000000000000002` 的最新版本。

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
