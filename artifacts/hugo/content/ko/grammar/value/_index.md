---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value는 값 자체를 담는 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value는 값 자체를 담는 레코드다. Codec이 Payload의 해석을 정한다.

## 레이아웃

```
TAG WORD          000K KKKC CCCC LLLL      섹션 3·4 (0x060L~0x09FL)
[Length 확장 TAG]
[Codec 확장 TAG]  Issuer 형식일 때
Payload
```

- `LLLL`은 TAG WORD를 포함한 전체 WORD 수 − 1이다. 1~14 WORD는 직접 길이, 15 WORD 이상은 확장 길이다.
- Issuer 형식이면 Codec 확장 TAG에 Issuer(Codec이 정한 폭 2/4/16 WORD)와 코덱 번호 2 WORD를 둔다. 코덱 번호는 Issuer가 정한다.
- 디코더는 형식을 몰라도 Kind, Length, Issuer, 코덱 번호까지 안다.

## 계열

Value 번호는 계열을 뜻하지 않는다. 직접 코드는 비트로 계열을 나타내지 않으며, Issuer 형식에도 계열 규칙이 없다. 계열은 주제 묶음이다.

| 계열 | 직접 코드 |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL`, `0x082L` |
| BINARY | `0x07BL~0x080L` |

- 벡터, 텐서, 복소수, 분수, 구간 같은 수치 값은 NUMERIC이다. 예외로 BIT-VECTOR는 BINARY다. 언어 코드는 TEXT다.
- Issuer 형식 레코드는 Codec 확장 TAG(Issuer와 코덱 번호)가 붙는다. Payload가 길면(전체 15 WORD 이상) Length 확장 TAG를 쓴다.

## 직접 코드

| Codec | 이름 | 계열 | 설명 |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false 또는 true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | 최소 WORD 2의 보수 정수 |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | 최소 WORD 부호 없는 정수 |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | 지구(WGS 84) 위도·경도와 불확도(단위 Reference) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | 천체 Reference와 위도·경도, 불확도(단위 Reference) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | 수치 양(정수·BINARY-FLOAT·10진수·분수), 단위 Reference, 하한·상한 |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | 표기를 보존하는 분수(분자·분모 레코드, 약분하지 않음) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`, 부호 있는 계수 |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`, 부호 없는 계수 |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | 1970-01-01부터의 날짜 수 (그레고리력) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | 자정부터의 나노초 |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | Unix epoch부터의 초 |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | 경과 시간(초) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | ISO 8601-2 확장 날짜 문자열 (연·월 정밀도, 불확실, 구간) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | GEDCOM 7 날짜 문자열 (율리우스력 등 다른 달력) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | 언어가 없는 UTF-8 문자열 |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | RFC 3986 URI |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | BCP 47 언어 태그 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | 언어가 붙은 텍스트 |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | 1 WORD 압축 언어 코드 |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | RFC 9562 UUID |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | SHA-256 결과 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | SHA-1 결과 (git 객체 ID 같은 식별 용도) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | 의미·형식 불명의 바이트열. 짝수·홀수 바이트 |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | bit-count 뒤에 MSB-first로 저장한 N bit |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | 경과 시간(나노초) |
| `0x082L` | [TOKEN-TEXT](0x082L-token-text.md) | TEXT | TOKEN-0·TOKEN-1 레코드열로 적은 텍스트(레코드마다 TAG 포함 2 WORD) |

- 짝수·홀수로 짝지은 코드는 가변 길이 바이트열이다. 짝수 코드는 바이트 수가 짝수, 홀수 코드는 홀수다([레코드와 TAG WORD](../record.md)).
- 직접 코드는 `0x060L~0x082L`에 Reserved 없이 있다. `0x083L~0x09CL`은 Reserved이고 `0x09DL~0x09FL`은 [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md)다.

## Issuer 형식

직접 코드에 없는 형식은 그 형식을 제정한 단체의 Issuer 아래 코덱 번호로 둔다. 제정 단체가 없는 관례 형식은 ADHOC(`0x00000002`) 아래에 둔다. GEUL 고유 형식(OPAQUE-BYTES, BIT-VECTOR, DURATION-NANOSECONDS)은 직접 코드다.

| Issuer | 형식 예 |
|---|---|
| ADHOC `0x00000002` | BFLOAT16, 정수·실수 벡터, 텐서, 복소수, 분수, 구간, 사원수, BLAKE3 |
| IETF `0x00000007` | 상대 URI, CRC32C, IPv4·IPv6 주소 |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128, POSIX 나노초 타임스탬프, MAC 주소 |
| KHRONOS `0x0000000E` | RGBA8·BGRA8 픽셀 |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | TAI 타임스탬프 |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | GPS 타임스탬프 |

- 형식을 모르는 디코더는 Issuer와 코덱 번호까지 알고 Length로 건너뛴다.
- 코덱 문서는 그 Issuer의 `codecs/` 아래에 레코드의 코덱 번호로 둔다. 예: IETF CRC32C는 `0x00000007/codecs/0x0000C000/`([공표 주소와 버전 목록](../publishing.md)).
- 이미지·영상 같은 큰 값은 직접 넣기보다 URI와 SHA-256으로 참조하기를 권장한다.
- 바이트열 안의 저작물은 원래 라이선스를 따른다. 출처와 라이선스는 Meta로 기록한다.

## 형식 묶음

묶음별 설명은 아래에 있다. 각 형식의 레이아웃, 해석, 유효성, 예시는 형식별 문서에 있다.

| 묶음 | 계열 | 형식 |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL, 정수, 부동소수, 좌표, QUANTITY, FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | 날짜, 시각, 타임스탬프, 경과 시간, EDTF, GEDCOM 날짜 |
| [text](#text) | TEXT | UTF-8 텍스트, 언어가 붙은 텍스트, URI, 언어 코드 |
| [binary](#binary) | BINARY | UUID, 다이제스트, CRC, 네트워크 주소, 불명 바이트열, 비트 벡터 |
| [vector](#vector) | NUMERIC | 정수·실수 밀집 벡터, 점·경계 상자, RGBA·BGRA 픽셀 |
| [tensor](#tensor) | NUMERIC | 형식·rank·shape를 붙인 dense·packed 텐서 |
| [etc](#etc) | NUMERIC | 복소수, 분수, 닫힌 구간, 사원수 |

- vector, tensor, etc 묶음은 모두 NUMERIC 계열의 Issuer 형식(ADHOC, KHRONOS)이다.

### numeric

NUMERIC 계열의 기본 수 형식이다. 직접 코드 `0x060L~0x067L`에 둔다.

- BOOL, 부호 있는·없는 정수, IEEE 754 binary 부동소수, 지구(WGS 84)·천체 좌표, 양·단위·경계를 묶은 QUANTITY, 원문 표기 그대로의 분수 FRACTION이 있다.
- 정수는 값이 들어가는 최소 WORD로 쓴다.
- 작은 스칼라 Issuer 형식(BFLOAT16, FP8, FP4)은 코덱 번호만 배정되어 있고 상세 규격이 없다([Value](#열린-문제) 열린 문제).
- 벡터, 텐서, 복소수, 기약분수(RATIONAL-I64), 구간도 NUMERIC 계열이지만 Issuer 형식이라 [vector](#vector), [tensor](#tensor), [etc](#etc) 묶음에 둔다.

### decimal

DECIMAL 계열은 정확한 10진수 형식이다. 직접 코드 `0x068L~0x069L`에 둔다.

- 직접 코드 SIGNED-DECIMAL·UNSIGNED-DECIMAL은 `C × 10^E`로 쓰며 원래 표기의 자릿수를 그대로 담는다. `1.20`(`C=120, E=−2`)과 `1.2`(`C=12, E=−1`)는 다른 레코드다. 값 동등성과 quantum 보존은 [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)의 열린 문제다.
- IEEE 754 decimal32/64/128의 DPD·BID 인코딩은 IEEE Issuer(`0x0000000D`) 형식이다.

### time

TIME 계열은 날짜와 시각 형식이다. 직접 코드 `0x06AL~0x071L`과 `0x081L`(DURATION-NANOSECONDS)에 둔다.

| 정밀도 | 형식 |
|---|---|
| 날짜(그레고리력) | GREGORIAN-DATE |
| 연·월, 불확실, 구간 | EDTF |
| 다른 달력의 원본 표기(율리우스력 등) | GEDCOM-DATE |
| 시각 | POSIX·TAI·GPS 타임스탬프 |
| 경과 시간 | DURATION-SECONDS, DURATION-NANOSECONDS |

- GREGORIAN-DATE로 쓸 수 있는 날짜는 EDTF로 쓰지 않는다.
- 나노초 타임스탬프와 TAI·GPS 형식은 각 표준 단체 Issuer(IEEE, BIPM, GPS) 아래의 형식이다.

### text

TEXT 계열은 텍스트와 문자열 식별자 형식이다. 직접 코드 `0x072L~0x07AL`과 `0x082L`(TOKEN-TEXT)에 둔다.

- 언어가 없는 문자열은 UTF8-TEXT, 이름·제목·문장처럼 언어가 있는 텍스트는 UTF8-LANGUAGE-TEXT다.
- 언어 코드(LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE)도 TEXT 계열이다.
- 텍스트를 GEUL 토큰열로 적을 때는 TOKEN-TEXT를 쓴다. 이은 바이트가 같으면 UTF8-TEXT와 같은 텍스트다.
- 가변 길이 바이트열은 짝수·홀수 Codec 쌍으로 둔다. 최하위 비트가 `1`이면 바이트 수가 홀수이고 마지막 WORD의 하위 바이트는 `0x00` 패딩이다([레코드와 TAG WORD](../record.md)).

### binary

BINARY 계열은 바이트열 형식이다. 직접 코드 `0x07BL~0x080L`에 둔다.

- UUID, SHA-256, SHA-1, 불명 바이트열(OPAQUE-BYTES), 비트 벡터(BIT-VECTOR)는 직접 코드다. 나머지 다이제스트, CRC32C, IPv4·IPv6·MAC 주소는 Issuer 형식이다.
- 고정 크기 값(UUID, 다이제스트, 주소)은 크기가 정해져 있어 짝수·홀수 쌍을 두지 않는다.
- 이미지·영상 같은 공개 미디어는 IANA Issuer(`0x00000008`)의 형식으로 둔다. 코덱 번호는 짝수·홀수 쌍으로 배정하고 Payload는 바이트열이다. Length 상한은 2^32−1 WORD다. 큰 값은 직접 넣기보다 URI와 SHA-256으로 참조하기를 권장한다.
- 바이트열 안의 저작물은 원래 라이선스를 따른다. 출처와 라이선스는 Meta로 기록한다.

### vector

벡터 형식은 NUMERIC 계열의 Issuer 형식이다. 정수·실수 밀집 벡터와 점·경계 상자는 ADHOC(`0x00000002`) 코덱 번호 `0x00000500`~`0x0000050C`, 픽셀 형식은 KHRONOS(`0x0000000E`) 아래에 둔다.

- 밀집 벡터의 원소는 big-endian으로 연속해 저장한다.
- Issuer 형식이라 Codec 확장 TAG에 Issuer 2 WORD와 코덱 번호 2 WORD가 붙는다.

### tensor

텐서 형식은 NUMERIC 계열의 Issuer 형식이다. ADHOC(`0x00000002`) 코덱 번호 `0x00000600`~`0x00000601`에 둔다.

- DESCRIBED-DENSE-TENSOR는 원소 형식·rank·shape와 C-contiguous dense payload를 담는다.
- DESCRIBED-PACKED-TENSOR는 packed 형식·rank·shape와 octet 안 low-bit-first packed payload를 담는다.

### etc

기타 수 형식은 NUMERIC 계열의 Issuer 형식이다. ADHOC(`0x00000002`) 코덱 번호 `0x00000700`~`0x00000704`에 둔다.

- 복소수(COMPLEX64, COMPLEX128), 정규화한 분수(RATIONAL-I64), binary64 닫힌 구간, binary32 사원수가 있다.

## 텍스트

언어가 있는 텍스트와 없는 텍스트는 다른 값이다. "Paris"(문자열)와 "Paris"(프랑스어)는 같지 않다.

| 형식 | 쓰는 곳 |
|---|---|
| UTF8-TEXT | 식별자, 코드, 파일 이름, 외부 ID처럼 언어가 없는 문자열 |
| UTF8-LANGUAGE-TEXT | 이름, 제목, 문장처럼 언어가 있는 텍스트 |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = 텍스트가 홀수 바이트)
[Length 확장 TAG]
언어              LANGUAGE-SHORT-CODE 또는 LANGUAGE-BCP47-CODE 레코드
텍스트            UTF-8 바이트 (홀수면 마지막 0x00)
```

- 텍스트는 well-formed UTF-8이며 원문 그대로 보존한다. 정규화는 비교·색인하는 쪽이 맡는다.
- 여러 언어에 공통인 이름은 언어 `mul`, 언어 미정은 `und`로 쓴다. 언어 내용이 없는 문자열은 UTF8-TEXT다.

예: `"Douglas Adams"@en` (13 바이트, 홀수)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   언어 en    D o  u g  l a  s ␠  A d  a m  s (패딩)
```

## 10진수와 수량

정확한 10진수는 `C × 10^E`로 쓴다. 지수 `E`는 32비트, 계수 `C`는 최소 WORD 2의 보수다. 원래 표기의 자릿수를 그대로 담는다: `1.20`은 `C=120, E=−2`, `1.2`는 `C=12, E=−1`이다. 두 표기는 같은 수를 나타내지만 바이트가 다른 별개의 레코드다. 인코더는 표기를 임의로 정규화하지 않는다. 두 레코드의 값 동등성과 quantum(유효숫자)의 의미는 열린 문제다([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

QUANTITY는 양과 단위, 경계를 하나의 값으로 담는다.

```
TAG WORD          0000 0110 0110 LLLL
[Length 확장 TAG]
양                수치 Value 레코드 (정수·BINARY-FLOAT·10진수·분수)
단위              Reference 레코드 (단위 항목), 무단위면 0x0000
하한              수치 Value 레코드, 생략하면 0x0000 ABSENT
상한              수치 Value 레코드, 생략하면 0x0000 ABSENT
```

- 단위는 값의 일부다. 단위를 떼어 다른 곳에 적지 않는다(떼면 `652`가 km인지 m인지 알 수 없다).
- SI 단위로 환산한 값은 담지 않는다. 단위와 환산표에서 계산할 수 있다.
- `0x0000`은 선택 필드를 생략했다는 표지 ABSENT다([Codec 규격 문서](../codec-spec.md)).

예: `652 km`, 범위 `[651, 653]` (km = 위키데이터 Q828224)

```
066E 0011                    TAG (확장 길이 17 WORD)
0683 0000 0000 028C          양 652
0142 000C A340               단위 Q828224
0683 0000 0000 028B          하한 651
0683 0000 0000 028D          상한 653
```

## 날짜

| 정밀도 | 형식 |
|---|---|
| 날짜(그레고리력) | GREGORIAN-DATE |
| 연·월, 불확실(`1971~`), 구간 | EDTF |
| 다른 달력의 원본 표기(율리우스력 등) | GEDCOM-DATE |
| 시각 | POSIX·TAI·GPS 타임스탬프 |

- GREGORIAN-DATE로 쓸 수 있는 날짜는 EDTF로 쓰지 않는다.

## 열린 문제

- 공개 미디어 형식(JPEG, PNG, MP4, MOV 등)은 IANA Issuer(`0x00000008`)의 코덱 번호로 둔다. 미디어 타입과 코덱 번호의 대응표 관리 방식.
- Value 직접 코드의 최종 목록. 법령·업무 대화 표본의 Value 빈도를 측정해 정한다(금액, 백분율, 날짜 구간 후보).
- 작은 스칼라 7개(ADHOC BFLOAT16, ONNX FP8 4종, OCP FP8-E8M0FNU·FP4-E2M1FN)의 상세 규격과 배치. 직접 코드로 옮길지 정하지 않았다. 지금은 코덱 번호만 배정되어 있다.
