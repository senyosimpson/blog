---
title: "Earning the right"
date: 2023-04-23
draft: false
# image: 
---

If you’re like me, you’re overly interested in the technical details of software. It’s not long before
we want to know more about how the database we use works, the intricacies of our operating system or
the best paradigms for writing software. We’re arbitrarily motivated to do deep dives into areas that
are filled with high degrees of complexity or to spend hours figuring out how to optimise the performance
of some software. We’re invested in the technology itself; it is the end, not a means to it. Over time,
I’ve come to realise that while this inclination has been central to my growth as a software engineer,
in the context of my professional career, it comes with a hefty downside — being caught up in the
technology even when its not valuable to the customer. If you’re obsessed with implementation details,
you need a high level of pragmatism to be and remain successful at work.

The central goal of any company is ~~growth~~ to generate profit. Well, at least that’s the goal of
any *reasonable* company. Generating profit means we get to care about everything else because without
profit there is no company. To generate profit, we need to create value.

Software, in the context of a [for-profit company](https://www.vice.com/en/article/5d3naz/openai-is-now-everything-it-promised-not-to-be-corporate-closed-source-and-for-profit),
is a means to an end and that end is creating value. There’s a saying, “It's better to go slowly in
the right direction than go speeding off in the wrong direction”. If you exert energy in the wrong
direction, it doesn’t matter how great of a job you’ve done in creating something, it’s value to your
customers is marginal, if not zero. And so, all the energy you put towards making code “perfect” amounts
to nothing. In and of itself, perfect code is not valuable. It doesn’t matter if its performant
and [scales to handling millions of queries per second](https://news.ycombinator.com/item?id=25326446)
or that is has 100% test coverage and a beautiful integration test suite or that its written in a purely
functional programming language or that it has best-in-class observability. To care about producing
perfect code, you have to earn the right.

To “earn the right” means to create a product of enough value that an increasing number of customers
use it to the point where it makes sense to care about the technical details[^1]. If millions of customers
are using your product each day, you start running into many fun problems: [optimising](https://discord.com/blog/why-discord-is-switching-from-go-to-rust)
the [performance](https://www.notion.so/blog/sharding-postgres-at-notion) of your software systems,
[rearchitecting systems](https://fly.io/blog/carving-the-scheduler-out-of-our-orchestrator/) to handle
increasing load and [improve developer velocity](https://dropbox.tech/infrastructure/atlas--our-journey-from-a-python-monolith-to-a-managed-platform)
and improving [developer](https://stripe.com/blog/migrating-to-typescript) [productivity](https://stripe.com/blog/sorbet-stripes-type-checker-for-ruby).
At this stage, the company and team has earned the right to care about the details.

At the beginning of this post, I mentioned that if you’re obsessed with implementation details, you
need a high level of pragmatism to be successful. The reason is summarised nicely in a quote we’ve all
heard before, “premature optimisation is the root of all evil”. It’s so easy to get wrapped up
in improving the performance of your code or how well it’s encapsulates behaviour or any of the other
1000 things we all want to care about before we've even proven its useful to our customers. At this point,
it's not subject to the type of constraints that necessitate the level of detail we all care about.
And then, we have to ask ourselves, "is it really worth it?". It’s fine shipping it if it gets the job
done[^2]. When you have enough customers, your systems will let you know they need some love. You’ve
earned the right to care.

[^1]: I think it's fair to say the one thing we ought to care about at all times is writing code that is maintainable. This still
does not need to be taken to its logical extreme but we'll be in a bad place if we can't maintain and
improve the software in the first place.
[^2]: As long as it is maintainable
