`timescale 1ns / 1ps

module decoder(
    input logic [31:0] inst_i, // Instruction.
    
    // Immediate selection/output.
    input logic [2:0] imm_sel_i,
    output logic [31:0] imm_o,
    
    output logic [4:0] rs1_o, rs2_o, rd_o, // Source/Destination registers.
    
    // Instruction identifiers.
    output logic [6:0] opcode_o, funct7_o,
    output logic [2:0] funct3_o
    );
    
    always_comb begin
        // Instruction identifiers.
        opcode_o = inst_i[6:0];
        funct3_o = inst_i[14:12];
        funct7_o = inst_i[31:25];
        
        // Source/Destination registers.
        rs1_o = inst_i[19:15];
        rs2_o = inst_i[24:20];
        rd_o =  inst_i[11:7];
        
        // Immediates.
        case (imm_sel_i)
        `IMM_SEL_I: imm_o = {{20{inst_i[31]}}, inst_i[31:20]};
        `IMM_SEL_S: imm_o = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
        `IMM_SEL_B: imm_o = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
        `IMM_SEL_U: imm_o = {inst_i[31:12], 12'b0};
        `IMM_SEL_J: imm_o = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
        default: imm_o = 32'd0;
        endcase
    end
endmodule