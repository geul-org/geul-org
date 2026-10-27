---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL הוא Reference מסוג הצהרה שמצביע על יעד באמצעות ID שהמסמך הזה הנפיק. גם Edge Id הוא LOCAL."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL הוא Reference מסוג הצהרה שמצביע על יעד באמצעות ID שהמסמך הזה הנפיק. הוא מפנה ליעדים בתוך המסמך בלי Issuer חיצוני, ואין לו משמעות מחוץ למסמך. כדי להצביע עליו מחוץ למסמך, מציבים במסמך Meta [DOC-ID](/he/grammar/meta/declaration/doc-id/), ומסמך אחר מצביע עליו ב-Reference מצביע.

## פריסה

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[Length extension TAG]
LOCAL ID          unsigned big-endian ברוחב הקצר ביותר
```

| LOCAL ID | סך הכול | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- ה-TAG WORD הוא `0000 0 LLLL 0001 QQQ`. ב-Identified (`000`) 7 הביטים התחתונים הם `0x08`.
- עוקבים אחרי הכלל המשותף של Reference לכתיבת ID של יעד במספר ה-WORD הקטן ביותר.

## Edge Id

- ה-LOCAL שהוא הרכיב הראשון ב-Payload של Edge הוא ההצהרה על ה-Edge Id של אותה Edge ([Edge](/he/grammar/edge/)). ה-Quantifier של LOCAL שמצהיר על Edge Id הוא `000` בלבד.
- LOCAL בכל מקום אחר ב-Payload של Edge הוא אזכור. יעד של המסמך הזה נכתב כ-LOCAL בכל אזכור. אין קוד הצבעה נפרד ליעד של המסמך הזה.

## הקצאת מזהים

- ה-ID הוא מספר שלם והמקודד מקצה אותו. לגודל המספר ולסדר ההקצאה אין משמעות מלבד זהות.
- **UNIQUE (חובה).** במסמך אחד LOCAL ID אחד מצביע על יעד אחד בלבד. Edge Id מוצהר פעם אחת בכל מסמך (Edge ב-HEAD ו-Edge ב-BODY חולקות מרחב מספרים אחד). אם יותר מ-Edge אחת מצהירה על אותו Edge Id, זה invalid.
- **AUTO INCREMENT (המלצה).** ID חדש מוקצה כערך המרבי של ה-ID שהוקצו עד כה במסמך + 1, וגדל לפי סדר המסמך. כך גם לאורך גרסאות (יוצרים ערך חדש גדול מה-ID שנמחק). זו המלצה בלבד ולא תנאי תקינות, ומסמך שאינו עולה הוא גם valid. המפענח אינו נשען על גודל ה-ID או על רציפותו.
- ID `0` אינו מוקצה. הוא אינו מצביע על שום יעד ואינו משמש כ-Edge Id. מקצים ID של יעד מ-`1`.
- מסמך, בתוך המסמך או מחוצה לו, מוצבע רק באמצעות [DOC-POINTER](/he/grammar/reference/doc-pointer/) אחד (המסמך עצמו הוא ה-DOC-POINTER של ה-`DOC-ID` שלו). אפשר לצרף למסמך גם `BIND`, `LABEL` ו-Edge הכרעה.
- ה-Issuer עצמו מוצבע באמצעות [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/). מזהה מסמך `0` הוא מסמך אינדקס הגדרות המונחים של ה-Issuer.
- ב-Codec שנותן משמעות ל-`0` במקום של רכיב ([TOULMIN](/he/grammar/edge/toulmin/): "אין" של REF ושל Edge ביצוע, "המסמך כולו" ב-Target של [SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) ב-HEAD) נוהגים לפי כלל ה-Codec. זו הסכמה בתוך אותו Codec, שונה מ[סמן מקום](/he/grammar/reference/slot-marker/).
- ID שהוקצה פעם אחת לא משתמשים בו שוב באותו מסמך.
- תמיד משתמשים ברוחב המינימלי שמסוגל לבטא את הערך.

## זהות ותחום

- באותו מסמך, LOCAL ID בעל ערך מספרי זהה הוא אותו יעד. רוחב הקידוד אינו חלק מהזהות.
- LOCAL מסוג Identified מייצג יעד מזוהה. לא משתמשים בו למטרות של אנונימי, לא מוגדר, null או sentinel. הדברים "יש ערך אך לא ידוע" (UNKNOWN-VALUE) ו"אין ערך" (NO-VALUE) נכתבים בשדה שמקבל את הסמנים האלה כ[סמן מקום](/he/grammar/reference/slot-marker/).
- LOCAL ID שונים הם רק Reference שונים, ולא אומרים שגם היעדים במציאות שונים.
- אין להרחיב את הזהות של LOCAL אל מחוץ למסמך. אותו מספר במסמך אחר אינו קשור.
- LOCAL מסוג Variable (`100`) הוא משתנה שיח בעל שם (Variable ב-[Reference](/he/grammar/reference/)).

## מיזוג

כשממזגים כמה מסמכים למסמך אחד, יוצרים לכל מסמך מקור טבלת התאמה `old ID → new ID`, מקצים מחדש את כל ה-LOCAL ID ל-ID של המסמך החדש ומחליפים את כל ההפניות.

- ID שהיו זהים באותו מסמך מקור חייבים להישאר זהים גם אחרי המיזוג.
- אותו מספר במסמכי מקור שונים אינו קשור, ואין למזג אותם אוטומטית ל-Reference זהה.
- אם נשאר LOCAL אחד שלא הוחלף, דוחים את המיזוג.

## תקינות

הקידודים וההקצאות הבאים הם invalid.

- קידוד לא מינימלי שיש בו WORD מוביל של `0x0000` (החריג הוא `0x0000` של WORD אחד עבור הערך 0)
- מקרה שבו ה-Quantifier במקום ההצהרה על Edge Id אינו `000` או שה-ID הוא `0`
- מקרה שבו מקצים ID אחד לכמה יעדים שונים באותו מסמך
- מקרה שבו אותו Edge Id מוצהר פעמיים או יותר באותו מסמך

## דוגמה

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1, Variable | `008C 0001` |

## דפים קשורים

- [Reference](/he/grammar/reference/), [DOC-POINTER](/he/grammar/reference/doc-pointer/), [ISSUER-POINTER](/he/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/he/grammar/reference/external-pointer/)
- [Edge](/he/grammar/edge/)
