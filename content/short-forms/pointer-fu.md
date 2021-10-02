---
title: "Pointer Fu: Learning about raw pointers in Rust"
date: 2021-09-12
draft: true
type: bakery
tags: [rust]
image: https://render.fineartamerica.com/images/images-profile-flow/400/images/artworkimages/mediumlarge/1/native-arrows-bri-b.jpg
---

I've been trying to learn how to write my own async executor. One of the components in an executor requires
extensive use of pointers. While I have a fairly decent understanding of pointers, the use of it in this
context went entirely over my head. This presents a great learning moment, so here I am! This will go
over some of the concepts I struggled with.

## Baby steps

* How to create pointers
* Making them is safe
* Dereferencing them is unsafe

## \*const T vs \*mut T

Rust has two pointer types, `*const T` and `*mut T`. The difference between them is actually not so obvious,
for one odd reason. It's safe to cast a `*const T` to a `*mut T`.

```rust
```

Given this, I went searching for the answers on their difference.

The main difference is their *variance*. Variane is a complicated subject so I will not attempt to explain,
lest I teach you the entirely wrong thing! The Rustonicon provides a good explanation of it. Anyway,
the difference between the two pointers is their variance.

* `*const T` is covariant
* `*mut T` is invariant


### Invariance

### Covariance
