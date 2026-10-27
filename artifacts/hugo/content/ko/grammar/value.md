---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value는 값 자체를 담는 레코드다. Codec 상위 2비트가 계열(수·10진수, 시간, 텍스트, 바이너리)이고, 자주 쓰는 형식은 직접 코드, 나머지는 표준 단체별 Issuer 형식으로 둔다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Value는 값 자체를 담는 레코드다. Codec이 Payload의 해석을 정한다.

## 레이아웃

```
TAG WORD          0000 1LLL LCCC CCCC
[Length 확장 TAG]
[Codec 확장 TAG]  Issuer 형식일 때
Payload
```

## 계열

Codec의 상위 2비트가 계열이다. 직접 코드(7비트)와 Issuer 형식 번호(16비트)가 같은 규칙을 따른다. 그래서 코덱북 없이도 계열을 안다.

| 상위 2비트 | 계열 | 직접 코드 | 형식 번호 |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL은 세 번째 비트로 다시 나눈다. `000`은 NUMERIC, `001`은 DECIMAL이다.
- 벡터, 텐서, 복소수, 분수, 구간 같은 수치 값은 NUMERIC이다. 언어 코드는 TEXT다.

## 직접 코드

| Codec | 이름 | 계열 | 설명 |
|---|---|---|---|
| `0x00` | BOOL | NUMERIC | false 또는 true |
| `0x01` | SIGNED-INTEGER | NUMERIC | 최소 WORD 2의 보수 정수 |
| `0x02` | UNSIGNED-INTEGER | NUMERIC | 최소 WORD 부호 없는 정수 |
| `0x03` | BINARY-FLOAT | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | COORDINATE-EARTH | NUMERIC | 지구(WGS 84) 위도·경도와 불확도 |
| `0x05` | COORDINATE-GEO | NUMERIC | 천체 Reference와 위도·경도, 불확도 |
| `0x06` | QUANTITY | NUMERIC | 10진수 양, 단위 Reference, 하한·상한 |
| `0x10` | SIGNED-DECIMAL | DECIMAL | `C × 10^E`, 부호 있는 계수 |
| `0x11` | UNSIGNED-DECIMAL | DECIMAL | `C × 10^E`, 부호 없는 계수 |
| `0x20` | GREGORIAN-DATE | TIME | 1970-01-01부터의 날짜 수 (그레고리력) |
| `0x21` | CIVIL-TIME-NANOSECONDS | TIME | 자정부터의 나노초 |
| `0x22` | POSIX-TIMESTAMP-SECONDS | TIME | Unix epoch부터의 초 |
| `0x23` | DURATION-SECONDS | TIME | 경과 시간(초) |
| `0x24`/`0x25` | EDTF | TIME | ISO 8601-2 확장 날짜 문자열 (연·월 정밀도, 불확실, 구간) |
| `0x26`/`0x27` | GEDCOM-DATE | TIME | GEDCOM 7 날짜 문자열 (율리우스력 등 다른 달력) |
| `0x40`/`0x41` | UTF8-TEXT | TEXT | 언어가 없는 UTF-8 문자열 |
| `0x44`/`0x45` | URI | TEXT | RFC 3986 URI |
| `0x46`/`0x47` | LANGUAGE-BCP47-CODE | TEXT | BCP 47 언어 태그 |
| `0x48` | LANGUAGE-SHORT-CODE | TEXT | 1 WORD 압축 언어 코드 |
| `0x4A`/`0x4B` | UTF8-LANGUAGE-TEXT | TEXT | 언어가 붙은 텍스트 |
| `0x60` | UUID | BINARY | RFC 9562 UUID |
| `0x61` | SHA-256-DIGEST | BINARY | SHA-256 결과 |
| `0x62` | SHA1-DIGEST | BINARY | SHA-1 결과 (git 객체 ID 같은 식별 용도) |

- 짝수·홀수로 짝지은 코드는 가변 길이 바이트열이다. 짝수 코드는 바이트 수가 짝수, 홀수 코드는 홀수다([레코드와 TAG WORD](/ko/grammar/record/)).
- 표에 없는 직접 코드는 예약이다.

## Issuer 형식

직접 코드에 없는 형식은 그 형식을 제정한 단체의 Issuer 아래 형식 번호로 둔다. 제정 단체가 없는 관례 형식은 ADHOC(`0x0001`), GEUL 고유 형식은 GEUL(`0x0000`) 아래에 둔다.

| Issuer | 형식 예 |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, 정수·실수 벡터, 텐서, 복소수, 분수, 구간, 사원수, BLAKE3 |
| IETF `0x0020` | 상대 URI, CRC32C, IPv4·IPv6 주소 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, POSIX 나노초 타임스탬프, MAC 주소 |
| KHRONOS `0x0041` | RGBA8·BGRA8 픽셀 |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | TAI 타임스탬프 |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | GPS 타임스탬프 |

- 형식을 모르는 디코더는 형식 번호의 계열만 알고 Payload를 건너뛴다.
- 이미지·영상 같은 큰 값은 직접 넣기보다 URI와 SHA-256으로 참조하기를 권장한다.
- 바이트열 안의 저작물은 원래 라이선스를 따른다. 출처와 라이선스는 Meta로 기록한다.

## 텍스트

언어가 있는 텍스트와 없는 텍스트는 다른 값이다. "Paris"(문자열)와 "Paris"(프랑스어)는 같지 않다.

| 형식 | 쓰는 곳 |
|---|---|
| UTF8-TEXT | 식별자, 코드, 파일 이름, 외부 ID처럼 언어가 없는 문자열 |
| UTF8-LANGUAGE-TEXT | 이름, 제목, 문장처럼 언어가 있는 텍스트 |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = 텍스트가 홀수 바이트)
[Length 확장 TAG]
언어              LANGUAGE-SHORT-CODE 또는 LANGUAGE-BCP47-CODE 레코드
텍스트            UTF-8 바이트 (홀수면 마지막 0x00)
```

- 텍스트는 well-formed UTF-8이며 원문 그대로 보존한다. 정규화는 비교·색인하는 쪽이 맡는다.
- 여러 언어에 공통인 이름은 언어 `mul`, 언어 미정은 `und`로 쓴다. 언어 내용이 없는 문자열은 UTF8-TEXT다.

예: `"Douglas Adams"@en` (13 바이트, 홀수)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   언어 en    D o  u g  l a  s ␠  A d  a m  s (패딩)
```

## 10진수와 수량

정확한 10진수는 `C × 10^E`로 쓴다. 지수 `E`는 32비트, 계수 `C`는 최소 WORD 2의 보수다. 원래 표기의 자릿수를 그대로 담는다: `1.20`은 `C=120, E=−2`, `1.2`는 `C=12, E=−1`이다. 두 값은 같은 수지만 유효숫자가 다르다.

QUANTITY는 양과 단위, 경계를 하나의 값으로 담는다.

```
TAG WORD          0000 1LLL L000 0110
[Length 확장 TAG]
양                SIGNED-DECIMAL 레코드
단위              Reference 레코드 (단위 항목), 무단위면 0x0000
하한              SIGNED-DECIMAL 레코드, 없으면 0x0000
상한              SIGNED-DECIMAL 레코드, 없으면 0x0000
```

- 단위는 값의 일부다. 단위를 떼어 다른 곳에 적지 않는다(떼면 `652`가 km인지 m인지 알 수 없다).
- SI 단위로 환산한 값은 담지 않는다. 단위와 환산표에서 계산할 수 있다.
- `0x0000`은 선택 필드를 생략했다는 표지다([Codec 규격 문서](/ko/grammar/codec-spec/)).

예: `652 km`, 범위 `[651, 653]` (km = 위키데이터 Q828224)

```
0F06 0011                    TAG (확장 길이 17 WORD)
0990 0000 0000 028C          양 652
0120 000C A340               단위 Q828224
0990 0000 0000 028B          하한 651
0990 0000 0000 028D          상한 653
```

## 날짜

| 정밀도 | 형식 |
|---|---|
| 날짜(그레고리력) | GREGORIAN-DATE |
| 연·월, 불확실(`1971~`), 구간 | EDTF |
| 다른 달력의 원본 표기(율리우스력 등) | GEDCOM-DATE |
| 시각 | POSIX·TAI·GPS 타임스탬프 |

- GREGORIAN-DATE로 쓸 수 있는 날짜는 EDTF로 쓰지 않는다.
