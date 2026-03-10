---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "הערת Go אחת היא רצף אחד. 10 סוגי רצף קבועים מכסים כל הסתעפות בינארית בשכבת השירות, ויצירת קוד סמלית מפיקה handlers של gin."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — הערת Go אחת היא רצף אחד. מצהירים — ונוצר handler של gin.

לוגיקת שירות היא סדרה של החלטות: איזה מודל לשאול, ממה להתגונן, מתי לדחות, מה להחזיר. ההחלטות האלה שייכות למי שמבין את העסק — אבל הן נקברות בקוד תבניתי, מפוזרות בין שכבות ואובדות בשכתובים.

SSaC שומר את ההחלטות האלה כמפרט הצהרתי. מצהירים **מה** קורה ו**באיזה סדר**, שורה אחת בכל פעם, והכלי מייצר את המימוש.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (DSL הערות)          (אימות)           (יצירת קוד)    (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">מאגר GitHub</a>

## רעיון מרכזי

כל פונקציית שירות היא רצף של צעדים. כל צעד עוקב אחר חוזה בינארי: **הצלחה → השורה הבאה, כישלון → return**. זו לא הפשטה שהמצאנו — כך לוגיקת שירות כבר עובדת. SSaC הופך את זה למפורש.

10 סוגי רצף קבועים מכסים את כל פעולות שכבת השירות שעוקבות אחר חוזה זה. מה שלא מתאים מואצל ל-`@call`. הקבוצה סגורה בתכנון.

ללא LLM, ללא הסקה — יצירת קוד סמלית טהורה מתבניות. המפרט הוא מקור האמת היחיד.

## תחביר — שורה אחת, רצף אחד

החל מ-v2, כל רצף הוא שורת הערה אחת. רק `@response` משתמש בבלוק מרובה שורות.

**CRUD — פעולות מודל**

```go
// @get Type var = Model.Method(args...)        — קריאה (תוצאה נדרשת)
// @post Type var = Model.Method(args...)       — יצירה (תוצאה נדרשת)
// @put Model.Method(args...)                   — עדכון (ללא תוצאה)
// @delete Model.Method(args...)                — מחיקה (ללא תוצאה)
```

פורמט ארגומנט: `source.Field` או `"ליטרל"`

- `request.CourseID` — מבקשת HTTP
- `course.InstructorID` — ממשתנה תוצאה קודם
- `currentUser.ID` — מהקשר האימות
- `"cancelled"` — ליטרל מחרוזת

**שומרים**

```go
// @empty target "message"                      — כישלון אם nil/zero (404)
// @exists target "message"                     — כישלון אם לא nil/zero (409)
```

יעד: משתנה (`course`) או משתנה.שדה (`course.InstructorID`)

**מעברי מצב**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**בדיקת הרשאות — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**קריאות חיצוניות**

```go
// @call Type var = package.Func(args...)       — עם תוצאה
// @call package.Func(args...)                  — ללא תוצאה
```

**תגובה — בלוק מיפוי שדות**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## דוגמה

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "אין הרשאה"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "ההזמנה לא נמצאה"
// @state reservation {status: reservation.Status} "cancel" "לא ניתן לבטל"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

הצהרה בת 10 שורות. כל שורה היא רצף אחד, מבוצע מלמעלה למטה לפי הסדר. הרשאות → קריאה → שומר → מעבר מצב → קריאה חיצונית → עדכון → קריאה חוזרת → תגובה.

## סוגי רצף (10)

| סוג | תפקיד |
|---|---|
| `@auth` | בדיקת הרשאות (מדיניות OPA) |
| `@get` | קריאת משאב |
| `@empty` | יציאה אם nil/zero (404) |
| `@exists` | יציאה אם לא nil/zero (409) |
| `@post` | יצירת משאב |
| `@put` | עדכון משאב |
| `@delete` | מחיקת משאב |
| `@state` | אימות מעבר מצב |
| `@call` | קריאת פונקציה מחבילה חיצונית |
| `@response` | החזרת תגובה (מיפוי שדות) |

## אימות

אימות פנימי (תמיד):
- ארגומנטים נדרשים חסרים לפי סוג
- פורמט `Model.Method`
- זרימת משתנים (הפניה לפני הצהרה)

אימות צולב מול SSOT חיצוני (כאשר מזוהה מבנה פרויקט):
- קיום מודל/מתודה (שאילתות sqlc, ממשקי Go)
- קיום שדות בקשה/תגובה (OpenAPI)
- קיום חבילה/פונקציה (ממשקי Go)
- אזהרת נתונים מיושנים: response אחרי put/delete ללא קריאה חוזרת (WARNING)
- קיום דיאגרמת מצב ותקינות מעברים
- קיום קובץ מדיניות OPA

## תכונות יצירת קוד

כאשר SSOT חיצוני (טבלאות סמלים) זמין, `ssac gen` מספק תכונות נוספות. הקוד המיוצר משתמש בפריימוורק gin.

- **המרת סוגים**: סוגי עמודות DDL → `strconv.ParseInt`, `time.Parse`, החזרת 400 Bad Request מוקדמת
- **סוגי ערך שומר**: בדיקות אפס מודעות סוג (`int` → `== 0`/`> 0`, מצביע → `== nil`/`!= nil`)
- **גזירת ממשק מודל**: הצלבת 3 מקורות SSOT → `<outDir>/model/models_gen.go`
- **יצירת קוד @state**: קריאה ל-`CanTransition` מחבילת דיאגרמת המצב
- **יצירת קוד @auth**: קריאה ל-`authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **יצירת קוד @call**: סגנון שומר (401) כשאין תוצאה, סגנון ערך (500) כשיש תוצאה
- **מבנה תיקיות דומיין**: `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## הרחבות x- של OpenAPI

פרמטרי תשתית (עימוד, מיון, סינון, הכללת יחסים) מוצהרים בהרחבות `x-` של OpenAPI. רק פרמטרים עסקיים מוצהרים במפרטי SSaC. מחולל הקוד קורא את הרחבות `x-` ובונה `QueryOpts` אוטומטית.

```yaml
/api/reservations:
  get:
    operationId: ListReservations
    x-pagination:
      style: offset
      defaultLimit: 20
      maxLimit: 100
    x-sort:
      allowed: [start_at, created_at]
      default: start_at
      direction: desc
    x-filter:
      allowed: [status, room_id]
    x-include:
      allowed: [room_id:rooms.id, user_id:users.id]
```

## רישיון

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">מאגר GitHub</a>
