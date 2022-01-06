---
title: "2021: A retrospective"
date: 2021-12-22
draft: true
image: https://img.freepik.com/free-vector/hand-opening-curtain-with-funny-monster-group-illustration-monsters-cute-alien-friendly-cool-cute-hand-drawn-monsters-collection_40453-1498.jpg
---

2021 has simultaneously been the longest and shortest year ever. For the most part it has felt
lacklustre but looking back there were great wins and lessons learned.

## Wins

* I gave my first ever tech talk! It was at the [Rust London meetup](https://www.meetup.com/Rust-London-User-Group/)
  on [error handling in Rust](https://senyosimpson.com/posts/rust-error-handling/)
* It gave me the confidence to do more [talks](https://senyosimpson.com/talks/). I ended up doing 6
  this year 🚀
* As a result of giving talks, I've met a bunch of people in the Rust community. It's the first professional
  community I've felt a part of and it has been wonderful
* Learning Rust continues to be one of the best economic decisions I've made. It has brought a number
  of amazing career opportunities my way
* I transitioned into a software engineering role focusing on infrastructure and tooling

## Lessons

Here. We. Go.

### Best practices

This summarizes my lesson on best practices

{{< tweet 1253833306279276545 >}}

At the start of 2021, I reached out to a staff engineer I admire and asked about advocating for best
practices. He said the exactly what I needed to hear

> Best practice should be used extremely sparingly as an argument to anything. Best practice is such
> an overused term to the point where it’s become quite meaningless because it rarely talks about the
> organisational issues that stem beneath.

Issues or no issues, the important part is that best practice is dependent entirely on the context you
operate within. For companies in highly regulated industries with highly sensitive data, security best
practices will look different to companies dealing with non-sensitive data. Software engineers in the
aerospace industry would likely laugh at the testing best practices present in most consumer SaaS companies.
A 40 year old organisation with millions of lines of code that have passed through the hands hundreds
of engineers is going to have an entirely different set of best practices to those of a 2 year old
startup with thousands of line of code across 3 engineers that written for the cloud. It is easy
to look at an organisation and criticize because we live and operate in different contexts. The truth
of the matter is that thousands of companies are providing value to their customers with entirely different
sets of best practices. This immediately tells us that there is no one set of best practices.

This is obviously not to say that there is no such thing as best practice. There are definitely practices
we can agree on: test your code, pay off technical debt, do not store passwords in plaintext. However,
the extent to which these practices are implemented and the manner in which they are depends on your
context. Take *inspiration* from other companies - don't just consume and think "we're doing it all wrong
and no one listens to me!". Best practices come in different shapes and sizes.

### Situational context

[^1]: A [good read](https://truelayer.com/blog/how-we-evaluate-and-adopt-new-technology) on how to evaluate adopting new technology and why we should [keep it boring](https://mcfunley.com/choose-boring-technology)

{{< tweet 1437419560005775364 >}}

If there is one lesson that has rooted itself deep inside my mind it is this one, both in my personal
life and professionally. As a developer, time and time again, I've made the mistake of ignoring my context.
And time and time again, I've seen other developers ignore their context. This is most obvious with new,
shiny technology and paradigms. Microservices! Rust! NoSQL! Distributed tracing! Chaos engineering!

{{< tweet 1407269523942612996 >}}

All these are fantastic when utilised in the right situation. That, and I reiterate, depends entirely
on your context. Sometimes, a newly founded startup needs to use a microservice architecture from the
get go, other times they don't. Sometimes, you need to use Cassandra for your data store, most of the
time Postgres is just fine.

There are plenty of factors to consider when adopting new technology[^1]

* Do we have enough expertise to use it successfully? If we don't have the expertise, are we willing
  to hire in or pay for training?
* How large is the community? Will we have the neccessary support?
* Has it been around long enough that we can expect it to be maintained for the next 20 years? What
  happens if it is sunset?
* How easy is it to change if we adopt the wrong technology?

I think I've made my point. Look at your own surroundings.

### Advocacy

{{< tweet 1414625192786251779 >}}

This was a particularly interesting lesson for me to learn. At the time, I was advocating for improving
the testing quality and coverage. In my naivety, I thought it would be an easy sell. We all know testing
is good engineering practice, let's do more of it. Makes sense? As I learned, testing for the sake of
adhering to "best practice" is an extremely poor justification. What I was missing was a social/business
reason to spend time improving our testing:

* Our builds are passing but the application repeatedly fails in production and we're losing X amount
  of time a week due to it
* It takes me an extra X minutes to ensure my changes aren't going to break the application
* We've accidently shipped breaking changes X times due to lack of tests, impacting every team's productivity

These are all compelling reasons to improve testing; there is a clear problem they are addressing.
Tech does not live in a vacuum removed from the social dynamics and complexity of an organisation.
The aim of most software is not to be an artefact of great engineering. While we may have great technical
reasons for addressing aspects of our code or development process, they must be married with a social/business
reason. It is important to remember that everyone has different incentives, pressures, contexts and
unfortunately for us engineers, very few of those people actually care about the quality of the code.
However, they do care about how fast we can ship new features, how much revenue our products can generate,
how customers feel about our products. Marry the business concerns with technical concerns and you've
significantly increased your odds of seeing a green light on your proposed changes.

### Psychological safety

To this day, I've never really shaken the off that tinge of fear when deploying to production. That feeling,
while entirely self-inflicted and mostly irrational, made me understand (technical) psychological safety.
Anyone that knows me well enough knows that Rust is my favourite programming language. One pillar of
its design is: *fearless* concurrency.

> Fearless concurrency allows you to write code that is free of subtle bugs and is easy to refactor
> without introducing new bugs.

In the same way Rust empowers you to develop concurrent software without fear, so should our systems
empower us to develop without fear. It is trivial to see that fearless development teams will have increased
velocity. When you're developing, you don't want to have to double check and perform mental gymnastics
to ensure you're not writing to a production database. To what extent psychological safety improves
velocity is debatable but it is definitely an ingredient in the elusive equation of developer velocity.

For teams to be fearless, production systems need safety rails. Developers need to feel enough psychological
safety that they are happy to experiment and deploy to production, knowing that they won't affect production.
Of course, we cannot prevent everything but that is beside the point. Humans make mistakes and without
safety rails, your production database *will* be dropped.

How exactly to improve psychological safety when developing is something I'm looking forward to exploring
in the upcoming year. From my perspective, can be anything from ensuring good unit test coverage to
having [robust production testing](https://copyconstruct.medium.com/testing-in-production-the-safe-way-18ca102d0ef1)
capabilities to ensuring the correct database privileges. The overarching goal is to build your systems
to ensure developers feel psychologically safe.

### Developer productivity

In his essay on [working at Stripe](https://www.kalzumeus.com/2020/10/09/four-years-at-stripe/),
[Patrick McKenzie](https://twitter.com/patio11) speaks to Stripe's ability to move faster than the
average startup.

> A stupendous portion of that advantage is just consistently choosing to get more done. That sounds
> vacuous but hasn’t been in my experience. I have seen truly silly improvements occasioned by someone
> just consistently asking in meetings “Could we do that faster? What is the minimum increment required
> to ship? Could that be done faster?”

Developer productivity is similar in that development teams need to continuously ask, "how do we improve
our own productivity?". An effective way to do that is by baking in leverage into your development processes.
Point 8 here

{{< tweet 1464070975910293506 >}}

From my own experience, a significant portion of lost productivity is simply from having to repeatedly
interact with messy manual processes (that are automatable) and incorrectly/undocumented systems. Yesterday
it was spending an extra two hours getting a system working because the documentation was out of date,
today it is an extra 24 minutes configuring yet another EC2 instance. The "easy" fix is to find the areas
where developers are losing the most time and work on incrementally improving them. This is the type
of work that has compounding effects. On activities that are performed with high frequency (e.g testing
services locally), even a 1% improvement on time spent can have an outsized impact on development velocity.

> I don’t think Stripe is uniformly fast. I think teams at Stripe are just faster than most companies,
> blocked a bit less by peer teams, constrained a tiny bit less by internal tools, etc etc.

### Sharing work publicly

The tweet says it all

{{< tweet 1469312906508619777 >}}

### Twitter

I clearly tweet a lot. Or maybe not.

{{< tweet 1480065554203525122 >}}

### Web3

I still do not understand it.

## 2022

Upwards and onwards  
To infinity and beyond  
Aluta continua  
To an unforgettable year
