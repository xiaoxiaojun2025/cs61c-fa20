.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, fail_m0
    blt a2, t0, fail_m0
    blt a4, t0, fail_m1
    blt a5, t0, fail_m1
    bne a2, a4, fail_m0_with_m1


    # Prologue
    addi sp, sp, -40
    sw s9, 36(sp)
    sw s8, 32(sp)
    sw s7, 28(sp)
    sw s6, 24(sp)
    sw s5, 20(sp)
    sw s3, 16(sp)
    sw s2, 12(sp)
    sw s1, 8(sp)
    sw s0, 4(sp)
    sw ra, 0(sp)

    # Assign
    mv s0, a0           # start of m0
    mv s1, a1           # rows of m0
    mv s2, a2           # length of vector
    mv s3, a3           # start of m1
    mv s5, a5           # cols of m1
    mv s6, a6           # start of d

    # Counters
    mv s7, zero         # row-counter of m0
    mv s8, zero         # col-counter of m1
    mv s9, zero         # counter of d

    # Prepare args for dot 
    mv a0, s0
    mv a1, s3
    mv a2, s2
    li a3, 1
    mv a4, s5 
    



outer_loop_start:


inner_loop_start:
    
    jal dot

    mv t0, s9
    slli t0, t0, 2
    add t0, t0, s6
    sw a0, 0(t0)        # write return value
    addi s9, s9, 1
    
    # restore a2, a3, a4
    mv a2, s2
    li a3, 1
    mv a4, s5

    addi s8, s8, 1
    beq s8, s5, inner_loop_end

    # prepare new a0 and a1
    mv a0, s7
    mul a0, a0, a2
    slli a0, a0, 2
    add a0, a0, s0
    mv a1, s8
    slli a1, a1, 2
    add a1, a1, s3

    j inner_loop_start



inner_loop_end:
    addi s7, s7, 1
    beq s7, s1, outer_loop_end

    mv s8, zero

    # prepare new a0 and a1
    mv a0, s7
    mul a0, a0, a2
    slli a0, a0, 2
    add a0, a0, s0
    mv a1, s8
    slli a1, a1, 2
    add a1, a1, s3

    j outer_loop_start




outer_loop_end:


    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    addi sp, sp, 40
    
    
    ret

fail_m0:
    li a1, 72
    j exit2
fail_m1:
    li a1, 73
    j exit2
fail_m0_with_m1:
    li a1, 74
    j exit2

