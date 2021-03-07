---
title: "Error handling in Rust"
date: 2021-02-20
draft: true
image: https://www.kolpaper.com/wp-content/uploads/2020/07/Vaporwave-Error-Wallpaper.jpg
---

Before coming into Rust, I never knew error handling was such a *big* deal. Rust's story is still
developing and as a result there are conversations about every aspect of the language. As there is
a strong emphasis on making writing Rust enjoyable, you can imagine how much healthy debate
goes on. Just ask anyone about async Rust. With that being said, error handling is an ongoing and
important discussion. The language attempts to make error handling ergonomic. I think they've done a
great job of it so far. As I started to dig into it, I realised there was so much I had never considered.
I am convinced that writing good errors and good error handling are part of the core tenets of writing
good software. Alongside this, they contribute immensely to developer experience. Anyone who has
come across the Rust compiler's errors messages will tell you the world of difference they make.
Without further ado, let's jump into the world of error handling.

## A kind introduction

I have a growing interest in distributed systems. In distributed systems, the strongest guarantee you
have is that they will fail; failure is normal. These systems are built to have a high tolerance to
failure. If there is anything that has stuck with me since diving into the world of distributed systems,
it's "build for failure". This thinking rapidly permeates to all aspects of software development. When
writing code, ignoring error paths is asking for a disaster. I know from experience, that used to be
yours truly. Runtime errors were my best friend for an unreasonably long period of time 😆. I have
subsequently left my dark ways. Error handling is such an important part of development precisely
because it allows us to handle failure. This makes understanding code and the myriad ways it may fail
easier to digest. Debugging is also made significantly easier by good error messages and handling.

Newer breeds of languages (e.g Rust, Go) have turned to returning errors instead of using exceptions.
Coming from Python, I found this strange but quickly became a fan, particularly of Rust's approach to
it. The mix of encoding errors in the type system, making them explicit in function signatures and
enforcing explicitly handling errors solved a whole host of problems I had been facing in Python,
some of them due to my own sloppiness. Some of the reasons I prefer this paradigm:

* Exceptions are hidden. With Python being a dynamically typed language, looking at a function signature
  gives you no indication of whether an exception will be thrown. Any function in Python *could* throw
  an exception. Short of reading the source code or the documentation, you're left for dead. Statically
  typed languages with exceptions can solve this problem. For example, Java function signatures declare
  the exceptions they throw.
* Exceptions are often misused. They should only be used in *exception*-al cases. This is one of those
  dogmatic phrases in tech. In reality, this is contextual. For example, if you need to read a file and
  have no upfront expectation that it should be there, it is not an exceptional case and an exception
  should not be thrown. The logic should handle it. However, if you do expect the file to be there,
  throwing an exception makes sense. Unfortunately, in many cases where exceptions don't need to be
  thrown, they are. In some way, this is a problem with the *programmer* and not the paradigm. However,
  paradigms that can be misused will most likely be and therefore, it's better for it to enforce sane
  behaviour by its definition. An example I heard of in a discord server was an old old library that threw exceptions
  on every non 2xx and 3xx response. This a bad use case of exceptions as getting errors is normal case
  and should be handled properly without throwing.
* Exceptions are often used for control flow. The problem with using exceptions for control flow is that
  they obscure your code. It makes difficult for a developer to follow the path of execution through
  the code base.
* Pokemon exception handling. In Java and in Python, it's possible to catch all exceptions by using syntax
  like `catch Exception` since all exceptions subclass `Exception`. This makes debugging failure modes
  extremely difficult. If your code starts producing weird outputs, it's impossible to tell because errors
  are caught silently by the catch all statement. This is again one of the cases that's the fault of the
  developer but the system gives you an easy way out. In fact, a similar thing happens in Golang too.
  Since you can write `value, _ := funcWithErrReturn()`, you can just ignore the error.
* Try-catch syntax is verbose.

Some advantages of returning errors:

* It is explicit. This is not strictly true as dynamic languages won't have this either. However, since
  a function returns a value and/or an error, you cannot assume the value is valid unless you have checked
  if an error has occured. This makes it easy to handle failure cases in code.
* Unrecoverable errors are uncommon. In Go and in Rust, there is a `panic` construct. When a program
  panics, it crashes and dies; there is no recovery possible. Often times, panicking is left to the application
  level. Library code never panics, rather passing the error up to the caller to decide if it can continue.
  This is great as you have strong guarantees on your code never failing unexpectedly. Panics are reserved
  for severe cases.
* It encourages proper error handling. I say encourage because it is very easy to ignore errors in Golang.
  Similarly, exceptions are often ignored resulting in programs crashing. Alternatively, they are caught
  with a catch all try-except and life moves on. Rust makes it impossible to ignore errors if you need
  to use the value but we will come back to that.
* There is normal control flow. Since errors are just returned, control flow is easy to follow.

## How Rust does error handling

### The Result type

Part of Rust's roots are tied to the ML family of languages. They are functional languages with a strong
type system made easier to use by solid type inference. One of the constructs common in functional languages
is the `Result` type. A `Result` is an enum that has two possible states: the value of the computation
or an error. The benefit here is that `Result` is its own type and can thus be type checked. To get the
value, you have to 'unwrap' `Result`. The compiler can enforce that `Result` is unwrapped before it is
*used* anywhere else. Additionally, the type system won't allow you to omit unwrapping. For example,
`Result<String>` is a different type to `String`. A function expecting a string as input will have the
signature `do_something(s: String)`. Since `Result<String>` is a completely different type, you cannot
use it in that function. This system enforces the handling of errors and the compiler can check if it
has done so. So how do we unwrap?

```Rust
enum Result<T, E> {
   Ok(T),
   Err(E),
}
```

```Rust
let mut f = File::create("ferris.txt");  // Returns Result<File>

// To unwrap we can match on the enum variants
let file = match f {
  Ok(file) => file,
  Err(e) => panic!("File could not be created")
};

match file.write_all("Hi Ferris") {
  Ok(_) => {},
  Err(e) => panic!("Could not write to file")
}
```

Rust has several convenience methods/syntax such as `unwrap`, `expect`, `?` which help to remove some
of the boilerplate.

### Panicking

In Rust, irrecoverable errors are signaled using the construct `panic`. When a panic is reached, a programmer
is essentially saying, "the program execution cannot continue any further after encountering this error".
Panics are a terminal state; the program crashes as a result. They are meant to be infrequent, with standard
error handling taking care of common cases. we've already seen panic being used in Rust in the above example.

```Rust
match file.write_all("Hi Ferris") {
  Ok(_) => {},
  Err(e) => panic!("Could not write to file") // If this branch executes, program crashes
}
```

### Bubbling errors

In many cases, you do not want an error to be handled at the point of contact. Instead, you would prefer
to have that error be handled by the caller of the function, leaving it to the caller to decide how to
proceed. In programming perlance, we want to "bubble" the error the caller. In Rust, we can achieve this
using matching

```Rust
fn init() -> Result<(), io::Error> {
  let mut file = match File::create("ferris.txt") {
    Ok(f) => f,
    Err(e) => return Err(e) // returns an error to the caller
  }

  match file.write_all("Hi Ferris") {
    Ok(_) => return Ok(()),
    Err(e) => return Err(e)
  }
}

// Caller of function gets error and then panics on failure
match init() {
  Ok(_) => {},
  Err(_) => panic!("Could not initialise")
}
```

### Making it ergonomic

As I mentioned earlier, Rust has a number of convenience methods/syntax to reduce the boilerplate. There
are three that are commonly used: `unwrap`, `expect` and `?`.

#### ?

When bubbling errors, you can imagine that writing the above match statement becomes cumbersome. It's
boilerplate that the language can handle for you. A similar problem exists in Go. If you ask Gophers
what line of code they write the most, you'll get the same answer: `if err != nil {}`. The Rust language
designers took care of matching boilerplate by introducing the `?` syntax. This automatically bubbles
the error to the caller on an error occuring.

```Rust
 // Before we would write code like this
fn init() -> Result<(), io::Error> {
  let mut file = match File::create("ferris.txt") {
    Ok(f) => f,
    Err(e) => return Err(e) // returns an error to the caller
  };

  match file.write_all("Hi Ferris") {
    Ok(_) => Ok(()),
    Err(e) => return Err(e)
  };
}

// With the `?` operator, we can write it as
fn init() -> Result<(), io::Error> {
  let mut file = File::create("ferris.txt")?;
  file.write_all("Hi Ferris")?;
}
```

As you can see from the above example, our syntax is significantly less verbose while being functionally
identical. This is one of those small things that makes the world of difference when writing Rust. It
shows the commitment to a friendly developer experience.

#### unwrap

There are often scenarios where you want to opt out of error handling. This may be when you're prototyping
and don't want to go through the effort of setting up robust error handling or when you know that a function
won't fail (e.g if you need to read a file that you know will always exist). To get out of it, you can
use the `unwrap()` method. `unwrap` returns the `Ok` variant with it's value if the computation succeeds
or will panic on error.

```Rust

// Notice how we don't need the return type anymore
fn init() {
  // We use `unwrap()` to panic if it fails otherwise execution continues
  let mut file = match File::create("ferris.txt").unwrap();
  file.write_all("Hi Ferris").unwrap();
}
```

If we try create a file in a location we do not have permission to access, the code will panic, causing
the program to crash. An example of a panic message

```
thread 'main' panicked at 'called `Result::unwrap()` on an `Err` value: Os {
code: 13, kind: PermissionDenied, message: "Permission denied" }',
src/main.rs:4:36
```

While this provides an easy escape to error handling, it's not recommended for production code. There
are cases where it is permissible (as with everything). If we can guarantee it won't fail or we want
execution to panic at that point, it is permissble. One issue with `unwrap` is that error messages can
be uninformative. We can do one better by using `expect`.

#### except

The `except()` method is identical to `unwrap()` but it allows you to set an error message. This conveys
your intent and makes debugging easier.

```Rust

// Notice how we don't need the return type anymore
fn init() {
  // We use `unwrap()` to panic if it fails otherwise execution continues
  let mut file = match File::create("ferris.txt")
    .expect("Could not create file `ferris.txt`");
  file.write_all("Hi Ferris").expect("Could not write to file");
}
```

This generates the message

```
thread 'main' panicked at 'Could not create file `ferris.txt`: Os {
code: 13, kind: PermissionDenied, message: "Permission denied" }',
src/main.rs:4:36
```

As we can see, Rust has a strong focus on making error handling a frictionless experience for the
developer. There are many other functions that I have not gone through here: `map_err`, `map_or_else`,
`unwrap_or`, `unwrap_or_else` and many others. If you're new to Rust, I encourage you to give them a
look. I know I certainly will as I improve the quality of my error handling.

## Making it informative

An aspect of writing good errors is to make them highly informative. Without good error messages,
debugging becomes extremely difficult. Either that or you've learnt how to read horribly cryptic
messages. C++ programmers, you're *obviously* suffering from Stockholm syndrome given that you
survive these crazy error messages 😆.

```
rtmap.cpp: In function `int main()':
rtmap.cpp:19: invalid conversion from `int' to `
   std::_Rb_tree_node<std::pair<const int, double> >*'
rtmap.cpp:19:   initializing argument 1 of `std::_Rb_tree_iterator<_Val, _Ref,
   _Ptr>::_Rb_tree_iterator(std::_Rb_tree_node<_Val>*) [with _Val =
   std::pair<const int, double>, _Ref = std::pair<const int, double>&, _Ptr =
   std::pair<const int, double>*]'
rtmap.cpp:20: invalid conversion from `int' to `
   std::_Rb_tree_node<std::pair<const int, double> >*'
rtmap.cpp:20:   initializing argument 1 of `std::_Rb_tree_iterator<_Val, _Ref,
   _Ptr>::_Rb_tree_iterator(std::_Rb_tree_node<_Val>*) [with _Val =
   std::pair<const int, double>, _Ref = std::pair<const int, double>&, _Ptr =
   std::pair<const int, double>*]'
E:/GCC3/include/c++/3.2/bits/stl_tree.h: In member function `void
   std::_Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::insert_unique(_II,
    _II) [with _InputIterator = int, _Key = int, _Val = std::pair<const int,
   double>, _KeyOfValue = std::_Select1st<std::pair<const int, double> >,
   _Compare = std::less<int>, _Alloc = std::allocator<std::pair<const int,
   double> >]':
E:/GCC3/include/c++/3.2/bits/stl_map.h:272:   instantiated from `void std::map<_
Key, _Tp, _Compare, _Alloc>::insert(_InputIterator, _InputIterator) [with _Input
Iterator = int, _Key = int, _Tp = double, _Compare = std::less<int>, _Alloc = st
d::allocator<std::pair<const int, double> >]'
rtmap.cpp:21:   instantiated from here
E:/GCC3/include/c++/3.2/bits/stl_tree.h:1161: invalid type argument of `unary *
```

Error messages should be highly informative and guide a developer to uncover the cause of the error
without excessive cognitive overhead. Rust has made this core emphasis of the language. The compiler
is extremely helpful. This tweet summarises it nicely

{{< tweet 1348669062528774148 >}}

Focusing on good error messages has permeated throughout the community. There's even the
[Error Handling Project Group] if you weren't convinced how committed the language designers are to
getting this right. There are a number of techniques we can use to make our errors more informative.
Along the way, we will discuss the crates that can help.

### At the root

The first question we have to ask is

> Are we writing an application or a library?

I had never considered that your approach to structuring error handling is different depending on
whether you are writing an application or library. This [article](https://nick.groenen.me/posts/rust-error-handling/)
illuminated this difference to me.

Some of the key components of error handling in libraries:

* Libraries should never panic/crash. From the application programmer's point of view, panics are
  undefined behaviour; there is no expectation that a library call will crash an application.
  All errors should be bubbled up to the caller and give it the responsibility of handling the error.
  This is generally a healthier software pattern as it caters for a wide variety of use cases.
* As far as possible, use custom errors. This two main benefits:
  * It significantly improves the amount of information captured in the error message. This make it
    faster to debug sources of error. Finding which library produced the error and what the error means
    is much easier under this model.
  * Improves the cardinality of errors in application. If all applications produced the same error types,
    it would be difficult to analyse error data. Finding out a simple question like, what is contributing
    to such error rates, becomes non-trivial when they are grouped as one.
  



* Chaining errors
* Adding context
* Custom errors
* ErrorKinds
* https://stackify.com/common-mistakes-handling-java-exception/

* Chaining errors
* Library vs app
* Create custom errors. Thiserror is good for this in library code
  *therwise you can use anyhow
* Failure tips for different types of error handling
* Make them informative. Add context

## The future of error handling

* Error reporting - eyre

## Bib

* https://dave.cheney.net/2012/01/18/why-go-gets-exceptions-right
* https://benkay86.github.io/rust-error-tutorial.html#enum_error
* https://doc.rust-lang.org/std/result/

[Error Handling Project Group]: https://github.com/rust-lang/project-error-handling
