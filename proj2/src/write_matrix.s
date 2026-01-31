.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s3, 16(sp)
    sw s2, 12(sp)
    sw s1, 8(sp)
    sw s0, 4(sp)
    sw ra, 0(sp) 

    # s1: starter; s2: rows; s3: cols
    mv s1, a1
    mv s2, a2
    mv s3, a3

    mv a1, a0
    li a2, 1
    jal fopen
    li t0, -1
    beq a0, t0, fopen_fail

    # s0: file operator 
    mv s0, a0

    # write rows
    mv a1, s0
    # a2是栈指针
    addi sp, sp, -4
    sw s2, 0(sp)
    mv a2, sp
    li a3, 1
    li a4, 4
    jal fwrite
    addi sp, sp, 4
    li t0, 1
    bne a0, t0, fwrite_fail

    # write cols
    mv a1, s0
    addi sp, sp, -4
    sw s3, 0(sp)
    mv a2, sp
    li a3, 1
    li a4, 4
    jal fwrite
    addi sp, sp, 4
    li t0, 1
    bne a0, t0, fwrite_fail

    # write elements
    mv a1, s0
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal fwrite
    mul t0, s2, s3
    bne a0, t0, fwrite_fail

    mv a0, s0
    jal fclose
    bne a0, zero, fclose_fail    

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20


    ret

fail_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    j exit2

fopen_fail:
    li a1, 93
    j fail_end
fwrite_fail:
    li a1, 94
    j fail_end
fclose_fail:
    li a1, 95
    j fail_end
