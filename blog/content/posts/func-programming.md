---
title: "Takeaways from a dive into Clojure"
show_reading_time: True
date: 2020-06-21
draft: true
---

This year, one of my gaols was to learn a functional programming language. I carried this over from last year because who actually achieves their goals, right? To be fair, I did make an attempt - I began learning Haskell. Let's just say, I'll try again one day! Around April this year, on recommendation from one of my mentors, I decided to look into Clojure. It turned out to be a great suggestion and I've been enjoying hacking away in Clojure ever since! With all that being said, I have been pleasantly surprised by the language, learning plenty along the way.

Clojure is a functional programming language *and* a dialect of [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)). Coming from an object-oriented and imperative coding background, both of these ideas were new to me. I'll dedicate the first portion of this post to the Lisp aspects of Clojure and the second portion to functional programming.

## Lisp

List processing (Lisp) is a programming language created by John McCarthy in 1958. It is designed to make processing lists simple and efficient (hence the name). During its peak, its main use case was in artificial intelligence research. Clojure is a dialect of Lisp, giving it some useful properties common to all Lisp languages.

### S-Expressions

A symbolic expression (s-expression) is the syntax used in the Lisp language and its variants. It provides a representation of a nested list of data. In Lisp, both code and data are represented as s-expressions which leads to the philosophy of *code as data*. Examples of s-expressions

```clojure
(+ 2 3)
; => 5
(+ 2 (+ 3 3))
; => (+ 2 6) => 8
```
A useful property of s-expressions is that they provide a uniform structure. All syntax follows the structure `(operator arg1 arg2 ...)`. This maps well to tree-structured data (as will be discussed further on) and makes writing compilers more trivial. In the above example, the first line adds numbers 2 and 3 to give 5. In the second line, we have a nested list. The inner operation is performed first and then the outer operation - first 3 and 3 are added to give 6 and then 2 and 6 are added to give the final result of 8.

For most programmers, this syntax is strange - I certainly found it awkward to work with in the beginning. After some time with it, I really began to enjoy it. The simple structure of the language makes reading and writing code straightforward. It lends itself to concise and readable functional code which made the process of learning functional programming easier. Considering we often want to chain a set of functions to apply to some data, having this uniform syntax made the mental model of how to achieve your goal simple. For example

```clojure
(add 4 (multiply 3 (subtract 8 4)))
; => (add 4 (multiply 3 4)) - (subtract 8 4) is computed to give 4
; => (add 4 12) - (multiply 3 4) is computed to give 12
; => 16 ; the final output is 16 as we add 4 and 12
```

### Code as Data, Data as Code

One of the central philosophies in Lisp is the idea of homoiconicity, commonly known as *code as data*. A homoiconic language is one that treats code as regular data that can be manipulated by the language itself. The main advantage of a homoiconic language is that it is easy to extend the language through the use of macros - new features or additions to the language can be easily created by manipulating already known constructs in the language. There is no inherent need to wait for new versions of the language to be introduced to gain features you need urgently, you can just create them yourself. 

Concretely, Lisp code is stored as a valid data structure, an [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) (ast). One of the design goals of the language was to make the correspondence between the syntax and the resulting ast as direct as possible. Consider the Clojure code

```clojure
(+ 4 (+ 2 3))
```
This generates the ast

{{< figure src="/images/clojure/ast.png" caption="Abstract Syntax Tree" height="100px" width="50px" >}}

This is the internal representation and is evaluated when the code is executed. However, given that `+` is just a function and the rest are literals, the expression can be stored as a list

```clojure
'(+ 4 (+ 2 3))
```
Now we have a list with the elements `+, 4, (+ 2 3)`. One can imagine we can rearrange this, replace the first operator, replace the second function, etc. This will result in a list that can be converted into the adequate ast. Through this capability, we arrive at *code as data, data as code*.

## Functional Programming

Functional programming is a programming paradigm that is based on the composition and application of functions - the core construct in the paradigm. Programs are built from composing multiple pure functions together. Given this structure, functional programming does not maintain or mutate state. This is in stark contrast to object-oriented programming where code is built around objects that have state and that state can be mutated. The core tenets of functional programming are

* Pure functions
* No side effects
* Immutability
* Function composition
* First-class functions
* Referential transparency

### Pure Functions

Pure functions are functions that return the same output for a given input. An example of a pure function is

```clojure
; this function squares a number
; in Clojure, the last evaluated expression is returned
(defn square-num [x]
  (* x x))

(square-num 2)
; => 4
```

This function will *always* give the same output if the same input is given no matter how many times it is invoked. The other important aspect of a pure function is that is has no side effects (i.e it does not mutate state).

### No Side Effects

Side effects occur when a function mutates state out of its context. Side effects make it harder to reason about code; it is not always easy to understand the flow of data. Example of side effects are reading or writing files, updating databases, creating database connections, printing to the console, so on and so forth. Naturally, functional programs cannot completely rid themselves of side effects, however, they are often separated from the data and are integrated in a principled manner. An example of a function with a side effect

```clojure
(defn add-numbers [a b]
  (let [num (+ a b)] ; binds the value (+ 4 3) to num
    (println "hello")
    num) ; to return the number
)

(add-numbers 4 3)
; => hello
; => 7
```

This example, while simple, adequately highlights a side effect. When adding the numbers, "hello" is printed to the console. In this case, it is a fairly harmless side effect. In other situations it may be detrimental. Imagine the function updated a database with the calculated number. The outcome of the function is different every time it is executed as it is adding data to a database. The reason that this can be difficult to reason about is that the function gives no indication such an effect would occur.


### Immutability

Functional programming relies heavily on immutability. This means once declared, structures cannot be modified. For example in a mutable language, you can do

```python
x = 1
x = x + 1
```
This is not possible in functional programming. In functional programming we can create a *new* variable but we can't update an already instantiated variable. This, again, brings the benefit of making it easier to reason about code and understand the flow of data through a program. Another advantage of immutable data structures is that it makes concurrency much easier to implement. Since objects cannot change once defined, they can be shared amongst threads without qualm.

Naturally, a common question is how do you write any useful code without mutable data structures. This requires a mental shift in the way you write programs - instead of having objects that are mutated as a program executes, you have data that is transformed as the program executes. Every time the data is transformed, a new output is created, leaving the input as it was. Clojure provides backdoors to mutability when necessary but it is not idiomatic Clojure. To formalise this, lets look at the same code done in a mutable manner and an immutable manner

```python
class Car:
    def __init__(self, engine_on=False):
        self.engine_on = engine_on

    def start(self):
        self.engine_on = True

    def stop(self):
        self.engine_on = False

car = Car(False)
car.engine_on == False
# => True
car.start()
car.engine_on == True
# => True
car.stop()
car.engine_on == False
# => True
```
In this case, we have an object and we mutated its state (i.e the `engine_on` variable).

Functional programming languages do not have classes. Instead, we store this data as a hash map/dictionary.

```clojure
; this defines a variable called car with a key engine-on set
; as false
(def car {:engine-on  false})

; a function that switches a car engine on. In this case,
; the assoc function returns a new map with the key
; updated to true
(defn switch-engine-on [car]
  (assoc car :engine-on true))

; a function that switches a car engine off. In this case,
; the assoc function returns a new map with the key
; updated to false
(defn switch-engine-off [car]
  (assoc car :engine-on false))

; the car is passed into the function switch-engine-on
; which returns a new map with the key updated to true.
; the next operation fetches the value of engine-on.
; Finally true? checks whether the value is true
(true? (:engine-on (switch-engine-on car)))
; => true

; because that function returned a new car map, the
; original car map still has the value engine-on set to false
(false? (:engine-on car))
; => true

; we can chain commands to switch the car on and off
; first the engine is switched on, then it is switched
; off. Then we get the value of the key engine-on.
; finally we check if it is false
(false? (:engine-on (switch-engine-off (switch-engine-on car))))
; => true
```


### Function Composition

Function composition is the act of combining multiple (simple) functions to build more complex functions. Due to functional programming emphasis on purity and mitigating side effects, it lends itself to the pattern of creating multiple small functions which are then combined into bigger functions. We have already seen examples of function composition in previous Clojure code. Function composition is not unique to functional programming, however, the paradigm makes it feel natural. Alongside this, its support for first-class function makes function composition all the more powerful.

### First-class Functions

In simple terms, first-class functions are functions that are treated as variables. This means they can be passed into other functions as arguments, be returned from functions and be saved in variables. First-class functions allow developers to create higher-level with abstractions with functions alone and enables function composition. Other programming languages such as Python also support first-class functions. An interesting use case for first-class functions is the `partial` function. This function takes in a function, binds a set of arguments to the specified values and returns the updated function. Since Python has this function, lets look at it in both Python and Clojure.

```python
from functools import partial

def add(a, b):
    return a + b

# bind the argument a to the value 2. Adder is now a new function
adder = partial(add, a=2)

# we can use adder now and only specify one argument (i.e b)
adder(4)
# => 6
adder(1)
# => 3
adder(-2)
# => 0

# In essence the partial function has done this
def adder(b):
    return add(2, b)
```
Similarly in Clojure

```clojure
((partial + 2) 4)
; => 6
((partial + 2) 1)
; => 3
((partial + 2) -2)
; => 0
```

### Referential Transparency

Referential transparency is when a function can be replaced with the value it returns without changing the program's behaviour. This is dependent on the fact that functions are *pure*. Breaking function purity breaks referential transparency. The main advantages it brings are that it makes code easier to reason about, test, refactor and optimize. A simple example of a referentially transparent function is an addition function

```clojure
(defn add [a b] 
  (+ a b))
```
We can replace that function with its return value and the calling program will still function the same.

```clojure
(let [a (add 2 2)]
  (if (= (add a a) 8) ; in this case, adds a to itself and then compares if it is equal to 8
    (println "Sum function works") ; executes if true
    (println "Error in sum function"))) ; executes if false

; => sum functions works
```
It is clear that if we replace `a` with `4`, the program would work the same, printing `sum function works`. Now imagine we defined the `add` functions as 

```clojure
(defn add [a b]
  (println "Adding" a "and" b)
  (+ a b))
```
In this case, the program would first print `Adding 2 and 2` and then `sum function works`. If we replaced `a` with `4`, we would not get the first print message. This has altered the program and therefore it is not referentially transparent.

## To more Clojure

Learning Clojure has been an enlightening experience. I hope you found some of the takeaways equally as awe-inspiring. It's an awesome language to learn to expand your horizons as a developer and at the same time, is a powerful language in its own right. I've found it to be one of the most productive languages I've used. To more Clojure!