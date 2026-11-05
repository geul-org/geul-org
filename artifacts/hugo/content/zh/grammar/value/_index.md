---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value 是承载值本身的记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value 是承载值本身的记录。由 Codec 决定 Payload 的解释。

## 布局 {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      章节 3·4 (0x060L~0x09FL)
[Length 扩展 TAG]
[Codec 扩展 TAG]  Issuer 格式时
Payload
```

- `LLLL` 是包含 TAG WORD 在内的总 WORD 数 − 1。1~14 WORD 为直接长度，15 WORD 以上为扩展长度。
- Issuer 格式时，在 Codec 扩展 TAG 中放入 Issuer（宽度由 Codec 决定，2/4/16 WORD）和 Codec 编号 2 WORD。Codec 编号由 Issuer 决定。
- 解码器即使不了解格式，也能读到 Kind、Length、Issuer、Codec 编号。

## 系列 {#계열}

Value 编号不表示系列。直接码不用 bit 表示系列，Issuer 格式也没有系列规则。系列是主题分组。

| 系列 | 直接码 |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- 向量、张量、复数、分数、区间等数值属于 NUMERIC。例外是 BIT-VECTOR 属于 BINARY。语言码属于 TEXT。
- Issuer 格式记录带有 Codec 扩展 TAG（Issuer 与 Codec 编号）。Payload 较长（总计 15 WORD 以上）时使用 Length 扩展 TAG。

## 直接码 {#직접-코드}

| Codec | 名称 | 系列 | 说明 |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false 或 true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | 最小 WORD 补码整数 |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | 最小 WORD 无符号整数 |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | 地球（WGS 84）纬度·经度与不确定度（单位 Reference） |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | 天体 Reference 与纬度·经度、不确定度（单位 Reference） |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | 数值量（整数·BINARY-FLOAT·十进制数·分数）、单位 Reference、下限·上限 |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | 保留写法的分数（分子·分母记录，不约分） |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`，有符号系数 |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`，无符号系数 |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | 自 1970-01-01 起的天数（格里高利历） |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | 自午夜起的纳秒 |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | 自 Unix epoch 起的秒 |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | 经过时间（秒） |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | ISO 8601-2 扩展日期字符串（年·月精度、不确定、区间） |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | GEDCOM 7 日期字符串（儒略历等其他历法） |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | 无语言标注的 UTF-8 字符串 |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | RFC 3986 URI |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | BCP 47 语言标签 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | 带语言的文本 |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | 1 WORD 压缩语言码 |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | RFC 9562 UUID |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | SHA-256 结果 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | SHA-1 结果（git 对象 ID 之类的标识用途） |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | 含义·格式不明的字节序列。偶数·奇数字节 |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | bit-count 之后按 MSB-first 存储的 N bit |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | 经过时间（纳秒） |

- 以奇偶配对的代码是变长字节序列。偶数代码的字节数为偶数，奇数代码的字节数为奇数（[记录与 TAG WORD](../record.md)）。
- 直接码在 `0x060L~0x081L` 中没有 Reserved。`0x082L~0x09CL` 为 Reserved，`0x09DL~0x09FL` 是 [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md)。

## Issuer 格式 {#issuer-형식}

直接码中没有的格式，放在制定该格式的机构的 Issuer 之下，以 Codec 编号表示。没有制定机构的惯例格式放在 ADHOC（`0x00000002`）之下。GEUL 特有的格式（OPAQUE-BYTES、BIT-VECTOR、DURATION-NANOSECONDS）是直接码。

| Issuer | 格式示例 |
|---|---|
| ADHOC `0x00000002` | BFLOAT16、整数·实数向量、张量、复数、分数、区间、四元数、BLAKE3 |
| IETF `0x00000007` | 相对 URI、CRC32C、IPv4·IPv6 地址 |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128、POSIX 纳秒时间戳、MAC 地址 |
| KHRONOS `0x0000000E` | RGBA8·BGRA8 像素 |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | TAI 时间戳 |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | GPS 时间戳 |

- 不了解格式的解码器可以读到 Issuer 和 Codec 编号，并按 Length 跳过。
- Codec 文档放在该 Issuer 的 `codecs/` 之下，以记录的 Codec 编号命名。例：IETF CRC32C 位于 `0x00000007/codecs/0x0000C000/`（[公布地址与版本列表](../publishing.md)）。
- 图像、视频等大型值，建议不直接放入，而用 URI 和 SHA-256 引用。
- 字节序列中的作品遵循其原有许可证。出处与许可证以 Meta 记录。

## 格式分组 {#형식-묶음}

各分组的说明如下。各格式的布局、解释、有效性、示例见各格式文档。

| 分组 | 系列 | 格式 |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL、整数、浮点数、坐标、QUANTITY、FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL、UNSIGNED-DECIMAL、IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | 日期、时刻、时间戳、经过时间、EDTF、GEDCOM 日期 |
| [text](#text) | TEXT | UTF-8 文本、带语言的文本、URI、语言码 |
| [binary](#binary) | BINARY | UUID、摘要、CRC、网络地址、不明字节序列、位向量 |
| [vector](#vector) | NUMERIC | 整数·实数稠密向量、点·边界框、RGBA·BGRA 像素 |
| [tensor](#tensor) | NUMERIC | 附带格式·rank·shape 的 dense·packed 张量 |
| [etc](#etc) | NUMERIC | 复数、分数、闭区间、四元数 |

- vector、tensor、etc 分组都是 NUMERIC 系列的 Issuer 格式（ADHOC、KHRONOS）。

### numeric {#numeric}

NUMERIC 系列的基本数值格式。放在直接码 `0x060L~0x067L`。

- 有 BOOL、有符号·无符号整数、IEEE 754 binary 浮点数、地球（WGS 84）·天体坐标、将量·单位·边界合在一起的 QUANTITY，以及保持原文写法的分数 FRACTION。
- 整数以能容纳其值的最小 WORD 书写。
- 小型标量 Issuer 格式（BFLOAT16、FP8、FP4）只分配了 Codec 编号，没有详细规格（[Value](#열린-문제) 未决问题）。
- 向量、张量、复数、既约分数（RATIONAL-I64）、区间也属于 NUMERIC 系列，但因是 Issuer 格式，所以放在 [vector](#vector)、[tensor](#tensor)、[etc](#etc) 分组。

### decimal {#decimal}

DECIMAL 系列是精确的十进制数格式。放在直接码 `0x068L~0x069L`。

- 直接码 SIGNED-DECIMAL·UNSIGNED-DECIMAL 以 `C × 10^E` 书写，原样承载原始写法的位数。`1.20`（`C=120, E=−2`）与 `1.2`（`C=12, E=−1`）是不同的记录。值相等性与 quantum 的保存是 [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제) 的未决问题。
- IEEE 754 decimal32/64/128 的 DPD·BID 编码是 IEEE Issuer（`0x0000000D`）格式。

### time {#time}

TIME 系列是日期与时刻格式。放在直接码 `0x06AL~0x071L` 和 `0x081L`（DURATION-NANOSECONDS）。

| 精度 | 格式 |
|---|---|
| 日期（格里高利历） | GREGORIAN-DATE |
| 年·月、不确定、区间 | EDTF |
| 其他历法的原始写法（儒略历等） | GEDCOM-DATE |
| 时刻 | POSIX·TAI·GPS 时间戳 |
| 经过时间 | DURATION-SECONDS、DURATION-NANOSECONDS |

- 能用 GREGORIAN-DATE 书写的日期，不用 EDTF 书写。
- 纳秒时间戳和 TAI·GPS 格式是各标准机构 Issuer（IEEE、BIPM、GPS）之下的格式。

### text {#text}

TEXT 系列是文本与字符串标识符格式。放在直接码 `0x072L~0x07AL`。

- 无语言的字符串是 UTF8-TEXT，名称·标题·句子等有语言的文本是 UTF8-LANGUAGE-TEXT。
- 语言码（LANGUAGE-SHORT-CODE、LANGUAGE-BCP47-CODE）也属于 TEXT 系列。
- 变长字节序列用偶数·奇数 Codec 对表示。最低位为 `1` 表示字节数为奇数，最后一个 WORD 的低位字节是 `0x00` 填充（[记录与 TAG WORD](../record.md)）。

### binary {#binary}

BINARY 系列是字节序列格式。放在直接码 `0x07BL~0x080L`。

- UUID、SHA-256、SHA-1、不明字节序列（OPAQUE-BYTES）、位向量（BIT-VECTOR）是直接码。其余摘要、CRC32C、IPv4·IPv6·MAC 地址是 Issuer 格式。
- 定长值（UUID、摘要、地址）大小已定，所以不设奇偶对。
- 图像、视频等公开媒体，作为 IANA Issuer（`0x00000008`）的格式放置。Codec 编号以奇偶对分配，Payload 是字节序列。Length 上限为 2^32−1 WORD。大型值建议不直接放入，而用 URI 和 SHA-256 引用。
- 字节序列中的作品遵循其原有许可证。出处与许可证以 Meta 记录。

### vector {#vector}

向量格式是 NUMERIC 系列的 Issuer 格式。整数·实数稠密向量与点·边界框放在 ADHOC（`0x00000002`）的 Codec 编号 `0x00000500`~`0x0000050C`，像素格式放在 KHRONOS（`0x0000000E`）之下。

- 稠密向量的元素按 big-endian 连续存储。
- 因为是 Issuer 格式，Codec 扩展 TAG 带有 Issuer 2 WORD 和 Codec 编号 2 WORD。

### tensor {#tensor}

张量格式是 NUMERIC 系列的 Issuer 格式。放在 ADHOC（`0x00000002`）的 Codec 编号 `0x00000600`~`0x00000601`。

- DESCRIBED-DENSE-TENSOR 承载元素格式·rank·shape 与 C-contiguous dense payload。
- DESCRIBED-PACKED-TENSOR 承载 packed 格式·rank·shape 与 octet 内 low-bit-first 的 packed payload。

### etc {#etc}

其他数值格式是 NUMERIC 系列的 Issuer 格式。放在 ADHOC（`0x00000002`）的 Codec 编号 `0x00000700`~`0x00000704`。

- 有复数（COMPLEX64、COMPLEX128）、规范化分数（RATIONAL-I64）、binary64 闭区间、binary32 四元数。

## 文本 {#텍스트}

有语言的文本与无语言的文本是不同的值。"Paris"（字符串）与 "Paris"（法语）并不相同。

| 格式 | 使用场合 |
|---|---|
| UTF8-TEXT | 标识符、代码、文件名、外部 ID 等无语言的字符串 |
| UTF8-LANGUAGE-TEXT | 名称、标题、句子等有语言的文本 |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = 文本为奇数字节)
[Length 扩展 TAG]
语言              LANGUAGE-SHORT-CODE 或 LANGUAGE-BCP47-CODE 记录
文本              UTF-8 字节 (奇数时最后为 0x00)
```

- 文本是 well-formed UTF-8，按原文保存。规范化由比较、索引的一方负责。
- 多种语言通用的名称，语言写作 `mul`，语言未定写作 `und`。无语言内容的字符串是 UTF8-TEXT。

例：`"Douglas Adams"@en`（13 字节，奇数）

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   语言 en    D o  u g  l a  s ␠  A d  a m  s (填充)
```

## 十进制数与数量 {#10진수와-수량}

精确的十进制数以 `C × 10^E` 书写。指数 `E` 为 32 位，系数 `C` 为最小 WORD 补码。原样承载原始写法的位数：`1.20` 为 `C=120, E=−2`，`1.2` 为 `C=12, E=−1`。两种写法表示同一个数，但字节不同，是各自独立的记录。编码器不得任意规范化写法。两条记录的值相等性与 quantum（有效数字）的含义是未决问题（[SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)）。

QUANTITY 把量、单位、边界放进一个值。

```
TAG WORD          0000 0110 0110 LLLL
[Length 扩展 TAG]
量                数值 Value 记录 (整数·BINARY-FLOAT·十进制数·分数)
单位              Reference 记录 (单位条目)，无单位则为 0x0000
下限              数值 Value 记录，省略则为 0x0000 ABSENT
上限              数值 Value 记录，省略则为 0x0000 ABSENT
```

- 单位是值的一部分。不把单位拆下来写到别处（拆开后就无法知道 `652` 是 km 还是 m）。
- 不承载换算为 SI 单位后的值。可以由单位和换算表计算得出。
- `0x0000` 是表示省略了可选字段的标记 ABSENT（[Codec 规格文档](../codec-spec.md)）。

例：`652 km`，范围 `[651, 653]`（km = Wikidata Q828224）

```
066E 0011                    TAG (扩展长度 17 WORD)
0683 0000 0000 028C          量 652
0142 000C A340               单位 Q828224
0683 0000 0000 028B          下限 651
0683 0000 0000 028D          上限 653
```

## 日期 {#날짜}

| 精度 | 格式 |
|---|---|
| 日期（格里高利历） | GREGORIAN-DATE |
| 年·月、不确定（`1971~`）、区间 | EDTF |
| 其他历法的原始写法（儒略历等） | GEDCOM-DATE |
| 时刻 | POSIX·TAI·GPS 时间戳 |

- 能用 GREGORIAN-DATE 书写的日期，不用 EDTF 书写。

## 未决问题 {#열린-문제}

- 公开媒体格式（JPEG、PNG、MP4、MOV 等）放在 IANA Issuer（`0x00000008`）的 Codec 编号下。媒体类型与 Codec 编号的对应表的管理方式。
- Value 直接码的最终列表。通过测量法令·业务对话样本中的 Value 频率来确定（金额、百分比、日期区间候选）。
- 7 个小型标量（ADHOC BFLOAT16、ONNX FP8 4 种、OCP FP8-E8M0FNU·FP4-E2M1FN）的详细规格与排布。尚未决定是否迁为直接码。目前只分配了 Codec 编号。
