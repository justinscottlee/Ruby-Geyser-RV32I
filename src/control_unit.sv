`timescale 1ns / 1ps

// TODO: Power Optimization: Disable unused modules so useless computation doesn't occur. e.g. the ALU shouldn't add anything in a JAL instruction.
// TODO: Programmable Extensibility: Any combination of opcode, funct7, or funct3 that doesn't resolve to a valid instruction will result in an illegal instruction exception that can be handled by code to possibly emulate the intended instruction with the software oblivious. 
module control_unit(
    // Instruction identifiers.
    input logic [6:0] opcode_i, funct7_i,
    input logic [2:0] funct3_i,
    input logic [18:0] control_field_i, // Control field read from microcode.
    
    output logic [5:0] microcode_addr_o, // Microcode instruction address.
    
    // ALU control signals.
    output logic alu_a_sel_o, alu_b_sel_o,
    output logic [3:0] alu_op_o,
    
    // Brancher control signals.
    output logic br_base_sel_o,
    output logic [1:0] br_cond_o,
    
    // Regfile control signals.
    output logic regfile_we_o,
    output logic [1:0] rd_data_sel_o,
    
    // Load-store Unit control signals.
    output logic lsu_we_o, lsu_sign_extend_o,
    output logic [1:0] lsu_datawidth_o,
    
    output logic [2:0] imm_sel_o, // Decoder control signal to select immediate type.
    
    output logic invalid_instruction_o
    );
    
    `include "defines.vh"
    
    assign alu_a_sel_o = control_field_i[0];
    assign alu_b_sel_o = control_field_i[1];
    assign alu_op_o = control_field_i[5:2];
    assign br_cond_o = control_field_i[7:6];
    assign br_base_sel_o = control_field_i[8];
    assign regfile_we_o = control_field_i[9];
    assign rd_data_sel_o = control_field_i[11:10];
    assign lsu_we_o = control_field_i[12];
    assign lsu_sign_extend_o = control_field_i[13];
    assign lsu_datawidth_o = control_field_i[15:14];
    assign imm_sel_o = control_field_i[18:16];
    
    always_comb begin
        case (opcode_i)
        `OPCODE_LUI: begin
            invalid_instruction_o = 1'b0;
            microcode_addr_o = 6'd0;
        end
        `OPCODE_AUIPC: begin
            invalid_instruction_o = 1'b0;
            microcode_addr_o = 6'd1;
        end
        `OPCODE_JAL: begin
            invalid_instruction_o = 1'b0;
            microcode_addr_o = 6'd2;
        end
        `OPCODE_JALR: begin
            invalid_instruction_o = 1'b0;
            microcode_addr_o = 6'd3;
        end
        `OPCODE_BRANCH: begin
            case (funct3_i)
            `FUNCT3_BEQ: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd4;
            end
            `FUNCT3_BNE: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd5;
            end
            `FUNCT3_BLT: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd6;
            end
            `FUNCT3_BGE: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd7;
            end
            `FUNCT3_BLTU: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd8;
            end
            `FUNCT3_BGEU: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd9;
            end
            default: begin
                microcode_addr_o = 6'd37;
                invalid_instruction_o = 1'b1;
            end
            endcase
        end
        `OPCODE_LOAD: begin
            case (funct3_i)
            `FUNCT3_LB: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd10;
            end
            `FUNCT3_LH: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd11;
            end
            `FUNCT3_LW: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd12;
            end
            `FUNCT3_LBU: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd13;
            end
            `FUNCT3_LHU: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd14;
            end
            default: begin
                microcode_addr_o = 6'd37;
                invalid_instruction_o = 1'b1;
            end
            endcase
        end
        `OPCODE_STORE: begin
            case (funct3_i)
            `FUNCT3_SB: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd15;
            end
            `FUNCT3_SH: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd16;
            end
            `FUNCT3_SW: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd17;
            end
            default: begin
                microcode_addr_o = 6'd37;
                invalid_instruction_o = 1'b1;
            end
            endcase
        end
        `OPCODE_OP_IMM: begin
            case (funct3_i)
            `FUNCT3_ADDI: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd18;
            end
            `FUNCT3_SLTI: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd19;
            end
            `FUNCT3_SLTIU: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd20;
            end
            `FUNCT3_XORI: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd21;
            end
            `FUNCT3_ORI: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd22;
            end
            `FUNCT3_ANDI: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd23;
            end
            `FUNCT3_SLLI: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd24;
            end
            `FUNCT3_SRLI_SRAI: begin
                case (funct7_i)
                `FUNCT7_SRLI: begin
                    invalid_instruction_o = 1'b0;
                    microcode_addr_o = 6'd25;
                end
                `FUNCT7_SRAI: begin
                    invalid_instruction_o = 1'b0;
                    microcode_addr_o = 6'd26;
                end
                default: begin
                    microcode_addr_o = 6'd37;
                    invalid_instruction_o = 1'b1;
                end
                endcase
            end
            default: begin
                microcode_addr_o = 6'd37;
                invalid_instruction_o = 1'b1;
            end
            endcase
        end
        `OPCODE_OP: begin
            case (funct3_i)
            `FUNCT3_ADD_SUB: begin
                case (funct7_i)
                `FUNCT7_ADD: begin
                    invalid_instruction_o = 1'b0;
                    microcode_addr_o = 6'd27;
                end
                `FUNCT7_SUB: begin
                    invalid_instruction_o = 1'b0;
                    microcode_addr_o = 6'd28;
                end
                default: begin
                    microcode_addr_o = 6'd37;
                    invalid_instruction_o = 1'b1;
                end
                endcase
            end
            `FUNCT3_SLL: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd29;
            end
            `FUNCT3_SLT: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd30;
            end
            `FUNCT3_SLTU: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd31;
            end
            `FUNCT3_XOR: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd32;
            end
            `FUNCT3_SRL_SRA: begin
                case (funct7_i)
                `FUNCT7_SRL: begin
                    invalid_instruction_o = 1'b0;
                    microcode_addr_o = 6'd33;
                end
                `FUNCT7_SRA: begin
                    invalid_instruction_o = 1'b0;
                    microcode_addr_o = 6'd34;
                end
                default: begin
                    microcode_addr_o = 6'd37;
                    invalid_instruction_o = 1'b1;
                end
                endcase
            end
            `FUNCT3_OR: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd35;
            end
            `FUNCT3_AND: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd36;
            end
            default: begin
                microcode_addr_o = 6'd37;
                invalid_instruction_o = 1'b1;
            end
            endcase
        end
        `OPCODE_MISC_MEM: begin
            case (funct3_i)
            `FUNCT3_FENCE: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd37;
            end
            default: begin
                microcode_addr_o = 6'd37;
                invalid_instruction_o = 1'b1;
            end
            endcase
        end
        `OPCODE_SYSTEM: begin
            case (funct3_i)
            `FUNCT3_ECALL_EBREAK: begin
                invalid_instruction_o = 1'b0;
                microcode_addr_o = 6'd38;
            end
            default: begin
                microcode_addr_o = 6'd37;
                invalid_instruction_o = 1'b1;
            end
            endcase
        end
        default: begin
            microcode_addr_o = 6'd37;
            invalid_instruction_o = 1'b1;
        end
        endcase
    end
endmodule