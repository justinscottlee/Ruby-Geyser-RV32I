# Tested Instructions:
# LUI
# AUIPC
# JAL, JALR
# BEQ, BNE, BLT, BGE, BLTU, BGEU
# LB, LH, LW, LBU, LHU
# SB, SH, SW
# ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
# ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND

# We need a certain baseline of instructions we can trust function to verify other instructions.
# Like axioms or postulates to prove the rest of the instruction set.
# s0 will be our assertion failed register. It will have a "code" so we can tell where our program failed.
lui x1, 0xFFFFF         # manually verify 0xFFFFF000 is written to x1.
lui x1, 0x00000         # manually verify 0x00000000 is written to x1.
lui x1, 0x01234         # manually verify 0x01234000 is written to x1.
# From here on, I trust lui functions absolutely.

addi x1, x0, 10         # manually verify 10 is written to x1.
addi x1, x1, -10        # manually verify 0 is written to x1.
addi x1, x1, -10        # manually verify -10 is written to x1.
# From here on, I trust addi functions absolutely.

jal x1, jal_success     # manually verify 0x1C is written to x1.
nop                     # pseudoinstruction addi x0, x0, 0
jal_success:
nop                     # manually verify this instruction is called immediately after the jal.
# From here on, I trust jal functions absolutely.

addi s0, x0, 1          # beq assertion failed code 1.
beq x0, x0, beq_eq      # branch should be taken
    j assertion_failed
beq_eq:
addi x1, x0, 10
beq x0, x1, beq_ne      # branch shouldn't be taken
j beq_ne_succeeds
beq_ne:
    j assertion_failed
beq_ne_succeeds:
# From here on, I trust beq functions absolutely.

addi s0, x0, 2          # bne assertion failed code 2
bne x0, x0, bne_eq      # branch shouldn't be taken
j bne_eq_succeeds
bne_eq:
    j assertion_failed
bne_eq_succeeds:
addi x1, x0, 10
bne x0, x1, bne_ne      # branch should be taken
    j assertion_failed
bne_ne:
# From here on, I trust bne functions absolutely.

addi s0, x0, 3          # jalr assertion failed code 3
addi x1, x0, 0x68
jalr x1, 4(x1)          # manually verify 0x68 is written to x1.
    j assertion_failed
jalr_success:
nop                     # manually verify this instruction is called immediately after the jalr.
# From here on, I trust jalr functions absolutely.

addi s0, x0, 4          # auipc assertion failed code 4
auipc x1, 0xFFFFF
mv a0, x1
lui a1, 0xFFFFF
addi a1, a1, 0x74
jal assert
auipc x1, 0x00000
mv a0, x1
addi a1, x0, 0x88
jal assert
auipc x1, 0x01234
mv a0, x1
lui a1, 0x01234
addi a1, a1, 0x98
jal assert
# From here on, I trust auipc functions absolutely.

addi s0, x0, 5          # blt assertion failed code 5
addi x1, x0, 10
addi x2, x0, 15
blt x1, x2, bltfirst    # branch should be taken
    j assertion_failed
bltfirst:
blt x2, x1, bltsecond   # branch shouldn't be taken
j skipbltsecond
bltsecond:
    j assertion_failed
skipbltsecond:
addi x1, x0, -10
addi x2, x0, -15
blt x2, x1, bltthird    # branch should be taken
    j assertion_failed
bltthird:
blt x1, x2, bltfourth   # branch should not be taken
j skipbltfourth
bltfourth:
    j assertion_failed
skipbltfourth:
# From here on, I trust blt functions absolutely.

addi s0, x0, 6          # bge assertion failed code 6
addi x1, x0, 10
addi x2, x0, 15
bge x2, x1, bgefirst    # branch should be taken
    j assertion_failed
bgefirst:
bge x1, x2, bgesecond   # branch shouldn't be taken
j skipbgesecond
bgesecond:
    j assertion_failed
skipbgesecond:
addi x1, x0, -10
addi x2, x0, -15
bge x1, x2, bgethird    # branch should be taken
    j assertion_failed
bgethird:
bge x2, x1, bgefourth   # branch should not be taken
j skipbgefourth
bgefourth:
    j assertion_failed
skipbgefourth:
# From here on, I trust bge functions absolutely.

addi s0, x0, 7          # bltu assertion failed code 7
addi x1, x0, -10
addi x2, x0, -20
bltu x2, x1, bltufirst  # branch should be taken
    j assertion_failed
bltufirst:
bltu x1, x2, bltusecond # branch should not be taken
j skipbltusecond
bltusecond:
    j assertion_failed
skipbltusecond:
addi x1, x0, 10
addi x2, x0, 20
bltu x1, x2, bltuthird  # branch should be taken
    j assertion_failed
bltuthird:
bltu x2, x1, bltufourth # branch should not be taken
j skipbltufourth
bltufourth:
    j assertion_failed
skipbltufourth:
# From here on, I trust bltu functions absolutely.

addi s0, x0, 8          # bgeu assertion failed code 8
addi x1, x0, -10
addi x2, x0, -20
bgeu x2, x1, bgeufirst  # branch shouldn't be taken
j skipbgeufirst
bgeufirst:
    j assertion_failed
skipbgeufirst:
bgeu x1, x2, bgeusecond # branch should be taken
    j assertion_failed
bgeusecond:
addi x1, x0, 10
addi x2, x0, 20
bgeu x2, x1, bgeuthird  # branch should be taken
    j assertion_failed
bgeuthird:
bgeu x1, x2, bgeufourth # branch should not be taken
j skipbgeufourth
bgeufourth:
    j assertion_failed
skipbgeufourth:
bgeu x0, x0, bgeufifth  # branch should be taken
    j assertion_failed
bgeufifth:
# From here on, I trust bgeu functions absolutely.

addi s0, x0, 9      # lw/sw assertion failed code 9
addi a0, x0, 20
addi t0, x0, 40
sw a0, 0(t0)
lw a1, 0(t0)
jal assert
# From here on, I trust lw/sw function absolutely.

addi s0, x0, 10     # lb/sb assertion failed code 10
lui t0, 0x77FF7
addi t0, t0, 0x0FF  # a0 = 0xFE01DC23
addi t1, x0, 40
sw t0, 0(t1)        # mem[40] = 0xFE01DC23
lb a0, 0(t1)
addi a1, x0, -1
jal assert
lb a0, 1(t1)
addi a1, x0, 0x70
jal assert
sb x0, 2(t1)
lb a0, 2(t1)
addi a1, x0, 0
jal assert
# From here on, I trust lb/sb function absolutely.

addi s0, x0, 11     # lh/sh assertion failed code 11
lui t0, 0x7FFFF # t0 = 0x7FFF F000
addi t1, x0, 40
sw t0, 0(t1)    # mem[40] = 0x7FFF F000
lh a0, 0(t1)
lui a1, 0xFFFFF # testing sign extension of loading 0xF000
jal assert
lh a0, 2(t1)
addi a0, a0, 1      # some funky stuff here, it is easier to test 0x8000 rather than 0x7FF because of the maximum immediate size I can load (I think 2048).
lui a1, 0x00008
jal assert
addi t0, x0, 123
sh t0, 0(t1)
lh a0, 0(t1)
addi a1, x0, 123
jal assert
# From here on, I trust lh/sh function absolutely.

addi s0, x0, 12     # lbu assertion failed code 12
addi t0, x0, 25
addi t1, x0, 40
sb t0, 1(t1)        # (byte)mem[41] = 25
lbu a0, 1(t1)
addi a1, x0, 25
jal assert
addi t0, x0, -25
sb t0, 1(t1)        # (byte)mem[41] = -25
lbu a0, 1(t1)
addi a1, x0, 231
jal assert
# From here on, I trust lbu functions absolutely.

addi s0, x0, 13     # lhu assertion failed code 13
lui t0, 0x7FFF0
addi t1, x0, 40
sw t0, 0(t1)        # mem[40] = 0x7FFF 0000
lhu a0, 2(t1)
addi a0, a0, 1      # same trick converting to 0x8000
lui a1, 0x00008
jal assert
addi t0, x0, -256   # 0xFF00
sh t0, 2(t1)
lhu a0, 2(t1)
addi a0, a0, 0xFF
addi a0, a0, 1  # same trick converting to 0x10000
lui a1, 0x00010
jal assert
# From here on, I trust lhu functions absolutely.

addi s0, x0, 14     # slti assertion failed code 14
addi t0, x0, 20
slti a0, t0, 10
addi a1, x0, 0
jal assert
slti a0, t0, -20
jal assert
slti a0, t0, 20
jal assert
slti a0, t0, 30
addi a1, x0, 1
jal assert
addi t0, x0, -20
slti a0, t0, -15
addi a1, x0, 1
jal assert
slti a0, t0, -30
addi a1, x0, 0
jal assert
# From here on, I trust slti functions absolutely.

addi s0, x0, 15     #sltiu assertion failed code 15
addi t0, x0, 20
sltiu a0, t0, 30
addi a1, x0, 1
jal assert
sltiu a0, t0, -1
jal assert
addi a1, x0, 0
sltiu a0, t0, 5
jal assert
# From here on, I trust sltiu functions absolutely.

addi s0, x0, 16     # xori assertion failed code 16
addi t0, x0, 5      # 0101
xori a0, t0, 3      # 0011
addi a1, x0, 6      # 0110
jal assert
# From here on, I trust xori functions absolutely.

addi s0, x0, 17     # ori assertion failed code 17
addi t0, x0, 5      # 0101
ori a0, t0, 3       # 0011
addi a1, x0, 7      # 0111
jal assert
# From here on, I trust ori fuctions absolutely.

addi s0, x0, 18     # andi assertion failed code 18
addi t0, x0, 5      # 0101
andi a0, t0, 3      # 0011
addi a1, x0, 1
jal assert
# From here on, I trust andi functions absolutely.

addi s0, x0, 19     # slli assertion failed code 19
addi t0, x0, 5      # 0101
slli a0, t0, 3      # 101000
addi a1, x0, 40
jal assert
# From here on, I trust slli functions absolutely

addi s0, x0, 20     # srli assertion failed code 20
addi t0, x0, -10
srli a0, t0, 2
blt a0, x0, assertion_failed
addi t0, x0, 9      # 1001
srli a0, t0, 1      # 0100
addi a1, x0, 4
jal assert
# From here on, I trust srli functions absolutely.

addi s0, x0, 21     # srai assertion failed code 21
addi t0, x0, -10
srai a0, t0, 1
addi a1, x0, -5
jal assert
addi t0, x0, 20
srai a0, t0, 1
addi a1, x0, 10
jal assert
# From here on, I trust srai functions absolutely.

addi s0, x0, 22     # add assertion failed code 22
addi t0, x0, 100
addi t1, x0, 100
add a0, t0, t1
addi a1, x0, 200
jal assert
addi t1, x0, -100
add a0, t0, t1
addi a1, x0, 0
jal assert
addi t0, x0, -100
add a0, t0, t1
addi a1, x0, -200
jal assert
addi t1, x0, 100
add a0, t0, t1
addi a1, x0, 0
jal assert
# From here on, I trust add functions absolutely.

addi s0, x0, 23     # sub assertion failed code 23
addi t0, x0, 100
addi t1, x0, 100
sub a0, t1, t0
addi a1, x0, 0
jal assert
addi t1, x0, -100
sub a0, t1, t0
addi a1, x0, -200
jal assert
addi t0, x0, -100
sub a0, t1, t0
addi a1, x0, 0
jal assert
addi t1, x0, 100
sub a0, t1, t0
addi a1, x0, 200
jal assert
# From here on, I trust sub functions absolutely.

# Same logical code as slli assertions.
addi s0, x0, 24     # sll assertion failed code 24
addi t0, x0, 5      # 0101
addi t1, x0, 3
sll a0, t0, t1      # 101000
addi a1, x0, 40
jal assert
# From here on, I trust sll functions absolutely.

# Same logical code as slti assertions.
addi s0, x0, 25     # slt assertion failed code 25
addi t0, x0, 20
addi t1, x0, 10
slt a0, t0, t1
addi a1, x0, 0
jal assert
addi t1, x0, -20
slt a0, t0, t1
jal assert
addi t1, x0, 20
slt a0, t0, t1
jal assert
addi t1, x0, 30
slt a0, t0, t1
addi a1, x0, 1
jal assert
addi t0, x0, -20
addi t1, x0, -15
slt a0, t0, t1
addi a1, x0, 1
jal assert
addi t1, x0, -30
slt a0, t0, t1
addi a1, x0, 0
jal assert
# From here on, I trust slt functions absolutely.

# Same logical code as sltiu assertions.
addi s0, x0, 26     # sltu assertion failed code 26
addi t0, x0, 20
addi t1, x0, 30
sltu a0, t0, t1
addi a1, x0, 1
jal assert
addi t1, x0, -1
sltu a0, t0, t1
jal assert
addi a1, x0, 0
addi t1, x0, 5
sltu a0, t0, t1
jal assert
# From here on, I trust sltu functions absolutely.

# Same logical code as ori assertions.
addi s0, x0, 27     # or assertion failed code 27
addi t0, x0, 5      # 0101
addi t1, x0, 3      # 0011
or a0, t0, t1       # 0111
addi a1, x0, 7
jal assert
# From here on, I trust or functions absolutely.

# Same logical code as andi assertions.
addi s0, x0, 28     # and assertion failed code 28
addi t0, x0, 5      # 0101
addi t1, x0, 3      # 0011
and a0, t0, t1      # 0001
addi a1, x0, 1
jal assert
# From here on, I trust and functions absolutely.

# Same logical code as xori assertions.
addi s0, x0, 29     # xor assertion failed code 29
addi t0, x0, 5      # 0101
addi t1, x0, 3      # 0011
xor a0, t0, t1      # 0110
addi a1, x0, 6
jal assert
# From here on, I trust xor functions absolutely.

# Same logical code as srli assertions.
addi s0, x0, 30     # srl assertion failed code 30
addi t0, x0, -10
addi t1, x0, 2
srl a0, t0, t1
blt a0, x0, assertion_failed
addi t0, x0, 9
addi t1, x0, 1
srl a0, t0, t1
addi a1, x0, 4
jal assert
# From here on, I trust srl functions absolutely.

# Same logical code as srai assertions.
addi s0, x0, 31     # sra assertion failed code 31
addi t0, x0, -10
addi t1, x0, 1
sra a0, t0, t1
addi a1, x0, -5
jal assert
addi t0, x0, 20
addi t1, x0, 1
sra a0, t0, t1
addi a1, x0, 10
jal assert
# From here on, I trust sra functions absolutely.

# At this point, all instructions have been tested and none of them have "thrown" an error by going into an infinite loop.

# end program
addi s0, x0, -1
j exit
assert: # void assert(a0, a1) { if (a0 != a1) {throw} else {return}}
    bne a0, a1, assertion_failed
    jr ra
assertion_failed:
    mv s0, s0               # pseudoinstruction addi s0, s0, 0
    j assertion_failed      # pseudoinstruction jal x0, -4
exit:
# If s0 is 0xFFFFFFFF, all tests passed.
