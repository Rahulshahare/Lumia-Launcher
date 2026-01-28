## ⚡️ Flutter vs PHP – “Learn Flutter by Seeing the PHP Equivalent”

Below you’ll find **the same programming idea expressed once in PHP and once in Flutter (Dart)**.  
Read the **concept**, glance at the **PHP snippet you already know**, then study the **Flutter/Dart counterpart**.  
Copy the Dart code into `lib/main.dart` of a fresh Flutter project (`flutter create my_app`) and run it – you’ll see the same behaviour you get from the PHP example, only on a mobile/desktop/web UI instead of a server‑side page.

---

### 📦 1️⃣ Project Setup  

| What you do | PHP | Flutter |
|-------------|-----|----------|
| **Install the SDK** | `apt‑get install php` (or XAMPP) – you already have a runtime. | `brew install flutter` / download from <https://flutter.dev> and run `flutter doctor`. |
| **Create a starter** | `php -S localhost:8000` – serve any folder. | `flutter create hello_world` → `cd hello_world` → `flutter run`. |
| **Run / hot reload** | Refresh the browser. | Press **r** in the terminal **or** click the lightning bolt in VS Code/Android Studio – UI updates instantly without rebuilding. |

---

### 🧩 2️⃣ Language Basics (Dart vs PHP)

| Concept | PHP (≈) | Dart (Flutter) | Quick notes |
|---------|----------|----------------|------------|
| **Entry point** | `<?php echo "Hello"; ?>` | `void main() => runApp(const MyApp());` | `runApp` boots the Flutter widget tree. |
| **Variables & Types** | `$age = 27; // int` | `int age = 27;` | Dart is **statically typed** (type inference works with `var`). |
| **Null‑safety** | `$name = null;` (runtime error if used) | `String? name;` – you must check or use `??`. |
| **String interpolation** | `"Hello $name"` | `"Hello $name"` (identical! but use double quotes). |
| **Arrays / Lists** | `$arr = [1,2,3];` | `List<int> arr = [1, 2, 3];` |
| **Associative arrays / Maps** | `$map = ['city'=>'Paris'];` | `Map<String, String> map = {'city':'Paris'};` |
| **Functions** | `function add($a,$b){return $a+$b;}` | `int add(int a, int b) => a + b;` |
| **Anonymous functions (closures)** | `array_map(fn($x)=>$x*2,$arr);` | `arr.map((x) => x * 2).toList();` |
| **Async / Await** | `file_get_contents($url);` (blocking) | `Future<String> fetch() async { await Future.delayed(...); return 'data'; }` |
| **Classes** | `class User { public $name; function __construct($n){$this->name=$n;} }` | `class User { final String name; User(this.name); }` |
| **Inheritance** | `class Admin extends User {}` | `class Admin extends User {}` (same syntax, but `extends` only, no `implements` mixins). |
| **Visibility** | `public`, `protected`, `private` | `public` (default), `protected`, `private` (`_field`). |
| **Static members** | `User::$counter` | `User.counter` (static) |
| **Interfaces** | `interface Jsonable { public function toJson(); }` | `abstract class Jsonable { String toJson(); }` (or `mixin`). |

> **Exercise:** Create a `Person` class in Dart that mirrors a PHP class you already have, then instantiate it in `main()` and `print` its fields.

---

### 🎨 3️⃣ UI Rendering – From HTML/PHP to Widgets

| Concept | PHP (HTML) | Flutter (Widgets) | How to think about it |
|---------|------------|-------------------|----------------------|
| **Template / view file** | `index.php` contains `<div><?= $title ?></div>` | `Widget build(BuildContext ctx) => Text(title);` | A widget **is** a UI element; you compose them like HTML tags. |
| **Conditional display** | `<?php if($logged){ echo "<p>Hi</p>"; } ?>` | `if (logged) Text('Hi') else SizedBox.shrink()` | In Dart you return *nothing* with `SizedBox.shrink()` (zero‑size). |
| **Loop over items** | ```php foreach($posts as $p){ echo "<li>$p</li>"; } ``` | ```dart ListView.builder(itemCount: posts.length, itemBuilder: (_, i) => ListTile(title: Text(posts[i]))); ``` | `ListView.builder` lazily builds each row, like a PHP `foreach` inside `<ul>`. |
| **Include / partials** | `include 'header.php';` | `Widget Header() => AppBar(title: Text('MyApp'));` | Extract a widget into its own class or function and reuse. |
| **Form handling** | `<form method="post"><input name="msg"></form>` + `$_POST['msg']` | `TextField(controller: _c)` + `onPressed: () => print(_c.text)` | No request/response cycle; you handle events directly in code. |
| **Routing / URL mapping** | `.htaccess` → `index.php?page=home` | `Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()))` | Flutter navigation is a *stack* of pages (widgets). |

---

### 📡 4️⃣ Data / Backend Interaction  

| Operation | PHP (server‑side) | Flutter (client‑side) |
|-----------|-------------------|-----------------------|
| **Read a DB row** | ```php $pdo->query('SELECT * FROM users')->fetch(); ``` | ```dart final rows = await db.query('SELECT * FROM users');``` (using **sqflite** or **Hive**). |
| **Insert with prepared stmt** | ```php $stmt=$pdo->prepare('INSERT … VALUES (?)'); $stmt->execute([$name]); ``` | ```dart await db.insert('users', {'name': name});``` (sqflite). |
| **REST call** | `file_get_contents('https://api.dev/users');` | ```dart final resp = await http.get(Uri.parse('https://api.dev/users')); final List users = jsonDecode(resp.body);``` |
| **JSON encode/decode** | `json_encode($obj);` `json_decode($str, true);` | `jsonEncode(obj);` `jsonDecode(str);` (identical APIs). |
| **Session / cookie** | `$_SESSION['uid']=5; setcookie('token','abc');` | **Flutter** has no built‑in session; you store tokens in **shared_preferences** or **secure_storage** and attach them to every HTTP request. |
| **File upload** | `<form enctype="multipart/form-data">` + `$_FILES` | Use `http.MultipartRequest` or `dio` to send files. |

> **Mini‑task:** Replace a PHP script that returns a JSON list of products with a Flutter screen that fetches the same endpoint using `http.get` and displays the names in a `ListView`.

---

### 🧭 5️⃣ Navigation & Routing  

| PHP (web) | Flutter (mobile) |
|-----------|-------------------|
| `index.php?page=about` → `include 'about.php';` | `Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));` |
| **URL rewriting** (`.htaccess`) | **Named routes**: `routes: {'/about': (_) => AboutScreen()}, Navigator.pushNamed(context, '/about');` |
| **GET parameters** (`?id=3`) | `Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(id:3)));` |
| **Redirect** (`header('Location: login.php');`) | `Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));` |

**Bottom navigation bar** (common in mobile apps) vs. PHP’s multi‑page layout:

```dart
Scaffold(
  body: IndexedStack(index: _selected, children: [Home(), Search(), Settings()]),
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: _selected,
    onTap: (i) => setState(() => _selected = i),
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ],
  ),
);
```

---

### 📦 6️⃣ State Management – “How do I keep data alive?”  

| PHP approach | Flutter analogue |
|--------------|-----------------|
| **Variables in the script** (lifetime = request) | **`setState`** – local widget state (short‑lived). |
| **Session (`$_SESSION`)** – survives across requests | **Provider + ChangeNotifier** (or Riverpod) – a global object kept alive as long as the app runs. |
| **Cache files / DB** | **Hive / sqflite** – on‑device persistence. |
| **Templating engine (Twig, Blade)** | **Widget tree** – declarative UI; you rebuild UI when the underlying model changes. |

#### Tiny Provider example (mirrors a PHP session)

```dart
// PHP
session_start();
$_SESSION['counter'] = ($_SESSION['counter'] ?? 0) + 1;

// Flutter
class CounterModel extends ChangeNotifier {
  int _value = 0;
  int get value => _value;
  void inc() { _value++; notifyListeners(); }
}

// UI
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    final counter = Provider.of<CounterModel>(ctx);
    return Scaffold(
      body: Center(child: Text('${counter.value}', style: const TextStyle(fontSize: 48))),
      floatingActionButton: FloatingActionButton(onPressed: counter.inc, child: const Icon(Icons.add)),
    );
  }
}
```

---

### 📊 7️⃣ Asynchrony & Streams  

| PHP | Flutter |
|-----|---------|
| **Blocking I/O** (`file_get_contents`) | **Future** (`await http.get`) |
| **Long‑polling** (loop with `sleep`) | **Stream** (`Stream.periodic`, `StreamBuilder`) |
| **Callback style** (`curl_setopt($ch, CURLOPT_WRITEFUNCTION, $cb)`) | **Async/await** is built‑in; you rarely need manual callbacks. |

**Stream example – live clock** (compare to a PHP page that refreshes every second with `<meta http‑equiv="refresh" ...>`):

```dart
class Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (_, snapshot) => Text(
        snapshot.data?.toIso8601String() ?? '',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
```

---

### 🗄️ 8️⃣ Persistence (Database / Local Storage)  

| PHP | Flutter |
|-----|---------|
| **MySQL via PDO** | **sqflite** (SQLite) or **Hive** (NoSQL) |
| **File system (`file_put_contents`)** | `await file.writeAsString(...)` (via `dart:io`) |
| **Session / cookie** | `shared_preferences` or `flutter_secure_storage` |
| **ORM (Eloquent, Doctrine)** | **Drift** (formerly Moor) – type‑safe SQLite wrapper. |

**Hive Todo example (compare to a PHP file‑based todo):**

```dart
// PHP (flat file)
// $todos = json_decode(file_get_contents('todos.json'), true);
// $todos[] = ['title'=>'Buy milk','done'=>false];
// file_put_contents('todos.json', json_encode($todos));

// Flutter (Hive)
final box = await Hive.openBox<Todo>('todos');
box.add(Todo()..title = 'Buy milk');          // automatically persisted
final List<Todo> todos = box.values.toList(); // read back
```

---

### 🧪 9️⃣ Testing  

| PHP | Flutter |
|------|---------|
| **PHPUnit** (`phpunit tests/`) | **flutter test** (unit) & **flutter test --flutter-driver** (integration) |
| **Mocking** (`$this->createMock`) | **mockito** for Dart (`flutter pub add mockito --dev`) |
| **Functional test** (curl a page) | **Widget test** (`testWidgets`) – you pump a widget tree and verify UI. |

**Widget test – same idea as testing a rendered HTML page:**

```dart
testWidgets('counter increments', (tester) async {
  await tester.pumpWidget(const MyApp()); // builds the whole app
  expect(find.text('0'), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump(); // rebuild after setState
  expect(find.text('1'), findsOneWidget);
});
```

---

### 🚀 10️⃣ Deploy / Distribution  

| PHP | Flutter |
|-----|----------|
| **Deploy to a web server** (`scp` → `/var/www`) | **`flutter build apk`**, **`flutter build ios`**, **`flutter build web`**, **`flutter build macos/windows/linux`** |
| **Version control** – same Git workflow | Same Git, but you may also publish to **pub.dev** (packages) or **Google Play / App Store** for binaries. |
| **Environment config** (`.env`, `$_SERVER`) | **Flavor / Dart defines** (`flutter run --dart-define=API_URL=https://api.dev`) or `dotenv` package. |

---

## 📚 QUICK‑START MINI‑PROJECT – “Todo App” (PHP ↔ Flutter)

Below is the *complete* code for a **very small Todo list** written in both worlds.  
Read the PHP version first (you already know it), then copy the Flutter version into `lib/main.dart` and run it – you’ll see the *same* features (add, toggle, delete, persistence).

### PHP (file‑based)

```php
<?php
// file: todo.php
$path = 'todos.json';
$todos = file_exists($path) ? json_decode(file_get_contents($path), true) : [];

// handle actions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'];
    if ($action === 'add' && $_POST['title']) {
        $todos[] = ['title'=>$_POST['title'], 'done'=>false];
    } elseif ($action === 'toggle') {
        $i = (int)$_POST['index'];
        $todos[$i]['done'] = !$todos[$i]['done'];
    } elseif ($action === 'del') {
        $i = (int)$_POST['index'];
        array_splice($todos, $i, 1);
    }
    file_put_contents($path, json_encode($todos));
    header('Location: todo.php');
    exit;
}
?>
<!DOCTYPE html>
<html><body>
<h1>Todo (PHP)</h1>
<form method="post"><input name="title"><button name="action" value="add">Add</button></form>
<ul>
<?php foreach ($todos as $i=>$t): ?>
  <li>
    <form method="post" style="display:inline">
      <button name="action" value="toggle" style="border:none;background:none;">
        <?= $t['done'] ? '✅' : '☐' ?>
      </button>
      <input type="hidden" name="index" value="<?= $i ?>">
    </form>
    <?= htmlspecialchars($t['title']) ?>
    <form method="post" style="display:inline">
      <button name="action" value="del" style="color:red;">✖</button>
      <input type="hidden" name="index" value="<?= $i ?>">
    </form>
  </li>
<?php endforeach; ?>
</ul>
</body></html>
```

### Flutter (Hive + Provider)

```dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

part 'main.g.dart'; // generated adapter

@HiveType(typeId: 0)
class TodoItem extends HiveObject {
  @HiveField(0) late String title;
  @HiveField(1) bool done = false;
}

// ---------- STATE ----------
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

// ---------- UI ----------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = TodoModel();
  await model.init();
  runApp(
    ChangeNotifierProvider.value(
      value: model,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Todo (Flutter)',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const TodoScreen(),
      );
}

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TodoModel>(context);
    final ctrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo (Flutter)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: ctrl,
                  decoration: const InputDecoration(labelText: 'New task'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final txt = ctrl.text.trim();
                  if (txt.isNotEmpty) {
                    model.add(txt);
                    ctrl.clear();
                  }
                },
              )
            ]),
          ),
          const Divider(),
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
          )
        ],
      ),
    );
  }
}
```

> **Run it:** `flutter run` (Android, iOS, web, or desktop). The data lives on the device thanks to **Hive**, just like the PHP version writes to `todos.json`.

---

## 📚 TL;DR Cheat‑Sheet (Flutter ↔ PHP)

| Area | PHP Syntax | Flutter/Dart Equivalent |
|------|------------|--------------------------|
| **Start app** | `<?php … ?>` | `void main() => runApp(MyApp());` |
| **Print / echo** | `echo $msg;` | `print(msg);` or `debugPrint(msg);` |
| **Variable** | `$cnt = 0;` | `int cnt = 0;` |
| **Array** | `$arr = [1,2];` | `List<int> arr = [1,2];` |
| **Assoc array** | `$map = ['a'=>1];` | `Map<String, int> map = {'a':1};` |
| **If** | `if($a){…}` | `if (a) {…}` |
| **Loop** | `foreach($items as $i){…}` | `for (var i in items) {…}` or `ListView.builder` |
| **Function** | `function add($x,$y){return $x+$y;}` | `int add(int x, int y) => x + y;` |
| **Class** | `class User { public $name; }` | `class User { final String name; User(this.name); }` |
| **Inheritance** | `class Admin extends User {}` | `class Admin extends User {}` |
| **Include file** | `include 'head.php';` | `Widget Header() => AppBar(...);` |
| **GET param** | `$_GET['id']` | `ModalRoute.of(context)!.settings.arguments` or pass directly. |
| **Redirect** | `header('Location: home.php');` | `Navigator.pushReplacement(...);` |
| **Database (PDO)** | `$pdo->query(...);` | `await db.query(...);` (sqflite) |
| **JSON** | `json_encode($obj);` | `jsonEncode(obj);` |
| **Session** | `$_SESSION['uid']` | `shared_preferences` or `Provider` global state. |
| **File write** | `file_put_contents('log.txt',$msg);` | `await File('log.txt').writeAsString(msg);` |
| **Test** | `phpunit` | `flutter test` (unit) / `testWidgets` (UI). |
| **Deploy** | Upload to web server | `flutter build apk|ios|web` → publish to stores or static host. |

---

## 🚀 How to Move Forward Quickly

1. **Day 0‑1** – Install Flutter, run the default counter app.  
2. **Day 2** – Write the same “Hello World” in Dart you already have in PHP.  
3. **Day 3‑4** – Build a tiny UI that shows a list of strings (equivalent to a PHP `foreach` over an array).  
4. **Day 5** – Add a `TextField` + button → **setState** (compare to a PHP form posting to itself).  
5. **Day 6‑7** – Introduce **Provider** for global state – think of it as a PHP session that lives for the whole app.  
6. **Day 8** – Persist the list with **Hive** (mirrors writing to a JSON file).  
7. **Day 9‑10** – Replace the file‑store with a **REST call** (`http` package) – same as a PHP cURL request.  
8. **Day 11‑12** – Add a second screen (detail page) → navigation vs. PHP redirects.  
9. **Day 13‑14** – Write a **unit test** and a **widget test** → analogous to PHPUnit tests.  
10. **Day 15** – Build for Android/iOS/Web and ship a binary – the Flutter version of “copy PHP files to /var/www”.

Follow the table above, copy‑paste the snippets, change a value, and you’ll instantly see the parallel between the two ecosystems.  

**Enjoy the journey – you already know the logic from PHP, now you just speak the Flutter/Dart language!** 🎉