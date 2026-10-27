---
title: "RGBA8-UNORM"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM은 R, G, B, A 순서의 UNORM8 네 성분을 Payload 2 WORD에 담는 픽셀 Value다(KHRONOS Issuer 형식 0x0000)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM은 R, G, B, A 네 UNORM8 성분을 고정 Payload 2 WORD에 packed 저장하는 Value다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0041` KHRONOS, 형식 번호 `0x0000`. 계열 NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  전체 5 WORD
Issuer            1 WORD  0x0041 (KHRONOS)
형식 번호         1 WORD  0x0000
Payload WORD 1st: [R: 상위 8bit][G: 하위 8bit]
Payload WORD 2nd: [B: 상위 8bit][A: 하위 8bit]
```

## 해석 규칙

- 직렬화 byte 순서는 `R, G, B, A`이며, 각 성분 byte `b`의 값은 `b / 255`다.
- 이는 Vulkan `VK_FORMAT_R8G8B8A8_UNORM`의 byte 0~3 component 순서와 UNORM 수치 mapping에 대응한다.
- `_SRGB` 형식이 아니므로 sRGB나 다른 색공간·transfer function을 암시하지 않는다. alpha도 UNORM 수치지만 straight/premultiplied 여부와 compositing 의미는 외부 문맥이다. ABI padding은 없다.

## 유효성

- 모든 8비트 패턴이 유효하다. Payload는 정확히 2 WORD여야 한다.

## 표준 근거와 형식 지위

- component memory order와 UNORM 의미는 Khronos의 [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html)과 [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html)의 `VK_FORMAT_R8G8B8A8_UNORM`에 맞춘다.
- GEUL TAG/Length와 두 16비트 big-endian WORD framing은 GEUL 고유 규칙이며, Vulkan image 자체의 serialization을 정의하지 않는다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD와 Payload 2 WORD를 합한 정확히 5 WORD이고 직접 길이 `LLLL=0100`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 2 WORD가 아니면 거부한다.

## 예시

- Payload `ff00 0080`은 bytes `R=ff, G=00, B=00, A=80`이다.
