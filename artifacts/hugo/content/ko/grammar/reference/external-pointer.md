---
title: "EXTERNAL-POINTER"
weight: 9
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER는 HEAD의 IMPORT-DOC으로 가져온 문서의 LOCAL ID를 가리키는 지시 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER는 HEAD의 [IMPORT-DOC](/ko/grammar/meta/import/import-doc/)으로 가져온 문서의 LOCAL ID를 가리키는 지시 Reference다.

## 레이아웃

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (섹션 1)
[Length 확장 TAG]
IMPORT ID         Codec이 정한 폭 (1/2/4 WORD)
대상 ID           나머지 전부. 가져온 문서의 LOCAL ID, 가장 짧은 폭
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | 이름 | IMPORT ID 폭 |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- 폭은 체계 번호로 정해진다: 체계 − 6(섹션 안 오프셋 `o = C & 0x1F`의 `o / 5`)이 0, 1, 2이면 1, 2, 4 WORD다. 양화는 `o % 5`다.

- IMPORT ID 값이 들어가는 가장 좁은 Codec을 쓴다.
- IMPORT ID는 이 문서의 `IMPORT-DOC`이 배정한 값이다. EXTERNAL-POINTER에는 Issuer를 적지 않는다. Issuer와 문서 ID는 그 `IMPORT-DOC`에서 얻는다. 버전도 그 `IMPORT-DOC`이 정한다(고정 또는 최신).
- 가져온 문서의 같은 LOCAL ID면, 그 문서 안에서 LOCAL로 쓰든 여기서 EXTERNAL-POINTER로 쓰든 같은 대상이다.
- Variable이면 가져온 문서의 LOCAL 변수다.

## 유효성

- 이 문서에 그 IMPORT ID를 배정한 `IMPORT-DOC`이 없으면 invalid다.
- IMPORT ID가 더 좁은 Codec에 들어가는데 넓은 Codec을 쓰면 non-minimal로 거부한다.
- 대상 ID가 `0`이면 invalid다. 가져온 문서 자신은 [DOC-POINTER](/ko/grammar/reference/doc-pointer/)로 가리킨다.
- 대상 ID의 선행 `0x0000` WORD는 금지한다.

## 예시

| 대상 | WORD sequence |
|---|---|
| IMPORT ID 1의 LOCAL 5 | `0202 0001 0005` |
| IMPORT ID 1의 LOCAL 65536 | `0203 0001 0001 0000` |
| IMPORT ID 70000의 LOCAL 5 | `0253 0001 1170 0005` |

## 관련 페이지

- [Reference](/ko/grammar/reference/), [LOCAL](/ko/grammar/reference/local/), [EXTERNAL-ISSUER](/ko/grammar/reference/external-issuer/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/)
- [IMPORT-DOC](/ko/grammar/meta/import/import-doc/)
