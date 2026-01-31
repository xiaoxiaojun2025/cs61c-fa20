/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	if (!image) { return NULL; }
	Color *ret = (Color *) malloc(sizeof(Color));
	*ret = image->image[row][col];
	//R
	for (int k = 0; k < 8; ++k) {
		int lives = 0;
		for (int i = (row - 1 + image->rows) % image->rows; i != (row + 2) % image->rows; i = (i + 1) % image->rows) {
			for (int j = (col - 1 + image->cols) % image->cols; j != (col + 2) % image->cols; j = (j + 1) % image->cols) {
				if (i == row && j == col) { continue; }
				if (image->image[i][j].R & (1U << k)) { ++lives; }
			}
		}
		//自己活着
		if (ret->R & (1U << k)) {
			int next = rule & ( (1U << (9 + lives) ) );
			if (next == 0) {
				ret->R &= ~(1U << k);
			}
		} else {
			int next = rule & (1U << lives );
			if (next != 0) {
				ret->R |= (1U << k);
			}
		}
	}
	//G
	for (int k = 0; k < 8; ++k) {
		int lives = 0;
		for (int i = (row - 1 + image->rows) % image->rows; i != (row + 2) % image->rows; i = (i + 1) % image->rows) {
			for (int j = (col - 1 + image->cols) % image->cols; j != (col + 2) % image->cols; j = (j + 1) % image->cols) {
				if (i == row && j == col) { continue; }
				if (image->image[i][j].G & (1U << k)) { ++lives; }
			}
		}
		//自己活着
		if (ret->G & (1U << k)) {
			int next = rule & ( (1U << (9 + lives) ) );
			if (next == 0) {
				ret->G &= ~(1U << k);
			}
		} else {
			int next = rule & (1U << lives );
			if (next != 0) {
				ret->G |= (1U << k);
			}
		}
	}

	//B
	for (int k = 0; k < 8; ++k) {
		int lives = 0;
		for (int i = (row - 1 + image->rows) % image->rows; i != (row + 2) % image->rows; i = (i + 1) % image->rows) {
			for (int j = (col - 1 + image->cols) % image->cols; j != (col + 2) % image->cols; j = (j + 1) % image->cols) {
				if (i == row && j == col) { continue; }
				if (image->image[i][j].B & (1U << k)) { ++lives; }
			}
		}
		//自己活着
		if (ret->B & (1U << k)) {
			int next = rule & ( (1U << (9 + lives) ) );
			if (next == 0) {
				ret->B &= ~(1U << k);
			}
		} else {
			int next = rule & (1U << lives );
			if (next != 0) {
				ret->B |= (1U << k);
			}
		}
	}
	return ret;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	if (!image) { return NULL; }
	Image *ret = (Image *) malloc(sizeof(Image));
	ret->rows = image->rows;
	ret->cols = image->cols;
	ret->image = (Color **) malloc(ret->rows * sizeof(Color*));
	for (int i = 0; i < image->rows; ++i) {
		ret->image[i] = (Color *) malloc(ret->cols * sizeof(Color));
		for (int j = 0; j < image->cols; ++j) {
			Color *newColor = evaluateOneCell(image, i, j, rule);
			ret->image[i][j] = *newColor;
			free(newColor);
		}
	}
	return ret;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	for (int i = 1; i < argc - 1; i += 2) {
		Image *origin = readData(argv[i]);
		if (!origin) { return -1; }
		int rule = strtol(argv[i + 1], NULL, 0);
		if (rule < 0 || rule > 0x3FFFF) {
			printf("usage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\nrule is a hex number beginning with 0x; Life is 0x1808.\n");
			return -1;
		}
		Image *curr = life(origin, strtol(argv[i + 1], NULL, 0));
		writeData(curr);
		freeImage(curr);
		freeImage(origin);
	}
	return 0;
}
