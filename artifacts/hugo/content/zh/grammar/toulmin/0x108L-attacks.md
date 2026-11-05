---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS 是用于写入 TOULMIN 图关系的 LINK Codec。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS 是用于写入 TOULMIN 图关系的 LINK Codec。含义：攻击关系。攻击者的判定按攻击强度（0~1，默认 1）逐步削减对象的判定。

| 项目 | 值 |
|---|---|
| 名称 | `ATTACKS`（规格文档 BIND `ATTACKS`） |
| TAG ID | `0x108L` |
| Codec ID | `0x00001080` |
| 规格文档 | `0x00000000/codecs/0x00001080/`（DECLARE 对象 `1080`） |
| 章节 | 8 `1000`（Edge TOULMIN），章节内偏移 C = 8 |
| Kind | Edge · 系列：TOULMIN，分组：关系，布局：LINK |
| TAG WORD | `0001 0000 1000 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 攻击关系。攻击者的判定按攻击强度（0~1，默认 1）逐步削减对象的判定 |
| Hugo 侧 | `edge/toulmin/link.md` |

## 布局 {#레이아웃}

布局为 [LINK](_index.md#link)（ID、src、dst、flags、条件字段、SPAN）。

| 项目 | 值 |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | 规则 → 规则。按攻击强度逐步削减判定 |

- dst 是节点的 REF。
- F_FORCE（攻击强度）仅此 Codec 使用。见下文[攻击强度](#공격-세기)。
- 公共字段（ID、REF、SPAN）与数值规则遵循 [TOULMIN](_index.md#공통-필드)。

## 攻击强度 {#공격-세기}

攻击强度（Force）表示一条 ATTACKS 边对对象的攻击有多强。范围为 0~1，没有 F_FORCE 时为 1。

- 判定中，攻击者判定值 v 的贡献 `(v+1)/2` 要乘以强度 F。反驳（COUNTER）攻击进入分母项 `F·(v+1)/2`，例外（EXCEPT）攻击进入门 `Π(1 − F·(v+1)/2)`。F 为 0 时，攻击对判定没有影响。
- 值遵循 [TOULMIN](_index.md#수치) 的数值规则。编码器去掉系数末尾的 0（0.5 为 `C=5, E=−1`，1.0 为 `C=1, E=0`）。解码器接受到小数点后 4 位。
- 不写强度的表面形式（`don't X when Y`，`` `Y` 면 `X` 는 무효다``（若 `Y` 则 `X` 无效））关闭 F_FORCE。
- 写出强度的表面形式（`` `Y` 면 `X` 를 0.5의 세기로 공격한다``（若 `Y` 则以 0.5 的强度攻击 `X`））开启 F_FORCE 并存入该值。像 `1.0의 세기로`（以 1.0 的强度）这样写 1 时，也开启 F_FORCE 并存入 1。因此原文的表面形式可以原样还原。
- 攻击强度与节点的刚度（Strict、Defeasible、Defeater）是不同的轴。刚度属于节点，攻击强度属于 ATTACKS 边。

### 攻击强度示例 {#공격-세기-예시}

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``（若 `Y` 则以 0.5 的强度攻击 `X`）。Edge Id 5，攻击者 Y 为 Edge Id 3，对象 X 为 Edge Id 2，SPAN 宽度 1 WORD。

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), 共 14 WORD
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, 攻击者)
0051 0002             dst     LOCAL 2 (X, 对象)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    起始字节 0x40, 字节数 0x1A
```

不写强度的同一条边，flags 为 `0000`，没有 F_FORCE 字段。TAG WORD 为 `1089`（共 10 WORD）。

## Codec 文档 {#코덱-문서}

Codec 文档设有 DECLARE（对象 `1080`）。LINK 布局的条件字段以及由 SOURCE 决定的 SPAN 宽度无法用 FIELD 声明，因此字段声明是未决问题（[TOULMIN](_index.md#열린-문제)）。

## 相关页面 {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001080/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
