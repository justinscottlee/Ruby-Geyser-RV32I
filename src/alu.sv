`timescale 1ns / 1ps

module alu (
    input logic [3:0] alu_op_i, // Operation.
    input logic [31:0] a_i, b_i, // Operands.
    output logic [31:0] res_o // Result.
    );
    
    `include "defines.vh"
    
    always_comb begin
        case (alu_op_i)
        `ALU_ADD:   res_o = a_i + b_i;
        `ALU_SUB:   res_o = a_i - b_i;
        `ALU_LT:    res_o = $signed(a_i) < $signed(b_i);
        `ALU_LTU:   res_o = a_i < b_i;
        `ALU_XOR:   res_o = a_i ^ b_i;
        `ALU_OR:    res_o = a_i | b_i;
        `ALU_AND:   res_o = a_i & b_i;
        // For shift operations below, we only need to shift by the first 5 least significant bits of b_i (b_i[4:0]). Any more, and we'd be shifting a 32 bit input by greater than 32 bits. There are also concerns with the increased hardware to support shifting by greater than 32 bits even if it could never be done in practice.
        `ALU_SRL:   res_o = a_i >> b_i[4:0];
        `ALU_SRA:   res_o = $signed(a_i) >>> b_i[4:0];
        `ALU_SLL:   res_o = a_i << b_i[4:0];
        default:    res_o = 32'd0;
        endcase
    end
endmodule