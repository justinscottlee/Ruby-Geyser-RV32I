main:
li a0 2
jal sin
j exit

sin: # a0 = a, after call a0 = sin(a)
mv t6 a0 # t6 saves the value of a

li a0 11
li a1 1
sw ra 0(sp)
addi sp sp -4
jal factorial
addi sp sp 4
lw ra 0(sp)
mv a1 t6
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
add s0 zero a0 # s0 = 11!a

li a0 11
li a1 3
sw ra 0(sp)
addi sp sp -4
jal factorial
addi sp sp 4
lw ra 0(sp)
mv a1 t6
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sub s0 s0 a0 # s0 = 11!a - 11!a^3/3!

li a0 11
li a1 5
sw ra 0(sp)
addi sp sp -4
jal factorial
addi sp sp 4
lw ra 0(sp)
mv a1 t6
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
add s0 s0 a0 # s0 = 11!a - 11!a^3/3! + 11!a^5/5!

li a0 11
li a1 7
sw ra 0(sp)
addi sp sp -4
jal factorial
addi sp sp 4
lw ra 0(sp)
mv a1 t6
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sub s0 s0 a0 # s0 = 11!a - 11!a^3/3! + 11!a^5/5! - 11!a^7/7!

li a0 11
li a1 9
sw ra 0(sp)
addi sp sp -4
jal factorial
addi sp sp 4
lw ra 0(sp)
mv a1 t6
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
add s0 s0 a0 # s0 = 11!a - 11!a^3/3! + 11!a^5/5! - 11!a^7/7! + 11!a^9/9!

li a0 1
mv a1 t6
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
sub s0 s0 a0 # s0 = 11!a - 11!a^3/3! + 11!a^5/5! - 11!a^7/7! + 11!a^9/9! - 11!a^11/11!
jr ra

# locks up registers t0, t1, t4, t5
factorial: # a0 = a, a1 = stopbottom, after call a0 = a! a1 will NOT be multiplied. so 10, 3 would give 10*9*8*7*6*5*4
mv t0 a0 # multiplier = a
li t1 1 # product = 1
mv t5 a1
fact_loop:
beq t0 t5 fact_escapeloop
mv a1 t0
mv a0 t1
sw ra 0(sp)
addi sp sp -4
jal mult
addi sp sp 4
lw ra 0(sp)
mv t1 a0
addi t0 t0 -1
j fact_loop
fact_escapeloop:
jr ra

#locks up registers t2 and t3
mult: # a0 = a, a1 = b, after call a0 = a * b
li t2 0 # i = 0
li t3 0 # sum = 0
mult_loop:
bge t2 a1 mult_escapeloop
add t3 t3 a0 # sum = sum + b
addi t2 t2 1 # i++
j mult_loop
mult_escapeloop:
mv a0 t3
jr ra

exit:
