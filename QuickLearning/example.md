Below are **three tiny, stand‑alone HTML pages** that illustrate the same learning‑flow you will later implement in Flutter:

| Page | What it shows | How it maps to the Flutter app |
|------|----------------|--------------------------------|
| **index.html** | Home menu – “Learn” and “Quiz” buttons, progress stars | `HomeScreen` (Scaffold → buttons) |
| **learn.html** | Swipe‑like card view (left/right arrows) with picture, native word, English word, and two audio buttons | `LearnScreen` (`PageView` + `WordCard`) |
| **quiz.html** | Simple multiple‑choice quiz (question in English, 4 picture options, “Check” button, score) | `QuizScreen` (radio list + scoring) |

All three pages use **plain HTML + CSS + vanilla JavaScript** and a tiny **`words.json`** data file (the same shape you will use in Flutter).  
You can open the files locally in a browser – no server needed.

---

## 📁 Folder structure

```
learning‑system‑demo/
│
├─ index.html          ← Home / menu
├─ learn.html          ← Card‑viewer (learn mode)
├─ quiz.html           ← Multiple‑choice quiz
├─ words.json          ← Data source (native, english, image, audio)
│
├─ assets/
│   ├─ images/
│   │   ├─ apple.png
│   │   ├─ dog.png
│   │   └─ ... (add as many as you like)
│   └─ audio/
│       ├─ apple_native.mp3
│       ├─ apple_en.mp3
│       ├─ dog_native.mp3
│       └─ dog_en.mp3
│
└─ style.css           ← shared CSS (optional)
```

> **Tip:** Keep the same filenames (`apple.png`, `apple_native.mp3`, …) as in the JSON file – the JavaScript will load them directly.

---

## 1️⃣ `words.json` – the data source (identical to the model you will use in Flutter)

```json
[
  {
    "native": "Apfel",
    "english": "Apple",
    "image": "assets/images/apple.png",
    "audio_native": "assets/audio/apple_native.mp3",
    "audio_english": "assets/audio/apple_en.mp3"
  },
  {
    "native": "Hund",
    "english": "Dog",
    "image": "assets/images/dog.png",
    "audio_native": "assets/audio/dog_native.mp3",
    "audio_english": "assets/audio/dog_en.mp3"
  },
  {
    "native": "Katze",
    "english": "Cat",
    "image": "assets/images/cat.png",
    "audio_native": "assets/audio/cat_native.mp3",
    "audio_english": "assets/audio/cat_en.mp3"
  }
]
```

Feel free to add more objects – the UI pages will automatically adapt.

---

## 2️⃣ Shared CSS (`style.css`)

```css
/* style.css – a very light reset + colours */
* { box-sizing: border-box; margin:0; padding:0; }
body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background:#f9f9f9; color:#333; }
.container { max-width: 600px; margin:0 auto; padding:1rem; }
h1 { margin-bottom: 1rem; text-align:center; }
button, .btn { cursor:pointer; background:#0069d9; color:#fff; border:none; padding:.6rem 1rem; border-radius:.4rem; font-size:1rem; }
button:disabled, .btn:disabled { background:#aaa; cursor:not-allowed; }
.star { font-size:1.5rem; color:#ffcc00; }
.card { background:#fff; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,.1); overflow:hidden; margin:1rem 0; }
.card img { width:100%; height:auto; display:block; }
.card .content { padding:1rem; text-align:center; }
.nav-arrows { display:flex; justify-content:space-between; margin-top:.5rem; }
.nav-arrows button { background:transparent; font-size:2rem; color:#0069d9; }
.quiz-option { display:flex; align-items:center; margin:0.5rem 0; }
.quiz-option input { margin-right:.5rem; }
```

Link this file from every page (`<link rel="stylesheet" href="style.css">`).

---

## 3️⃣ `index.html` – Home / Menu

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bilingual Kids – Home</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
  <h1>Bilingual Kids</h1>

  <!-- ★★★★★ progress bar (static for demo) -->
  <div style="text-align:center; margin-bottom:1rem;">
    <span class="star">★</span>
    <span class="star">★</span>
    <span class="star">★</span>
    <span class="star">☆</span>
    <span class="star">☆</span>
  </div>

  <button class="btn" onclick="location.href='learn.html'">📚 Learn Words</button>
  <button class="btn" style="margin-left:0.5rem;" onclick="location.href='quiz.html'">🧩 Quiz Me</button>
</div>
</body>
</html>
```

**What you see**

* A title, a static “star” progress bar (replace with a real counter later).  
* Two big buttons that navigate to the two core screens.

---

## 4️⃣ `learn.html` – Swipe‑style Card Viewer

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Learn – Bilingual Kids</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
  <h1>Learn Words</h1>

  <div id="cardContainer" class="card">
    <!-- Content will be injected by JS -->
    <img id="cardImg" src="" alt="">
    <div class="content">
      <h2 id="nativeWord"></h2>
      <p id="englishWord"></p>

      <div style="margin-top:0.5rem;">
        <button class="btn" id="playNative">🔊 Native</button>
        <button class="btn" id="playEnglish" style="margin-left:0.5rem;">🔊 English</button>
      </div>
    </div>
  </div>

  <div class="nav-arrows">
    <button id="prevBtn" title="Previous">&#9664;</button>
    <button id="nextBtn" title="Next">&#9654;</button>
  </div>

  <p style="text-align:center; margin-top:1rem;">
    <a href="index.html">← Back to Home</a>
  </p>
</div>

<script>
  // ---------- 1️⃣ Load JSON ----------
  let words = [];
  let currentIdx = 0;

  fetch('words.json')
    .then(r => r.json())
    .then(data => {
      words = data;
      showCard(0);
    })
    .catch(err => console.error('Failed to load words.json', err));

  // ---------- 2️⃣ Populate UI ----------
  function showCard(idx) {
    if (!words[idx]) return;
    const w = words[idx];
    document.getElementById('cardImg').src = w.image;
    document.getElementById('nativeWord').textContent = w.native;
    document.getElementById('englishWord').textContent = w.english;
    // store audio URLs for the buttons
    document.getElementById('playNative').dataset.src = w.audio_native;
    document.getElementById('playEnglish').dataset.src = w.audio_english;
    // enable/disable arrows at ends
    document.getElementById('prevBtn').disabled = idx === 0;
    document.getElementById('nextBtn').disabled = idx === words.length - 1;
    currentIdx = idx;
  }

  // ---------- 3️⃣ Arrow navigation ----------
  document.getElementById('prevBtn').addEventListener('click', () => {
    if (currentIdx > 0) showCard(currentIdx - 1);
  });
  document.getElementById('nextBtn').addEventListener('click', () => {
    if (currentIdx < words.length - 1) showCard(currentIdx + 1);
  });

  // ---------- 4️⃣ Audio playback ----------
  function playAudio(url) {
    const audio = new Audio(url);
    audio.play();
  }

  document.getElementById('playNative').addEventListener('click', e => {
    playAudio(e.target.dataset.src);
  });
  document.getElementById('playEnglish').addEventListener('click', e => {
    playAudio(e.target.dataset.src);
  });
</script>
</body>
</html>
```

**Key points**

* The **card** contains an image, the native word (big heading), the English word (paragraph), and two audio buttons.  
* **Prev/Next** arrows let the kid flip through cards – this mimics the `PageView` in Flutter.  
* Audio is played with the native `Audio` object (`new Audio(url).play()`).

---

## 5️⃣ `quiz.html` – Simple Multiple‑Choice Quiz

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Quiz – Bilingual Kids</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
  <h1>Quiz Me!</h1>

  <div id="quizArea">
    <!-- Filled by JS -->
  </div>

  <p style="text-align:center; margin-top:1rem;">
    <a href="index.html">← Back to Home</a>
  </p>
</div>

<script>
  let words = [];
  let current = 0;
  let score = 0;

  // --------- Load words ----------
  fetch('words.json')
    .then(r => r.json())
    .then(data => {
      words = data;
      startQuiz();
    })
    .catch(err => console.error('words.json error', err));

  // --------- Helpers ----------
  function shuffle(arr) {
    return arr.sort(() => Math.random() - 0.5);
  }

  function getOptions(idx) {
    const correct = words[idx];
    // pick 3 random wrong words
    const wrong = shuffle(words.filter((_, i) => i !== idx)).slice(0, 3);
    const mixed = shuffle([correct, ...wrong]);
    return mixed;
  }

  // --------- Render a question ----------
  function renderQuestion() {
    const word = words[current];
    const options = getOptions(current);

    const html = `
      <p><strong>Which picture matches the English word?</strong> <em>"${word.english}"</em></p>
      <form id="quizForm">
        ${options.map((opt, i) => `
          <div class="quiz-option">
            <input type="radio" name="choice" id="opt${i}" value="${opt.native}">
            <label for="opt${i}"><img src="${opt.image}" alt="${opt.native}" style="height:80px;"></label>
          </div>
        `).join('')}
        <button type="submit" class="btn" style="margin-top:0.5rem;">Check</button>
      </form>
      <p style="margin-top:0.5rem;">Score: ${score} / ${words.length}</p>
    `;

    document.getElementById('quizArea').innerHTML = html;

    document.getElementById('quizForm').addEventListener('submit', e => {
      e.preventDefault();
      const selected = document.querySelector('input[name="choice"]:checked');
      if (!selected) return;
      const isCorrect = selected.value === word.native;
      if (isCorrect) {
        score++;
        alert('✅ Correct! +1 star');
      } else {
        alert(`❌ Oops! The right answer was "${word.native}"`);
      }
      // move to next question or finish
      if (current < words.length - 1) {
        current++;
        renderQuestion();
      } else {
        finishQuiz();
      }
    });
  }

  // --------- Start / finish ----------
  function startQuiz() {
    // randomise order of questions
    words = shuffle(words);
    current = 0;
    score = 0;
    renderQuestion();
  }

  function finishQuiz() {
    const html = `
      <h2>Quiz finished!</h2>
      <p>You scored <strong>${score}</strong> out of <strong>${words.length}</strong>.</p>
      <button class="btn" onclick="location.reload()">Play again</button>
    `;
    document.getElementById('quizArea').innerHTML = html;
  }
</script>
</body>
</html>
```

**What the kid experiences**

* The **English word** is shown as a prompt.  
* Four pictures are displayed as radio options (one correct, three distractors).  
* After pressing **Check**, a simple `alert()` tells if the answer is right and the score updates.  
* When all words are exhausted a “finished” screen appears.

---

## 📦 How to run the demo locally

1. **Create the folder** structure as shown above.  
2. **Copy the three HTML files** (`index.html`, `learn.html`, `quiz.html`) into the root folder.  
3. **Place the assets** (`images/`, `audio/`) and the `words.json` file in the appropriate sub‑folders.  
4. **Open `index.html`** in a modern browser (Chrome, Edge, Firefox, Safari).  
   * No server is required – the browser can load the local JSON because it’s a same‑origin file.  
   * If you experience a **CORS** error when opening the file directly, run a tiny static server (e.g., `python -m http.server 8000` in the folder) and open `http://localhost:8000/index.html`.

---

## 🎯 What you can reuse in Flutter

| Feature | HTML/JS implementation | Flutter equivalent |
|---------|------------------------|--------------------|
| **Data load** (`fetch('words.json')`) | `WordsProvider.loadLocal()` (read from `rootBundle`) |
| **Card UI** (`<div class="card">…</div>`) | `WordCard` widget (image + texts + audio buttons) |
| **Swipe navigation** (`prevBtn/nextBtn`) | `PageView` with `controller` |
| **Audio playback** (`new Audio(url).play()`) | `audioplayers` → `AudioPlayer.play(AssetSource(...))` |
| **Quiz generation** (random options, `alert`) | `QuizScreen` – same algorithm, but UI built with Flutter widgets (`RadioListTile`, `AlertDialog`) |
| **Progress stars** (`★`) | `StarBar` widget reading `UserProgress.stars` |
| **Navigation** (`location.href='learn.html'`) | `Navigator.push` / `Navigator.pop` |

You can **copy the JSON structure**, the **shuffling logic**, and the **scoring algorithm** directly into your Dart code – only the UI rendering changes from HTML tags to Flutter widgets.

---

## 🚀 Next Steps

1. **Prototype the UI** in a browser first – it’s instant to iterate.  
2. **Port the logic** (fetch, shuffle, scoring) into Dart files (`words_provider.dart`, `quiz_provider.dart`).  
3. Replace the HTML + JS UI with the Flutter widgets we discussed earlier (`Scaffold`, `AppBar`, `Card`, `PageView`, `RadioListTile`).  
4. Add **local persistence** (`Hive`) for the star count – you already have the JSON file, just store a small `UserProgress` object.  
5. (Optional) **Deploy the PHP endpoint** (`api/words.php`) you saw in the earlier answer so the app can download fresh word packs.

---

### 🎉 TL;DR – Ready‑to‑copy HTML files

```text
learning-system-demo/
│
├─ index.html       ← Home page (menu)
├─ learn.html       ← Card viewer (learn mode)
├─ quiz.html        ← Multiple‑choice quiz
├─ words.json       ← Data source (native, english, image, audio)
│
└─ assets/
    ├─ images/
    │   ├─ apple.png
    │   ├─ dog.png
    │   └─ cat.png
    └─ audio/
        ├─ apple_native.mp3
        ├─ apple_en.mp3
        ├─ dog_native.mp3
        └─ dog_en.mp3
```

Open `index.html` → click **Learn** or **Quiz** → see a simple, kid‑friendly learning flow that you can later reproduce in Flutter with the same data model and interaction pattern. Happy coding! 🚀