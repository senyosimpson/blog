---
title: "Pointer Fu: An adventure in the Tokio code base"
date: 2021-10-22
draft: true
type: bakery
tags: [rust]
image: https://render.fineartamerica.com/images/images-profile-flow/400/images/artworkimages/mediumlarge/1/native-arrows-bri-b.jpg
---

[Tokio]: https://tokio.rs/

In an effort to understand the internals of asynchronous runtimes, I've been spending time reading [Tokio]'s
source code. I've still got a long way to go but it has been a great journey so far.

{{< tweet 1450127351917027332 >}}

Raw pointers are used all over Tokio. In one particular instance, the way they used them really blew
my mind 🤯 So here I am, writing about it. Buckle in 💺.

## Setting the scene

We have a struct, `RawTask` defined as

```rust
struct RawTask {
  ptr: NonNull<Header>
}
```

A `RawTask` is roughly initialised like so (this is psuedo-code)

```rust
fn new() -> RawTask {
  let ptr = Cell::new(); // this returns a raw pointer to a Cell

  // Cast this pointer to one that points to a Header
  let header_ptr = ptr as *mut Header;
  let ptr = NonNull::new(header_ptr); 
  RawTask { ptr }
}
```

The type `Cell` is defined as (taken directly from Tokio source)

```rust
#[repr(C)]
pub(super) struct Cell<T: Future, S> {
    /// Hot task state data
    pub(super) header: Header,

    /// Either the future or output, depending on the execution stage.
    pub(super) core: Core<T, S>,

    /// Cold data
    pub(super) trailer: Trailer,
}
```

## What is so interesting?

First, a necessary detour! Rust can represent structs in memory in multiple different ways. It's covered
in detail in the [The Rust Reference](https://doc.rust-lang.org/reference/type-layout.html#representations).
By default, Rust offers *no guarantee* on the memory layout of your struct. This means it is free to
modify the layout however it wants. From a developer perspective, it means you cannot write any code
that makes assumptions on the memory layout of your struct. To change the representation of the struct,
you can use the `repr` attribute (as shown in the above definition of `Cell`).

Now, here's where it gets good! I omitted the comment for the `Cell` struct, which is

```rust
/// The task cell. Contains the components of the task.
///
/// It is critical for `Header` to be the first field as the task structure will
/// be referenced by both *mut Cell and *mut Header.
```

Hopefully some alarm bells started ringing in your head 🚨. `Header` has to be the first field in the
struct. This is so that you can dereference a pointer to `Cell` into either a `Cell` or a `Header` (if
this doesn't make sense to you, check this [Rust playground example](https://play.rust-lang.org/?version=nightly&mode=debug&edition=2021&gist=8451396f7892fb3330900d1b5a086997)
out). However, by default, Rust provides no guarantee that `Header` will remain the first struct field!
Instead, as you can see, they've changed the representation to the `C` layout. In `C`, struct fields
are stored in the order they are declared. This gives us the guarantee we need. Now we can go around
dereferencing the pointer to `Header` without any worry!

```rust
let cell = Cell::new();
let cell_ptr = &cell as *mut Cell;
let header_ptr = cell_ptr as *mut Header;

let header = unsafe { *header_ptr };
```
