.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0, 1
    blt a2, t0, fail_1
    blt a3, t0, fail_2
    blt a4, t0, fail_2

    # Prologue
    addi sp, sp, -20
    sw s4, 16(sp)           # v1步长
    sw s3, 12(sp)           # v0步长
    sw s2, 8(sp)           # 数组长度
    sw s1, 4(sp)            # v1首地址
    sw s0, 0(sp)            # v0首地址

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4

    mv a0, zero             #累加和
    mv a2, zero             # 计数器
    mv t0, s0
    mv t1, s1
    mv t2, s3
    slli t2, t2, 2
    mv t3, s4
    slli t3, t3, 2 

loop_start:
    beq a2, s2, loop_end

    # the address of i-th element  = base_address + i * stride * sizeof(element)

    lw a3, 0(t0)
    lw a4, 0(t1)
    mul t4, a3, a4
    add a0, a0, t4

    addi a2, a2, 1
    add t0, t0, t2
    add t1, t1, t3
    j loop_start




loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20
    
    ret

fail_1:
    li a1, 75
    j exit2
fail_2:
    li a1, 76
    j exit2
