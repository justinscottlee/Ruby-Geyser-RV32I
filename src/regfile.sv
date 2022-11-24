`timescale 1ns / 1ps

module regfile(
    input logic clk_i, rst_i, we_i,
    
    // Destination register.
    input logic [4:0] rd_i,
    input logic [31:0] rd_data_i,
    
    // Source registers.
    input logic [4:0] rs1_i, rs2_i,
    output logic [31:0] rs1_data_o, rs2_data_o
    );
    
    reg [31:0] regfile [1:31]; // x1-x31 32-bit registers (x0 is hardwired to zero).
    
    always_ff @ (posedge clk_i) begin
        if (rst_i) begin // Reset signal.
            for (int i = 1; i < 32; i++) begin
                regfile[i] <= 32'h0; // Set all registers to zero.
            end
            regfile[2] <= 32'h7FF0; // Set stack pointer register to 0x7FF0.
            regfile[3] <= 32'h4000; // Set global pointer register to 0x4000.
        end
        else begin // Regular clock.
            if (we_i) begin
                regfile[rd_i] <= rd_data_i; // Writing to register rd.
            end
        end
    end
    
    always_comb begin
        rs1_data_o = (rs1_i == 0) ? 32'h0 : regfile[rs1_i]; // Reading from register rs1.
        rs2_data_o = (rs2_i == 0) ? 32'h0 : regfile[rs2_i]; // Reading from register rs2.
    end
endmodule