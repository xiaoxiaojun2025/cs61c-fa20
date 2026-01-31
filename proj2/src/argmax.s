.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue


    li t0, 1            #计数器，从1开始
    blt a1, t0, fail
    mv t1, zero        #最大索引
    lw t2, 0(a0)        #最大值



loop_start:
    beq t0, a1, loop_end
    mv t3, t0
    slli t3, t3, 2
    add t3, t3, a0
    lw t3, 0(t3)
    bge t2, t3, loop_continue
    mv t2, t3
    mv t1, t0

loop_continue:
    addi t0, t0, 1
    j loop_start
    

loop_end:
    

    # Epilogue

    mv a0, t1

    ret

fail:
    li a1, 77
    j exit2
