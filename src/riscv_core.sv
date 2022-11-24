`timescale 1ns / 1ps

module riscv_core(
    input clk_i, rst_i, microcode_we_i,
    input [18:0] microcode_write_data_i,
    input [5:0] microcode_write_addr_i,
    output [31:0] alu_res_monitor, rs1_data_monitor, rs2_data_monitor, rd_data_monitor, imm_monitor, pc_monitor, alu_a_monitor, alu_b_monitor, branch_addr_monitor, lsu_read_monitor, inst_monitor,
    output [4:0] rs1_monitor, rs2_monitor, rd_monitor,
    output invalid_instruction_monitor, clk
    );

    assign alu_res_monitor = alu_res;
    assign rs1_data_monitor = rs1_data;
    assign rs2_data_monitor = rs2_data;
    assign rd_data_monitor = rd_data;
    assign imm_monitor = imm;
    assign pc_monitor = pc;
    assign alu_a_monitor = alu_a;
    assign alu_b_monitor = alu_b;
    assign branch_addr_monitor = branch_addr;
    assign lsu_read_monitor = lsu_read_data;
    assign inst_monitor = inst;
    assign rs1_monitor = rs1;
    assign rs2_monitor = rs2;
    assign rd_monitor = rd;
    assign invalid_instruction_monitor = invalid_instruction;
    
    wire [31:0] alu_res, rs1_data, rs2_data, rd_data, imm, pc, pc4, inst, alu_a, alu_b, branch_addr, branch_base_addr, dm_read_data, lsu_read_data;
    wire [18:0] control_field;
    wire [6:0] opcode, funct7;
    wire [5:0] microcode_read_addr;
    wire [4:0] rs1, rs2, rd;
    wire [3:0] alu_op, dm_write_mask;
    wire [2:0] br_cond, imm_sel, funct3;
    wire [1:0] rd_data_sel, lsu_data_width;
    wire a_sel, b_sel, br_base_sel, br_taken, regfile_we, lsu_we, lsu_sign_extend, invalid_instruction, clk;
    
    // clock_generator is an IP clock wizard source from Vivado. You may want to replace this with a manual "always #1 clk = ~clk;" in the testbench for simulation outside of Vivado.
    clock_generator clock_generator(.clk_100MHz_i(clk_i), .clk_200MHz_o(clk));
    
    decoder decoder(.inst_i(inst), .imm_sel_i(imm_sel), .imm_o(imm), .rs1_o(rs1), .rs2_o(rs2), .rd_o(rd), .opcode_o(opcode), .funct7_o(funct7), .funct3_o(funct3));
    control_unit control_unit(.opcode_i(opcode), .funct7_i(funct7), .funct3_i(funct3), .control_field_i(control_field), .microcode_addr_o(microcode_read_addr), .alu_a_sel_o(a_sel), .alu_b_sel_o(b_sel), .alu_op_o(alu_op), .br_base_sel_o(br_base_sel), .br_cond_o(br_cond), .regfile_we_o(regfile_we), .rd_data_sel_o(rd_data_sel), .lsu_we_o(lsu_we), .lsu_sign_extend_o(lsu_sign_extend), .lsu_datawidth_o(lsu_data_width), .imm_sel_o(imm_sel), .invalid_instruction_o(invalid_instruction));
    microcode_memory microcode_memory(.clk_i(clk), .we_i(microcode_we_i), .read_addr_i(microcode_read_addr), .write_addr_i(microcode_write_addr_i), .write_data_i(microcode_write_data_i), .read_data_o(control_field)); // good
    regfile regfile(.clk_i(clk), .rst_i(rst_i), .we_i(regfile_we), .rd_i(rd), .rd_data_i(rd_data), .rs1_i(rs1), .rs2_i(rs2), .rs1_data_o(rs1_data), .rs2_data_o(rs2_data));
    alu alu(.alu_op_i(alu_op), .a_i(alu_a), .b_i(alu_b), .res_o(alu_res)); // good
    program_counter program_counter(.clk_i(clk), .rst_i(rst_i), .we_i(br_taken), .write_addr_i(branch_addr), .pc_o(pc), .pc4_o(pc4)); // good
    instruction_memory L1_instruction_cache(.addr_i(pc), .inst_o(inst)); // good
    brancher brancher(.br_cond_i(br_cond), .alu_result_i(alu_res), .base_addr_i(branch_base_addr), .offset_i(imm), .addr_o(branch_addr), .br_taken_o(br_taken)); // good
    mux2 mux_alu_a(.sel_i(a_sel), .in0_i(rs1_data), .in1_i(pc), .out_o(alu_a)); // good
    mux2 mux_alu_b(.sel_i(b_sel), .in0_i(imm), .in1_i(rs2_data), .out_o(alu_b)); // good
    mux2 mux_br_base(.sel_i(br_base_sel), .in0_i(pc), .in1_i(rs1_data), .out_o(branch_base_addr)); // good
    mux4 mux_rd_data(.sel_i(rd_data_sel), .in00_i(alu_res), .in01_i(pc4), .in10_i(lsu_read_data), .in11_i(imm), .out_o(rd_data)); // good
    load_store_unit lsu(.sign_extend_i(lsu_sign_extend), .we_i(lsu_we), .data_width_i(lsu_data_width), .addr_i(alu_res), .write_data_i(rs2_data), .dm_read_data_i(dm_read_data), .read_data_o(lsu_read_data), .dm_write_mask_o(dm_write_mask));
    memory_8Kx8x4 L1_data_cache(.clk_i(clk), .write_mask_i(dm_write_mask), .addr_i(alu_res[14:0]), .write_data_i(rs2_data), .read_data_o(dm_read_data));

endmodule