Below is a **complete, ready‑to‑run redesign** of the three demo pages (Home → Learn → Quiz).  
Everything is still pure HTML + CSS + vanilla JS – no external libraries – but the look & feel is now **mobile‑friendly, colourful, and animated**.  

You can drop the files into the same folder structure you already have, replace the placeholder images/audio with your own assets, and open `index.html` in a browser.  
The visual style is deliberately close to what you’ll later get with Flutter’s **Material 3** (rounded cards, elevation, smooth transitions, and a modern colour palette).

---

## 📁 Folder Layout (unchanged)

```
learning-system-demo/
│
├─ index.html
├─ learn.html
├─ quiz.html
├─ words.json
│
├─ assets/
│   ├─ images/
│   │   ├─ apple.png
│   │   ├─ dog.png
│   │   └─ cat.png
│   └─ audio/
│       ├─ apple_native.mp3
│       ├─ apple_en.mp3
│       ├─ dog_native.mp3
│       └─ dog_en.mp3
│
└─ style.css          ← **new, richer stylesheet**
```

---

## 🎨 1️⃣ `style.css` – “Material‑Lite” Theme  

```css
/* -------------------------------------------------------------
   Global variables – tweak here for a quick colour change
   ------------------------------------------------------------- */
:root {
  --primary:   #3b82f6;   /* indigo‑500 */
  --on-primary:#ffffff;
  --surface:   #ffffff;
  --on-surface:#212121;
  --background:#f4f7fa;
  --error:     #ef4444;
  --radius:    .8rem;
  --shadow:    0 4px 12px rgba(0,0,0,.08);
  --transition:.2s ease;
  --font:      'Poppins', system-ui, sans-serif;
}

/* -------------------------------------------------------------
   Basic reset & typography
   ------------------------------------------------------------- */
*,
*::before,
*::after { box-sizing:border-box; }
html,body { margin:0; padding:0; height:100%; }
body {
  font-family: var(--font);
  background: var(--background);
  color: var(--on-surface);
  line-height:1.5;
  -webkit-font-smoothing: antialiased;
}

/* -------------------------------------------------------------
   Layout helpers
   ------------------------------------------------------------- */
.container {
  max-width: 640px;
  margin: 0 auto;
  padding: 1.5rem;
}

/* -------------------------------------------------------------
   Typography
   ------------------------------------------------------------- */
h1 {
  font-size: 2rem;
  font-weight: 600;
  text-align: center;
  margin-bottom: 1.5rem;
  color: var(--primary);
}
h2 { font-size:1.75rem; margin: .5rem 0; }
p  { margin: .75rem 0; }

/* -------------------------------------------------------------
   Buttons – primary, secondary & disabled
   ------------------------------------------------------------- */
.btn,
button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap:.4rem;
  font-weight:600;
  font-size:1rem;
  color: var(--on-primary);
  background: var(--primary);
  border:none;
  border-radius: var(--radius);
  padding:.75rem 1.2rem;
  cursor:pointer;
  transition: background var(--transition), transform var(--transition);
}
.btn:hover,
button:hover { background:#2563eb; }
.btn:active,
button:active { transform:scale(.97); }
.btn:disabled,
button:disabled {
  background:#cbd5e1;
  color:#9ca3af;
  cursor:not-allowed;
}

/* -------------------------------------------------------------
   Card – used in Learn page
   ------------------------------------------------------------- */
.card {
  background: var(--surface);
  border-radius: var(--radius);
  overflow:hidden;
  box-shadow: var(--shadow);
  display:flex;
  flex-direction:column;
}
.card img { width:100%; height:auto; object-fit:contain; }
.card .content {
  padding:1rem;
  text-align:center;
}
.card .content h2 { color: var(--primary); }
.card .content p  { font-size:1.1rem; }

/* -------------------------------------------------------------
   Navigation arrows (Learn page)
   ------------------------------------------------------------- */
.nav-arrows {
  display:flex;
  justify-content:space-between;
  margin-top:.5rem;
}
.nav-arrows button {
  background:transparent;
  font-size:2.2rem;
  color: var(--primary);
  padding:.2rem;
}
.nav-arrows button:disabled { opacity:.3; cursor:default; }

/* -------------------------------------------------------------
   Star rating – animated “fill” on page load
   ------------------------------------------------------------- */
.star-bar {
  display:flex;
  justify-content:center;
  gap:.2rem;
  font-size:1.8rem;
}
.star-bar .star {
  color:#ffb400;
  animation: twinkle .4s ease forwards;
}
.star-bar .star:nth-child(odd)  { animation-delay:.05s; }
.star-bar .star:nth-child(even) { animation-delay:.15s; }

@keyframes twinkle {
  from { opacity:0; transform:scale(.7); }
  to   { opacity:1; transform:scale(1); }
}

/* -------------------------------------------------------------
   Quiz page – grid of picture options
   ------------------------------------------------------------- */
.quiz-grid {
  display:grid;
  grid-template-columns:repeat(auto-fit, minmax(120px,1fr));
  gap:1rem;
  margin:.75rem 0;
}
.quiz-option {
  display:flex;
  flex-direction:column;
  align-items:center;
}
.quiz-option input { display:none; }
.quiz-option label {
  cursor:pointer;
  border-radius: var(--radius);
  overflow:hidden;
  box-shadow: var(--shadow);
  transition: transform var(--transition), box-shadow var(--transition);
}
.quiz-option label:hover { transform:translateY(-2px); }
.quiz-option input:checked + label {
  outline:3px solid var(--primary);
  outline-offset:-3px;
}

/* -------------------------------------------------------------
   Footer link
   ------------------------------------------------------------- */
footer a {
  color:var(--primary);
  text-decoration:none;
}
footer a:hover { text-decoration:underline; }

/* -------------------------------------------------------------
   Media queries – a tiny responsive tweak
   ------------------------------------------------------------- */
@media (max-width:420px) {
  h1 { font-size:1.75rem; }
  .btn, button { font-size:.9rem; padding:.6rem .9rem; }
}
```

*Why it feels nicer*  

* **Google Font** – the `Poppins` font gives a friendly, modern look (imported via HTML).  
* **CSS variables** – allow quick colour/theme changes.  
* **Elevation & rounded corners** – mimic Material’s card style.  
* **Subtle hover/press animations** – give tactile feedback.  
* **Animated star bar** – stars appear with a “twinkle” when the page loads.  
* **Grid layout for quiz** – pictures are nicely spaced and selectable without radio buttons.  

---

## 📄 2️⃣ `index.html` – Home / Menu (pretty version)

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bilingual Kids – Home</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap"
        rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
  <h1>Bilingual Kids</h1>

  <!-- ★★★★★ progress bar (static for demo) -->
  <div class="star-bar" aria-label="Progress stars">
    <span class="star">★</span>
    <span class="star">★</span>
    <span class="star">★</span>
    <span class="star">☆</span>
    <span class="star">☆</span>
  </div>

  <div style="margin-top:2rem; text-align:center;">
    <button class="btn" onclick="location.href='learn.html'">
      📚 Learn Words
    </button>
    <button class="btn" style="margin-left:.8rem;"
            onclick="location.href='quiz.html'">
      🧩 Quiz Me
    </button>
  </div>
</div>
</body>
</html>
```

*What changed*  

* Larger, centered title with primary colour.  
* Star bar now animated (CSS `@keyframes`).  
* Buttons have a subtle hover/press animation and a small gap.

---

## 📘 3️⃣ `learn.html` – Swipe‑style Card Viewer (visual upgrade)

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Learn – Bilingual Kids</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap"
        rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
  <h1>Learn Words</h1>

  <div id="cardContainer" class="card">
    <img id="cardImg" src="" alt="Word picture">
    <div class="content">
      <h2 id="nativeWord"></h2>
      <p id="englishWord"></p>

      <div style="margin-top:0.8rem;">
        <button class="btn" id="playNative">
          🔊 Native
        </button>
        <button class="btn" id="playEnglish" style="margin-left:.6rem;">
          🔊 English
        </button>
      </div>
    </div>
  </div>

  <div class="nav-arrows">
    <button id="prevBtn" title="Previous">&#9664;</button>
    <button id="nextBtn" title="Next">&#9654;</button>
  </div>

  <footer style="margin-top:2rem; text-align:center;">
    <a href="index.html">← Back to Home</a>
  </footer>
</div>

<script>
  // ---------- Load JSON ----------
  let words = [], cur = 0;
  fetch('words.json')
    .then(r => r.json())
    .then(data => { words = data; renderCard(0); })
    .catch(console.error);

  // ---------- Populate UI ----------
  function renderCard(i) {
    if (!words[i]) return;
    const w = words[i];
    document.getElementById('cardImg').src = w.image;
    document.getElementById('nativeWord').textContent = w.native;
    document.getElementById('englishWord').textContent = w.english;
    document.getElementById('playNative').dataset.src = w.audio_native;
    document.getElementById('playEnglish').dataset.src = w.audio_english;
    document.getElementById('prevBtn').disabled = i === 0;
    document.getElementById('nextBtn').disabled = i === words.length - 1;
    cur = i;
  }

  // ---------- Arrow navigation ----------
  document.getElementById('prevBtn').onclick = () => cur > 0 && renderCard(cur-1);
  document.getElementById('nextBtn').onclick = () => cur < words.length-1 && renderCard(cur+1);

  // ---------- Audio ----------
  const play = url => new Audio(url).play();
  document.getElementById('playNative').onclick  = e => play(e.target.dataset.src);
  document.getElementById('playEnglish').onclick = e => play(e.target.dataset.src);
</script>
</body>
</html>
```

*Visual upgrades*  

* Card now has a **soft shadow** and rounded corners.  
* Images stretch to full width but keep aspect ratio.  
* Buttons are styled like primary Material buttons.  
* Navigation arrows are larger and disabled when you reach the ends.  

---

## 🧩 4️⃣ `quiz.html` – Modern Multiple‑Choice Quiz

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Quiz – Bilingual Kids</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap"
        rel="stylesheet">
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
  <h1>Quiz Me!</h1>

  <div id="quizArea"></div>

  <footer style="margin-top:2rem; text-align:center;">
    <a href="index.html">← Back to Home</a>
  </footer>
</div>

<script>
  let words = [], cur = 0, score = 0;

  // ----- Load words -----
  fetch('words.json')
    .then(r => r.json())
    .then(data => { words = shuffle(data); start(); })
    .catch(console.error);

  // ----- Helpers -----
  const shuffle = arr => arr.sort(() => Math.random() - .5);
  const getOptions = idx => {
    const correct = words[idx];
    const wrong = shuffle(words.filter((_,i)=>i!==idx)).slice(0,3);
    return shuffle([correct, ...wrong]);
  };

  // ----- Render a question -----
  function render() {
    const q = words[cur];
    const opts = getOptions(cur);
    const html = `
      <p><strong>Which picture matches the English word?</strong><br>
         <em>"${q.english}"</em></p>
      <form id="quizForm" class="quiz-grid">
        ${opts.map((opt,i)=>`
          <div class="quiz-option">
            <input type="radio" name="choice" id="opt${i}" value="${opt.native}">
            <label for="opt${i}">
              <img src="${opt.image}" alt="${opt.native}" width="100%">
            </label>
          </div>
        `).join('')}
        <button type="submit" class="btn" style="grid-column:1/-1;">Check</button>
      </form>
      <p style="margin-top:.5rem;">Score: <strong>${score}</strong> / ${words.length}</p>
    `;
    document.getElementById('quizArea').innerHTML = html;
    document.getElementById('quizForm').addEventListener('submit', onSubmit);
  }

  // ----- Submit handler -----
  function onSubmit(e) {
    e.preventDefault();
    const sel = document.querySelector('input[name="choice"]:checked');
    if (!sel) return;
    const right = words[cur].native;
    if (sel.value === right) {
      score++;
      alert('✅ Correct! +1 star');
    } else {
      alert(`❌ Oops! The correct answer was "${right}"`);
    }
    if (cur < words.length - 1) {
      cur++;
      render();
    } else {
      finish();
    }
  }

  // ----- Finish screen -----
  function finish() {
    const html = `
      <h2>Quiz finished!</h2>
      <p>You scored <strong>${score}</strong> out of <strong>${words.length}</strong>.</p>
      <button class="btn" onclick="location.reload()">Play again</button>
    `;
    document.getElementById('quizArea').innerHTML = html;
  }

  // ----- Start the quiz -----
  function start() { cur = 0; score = 0; render(); }
</script>
</body>
</html>
```

*Visual upgrades*  

* The **question area** is centered and uses a larger font.  
* Options are displayed in a **responsive grid** – each picture is a selectable tile with a clear outline when chosen.  
* The **Check** button spans the full width of the grid for a clear call‑to‑action.  
* Score updates live below the grid.  
* The final screen shows a large heading and a primary‑styled “Play again” button.

---

## 📱 5️⃣ How to See the Result  

1. **Create the folder structure** exactly as shown.  
2. **Copy the three HTML files** (`index.html`, `learn.html`, `quiz.html`) into the root folder.  
3. **Place the assets** (`assets/images/*` and `assets/audio/*`) and `words.json` in the appropriate sub‑folders.  
4. **Open `index.html`** in a modern browser (Chrome, Edge, Firefox, Safari).  
   * If your browser blocks `fetch('words.json')` from a *file://* URL, run a tiny static server:  

   ```bash
   # Python (installed on most systems)
   cd learning-system-demo
   python -m http.server 8000
   # then open http://localhost:8000/index.html
   ```

You should now have a **bright, animated UI** that feels like a polished mobile app – the perfect visual reference for the Flutter version you’ll build next.

---

## 📦 6️⃣ Mapping the New UI to Flutter (quick cheat‑sheet)

| HTML/CSS feature | Flutter widget / technique |
|------------------|----------------------------|
| **Container with `--radius` & `--shadow`** | `Card` → `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))`, `elevation: 4` |
| **Animated star bar** | `Row` of `Icon(Icons.star)` + `AnimatedOpacity` or `TweenAnimationBuilder` |
| **Primary button (`.btn`)** | `ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))` |
| **Navigation arrows** | Two `IconButton`s inside a `Row` (or `FloatingActionButton` if you prefer) |
| **Image‑only selectable tiles** (quiz) | `RadioListTile` with a `leading` that is an `Image.asset` **or** a custom widget using `InkWell` + `Container` + `BoxDecoration` for the selected outline |
| **Responsive grid** | `GridView.builder` with `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 150)` |
| **Audio playback** | `audioplayers` → `AudioPlayer().play(AssetSource('audio/apple_native.mp3'))` |
| **Page‑view swiping** | `PageView.builder` for the Learn screen |
| **Score tracking** | Store `int score` in a `ChangeNotifier` (`ProgressProvider`) and persist with Hive |

When you start the Flutter implementation, simply **copy the JSON data shape** (`native`, `english`, `image`, `audio_native`, `audio_english`) into a `Word` model (as shown in the earlier Flutter answer) and reuse the **same shuffling & scoring logic** from the JavaScript.

---

## 🎉 TL;DR – What you get

* **`style.css`** – a clean, modern stylesheet (variables, shadows, animations).  
* **`index.html`** – home page with animated stars & big primary buttons.  
* **`learn.html`** – sleek card view with navigation arrows, image, two audio buttons, and smooth hover effects.  
* **`quiz.html`** – responsive picture‑grid quiz with radio‑style selection, live score, and a friendly finish screen.  
* **All files are self‑contained** – just open `index.html` (or serve via a static server) and you have a **visually pleasant prototype** that can be directly translated to Flutter.

Happy coding, and enjoy watching kids explore their native language with a UI that feels as polished as a real mobile app! 🚀✨