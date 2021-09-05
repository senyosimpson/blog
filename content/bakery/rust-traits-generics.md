---
title: "Two learnings on implementing traits"
date: 2021-09-05
draft: false
type: bakery
tags: [rust]
---

Some time ago, I came across two challenges with implemeting traits:

* Implementing a trait on another trait
* Using multiple, separate traits bounds on a trait implementation

## Implementing a trait on another trait

Honestly, I've forgotten why I wanted to do this. Nonetheless, this is not possible in Rust. And rightfully
so, can you imagine how much of a mess that would be? However, the way around this is through a neat
Rust feature: trait bounds! I'd never internalised them before this. They're in
[The Book](https://doc.rust-lang.org/book/ch10-02-traits.html#using-trait-bounds-to-conditionally-implement-methods)
though. Definitely well worth reading again.

With a trait bound, we can implement a trait for all types that implement some other trait.

```rust
trait MyTrait {}

impl<T: Clone + Copy> MyTrait for T {}
```

This implements `MyTrait` for all `T` that implement `Clone` and `Copy`. Another way to say it is it
implements `MyTrait` for all *types* that implement `Clone` and `Copy`. So if we have

```rust
struct MyStruct;
impl Clone for MyStruct {}
impl Copy for MyStruct {}
```

then `MyStruct` implements `MyTrait` because `MyStruct` is a type that implements `Clone` and `Copy`.

This is exactly what we need! We can have traits that are effectively implemented on other traits,
albeit in a roundabout way.

## Multiple, separate trait bounds

In learning on the above, I was wondering if you could have multiple trait bounds over a generic parameter.
For example

```rust
impl<T: Clone + Copy> MyTrait for T {}
impl<T: Send + Sync> MyTrait for T {}
```

turns out, you can't do that (most of the time). Rust will complain saying there are conflicting implementations.
Why? Well, because you cannot guarantee that these trait bounds are mutually exclusive i.e that a type
`T` either implements `Copy + Clone` or `Send + Sync` but never both. If there is a type `T` that implements
all those traits, then which implementation should it use? Conflict! Therefore, the only way to do the
above is to have traits that are mutually exclusive. An example is `Unpin`. You cannot have a `T` that
implements both `Unpin` and `!Unpin` naturally since they are in opposition. Since this is hardly ever
true for the standard use of traits, you only have one chance at defining traits over a generic parameter.
The natural option is to do something like

```rust
impl <T: Clone + Copy + Send + Sync> MyTrait for T {}
```

However, this becomes part of your API, thus enforcing a contract you may not wish to enforce. So when
doing this, think carefully!
