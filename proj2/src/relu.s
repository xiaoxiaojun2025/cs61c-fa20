.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    li t1, 1
    blt a1, t1, fail 
    # Prologue
    mv t1, zero               #计数器

loop_start:
    beq t1, a1, loop_end
    mv t2, t1
    slli t2, t2, 2
    add t2, t2, a0
    lw t0, 0(t2)
    bge t0, zero, loop_continue
    mv t0, zero
    sw t0, 0(t2)






loop_continue:
    addi t1, t1, 1
    j loop_start 





loop_end:


    # Epilogue

    
	ret

fail:
    li a1, 78
    j exit2

