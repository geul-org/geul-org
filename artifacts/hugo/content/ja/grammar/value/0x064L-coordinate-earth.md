---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH は地球上の一点を緯度・経度と不確かさで表す座標 Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `COORDINATE-EARTH` (規格ドキュメント BIND `COORDINATE-EARTH`) |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| 規格ドキュメント | `0x00000000/codecs/0x00000640/` (DECLARE 対象 `0640`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 4 |
| Kind | Value · 系列: NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引説明 | 地球(WGS 84)の緯度・経度 binary64、不確かさ binary32 とその単位 Reference(ABSENT = 不明) |
| Hugo 側 | `value/numeric/coordinate-earth.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | 生値 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | 生値 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | 生値 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference)、`020F` セクション 1 全体(ワイルドカード、Reference)、`040F` セクション 2 全体(ワイルドカード、Reference)、`0000` ABSENT(任意フィールド) |  |

COORDINATE-EARTH は地球上の一点を緯度・経度と不確かさで表す座標 Value である。Value 直接コード `0x064L`、系列 NUMERIC である。意味は [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)(geo URI)の `geo:緯度,経度;u=不確かさ`(座標系 WGS 84)と同じで、文字列ではなく固定幅の数値として保持する。不確かさは単位を併記する。地球外の天体の座標は [COORDINATE-GEO](0x065L-coordinate-geo.md)(`0x065L`)で書く。

## レイアウト {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD 生値, IEEE 754 binary64 (度)
Longitude         4 WORD 生値, IEEE 754 binary64 (度)
Uncertainty       2 WORD 生値, IEEE 754 binary32 (Unit の単位)
Unit              Reference レコード 1 個、またはプレースホルダ 0x0000 ABSENT
```

## 解釈と有効性 {#해석과-유효성}

- Payload は Latitude 4 WORD、Longitude 4 WORD、Uncertainty 2 WORD の後に Unit レコードがちょうど 1 つ続く。Unit を読んだカーソルはレコード末尾と一致しなければならない。
- 座標系は WGS 84 である(RFC 5870 の既定 `crs=wgs84`)。
- Latitude・Longitude は Payload WORD を big-endian 順に連結した IEEE 754 binary64 である([BINARY-FLOAT](0x063L-binary-float.md)の binary64 と同じビット配置)。単位は度(°)である。
  - 有限の値でなければならない。NaN と ±Infinity は invalid である。
  - Latitude は `-90 ≤ φ ≤ 90`(北が正)、Longitude は `-180 ≤ λ ≤ 180`(東が正)である。
  - 軸順序は緯度、経度である(RFC 5870・ISO 6709 と同じ)。WKB・GeoJSON の x(経度)・y(緯度)の順ではない。
- Uncertainty は 2 WORD を big-endian で連結した IEEE 754 binary32 である(BINARY-FLOAT の binary32 と同じビット配置)。実際の位置がこの半径内にあるという意味で、値は Unit の単位で読む。
  - 有限の `+0` 以上でなければならない。負数、`-0`(`8000 0000`)、NaN、±Infinity は invalid である。
  - `0`(Unit があるとき): 正確な座標。どの単位で書いても同じである。
- Unit は Uncertainty の単位を指す Reference である。Value は受けない。Quantifier は Identified である。
  - Wikidata の単位項目 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) を使うことを推奨する: 度 Q28390、分角 Q209426、秒角 Q829073、メートル Q11573、ミリメートル Q174789 など。QID のない単位は他の Reference(LOCAL、GEUL など)で指す。同じ単位を指す Reference が複数あるときは QID が正規形である。
  - Unit がメートル(Q11573)なら、Uncertainty は RFC 5870 の `u` と同じである。
- **不明**: Unit の位置に [ABSENT](../slot-marker.md)(`0x0000`)を書き、Uncertainty は `+0`(`0000 0000`)にする。RFC 5870 で `u` を省略した場合と同じである。ABSENT なのに Uncertainty が `+0` でなければ invalid である(表現を 1 つに固定する)。
- 高度は保持しない。必要なら別の形式で定める。Wikidata の altitude は標本で使われておらず(0/23,066)、値があっても変換せず原文を UTF8-TEXT で保存する。
- 地球の座標はこの形式を使うことを推奨する。COORDINATE-GEO に地球(Q2)を書いた座標も invalid ではなく、比較する側が同じ座標として照合する。
- geul.org の規格ドキュメント `0x00000000/codecs/0x00000640` は、Latitude・Longitude・Uncertainty の生値フィールドに [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT(`0630`)を置き(4 WORD = binary64、2 WORD = binary32)、Unit レコードフィールドに CODEC `000F`・`020F`・`040F`(任意の Reference)・`0000`(ABSENT)を置く。

## 長さ {#길이}

- 全体は TAG 1 WORD + 10 WORD + Unit レコードである。

| Unit | 全体 | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `064B` (`LLLL=1011`) |
| QID が 1 WORD に収まるとき (2 WORD、例: 度 Q28390) | 13 WORD | `064C` (`LLLL=1100`) |
| QID が 2 WORD のとき (3 WORD、例: 分角 Q209426) | 14 WORD | `064D` (`LLLL=1101`) |
| Unit レコード 4 WORD 以上 | 15 WORD 以上 | 拡張長([レコードと TAG WORD](../record.md)) |

- 偶・奇の Codec 対は置かない。

## Wikidata との対応 {#위키데이터-대응}

Wikidata の globecoordinate: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | この形式(地球)。他の天体は COORDINATE-GEO |
| latitude, longitude | binary64 のまま (Wikidata の値はもともと binary64 なので損失がない) |
| precision (度) | Uncertainty と Unit。下の「精度」 |
| precision が null または無し | Unit = ABSENT, Uncertainty = `+0` (不明) |
| altitude | 捨てる (常に null) |

- Wikidata の precision は測定誤差ではなく**記録の解像度**である(座標を何度・分・秒の単位で書いたか)。GEUL の Uncertainty はその値を変えずに移す。測定・座標系の誤差を加えた半径ではない。

### 精度 {#정밀도}

precision を換算せずに移す。度・分角・秒角のうち、元の表記を復元できる最初の単位を選ぶ。

| precision 原文(例) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k 度) | 度 Q28390 | その値の binary32 |
| `0.0166667` のような短い 10 進表記 | 度 Q28390 | その値の binary32 |
| `0.016666666666667` (1/60°) | 分角 Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | 秒角 Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | 秒角 Q829073 | `0.1` |

- 順変換: 度、分角(×60)、秒角(×3600)の順に、precision に単位数を掛けた値に最も近い binary32 を Uncertainty とし、下の逆変換が precision 原文をそのまま復元する最初の単位を使う。
- 逆変換: Uncertainty の最短 10 進表記(その binary32 に読み戻せる最短の数)を単位数で割って度に直し、Wikibase がダンプに書く方式(有効数字 14 桁、`1e-4` 未満は指数表記 `1.0e-6`・`2.7777777777778e-5`)で書く。ロード先 DB(jsonb)はこれを小数表記 `0.0000010`・`0.000027777777777778` で保管する。
- どの単位でも原文を復元できなければ(有効数字 17 桁表記 `0.0002777777777777778`、計算値に見える異常値など)、座標全体を変換せず原文を UTF8-TEXT で保存する。負の precision や天体が空の値も同じである。
- Wikidata Q1–Q10000 標本(座標 claim 7,026 件、precision あり 6,824 件): 原文を復元できたもの 5,933 件(86.9%; 度 4,104、秒角 1,370、分角 459)。復元できなかった 891 件のうち 753 件が有効数字 17 桁表記の 1/3600・1/60 系列である。

## 例 {#예시}

ベルリン 52.516666666667, 13.383333333333, precision 1/60°(分角 1):

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D`(14 WORD)、Latitude `404A 4222 2222 2251`、Longitude `402A C444 4444 4389`、Uncertainty `3F80 0000`(binary32 1.0)、Unit `0142 0003 3212`(WIKIDATA-QID Q209426、分角)。
- テキスト表記: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`。

不確かさが不明の同じ点: `064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD、Unit ABSENT)。

## 標準の根拠 {#표준-근거}

- 意味: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — 緯度・経度の順序、`u` 不確かさ(メートル)、既定の座標系 WGS 84。Unit がメートルなら Uncertainty = `u`。
- 数値: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64(緯度・経度)、binary32(不確かさ)。
- 軸順序と範囲: ISO 6709(Standard representation of geographic point location by coordinates)。
- 単位: Wikidata の単位項目(QID)。固定幅の配置、Unit フィールドと不明の表現は GEUL の規則である。

## 未解決の問題 {#열린-문제}

1. 高度。
2. ISO 6709 文字列の原文を保存する形式(COORDINATE-ISO6709)は、用途が生じたときに定める。
3. Wikidata precision の有効数字 17 桁表記(標本の約 11%)を無損失で移す方法。

## 関連ページ {#관련-페이지}

- [Value](_index.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [BINARY-FLOAT](0x063L-binary-float.md), [プレースホルダ](../slot-marker.md)
- Issuer 形式 [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) は座標系・単位・軸の意味を外部の文脈に委ねる一般的な 2 次元の点であり、この形式は地球上の地理座標である。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000640/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000064000000000
BODY
#1 DECLARE 0x0640
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "COORDINATE-EARTH"
#6 BIND #2 "latitude"
#7 BIND #3 "longitude"
#8 BIND #4 "uncertainty"
#9 CODEC #2 0x0630
#10 CODEC #3 0x0630
#11 CODEC #4 0x0630
#12 FIELD #1 record
#13 BIND #12 "unit"
#14 CODEC #12 0x000F
#16 CODEC #12 0x020F
#17 CODEC #12 0x040F
#15 CODEC #12 0x0000
```
