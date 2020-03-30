---
title: "Machine learning in the wild"
draft: true
---

Machine learning promises to be transformational for many industries, ranging from financial services to healthcare to agriculture. The resurgence of machine learning, due to the astonishing performance of deep learning in computer vision and natural language processing, has prompted industry to jump on the bandwagon and use machine learning in their businesses. In fact, entire startups are being built around machine learning alone, promising that their new found algorithms will vastly improve and outperform existing products and services.

While week-on-week, new state of the art algorithms are being published, using them in a production setting is often non-trivial.
The additional complexity of using machine learning to power products cannot be understated. Many new factors become important in your system and oftentimes, development of machine learning models comprises a small part of the puzzle. This is highlighted in the paper, [Hidden Technical Debt in Machine Learning Systems](link), where they visualise the components of a production machine learning system revealing the true complexity of such systems.

![ml-prod](resources/_gen/images/ml-wild/production-ml-2.png)

When embarking on a journey to introduce machine learning into your product, it is important to be aware of this complexity and take it into consideration. In this blog post, I go over some of the challenges with reference to my own experiences. This is by no means the most comprehensive material and I will provide links to additional resources where needed.

## Technical Debt

## Data Quality

## Concept Drift

### Retraining

## Versioning

Versioning is an essential part of software engineering. Git has largely solved this problem for traditional software development. In machine learning, we not only have to version our code but also the parameters of our model and the data that was used to train the model.

Data versioning is a new challenge that machine learning brings to the table. Why is this important? Well let's walk through a scenario. Imagine a machine learning engineer, Daisy, creates a model with dataset A. She then uses the same model with slightly different data, dataset B. She repeats this two more times, making dataset's C and D. After all her experiments, she finds the model with datasets A and C performed the best. Unfortunately she never logged the differences between the datasets, only has the version with the latest changes (dataset D) and forgot all the changes between them. It is now impossible for her to reproduce her best performing model, a true tragedy. Alongside this, she cannot understand why datasets A and C lead to the best models, reducing her understanding and confidence in the model performance. From this example, it is pretty evident why there is a need for data versioning.

As a new challenge, data versioning has not come of age yet. As of current time, there is no standard methodology or tooling to deal with this problem effectively. However, it is important to develop internal systems to track and version data. Being able to reproduce your experiments and to further improve them with the correct data is essential in using machine learning effectively.

Some of the tools that currently exist to solve this challenge are ... dvc/dolt/pachyderm.

## Experimental Infrastructure and Platforms

Experimental infrastructure and platforms refer to the necessary infrastructure and platforms needed to use machine learning as effectively as possible. It is not necessary in the beginning of the machine learning journey but as a company begins to scale up their machine learning efforts, it becomes critical. Thousands of experiments need to be run and evaluated and having the correct infrastructure and tools make the iteration speed quick and allow models to actually make it into production.

Having the correct infrastructure is necessary so that development cycles are fast as possible. I'll highlight this through another one of Daisy's adventures. Daisy decided that she needs to create and train a new model for fraud detection. She whips out her trusty jupyter notebook and sets off on her adventure. On completion of her model and dataset, she proceeds to train the notebook on an EC2 instance the company provides. To do this, she has to ssh into it, install all the dependencies, monitor if it's still alive, pull the outputs once its completed and repeat. Naturally, there are many points of failure here, slowing her development time. The company realises this is inefficient and moves their traning and evaluation infrastructure to kubernetes with kubeflow. Now she can execute jobs on kubeflow, have instant monitoring of its progress, easily view her outputs and so much more. Clearly this has improved her iteration speed, removed her need to fully understand infrastructure and given her the necessary amount of visibility. By using the correct infrastructure, Daisy is able to train and evaluate more models in a shorter period of time.

Platforms are not nearly as high priority as the correct infrastructure but can definitely improve the development experience of data scientists and machine learning engineers. Here, a great example is Uber's Michelangelo. This platform enabled their team to ... . A good review is available here by Natu Lauchande (insert link).

## Code quality

Every developer knows there's nothing better than having quality code. It is wonderful to read, maintainable and extensible. This is a core tenet of all forms of software engineering, including machine learning engineering. What makes it different is that data scientists are often not the strongest programmers (and rightfully so, their expertise lies in the science of data science). Machine learning engineers are responsible for productionising the models created by data scientists which includes ensuring a good code standard. The challenge posed here is that small teams often do not have a division of machine learning engineers and data scientists. This means that data scientists either have to upskill their software engineering prowess or they release low quality code into production which is often the simplest and fastest option. This bakes technical debt into your code base from foundation and makes it difficult to extend in the future. This can cause significant growing pains moving forward as all technical debt does.

In order to circumvent this, rope in a software engineer or two into the data science team from the get go. While they may not understand the machine learning itself, they'll be able to sanity check code before it makes it into production. Alternatively, upskill your data scientists to some minimum level of software engineering prowess.
