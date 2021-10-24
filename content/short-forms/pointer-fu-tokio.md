---
title: "Pointer Fu: An adventure in the Tokio code base"
date: 2021-10-24
draft: false
type: bakery
tags: [rust]
image: https://render.fineartamerica.com/images/images-profile-flow/400/images/artworkimages/mediumlarge/1/native-arrows-bri-b.jpg
---

[Tokio]: https://tokio.rs/

In an effort to understand the internals of asynchronous runtimes, I've been spending time reading [Tokio]'s
source code. I've still got a long way to go but it has been a great journey so far.

{{< tweet 1450127351917027332 >}}

Raw pointers are used all over Tokio. In one particular instance, the way they used them really blew
my mind 🤯. So here I am, writing about it. Buckle in 💺.

## Setting the scene

We have a type `Cell` that is defined as (taken directly from Tokio source)

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

It's used when initialising a struct `RawTask`

```rust
struct RawTask {
  ptr: NonNull<Header>
}

// This is pseudocode
impl RawTask {
    fn new() -> RawTask {
        let ptr = Cell::new(); // returns a raw pointer to a Cell

        // Cast pointer to one that points to a Header
        let header_ptr = ptr as *mut Header;
        let ptr = NonNull::new(header_ptr); 
        RawTask { ptr }
    }
}
```

## What is so interesting?

First, a necessary detour! Rust can represent structs in memory in multiple ways. It's covered
in detail in the [The Rust Reference](https://doc.rust-lang.org/reference/type-layout.html#representations).
By default, Rust offers *no guarantee* on the memory layout of your struct; it is free to
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
this doesn't make sense to you, check out the [addendum](#addendum)). However, by default, Rust provides
no guarantee that `Header` will remain the first struct field! Instead, as you can see, they've changed
the representation to the `C` layout. In `C`, struct fields are stored in the order they are declared.
This gives us the guarantee we need. Now we can go around dereferencing the pointer to `Header` without
any worry!

```rust
let cell = Cell::new();
let cell_ptr = &cell as *mut Cell;
let header_ptr = cell_ptr as *mut Header;

let header = unsafe { *header_ptr };
```

## Addendum

View in [Rust playground](https://play.rust-lang.org/?version=nightly&mode=debug&edition=2021&gist=8451396f7892fb3330900d1b5a086997)

```rust
#[derive(Debug, Clone, Copy)]
struct Header {
    x: u32
}

#[derive(Debug, Clone, Copy)]
struct Core {
    y: u8
}

#[derive(Debug, Clone, Copy)]
struct Task {
    header: Header,
    core: Core
}

fn main() {
    let header = Header { x: 256 };
    let core = Core { y: 10 };
    
    // Even though there is no guarantee on memory layout, it should
    // be stored in order of declaration because there is no other
    // way to store the struct that would result in more efficient
    // memory usage
    let task = Task { header, core };
    
    // Create raw pointer to task
    let task_ptr = &task as *const Task;
    // Cast pointer to point to Header
    let header_ptr = task_ptr as *const Header;
    
    // Dereference header_ptr
    // We expect this to give us our Header struct as defined above.
    // Because Header is the first field and the pointer is pointing
    // to the beginning of the Task struct , it is valid to perform
    // this dereference
    let header_from_ptr_deref = unsafe { *header_ptr };
    
    // Dereference task_ptr
    // We expect this to give us our Task struct as defined above
    let task_from_ptr_deref = unsafe { *task_ptr };
    
    println!("Header from deref: {:#?}", header_from_ptr_deref);
    println!("Task from deref: {:#?}", task_from_ptr_deref);
    
    // Bonus: we can also cast task_ptr into a pointer to Core
    // However, because its struct member is a u8 and Header's member
    // is storing 256, which u8 cannot represent, dereferencing
    // core_ptr will produce a corrupted Core struct
    let core_ptr = task_ptr as *const Core;
    let core_from_ptr_deref = unsafe { *core_ptr };
    println!("Core from deref: {:#?}", core_from_ptr_deref);
}
```

The output of running this gives you. Note that `Core` we obtained from dereferencing has `y=0`
instead of `y=10`.

```
Header from deref: Header {
    x: 256,
}

Task from deref: Task {
    header: Header {
        x: 256,
    },
    core: Core {
        y: 10,
    },
}

Core from deref: Core {
    y: 0,
}
```
