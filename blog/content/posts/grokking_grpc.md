---
title: "Grokking gRPC"
date: 2020-09-14
draft: true
---

# What is Remote Procedure Call

Remote Procedure Call (RPC) is a communication protocol used between web services. The central idea around RPC is to allow a client application to execute a procedure (function) on a server application as if it were running locally. The networking details are abstracted away from the developer, giving the illusion that the function is executed locally instead of on another server. RPC is commonly used for communications between internal services.

To concretize it, we walk through a typical RPC flow

1. A client calls a function
2. The function is actually an RPC. A request is made to a server to execute the procedure
3. The request contains the parameters to be passed into the procedure
4. The procedure is executed on the server
5. A response is returned to the client containing the result of the procedure execution

From the client's perspective, the procedure seems as if it is running locally. Naturally with any communcation protocol, there are advantages and disadvantages. Martin Kleppmann, in his book [Designing Data-Intensive Applications](https://dataintensive.net), highlights some of the differences between remote and local procedure calls.

* A local function call is predictable and its success depends on factors under your control. In contrast, a networking request is unpredictable and fails to various reasons.
* A local function returns a result, throws an exception or never returns. A networking request, additionally, can return without a result due to a timeout. In this scenario, there is no way to know what occured.
* A network request may be received and execute but only the network *response* fails. Network request failures are often handled by retries but unfortunately in this case, the function would be executed multiple times as you would not know only the responses are getting lost.
* A local function takes a similar amount of time to execute every time it is invoked. Network requests has variable latency due to networking specific issues - network is congested, server is at maximum capacity, etc.

## gRPC

The [gRPC website](https://grpc.io) describes it as a, "modern, open source remote procedure call (RPC) framework that can run anywhere. It enables client and server applications to communicate transparently, and makes it easier to build connected systems". Instead of using JSON as the messaging format, by default gRPC uses protocol buffers. Protocol buffers are a method for serializing/deserializing structured data. Protocol buffer messages are encoded in a binary format. This makes sending them over the wire fast, however, it comes at the cost of human readability. Protocol buffer messages are defined by a schema. This is shown in the tutorial at the end of this post.

# What happened to REST?

REST is the canonical standard for communications over the web. It has been battle-tested in production, extensive tooling exists for implementing RESTful services and most developers are comfortable with designing, building and maintaining RESTful services. Naturally the big question is what is so great about gRPC that we'd forego creating a RESTful service. The answer is fairly straightforward - performance. While there other benefits of using gRPC (HTTP/2, bidirectonal streaming), for the standard use case, performance is the central reason for using gRPC. JSON is much slower to serialize/deserialize than protobufs. At scale, this can lead to a noticeable degradation in performance of the overall system. As protobufs are a binary format, they are much faster to serialize/deserialize - some articles saying there is an improvement of 5-6 times. 

# Tutorial on gRPC in Golang

# References

## RPC

1. https://www.tutorialspoint.com/remote-procedure-call-rpc
2. https://www.geeksforgeeks.org/remote-procedure-call-rpc-in-operating-system/
3. https://searchapparchitecture.techtarget.com/definition/Remote-Procedure-Call-RPC
4. https://en.wikipedia.org/wiki/Remote_procedure_call
5. 

## RPC VS rest

1. https://wecode.wepay.com/posts/migrating-apis-from-rest-to-grpc-at-wepay

## gRPC 

1. https://grpc.io
2. https://en.wikipedia.org/wiki/GRPC

# Protocol Buffers

1. https://en.wikipedia.org/wiki/Protocol_Buffers
2. https://codeclimate.com/blog/choose-protocol-buffers/
3. https://medium.com/better-programming/understanding-protocol-buffers-43c5bced0d47