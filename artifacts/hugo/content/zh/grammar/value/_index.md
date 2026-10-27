---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value 是承载值本身的记录。Codec 高 2 位是系列（数·十进制数、时间、文本、二进制），常用格式作为直接码，其余按标准组织放在 Issuer 格式中。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value 是承载值本身的记录。由 Codec 决定 Payload 的解读。

## 布局

```
TAG WORD          0000 1LLL LCCC CCCC
[Length 扩展 TAG]
[Codec 扩展 TAG]  Issuer 格式时
Payload
```

- `LLLL` 是包含 TAG WORD 在内的总 WORD 数 − 1。1~14 WORD 用直接长度，15 WORD 以上用扩展长度。
- Issuer 格式时，Codec 扩展 TAG 中放 Issuer（由 Codec 决定宽度 1/2/4/16 WORD）和格式编号 1 WORD。格式编号的高 2 位是系列。
- 解码器即使不知道格式，也知道系列和 Length。

## 系列

Codec 的高 2 位是系列。直接码（7 位）和 Issuer 格式编号（16 位）遵循同样的规则。因此没有 codebook 也能知道系列。

| 高 2 位 | 系列 | 直接码 | 格式编号 |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL 再用第三位区分。`000` 是 NUMERIC，`001` 是 DECIMAL。
- 向量、张量、复数、分数、区间之类的数值是 NUMERIC。例外是 BIT-VECTOR 属于 BINARY。语言码属于 TEXT。
- Issuer 格式记录带有 Codec 扩展 TAG（Issuer 和格式编号）。Payload 较长时（总共 15 WORD 以上）使用 Length 扩展 TAG。

## 直接码

| Codec | 名称 | 系列 | 说明 |
|---|---|---|---|
| `0x00` | [BOOL](/zh/grammar/value/numeric/bool/) | NUMERIC | false 或 true |
| `0x01` | [SIGNED-INTEGER](/zh/grammar/value/numeric/signed-integer/) | NUMERIC | 最小 WORD 二进制补码整数 |
| `0x02` | [UNSIGNED-INTEGER](/zh/grammar/value/numeric/unsigned-integer/) | NUMERIC | 最小 WORD 无符号整数 |
| `0x03` | [BINARY-FLOAT](/zh/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/zh/grammar/value/numeric/coordinate-earth/) | NUMERIC | 地球（WGS 84）纬度·经度与不确定度（单位 Reference） |
| `0x05` | [COORDINATE-GEO](/zh/grammar/value/numeric/coordinate-geo/) | NUMERIC | 天体 Reference 与纬度·经度、不确定度（单位 Reference） |
| `0x06` | [QUANTITY](/zh/grammar/value/numeric/quantity/) | NUMERIC | 数值数量（整数·BINARY-FLOAT·十进制数·分数）、单位 Reference、下限·上限 |
| `0x07` | [FRACTION](/zh/grammar/value/numeric/fraction/) | NUMERIC | 保留写法的分数（分子·分母记录，不约分） |
| `0x10` | [SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`，有符号系数 |
| `0x11` | [UNSIGNED-DECIMAL](/zh/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`，无符号系数 |
| `0x20` | [GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/) | TIME | 自 1970-01-01 起的天数（格里高利历） |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/zh/grammar/value/time/civil-time-nanoseconds/) | TIME | 自午夜起的纳秒 |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/zh/grammar/value/time/posix-timestamp-seconds/) | TIME | 自 Unix epoch 起的秒 |
| `0x23` | [DURATION-SECONDS](/zh/grammar/value/time/duration-seconds/) | TIME | 经过时间（秒） |
| `0x24`/`0x25` | [EDTF](/zh/grammar/value/time/edtf/) | TIME | ISO 8601-2 扩展日期字符串（年·月精度、不确定、区间） |
| `0x26`/`0x27` | [GEDCOM-DATE](/zh/grammar/value/time/gedcom-date/) | TIME | GEDCOM 7 日期字符串（儒略历等其他历法） |
| `0x40`/`0x41` | [UTF8-TEXT](/zh/grammar/value/text/utf8-text/) | TEXT | 没有语言的 UTF-8 字符串 |
| `0x44`/`0x45` | [URI](/zh/grammar/value/text/uri/) | TEXT | RFC 3986 URI |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/zh/grammar/value/text/language-bcp47-code/) | TEXT | BCP 47 语言标签 |
| `0x48` | [LANGUAGE-SHORT-CODE](/zh/grammar/value/text/language-short-code/) | TEXT | 1 WORD 压缩语言码 |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/) | TEXT | 带语言的文本 |
| `0x60` | [UUID](/zh/grammar/value/binary/uuid/) | BINARY | RFC 9562 UUID |
| `0x61` | [SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/) | BINARY | SHA-256 结果 |
| `0x62` | [SHA1-DIGEST](/zh/grammar/value/binary/sha1-digest/) | BINARY | SHA-1 结果（git 对象 ID 之类的标识用途） |

- 以偶数·奇数配对的码是可变长度字节序列。偶数码的字节数为偶数，奇数码的字节数为奇数（[记录与 TAG WORD](/zh/grammar/record/)）。
- 表中没有的直接码为保留。

## Issuer 格式

直接码中没有的格式，放在制定该格式的组织的 Issuer 之下的格式编号中。没有制定组织的惯例格式放在 ADHOC（`0x0001`）之下，GEUL 专有格式放在 GEUL（`0x0000`）之下。

| Issuer | 格式示例 |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS、OPAQUE-BYTES、BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16、整数·实数向量、张量、复数、分数、区间、四元数、BLAKE3 |
| IETF `0x0020` | 相对 URI、CRC32C、IPv4·IPv6 地址 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128、POSIX 纳秒时间戳、MAC 地址 |
| KHRONOS `0x0041` | RGBA8·BGRA8 像素 |
| ONNX `0x0043`、OCP `0x0044` | FP8、FP4 |
| BIPM `0x0060` | TAI 时间戳 |
| NIST `0x0062` | SHA-512、SHA3-256 |
| GPS `0x0063` | GPS 时间戳 |

- 不认识格式的解码器只知道格式编号的系列，并跳过 Payload。
- 图像·视频之类的大值，建议不要直接放入，而是用 URI 和 SHA-256 来引用。
- 字节序列中的作品遵循其原有的许可证。出处和许可证用 Meta 记录。

## 格式分组

各格式的布局、解读、有效性、示例见各分组文档。

| 分组 | 系列 | 格式 |
|---|---|---|
| [numeric](/zh/grammar/value/numeric/) | NUMERIC | BOOL、整数、浮点数、坐标、QUANTITY、FRACTION |
| [decimal](/zh/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL、UNSIGNED-DECIMAL、IEEE 754 decimal32/64/128 |
| [time](/zh/grammar/value/time/) | TIME | 日期、时刻、时间戳、经过时间、EDTF、GEDCOM 日期 |
| [text](/zh/grammar/value/text/) | TEXT | UTF-8 文本、带语言的文本、URI、语言码 |
| [binary](/zh/grammar/value/binary/) | BINARY | UUID、摘要、CRC、网络地址、不明字节序列、位向量 |
| [vector](/zh/grammar/value/vector/) | NUMERIC | 整数·实数稠密向量、点·边界框、RGBA·BGRA 像素 |
| [tensor](/zh/grammar/value/tensor/) | NUMERIC | 附有格式·rank·shape 的 dense·packed 张量 |
| [etc](/zh/grammar/value/etc/) | NUMERIC | 复数、分数、闭区间、四元数 |

- vector、tensor、etc 分组都是 NUMERIC 系列的 Issuer 格式（ADHOC、KHRONOS）。

## 文本

带语言的文本和不带语言的文本是不同的值。"Paris"（字符串）与 "Paris"（法语）并不相同。

| 格式 | 使用位置 |
|---|---|
| UTF8-TEXT | 标识符、代码、文件名、外部 ID 之类没有语言的字符串 |
| UTF8-LANGUAGE-TEXT | 名称、标题、句子之类有语言的文本 |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = 文本为奇数字节)
[Length 扩展 TAG]
语言              LANGUAGE-SHORT-CODE 或 LANGUAGE-BCP47-CODE 记录
文本              UTF-8 字节 (奇数则末尾为 0x00)
```

- 文本是 well-formed UTF-8，原样保留原文。规范化由比较·索引的一方负责。
- 对多种语言通用的名称用语言 `mul`，语言未定用 `und`。没有语言内容的字符串是 UTF8-TEXT。

例：`"Douglas Adams"@en`（13 字节，奇数）

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   语言 en    D o  u g  l a  s ␠  A d  a m  s (填充)
```

## 十进制数与数量

精确的十进制数写成 `C × 10^E`。指数 `E` 是 32 位，系数 `C` 是最小 WORD 二进制补码。原样保留原来写法的位数：`1.20` 是 `C=120, E=−2`，`1.2` 是 `C=12, E=−1`。这两种写法表示同一个数，但字节不同，是相互独立的记录。编码器不会随意规范化写法。两个记录的值等价性与 quantum（有效数字）的含义是未决问题（[SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/#未决问题)）。

QUANTITY 把数量、单位、边界作为一个值来承载。

```
TAG WORD          0000 1LLL L000 0110
[Length 扩展 TAG]
数量              数值 Value 记录 (整数·BINARY-FLOAT·十进制数·分数)
单位              Reference 记录 (单位条目)，无单位则为 0x0000
下限              数值 Value 记录，省略则为 0x0000 ABSENT
上限              数值 Value 记录，省略则为 0x0000 ABSENT
```

- 单位是值的一部分。不要把单位拆下来写在别处（拆开后就无法知道 `652` 是 km 还是 m）。
- 不存放换算为 SI 单位的值。可以由单位和换算表计算得出。
- `0x0000` 是省略可选字段的标记 ABSENT（[Codec 规格文档](/zh/grammar/codec-spec/)）。

例：`652 km`，范围 `[651, 653]`（km = Wikidata Q828224）

```
0F06 0011                    TAG (扩展长度 17 WORD)
0990 0000 0000 028C          数量 652
0120 000C A340               单位 Q828224
0990 0000 0000 028B          下限 651
0990 0000 0000 028D          上限 653
```

## 日期

| 精度 | 格式 |
|---|---|
| 日期（格里高利历） | GREGORIAN-DATE |
| 年·月、不确定（`1971~`）、区间 | EDTF |
| 其他历法的原始写法（儒略历等） | GEDCOM-DATE |
| 时刻 | POSIX·TAI·GPS 时间戳 |

- 能用 GREGORIAN-DATE 表示的日期，不用 EDTF 书写。

## 未决问题

- 公开媒体格式（JPEG、PNG、MP4、MOV 等）放在 IANA Issuer（`0x0021`）的 BINARY 格式编号中。媒体类型与格式编号对应表的管理方式。
- Value 直接码的最终列表。测量法令·业务对话样本中的 Value 频率后确定（金额、百分比、日期区间候选）。
- 7 个小标量（ADHOC BFLOAT16、ONNX FP8 4 种、OCP FP8-E8M0FNU·FP4-E2M1FN）的详细规格与布置。是否移到 NUMERIC 直接码保留区间（`0x08`~`0x0F`）尚未确定。目前只分配了格式编号。
