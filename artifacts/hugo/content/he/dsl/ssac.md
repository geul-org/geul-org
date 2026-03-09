---
title: "SSaC — Service Sequences as Code"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "מצהיר על לוגיקת שירות בהערות Go ומייצר קוד מימוש. 10 סוגי רצף קבועים מכסים את כל פעולות החוזה הבינארי בשכבת השירות."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — מייצר קוד שירות מ-DSL הערות Go.

לוגיקת שירות היא סדרה של החלטות: איזה מודל לשאול, ממה להתגונן, מתי לדחות, מה להחזיר. ההחלטות האלה שייכות למי שמבין את העסק — אבל הן נקברות בקוד תבניתי, מפוזרות בין שכבות ואובדות בשכתובים.

SSaC שומר את ההחלטות האלה כמפרט הצהרתי. אתה מצהיר **מה** קורה ו**באיזה סדר**. הכלי מייצר את המימוש.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## רעיון מרכזי

כל פונקציית שירות היא רצף של צעדים. כל צעד עוקב אחר חוזה בינארי: **הצלחה → השורה הבאה, כישלון → return**. זו לא הפשטה שהמצאנו — כך לוגיקת שירות כבר עובדת. SSaC הופך את זה למפורש.

10 סוגי רצף קבועים מכסים את כל פעולות שכבת השירות שעוקבות אחר חוזה זה. מה שלא מתאים מואצל ל-`call`. הקבוצה סגורה בתכנון.

ללא LLM, ללא הסקה — יצירת קוד סמלית טהורה מתבניות. המפרט הוא מקור האמת היחיד.

## דוגמה

```go
// @sequence get
// @model Project.FindByID
// @param ProjectID request
// @result project Project

// @sequence guard nil project
// @message "project not found"

// @sequence post
// @model Session.Create
// @param ProjectID request
// @param Command request
// @result session Session

// @sequence response json
// @var session
func CreateSession(w http.ResponseWriter, r *http.Request) {}
```

הצהרה זו בת 10 שורות מייצרת את הקוד הבא:

```go
func CreateSession(w http.ResponseWriter, r *http.Request) {
    projectID := r.FormValue("ProjectID")
    command := r.FormValue("Command")

    project, err := projectModel.FindByID(projectID)
    if err != nil {
        http.Error(w, "Project lookup failed", http.StatusInternalServerError)
        return
    }

    if project == nil {
        http.Error(w, "project not found", http.StatusNotFound)
        return
    }

    session, err := sessionModel.Create(projectID, command)
    if err != nil {
        http.Error(w, "Session creation failed", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "session": session,
    })
}
```

## סוגי רצף (10)

| סוג | תפקיד |
|---|---|
| `authorize` | בדיקת הרשאות (OPA וכו') |
| `get` | חיפוש משאב |
| `guard nil` | יציאה אם null |
| `guard exists` | יציאה אם קיים |
| `post` | יצירת משאב |
| `put` | עדכון משאב |
| `delete` | מחיקת משאב |
| `password` | השוואת סיסמה |
| `call` | קריאה חיצונית (@component / @func) |
| `response` | החזרת תגובה (json) |

## תכונות יצירת קוד

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
      allowed: [room, user]
```

## רישיון

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
