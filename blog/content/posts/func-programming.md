---
title: "Takeaways from a dive into Clojure"
show_reading_time: True
date: 2020-06-21
draft: true
---

This year I had a goal to learn a functional programming language, carried over from last year because who actually achieves their goals, right? To be fair, I did make an attempt and started to learn Haskell. That did not fair well as I really could not figure out how to create anything with Haskell after going through a brief introduction. I am a hands-on learner so I gave up after that. Around April this year, on recommendation from one of my mentors, I decided to look into Clojure. It turned out to be a great suggestion and I've been enjoying hacking away in Clojure ever since! With all that being said, I have been pleasantly surprised by the language, learning plenty along my way.

Clojure is a functional programming language *and* is a dialect of Lisp (insert link). Coming from an object-oriented and imperative coding background, both of these ideas were new to me. I'll dedicate the first portion of this post to the Lisp aspects of Clojure and the second portion to functional programming.

# What is Lisp?

## Code as Data, Data as Code

One of the central philosophies in Lisp is the idea of homoiconicity, commonly known as code-as-data. A homoiconic language is one that treats code as regular data that can be manipulated by the language itself. This has two obvious advantages. The first is that it is easy to extend the language - new features or additions to the language can be created by manipulating already known constructs in the language (i.e macros). There is no inherent need to wait for new versions of the language to be introduced to gain features you need urgently, you can just create them yourself. The second is, if necessary, the language can modify itself on during execution. Considering the code is data that can be manipulated, at any point in the program, it can adjust its code to perform a different set of functions.

Concretely, Lisp code is stored as a valid data structure, an [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree). One of the design goals of the language was to make the correspondence between the syntax and the resulting ast as direct as possible. Consider the Clojure code

```clojure
(+ 4 (+ 2 3))
```
This generates the ast

{{< figure src="/images/clojure/ast.png" caption="Abstract Syntax Tree" height="100px" width="50px" >}}

This is the internal representation and is evaluated when the code is executed. However, given that `+` is just a function and the rest are literals, the expression can be stored as a list

```clojure
'(+ 4 (+ 2 3))
```
Now we have a list with the elements `+, 4, (+ 2 3)`. One can imagine we can rearrange this, replace the first operator, replace the second function, etc. This will result in a list that can be converted into the adequate ast. Through this capability, we arrive at code-as-data, data-as-code.

# Function Composition and Testing
* No classes

# Data First Paradigm
    * Don't modify objects that represent some data but the data itself
    * Due to above, more transparency in the actual code
    * Operations on Data
    * Code is thought of as functions really

# Lisp Syntax and Structural Code

    * Clean Syntax
    * AST Tree
    * Easy to follow
    * Lack of syntax really makes you productive
    * Separation of side-effecting code

# Immutable Data

