# Starter Code for Grading System Simulation
.data
scores:      .word 85, 90, 78, 92, 66    # Example array of scores
num_scores:  .word 5                     # Number of scores
pass_mark:   .word 70                    # Passing threshold

.text
.globl main

main:
    # Call necessary procedures to implement the grading system
    # Insert your code here

    # Return from program
    li a7, 10    # Syscall for exit
    ecall
