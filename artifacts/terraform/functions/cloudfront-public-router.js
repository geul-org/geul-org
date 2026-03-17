function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // 410 Gone: 삭제된 DSL 섹션
    if (uri === '/dsl' || uri === '/dsl/' || /^\/(dsl\/|[a-z]{2}\/dsl[\/?])/.test(uri)) {
        return {
            statusCode: 410,
            statusDescription: 'Gone',
            headers: {
                'content-type': { value: 'text/html; charset=UTF-8' },
                'cache-control': { value: 'public, max-age=86400' }
            },
            body: '<!DOCTYPE html><html><head><meta charset="utf-8"><title>410 Gone</title><style>body{font-family:system-ui,sans-serif;max-width:480px;margin:80px auto;text-align:center;color:#333}h1{font-size:2rem}a{color:#0066cc}</style></head><body><h1>410 Gone</h1><p>This content has been permanently removed.</p><p><a href="/">geul.org</a></p></body></html>'
        };
    }

    // 홈: 언어 자동 리다이렉트 (쿠키 우선 → Accept-Language 폴백)
    if (uri === '/') {
        var nonEn = /^(ko|zh|es|ar|pt|id|ru|ja|fr|de|he)$/;

        // 1) lang 쿠키: 사용자가 수동 선택한 언어
        var langCookie = request.cookies && request.cookies['lang'];
        if (langCookie && nonEn.test(langCookie.value)) {
            return tempRedirect('/' + langCookie.value + '/');
        }

        // 2) 쿠키 없거나 en이면 Accept-Language 기반
        if (!langCookie || langCookie.value === 'en') {
            var al = request.headers['accept-language'];
            if (al) {
                var supported = {en:1,ko:1,zh:1,es:1,ar:1,pt:1,id:1,ru:1,ja:1,fr:1,de:1,he:1};
                var parts = al.value.split(',');
                var best = null;
                var bestQ = -1;
                for (var i = 0; i < parts.length; i++) {
                    var p = parts[i].trim().split(';');
                    var lang = p[0].trim().substring(0, 2).toLowerCase();
                    var q = 1;
                    if (p[1]) {
                        var m = p[1].match(/q=([\d.]+)/);
                        if (m) q = parseFloat(m[1]);
                    }
                    if (q > bestQ && supported[lang]) {
                        best = lang;
                        bestQ = q;
                    }
                }
                if (best && best !== 'en') {
                    return tempRedirect('/' + best + '/');
                }
            }
        }
    }

    // index.html 리라이트 (Hugo clean URL)
    if (uri.endsWith('/')) {
        request.uri = uri + 'index.html';
    } else if (!uri.includes('.')) {
        request.uri = uri + '/index.html';
    }
    return request;
}

function tempRedirect(to) {
    return {
        statusCode: 302,
        statusDescription: 'Found',
        headers: { location: { value: to } }
    };
}
