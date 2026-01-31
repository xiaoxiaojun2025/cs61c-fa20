/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	if (!image) { return NULL; }
	Color *ret = (Color *) malloc(sizeof(Color));
	if (image->image[row][col].B & 1U) {
		ret->R = ret->G = ret->B = 255; 
	} else {
		ret->R = ret->G = ret->B = 0;
	}
	return ret;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	if (!image) { return NULL; }
	Image *ret = (Image *) malloc(sizeof(Image));
	ret->rows = image->rows;
	ret->cols = image->cols;
	ret->image = (Color **) malloc(ret->rows * sizeof(Color*));
	for (uint32_t i = 0; i < image->rows; ++i) {
		ret->image[i] = (Color *) malloc(ret->cols * sizeof(Color));
		for (uint32_t j = 0; j < image->cols; ++j) {
			Color *newColor = evaluateOnePixel(image, i, j);
			ret->image[i][j] = *newColor;
			free(newColor);
		}
	}
	return ret;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	for (int i = 1; i < argc; ++i) {
		Image *origin = readData(argv[i]);
		if (!origin) { return -1; }
		Image *curr = steganography(origin);
		writeData(curr);
		freeImage(curr);
		freeImage(origin);
	}
	return 0;	
}
