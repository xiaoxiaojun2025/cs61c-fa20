.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s5, 24(sp)
    sw s4, 20(sp)
    sw s3, 16(sp)
    sw s2, 12(sp)
    sw s1, 8(sp)
    sw s0, 4(sp)
    sw ra, 0(sp)

    mv s4, a1
    mv s5, a2

    mv a1, a0
    mv a2, zero
    jal fopen
    li t0, -1
    beq a0, t0, fopen_fail

    # s0 for file operator
    mv s0, a0

    # s1: store rows
    li a0, 4
    jal malloc
    beq a0, zero, malloc_fail
    mv s1, a0

    mv a1, s0
    mv a2, a0
    li a3, 4
    jal fread
    # free
    addi sp, sp, -4
    sw a0, 0(sp)
    mv a0, s1
    lw s1, 0(s1)
    jal free
    lw a0, 0(sp)
    addi sp, sp, 4
    li t0, 4
    bne a0, t0, fread_fail
    sw s1, 0(s4)

    # s2: store cols
    li a0, 4
    jal malloc
    beq a0, zero, malloc_fail
    mv s2, a0

    mv a1, s0
    mv a2, a0
    li a3, 4
    jal fread

    addi sp, sp, -4
    sw a0, 0(sp)
    mv a0, s2
    lw s2, 0(s2)
    jal free
    lw a0, 0(sp)
    addi sp, sp, 4
    li t0, 4
    bne a0, t0, fread_fail
    sw s2, 0(s5)

    # s3: start of matrix
    mul a0, s1, s2
    slli a0, a0, 2
    jal malloc
    beq a0, zero, malloc_fail
    mv s3, a0

    mv a1, s0
    mv a2, a0
    mul a3, s1, s2
    slli a3, a3, 2
    addi sp, sp, -4
    sw a3, 0(sp)
    jal fread 
    lw a3, 0(sp)
    addi sp, sp, 4
    bne a0, a3, fread_fail

    mv a0, s0
    jal fclose
    bne a0, zero, fclose_fail

    # return a0
    mv a0, s3
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    

    ret

malloc_fail:
    li a1, 88
    j fail_end
fopen_fail:
    li a1, 90
    j fail_end
fread_fail:
    li a1, 91
    j fail_end
fclose_fail:
    li a1, 92
    j fail_end

fail_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    j exit2    
