---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST 是承载 SHA-1 结果完整 160bit 的固定 11 WORD Value，只用于 git 对象 ID 之类的标识用途。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST 是承载 SHA-1 完整结果的固定宽度 Value。Value 直接码 `0x62`，系列为 BINARY。Payload 恰好是 10 WORD（160 bit），不允许截断（truncation）。

**只用于标识用途。** SHA-1 的抗碰撞性已被攻破（2017 SHAttered）。作为完整性·签名的依据，要使用 [SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)。本格式是为了原样承载已经由 SHA-1 确定的标识符，典型的是 SHA-1 git 仓库的对象 ID（提交 ID）而设。例如，把 [TRANSFORMED-BY](/zh/grammar/meta/lineage/transformed-by/) 的 Version（提交 ID）不用 hex 文本（22 WORD），而用 11 WORD 承载。

## 布局

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## 解读与有效性

- 把 Payload 的 20 octet 按 SHA-1 输出顺序原样读取。每个 WORD 中高 octet 在前（与 SHA-256-DIGEST 相同的 framing）。
- Payload 不是 10 WORD，或随意截断结果的表示（git 缩写 ID 等），予以拒绝。没有 descriptor 和 padding。
- git 对象 ID 就是 git 计算出的值。git 的 SHA-1 是加入了碰撞检测的变体（SHA-1DC），但对非碰撞攻击的输入，结果与 SHA-1 相同。

## 标准依据

- SHA-1 算法和 160bit 结果遵循 NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final)。
- GEUL TAG 和 16bit WORD framing 是本格式增加的规则。

## 长度

- 总计是 TAG 1 WORD 与 Payload 10 WORD 之和，恰好 11 WORD，使用 `LLLL=1010`。没有 Length 扩展。

## 示例

git 提交 `ddc0719974a32aaa7b422ee84221a9721085ce4c`：

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## 相关页面

- [Value](/zh/grammar/value/)、[SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)、[TRANSFORMED-BY](/zh/grammar/meta/lineage/transformed-by/)
