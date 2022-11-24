`timescale 1ns / 1ps

module memory_bank
    #(parameter DATA_WIDTH = 8,
      parameter DATA_DEPTH = 8192) (
    input logic clk_i, we_i,
    input logic [$clog2(DATA_DEPTH)-1:0] addr_i,
    input logic [DATA_WIDTH-1:0] write_data_i,
    output logic [DATA_WIDTH-1:0] read_data_o
    );
    
    reg [DATA_WIDTH-1:0] mem [0:DATA_DEPTH-1];
    
    always_comb begin
        read_data_o = mem[addr_i];
    end
    
    always_ff @ (posedge clk_i) begin
        if (we_i) begin
            mem[addr_i] <= write_data_i;
        end
    end
endmodule