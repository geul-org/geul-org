---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS は TOULMIN グラフの関係を書く LINK Codec である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS は TOULMIN グラフの関係を書く LINK Codec である。意味は攻撃関係。攻撃者の判定が対象の判定を、攻撃の強さ (0~1、既定 1) の分だけ漸進的に削る。

| 項目 | 値 |
|---|---|
| 名前 | `ATTACKS` (規格ドキュメント BIND `ATTACKS`) |
| TAG ID | `0x108L` |
| Codec ID | `0x00001080` |
| 規格ドキュメント | `0x00000000/codecs/0x00001080/` (DECLARE 対象 `1080`) |
| セクション | 8 `1000` (Edge TOULMIN)、セクション内オフセット C = 8 |
| Kind | Edge · 系列: TOULMIN、まとまり: 関係、レイアウト: LINK |
| TAG WORD | `0001 0000 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 攻撃関係。攻撃者の判定が対象の判定を、攻撃の強さ (0~1、既定 1) の分だけ漸進的に削る |
| Hugo 側 | `edge/toulmin/link.md` |

## レイアウト {#레이아웃}

レイアウトは [LINK](_index.md#link) である (ID、src、dst、flags、条件付きフィールド、SPAN)。

| 項目 | 値 |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | 規則 → 規則。判定を攻撃の強さの分だけ漸進的に削る |

- dst はノードの REF である。
- F_FORCE (攻撃の強さ) はこの Codec だけが使う。下の[攻撃の強さ](#공격-세기)を参照。
- 共通フィールド (ID、REF、SPAN) と数値規則は [TOULMIN](_index.md#공통-필드) に従う。

## 攻撃の強さ {#공격-세기}

攻撃の強さ (Force) は、ATTACKS エッジ一つが対象をどれだけ強く攻撃するかを表す。範囲は 0~1 で、F_FORCE がなければ 1 である。

- 判定で、攻撃者の判定値 v の寄与 `(v+1)/2` に強さ F を掛ける。反駁 (COUNTER) の攻撃は分母項 `F·(v+1)/2` に、例外 (EXCEPT) の攻撃はゲート `Π(1 − F·(v+1)/2)` に入る。F が 0 なら攻撃は判定に影響しない。
- 値は [TOULMIN](_index.md#수치) の数値規則に従う。エンコーダは係数の末尾の 0 を消す (0.5 は `C=5, E=−1`、1.0 は `C=1, E=0`)。デコーダは小数 4 桁まで受け付ける。
- 強さを書かない表面 (`don't X when Y`、`` `Y` 면 `X` 는 무효다`` (「Y ならば X は無効である」の意)) は F_FORCE をオフにする。
- 強さを書いた表面 (`` `Y` 면 `X` 를 0.5의 세기로 공격한다`` (「Y ならば X を強さ 0.5 で攻撃する」の意)) は F_FORCE をオンにしてその値を収める。`1.0의 세기로` (「強さ 1.0 で」の意) のように 1 を書いた場合も F_FORCE をオンにして 1 を収める。そのため原文の表面がそのまま戻る。
- 攻撃の強さはノードの強度 (Strict、Defeasible、Defeater) とは別の軸である。強度はノードに、攻撃の強さは ATTACKS エッジに付く。

### 攻撃の強さの例 {#공격-세기-예시}

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``。Edge Id 5、攻撃者 Y は Edge Id 3、対象 X は Edge Id 2、SPAN 幅 1 WORD。

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), 全体 14 WORD
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, 攻撃者)
0051 0002             dst     LOCAL 2 (X, 対象)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    開始バイト 0x40, バイト数 0x1A
```

強さを書かない同じエッジは flags が `0000` で、F_FORCE フィールドがない。TAG WORD は `1089` (全体 10 WORD) である。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE (対象 `1080`) を置く。LINK レイアウトの条件付きフィールドと、SOURCE が定める SPAN 幅は FIELD で宣言できないため、フィールド宣言は未解決の問題である ([TOULMIN](_index.md#열린-문제))。

## 関連ページ {#관련-페이지}

- [LINK](_index.md#link)、[TOULMIN](_index.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001080/latest.geul` を `geul show` で読んだ姿である (16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
