---
title: "State machines in Rust"
date: 2021-09-05
draft: false
type: bakery
tags: [rust]
image: https://blog.statechannels.org/static/8228bd64ef4553da6c982bd55c64b867/ef9e5/state-machine.png
---

In Rust, you often hear about state machines. Futures are state machines! I thought it would be cool
to read more about it. I came across [this blog post](https://hoverbear.org/blog/rust-state-machine-pattern/)
(funnily enough, by a friend and mentor of mine) which really helped me! I highly recommend reading it.
In this bakery post, I'm just noting the part I found relevant. The example here is from her blog post.

> P.S.A: Go and read that post 😆

## State Machines

Rust is able to represent state machines quite elegantly. Due to its type system, you can make sure
invariants are upheld. To use a real life example, we can do some basic modeling of [Raft](https://raft.github.io/)
(no knowledge needed for this post). A node in a Raft cluster can be in one of 3 states:

* Candidate
* Follower
* Leader

The possible transitions are:

* Follower -> Candidate
* Candidate -> Leader
* Candidate -> Follower
* Leader -> Follower

Therefore the only invalid state transition is: Follower -> Leader.

Now we can start modeling this. We have a struct `Node` that represents a node in the cluster

```rust
struct Node<S> {
  ...
  state: S
}
```

`S` is a generic parameter over the possible states. Our states are also structs

```rust
struct Follower; // In reality, these are likely to hold some data
struct Candidate;
struct Leader;
```

In Raft, all nodes start in the `Follower` state. We can define a function `new` for that state *only*.

```rust
impl Node<Follower> {
  pub fn new() -> Node<Follower> {
    ..
    state: Follower {}
  }
}
```

We can initialise this like so

```rust
let follower = Node::<Follower>::new();
```

The important thing is that we can't do this for other states! If we do

```rust
let leader = Node::<Leader>::new();
```

we will get an error because we haven't defined the function `new` for `Node<Leader>`. This is super
sweet!

The next thing we need to be able to do is have state transitions enforceable by the compiler.
We can do this using the `From` trait. If we want to transition from `Follower` to `Candidate` we can
implement `From` for it.

```rust
impl From<Node<Follower>> for Node<Candidate> {
  fn from(state: Node<Follower>) -> Node<Candidate> {
    let candidate = Node {
      ..
      state: Candidate {}
    }
    candidate
  }
}
```

We can use it as such

```rust
let follower = Node { state: Follower {}}
let candidate = Node::<Candidate>::from(follower);
```

Now we've gotten the type system on our side! If we don't implement `From` for Follower -> Leader, doing

```rust
let leader = Node::<Leader>::from(follower);
```

will cause a compilation error. Nice!

## Thoughts

On using this design, one issue I came across was implementing general behaviours across all states.
Since each `impl` block is dedicated to a particular state (e.g `Node<Follower>`, `Node<Leader>`),
you have to duplicate any methods you use across them. We can get around this using our favourite
feature: traits! We could have something like

```rust
struct Follower;
struct Candidate;
struct Leader;

trait NodeState {}
impl NodeState for Follower {}
impl NodeState for Candidate {}
impl NodeState for Leader {}

impl <S: NodeState> Node<S> {
    // Generic methods
}
```

We've added the trait bound `NodeState`. All states `S` that implement `NodeState` will have the
functionality in the `impl` block.
