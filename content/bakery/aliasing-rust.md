---
title: "Aliasing and how Rust thinks about it"
date: 2021-09-12
draft: true
type: bakery
tags: [rust]
image: https://financialstreet.ng/wp-content/uploads/2021/04/EITI-targets-revenue-from-non-extractive-industry-.png
---

## What is aliasing?

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

For compiled programs, aliasing makes it difficult to efficiently optimise programs (while maintaining
correctness). The Rustonomicon has a [great example](https://doc.rust-lang.org/nomicon/aliasing.html)
of this which I'll walk through here.

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
