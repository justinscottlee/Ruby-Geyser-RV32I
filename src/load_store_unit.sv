`timescale 1ns / 1ps

// TODO: add an MMU? Handle all the stuff with virtual memory addresses like 0x0 thru 0xFFF for internal registers/io/etc, versus 0x1000 thru 0x8FFF for data memory cache, versus 0x9000 thru 0xFFFFFFFF for external memory interface.

// Little-Endian. 0xFF00AACC at 0x0 in memory -> 0x0: 0xCC, 0x1: 0xAA, 0x2: 0x00, 0x3: 0xFF
module load_store_unit(
    input logic sign_extend_i, we_i,
    input logic [1:0] data_width_i,
    input logic [31:0] addr_i, write_data_i, dm_read_data_i,
    output logic [31:0] read_data_o,
    output logic [3:0] dm_write_mask_o
    );
    
    `include "defines.vh"
    
    always_comb begin
        // Read.
        case (data_width_i)
        `DATAWIDTH_BYTE: begin
            read_data_o = sign_extend_i ? {{24{dm_read_data_i[7]}}, dm_read_data_i[7:0]} : {24'b0, dm_read_data_i[7:0]};
        end
        `DATAWIDTH_SHORT: begin
            read_data_o = sign_extend_i ? {{16{dm_read_data_i[15]}}, dm_read_data_i[15:0]} : {16'b0, dm_read_data_i[15:0]};
        end
        `DATAWIDTH_WORD: begin
            read_data_o = dm_read_data_i;
        end
        default: begin
            read_data_o = 32'd0;
        end
        endcase
        // Write.
        if (we_i) begin
            case (data_width_i)
            `DATAWIDTH_BYTE: begin
                dm_write_mask_o = 4'b0001;
            end 
            `DATAWIDTH_SHORT: begin
                dm_write_mask_o = 4'b0011;
            end
            `DATAWIDTH_WORD: begin
                dm_write_mask_o = 4'b1111;
            end
            default: begin
                dm_write_mask_o = 4'b0000;
            end
            endcase
        end
        else begin
            dm_write_mask_o = 4'b0000; // Default data memory write mask to not write anything.
        end
    end
endmodule