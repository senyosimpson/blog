---
title: "Year one in tech"
date: 2020-12-16T12:03:43+02:00
draft: true
---

One year into my tech journey working full-time - what an amazing ride! I have learnt much more than I expected and grown much more than I expected. I have taken away *way* too many lessons from this year. I often wonder if it ever slows down but my feeling is that it never does. Given it's the end of the year, it's a good time to write about my experience. This is a long post. To make it more palatable, I've split into two sections - the first is core lessons and the second can be thought of as an addendum. I write for you but also for me so consider this a blog post and a journal entry ✍🏾. Time for some reflections!

## Breadth first search

As a junior developer with limited knowledge, the sheer amount of tech to learn is overwhelming. Purely out of curiosity, I spent most of my year in exploration mode. Through this, I managed to get a feel for different technologies, programming languages, architectural patterns, etc. In hindsight, I've realised, it's the best time to explore because you are not expected to be an expert on anything. Additionally, exploring will give you the chance to discover what you really enjoy. I currently work as a machine learning engineer. My interests have gone from machine learning research -> machine learning systems -> software infrastructure and distributed systems (as a more general field instead of machine learning specific). If I didn't spend time reading and surveying the tech landscape, I probably wouldn't have found that I really enjoyed other fields. Another thing I did was play around with several languages: Clojure, Golang and Rust. I found it to be really valuable. From Clojure, I learned about the functional programming paradigm (that's why I chose to learn it) and about the Lisp family of languages. I didn't spend that much time with Golang and did not even mess around with their highly touted concurrency story. To all the Gophers, I'm sorry. However, from Go I learned how a language that keeps it simple can reduce friction during development, being opinionated can be highly beneficial and that you can live without exceptions. Rust is currently my favourite language. Memory safety, ergonomic error handling, strong type systems, pattern matching. The list goes on. Anyway, the point is that, spending time is exploring is advantageous early on in your career, I have certainly found that to be true. It helps build a solid foundation and shapes your thinking.

## Communities matter

Building welcoming and authentic communities matters, possibly more so than the thing they form around. When learning Rust, I quickly came to a standstill. It is a big language and it does not hide any details from you. This makes it fairly difficult to learn and to continuously progress. Around that time, I came across the website, [Awesome Rust Mentors](https://rustbeginners.github.io/awesome-rust-mentors/) where you can find someone to mentor along your Rust journey. That led me to meeting the wonderful [Ana Hobden](https://twitter.com/a_hoverbear?lang=en). Next thing I knew, I'm on a Disord server with a whole bunch of software developers from around the world with many of them being heavy Rust users. It is an amazing community - everyone is welcoming, kind and willing to help. Arguably, the reason I've managed to continue with Rust is the community and not entirely just the language being great. This is a sentiment you often hear in other communities too such as the Golang and Kubernetes communities. Nonetheless, I think community is of the utmost importance and it's value cannot be underrated. Oftentimes, the success of a technology (especially in open source) is, atleast in part, a result of the community that is built around it.

## Coding is a job

At the end of the day, coding is a job. The best reason to code is for **money**. This seems to be a controversial opinion in the tech world with many believing you cannot be good at coding if you do not live and breathe it. Why is it that with tech, there needs to be some "higher purpose" other than money where we do not expect the same of other jobs? People need to make money, coding pays well, a match made in heaven. Our industry's passion porn problem needs to stop. Let people do their thing.

## Building products is hard

I don't think you can appreciate how hard it is to build a product until you are in the process of doing so. Depending on the nature of the product, the technical aspects of it can even be the easiest. There are several dimensions to the process that make it extremely difficult.

* How do we get relevant and accurate customer feedback - It is fairly straightforward to get some feedback. The problem is getting unbiased and accurate feedback. For example, the phrasing of a question can bias the answer. "Did you have a positive experience with this aspect of the product", "Did you have a negative experience with this aspect of the product", "How was your experience of this asepct of the product" are all asking the same underlying question but could swing the pendulum of answers in one direction or the other. Being able to get *accurate* feedback is difficult but essential for the development of a product.
* What is an effective way of marketing the product - It's easy to believe that marketing just requires exposure. The more it is in people faces and the bigger noise you make, the more people will use your product. This is most definitely false, nothing is *that* easy. You have to know your customer and meet them where they are at. This looks different for every company and tailoring your marketing strategy to your context is important is necessary for it to work.
* Prioritising feature development - There are too many features to build and not enough time and people to build them. In my opinion, this is usually a good thing as it forces you to sift through the noise. Nonetheless, prioritising what to work on is a really big headache. Every single feature feels high priority. It's as if not building all the features *right now* will sink your product. There is also the question of whether the features you do decide to build are the right features. There is nothing worse than to build the wrong thing. It is a waste of time and money. Validating that you working on the right features requires good customer feedback and as we already know, that is non-trivial too.
* Balancing speed vs quality - In the startup realm, your aim is to minimize time to market. This presents the common trade-off between speed and quality. Balancing them adequately is difficult. Too much time and you risk being irrelevant. Too low quality and you risk poor product-market fit. Understanding where you can trade-off one for the other is an important part of product development.

All these above points just highlight how difficult it is to build products. It is by no means an insurmountable challenge nor is every mistake equally as costly. For me, the realisation was that building products is just not straightforward and many factors to the success of it are outside the realm of tech.

## Progress is misleading

The hallmark of any high functioning team is efficiency. Very high efficiency. Unfortunately, becoming efficient is something you have to pay for with time. Imagine we have teams A and B. Team A spends 40% of their sprint working on their infrastructure and operations. This includes things like build pipelines, tooling for managing cloud environments, automating repeatable processes and the works. Team B spends 10% of their time doing this kind of work. Both teams have 10 days to build out a feature. Due to team B's policy, by day 3, they are already halfway through building their new feature whereas team A only gets halfway on day 6. Fortunately for team A, their time spent on operations is a once-off cost and is paid back, allowing them to finish by day 10. Team B finishes on day 7 but their deployment story isn't nearly as sleek, adding 4 days. They finish on day 11. Now this is a fairly contrived example but I'm trying to highlight that progress can be misleading. Because team B was already halfway on day 3, they felt like they were making rapid progress. Even if they are significantly slowed down later in the process, it doesn't feel nearly as bad because they are still making progress, albeit more slowly. What does not feel like progress is addressing tooling and infrastructure as it is adjacent to feature development. Team A's policy is based on the belief that they will become faster over time by making it simpler and faster to get work done. The next time they build features, team A can finish in 4 days while team B might finish in 9. They are paying in time today so that tomorrow they move faster.

## Moving fast in machine learning

In my experience, there are two things that slow down machine learning development:

* Poor data management
* Poor end to end (e2e) testing

### Data management

Machine learning is all about data. Models come and go but data is here to stay. Without the requisite infrastructure, tooling and management of your data, you're going to spend ample amounts of time just gathering your data. Only for you to find out that the data is not as pretty and complete as you thought it would be. Without the right data management, the work is pushed onto developers at the time of feature development. Data usually resides in disparate places, is not clean and is not easily queryable. Time is sunk into collecting this data but is not integrated into a system. This means unless that code is shared, anyone working with the same or similar data is going to repeat this process. Worst of all is if that process takes a number of hours to complete - extremely common with batch jobs as the data scales. The last thing you want in this process is a high inertia in just retrieving that data every single time. Hours and hours of dev time lost. Addressing this is once again one of those trade-offs between feature development and operations/infrastructure work. You will have to pay it off, it's up to your team to decide how to make those compromises.

### E2E testing

In many use cases, machine learning models form part of a greater system. To test whether an update has resulted in an improvement, you cannot only test the machine learning model, you have to test the entire system's performance. It's entirely possible that an improvement in the model leads to a degradation in performance of the system. Why? Well let's take an example scenario. You have a machine learning model A. You have downstream components, alpha and beta. Both alpha and beta are tuned to the current performance of model A. When you make an update to model A, your tuning becomes outdated. The entire system now produces worse than before. It's easy to see the remedy - retune alpha and beta. You don't want to do that work if you do not have to though hence you need solid e2e testing. This will give you confidence in your updates and trust your deployments. Without it, you go through a laborious process of trying to validate the system is working as expected through a manual process and possibly an unrobust test suite. This easily causes development time to balloon. Similarly, this is something a team must determine if they want to pay off.

## Seniority is (sometimes) overrated

As a junior, you come in wide-eyed, fresh, hungry to learn and literally know *nothing*. In comparison to you, seniors seem like supreme beings with all their knowledge and experience. However, seniors are not *always* better technically. There are a number of dimensions that make a senior a senior. Obviously depth and breadth of knowledge is one of them but more importantly, it is their ability to reason. Understanding how changes will affect the system, what trade-offs they are making by adopting a certain technology, being able to model the domain well, creating good abstractions, applying architectural patterns when they are a natural fit, etc. These are all things that come with experience (and being burnt several times 😆). The truth is, not all seniors are actually good at this and in the case where they are not, seniority is overrated. Some juniors will match these seniors in technical ability in no time - especially through bootstrapping knowledge by reading books, attending conferences, watching videos, playing around with new technology and so on.

## Scaling startups is difficult

As a developer, when we think scale, we think about X fold increases in the use of our product. This is a common concern because *everything* becomes more difficult when you introduce scale. In the same way scale is difficult for technology, so it is for a startup. Anyone that's ever been part of a fast-growing startup will tell you that during those growth periods, it feels like chaos. The most glaring difficulty during this time is *processes*. How do you go from managing a team of 20 to a team of 100 in a short period of time? Exactly. At this stage in a startups lifecycle, the processes won't have caught up to reality. The business will have to define and redefine its organizational structure, introduce processes to mitigate lack of communication, ensure transparency across the whole team, figure out how to handle hiring for different teams, how to do perforamnce reviews, their promotion structures, their compensation structures. It is *a lot*. Scaling a startup is a journey, one that anyone joining a fast-growing startup should be ready for. It's a great time to be part of a company and see it put through its paces.

## Overcoming silos needs good systems

As the need for more teams emerges and the number of staff increases, communication becomes one of the biggest bottlenecks. Without good communication, silos begin to emerge. Soon enough, tech has no idea what marketing is doing, marketing has no idea what finance is doing, finance has no idea what sales is doing. Nobody knows what any other team is doing. Worst off is when teams are solving the same problem because they don't know other teams have solved it already. This tends to happen in product teams. Product team A will go about building some feature and solve a whole host of technical problems. Later in the year, product team B will encounter and solve a portion of those problems as well, not knowing product team A has done so already. Overcoming silos requires a good system that enables effective communication. A good example of this is AirBnB. They wanted to overcome silos amongst their data teams. They call the process of ensuring insights uncovered by one person/team is effectively transferred to the rest of the company, **scaling knowledge**. In this particular case, they built an internal product called Knowledge Repo which could be used by data scientists to share their work. It's a centralised space so people can look up all work done by various teams there. This a good way to scale communication in this particular use case. Silos are a massive issue. Miscommunication causes tension, misunderstandings and reduces the productivity of the company as a whole. Continously ensuring communication is good is important.

## Software is all about trade-offs

Software has many camps full of evangelists. Just start a conversation about using Vim and I am sure you'll encounter some of them. For example, I'm sure this guy is a Vim user.

{{< tweet 1312206331277840384 >}}

The honest truth is that there is no one way to build software. There is no *truth*. There is no *best* way that is generally applicable. Everything in software is contextual. With that being said, all decisions when it comes to the technology you use come down to trade-offs. Do you need fast writes or fast reads? Do you need to stream data or batch process data? Are you concerned about latency or throughput? All these questions will guide you to the final set of technologies you use. The more complex your exisiting system, the more difficult questions you'll have to answer and the more trade-offs you'll have to make.

It's annoying to see such a strong hype culture in software. I'm it's not even local to software. Nonetheless, once some new technology comes out, some proponents think it is the *only* way to build software and will consider your technological choices inferior if you diverge. This is undeniably false. I can guarantee you that your 50 person startup does not *need* microservices and Kubernetes to manage them. You can get extremely far with something simpler and/or design your applications in a way that can easily be split out when needed. Unfortunately, you'll hear a chorus of developers pushing that microservices is the only way to build software in the modern era.

What is important is not the use of any specific technology but the applicability of it to your context. You're not Netflix, Google, Facebook, Stripe,Uber and the likes. You are X and you have Y problems that can be solved with Z technologies. Understanding how problems are solved is important, it improves your mental models. You'll be able to improve your designs and *draw* inspiration from multiple sources, tailored to your context. Think deeply about your problems, understand your trade-offs and design from there.

## Talking is pretty useless

I am a talker. I love to discuss new topics and really dive into them, tear them apart, turn it upside-down, shake it, spin it... you get the point 😆. I love retrospectives (as you can probably tell from this post), ideation sessions, strategy sessions. Over time I've realised one of my bigger flaws is that I can talk but often don't translate that into action. That is a *very* dangerous world to exist in. Words are powerful when followed by action but are otherwise just vibrations of air. I am now concerned with talk being followed with actionable outcomes. Without that, issues never truly get resolved and the problem will just come up again laetr, only for the cycle to repeat. As an individual, team or company, there should usually be practical, actionable outcomes and a plan to action them.

## Fundamentals come first

Tech is a huge, fast-evolving field. It is literally impossible to keep up. The best way to future-proof yourself is to focus on fundamentals. A focus on the fundamentals will ensure you have a small, well-refined and good personal "standard library". This sets a solid foundation and allows you to onboard information much faster. I've found that taking a top-down approach to learning to be the most beneficial for me. Starting at the high-level gives you a feel for what is going on and peaks your interest. Over time, I successively go more lower-level. This is important as fundamentals are fairly static. You often hear this song from the frontend community where they have extremely powerful frameworks to aid them in their work. These are great but they are abstractions - plenty of detail is hidden. Many developers spend time only learning frameworks and not the core principles behind them. This makes much of your knowledge irrelevant when a new framework rises to popularity.

## Processes increase velocity

I read somewhere that processes are **not** supposed to introduce overhead. When scaling a company, processes need to be introduced in order to manage the team effectively. Often, process is seen as a negative because it adds multiple steps between idea and action and promotes a highly bureaucratic structure. This is true, especially at massive firms. Process, however, is not meant to slow you down. They are introduced precisely because things are in a mess and getting anything done effectively takes too long. Processes *increase* velocity when done right. Getting it right is the challenge and requires a team/company to be flexible. Processes should be changed, added and removed when needed in order to maximize efficiency. In that structure, they are really your best friend and help everyone move faster.

## Titles matter

There's a growing narrative that titles do not matter. I guess this is more specific to smaller companies where there is a flatter organizational structure. Regardless, individuals and companies alike are pushing a message that they are not as important as before, that everyone's voice is heard and that if you have great ideas, you are empowered to take them forward. While this is often true, it doesn't take into account that we behave in accordance with our position in the hierarchy. Let's look at a contrived example. Imagine there is a tech team and they are struggling with silos between product teams. A junior, who having experienced the benefits of knowledge sharing at a company she interned at previously, is passionate about it and wants to push for it to become ingrained in the team's culture. She comes with a plan, the CTO loves it and leaves it in her hands to drive forward. Now comes the tricky part; you are a junior and therefore inherently don't command the same level of power and influence over the team. If your seniors are not as invested in the idea, the power dynamic is not in your favour. Given the hierarchy, you're likely to stop pushing your agenda as you're now "imposing" something upon your seniors and intermediates. This can be taken negatively quite easily, depending on the personality of your team. Alternatively, it could be that people won't take it as seriously because it's not coming from the top; if it's a junior's agenda, it's surely dismissable.

Titles give you access to certain conversations and platforms. The higher you go, the more knowledge you'll have of the state of affairs of the company. You'll be invited to conversations that determine the direction of individual teams and the company. It's a powerful position to be in.

To me, it's clear that titles really do matter. I don't think it worth *chasing* titles at the expense of everything else but it is nave to completely dismiss their importance.

## Strong leaders are a force multiplier

<!-- Should add more infomation here or discard -->

Strong leaders bring out the best in their teams. This is most clear in sport. Amazing managers can completely change the directory of a team. In soccer, Sir Alex Ferguson, Jürgen Klopp, José Mourinho all come to mind. The same is true in the business context. Strong leaders set the tone and rhythm for the team/company. They are present, dynamic, respond and act on feedback, set the course and direction of the team and action a plan to bring it into fruition, empower teams to do their best work. They are the shoulders on which everyone stands. They also make all the difference. Without strong leadership, the full potential of the team will never be fully realised.

## Great developers are great designers

One standout quality I've noticed between myself and senior developers is their ability to reason about and design code. I think one of the hallmarks of great developers is their ability to design. Why? Well actually writing the code is often not the most difficult part. It's designing it so your abstractions do not leak (too much), the code is easy to read while being easily extendible. The architecture of the system is as simple as it can be for the given complexity, it is easy to maintain and extend and the right technologies are chosen given the requirements. These are all things that do not actually have to do with *writing* code. Look at the [RFC process](https://www.python.org/dev/peps/pep-0484/) for any language and you'll understand what I mean by design. Great developers are great designers.
## Value is king

As developers, it's easy to get caught up in the technology you're using. There's a whole [website](https://stackshare.io/stacks) dedicated to searching tech stacks of several companies. Everybody wants to use kubernetes, service meshes, distributed databases, Golang or Rust, VueJS, deep learning. You can go on *forever*. Companies often use this to market themselves - "we use *machine learning* to power our next-generation platform" blah blah blah. This does matter for marketing purposes in the case where your consumers are likely to know something about that technology. However, the technology is not the reason they buy your product/service, it's the value. Value is king, it is the *only* thing that matters. How you go about attaining that value is up to you. If that comes from technology from the 1800s or is cutting-edge research from weeks ago is actually irrelevant. If I as the consumer derive the same value from a product with old technology vs new technology, I will just choose the cheaper one. This is all to say that focus on providing value to your customer. Use whatever technology will add that value and make your lives easier as your product becomes more complex but there is **no** point in getting caught up in it.

***


1. DONE: Breadth first then depth at an early stage - this applies to learning and your direction in tech (play around with different facets of technology). When learning depth, focus on foundations. The abstractions (e.g frameworks) will change but the database it abstracts will have core principles you need to know about.

2. ADVICE; If you're in the right environment, continually push above your weight

3. ADVICE: Look up from your monitors - there's a business around you. Get involved in some aspect of it

4. DONE: Get involved in the tech community around you

5. NOT KNOWLEDGEABLE ENOUGH: Product rollout strategies are critical to the success of the product

6. DONE: Coding for money is the best reason to code - don't let anyone lie to you about this

7. DONE: Focus on gathering intuition as a developer

8. DONE: Building products is hard and depends on so many other things other than the tech - customer feedback, prioritising features, in ML - data requirements and debugging

9. DONE: If you want to move fast in machine learning, pour time into your data systems

10. DONE: The whole of software engineering is about trade-offs.

11. DONE: Ditch the idea that some technology is the *best* - that's how you have fanboys of certain languages, frameworks, design and architectural patterns. Everything is use case specific and all that matters is what *trade-offs* need to be made. For example, there's a move to microservices. This is *often* not the best choice for your company at the stage it is at. Rather build your monolith with the idea of microservices in mind.

12. DONE: At a tech first company, it's easy to feel important. However, a company cannot run without the input from everyone - always a team effort.

13. DONE: With prioritising features - you do have to learn to say no. Everything will feel important

14. DONE: Overcoming silos requires a good system

15. DONE: Just because you're a junior, it does not implicitly mean you're a worse developer than those above you - there's a lot of levels to this

10. DONE: Focus on actionable outcomes and do some actioning

17. ADVICE: You get better by leveraging the knowledge of seniors. Ask them questions on anything you've thought about - does not have to be related to your actual work at the time.

18. DONE: You should care about your customers. If you're an infrastructure/ops team, that's your product teams. If you're a product team, that's your customers

14. DONE: As an engineer, when we think scale, we think use of our product and if our technology will scale. Scaling a startup is non-trivial in ways outside of technology. The most obvious one is *process*. It is very difficult to scale an organisations process. You'll meet chaos on your journey - it will subside but be prepared for it.

15. ADVICE: Learn to set boundaries between work and your life.

16. DONE: Coding is more thinking than writing - one great feature of great developers is thoughtfulness

17. DONE: Titles matter - often times you'll implicitly act in accordance with your role. For example, there have been times where I'd keep quiet so as to not stand on anyone's toes. Other times, while having a valuable contribution, I'd feel lazy and dip out since "it's not my responsibility". Either way, leveling up your title gives you access to certain rooms and therefore it does matter.

18. DONE: I've learned that leadership is top-down and strong leaders matter. They make all the difference in carving the trajectory of the company, ensuring a high quality of work is done, implementing the right frameworks to promote certain values etc. This is not to say it is "forced", rather that that is their job. My job is to play my part and contribute successfully. Speaking to a friend, he mentioned leadership flows top-down while feedback flows bottom-up. This is essential in keeping a space healthy while leaving leaders to do their best work and set the business up for success by creating the best environment.

19. DONE: Experience != skill - don't be overwhelmed by how much others know and think you aren't as technically gifted or lack skill. Experience (especially gathered at the same company) can make someone "seem" more skilled because they have intricate knowledge of the systems they are dealing with. This doesn't make someone more technically gifted than you. Things that actually matter - (read that tweet).

20. DONE: Play around with technology early stage - ml -> ml systems -> infrastructure.

21. ADVICE: The quality of engineering at a company is largely due to the precedent set by the senior members of the team. If you can, you should find a company that sets a high bar on engineering practice (in the event you wish to be strong technically). It's not that you yourself can't maintain a high bar individually, it's that you won't feel like you need to. And when you don't need to, you most likely won't.

22. DONE: Fight hard to find the right trade-off between feature development and other activities such as addressing tech debt, improving CI/CD pipelines, automating tooling, monitoring your applications etc. By default, you will always go for feature development because it feels more important. There's a reason "feature factories" are a thing. The only way to fight this inclination is to have some sort of precedent on when to address other conerns. And imo, they should be addressed because you can easily end up moving slower than faster due to technical debt or just fighting with your tooling.

23. DONE: ou cannot learn every technology (at a high-level). Focus on core concepts. For example, if you're excited about microservices, it's easy to end up learning k8s. You'll spend the initial phases learning to *operate* k8s - that's not as useful if you don't need it. Learn the fundamentals - what are containers, linux internals, dns, load balancing etc. They're all the fundamentals and power k8s. You should spend time there rather than learning how to *operate* the technology.

24. DONE: Process is not supposed to add overhead

25. DONE: High performance team have low overhead
