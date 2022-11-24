`timescale 1ns / 1ps

module tb_riscv_core;
    reg clk_i, clk, rst_i, microcode_we;
    reg [18:0] microcode_write_data;
    reg [5:0] microcode_write_addr;
    wire [31:0] alu_res_monitor, rs1_data_monitor, rs2_data_monitor, rd_data_monitor, imm_monitor, pc_monitor, alu_a_monitor, alu_b_monitor, branch_addr_monitor, lsu_read_monitor, inst_monitor;
    wire [4:0] rs1_monitor, rs2_monitor, rd_monitor;
    wire invalid_instruction_monitor;
    
    riscv_core dut(.clk_i(clk_i), .clk(clk), .rst_i(rst_i), .microcode_we_i(microcode_we), .microcode_write_data_i(microcode_write_data), .microcode_write_addr_i(microcode_write_addr), .alu_res_monitor(alu_res_monitor), .rs1_data_monitor(rs1_data_monitor), .rs2_data_monitor(rs2_data_monitor), .rd_data_monitor(rd_data_monitor), .imm_monitor(imm_monitor), .pc_monitor(pc_monitor), .alu_a_monitor(alu_a_monitor), .alu_b_monitor(alu_b_monitor), .branch_addr_monitor(branch_addr_monitor), .lsu_read_monitor(lsu_read_monitor), .inst_monitor(inst_monitor), .rs1_monitor(rs1_monitor), .rs2_monitor(rs2_monitor), .rd_monitor(rd_monitor), .invalid_instruction_monitor(invalid_instruction_monitor));
    
    `include "defines.vh"
    
    always #5 clk_i = ~clk_i;
      // The instruction_memory module is loaded by its initial begin statement, so all we need to do in this testbench is generate a clock.
    initial begin
        clk_i = 1'b0;
        #1000;
        microcode_we = 1'b1;
        // LUI
        microcode_write_addr = 6'd0;
        microcode_write_data = {`IMM_SEL_U, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_IMM, `REGFILE_WRITE_ENABLE, 1'bx,`BRANCH_FORCE_FALSE, 4'bxxxx, 1'bx, 1'bx}; // good
        #5; // wait for clock to write to microcode
        // AUIPC
        microcode_write_addr = 6'd1;
        microcode_write_data = {`IMM_SEL_U, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_PC}; // good
        #5; // wait for clock to write to microcode
        // JAL
        microcode_write_addr = 6'd2;
        microcode_write_data = {`IMM_SEL_J, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_PC4, `REGFILE_WRITE_ENABLE, `BRANCH_BASE_SEL_PC, `BRANCH_FORCE_TRUE, 4'bxxxx, 1'bx, 1'bx};
        #5; // wait for clock to write to microcode
        // JALR
        microcode_write_addr = 6'd3;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_PC4, `REGFILE_WRITE_ENABLE, `BRANCH_BASE_SEL_RS1, `BRANCH_FORCE_TRUE, 4'bxxxx, 1'bx, 1'bx};
        #5; // wait for clock to write to microcode
        // BEQ
        microcode_write_addr = 6'd4;
        microcode_write_data = {`IMM_SEL_B, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, 2'bxx, `REGFILE_WRITE_DISABLE, `BRANCH_BASE_SEL_PC, `BRANCH_ALU_ZERO, `ALU_SUB, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // BNE
        microcode_write_addr = 6'd5;
        microcode_write_data = {`IMM_SEL_B, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, 2'bxx, `REGFILE_WRITE_DISABLE, `BRANCH_BASE_SEL_PC, `BRANCH_ALU_NONZERO, `ALU_SUB, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // BLT
        microcode_write_addr = 6'd6;
        microcode_write_data = {`IMM_SEL_B, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, 2'bxx, `REGFILE_WRITE_DISABLE, `BRANCH_BASE_SEL_PC, `BRANCH_ALU_NONZERO, `ALU_LT, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // BGE
        microcode_write_addr = 6'd7;
        microcode_write_data = {`IMM_SEL_B, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, 2'bxx, `REGFILE_WRITE_DISABLE, `BRANCH_BASE_SEL_PC, `BRANCH_ALU_ZERO, `ALU_LT, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // BLTU
        microcode_write_addr = 6'd8;
        microcode_write_data = {`IMM_SEL_B, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, 2'bxx, `REGFILE_WRITE_DISABLE, `BRANCH_BASE_SEL_PC, `BRANCH_ALU_NONZERO, `ALU_LTU, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // BGEU
        microcode_write_addr = 6'd9;
        microcode_write_data = {`IMM_SEL_B, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, 2'bxx, `REGFILE_WRITE_DISABLE, `BRANCH_BASE_SEL_PC, `BRANCH_ALU_ZERO, `ALU_LTU, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // LB
        microcode_write_addr = 6'd10;
        microcode_write_data = {`IMM_SEL_I, `DATAWIDTH_BYTE, `LSU_SIGN_EXTENDED, `LSU_WRITE_DISABLE, `RD_DATA_SEL_LSU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // LH
        microcode_write_addr = 6'd11;
        microcode_write_data = {`IMM_SEL_I, `DATAWIDTH_SHORT, `LSU_SIGN_EXTENDED, `LSU_WRITE_DISABLE, `RD_DATA_SEL_LSU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // LW
        microcode_write_addr = 6'd12;
        microcode_write_data = {`IMM_SEL_I, `DATAWIDTH_WORD, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_LSU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // LBU
        microcode_write_addr = 6'd13;
        microcode_write_data = {`IMM_SEL_I, `DATAWIDTH_BYTE, `LSU_NOT_SIGN_EXTENDED, `LSU_WRITE_DISABLE, `RD_DATA_SEL_LSU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // LHU
        microcode_write_addr = 6'd14;
        microcode_write_data = {`IMM_SEL_I, `DATAWIDTH_SHORT, `LSU_NOT_SIGN_EXTENDED, `LSU_WRITE_DISABLE, `RD_DATA_SEL_LSU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SB
        microcode_write_addr = 6'd15;
        microcode_write_data = {`IMM_SEL_S, `DATAWIDTH_BYTE, 1'bx, `LSU_WRITE_ENABLE, 2'bxx, `REGFILE_WRITE_DISABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SH
        microcode_write_addr = 6'd16;
        microcode_write_data = {`IMM_SEL_S, `DATAWIDTH_SHORT, 1'bx, `LSU_WRITE_ENABLE, 2'bxx, `REGFILE_WRITE_DISABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SW
        microcode_write_addr = 6'd17;
        microcode_write_data = {`IMM_SEL_S, `DATAWIDTH_WORD, 1'bx, `LSU_WRITE_ENABLE, 2'bxx, `REGFILE_WRITE_DISABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // ADDI
        microcode_write_addr = 6'd18;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SLTI
        microcode_write_addr = 6'd19;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_LT, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SLTIU
        microcode_write_addr = 6'd20;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_LTU, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // XORI
        microcode_write_addr = 6'd21;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_XOR, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // ORI
        microcode_write_addr = 6'd22;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_OR, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // ANDI
        microcode_write_addr = 6'd23;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_AND, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SLLI
        microcode_write_addr = 6'd24;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_SLL, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SRLI
        microcode_write_addr = 6'd25;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_SRL, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SRAI
        microcode_write_addr = 6'd26;
        microcode_write_data = {`IMM_SEL_I, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_SRA, `ALU_B_SEL_IMM, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // ADD
        microcode_write_addr = 6'd27;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_ADD, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SUB
        microcode_write_addr = 6'd28;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_SUB, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SLL
        microcode_write_addr = 6'd29;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_SLL, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SLT
        microcode_write_addr = 6'd30;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_LT, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SLTU
        microcode_write_addr = 6'd31;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_LTU, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // XOR
        microcode_write_addr = 6'd32;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_XOR, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SRL
        microcode_write_addr = 6'd33;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_SRL, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // SRA
        microcode_write_addr = 6'd34;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_SRA, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // OR
        microcode_write_addr = 6'd35;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_OR, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // AND
        microcode_write_addr = 6'd36;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, `RD_DATA_SEL_ALU, `REGFILE_WRITE_ENABLE, 1'bx, `BRANCH_FORCE_FALSE, `ALU_AND, `ALU_B_SEL_RS2, `ALU_A_SEL_RS1};
        #5; // wait for clock to write to microcode
        // FENCE (currently implemented as NOP)
        microcode_write_addr = 6'd37;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, 2'bxx, `REGFILE_WRITE_DISABLE, 1'bx, `BRANCH_FORCE_FALSE, 4'bxxxx, 1'bx, 1'bx};
        #5; // wait for clock to write to microcode
        // ECALL or EBREAK (currently implemented as NOP)
        microcode_write_addr = 6'd38;
        microcode_write_data = {3'bxxx, 2'bxx, 1'bx, `LSU_WRITE_DISABLE, 2'bxx, `REGFILE_WRITE_DISABLE, 1'bx, `BRANCH_FORCE_FALSE, 4'bxxxx, 1'bx, 1'bx};
        #5; // wait for clock to write to microcode
        microcode_we = 1'b0;
        rst_i = 1'b1;
        #5;
        rst_i = 1'b0;
        #200000;
        $finish;
    end
endmodule