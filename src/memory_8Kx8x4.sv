`timescale 1ns / 1ps

module memory_8Kx8x4(
    input logic clk_i,
    input logic [3:0] write_mask_i,
    input logic [14:0] addr_i,
    input logic [31:0] write_data_i,
    output logic [31:0] read_data_o
    );
    
    reg bank0_write_enable, bank1_write_enable, bank2_write_enable, bank3_write_enable;
    reg [12:0] bank0_addr, bank1_addr, bank2_addr, bank3_addr;
    reg [7:0] bank0_write_data, bank1_write_data, bank2_write_data, bank3_write_data;
    wire [7:0] bank0_read_data, bank1_read_data, bank2_read_data, bank3_read_data;
    
    logic [12:0] bank_addr;
    logic [1:0] bank_base;
    
    assign bank_base = addr_i % 4; // addr_i % 4 signifies which memory bank the data starts at
    assign bank_addr = addr_i >> 2; // addr_i >> 2 is needed because the memory is basically striped across 4 modules, so divide by 4
    
    memory_bank #(.DATA_WIDTH(8), .DATA_DEPTH(8192)) bank0 (.clk_i(clk_i), .we_i(bank0_write_enable), .addr_i(bank0_addr), .write_data_i(bank0_write_data), .read_data_o(bank0_read_data));
    memory_bank #(.DATA_WIDTH(8), .DATA_DEPTH(8192)) bank1 (.clk_i(clk_i), .we_i(bank1_write_enable), .addr_i(bank1_addr), .write_data_i(bank1_write_data), .read_data_o(bank1_read_data));
    memory_bank #(.DATA_WIDTH(8), .DATA_DEPTH(8192)) bank2 (.clk_i(clk_i), .we_i(bank2_write_enable), .addr_i(bank2_addr), .write_data_i(bank2_write_data), .read_data_o(bank2_read_data));
    memory_bank #(.DATA_WIDTH(8), .DATA_DEPTH(8192)) bank3 (.clk_i(clk_i), .we_i(bank3_write_enable), .addr_i(bank3_addr), .write_data_i(bank3_write_data), .read_data_o(bank3_read_data));
    
    always_comb begin
        bank0_addr = bank_addr + ((bank_base > 0) ? 1 : 0);
        bank1_addr = bank_addr + ((bank_base > 1) ? 1 : 0);
        bank2_addr = bank_addr + ((bank_base > 2) ? 1 : 0);
        bank3_addr = bank_addr;
        bank0_write_enable = write_mask_i[(4 - bank_base) % 4];
        bank1_write_enable = write_mask_i[(5 - bank_base) % 4];
        bank2_write_enable = write_mask_i[(6 - bank_base) % 4];
        bank3_write_enable = write_mask_i[(7 - bank_base) % 4];
        case (bank_base)
        2'd0: begin
            bank0_write_data = write_data_i[7:0];
            bank1_write_data = write_data_i[15:8];
            bank2_write_data = write_data_i[23:16];
            bank3_write_data = write_data_i[31:24];
            read_data_o = {bank3_read_data, bank2_read_data, bank1_read_data, bank0_read_data};
        end
        2'd1: begin
            bank0_write_data = write_data_i[31:24];
            bank1_write_data = write_data_i[7:0];
            bank2_write_data = write_data_i[15:8];
            bank3_write_data = write_data_i[23:16];
            read_data_o = {bank0_read_data, bank3_read_data, bank2_read_data, bank1_read_data};
        end
        2'd2: begin
            bank0_write_data = write_data_i[23:16];
            bank1_write_data = write_data_i[31:24];
            bank2_write_data = write_data_i[7:0];
            bank3_write_data = write_data_i[15:8];
            read_data_o = {bank1_read_data, bank0_read_data, bank3_read_data, bank2_read_data};
        end
        2'd3: begin
            bank0_write_data = write_data_i[15:8];
            bank1_write_data = write_data_i[23:16];
            bank2_write_data = write_data_i[31:24];
            bank3_write_data = write_data_i[7:0];
            read_data_o = {bank2_read_data, bank1_read_data, bank0_read_data, bank3_read_data};
        end
        endcase
    end
endmodule