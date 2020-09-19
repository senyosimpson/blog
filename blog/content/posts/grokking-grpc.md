---
title: "Grokking gRPC"
date: 2020-09-14
draft: false
image: https://grpc.io/img/icons/feature-3.svg
---

If you are similar to me, you've kept hearing about gRPC but have little idea of what it actually is, what its use cases are and why everyone keeps speaking about it. Initially, I thought it must be *another* buzzword being thrown around. Fortunately, I was wrong 😆. I've spent a couple of days reading and learning more about it. This blog post is a comprehensive summary of all I've learned. I hope you enjoy it! 

# What is Remote Procedure Call?

Remote Procedure Call (RPC) is a communication protocol used between web services. The central idea around RPC is to allow a client application to execute a procedure (function) on a server application as if the procedure was running locally. The networking details are abstracted away from the developer making it simple to use.

To concretize it, a bird's eye view of a typical RPC flow:

1. A client calls a function
2. The function is actually a remote procedure call. A request is made to a server to execute the procedure
3. The request contains the parameters to be passed into the procedure
4. The procedure is executed on the server
5. A response is returned to the client containing the result of the procedure execution

From the client's perspective, the procedure seems as if it is running locally. This is a great abstraction, however there are pitfalls. Martin Kleppmann, in his book [Designing Data-Intensive Applications](https://dataintensive.net), highlights some of the differences between remote and local procedure calls.

* A local function call is predictable and its success depends on factors under your control. In contrast, a networking request is unpredictable and fails for various reasons.
* A local function returns a result, throws an exception or never returns. A networking request, in addition, can return without a result due to a timeout. In this scenario, there is no way to know what occured.
* A network request may be received and execute but only the network *response* fails. Network request failures are often handled by retries but unfortunately in this case, the function would be executed multiple times as you would not know only the responses are getting lost.
* A local function takes a similar amount of time to execute every time it is invoked. Network requests have variable latency due to networking specific issues - network is congested, server is at maximum capacity etc.

## What is gRPC?

The [gRPC website](https://grpc.io) describes it as a, "modern, open source remote procedure call (RPC) framework that can run anywhere. It enables client and server applications to communicate transparently, and makes it easier to build connected systems". It was created by Google and subsequently open-sourced in 2016. gRPC has driven the resurgence of communications using RPC. With the move towards service-oriented architectures, it has found a natural home in service-to-service communications.

gRPC uses protocol buffers (protobufs) - a method for serializing/deserializing structured data. Protocol buffer messages are encoded in a binary format. This makes it fast to send information over the wire; at least in comparison to textual formats such as JSON. The use of protocol buffers alongside the great and easy to use tooling around gRPC has made it the preferred framework for implementing RPC.

As with any technology, there are advantages and disadvantages. This [article](https://docs.microsoft.com/en-us/aspnet/core/grpc/comparison?view=aspnetcore-3.1) by Microsoft highlights some of the them. In summary

**gRPC Advantages**

* Performance - gRPC is fast in comparison to other protocols
* Code generation - server and client code is automatically generated from a single file
* Streaming - gRPC supports HTTP streaming

**gRPC Disadvantages**

* Limited browser support - there is limited support for HTTP/2 in the browser
* Not human readable - gRPC uses a binary format and therefore is not human readable.

# Protocol Buffers

As stated above, protocol buffers are a method for the serializing/deserializing structured data. Protocol buffer messages are defined using a schema consisting of key-value pairs.

```protobuf
message Person {
  string name = 1;
  int32 id = 2;
  string email = 3;
}
```

You can think of Person as a struct. Each field is a key-value pair and is annotated with their respective data type. Each field has a number associated to it which is used as the key. In actual fact, the key contains the field number and information about the type of data being encoded/decoded in order to determine the length of the value. This is commonly referred to as the tag. As an example, if we have a protobuf message

```protobuf
message Test2 {
  string b = 2;
}
```
with the value of `b` set to `testing`, the corresponding encoding will be

```
12 07 74 65 73 74 69 6e 67
```

The bytes `12` and `07` form the tag. The value `12` is decoded to give the field number 2 and the data type string. The value `07` is decoded to give the length of the value which is 7 in this case. As you can see, there are 7 bytes remaining which give the value of the string. If you are interested, you can find more information about the protocol buffer encoding from the [official guide](https://developers.google.com/protocol-buffers/docs/encoding). This example is actually from there albeit with much less detail.

# What happened to REST?

REST is the canonical standard for communications over the web. It has been battle-tested in production, extensive tooling exists for implementing RESTful services and most developers are comfortable with designing, building and maintaining RESTful services. Naturally the big question is what is so great about gRPC that we would forego creating a RESTful service? The answer is fairly straightforward: performance. While there are other benefits of using gRPC such as the use of HTTP/2 or bidirectonal streaming, for the standard use case, performance is the central reason for adopting it. JSON is much slower to serialize/deserialize than protobufs. At scale, this can lead to a noticeable degradation in performance of the overall system. As protobufs are a binary format, they are much faster to serialize/deserialize. some articles claiming there is an improvement of 5-6 times. 

# gRPC by example

Nothing is ever complete without some code examples! I've tried to make this as easy to follow as possible. Let me know if any improvements can be made. All the code can be found [here](https://github.com/senyosimpson/tutorials/tree/master/grokkingrpc). We will implement the service in the [Quick Start](https://grpc.io/docs/languages/go/quickstart/) section of the gRPC website. I'm using Golang for this tutorial.

One snag that got me was related to the automatic code generation from the proto files. There is a move towards a new Golang plugin for the protobuf compiler (it performs the automatic code generation). The old (which I used) and new version output slightly different files and so I couldn't follow the code in the official grpc [examples](https://github.com/grpc/grpc-go/tree/master/examples/helloworld) repository. To make things simple, this tutorial uses the old Golang plugin. Awesome, let's get into it 🥳

***

The service is really simple, all it does is greet a person. The client can send a request containing a name to the server. The server produces a simple message, `"Hello <name>"`. To recap, the server is responsible for executing the procedure and returning the result to the client. From the client's perspective, the procedure ran locally.


First things first, the dependencies need to be installed. 

1. Protobuf compiler - installation [instructions](https://grpc.io/docs/protoc-installation/)
2. Golang plugin for the Protobuf compiler - installation [instructions](https://grpc.io/docs/languages/go/quickstart/) 

We create our protobuf schema `helloworld.proto`.

```protobuf
syntax = "proto3"; // This denotes the protobuf version

// All protobufs have a package name. This is to avoid name clashes with other protocol
// message types. In Golang, the package name is used as the Go package name for the
// generated files. This is however overwritten if you specify the go_package option
package helloworld; 

// This option is specifies the full import path of the Go package that contains
// the generated code.
option go_package = "github.com/senyosimpson/tutorials/grokkingrpc/helloworld";

// This defines the service. In a service, you define rpc methods. These are
// method signatures that contain their request and response types.
service HelloWorld {
    rpc Greet(HelloRequest) returns (HelloReply) {}
}

// Messages are defined by specifying their type and name of the variables it holds.
// These are enumerated from 1 to n.
message HelloRequest {
    string name = 1;
}

message HelloReply {
    string message = 1;
}
```

Now that we have our protobuf schema, we can generate the Go files. These files will have an extension `.pb.go`. To do so, execute the command

```bash
protoc -I helloworld/ helloworld/helloworld.proto --go_out=plugins=grpc:helloworld --go_opt=paths=source_relative
```

Now that we have our generated files, we're ready to create our server. If you look in the generated file, `helloworld.pb.go`, you should find an interface named `HelloWorldServer`. 

```go
// HelloWorldServer is the server API for HelloWorld service.
type HelloWorldServer interface {
	Greet(context.Context, *HelloRequest) (*HelloReply, error)
```

We have to implement this interface to define our service. In the implementation, the server prints out that it received a given name. It returns a reply message that contains the greeting, `Hello <name>`.

```go
type helloWorldService struct {}

func (s *HelloWorldServer) Greet(ctx context.Context, r *pb.HelloRequest) (*pb.HelloReply, error) {
    log.Printf("Received: %v", r.GetName())
	return &pb.HelloReply{Message: "Hello " + r.GetName()}, nil
}
```
As an fyi, the function `GetName` is automatically generated. This can be found in the `helloworld.pb.go` file.

The rest of the necessary code is implementing the server itself. The full code
```go
package main

import (
	"context"
	"log"
	"net"

	pb "github.com/senyosimpson/tutorials/grokkingrpc/helloworld"
	"google.golang.org/grpc"
)

type helloWorldServer struct{}

func (s *helloWorldServer) Greet(ctx context.Context, r *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", r.GetName())
	return &pb.HelloReply{Message: "Hello " + r.GetName()}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	server := grpc.NewServer()
	pb.RegisterHelloWorldServer(server, &helloWorldServer{})
	if err := server.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

The client is straightforward, I just copied it from the examples repository. The main line of consequence is the request to the server.

```go
r, err := client.Greet(ctx, &pb.HelloRequest{Name: name})
```
Here we see the client calling the `Greet` method. A request message is passed in with a specified name.

```go
package main

import (
	"context"
	"log"
	"os"
	"time"

	"google.golang.org/grpc"
	pb "github.com/senyosimpson/tutorials/grokkingrpc/helloworld"
)

const (
	address = "localhost:50051"
)

func main() {
	// Set up a connection to the server.
	conn, err := grpc.Dial(address, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	client := pb.NewHelloWorldClient(conn)

	// Contact the server and print out its response.
	name := "Bas"
	if len(os.Args) > 1 {
		name = os.Args[1]
	}

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := client.Greet(ctx, &pb.HelloRequest{Name: name})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.GetMessage())
}
```

We're now ready to test it! In one terminal, start the server. In the other, we can run the client code and make requests to the server. In the image below, the server is on the left and client on the right. We can see the client gets back the reply message and prints the message to the console.

{{< figure src="/images/grokkingrpc/two.png" height="50px" >}}

And that's it! I hope you've taken something valuable out of this walkthrough of the basics of gRPC. I've certainly enjoyed learning and writing about it.


# References

### RPC

1. [Remote Procedure Call - Tutorialspoint](https://www.tutorialspoint.com/remote-procedure-call-rpc)
2. [Remote Procedure Call - Geeks for Geeks](https://www.geeksforgeeks.org/remote-procedure-call-rpc-in-operating-system/)
3. [Remote Procedure Call - Wikipedia](https://en.wikipedia.org/wiki/Remote_procedure_call)

### gRPC VS REST

1. [Migrating APIs from REST to gRPC](https://wecode.wepay.com/posts/migrating-apis-from-rest-to-grpc-at-wepay)

### gRPC 

1. [gRPC Official Website](https://grpc.io)
2. [gRPC - Wikipedia](https://en.wikipedia.org/wiki/GRPC)

### Protocol Buffers

1. [Protocol buffers - Wikipedia](https://en.wikipedia.org/wiki/Protocol_Buffers)
2. [5 Reasons to use protocol buffers](https://codeclimate.com/blog/choose-protocol-buffers/)