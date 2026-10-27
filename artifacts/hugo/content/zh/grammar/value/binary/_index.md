---
title: "Value — 二进制"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BINARY 系列（Codec `0x60`~`0x7B`，格式编号 `0xC000`~`0xFFFF`）的格式：UUID、摘要、CRC、网络地址、不明字节序列、位向量。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY 系列是字节序列格式。放在直接码 `0x60`~`0x7B`、Issuer 格式编号 `0xC000`~`0xFFFF` 中。

- UUID、SHA-256、SHA-1 是直接码。其余摘要、CRC32C、IPv4·IPv6·MAC 地址、不明字节序列、位向量是 Issuer 格式。
- 固定大小的值（UUID、摘要、地址）大小已定，所以不设偶数·奇数对。
- 图像·视频之类的公开媒体放在 IANA Issuer（`0x0021`）的 BINARY 格式中。格式编号分配为偶数·奇数对，Payload 是字节序列。Length 上限是 2^32−1 WORD。大的值建议不要直接放入，而是用 URI 和 SHA-256 来引用。
- 字节序列中的作品遵循其原有的许可证。出处和许可证用 Meta 记录。
