---
title: "Upgrading your machine learning"
date: 2020-10-21
draft: true
---

# Depth First

Machine learning is a **huge** field. It is impossible to know everything there is to know about machine learning. I know nothing about natural language processing. The only things I do know about are BERT, ULMFiT, the GPT models and the transformer architecture. Now you may be thinking, "Senyo, that's actually a fair bit" but you would be sorely mistaken. I have only *heard* of them. I have *no idea* how they work 🤫. Jokes aside, it is impossible to keep up. There's already a gazillion papers that are released daily.

Fortunately, machine learning is a project driven field. What matters most are the projects you've worked on, either in your personal time or in industry. Most of us feel a need to do many projects to cover the landscape of machine learning. One day you'll be working on understanding linear regression, the next t-SNE, the next computer vision and somehow end up trying to predict stock prices using machine learning. There is way too much to do! I've found this counterproductive, both for the use of my time and for my growth. It is *much* better to choose a project with a fairly large scope and go the distance with it. There are several benefits to this that stand out for me.

## Deeper understanding of the problem

The longer you sit with a problem, the more you understand the intricacies of it. This normally opens several avenues of exploration. You'll have to read more papers, explore more parts of the machine learning spectrum, possibly merge techniques that previously seemed unrelated and so on. Additionally, the learning is *contextualised*, meaning that you learn about new techniques within the mental framework of your problem. This often makes learning easier. A simple example: if you're learning linear regression without context, you're likely to think of the parameters of the models as they are presented, i.e $a$, $b$, $c$. If you're learning it within context of your problem (let's say you're determining house pricing), your parameters can "come to life". Instead of $a$, $b$, $c$, you might think about *neighbourhood*, *number of bedrooms*, *if there is an elevator* 😆 and how they are weighted against each other. This could make understanding how linear regression works easier - it's related to a problem you're trying to solve.

## Effective communication

You will be able to communicate the problem and your solution with sufficient technical depth. One place where a lack of technical depth can hurt you is during interviews. Interviewers often want to gauge how you *thought* about the problem and not entirely that you managed to solve. Having deep knowledge of the problem, the solutions that exist and your justification for choosing a particular solution are much more important than the fact that you have solved the problem. In fact, not only is this useful for interviews but with your team. Being able to communicate your thinking to your teammates is essential. It helps them to contribute, provide a good soundboard and to give advice. Having a depth first approach gives you the opportunity to truly understand the problem and be able to communicate it well.

## Context on the general problem domain

It often gives you a flavour for the general problems encountered in that space. I did my undergraduate thesis project on super resolution - recovering high resolution images from low resolution images. It is an ill-posed problem. This means that for a given low resolution image, there are multiple high resolution images that are plausible solutions for it. This phenomenon is not at all unique to super resolution. Other problems in computer vision that face this challenge are image denoising, image reconstruction, image inpainting and many others. Through working on one project and attempting to solve the problem presented, you can learn plenty about other related problems. Without spending signficant time with the problem, you can easily miss the common thread.

# Forget about the solution

As machine learning engineers and data scientists, we're often most excited by our solutions to problems. We love to talk about the new models and algorithms we got to use. This is exacerbated by platforms like Kaggle. While this is not bad, it does distract us from what I would consider the more important part, *evaluation*. Obviously plenty of time needs to go into the solution to make it useful but I'd argue that even more time should go into evaluating it.

## Understanding failure modes

When I started my machine learning journey, I would use blanket metrics to get an idea of the performance of my model. While this is not wrong, there are many cases where it is insufficient. A simple example is when being wrong in one way is more harmful than being wrong in another way. This is quite common in real life scenarios. If you're investing money, being wrong with a small amount of money is much less harmful than being wrong with your entire life savings. Blanket metrics often only tell you how often you're right or wrong but don't provide much insight past that. Understanding failure modes is necessary to truly understand model performance. At the end of evaluating a model, you should be able to characterize its weaknesses and propose reasonable hypotheses on why this may be the case. 

## Promoting fairness

## Insight into improvements