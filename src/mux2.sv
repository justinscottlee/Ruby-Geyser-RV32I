`timescale 1ns / 1ps

module mux2(
    input logic sel_i,
    input logic [31:0] in0_i, in1_i,
    output logic [31:0] out_o
    );
    
    always_comb begin
        out_o = sel_i ? in1_i : in0_i;
    end
endmodule