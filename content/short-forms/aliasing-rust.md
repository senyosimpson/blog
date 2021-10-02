---
title: "Aliasing and how Rust thinks about it"
date: 2021-09-12
draft: true
type: bakery
tags: [rust]
image: https://financialstreet.ng/wp-content/uploads/2021/04/EITI-targets-revenue-from-non-extractive-industry-.png
---

The [Wikipedia](https://en.wikipedia.org/wiki/Aliasing_(computing)) definition of aliasing describes
it as

> A situation in which a data location in memory can be accessed through different symbolic names

Simply put, it is when multiple variables point to the same piece of data. For example, in Python

```python
a = b = {"hello": "world"}
```

Both `a` and `b` point to the same data. If you update `a`, `b` is updated as well.

```python
a = b = {"hello": "world"}
a["hello"] = "python"

print(a)  # {"hello": "python"}
print(b)  # {"hello": "python"}
```

Rust has strict aliasing rules. This has two primary benefits:

* It reduces human error by disallowing unintuitive behaviour
* It makes it easier for the compiler to optimise code

## Disabling your footgun

Lenient aliasing rules often cause developers to write code that behaves in unexpected, unintuitive
ways. I've certainly done this more then once when writing Python. For example

```python
hashmap = {"hello": "world"}
new_hashmap = hashmap
new_hashmap["world"] = "hello"

print(hashmap)       # {"hello": "world", "world": "hello"}
print(new_hashmap)   # {"hello": "world", "world": "hello"}
```

This feels unintuitive. It's easy to assume `new_hashmap` is separate from `hashmap`. Instead, we've
modified the same data. `new_hashmap` is an *alias*, not a copy. Here's another example. I've made this
mistake countless times.

```python
def insert(hashmap, key, value):
    hashmap[key] = value
    return hashmap

hashmap = {"hello": "world"}
new_hashmap = insert(hashmap, "world", "hello")

print(hashmap)       # {"hello": "world", "world": "hello"}
print(new_hashmap)   # {"hello": "world", "world": "hello"}
```

Turns out, `hashmap` is passed by reference ([sort of](https://robertheaton.com/2014/02/09/pythons-pass-by-object-reference-as-explained-by-philip-k-dick/))
and modifies the same object so *all* of our variables are updated. To achieve what we want, we have
to copy it manually

```python
from copy import deepcopy

def insert(hashmap, key, value):
    hashmap[key] = value
    return hashmap

hashmap = {"hello": "world"}
new_hashmap = deepcopy(hashmap)
new_hashmap = insert(new_hashmap, "world", "hello")

print(hashmap)       # {"hello": "world"}
print(new_hashmap)   # {"hello": "world", "world": "hello"}
```

Now `new_hashmap` behaves as expected. What is funny though is that this doesn't apply across the board.

```python
def append(tup, value):
    return tup + (value,)

tup = ("hello", "world")
new_tup = tup
new_tup = append(new_tup, "python")

print(tup)      # ("hello", "world")
print(new_tup)  # ("hello", "world", "python)
```

This has to do with Python's rules. Dictionaries (hashmaps) are mutable while tuples are immutable. Therefore
a tuple must be copied since it cannot be changed after initialisation whereas a dictionary can be modified.
However, that's not immediately obvious!

Rust makes this explicit. By default, variables are immutable. You have to mark them as mutable to modify
them.

```rust
use std::collections::HashMap;

let hashmap = HashMap::new();      // Not declared as mutable
hashmap.insert("hello", "world");  // Not allowed since hashmap is not mutable
```

Let's make it mutable and see what happens

```rust
use std::collections::HashMap;

let mut hashmap = HashMap::new();  // Marked as mutable
let mut new_hashmap = hashmap;

hashmap.insert("hello".to_string(), "world".to_string());  // Compiler kicks up a fuss!

println!("{:#?}", hashmap);
println!("{:#?}", new_hashmap);
```

Here are Rust's aliasing rules at work! The compiler tell us

```
  |
4 |     let mut hashmap = HashMap::new();
  |         ----------- move occurs because `hashmap` has type `HashMap<String, String>`,
  |                     which does not implement the `Copy` trait
  |
5 |     let mut new_hashmap = hashmap;
  |                           ------- value moved here
6 |     
7 |     hashmap.insert("hello".to_string(), "world".to_string());
  |     ^^^^^^^ value borrowed here after move
```

What has happened is that 


Before explaining, let's make the compiler happy

```rust
use std::collections::HashMap;

let mut hashmap = HashMap::new();  // Marked as mutable
let mut new_hashmap = hashmap.clone(); // Compiler is happy!

hashmap.insert("hello".to_string(), "world".to_string());
new_hashmap.insert("world".to_string(), "hello".to_string());

println!("{:#?}", hashmap);      // {"hello", "world"}
println!("{:#?}", new_hashmap);  // {"world": "hello"}
```

## Need for speed

For compiled programs, aliasing makes it difficult to efficiently optimise programs. The Rustonomicon
has a [great example](https://doc.rust-lang.org/nomicon/aliasing.html) of this which I'll walk through
here.

We have a function

```rust
fn compute(input: &u32, output: &mut u32) {
    if *input > 10 {
        *output = 1;
    }
    if *input > 5 {
        *output *= 2;
    }
}
```

We want the optimised version of our function to be

```rust
fn optimised_compute(input: &u32, output: &mut u32) {
    let cached_input = *input; // keep `*input` in a register
    if cached_input > 10 {
        *output = 2;
    } else if cached_input > 5 {
        *output *= 2;
    }
}
```

In the original version, we have two *separate* if statements. Since `10 > 5`, `output == 2` for all
values above 10. We can avoid double assigning `output` under that condition by directly assigning
`output = 2`. This is what we've done in the optimised version.

This is where aliasing comes into play. If `input` and `output` overlap and we keep the same optimised
version of our function, our program will be incorrect. For example, let's look at how the original
function works if `input` is set to the same value as `output` i.e `compute(&x, &mut x)`.

```rust
                    // input ==  output == 0x12345678
                    // *input == *output == 20
if *input > 10 {    // true  (*input == 20)
    *output = 1;    // NB: this also overwrites *input, because they point to the same memory location
}
if *input > 5 {     // false (*input == 1)
    *output *= 2;
}
                    // *input == *output == 1
```

In the above case, `output` equals 1. Now our optimised code is invalid!

Fortunately, the above doesn't apply to Rust and our optimisation still works. The reason for this: our
favourite feature - the borrow checker. The borrow checker limits the effect aliasing has on Rust programs
by enforcing its rules. With respect to references, the rule is

> At any given time, you can either have:
>
> * one or more immutable references to a resource
> * exactly one mutable reference to a resource

Therefore, we can't call `compute(&x, &mut x)` because we have an immutable and mutable reference at
the same time. By enforcing this rule, Rust is able to optimise code efficiently.
