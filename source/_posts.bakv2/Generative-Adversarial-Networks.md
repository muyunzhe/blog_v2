---
title: Generative Adversarial Networks
comments: true
toc: true
mathjax2: true
keywords: '牧云者,人工智能,云计算,数据挖掘,hexo,blog'
date: 2018-01-02 14:49:19
categories: [artificial-intelligence, deep-learning]
tags: [deep-learning, Neural-Networks]
---
GAN 暨生成对抗网络（Generative Adversarial Networks）是由两个彼此竞争的深度神经网络——生成器和判别器组成的。本文主要介绍GAN的基本原理。
 <!--more-->
# GAN原理
GAN的基本原理其实非常简单，这里以生成图片为例进行说明。假设我们有两个网络，G（Generator）和D（Discriminator）。正如它的名字所暗示的那样，它们的功能分别是：
G是一个生成图片的网络，它接收一个随机的噪声z，通过这个噪声生成图片，记做G(z)。
D是一个判别网络，判别一张图片是不是“真实的”。它的输入参数是x，x代表一张图片，输出D（x）代表x为真实图片的概率，如果为1，就代表100%是真实的图片，而输出为0，就代表不可能是真实的图片。
在训练过程中，生成网络G的目标就是尽量生成真实的图片去欺骗判别网络D。而D的目标就是尽量把G生成的图片和真实的图片分别开来。这样，G和D构成了一个动态的“博弈过程”。
最后博弈的结果是什么？在最理想的状态下，G可以生成足以“以假乱真”的图片G(z)。对于D来说，它难以判定G生成的图片究竟是不是真实的，因此D(G(z)) = 0.5。
这样我们的目的就达成了：我们得到了一个生成式的模型G，它可以用来生成图片。
用论文里的公式表示就是：
![](/img/gan_cost.jpg)
简单分析一下这个公式：
整个式子由两项构成。x表示真实图片，z表示输入G网络的噪声，而G(z)表示G网络生成的图片。

D(x)表示D网络判断真实图片是否真实的概率（因为x就是真实的，所以对于D来说，这个值越接近1越好）。而D(G(z))是D网络判断G生成的图片的是否真实的概率。

G的目的：上面提到过，D(G(z))是D网络判断G生成的图片是否真实的概率，G应该希望自己生成的图片“越接近真实越好”。也就是说，G希望D(G(z))尽可能得大，这时V(D, G)会变小。因此我们看到式子的最前面的记号是min_G。

D的目的：D的能力越强，D(x)应该越大，D(G(x))应该越小。这时V(D,G)会变大。因此式子对于D来说是求最大(max_D)

# 训练算法
那么如何用随机梯度下降法训练D和G？论文中也给出了算法：
![](/img/587c739c7f34d.jpg)
第一步我们训练D，D是希望V(G, D)越大越好，所以是加上梯度(ascending)。第二步训练G时，V(G, D)越小越好，所以是减去梯度(descending)。整个训练过程交替进行。

# 训练过程
![](/img/训练过程.png)
如图所示，我们手上有真实数据（黑色点，data）和模型生成的伪数据（绿色线，model distribution，是由我们的 z 映射过去的）（画成波峰的形式是因为它们都代表着各自的分布，其中纵轴是分布，横轴是我们的 x）。而我们要学习的 D 就是那条蓝色的点线，这条线的目的是把融在一起的 data 和 model 分布给区分开。写成公式就是 data 和 model 分布相加做分母，分子则是真实的 data 分布。
我们最终要达到的效果是：D 无限接近于常数 1/2。换句话说就是要 Pmodel 和 Pdata 无限相似。这个时候，我们的 D 分布再也没法分辨出真伪数据的区别了。这时候，我们就可以说我们训练出了一个炉火纯青的造假者（生成模型）。

# 最终结果
训练结束最终收敛到生成模型最优化：
![](/img/最终结果.png)
蓝色断点线是一条常数线（1/2），黑色与绿色完美重合了。

假设生成器生成了一张图片，辨别器认为这张图片有 0.4 的概率是真实图片。生成器如何调整它生成的图片来增加这个概率，比如说增加到 0.41？
答案就是：
为训练生成器，辨别器不得不告诉生成器如何调整从而使它生成的图片变得更加真实。
生成器必须向辨别器寻求建议！
直观来说，辨别器告诉生成器每个像素应调整多少来使整幅图像更真实一点点。
技术上来说，通过反向传播辨别器输出的梯度来调整生成图片。以这种方式训练生成器，你将会得到与图片形状一样的梯度向量。
如果你把这些梯度加到生成的图片上，在辨别器看来，图片就会变得更真实一点。
但是我们不仅仅把梯度加到图片上。
相反，我们进一步反向传播这些图片梯度成为组成生成器的权重，这样一来，生成器就学习到如何生成这幅新图片。
我重复一遍，为生成好的图片，你必须向老师展示你的工作，得到反馈！
如果辨别器不帮助生成器的话，那就太残酷了，因为生成器实际做的工作比辨别器更艰难，它生成图片！
这就是生成器如何被训练的。
就像这样，来回训练生成器和辨别器，直到达到一个平衡状态。
