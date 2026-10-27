---
title: "Value — מספרים"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "פורמטי המספרים הבסיסיים של משפחת NUMERIC (Codec `0x00`~`0x0F`): BOOL, מספרים שלמים, נקודה צפה של IEEE 754, קואורדינטות של כדור הארץ וגרמי שמים, QUANTITY עם יחידה, ו-FRACTION, שבר ששומר על הכתיב שלו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

אלה פורמטי המספרים הבסיסיים של משפחת NUMERIC. הם מוצבים בקודים ישירים `0x00`~`0x0F` (שלושה ביטים עליונים של ה-Codec `000`) ובמספרי פורמט Issuer `0x0000`~`0x1FFF`.

- יש BOOL, מספרים שלמים עם סימן ובלי סימן, נקודה צפה בינארית של IEEE 754, קואורדינטות של כדור הארץ (WGS 84) ושל גרמי שמים, QUANTITY שמאגד כמות, יחידה וגבולות, ו-FRACTION, שבר כפי שנכתב במקור.
- מספר שלם נכתב במינימום ה-WORD שהערך נכנס בו.
- לפורמטי Issuer של סקלרים קטנים (BFLOAT16, FP8, FP4) הוקצו רק מספרי פורמט ואין להם מפרט מפורט (שאלה פתוחה ב-[Value](/he/grammar/value/#שאלות-פתוחות)).
- גם וקטורים, טנסורים, מספרים מרוכבים, שברים מצומצמים (RATIONAL-I64) וקטעים הם NUMERIC, אך מכיוון שהם פורמטי Issuer הם מוצבים בקבוצות [vector](/he/grammar/value/vector/), [tensor](/he/grammar/value/tensor/) ו-[etc](/he/grammar/value/etc/).
