---
title: "Value — 시간"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TIME 계열(Codec `0x20`~`0x3F`, 형식 번호 `0x4000`~`0x7FFF`)의 날짜·시각 형식: 그레고리력 날짜, 타임스탬프, 경과 시간, EDTF, GEDCOM 날짜."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TIME 계열은 날짜와 시각 형식이다. 직접 코드 `0x20`~`0x3F`, Issuer 형식 번호 `0x4000`~`0x7FFF`에 둔다.

| 정밀도 | 형식 |
|---|---|
| 날짜(그레고리력) | GREGORIAN-DATE |
| 연·월, 불확실, 구간 | EDTF |
| 다른 달력의 원본 표기(율리우스력 등) | GEDCOM-DATE |
| 시각 | POSIX·TAI·GPS 타임스탬프 |
| 경과 시간 | DURATION-SECONDS, DURATION-NANOSECONDS |

- GREGORIAN-DATE로 쓸 수 있는 날짜는 EDTF로 쓰지 않는다.
- 나노초 타임스탬프와 TAI·GPS 형식은 각 표준 단체 Issuer(IEEE, BIPM, GPS) 아래의 형식이다.
