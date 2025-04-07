---
date: 2020-01-26
linktitle: spectrum
title: On Pytorch Tensors and Autograd
summary: A brief explanation of PyTorch's Autograd system, computational graphs, and how gradient calculation works in deep learning frameworks.
categories: [ "Machine Learning" ]
tags: ["Pytorch", "Autograd", "Python"]
---

# On Pytorch Tensors and Autograd 

Somehow, Pytorch blitz tutorial on Autograd completely confused me. I could not understand what does `.backward()`, `.grad` and `grad_fn` do.

Fortunately, I found an excellent explanation of Autograd and Computational Graph is here: https://blog.paperspace.com/pytorch-101-understanding-graphs-and-automatic-differentiation/. Just for my notes and anyone interested, I am going to leave my short recap here:

- Computational Graph - records the order of operations on tensors in the graph. Edges of the graph represent the local gradients. Leafs of the graph are independent variables (inputs and weights/biases in case of NN)
- `tensor.backward()` computes the gradients all the way back through the computational graph and accumulate results in leafs. Can only be called on the 0-rank tensor.
- `tensor.grad` holds the accumulated gradient from the call to `.backward()` with respect to the given tensor
