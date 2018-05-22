# marking_trees

This is my solution to the "[Marking Tree](https://www.eecs.harvard.edu/~michaelm/postscripts/sigact2001b.pdf)" problem.

### Background
Consider a complete binary tree of height h > 1 with N = 2**h - 1 nodes.
The nodes are either marked or unmarked. Initially, all nodes are unmarked.
Each round you select a node, i, to mark according to som random process (see below).
You then mark the node, and use the following rules repeatedly:

1. A node gets marked when both its childres are marked.

2. A chile node gets marked if its parent and sibling are marked.

When no more rules apply, you stop.

### Random Processes
We consider 3 random process for selecting the node, i:

1. Each round, you select a node, i, independently and uniformly at random.

2. Each round, you select a node, i, uniformly at random from the nodes _not sent before_.

3. Each round, you select node, i, uniformly at random from the nodes _not yet marked_.

### Solution
The solution to the problem is implemented in C and x86 assembly.
The C code sets up the tree and initializes stuff for each random process and the 
assembly code runs the actual marking algorithm.
Each round is being run 50 times to calculate confidence intervals.

A Python implementation takes about 40 minutes to run, whereas the C/Asm implementation
takes about 40 seconds :)

