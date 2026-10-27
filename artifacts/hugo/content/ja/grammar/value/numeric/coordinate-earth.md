---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH は、地球(WGS 84)上の一点を、緯度・経度 binary64 と不確かさ binary32、不確かさの単位 Reference で収める Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH は、地球上の一点を緯度・経度と不確かさで表す座標 Value だ。Value 直接コード `0x04`、系列 NUMERIC だ。意味は [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)(geo URI)の `geo:緯度,経度;u=不確かさ`(座標系 WGS 84)と同じで、文字列ではなく固定幅の数値で収める。不確かさは単位も併せて書く。地球外の天体の座標は、[COORDINATE-GEO](/ja/grammar/value/numeric/coordinate-geo/)(`0x05`)で書く。

## レイアウト

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD 生値、IEEE 754 binary64 (度)
Longitude         4 WORD 生値、IEEE 754 binary64 (度)
Uncertainty       2 WORD 生値、IEEE 754 binary32 (Unit の単位)
Unit              Reference レコード 1個、またはプレースホルダ 0x0000 ABSENT
```

## 解釈と有効性

- Payload は、Latitude 4 WORD、Longitude 4 WORD、Uncertainty 2 WORD の後ろに、Unit レコードがちょうど一つだ。Unit を読み終えたカーソルは、レコードの終わりと合わなければならない。
- 座標系は WGS 84 だ(RFC 5870 の既定 `crs=wgs84`)。
- Latitude・Longitude は、Payload WORD を big-endian 順に連ねた IEEE 754 binary64 だ([BINARY-FLOAT](/ja/grammar/value/numeric/binary-float/) の binary64 と同じビット配置)。単位は度(°)だ。
  - 有限な値でなければならない。NaN と ±Infinity は invalid だ。
  - Latitude は `-90 ≤ φ ≤ 90`(北が正)、Longitude は `-180 ≤ λ ≤ 180`(東が正)だ。
  - 軸の順序は緯度、経度だ(RFC 5870・ISO 6709 と同じ)。WKB・GeoJSON の x(経度)・y(緯度)の順序ではない。
- Uncertainty は、2 WORD を big-endian で連ねた IEEE 754 binary32 だ(BINARY-FLOAT の binary32 と同じビット配置)。実際の位置がこの半径の内側にあるという意味で、値は Unit の単位で読む。
  - 有限な `+0` 以上でなければならない。負数、`-0`(`8000 0000`)、NaN、±Infinity は invalid だ。
  - `0`(Unit があるとき): 正確な座標。どの単位で書いても同じだ。
- Unit は、Uncertainty の単位を指す Reference だ。Value は受け付けない。Quantifier は Identified(`000`)だ。
  - Wikidata の単位項目 [WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/) を使うことを勧める: 度 Q28390、分角 Q209426、秒角 Q829073、メートル Q11573、ミリメートル Q174789 など。QID のない単位は、他の Reference(LOCAL、GEUL など)で指す。同じ単位を指す Reference が複数あれば、QID が正規形だ。
  - Unit がメートル(Q11573)なら、Uncertainty は RFC 5870 の `u` と同じだ。
- **不明**: Unit の位置に [ABSENT](/ja/grammar/reference/slot-marker/)(`0x0000`)を書き、Uncertainty は `+0`(`0000 0000`)にする。RFC 5870 で `u` を省略した場合と同じだ。ABSENT なのに Uncertainty が `+0` でなければ invalid だ(表現を一つに固定する)。
- 高度は収めない。必要なら別の形式で定める。Wikidata の altitude はサンプルで使われておらず(0/23,066)、値があれば変換せずに原文を UTF8-TEXT で保存する。
- 地球の座標は、この形式を使うことを勧める。COORDINATE-GEO に地球(Q2)を書いた座標も invalid ではなく、比較する側が同じ座標として突き合わせる。
- geul.org 規格ドキュメント `0x0000/0x0000000000000804` は、Latitude・Longitude・Uncertainty の生値フィールドに [CODEC](/ja/grammar/edge/codec/) BINARY-FLOAT(`0803`)を置き(4 WORD = binary64、2 WORD = binary32)、Unit のレコードフィールドに CODEC `0780`(任意の Reference)・`0000`(ABSENT)を置く。

## 長さ

- 全体は、TAG 1 WORD + 10 WORD + Unit レコードだ。

| Unit | 全体 | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| QID が 1 WORD に収まるとき (2 WORD、例: 度 Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| QID が 2 WORD のとき (3 WORD、例: 分角 Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| Unit レコード 4 WORD 以上 | 15 WORD 以上 | 拡張長さ([レコードと TAG WORD](/ja/grammar/record/)) |

- 偶数・奇数の Codec ペアは置かない。

## Wikidata との対応

Wikidata の globecoordinate: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | この形式(地球)。他の天体は COORDINATE-GEO |
| latitude, longitude | binary64 のまま (Wikidata の値はもともと binary64 なので損失がない) |
| precision (度) | Uncertainty と Unit。下の「精度」 |
| precision が null またはなし | Unit = ABSENT、Uncertainty = `+0` (不明) |
| altitude | 捨てる (常に null) |

- Wikidata の precision は、測定誤差ではなく**記録の解像度**だ(座標を何度・分・秒の単位で書いたか)。GEUL の Uncertainty は、その値を変えずに移す。測定・座標系の誤差を足した半径ではない。

### 精度

precision を換算せずに移す。度・分角・秒角のうち、元の表記を復元できる最初の単位を選ぶ。

| precision の原文(例) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k 度) | 度 Q28390 | その値の binary32 |
| `0.0166667` のような短い10進表記 | 度 Q28390 | その値の binary32 |
| `0.016666666666667` (1/60°) | 分角 Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | 秒角 Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | 秒角 Q829073 | `0.1` |

- 順変換: 度、分角(×60)、秒角(×3600)の順に、precision に単位数を掛けた値に最も近い binary32 を Uncertainty とし、下の逆変換が precision の原文をそのまま復元する最初の単位を使う。
- 逆変換: Uncertainty の最短の10進表記(その binary32 に読み戻される最短の数)を単位数で割って度に直し、Wikibase がダンプに書く方式(有効数字14桁、`1e-4` 未満は指数表記 `1.0e-6`・`2.7777777777778e-5`)で書く。格納 DB(jsonb)は、これを小数表記 `0.0000010`・`0.000027777777777778` で保管する。
- どの単位でも原文を復元できなければ(有効数字17桁の表記 `0.0002777777777777778`、計算値のように見える外れ値など)、座標全体を変換せず、原文を UTF8-TEXT で保存する。負の precision と、天体が空の値も同じだ。
- Wikidata Q1–Q10000 のサンプル(座標 claim 7,026 件、precision あり 6,824 件): 原文を復元できたのは 5,933 件(86.9%; 度 4,104、秒角 1,370、分角 459)。復元できなかった 891 件のうち、753 件が有効数字17桁表記の 1/3600・1/60 系列だ。

## 例

ベルリン 52.516666666667, 13.383333333333、precision 1/60°(分角 1):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84`(14 WORD)、Latitude `404A 4222 2222 2251`、Longitude `402A C444 4444 4389`、Uncertainty `3F80 0000`(binary32 1.0)、Unit `0120 0003 3212`(WIKIDATA-QID Q209426、分角)。
- テキスト表記: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`。

不確かさが不明な同じ点: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD、Unit ABSENT)。

## 標準の根拠

- 意味: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — 緯度・経度の順序、`u` 不確かさ(メートル)、既定の座標系 WGS 84。Unit がメートルなら Uncertainty = `u`。
- 数値: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64(緯度・経度)、binary32(不確かさ)。
- 軸の順序と範囲: ISO 6709(Standard representation of geographic point location by coordinates)。
- 単位: Wikidata の単位項目(QID)。固定幅の配置、Unit フィールドと不明の表現は GEUL の規則だ。

## 未解決の問題

1. 高度。
2. ISO 6709 文字列の原文を保存する形式(COORDINATE-ISO6709)は、用途ができたら定める。
3. Wikidata の precision の有効数字17桁表記(サンプルの約11%)を無損失で移す方法。

## 関連ページ

- [Value](/ja/grammar/value/)、[COORDINATE-GEO](/ja/grammar/value/numeric/coordinate-geo/)、[BINARY-FLOAT](/ja/grammar/value/numeric/binary-float/)、[プレースホルダ](/ja/grammar/reference/slot-marker/)
- Issuer 形式の [POINT2-BINARY64](/ja/grammar/value/vector/point2-binary64/) は、座標系・単位・軸の意味を外部の文脈に委ねる一般の2次元の点で、この形式は地球上の地理座標だ。
