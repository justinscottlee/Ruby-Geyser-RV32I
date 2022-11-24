`timescale 1ns / 1ps

module instruction_memory #(
    parameter SIZE = 32768
    )(
        input logic [$clog2(SIZE)-1:0] addr_i,
        output logic [31:0] inst_o
    );
    
    reg [31:0] mem [0:SIZE/4-1];
    
    initial $readmemh("instruction_memory.mem", mem);
    
    always_comb begin
        inst_o = mem[addr_i / 4];
    end
endmodule