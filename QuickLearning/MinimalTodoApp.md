## 📋 Goal  
Create a **minimal Todo app** in Flutter and see, step‑by‑step, how each piece maps to something you already know from PHP.  
You’ll end up with a single‑file `main.dart` that lets you:

1. Add a new todo item.  
2. Mark an item as done/undone.  
3. Delete an item.  
4. Keep the list on the device (no server needed).

For every Flutter step you’ll see the **equivalent PHP concept** and a **tiny code example** so the mental jump is immediate.

---

## 🗂️ 0️⃣ Prerequisites (the same for both worlds)

| What you need | PHP analogue | Flutter command |
|---------------|--------------|-----------------|
| **SDK / runtime** | `php` (CLI or Apache) | `flutter` (stable channel) |
| **Editor** | VS Code, PHPStorm, Nano | VS Code, Android Studio, IntelliJ |
| **Version control** | Git repo with `index.php` | Git repo with `lib/main.dart` |

> **Tip:** If you already have a PHP project on GitHub, just create a new branch/folder for the Flutter code – you’ll keep everything in the same repo if you like.

```bash
# Install Flutter (macOS / Linux / Windows)
brew install --cask flutter   # macOS
# or download from https://flutter.dev
flutter doctor               # make sure everything is green
```

---

## 📂 1️⃣ Create a fresh Flutter project  

| PHP step | Flutter step | Explanation |
|----------|--------------|-------------|
| **Create a folder** – `mkdir my_app && cd my_app` | `flutter create todo_app` | Generates the standard Flutter skeleton (`android/`, `ios/`, `lib/` …). |
| **Run the server** – `php -S localhost:8000` | `flutter run` | Starts the app on an attached device, emulator, or web browser. |
| **Edit `index.php`** | Edit `lib/main.dart` | All UI lives in Dart code, not in separate HTML files. |

```bash
flutter create todo_app
cd todo_app
flutter run            # opens a blue “Flutter Demo” on your device
```

---

## 🧩 2️⃣ Core Language Concepts (PHP ↔ Dart)

| Concept | PHP example | Dart (Flutter) example |
|---------|-------------|------------------------|
| **Entry point** | `<?php echo "Hi"; ?>` | `void main() => runApp(const MyApp());` |
| **Variables** | `$title = "Buy milk";` | `String title = "Buy milk";` |
| **Null‑safety** | `$name = null; // may crash later` | `String? name; // must check or use ??` |
| **String interpolation** | `"Hello $name"` | `"Hello $name"` (identical) |
| **List / array** | `$list = [1,2,3];` | `List<int> list = [1, 2, 3];` |
| **Map / associative array** | `$map = ['city'=>'Paris'];` | `Map<String, String> map = {'city':'Paris'};` |
| **Function** | `function add($a,$b){return $a+$b;}` | `int add(int a, int b) => a + b;` |
| **Class** | `class User { public $name; function __construct($n){$this->name=$n;} }` | `class User { final String name; User(this.name); }` |
| **Async / await** | Blocking `file_get_contents($url);` | `Future<String> fetch() async { await Future.delayed(...); return 'data'; }` |

> **Why this matters:** Flutter UI is **reactive** – when a Dart variable changes, the UI rebuilds automatically (via `setState` / Provider). In PHP you would re‑render the page on each request.

---

## 📦 3️⃣ Add Packages (Composer ↔ pub)

| PHP (Composer) | Flutter (pub) | Reason |
|----------------|----------------|--------|
| `composer require monolog/monolog` | `flutter pub add provider` | Provider gives you a global state object similar to a PHP `$_SESSION`. |
| `composer require vlucas/phpdotenv` | `flutter pub add hive hive_flutter` | Hive stores data locally like writing a JSON file (`file_put_contents`). |

```bash
flutter pub add provider
flutter pub add hive hive_flutter
```

> **Result:** `pubspec.yaml` now contains the two dependencies; run `flutter pub get` (done automatically).

---

## 🗂️ 4️⃣ Data Model – TodoItem  

| PHP (flat‑file JSON) | Flutter (Hive) |
|----------------------|----------------|
| ```php $todos = json_decode(file_get_contents('todos.json'), true); ``` | ```dart @HiveType(typeId: 0) class TodoItem extends HiveObject { @HiveField(0) late String title; @HiveField(1) bool done = false; } ``` |
| **Add** – `$todos[] = ['title'=>$t,'done'=>false]; file_put_contents('todos.json', json_encode($todos));` | **Add** – `await box.add(TodoItem()..title = t);` |
| **Toggle** – `$todos[$i]['done'] = !$todos[$i]['done'];` | **Toggle** – `item.done = !item.done; await item.save();` |
| **Delete** – `array_splice($todos,$i,1);` | **Delete** – `await item.delete();` |

### 4.1 Generate Hive adapter (one‑time)

```bash
flutter packages pub run build_runner build   # creates main.g.dart with TodoItemAdapter
```

---

## 🏗️ 5️⃣ State Management – Provider  

| PHP concept | Flutter Provider |
|-------------|------------------|
| **Session** (`$_SESSION['todos'] = $todos;`) | **ChangeNotifier** (`TodoModel` holds a Hive `Box` and notifies listeners). |
| **`$_POST` handling** | UI callbacks (`onPressed`, `onChanged`). |

### 5.1 TodoModel (the “session”)

```dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoModel extends ChangeNotifier {
  late Box<TodoItem> _box;

  List<TodoItem> get items => _box.values.toList();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoItemAdapter());
    _box = await Hive.openBox<TodoItem>('todos');
    notifyListeners();          // UI will rebuild once the box is ready
  }

  void add(String title) {
    _box.add(TodoItem()..title = title);
    notifyListeners();
  }

  void toggle(TodoItem item) {
    item.done = !item.done;
    item.save();                 // writes back to the Hive file
    notifyListeners();
  }

  void delete(TodoItem item) {
    item.delete();
    notifyListeners();
  }
}
```

> **PHP parallel:** Think of `TodoModel` as a class that loads `$todos` from a file in its constructor and then provides `add()`, `toggle()`, `delete()` methods that also update the file.

---

## 🖼️ 6️⃣ UI – From HTML/PHP to Widgets  

| PHP view (HTML) | Flutter widget tree |
|-----------------|----------------------|
| `<ul><li>Buy milk <a href="?toggle=1">✔</a></li></ul>` | `ListView.builder(itemCount: ..., itemBuilder: (_,i)=>ListTile(...))` |
| `<form method="post"><input name="title"><button>Add</button></form>` | `Row(TextField(controller:...), IconButton(onPressed: …))` |
| `header.php` | `AppBar(title: Text('Todo'))` |

### 6.1 Full `main.dart`

```dart
// ────────────────────────────────────────────────────────────────────────
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ----------- 1️⃣ Hive data model (same as PHP JSON structure) ----------
part 'main.g.dart';                     // generated adapter

@HiveType(typeId: 0)
class TodoItem extends HiveObject {
  @HiveField(0) late String title;
  @HiveField(1) bool done = false;
}

// ----------- 2️⃣ State (PHP $_SESSION analogue) -------------------------
class TodoModel extends ChangeNotifier {
  late Box<TodoItem> _box;

  List<TodoItem> get items => _box.values.toList();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoItemAdapter());
    _box = await Hive.openBox<TodoItem>('todos');
    notifyListeners();
  }

  void add(String title) {
    _box.add(TodoItem()..title = title);
    notifyListeners();
  }

  void toggle(TodoItem item) {
    item.done = !item.done;
    item.save();
    notifyListeners();
  }

  void delete(TodoItem item) {
    item.delete();
    notifyListeners();
  }
}

// ----------- 3️⃣ Entry point (PHP's index.php) -------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = TodoModel();
  await model.init();                         // load persisted data
  runApp(
    ChangeNotifierProvider.value(
      value: model,
      child: const MyApp(),
    ),
  );
}

// ----------- 4️⃣ Root widget (HTML <body>) -----------------------------
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Todo (Flutter)',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const TodoScreen(),
      );
}

// ----------- 5️⃣ Todo screen (HTML <ul> + <form>) --------------------
class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TodoModel>(context);
    final txtCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo (Flutter)')),
      body: Column(
        children: [
          // ---- 5.1 Input form (PHP <form>) ----
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: txtCtrl,
                  decoration: const InputDecoration(labelText: 'New task'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final t = txtCtrl.text.trim();
                  if (t.isNotEmpty) {
                    model.add(t);
                    txtCtrl.clear();
                  }
                },
              )
            ]),
          ),
          const Divider(),
          // ---- 5.2 List of todos (PHP foreach) ----
          Expanded(
            child: ListView.builder(
              itemCount: model.items.length,
              itemBuilder: (_, i) {
                final item = model.items[i];
                return ListTile(
                  leading: Checkbox(
                    value: item.done,
                    onChanged: (_) => model.toggle(item),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                        decoration:
                            item.done ? TextDecoration.lineThrough : null),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => model.delete(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

**What each block maps to in PHP**

| Block | PHP analogue |
|-------|--------------|
| `main()` + `runApp` | `index.php` that includes all other files |
| `TodoModel` (`ChangeNotifier`) | `$_SESSION['todos']` + helper functions (`addTodo()`, `toggleTodo()`, `deleteTodo()`) |
| `Hive` box | `file_put_contents('todos.json', …)` |
| `Scaffold → AppBar` | `include 'header.php'` |
| `TextField + IconButton` | `<form method="post"><input name="title"><button>Add</button></form>` |
| `ListView.builder` + `ListTile` | `<ul><?php foreach($todos as $i=>$t){ … }</ul>` |
| `Checkbox` `onChanged` | `<a href="?toggle=$i">✔</a>` |
| `IconButton(delete)` | `<a href="?del=$i">✖</a>` |
| `Provider.of<TodoModel>` | `$_SESSION` accessed anywhere in the script |

---

## 🔄 7️⃣ Hot‑Reload – The Flutter “instant refresh”

| PHP workflow | Flutter workflow |
|--------------|------------------|
| Edit `index.php` → refresh browser → whole page reloads. | Edit Dart code → press **r** (or the IDE’s lightning bolt) → **only the changed widget tree rebuilds**, preserving UI state (e.g., scroll position). |

**Try it:** Change the AppBar title from `'Todo (Flutter)'` to `'My Tasks'`. Press **r** – the title updates instantly, the list you already added stays on screen.

---

## 💾 8️⃣ Persistence – Hive vs. PHP flat file  

| Action | PHP (file) | Flutter (Hive) |
|--------|------------|----------------|
| **Initial load** | `$todos = json_decode(file_get_contents('todos.json'), true) ?? [];` | `await Hive.openBox<TodoItem>('todos')` |
| **Save after change** | `file_put_contents('todos.json', json_encode($todos));` | `item.save()` or `box.add(...)` – Hive writes immediately. |
| **Where the file lives** | `./todos.json` on the server | `.../Documents/Flutter/hive/todos.hive` on the device (no server needed). |

> **Result:** Your mobile app works offline – exactly like a PHP script that reads/writes a local JSON file, but the file is on the phone instead of a server.

---

## ✅ 9️⃣ Quick Test – Verify everything works

```bash
flutter run          # launch on emulator / connected device
```

1. Type “Buy milk” → press **+** → item appears.  
2. Tap the checkbox → line‑through appears (toggle).  
3. Tap the trash icon → item disappears.  
4. Close the app, reopen – the list is still there (Hive persisted it).

If any of those steps fail, check the console output; most errors are either missing Hive adapter generation or forgetting to call `model.init()` before `runApp`.

---

## 🧪 10️⃣ Optional: Unit / Widget Test (PHPUnit ↔ flutter test)

### PHP unit test (example)

```php
// tests/TodoTest.php
use PHPUnit\Framework\TestCase;

class TodoTest extends TestCase {
    public function testAdd() {
        $todos = [];
        $todos[] = ['title'=>'Buy milk','done'=>false];
        $this->assertCount(1, $todos);
    }
}
```

Run: `phpunit tests`.

### Flutter test (equivalent)

Create `test/todo_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart';   // <- adjust import to your package name

void main() {
  test('TodoModel adds an item', () async {
    final model = TodoModel();
    await model.init();               // opens Hive (in test it creates a temp dir)
    final initial = model.items.length;
    model.add('Buy milk');
    expect(model.items.length, initial + 1);
    expect(model.items.last.title, 'Buy milk');
  });
}
```

Run: `flutter test`.

> **Takeaway:** Testing in Flutter is as straightforward as PHPUnit – you just import the Dart class and call its methods.

---

## 🚀 11️⃣ Deploy / Distribution  

| PHP deployment | Flutter deployment |
|----------------|--------------------|
| Upload all `.php` files to a web host (`scp`/FTP). | `flutter build apk --release` → upload the APK to Google Play, or `flutter build web` → copy `build/web/` to any static web server (e.g., GitHub Pages). |
| Use Apache/Nginx config (`.htaccess`). | No server config needed; the compiled binary contains everything. |

**One‑liner build for Android:**

```bash
flutter build apk --release
# the file is at build/app/outputs/flutter-apk/app-release.apk
```

---

## 📚 TL;DR Summary – Step‑by‑Step Checklist

| # | Step | PHP ↔ Flutter | Command / Code |
|---|------|---------------|----------------|
| 0 | Install SDK | `php -v` vs `flutter doctor` | `brew install flutter` |
| 1 | Scaffold project | `mkdir todo && cd todo` vs `flutter create todo_app` | `flutter create todo_app` |
| 2 | Add deps | `composer require ...` vs `flutter pub add provider hive hive_flutter` | `flutter pub add provider` |
| 3 | Define data model | JSON file (`todos.json`) vs Hive `TodoItem` class | See `@HiveType` block |
| 4 | State container | `$_SESSION` vs `ChangeNotifier` (`TodoModel`) | `class TodoModel extends ChangeNotifier { … }` |
| 5 | UI layout | HTML `<ul>` + `<form>` vs `Scaffold → ListView.builder → TextField` | Full `TodoScreen` widget |
| 6 | Persistence | `file_put_contents` vs `Hive` (`box.add`, `item.save`) | `await Hive.initFlutter();` |
| 7 | Interaction | POST → `$_POST` vs `onPressed`, `onChanged` callbacks | `model.add(txtCtrl.text);` |
| 8 | Hot‑reload | Browser refresh vs **r** in terminal | Press **r** or IDE lightning |
| 9 | Test | PHPUnit vs `flutter test` | `flutter test` |
|10| Deploy | FTP/SSH vs `flutter build apk|web` | `flutter build apk --release` |

---

### 🎉 You’re done!

You now have a **fully functional Todo app** written in Flutter, with every piece clearly linked to a PHP concept you already understand.  

From here you can:

* Replace Hive with a remote REST API (just like you’d call a PHP endpoint).  
* Swap Provider for Riverpod, Bloc, or GetX – the UI code stays the same.  
* Add authentication, theming, or animations – the same patterns apply.

Happy coding, and enjoy the cross‑language perspective! 🚀