`timescale 1ns / 1ps

// Horizontal Microcode. Needs to be programmed by the motherboard on every boot, or can be updated further by the kernel if microcode memory is put in the address space--which it should be.
module microcode_memory(
    input logic clk_i, we_i,
    
    input logic [5:0] read_addr_i,
    output logic [18:0] read_data_o, // Output control signal bit-field.
    
    input logic [5:0] write_addr_i,
    input logic [18:0] write_data_i // Input write data for microcode programming.
    );
    
    // 19 internal core control signals, up to 64 instructions.
    reg [18:0] mem [63:0];
    
    always_comb begin
        read_data_o = mem[read_addr_i];
    end
    
    always_ff @ (posedge clk_i) begin
        if (we_i) begin
            mem[write_addr_i] <= write_data_i;
        end
    end
endmodule