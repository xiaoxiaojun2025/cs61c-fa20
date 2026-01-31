.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # check
    li t0, 5
    bne a0, t0, args_fail
    
    addi sp, sp, -52
    sw a2, 48(sp)
    sw s10, 44(sp)
    sw s9, 40(sp)
    sw s8, 36(sp)
    sw s7, 32(sp)
    sw s6, 28(sp)
    sw s5, 24(sp)
    sw s4, 20(sp)
    sw s3, 16(sp)
    sw s2, 12(sp)
    sw s1, 8(sp)
    sw s0, 4(sp)
    sw ra, 0(sp)

    mv s0, a1

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw a0, 4(s0)
    # a1, a2是栈指针
    addi sp, sp, -8
    addi a2, sp, 4
    mv a1, sp
    jal read_matrix
    # m0's rows and cols
    mv s1, a0
    lw s2, 0(sp)
    lw s3, 4(sp)
    addi sp, sp, 8


    # Load pretrained m1
    lw a0, 8(s0)
    addi sp, sp, -8
    addi a2, sp, 4
    mv a1, sp
    jal read_matrix
    # input's rows and cols
    mv s8, a0 
    lw s9, 0(sp)
    lw s10, 4(sp)
    addi sp, sp, 8



    # Load input matrix
    lw a0, 12(s0)
    addi sp, sp, -8
    addi a2, sp, 4
    mv a1, sp
    jal read_matrix
    # input's rows and cols
    mv s4, a0 
    lw s5, 0(sp)
    lw s6, 4(sp)
    addi sp, sp, 8


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # 1
    mul a0, s2, s6
    slli a0, a0, 2
    jal malloc
    beq a0, zero, malloc_fail
    mv s7, a0

    mv a0, s1
    mv a1, s2
    mv a2, s3
    mv a3, s4
    mv a4, s5
    mv a5, s6
    mv a6, s7
    jal matmul

    # free m0 and input
    mv a0, s1
    jal free
    mv a0, s4
    jal free

    # 2
    mv a0, s7
    mul a1, s2, s6
    jal relu

    # 3
    mul a0, s9, s6
    slli a0, a0, 2
    jal malloc
    mv s1, a0

    mv a0, s8
    mv a1, s9
    mv a2, s10
    mv a3, s7
    mv a4, s2
    mv a5, s6
    mv a6, s1
    jal matmul

    # free m1 and relu(m0 * input)
    mv a0, s8
    jal free
    mv a0, s7
    jal free

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s0)
    mv a1, s1
    mv a2, s9
    mv a3, s6
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s1
    mul a1, s9, s6
    jal argmax

    mv s0, a0

    # free the last matrix
    mv a0, s1
    jal free

    # Print classification
    lw a2, 48(sp)
    bne a2, zero, end
    mv a1, s0
    jal print_int


    # Print newline afterwards for clarity
    li, a1, '\n'
    jal print_char

end:
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 52

    ret

args_fail:

    li a1, 89
    j fail_end  
malloc_fail:
    li a1, 88
    j fail_end

fail_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 52
    j exit2
