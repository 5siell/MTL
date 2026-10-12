// Full-text search across every chapter linked from the table of contents.
// Pages are fetched the first time someone uses the box, so there is no index to keep up to date:
// add a chapter to the TOC and it becomes searchable automatically.
(function () {
    const input = document.getElementById('site-search');
    const results = document.getElementById('search-results');
    const status = document.getElementById('search-status');
    if (!input || !results) return;

    // Chapters = every TOC link to a local .html page, in TOC order.
    const chapters = [];
    const seen = new Set();
    document.querySelectorAll('main ul a[href$=".html"]').forEach(a => {
        const href = a.getAttribute('href');
        if (seen.has(href) || /^https?:/i.test(href)) return;
        seen.add(href);
        chapters.push({ href, title: a.textContent.replace(/\s+/g, ' ').replace(/_/g, ' ').trim() });
    });

    let loading = null;

    function load() {
        if (loading) return loading;
        status.textContent = 'Loading chapters…';
        const parser = new DOMParser();
        loading = Promise.all(chapters.map(ch =>
            fetch(encodeURI(ch.href))
                .then(r => r.ok ? r.text() : '')
                .then(html => {
                    const doc = parser.parseFromString(html, 'text/html');
                    const main = doc.querySelector('main') || doc.body;
                    if (main) main.querySelectorAll('script, style, nav').forEach(n => n.remove());
                    ch.text = main ? main.textContent.replace(/\s+/g, ' ').trim() : '';
                    ch.lower = ch.text.toLowerCase();
                })
                .catch(() => { ch.text = ''; ch.lower = ''; })
        )).then(() => { status.textContent = ''; });
        return loading;
    }

    function escapeHtml(s) {
        return s.replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
    }

    function highlight(text, terms) {
        let out = escapeHtml(text);
        terms.forEach(t => {
            const re = new RegExp('(' + escapeHtml(t).replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
            out = out.replace(re, '<mark>$1</mark>');
        });
        return out;
    }

    function snippet(ch, term) {
        const i = ch.lower.indexOf(term);
        if (i === -1) return ch.text.slice(0, 160) + (ch.text.length > 160 ? '…' : '');
        const start = Math.max(0, i - 70);
        const end = Math.min(ch.text.length, i + term.length + 110);
        return (start > 0 ? '…' : '') + ch.text.slice(start, end).trim() + (end < ch.text.length ? '…' : '');
    }

    function search() {
        const q = input.value.trim().toLowerCase();
        if (q.length < 2) {
            results.innerHTML = '';
            status.textContent = q.length ? 'Keep typing…' : '';
            return;
        }
        const terms = q.split(/\s+/).filter(Boolean);
        const hits = [];
        chapters.forEach(ch => {
            if (!ch.lower && !ch.title) return;
            const titleL = ch.title.toLowerCase();
            if (!terms.every(t => ch.lower.includes(t) || titleL.includes(t))) return;
            let score = 0;
            terms.forEach(t => {
                if (titleL.includes(t)) score += 50;
                score += Math.min(ch.lower.split(t).length - 1, 20);
            });
            if (titleL.includes(q)) score += 100;
            hits.push({ ch, score });
        });
        hits.sort((a, b) => b.score - a.score);

        status.textContent = hits.length
            ? hits.length + (hits.length === 1 ? ' chapter matches' : ' chapters match')
            : 'No matches for “' + input.value.trim() + '”';

        // Longest term is the most distinctive one to jump to inside the page.
        const jump = terms.slice().sort((a, b) => b.length - a.length)[0];
        results.innerHTML = hits.slice(0, 30).map(({ ch }) => {
            const inText = ch.lower.includes(jump);
            const href = encodeURI(ch.href) + (inText ? '#:~:text=' + encodeURIComponent(jump) : '');
            return '<li><a href="' + href + '">' + highlight(ch.title, terms) + '</a>' +
                '<p>' + highlight(snippet(ch, jump), terms) + '</p></li>';
        }).join('');
    }

    let timer;
    input.addEventListener('focus', load, { once: true });
    input.addEventListener('input', () => {
        clearTimeout(timer);
        timer = setTimeout(() => load().then(search), 120);
    });
    input.addEventListener('keydown', e => {
        if (e.key === 'Escape') { input.value = ''; search(); }
    });
    // Press "/" anywhere on the page to jump to the search box.
    document.addEventListener('keydown', e => {
        if (e.key === '/' && document.activeElement !== input) {
            e.preventDefault();
            input.focus();
        }
    });
})();
