# Solution Code for Grading System Simulation
.data
scores:      .word 70, 46, 40, 100, 50    # Example array of scores
num_scores:  .word 5                     # Number of scores
pass_mark:   .word 50                    # Passing threshold
average:     .word 0                     # Placeholder for average score
highest:     .word 0                     # Placeholder for highest score

.text
.globl main

# Main function
main:
    # Load number of scores and address of the scores array
    la a0, scores            # Load base address of the scores array
    lw a1, num_scores        # Load number of scores

    # Call procedure to calculate average
    jal ra, calculate_average
    sw a0, average           # Store calculated average in memory

    # Call procedure to find the highest score
    la a0, scores            # Load base address of the scores array
    lw a1, num_scores        # Load number of scores
    jal ra, find_highest
    sw a0, highest           # Store highest score in memory

    # Call procedure to check pass/fail
    lw a0, average           # Load the calculated average
    lw a1, pass_mark         # Load the pass mark
    jal ra, check_pass_fail

    # Exit program
    li a7, 10                # Syscall for exit
    ecall

# Procedure: Calculate Average
calculate_average:
    mv t0, zero              # Sum = 0
    mv t1, zero              # Index = 0

loop_avg:
    bge t1, a1, end_avg      # If index >= num_scores, exit loop
    slli t2, t1, 2           # t2 = index * 4 (word size)
    add t2, t2, a0           # t2 = address of scores[index]
    lw t3, 0(t2)             # Load scores[index]
    add t0, t0, t3           # Sum += scores[index]
    addi t1, t1, 1           # Index++
    j loop_avg

end_avg:
    div a0, t0, a1           # a0 = Sum / num_scores (average)
    ret                      # Return average in a0

# Procedure: Find Highest Score
find_highest:
    mv t0, zero              # Max = 0
    mv t1, zero              # Index = 0

loop_highest:
    bge t1, a1, end_highest  # If index >= num_scores, exit loop
    slli t2, t1, 2           # t2 = index * 4 (word size)
    add t2, t2, a0           # t2 = address of scores[index]
    lw t3, 0(t2)             # Load scores[index]
    blt t0, t3, update_max   # If Max < scores[index], update Max
    j skip_update

update_max:
    mv t0, t3                # Max = scores[index]

skip_update:
    addi t1, t1, 1           # Index++
    j loop_highest

end_highest:
    mv a0, t0                # Return Max in a0
    ret

# Procedure: Check Pass/Fail
check_pass_fail:
    blt a0, a1, fail         # If average < pass_mark, go to fail
    la a0, pass_msg          # Load "Pass" message
    j print_message

fail:
    la a0, fail_msg          # Load "Fail" message

print_message:
    li a7, 4                 # Syscall to print string
    ecall
    ret

.data
pass_msg:   .asciiz "You passed the class, congrats !! \n"
fail_msg:   .asciiz "You failed :(( !\n"
