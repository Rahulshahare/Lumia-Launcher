## ⚡ Rapid‑Fire PHP Crash Course  
*(Concept + tiny, runnable example for every topic)*  

Below you’ll find **the smallest piece of code that still shows the idea**.  
Copy each snippet into a file, run it (CLI `php file.php` or through a local web server), and then modify the variables or add one line – that’s the fastest way to internalise a concept.

---

### 1️⃣ What PHP Is & How to Run It
| Concept | Example |
|---------|----------|
| **Server‑side script** – executed on the server, output sent as HTML/JSON/etc. | ```bash\nphp -r 'echo \"Hello, PHP!\n\";'   # one‑liner in the terminal\n``` |
| **Embedding in HTML** – `<?php … ?>` tags. | ```html\n<!DOCTYPE html>\n<html><body>\n<?php echo \"Today is \" . date('Y‑m‑d'); ?>\n</body></html>\n``` |
| **CLI script** – no web server needed. | ```php\n<?php // hello.php\necho \"CLI says hi\\n\";\n?>\n``` |

> **Setup tip** – Install XAMPP / MAMP / LAMP *or* run Docker `docker run -p 8080:80 -v $(pwd):/var/www/html php:8.2-apache`. Place your files in the mapped folder and open `http://localhost/yourfile.php`.

---

### 2️⃣ Syntax & Basic Data Types
| Concept | Example |
|---------|----------|
| **Variables** – always start with `$`. | ```php\n<?php\n$name = \"Alice\";   // string\n$age  = 27;        // int\n$price = 12.99;    // float\n$isAdmin = false; // bool\nvar_dump($name, $age, $price, $isAdmin);\n?>\n``` |
| **Arrays** – indexed or associative. | ```php\n$indexed   = [1, 2, 3];\n$assoc     = ['city' => 'Paris', 'country' => 'FR'];\nprint_r($indexed);\nprint_r($assoc);\n``` |
| **Null** – no value. | ```php\n$nothing = null;\nvar_dump($nothing);\n``` |

**Try:** change `$age` to a string, then `var_dump($age);` – notice the type.

---

### 3️⃣ Operators & Type Juggling
| Concept | Example |
|---------|----------|
| **Arithmetic** | `5 + 2 * 3` → `11` |
| **String‑numeric conversion** | ```php\nvar_dump('5' + 2);   // int(7)\n``` |
| **Loose vs. strict comparison** | ```php\nvar_dump(0 == '0');   // true  (loose)\nvar_dump(0 === '0');  // false (strict)\n``` |
| **Logical** | `&&`, `||`, `!` – same as most languages. |

**Exercise:** predict the result of `0 == false` and `0 === false` before running.

---

### 4️⃣ Control Structures
| Concept | Example |
|---------|----------|
| **if / elseif / else** | ```php\nif ($age < 18) echo \"minor\";\nelseif ($age < 65) echo \"adult\";\nelse echo \"senior\";\n``` |
| **ternary** | `$msg = $isAdmin ? \"Admin\" : \"User\";` |
| **switch** | ```php\nswitch ($city) {\n  case 'Paris': echo 'FR'; break;\n  case 'Berlin': echo 'DE'; break;\n  default: echo '??';\n}\n``` |
| **for / while / foreach** | ```php\nfor ($i=1;$i<=3;$i++) echo $i;           // 123\n\n$i = 3; while ($i--) echo $i;               // 210\n\nforeach ($assoc as $k=>$v) echo \"$k=>$v \"; // city=>Paris country=>FR \n``` |

**Try:** rewrite the `for` loop as a `foreach` over an indexed array.

---

### 5️⃣ Functions
| Concept | Example |
|---------|----------|
| **Definition** | ```php\nfunction greet(string $who = 'World'): string {\n    return \"Hello, $who!\";\n}\n``` |
| **Calling** | `echo greet();          // Hello, World!`\n`echo greet('Bob');`   // Hello, Bob! |
| **Return values** | `return` ends the function and gives a value. |
| **Scope** – variables defined *inside* are local; use `global $var;` or `static $counter = 0;` to persist. | ```php\nfunction counter(){ static $c=0; return ++$c; }\necho counter(); //1\necho counter(); //2\n``` |

**Exercise:** write a `factorial(int $n): int` using a loop.

---

### 6️⃣ Strings – Manipulation
| Concept | Example |
|---------|----------|
| **Concatenation** (`.`) | `$msg = \"Hello\" . \", \" . $name;` |
| **Interpolation** (inside double quotes) | `echo \"Age: $age\";` |
| **Common functions** | `strlen($s)`, `strpos($s,'sub')`, `substr($s,2,4)`, `strtolower()`, `trim()` |
| **Regex** (`preg_match`) | ```php\nif (preg_match('/^[A-Z][a-z]+$/', $name)) echo \"Name looks good\";\n``` |

**Try:** validate an email with `filter_var($email, FILTER_VALIDATE_EMAIL)`.

---

### 7️⃣ Superglobals – Getting Input
| Variable | Typical use |
|----------|-------------|
| `$_GET`  | Query‑string data (`?id=5`) |
| `$_POST` | Form data sent with `method="post"` |
| `$_SERVER` | Request meta (method, URI, host) |
| `$_COOKIE` | Client‑side stored values |
| `$_SESSION` | Server‑side persistence across requests |

**Mini‑form demo** (`form.html` + `process.php`):

```html
<!-- form.html -->
<form action="process.php" method="post">
  <input name="color" placeholder="favorite color">
  <button>Send</button>
</form>
```

```php
<?php // process.php
$color = $_POST['color'] ?? 'unknown';
echo "Your favorite color is <strong>$color</strong>";
?>
```

---

### 8️⃣ File I/O
| Operation | Example |
|-----------|----------|
| **Write** | `file_put_contents('log.txt', date('c').\" – hit\\n\", FILE_APPEND);` |
| **Read** | `$content = file_get_contents('log.txt'); echo $content;` |
| **Stream API** | ```php\n$fh = fopen('data.txt','r');\nwhile(($line = fgets($fh)) !== false){ echo $line; }\nfclose($fh);\n``` |

**Exercise:** create a script that saves the current timestamp to `hits.txt` each time it runs.

---

### 9️⃣ Error & Exception Handling
| Concept | Example |
|---------|----------|
| **Display all errors** (dev only) | `error_reporting(E_ALL); ini_set('display_errors', 1);` |
| **Try / Catch** | ```php\nfunction div($a,$b){ if($b==0) throw new Exception('÷ by 0'); return $a/$b; }\ntry { echo div(5,0); }\ncatch (Exception $e){ echo 'Error: '.$e->getMessage(); }\n``` |
| **Custom exception** | ```php\nclass AuthException extends Exception {}\nthrow new AuthException('Bad token');\n``` |

**Tip:** never leave `display_errors` on in production – log them instead.

---

### 🔟 Working with MySQL – PDO (the **secure** way)

```php
<?php
$dsn = 'mysql:host=localhost;dbname=test;charset=utf8mb4';
$pdo = new PDO($dsn, 'root', '', [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,   // throw on error
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
]);

// 1️⃣ INSERT (prepared statement)
$stmt = $pdo->prepare('INSERT INTO users (email, pwd) VALUES (:e, :p)');
$stmt->execute([
    'e' => 'bob@example.com',
    'p' => password_hash('s3cr3t', PASSWORD_DEFAULT)
]);

// 2️⃣ SELECT
$stmt = $pdo->prepare('SELECT id,email FROM users WHERE email = :e');
$stmt->execute(['e' => 'bob@example.com']);
$user = $stmt->fetch();          // ['id'=>1,'email'=>'bob@example.com']
print_r($user);
?>
```

**Why PDO?**  
* Automatic quoting → **prevents SQL injection**.  
* Same API works for PostgreSQL, SQLite, SQL Server, ….

**Exercise:** add an `UPDATE` that toggles a `done TINYINT` column for a todo row.

---

### 1️⃣1️⃣ Sessions & Cookies
| Concept | Example |
|---------|----------|
| **Start a session** | `session_start(); $_SESSION['user'] = 'alice';` |
| **Read session data** | `echo $_SESSION['user'];` |
| **Set a cookie** (must be before any output) | `setcookie('theme','dark', time()+30*24*3600, '/');` |
| **Read cookie** | `$_COOKIE['theme'] ?? 'default';` |

```php
<?php // login.php
session_start();
$_SESSION['uid'] = 42;                 // remember user
setcookie('last_login', time(), time()+86400);
?>
```

---

### 1️⃣2️⃣ Basic Object‑Oriented PHP
| Concept | Example |
|---------|----------|
| **Class & property** | ```php\nclass Animal {\n    protected string $name;\n    public function __construct(string $name){ $this->name=$name; }\n}\n``` |
| **Method** | ```php\npublic function speak(): string { return \"$this->name makes a sound\"; }\n``` |
| **Inheritance** | ```php\nclass Dog extends Animal {\n    public function speak(): string { return \"$this->name barks\"; }\n}\n$dog = new Dog('Rex'); echo $dog->speak(); // Rex barks\n``` |
| **Visibility** – `public` (anywhere), `protected` (class & children), `private` (class only). |
| **Static** – belongs to class, not instance. | `User::find(5);` |
| **Interface** – contract only. | ```php\ninterface Jsonable { public function toJson(): string; }\n``` |

**Exercise:** create a `Product` class that implements `Jsonable` and returns its properties as JSON.

---

### 1️⃣3️⃣ Security Essentials (must‑know from day 1)

| Threat | PHP defence |
|--------|--------------|
| **SQL Injection** | Use **prepared statements** (PDO) – never concatenate raw input into SQL. |
| **XSS (Cross‑Site Scripting)** | Escape output: `echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');` |
| **Password storage** | `password_hash($pwd, PASSWORD_DEFAULT)` & `password_verify($pwd, $hash)` |
| **CSRF** | Add a hidden token to forms (`$_SESSION['csrf']`) and verify on POST. |
| **File inclusion** | Never include user‑supplied paths. Use a whitelist or map IDs to known files. |

---

## 📦 Mini‑Project – **Todo‑API** (All concepts in one file)

> A **single‑file** REST‑like endpoint that lets you list, create, toggle, and delete todo items.  
> Save as `api.php` under your web root, then call it with curl or Postman.

```php
<?php
declare(strict_types=1);
header('Content-Type: application/json');

// ---------- CONFIG ----------
$pdo = new PDO(
    'mysql:host=localhost;dbname=todo;charset=utf8mb4',
    'root',
    '',
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
     PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
);

// ---------- SIMPLE ROUTER ----------
$method = $_SERVER['REQUEST_METHOD'];
$path   = trim($_GET['path'] ?? '', '/');          // e.g. ?path=items/3
$segments = explode('/', $path);

// ---------- MODEL ----------
class Todo {
    private PDO $db;
    public function __construct(PDO $db){ $this->db = $db; }

    public function all(): array {
        return $this->db->query('SELECT id,title,done FROM items ORDER BY id DESC')->fetchAll();
    }
    public function create(string $title): array {
        $stmt = $this->db->prepare('INSERT INTO items (title,done) VALUES (:t,0)');
        $stmt->execute(['t'=>$title]);
        $id = (int)$this->db->lastInsertId();
        return ['id'=>$id,'title'=>$title,'done'=>0];
    }
    public function toggle(int $id): array {
        $stmt = $this->db->prepare('UPDATE items SET done = NOT done WHERE id=:i');
        $stmt->execute(['i'=>$id]);
        return $this->get($id);
    }
    public function delete(int $id): void {
        $stmt = $this->db->prepare('DELETE FROM items WHERE id=:i');
        $stmt->execute(['i'=>$id]);
    }
    private function get(int $id): array {
        $stmt = $this->db->prepare('SELECT id,title,done FROM items WHERE id=:i');
        $stmt->execute(['i'=>$id]);
        $row = $stmt->fetch();
        if (!$row) throw new Exception('Not found',404);
        return $row;
    }
}

// ---------- CONTROLLER ----------
$api = new Todo();

try {
    // GET /items            → list
    // GET /items/5          → toggle done flag (demo)
    // POST /items           → create  { "title":"Buy milk" }
    // DELETE /items/5       → delete
    if ($method === 'GET' && $segments[0] === 'items' && isset($segments[1])) {
        echo json_encode($api->toggle((int)$segments[1]));
    } elseif ($method === 'GET' && $segments[0] === 'items') {
        echo json_encode($api->all());
    } elseif ($method === 'POST' && $segments[0] === 'items') {
        $data = json_decode(file_get_contents('php://input'), true);
        if (!isset($data['title'])) throw new Exception('title missing',400);
        echo json_encode($api->create($data['title']));
    } elseif ($method === 'DELETE' && $segments[0] === 'items' && isset($segments[1])) {
        $api->delete((int)$segments[1]);
        http_response_code(204);               // No Content
    } else {
        throw new Exception('Route not found',404);
    }
}
catch (Exception $e) {
    http_response_code($e->getCode() ?: 500);
    echo json_encode(['error'=>$e->getMessage()]);
}
```

**SQL for the table** (run once in phpMyAdmin, MySQL console, etc.):

```sql
CREATE TABLE items (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    done TINYINT(1) NOT NULL DEFAULT 0
);
```

**Quick test from the terminal**

```bash
# list
curl http://localhost/api.php?path=items

# create
curl -X POST -H "Content-Type: application/json" \
     -d '{"title":"Buy coffee"}' \
     http://localhost/api.php?path=items

# toggle id 1
curl http://localhost/api.php?path=items/1

# delete id 2
curl -X DELETE http://localhost/api.php?path=items/2
```

*What you just practiced*: PDO, prepared statements, JSON I/O, routing, OOP, error handling, and HTTP verbs – the core of any real‑world PHP app.

---

## 📚 One‑Page Cheat‑Sheet (keep it handy)

| Category | Syntax | Quick tip |
|----------|--------|-----------|
| **Echo / Print** | `echo "text";` `print $var;` | `echo $a, $b;` works with multiple args. |
| **Array literal** | `$a = [1,2]; $b = ['k'=>5];` | Short syntax (`[]`) works from PHP 5.4+. |
| **String interpolation** | `"Hello $name"` | Only double‑quoted strings or heredoc. |
| **Include / Require** | `require 'file.php';` `include_once 'utils.php';` | `require` stops script on failure; `include` only warns. |
| **Constants** | `define('PI',3.14);` `const MAX=100;` | `const` works inside classes, `define` is global. |
| **Static method** | `ClassName::method();` | No `$this` inside static methods. |
| **Namespace** | `namespace App\Models;` | Follow PSR‑4: `App\Models\User` → `src/Models/User.php`. |
| **Composer** | `composer require vendor/pkg` | Autoloader: `require __DIR__.'/vendor/autoload.php';` |
| **Password hash** | `password_hash($pwd,PASSWORD_DEFAULT);` `password_verify($pwd,$hash);` | Store only the hash. |
| **Redirect** | `header('Location: /login.php'); exit;` | Must be before any output. |
| **JSON** | `json_encode($data);` `json_decode($json,true);` | Second arg `true` → associative array. |
| **Session start** | `session_start(); $_SESSION['x']=5;` | Call **once** at the top of the script. |
| **PDO fetch mode** | `$stmt->fetchAll(PDO::FETCH_ASSOC);` | `FETCH_OBJ` returns objects, `FETCH_NUM` numeric keys. |

---

## 🚀 Next Steps (after you finish the 2‑week sprint)

1. **Composer & Autoloading** – split classes into separate files, use PSR‑4.  
2. **PSR‑12 coding style** – run `phpcs` to auto‑format.  
3. **Unit testing** – install PHPUnit (`composer require --dev phpunit/phpunit`) and write a test for `Todo::toggle()`.  
4. **Pick a framework** – Laravel (Eloquent ORM, Blade templates) or Symfony (components, Flex).  
5. **Deploy** – learn about `.htaccess` rewrites, Docker containers, or serverless PHP (e.g., Vercel, Cloudflare Workers).  

---

### 🎯 TL;DR Action Plan

| Day | Do it | Verify |
|-----|-------|--------|
| 1 | Install a local LAMP/XAMPP stack. Run `php -v`. | `php -v` shows version. |
| 2‑7 | Follow the **Concept + Example** table above, typing each snippet into a file and running it. | No syntax errors; output matches expectation. |
| 8‑10 | Build the **Todo‑API** file, create the MySQL table, test with `curl`. | All four HTTP verbs work, data persists. |
| 11‑14 | Refactor: move `Todo` class to its own `Todo.php`, add Composer autoloader, write one PHPUnit test. | `phpunit` passes. |
| 15‑20 | Choose Laravel or Symfony, create a fresh project (`composer create-project laravel/laravel blog`), copy the `Todo` logic into a controller/model, and view it in the browser. | Web page shows todo list, you can add/toggle/delete items. |

You now have **the fastest possible foundation**: you can write plain PHP, interact with a database safely, organise code with functions & classes, and build a tiny REST API. From here the sky’s the limit—add a front‑end, integrate a queue, or dive into a full‑blown framework. Happy coding! 🚀