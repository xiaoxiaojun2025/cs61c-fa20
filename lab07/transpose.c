#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

int min(int x, int y) {
    return (x < y) ? x : y;
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
    int bn = n / blocksize + (n % blocksize != 0), x_start, y_start, x_length, y_length;
    for (int i = 0; i < bn; ++i) {
        x_start = i * blocksize;
        x_length = min(blocksize, n - x_start);
        for (int j = 0; j < bn; ++j) {
            y_start = j * blocksize;
            y_length = min(blocksize, n - y_start);
            for (int x = 0; x < x_length; ++x) {
                for (int y = 0; y < y_length; ++y) {
                    dst[y + y_start + (x + x_start) * n] 
                    = src[x + x_start + (y + y_start) * n]; 
                }
            }
        }
    }
}


