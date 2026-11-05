---
title: "文档"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "GEUL 数据的单位是一个文档（DOC）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 数据的单位是一个文档（DOC）。一个文件（`.geul`，媒体类型 `application/vnd.geul`）就是一个文档。

## 结构 {#구조}

```
DOC-*            ← 打开文档 (整体长度)
  Meta …         ← HEAD: 关于文档的记录
  SOURCE …       ←   (文档整体的出处及其 QUALIFIER)
BODY             ← 结束 HEAD，打开 BODY
  Reference, Value, Edge …
END              ← 关闭文档
```

| 记录 | TAG | 含义 |
|---|---|---|
| DOC-1WORD | `1C01` + 1 WORD | 以 1 WORD 指定整体长度并打开文档 |
| DOC-2WORD | `1C12` + 2 WORD | 整体长度为 2 WORD |
| DOC-4WORD | `1C24` + 4 WORD | 整体长度为 4 WORD |
| BODY | `1C30` | 1 WORD。结束 HEAD，开始 BODY |
| END | `1C40` | 1 WORD。关闭文档 |

- DOC-* 的值是从打开记录的起始到 END 末尾的整体 WORD 数。使用能容纳该值的最窄宽度。
- END 是必需的。END 的位置与 DOC-* 的长度不符时拒绝。输入在没有 END 的情况下结束，则是被截断的文档。
- 解码器可以凭 DOC-* 的长度一次跳过整个文档。
- 没有在不知道长度的情况下打开文档的方法。无法预先知道结尾的实时数据，要切分成已知长度的单位，以多个文档发送。
- HEAD 为空时省略 BODY。没有 BODY 记录的文档全部是 BODY。BODY 只设一次。HEAD 中只要有一个记录（Meta 或 HEAD Edge），就要设置 BODY。
- 文档不嵌套。其他文档通过 [IMPORT](meta/_index.md) 或指示 Reference 来指向。

## HEAD 与 BODY {#head와-body}

- HEAD 中只放 Meta 和 **HEAD Edge** 两种。二者都是对包含它们的**文档**的陈述。
  - Meta：文档的结构·定义·出处·谱系·验证·策略·IMPORT。
  - HEAD Edge：记录文档整体来源的依据 Edge [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처)（Target `0`），以及以该 SOURCE 为 Target 的 [QUALIFIER](edge/0x0ABL-qualifier.md)（原文哈希、接收时间、原文范围等）。QUALIFIER 放在该 SOURCE 之后。
- BODY 中只放 Reference、Value、Edge。单个记录的出处用 BODY 内的依据 Edge [SOURCE](edge/0x0C0L-source.md) 表示，可信度之类的其他依据则用附在该记录上的 QUALIFIER 表示。Target 为 `0` 的 SOURCE，以及以 HEAD SOURCE 为 Target 的 QUALIFIER，不能放在 BODY 中。
- 解码器从前向后读取 HEAD 并加以区分。Meta 属于 HEAD。Target 为 `0` 的 SOURCE 属于 HEAD，并记住它的 Edge Id。以所记住的 SOURCE 为 Target 的 QUALIFIER 属于 HEAD。遇到其他记录时，若 HEAD 为空，则 BODY 被省略（从该记录起是 BODY），否则因缺少 BODY 而 invalid。
- **HEAD 与 BODY 共用一个 Edge Id 编号空间。** 在文档内唯一，与 BODY 的 Edge 一样从 [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) 获得。HEAD Edge 的 Origin 是 LOCAL 时，其定义放在 BODY 中（LOCAL 的范围是整个文档）。
- Meta 可以在 Payload 中包含 Value 记录。被包含的 Value 不是独立记录，而是该 Meta 的一部分。
- 声明（Meta 定义类）的范围是该文档。

## 基本声明 {#기본-선언}

两个声明都至多一个。哪些文档必须有，由下面的条件决定。

| Meta | 含义 | 必须有的文档 |
|---|---|---|
| [SPEC-VERSION](meta/0x1C5L-spec-version.md) | 遵循的规范版本。决定如何读取其余记录。遇到不认识的版本则拒绝或警告。v1 文档的值为 `0x0001` | 公布文档。没有时按解码器所知的版本读取 |
| [DOC-ID](meta/0x1C7L-doc-id.md) | 文档自身的标识符。要在文档外指向该文档及其中的对象，必须有 | `.well-known/geul/` 下 `docs/<文档 ID>/`·`codecs/<Codec ID>/` 的版本文档（含规格文档）。版本列表 `versions.geul` 和列表文档（`issuers/`）中不设置 |

- `SPEC-VERSION` 只含一个整数，使任何版本的解码器都能读取（v1 为 `1C51 0001`）。不依赖 Value 码。
- `DOC-ID` 是指向自身的 DOC-POINTER（Issuer、文档 ID、版本 `0`）。文档 ID 为 4 WORD。Codec 文档没有文档 ID，使用 [CODEC-POINTER](reference/0x042L-codec-pointer.md)（Issuer、Codec ID、版本 `0`）。每个 Issuer 都保留文档 ID `0x0000000000000000` 和 `0xFFFFFFFFFFFFFFFF`（[Issuer 与公布](issuer.md#용어-정의-문서)）。
- 没有 `DOC-ID` 的文档是无名文档。只能通过内容哈希指向。

## 内容哈希 {#내용-해시}

一份文档用**内容哈希**指向（与 git 的提交 ID 作用相同）。

- 是从打开记录（DOC-*）到 END 之前的 SHA-256。16 WORD。
- 验证类 Meta（签名等，章节 15 中 `C >= 5`，即 `w >= 0x1E50` 的记录）不参与计算。因此把签名放在文档里也不会产生循环。
- 计算时，DOC-* 的长度改为去掉验证记录后的长度，宽度也改为适合该长度的最窄宽度。因此附加签名前后的内容哈希相同。
- 内容哈希不记录在文档里，而是计算得出。只有在指向其他版本时才作为值写出（`PARENT` 等）。
- 文档内的 `PARENT` 也参与计算，所以内容哈希是连接整个历史的哈希链。
- 在文档之外后来附加的 Meta（单独存储库中的注释等）不改变内容哈希（与 git notes 相同）。
- 文档以二进制为正本。内容哈希和签名只按二进制计算。

## 版本 {#버전}

有名文档（有 `DOC-ID` 的文档）拥有版本。

- **版本 ID** 是在一个文档内按公布顺序从 1 开始编号的 2 WORD 整数。`0` 表示“不写版本”，按最新版本处理。
- 版本 ID 由公布方在公布时分配。版本 ID 与内容哈希的对应记录在公布方签名的版本列表中（[公布地址与版本列表](publishing.md#버전-목록)）。
- 不重复公布相同内容。若该内容哈希已存在，则返回其版本 ID。
- 2 WORD 用完后，以新的文档 ID 发布。
- v2 之后的版本在 HEAD 中写入 `PARENT`（上一版本的内容哈希）。它参与内容哈希，因此各版本由哈希链连接。最初的版本中不设置。

## 修订 {#개정}

GEUL 文档像法令一样被修订。

- **版本不可变。** 已公布的版本不修改也不删除。例外只有法定删除和依职权删除（[TOMBSTONE](edge/0x0BAL-tombstone.md)）。
- 不删除历史。修改的内容以新版本发布，不覆盖原版本（保存旧法）。修改后的版本通过 [REPLACES](meta/0x1D7L-replaces.md) 与原版本相连。
- 像 branch、HEAD、reflog 这样会变化的指针不放在文档中。在文档之外（存储库·索引）管理。
- 新版本可以新设、修订、删除定义。不承诺与之前版本兼容。同一术语的定义改变也是修订（例：民法“成年”20 岁 → 19 岁，刑法强奸罪对象“妇女” → “人”）。
- **LOCAL ID 是跨版本的同一性**（如同条文编号）。相同的 LOCAL ID 即使版本不同，也指向同一对象。
  - 新设：获得新的 LOCAL ID。ID 没有顺序含义，因此不需要“第 X 条之二”这样的插入。新编号从版本列表的 `NEXT-LOCAL-ID` 获得（auto increment）。
  - 修订：修改同一 LOCAL ID 的内容。
  - 删除：在新版本中去掉该 LOCAL ID。**已删除的 ID 不再使用。**
  - 移动·拆分·合并：获得新的 LOCAL ID，并在新记录上附加 QUALIFIER P1365（replaces，值为旧 LOCAL ID）以连接旧 ID。旧 ID 不再使用，因此指向之前版本中的那条记录。
- 从原始资料重新生成文档的工具也遵守这一规则。与上一版本相同的陈述赋予相同的 LOCAL ID，只给改变或新出现的陈述新编号。不得每次都从 1 重新编号。
- 引用要特定到版本。固定版本的引用绑定到该版本，最新（版本 `0`）引用绑定到解释时点的现行版本。处理过去事件的文档，要固定引用当时施行的版本。
- 公布与施行不同。公布时间由版本列表记录，施行期间由文档记录。
  - [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md)·[EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md)：整个版本的施行期间
  - 条文 Edge 的 QUALIFIER P580（开始）·P582（结束）：各条文施行日不同时
- **时点 T 的施行版本，是施行日在 T 以前的最高版本。** 有各条文的 P580·P582 QUALIFIER 时，以其为优先。有效期（`EFFECTIVE-UNTIL`）已过的版本不在施行中。
- 过渡规定（“依原规定”）、行为时法与对被告人有利的新法的选择等，决定适用哪个版本的规则由判定（[TOULMIN](toulmin/_index.md)）负责。施行信息是其材料。
- 解释例·判例收窄或放宽术语的解释，不是文档修订，而是判定规则。通过立法确定解释的情形（例：劳动基准法新设“1 周”的定义）是修订。
- Codec 和 Codec 编号的二进制（wire）布局不做修订。因为以 Codec 编号编码的记录在读取时不固定 codebook 版本。要改变布局，就分配新的编号。已删除的 Codec 编号不再用于其他格式。

## diff 存储 {#diff-저장}

版本始终以整个文档（快照）定义。diff 只是少量存储·传输该快照的格式。

- 只有有 `DOC-ID` 且 BODY 全部为 Edge 的文档才可以用 diff 表示。不设 `DOC-ID` 的版本列表 `versions.geul`、列表文档（`issuers/` 的版本）和无名文档不设 diff。
- diff 文档是一般的 GEUL 文档，在 HEAD 中放置 [DELTA-BASE](meta/0x1DBL-delta-base.md)（基准版本 ID）。
- 删除用 [DELTA-REMOVE](meta/0x1DCL-delta-remove.md)（要去掉的 LOCAL ID 列表），添加和修订用 BODY 的 Edge 表示。没有单独的添加·修订标记。Edge Id 在基准中则为修订，没有则为添加。
- 快照还原必须是确定性的（这样哈希才能吻合）。
  1. 还原基准版本的快照。基准也是 diff 时递归还原。
  2. HEAD 整体替换为 diff 的 HEAD 去掉 `DELTA-BASE`·`DELTA-REMOVE` 后的内容。HEAD Edge 也一并改变（不写入 `DELTA-REMOVE`）。
  3. BODY 保持基准顺序。去掉 `DELTA-REMOVE` 的 ID，diff BODY 的 Edge Id 在基准中，则在原位替换。
  4. 基准中没有的 Edge Id，按其在 diff 中出现的顺序附加到末尾。
  5. 结果的内容哈希必须与版本列表中该版本的哈希相同。不同则 invalid。
- 在 diff 中重新使用已删除的 LOCAL ID 则 invalid。被去掉的 HEAD Edge 的 Edge Id 也不再使用。
- 内容哈希、版本列表、签名都以还原后的快照为准。
