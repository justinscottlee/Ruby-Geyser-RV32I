`timescale 1ns / 1ps

module brancher(
    input logic [1:0] br_cond_i,
    input logic [31:0] alu_result_i, base_addr_i, offset_i,
    
    output logic [31:0] addr_o, // Calculated branch address from base address and offset.
    output logic br_taken_o // Whether the branch is taken.
    );
    
    `include "defines.vh"
    
    always_comb begin
        addr_o = base_addr_i + offset_i; // Internal adder to calculate branch address.
        case (br_cond_i)
        `BRANCH_ALU_ZERO:    br_taken_o = alu_result_i == 0;
        `BRANCH_ALU_NONZERO: br_taken_o = alu_result_i != 0;           
        `BRANCH_FORCE_FALSE: br_taken_o = 1'b0;
        `BRANCH_FORCE_TRUE:  br_taken_o = 1'b1;
        endcase
    end
endmodule