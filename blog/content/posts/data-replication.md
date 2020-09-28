---
title: "Data replication in distributed systems"
date: 2020-09-24
draft: true
---

I've been reading the book, [Designing Data-Intensive Applications](https://dataintensive.net) by Martin Kleppmann. One of the chapters dives into the world of data replication in distributed systems. I always assumed data replication is non-trivial but reading the chapter opened my eyes to the true complexity of doing so and the difficult design choices one has to make. I found it interesting and decided to write about it. This post is an attempt to distil the knowledge from that chapter.

# What is data replication?

Data replication is the act of copying the *same* data across multiple machines. This is a common practice in the development of highly-available software systems. The two leading reasons for data replication:

* In the event one database stops working, the system can continue operating
* To improve the performance of the system. By having replicas, load can be balanced across them

The trouble in data replication is due to handling changes to the data. Propagating changes to all replicas and guaranteeing they have arrived at the same state is non-trivial. The three main algorithms for replicating changes are: single-leader, multi-leader and leaderless replication. We will discuss all three of them in finer detail.

# Single-leader replication

The most common solution for replicating changes is *leader-based replication*. In leader-based replication, all writes are submitted to the primary database, a.k.a the leader. The leader sends the changes to the replica databases, a.k.a the followers. This strategy ensures that all the databases contain the same data. The benefit is that reads can be handled by any of the databases (the leader or the followers). This improves the performance of the overall system as the load is balanced across all the databases.

{{< figure src="/images/data-replication/leader-followers.png" caption="Source: Designing Data-Intensive Applications">}}

## Synchronous vs asynchronous replication

Data replication can be done in a synchronous or asnychronous fashion. In synchronous replication, a request is only successful after the last replica has successfully completed the request. This has the advantage of ensuring that data has successfully been replicated amongst all the replicas. The disadvantage is that if any replica fails to process the request (for e.g due to a networking issue), the request fails even though some of the replicas may have the relevant data. Alongside this, if any of the replicas are slow to process the request, the response time becomes unacceptable. In asynchronous replication, the request is successful once the leader has processed it. This is advantageous as requests are handled quickly (unless the leader itself is under strain) and writes can still be processed if any number of replicas fail. However, this pattern means writes are not durable. If the leader fails and is not recoverable, writes that have not been replicated are lost.

## How to deal with failure

## Under the hood of leader-based replication

By now, I'm sure you're curious to know how is replication implemented. There are a few common methods for doing so.

### Statement-based replication

In statement-based replication, the sql statement itself is passed onto replicas. When a write request is received by the leader, it logs the sql statement and propagates it to the replicas. This approach has a few failure modes

* If a statement contains a nondeterministic function, the writes will be different. For example, if the statement needs the current time, each replica will have a slightly different time.
* Statements that have side effects (e.g a trigger) will be repeatedly called. This is not ideal as it is a waste of computation and may lead to slightly differing results if the side effect is not deterministic.

### Write-ahead-log shipping

Databases usually keep a log containing information of every write processed. This log can be used to build a replica of the database. Using this method, the leader writes every write to the log and propagates the log to each replica. The replica processes the log and builds the data as it is on the leader. The disadvantage with this method is that a log usually describes the data on a low-level - it contains details of which bytes were changed in which disc blocks. This tightly couples the replication process and the storage engine; if the database storage format changes, you have to upgrade the entire fleet of databases at once since the leader and followers cannot have different versions. This makes it impossible to have zero-downtime upgrades - this is unacceptable for many companies.

### Logical log replication

To decouple the replication process and storage engine, different log formats can be used for the storage engine and replication. The replication log is called a *logical log*. This log contains information about writes to the database at a row level.

* For an inserted row, the log contains new values for all columns
* For a deleted row, the log contains enough information to identify the deleted row
* For an updated row, the log contains enough information to identify the updated row and the new values for the changed columns

Using a logical log allows for zero-downtime upgrades. Another benefit is that it is easier for external applications to parse a logical log - this proves useful if there is a need to send the contents of a database to an external system such as a datawarehouse.

## Replication Lag (Should be discussed at the end)

Leader-based replication is great for workloads that mainly consist of reads and few writes. The leader is responsible for processing all the writes while read requests are distributed amongst replicas. This is known as a *read-scaling* architecture. It is only practical with the use of asynchronous replication, however, this brings its own set of challenges all revolving around the consistency of data across all the databases. When a write is made, there is a replication lag - the time it takes for the write to be propagated and applied by the replica. After some time (usually a fraction of a second), all replicas will have the same data and *become consistent*. This is known as *eventual consistency*.

### Read your own writes

Imagine a scenario where a user updates her profile and views it immediately after. The update is a write request which is handled by the leader and propagated to the replicas. The viewing of her profile is a read request and can be handled by any of the replicas. It can so happen that the replica has not processed the write by the time she views her profile, showing her stale data. This situation requires *read-after-write consistency*, also known as *read-your-writes consistency*. This ensures that a user will always see the updated data they submitted *themsleves* but makes no claim as to what state the data will be for other users. There are a number of ways to implement this:

* 