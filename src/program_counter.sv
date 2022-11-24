`timescale 1ns / 1ps

module program_counter(
    input logic clk_i, rst_i, we_i,
    
    input logic [31:0] write_addr_i, // PC+, next value of PC.
    
    output logic [31:0] pc4_o, // Current value of PC+4.
    output logic [31:0] pc_o // Current value of PC.
    );
    
    reg [31:0] pc; // Internal PC register.
    
    // Output values locked to internal PC register.
    assign pc_o = pc;
    assign pc4_o = pc + 32'h4;

    always_ff @ (posedge clk_i) begin
        if (rst_i) begin // Reset signal.
             pc <= 32'h0; // Expect kernel entry point at 0x1000.
        end
        else begin // Regular clock.
            if (we_i) begin
                // if (write_addr_i[1:0] != 2'b00)
                //     generate instruction-address-misaligned exception
                pc <= write_addr_i;
            end
            else begin
                pc <= pc4_o;
            end
        end
    end
endmodule