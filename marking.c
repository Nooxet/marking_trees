#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>

#define REPS 50

typedef struct {
	int val;
	int marked;
} node;

void mark(int);
int getctr();
void clrctr();
void setn(int);
int getn();
int get_left(int);
int get_right(int);
int get_parent(int);
void check(int);

node *tree;

int r1(int N)
{
	setn(N); // IMPORTANT!!
	int rounds = 0;
	int r;
	while (getctr() != N-1) {
		r = lrand48() % (N-1) + 1;
		mark(r);
		rounds++;
	}
	clrctr();
	return rounds;
	
}

int r2(int N)
{
	setn(N);
	int rounds = 0;
	int M = N - 1;
	int rs[M];
	for (int i = 0; i < M; i++) {
		rs[i] = i + 1;
	}
	
	/* Knuth's shuffle */
	for (int i = 0; i < M-1; i++) {
		/* i <= j < M */
		int j = (lrand48() % (M - i)) + i;
		int tmp = rs[i];
		rs[i] = rs[j];
		rs[j] = tmp;
	}

/*
	printf("[");
	for (int i = 0; i < M; i++) {
		printf("%d, ", rs[i]);
	}
	printf("]\n");
	return 0;
*/
	int pos = 0;
	while (getctr() != N-1) {
		mark(rs[pos++]);
		rounds++;
	}
	clrctr();
	return rounds;
}

int ismarked(int r)
{
	return tree[r].marked;
}

int r3(int N)
{
	setn(N);
	int rounds = 0;
	int M = N - 1;
	int rs[M];
	for (int i = 0; i < M; i++) {
		rs[i] = i + 1;
	}
	
	/* Knuth's shuffle */
	for (int i = 0; i < M-1; i++) {
		/* i <= j < M */
		int j = (lrand48() % (M - i)) + i;
		int tmp = rs[i];
		rs[i] = rs[j];
		rs[j] = tmp;
	}
/*
	printf("[");
	for (int i = 0; i < M; i++) {
		printf("%d, ", rs[i]);
	}
	printf("]\n");
	return 0;
*/
	int pos = 0;
	while (getctr() != N-1) {
		int r = rs[pos];
	//	printf("r: %d\tpos: %d\n", r, pos);
		pos++;
		if (ismarked(r)) continue;
		mark(r);
		rounds++;
	}

	clrctr();
	return rounds;
}

void make_tree(int N)
{
	tree = calloc(N, sizeof(node));
	for (int i = 0; i < N; i++) {
		tree[i].val = i;
	}
}

void clr_tree(int N)
{
	memset(tree, 0, N * sizeof(node));
}

int main()
{
	int N = 2;
	
	srand48(time(NULL));

	double rsum = 0;
	int rvals[REPS];
	int r = 0;
	for (int e = 2; e < 21; e++) {
		N *= 2;	// N = 2**e
		make_tree(N);
		rsum = 0;
		for (int j = 0; j < REPS; j++) {
			r = r1(N);
			rvals[j] = r;
			rsum += r;
			clr_tree(N);
		}
		double mean = rsum / REPS;
		double std = 0;
		for (int j = 0; j < REPS; j++) {
			std += (rvals[j] - mean) * (rvals[j] - mean);
		}
		std = sqrt(1.0/(N-1) * std);
		// for confidence interval
		std = 2 * std / sqrt(REPS);
		printf("%d & %f & %f\n", N-1, mean, std);
		free(tree);
	}

	return 0;
}
