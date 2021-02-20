---
title: "Error handling in Rust"
date: 2021-02-20
draft: true
image: https://www.kolpaper.com/wp-content/uploads/2020/07/Vaporwave-Error-Wallpaper.jpg
---

Before coming into Rust, I never knew error handling was such a *big* deal. Rust's story is still
developing and as a result there are conversations about every aspect of the language. As there is
a massive emphasis on making developing in Rust enjoyable, you can imagine how much healthy debate
goes on. Just ask anyone about async Rust. With that being said, error handling is an ongoing and
important discussion. The language attempts to, successfully in my opinion, make error handling ergonomic.
As I started to dig into it, I realised there was so much I had never considered. I am convinced writing
good errors and good error handling are some of the most important parts of writing good software. Alongside
this, they contribute immensely to the developer experience. Anyone who has come across the Rust compiler's
errors messages will tell you the world of difference they have made. Without further ado, let's
jump into the world of error handling.

I have a growing interest in distributed systems. In distributed systems, the strongest guarantee you have
is that they will fail; failure is normal. These systems are built to have a high tolerance to failure. If
there is anything that has stuck with me since diving into the world of distributed systems, it's "build
for failure". This thinking rapidly permeates to all aspects of software development. When writing code,
ignoring error paths is asking for a disaster. I know from experience, that used to be yours truly. Runtime
errors were my best friend for an unreasonably long period of time 😆. I have subsequently left my dark ways.
Error handling is such an important part of development precisely because it allows us to handle failure.
Other than telling you something wrong happened, errors should be informative. They make understanding code
and the myriad ways it may fail easier to digest. Debugging is made significantly easier by good error messages
and handling.

Newer breeds of languages (e.g Rust, Go) have turned to returning errors instead of having exceptions. I am
biased towards this paradigm (specifically the way Rust and other ML languages handle it) but for the sake
of fairness, let's discuss the pros and cons of both approaches. Some of the reasons exceptions are seen as
undesirable in modern languages:

* Exceptions are hidden. When looking at a function signature, there's no indication of whether an exception
  will be thrown. This is not strictly true across all languages. For example, Java function signatures can declare
  the exceptions they throw. Dynamic languages naturally don't do this. In Python, every function *could* throw
  an exception. Short of reading the source or the documentation, there's no way to know if it will be thrown.
* Exceptions are often misused. They should only be thrown in *exception*-al cases, being caught and handled otherwise.
  Often this is not the case. Even in cases where they could be gracefully handled, exceptions are thrown. In some way,
  this is a problem with the *programmer* and not the paradigm. However, paradigms that can be misused will most likely
  be and therefore, it's better for it to enforce sane behaviour by its definition.
* Exceptions are used for control flow. The problem with using exceptions for control flow is that they obscure your
  code. It makes difficult for a developer to follow the path of execution through the code base.
* Pokemon exception handling. In Java and in Python (and possibly others), it's possible to catch all exceptions by using    
  syntax like `catch Exception` since all exceptions subclass `Exception`. This makes debugging failure modes extremely
  difficult. If your code starts producing weird outputs, it's impossible to tell because errors are caught silently by
  the catch all statement.
* Try-catch syntax is verbose.

Some advantages of returning errors:

* It is explicit. This is not strictly true as dynamic languages won't have this either. However, since a function    
  returns a value and/or an error, you cannot assume the value is valid unless you have checked if an error has
  occured. This makes it easy to handle failure cases in code.
* Unrecoverable errors are uncommon. In Go and in Rust, there is a `panic` construct. When a program panics, it
  crashes and dies. There is no recovery possible. Often times, panicking is left to the application level. Library
  code never panics, rather passing the error up to the caller to decide if it can continue. This is great as you have
  strong guarantees on your code never failing unexpectedly. Panics are reserved for severe cases.
* It encourages proper error handling. I say encourage because it is very easy to ignore errors in Golang. Similarly,
  exceptions are often ignored resulting in programs crashing. Alternatively, they are caught with a catch all try-except
  and life moves on. Rust makes it impossible to ignore errors if you need to use the value but we will come back to that.
* 






## How Rust does error handling

## Errors vs exceptions

## Making it ergonomic
[Making it ergonomic]: #making-it-ergonomic

- Result type
- ? operator
- panics

## Making it informative

- Chaining errors
- Adding context
- Custom errors
- https://stackify.com/common-mistakes-handling-java-exception/

## The future of error handling

- Error reporting


## Bib

* https://dave.cheney.net/2012/01/18/why-go-gets-exceptions-right