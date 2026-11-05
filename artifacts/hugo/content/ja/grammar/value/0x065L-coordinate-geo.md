---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO は指定した天体(惑星、衛星、小惑星など)上の一点を緯度・経度と不確かさで表す座標 Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `COORDINATE-GEO` (規格ドキュメント BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| 規格ドキュメント | `0x00000000/codecs/0x00000650/` (DECLARE 対象 `0650`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 5 |
| Kind | Value · 系列: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 天体 Reference と緯度・経度 binary64、不確かさ binary32 とその単位 Reference |
| Hugo 側 | `value/numeric/coordinate-geo.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | レコード | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | 生値 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | 生値 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | 生値 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference)、`020F` セクション 1 全体(ワイルドカード、Reference)、`040F` セクション 2 全体(ワイルドカード、Reference)、`0000` ABSENT(任意フィールド) |  |

COORDINATE-GEO は指定した天体(惑星、衛星、小惑星など)上の一点を緯度・経度と不確かさで表す座標 Value である。Value 直接コード `0x065L`、系列 NUMERIC である。[COORDINATE-EARTH](0x064L-coordinate-earth.md)(`0x064L`)の前に天体(Globe)Reference を加えた形式で、緯度・経度・不確かさ・単位の規則は COORDINATE-EARTH と同じである。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Globe             Reference レコード 1 個 (天体を指す Reference, Quantifier Identified)
Latitude          4 WORD 生値, IEEE 754 binary64 (度)
Longitude         4 WORD 生値, IEEE 754 binary64 (度)
Uncertainty       2 WORD 生値, IEEE 754 binary32 (Unit の単位)
Unit              Reference レコード 1 個、またはプレースホルダ 0x0000 ABSENT
```

## 解釈と有効性 {#해석과-유효성}

- Payload は Globe レコードで始まる。Globe は完全な Reference レコードがちょうど 1 つで、Quantifier は Identified である。天体を指す Reference ならどれでも使える: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)(名前のある天体)、[GEUL](../reference/0x00AL-geul.md)、同じドキュメントの [LOCAL](../reference/0x005L-local.md)(ドキュメント内で定義した天体)、別ドキュメントの天体([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)・[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md))など。天体は無数にあり、QID のある天体はその一部である。
- Globe の後に 10 WORD(Latitude 4、Longitude 4、Uncertainty 2)と Unit レコードが 1 つ続く。Unit を読んだカーソルはレコード末尾と一致しなければならない。
- Latitude は `-90 ≤ φ ≤ 90`、Longitude は `-360 ≤ λ ≤ 360` である。経度を 0~360° で数える天体の座標系(東経・西経)の値と、その逆方向で書いた負の値を変更せずに保持できるよう、地球より広く許可する。範囲は Wikidata の globecoordinate データモデル(Wikibase `LatLongValue`)と同じである。`λ` と `λ ± 360` は同じ子午線であり、GEUL は正規化しない。その他の規則(binary64、有限値、軸順序、Uncertainty・Unit の意味、不明の表現)は COORDINATE-EARTH と同じである。
- 座標系は天体ごとにその天体の慣例に従う(惑星中心緯度、東経または西経 0~360° など)。天体ごとの座標系は別の GEUL ドキュメントで定める。
- 距離単位(メートルなど)の Uncertainty は天体表面上の距離である。角度単位(度・分角・秒角)は天体の大きさに関係なく、緯度・経度の角度半径である。
- 地球(Q2)の座標は COORDINATE-EARTH を使うことを推奨する。この形式に地球を書いても invalid ではなく、比較する側が同じ座標として照合する。
- geul.org の規格ドキュメント `0x00000000/codecs/0x00000650` は、Latitude・Longitude・Uncertainty の生値フィールドに [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT(`0630`)を、Unit レコードフィールドに CODEC `000F`・`020F`・`040F`(任意の Reference)・`0000`(ABSENT)を置く。

## 長さ {#길이}

- 全体は TAG 1 WORD + (Length 拡張 TAG) + Globe レコード + 10 WORD + Unit レコードである。
- Globe が 2 WORD(QID が 1 WORD に収まるとき)で Unit が ABSENT なら 14 WORD、`LLLL=1101`、TAG `065D` である。Unit が Reference(2 WORD 以上)なら 15 WORD を超えるため拡張長を使う: TAG `065E`、次の WORD に全体の WORD 数([レコードと TAG WORD](../record.md))。

## Wikidata との対応 {#위키데이터-대응}

- globe が地球(Q2)でない globecoordinate はこの形式で書く。Globe = WIKIDATA-QID(globe 項目)。緯度・経度、precision → Uncertainty・Unit の対応は COORDINATE-EARTH と同じである(precision は度単位の記録解像度なので、天体の大きさに関係なくそのまま移す)。
- Wikidata 標本(座標 claim 約 2.4 万件)の地球外天体: 火星(Q111)、ケレス(Q596)、月(Q405)、水星(Q308)、金星(Q313)など 23 件。globe が空の 41 件は変換せず原文を UTF8-TEXT で保存する。

## 例 {#예시}

火星(Q111) 4.5, 137.4, 不確かさ不明:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D`(Codec `0x065L`、`LLLL=1101`、14 WORD)、Globe `0141 006F`(WIKIDATA-QID Q111)、Latitude `4012 0000 0000 0000`、Longitude `4061 2CCC CCCC CCCD`、Uncertainty `0000 0000`(+0)、Unit `0000`(ABSENT、不明)。
- テキスト表記: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`。

同じ点、precision 0.1°(Unit 度 Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E`(`LLLL=1110`、拡張長)、全体 `0010`(16 WORD)、Uncertainty `3DCC CCCD`(binary32 0.1)、Unit `0141 6EE6`(Q28390)。

## 標準の根拠 {#표준-근거}

- 意味: [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) の緯度・経度・`u`(Unit がメートルのとき)。RFC 5870 の `crs` に登録された座標系は `wgs84` のみなので、地球外の天体は GEUL の Globe Reference で指定する。
- 数値: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64(緯度・経度)、binary32(不確かさ)。
- 経度の範囲: Wikidata の globecoordinate データモデル [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo) の `-360 ≤ λ ≤ 360`。

## 未解決の問題 {#열린-문제}

1. 天体ごとの座標系ドキュメント: 天体ごとの緯度の定義(惑星中心・惑星面)と経度の方向・範囲。

## 関連ページ {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000650/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
