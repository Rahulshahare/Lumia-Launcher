## ⚡️ Flutter Crash‑Course – “Learn by Doing”  
*(Concept + tiny runnable example for every step)*  

> **Goal** – By the end of this 2‑week sprint you’ll be able to spin‑up a real, interactive Flutter app (a simple Todo list) and understand the core ideas you’ll need for anything else.  
> All examples assume the default **stable** channel (Flutter 3.x) and the **Dart** SDK that ships with it.

---

## 1️⃣ Set‑up (Day 0)

| Action | Command / UI |
|--------|--------------|
| **Install Flutter** | <https://flutter.dev/docs/get-started/install> – run the installer for your OS. |
| **Verify** | ```bash\nflutter doctor -v\n``` – all checks green (Android SDK, Xcode, VS Code/Android Studio). |
| **Create first project** | ```bash\nflutter create hello_world\ncd hello_world\nflutter run\n``` – should show a counter app on your device/emulator. |
| **IDE tip** | Install the **Flutter** and **Dart** extensions for VS Code or Android Studio – they give hot‑reload, snippets, and debugging. |

---

## 2️⃣ Dart Basics (Day 1)

| Concept | Mini‑example (run `dart run` or paste into `main.dart`) |
|---------|--------------------------------------------------------|
| **Entry point** | ```dart\nvoid main() => print('Hello Dart!');\n``` |
| **Variables & Types** | ```dart\nint age = 27;\ndouble price = 12.5;\nString name = 'Alice';\nbool isAdmin = false;\nvar list = [1, 2, 3]; // inferred List<int>\n``` |
| **Functions** | ```dart\nint add(int a, int b) => a + b;\nvoid greet(String who) { print('Hi, $who'); }\n``` |
| **Null‑safety** (default in Flutter) | ```dart\nString? maybe; // can be null\nString sure = maybe ?? 'default';\n``` |
| **Collections** | ```dart\nvar map = {'city':'Paris','country':'FR'};\nprint(map['city']);\n``` |
| **Async / Await** | ```dart\nFuture<String> fetch() async {\n  await Future.delayed(Duration(seconds: 1));\n  return 'data';\n}\nvoid main() async { print(await fetch()); }\n``` |
| **Classes** | ```dart\nclass Person {\n  final String name;\n  int age;\n  Person(this.name, this.age);\n  void birthday() => age++;\n}\n``` |

> **Practice:** open `dartpad.dev`, copy each snippet, run, and tweak a value.  

---

## 3️⃣ Flutter Core – Widgets & Layout (Day 2‑3)

| Concept | Code (place inside `lib/main.dart`) |
|---------|--------------------------------------|
| **StatelessWidget** – immutable UI | ```dart\nimport 'package:flutter/material.dart';\n\nclass Hello extends StatelessWidget {\n  final String name;\n  const Hello({Key? key, required this.name}) : super(key: key);\n  @override\n  Widget build(BuildContext context) => Center(child: Text('Hello $name'));\n}\n``` |
| **StatefulWidget** – UI that changes | ```dart\nclass Counter extends StatefulWidget {\n  const Counter({Key? key}) : super(key: key);\n  @override _CounterState createState() => _CounterState();\n}\n\nclass _CounterState extends State<Counter> {\n  int _value = 0;\n  void _inc() => setState(() => _value++);\n  @override\n  Widget build(BuildContext context) => Scaffold(\n    appBar: AppBar(title: const Text('Counter')),\n    body: Center(child: Text('$_value', style: const TextStyle(fontSize: 48))),\n    floatingActionButton: FloatingActionButton(onPressed: _inc, child: const Icon(Icons.add)),\n  );\n}\n``` |
| **MaterialApp** – root of a Material‑design app | ```dart\nvoid main() => runApp(const MaterialApp(home: Counter()));\n``` |
| **Common layout widgets** | ```dart\nColumn(children: [\n  Text('Top'),\n  Expanded(child: Container(color: Colors.blue)),\n  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [\n    Icon(Icons.star),\n    Icon(Icons.star_border),\n  ]),\n]);\n``` |
| **ListView.builder** – lazy scrolling list | ```dart\nListView.builder(\n  itemCount: items.length,\n  itemBuilder: (_, i) => ListTile(title: Text(items[i])),\n);\n``` |
| **GestureDetector / InkWell** – tap handling | ```dart\nInkWell(onTap: () => print('tapped'), child: const Padding(padding: EdgeInsets.all(12), child: Text('Tap me')));\n``` |

> **Hot‑Reload** – Press **r** in the terminal or click the lightning bolt in the IDE; changes appear instantly.

---

## 4️⃣ State Management (Day 4‑5)

| Approach | When to use | Minimal example |
|----------|-------------|-----------------|
| **setState** (built‑in) | Small screens, a few UI values | Already shown in the Counter example. |
| **InheritedWidget / InheritedModel** | Propagate read‑only data down the tree. | ```dart\nclass ThemeProvider extends InheritedWidget { final ThemeData theme; const ThemeProvider({required this.theme, required Widget child}) : super(child: child);\n  static ThemeProvider? of(BuildContext ctx) => ctx.dependOnInheritedWidgetOfExactType<ThemeProvider>();\n  @override bool updateShouldNotify(ThemeProvider old) => theme != old.theme;\n}\n``` |
| **Provider** (most popular) | Medium‑size apps, clean separation. | 1️⃣ Add dependency: `flutter pub add provider` <br>2️⃣ Wrap root: <br>```dart\nvoid main() => runApp(\n  ChangeNotifierProvider(create: (_) => TodoModel(), child: const MyApp()),\n);\n```\n3️⃣ Model: <br>```dart\nclass TodoModel extends ChangeNotifier {\n  final List<String> _items = [];\n  List<String> get items => List.unmodifiable(_items);\n  void add(String txt){ _items.add(txt); notifyListeners(); }\n}\n```\n4️⃣ UI: <br>```dart\nclass TodoScreen extends StatelessWidget {\n  @override Widget build(BuildContext ctx) {\n    final model = Provider.of<TodoModel>(ctx);\n    return Scaffold(\n      appBar: AppBar(title: const Text('Todo')),\n      body: ListView.builder(\n        itemCount: model.items.length,\n        itemBuilder: (_, i) => ListTile(title: Text(model.items[i])),\n      ),\n      floatingActionButton: FloatingActionButton(\n        onPressed: () => model.add('Item ${model.items.length+1}'),\n        child: const Icon(Icons.add),\n      ),\n    );\n  }\n}\n``` |
| **Riverpod** | More testable, no `BuildContext` required for providers. | `flutter pub add flutter_riverpod` – see <https://riverpod.dev>. |
| **Bloc / Cubit** | Large apps, explicit event‑state flow. | `flutter pub add flutter_bloc`. (skip for the 2‑week sprint). |

> **Quick tip:** For a starter project, **Provider** + **ChangeNotifier** gives you everything you need with < 30 lines of boilerplate.

---

## 5️⃣ Navigation (Day 6)

| Concept | Example |
|---------|---------|
| **Basic push/pop** | ```dart\nNavigator.of(context).push(MaterialPageRoute(builder: (_) => const DetailScreen()));\nNavigator.pop(context);\n``` |
| **Named routes** (centralised) | ```dart\nvoid main() => runApp(MaterialApp(\n  initialRoute: '/',\n  routes: {\n    '/': (_) => const HomeScreen(),\n    '/detail': (_) => const DetailScreen(),\n  },\n));\n// navigate\nNavigator.pushNamed(context, '/detail');\n``` |
| **Passing arguments** | ```dart\nNavigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(item: myItem)));\n// in DetailScreen\nfinal Item item; const DetailScreen({Key? key, required this.item}) : super(key: key);\n``` |
| **BottomNavigationBar** | ```dart\nScaffold(\n  body: IndexedStack(index: _idx, children: [Home(), Search(), Settings()]),\n  bottomNavigationBar: BottomNavigationBar(currentIndex: _idx, onTap: (i)=>setState(()=>_idx=i), items: const [...]),\n);\n``` |

---

## 6️⃣ Async Data & Networking (Day 7‑8)

| Concept | Minimal code |
|---------|--------------|
| **http package** | `flutter pub add http` |
| **GET request** | ```dart\nimport 'package:http/http.dart' as http;\nFuture<List<dynamic>> fetchPosts() async {\n  final resp = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));\n  if (resp.statusCode == 200) return jsonDecode(resp.body);\n  throw Exception('Bad response');\n}\n``` |
| **FutureBuilder** – UI that reacts to async data | ```dart\nclass PostsScreen extends StatelessWidget {\n  const PostsScreen({Key? key}) : super(key: key);\n  @override\n  Widget build(BuildContext context) => FutureBuilder<List<dynamic>>(\n    future: fetchPosts(),\n    builder: (_, snap) {\n      if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());\n      if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));\n      final posts = snap.data!;\n      return ListView.builder(\n        itemCount: posts.length,\n        itemBuilder: (_, i) => ListTile(title: Text(posts[i]['title'])),\n      );\n    },\n  );\n}\n``` |
| **Pull‑to‑refresh** | Wrap the list in `RefreshIndicator(onRefresh: () async => setState(() {}), child: ListView(...))`. |

---

## 7️⃣ Local Persistence (Day 9)

| Need | Package | Tiny example |
|------|---------|--------------|
| **Key‑value store** | `flutter pub add shared_preferences` | ```dart\nfinal prefs = await SharedPreferences.getInstance();\nawait prefs.setString('token', 'abc123');\nString? token = prefs.getString('token');\n``` |
| **SQLite** | `flutter pub add sqflite path` | ```dart\nfinal db = await openDatabase(join(await getDatabasesPath(), 'todo.db'), onCreate: (db, v) async {\n  await db.execute('CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, done INTEGER)');\n});\nawait db.insert('todo', {'title':'Buy milk','done':0});\nfinal rows = await db.query('todo');\n``` |
| **Hive (no‑SQL, fast)** | `flutter pub add hive hive_flutter` | ```dart\nawait Hive.initFlutter();\nvar box = await Hive.openBox('settings');\nbox.put('theme', 'dark');\nString theme = box.get('theme');\n``` |

> **Quick tip:** For a simple Todo app, **Hive** or **shared_preferences** is enough; you’ll avoid SQL boilerplate.

---

## 8️⃣ The Mini‑Project – **Todo List** (Day 10‑14)

> One file (`main.dart`) + a tiny local database (Hive) → fully functional CRUD UI.

### 8.1 Add dependencies

```yaml
# pubspec.yaml (add under dependencies)
flutter:
  sdk: flutter
provider: ^6.0.5
hive: ^2.2.3
hive_flutter: ^1.1.0
```

Run `flutter pub get`.

### 8.2 Data model (Hive)

```dart
import 'package:hive/hive.dart';
part 'todo_item.g.dart';          // generated adapter

@HiveType(typeId: 0)
class TodoItem extends HiveObject {
  @HiveField(0) late String title;
  @HiveField(1) bool done = false;
}
```

Generate the adapter: `flutter packages pub run build_runner build`.

### 8.3 Provider for state

```dart
class TodoProvider extends ChangeNotifier {
  late Box<TodoItem> _box;

  List<TodoItem> get items => _box.values.toList();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoItemAdapter());
    _box = await Hive.openBox<TodoItem>('todos');
    notifyListeners();
  }

  void add(String txt) {
    _box.add(TodoItem()..title = txt);
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
```

### 8.4 UI

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = TodoProvider();
  await provider.init();                     // load Hive first
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Todo Demo',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const TodoScreen(),
      );
}

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Todo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'New task'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final txt = _controller.text.trim();
                  if (txt.isNotEmpty) {
                    model.add(txt);
                    _controller.clear();
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
                  title: Text(item.title,
                      style: TextStyle(
                          decoration:
                              item.done ? TextDecoration.lineThrough : null)),
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

#### Run it

```bash
flutter run
```

You now have a **persisted**, **state‑managed**, **responsive** Todo app in < 100 lines of Dart!

---

## 9️⃣ Testing (Day 15)

| Type | Minimal example |
|------|-----------------|
| **Unit test** (pure Dart) | ```dart\nimport 'package:test/test.dart';\nint add(int a,int b)=>a+b;\nvoid main(){ test('adds',()=> expect(add(2,3),5)); }\n``` |
| **Widget test** (Flutter) | ```dart\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:my_app/main.dart';\nvoid main(){ testWidgets('adds a todo', (tester) async {\n  await tester.pumpWidget(const MyApp());\n  await tester.enterText(find.byType(TextField), 'Buy milk');\n  await tester.tap(find.byIcon(Icons.add));\n  await tester.pump();\n  expect(find.text('Buy milk'), findsOneWidget);\n}); }\n``` |
| **Run** | `flutter test` |

> **Tip:** Keep the logic (e.g., `TodoProvider`) pure Dart – it’s easy to unit‑test without a device.

---

## 🔟 Deploying (Day 16)

| Platform | Steps |
|----------|-------|
| **Android** | 1️⃣ `flutter build apk --release`  <br>2️⃣ Upload the generated `app-release.apk` to the Play Console (or sideload). |
| **iOS** | 1️⃣ Open `ios/Runner.xcworkspace` in Xcode. <br>2️⃣ Set signing & capabilities. <br>3️⃣ `flutter build ios --release` then archive via Xcode and submit to App Store Connect. |
| **Web** | `flutter build web` → contents appear in `build/web/`; host on any static server (GitHub Pages, Firebase Hosting, Netlify). |
| **Desktop** (macOS/Windows/Linux) | `flutter build macos` / `flutter build windows` / `flutter build linux`. |

**Hot‑reload** works on all targets during development – you never need to rebuild for every UI tweak.

---

## 📚 One‑Page Cheat‑Sheet (keep it bookmarked)

| Area | Syntax | Quick tip |
|------|--------|-----------|
| **Run app** | `flutter run` | Add `-d chrome` to launch on web. |
| **Hot‑reload** | `r` in terminal or IDE button | Keeps state alive. |
| **Add package** | `flutter pub add <pkg>` | `flutter pub outdated` to see updates. |
| **StatelessWidget** | `class X extends StatelessWidget { … }` | Use when UI never changes after build. |
| **StatefulWidget** | `class X extends StatefulWidget` + `_XState` | Call `setState(() { … })` to rebuild. |
| **Navigator** | `Navigator.push(context, MaterialPageRoute(builder: (_) => Next()))` | Use named routes for large apps. |
| **Provider** | `ChangeNotifierProvider(create: (_) => Model())` | Access via `Provider.of<Model>(context)` or `context.watch<Model>()`. |
| **FutureBuilder** | `FutureBuilder<T>(future: myFuture, builder: ...)` | Shows loading, error, data automatically. |
| **ListView.builder** | `ListView.builder(itemCount: n, itemBuilder: (_, i) => ...)` | Use `const` constructors whenever possible for performance. |
| **Hive** | `await Hive.openBox('box')` | Call `await Hive.initFlutter()` before using. |
| **Testing** | `flutter test` | Widget tests need `pumpWidget`. |
| **Build** | `flutter build apk|appbundle|ios|web|macos|windows|linux` | Add `--split-per-abi` for smaller Android APKs. |

---

## 🚀 Next Steps (after the 2‑week sprint)

| Goal | Resources |
|------|-----------|
| **Deep dive into state management** | Riverpod (`flutter_riverpod`), Bloc (`flutter_bloc`), GetX. |
| **Animations** | `AnimatedContainer`, `TweenAnimationBuilder`, `Hero`, `flutter_animate`. |
| **Advanced networking** | `dio` (interceptors, multipart), GraphQL (`graphql_flutter`). |
| **Internationalisation (i18n)** | `flutter_localizations`, `intl` package. |
| **Firebase integration** | `firebase_core`, `cloud_firestore`, `firebase_auth`. |
| **CI/CD** | GitHub Actions `flutter-action`, Fastlane for release automation. |
| **Performance profiling** | DevTools → CPU, Memory, Raster, Network tabs. |
| **Design systems** | Material 3 (`useMaterial3: true`), Cupertino widgets, custom themes. |
| **Desktop & Embedded** | Learn about `window_manager`, `bitsdojo_window` for custom windows. |

---

## 🎓 TL;DR Action Plan

| Day | Do | Verify |
|-----|----|--------|
| 0 | Install Flutter, run `flutter doctor`. | All checks green. |
| 1 | Write/run the Dart basics snippets. | No compile errors. |
| 2‑3 | Build a `StatelessWidget` & a `StatefulWidget` (counter). | Counter increments with hot‑reload. |
| 4‑5 | Add `provider` + a simple `TodoModel`; display a list with `ListView.builder`. | Adding an item updates UI instantly. |
| 6 | Implement navigation (push a Detail screen). | Back button works. |
| 7‑8 | Fetch JSON from a public API with `http` & show it via `FutureBuilder`. | Data appears after a spinner. |
| 9 | Persist todo items with **Hive** (or `shared_preferences`). | Close and re‑open app → data stays. |
| 10‑14 | Complete the full Todo app (code above). | Add / toggle / delete items; data saved. |
| 15 | Write one unit test and one widget test; run `flutter test`. | Tests pass. |
| 16 | Build release binaries for Android, iOS, and Web. | APK/Web folder generated. |
| 17‑20 | Choose a next‑level state solution (Riverpod/Bloc) and refactor a small part. | App still works, new pattern in place. |

You now have **the fastest possible foundation** to create production‑grade Flutter applications. From here you can scale the same patterns to larger projects, add sophisticated animations, connect to Firebase, or ship to every platform from a single code base. Happy coding! 🎉