---
title: "Ergonomic error handling with Rust"
date: 2021-02-20
draft: true
image: https://www.kolpaper.com/wp-content/uploads/2020/07/Vaporwave-Error-Wallpaper.jpg
---

Prior to learning Rust, I never knew error handling was actually a big deal. It never struck me
that there are alternative ways to handling errors, that error messages should be as informative
as possible or even that you should take time to write robust error handling logic in your code.
It seems so obvious in retrospect but in Python-land, there isn't as big a chorus on error handling.
Rust's story is still developing and as a result there are conversations about every aspect of the
language. With a strong emphasis on making writing Rust enjoyable, there is plenty healthy debate
going on. Just ask anyone about async Rust. With that being said, error handling is an ongoing and
important discussion. The language attempts to make error handling ergonomic. I think they've done a
great job of it so far. As I started to read more about error handling, I realised there was so much
I had never considered. Writing good errors and having robust error handling logic are core features
of writing good software. Alongside this, they contribute immensely to developer experience. Anyone
who has come across the Rust compiler will tell you the world of difference its error messages make.
Without further ado, let's jump into the world of error handling.

## Why you should learn about distributed systems

[Why you should learn about distributed systems]: #why-you-should-learn-about-distributed-systems

I have a growing interest in distributed systems. I'm not even sure why because distributed systems are
always broken and you're unsure of everything. You made a request to another service to run a function
and never got a response? Well maybe the service was down or there was a network interruption and it
never got delivered or it got delivered and the request ran successfully but there was a network interruption
on response or the service is completely overwhelmed. As you can see, it's a mess. However, it's not
all doom and gloom! Thankfully, we can be certain about one thing. The system *will* have failures. All.
The. Time. Like I said, great news! In distributed systems, failure is normal. These systems are built
to be fault-tolerant. If there is anything that has stuck with me since learning more about them, it
is this: build for failure. This thinking is applicable in most aspects of software development. Ignoring
error paths is asking for a disaster. How many times have you used software and it returns the world's
the most unhelpful error messages? It once took me about a full working day to debug an error that was
fixed by using a jpg image instead of a png. The error message had absolutely nothing to do with
the image format though and so I wasted countless hours researching and debugging. The application was
not built to handle (reasonable) failures. I'd be lying if I said all the code I have written had great
error handling. In fact, I used to ignore error paths like its nothing. Runtime errors were my best
friend for far too long. Fortunately, I have left my dark ways. Error handling is such an important
part of development precisely because it allows us to handle failure. It improves our ability to
reason about our software; we understand the myriad ways it may fail. When we do have failures, great
error messages allow us to diagnose problems efficiently. This in turn boosts productivity and leads
to an improved developer experience.

## Shifting paradigms

[Shifting paradigms]: #shifting-paradigms

Newer breeds of languages (e.g Rust, Go) have returned to ways of ancient past by returning errors
instead of using exceptions. Coming from Python, I found this strange but quickly became a fan, particularly
of Rust's approach to it (of course). The mix of encoding errors in the type system, making them explicit
in function signatures and enforcing handling them solved a whole host of problems I had been facing
in Python, most of them due to my own sloppiness. There is plenty of debate on exceptions vs returning
errors. While I am a fan of returning errors, there are merits to both approaches.

* Returning errors is explicit. In Python, any function *could* throw an exception. Short of reading
  the source code or the documentation, you're left for dead. If errors are returned, e.g
  `obj, err = func()`, they are pushed onto the developer explicitly. She is at least aware that the
  function may result in an error. It is still left to her to decide to handle or ignore it but she
  does so consciously. Without the explicitness, it is too easy to miss areas of code that should have
  exception handling, purely because you do not even know exceptions are raised. In fairness, statically
  typed languages with exceptions can solve this problem. For example, Java function signatures declare
  the exceptions they throw and the compiler enforces exceptions are handled by the developer. Fortunately
  for all Java developers, there is a loop hole out of that requirement; one that is used all
  [too often](https://www.overops.com/blog/ignore-checked-exceptions-all-the-cool-devs-are-doing-it-based-on-600000-java-projects/).
  Regardless, I enjoy the explicitness of returning errors.
* Exceptions are often misused. They should only be used in *exception*-al cases. This is one of those
  dogmatic phrases in tech but there is some merit behind it. Exceptions do not need to be raised in
  situations where errors are expected. For example, if we need to read a file and know that there is
  a possibility that the file may not exist, an exception should not be raised. We expected this and
  should write our code to handle that situation or propagate that information back to the caller. It's
  not an exceptional situation. However, if we need to read a file and expect the file to be there and
  it is not, an exception can be raised. It's a situation we did not expect and possibly one we do not
  know how to handle. As I have found, this was the original thinking behind exceptions. I quite enjoy
  it. In most circumstances, we have logic to handle known, expected failure cases and when we run into
  truly exceptional situations, we raise exceptions. In reality, exceptions are used freely. One horror
  story I came across, a developer commented about a library he had tried using. It threw exceptions
  for every single non 2xx and 3xx response. That's a great example to highlight where exceptions are
  really useful versus when we can write logic to handle the situation accordingly.
* Pokemon exception handling. In Java and Python, it's possible to catch all exceptions by using syntax
  like `catch Exception` since all exceptions subclass `Exception`. This makes debugging failure modes
  extremely difficult. If your code starts producing weird outputs, it's impossible to tell because errors
  are caught silently by the catch all statement. In reality, this is the fault of the developer but
  developers are lazy and will find loopholes if the system allows.
* It's not entirely rosy in the returning errors camp either though. The biggest problem with returning
  errors is that they are easily ignored and can lead to invalid states. For example, in Go, you can
  write `value, _ := func()` and completely ignore the error. `value` is going to be in an invalid
  state but execution will continue uninhibited. With exceptions, the benefit is that the program will
  crash immediately. Returning errors requires significant discipline from developers, who as we have
  mentioned before, are lazy.

Reviewing all the points above, its difficult to say we have a clear cut winner. Time for a confession:
I lied when I said I prefer returning errors instead of exceptions. I just really like Rust's approach
to error handling, which is actually to say I like the ML family of languages approach to error handling.
Amongst that family, you will find some that use exceptions, others that return errors and others that
use a mixture of both. What is really important, in my opinion, is how the type system supports error
handling.

## How Rust does error handling

### The Result type

Rust takes plenty of inspiration from the ML family of languages. They are functional languages with
a wonderful type system made easier to use by solid type inference. One of the common constructs in
these languages is the `Result` type. A `Result` is an enum that has two possible states: the value
of the computation or an error. To get the value, you have to 'unwrap' `Result`. The compiler can enforce
that `Result` is unwrapped before it is *used* anywhere else. Additionally, the type system won't allow
you to omit unwrapping. For example, `Result<String>` is a different type to `String`. A function expecting
a string as input will have the signature `do_something(s: String)`. Since `Result<String>` is a different
type, you cannot use it in that function. This system enforces the handling of errors. There is no way
to circumvent it due to it being embedded in the type system. This is why error handling in Rust is great.
We get to leave the land of exceptions but it does not allow us to be lazy. Let's take a look at the basics
of error handling in Rust.

```Rust
// This is the result type that either contains the value of 
// the computation Ok(T) where T is the value or an error Err(E)
// where E is the error
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
