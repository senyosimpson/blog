---
title: "The 8 fallacies of distributed computing"
date: 2020-30-08
draft: true
---

The 8 fallacies of distributed computing are a set of assumptions developers often make about distributed
systems. I found them rather intriguing after first encountering them in this [blog post](https://ably.com/blog/8-fallacies-of-distributed-computing)
by [Ably](https://ably.com/) which I highly recommend reading. They give insight into some of the challenges
of building distributed systems. The 8 fallacies are:

1. The network is reliable
2. Latency is zero
3. Bandwidth is infinite
4. The network is secure
5. Topology does not change
6. There is one administrator
7. Transport cost is zero
8. The network is homogenous.

## The network is reliable

Networks are notoriously unreliable. This was a major surprise for me initially. We get accustomed to
the idea of networks being reliable - your browsers loads the page most of the time and when it doesn't,
you click refresh before you even really consider a network fault probably occured. Networks fail all
the time, for a myriad of reasons - power failures, network switch failure, DDoS attacks,
[fire](https://www.datacenterdynamics.com/en/news/fire-destroys-ovhclouds-sbg2-data-center-strasbourg/),
[ships](https://www.bbc.com/news/world-europe-jersey-38146787),
[sharks](https://www.theguardian.com/technology/2014/aug/14/google-undersea-fibre-optic-cables-shark-attacks).
You get the point.

Two common methods for solving network unreliability are: automatic retry systems and building
redundancy into the system. Automatic retries sounds simples but there are a number of gotchas.
For example, imagine you a payment processor. A request comes in, it succeeds but the response
is lost due to a network failure. The client times out due to no response and retries its request.
Without clever design, you'll end up processing the payment twice! This is fixed by writing idempotent
services. There are other issues such as retry storms as well. Not so easy!

Redundant systems prevent failures by reducing reliance on one logical system. For example, if you have
a system that is replicated in many unrelated data centers, it can handle a data center going offline.
If one goes down, all traffic can be routed to the other data center and service will continue without
hiccup.

## 