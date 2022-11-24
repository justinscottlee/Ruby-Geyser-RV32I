`timescale 1ns / 1ps

module mux4(
    input logic [1:0] sel_i,
    input logic [31:0] in00_i, in01_i, in10_i, in11_i,
    output logic [31:0] out_o
    );
    
    always_comb begin
        case (sel_i)
        2'b00: out_o = in00_i;
        2'b01: out_o = in01_i;
        2'b10: out_o = in10_i;
        2'b11: out_o = in11_i;
        endcase
    end
endmodule