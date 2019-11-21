`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2019 06:12:53 PM
// Design Name: 
// Module Name: ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ex(
    input wire rst,
    input wire [`AddrLen - 1 : 0] pc,

    input wire [`RegLen - 1 : 0] reg1,
    input wire [`RegLen - 1 : 0] reg2,
    input wire [`RegLen - 1 : 0] Imm,
    input wire [`RegLen - 1 : 0] rd,
    input wire rd_enable,
    input wire [`OpCodeLen - 1 : 0] aluop,
    input wire [`OpSelLen - 1 : 0] alusel,
    input wire [3:0] width_i,

    output reg [`RegLen - 1 : 0] rd_data_o,
    output reg [`RegAddrLen - 1 : 0] rd_addr,
    output reg [`AddrLen - 1 : 0] mem_addr,

    output reg rd_enable_o,
    output reg [3:0] width_o
    );
    
    reg [`RegLen - 1 : 0] res;

//Do the calculation
always @ (*) begin
    if (rst == `ResetEnable) begin
        res <= `ZERO_WORD;
    end
    else begin
        case (aluop)
            `OP_AUIPC:
                res <= pc + Imm;
            `OP_ADD:
                res <= reg1 + reg2;
            `OP_ADD2:
                res <= reg1 + Imm;
            `OP_SUB:
                res <= reg1 - reg2;
            `OP_SLL:
                res <= reg1 << reg2[4:0];
            `OP_SLT:
                res <= { {31{1'b0}}, $signed(reg1) < $signed(reg2) };
            `OP_SLTU:
                res <= { {31{1'b0}}, reg1 < reg2 };
            `OP_XOR:
                res <= reg1 ^ reg2;
            `OP_SRL:
                res <= reg1 >> reg2[4:0];
            `OP_SRA:
                res <= $signed(reg1) >>> reg2[4:0];
            `OP_OR:
                res <= reg1 | reg2;
            `OP_AND:
                res <= reg1 & reg2;
            default: 
                res <= `ZERO_WORD;
        endcase
    end
end

//Determine the output
always @ (*) begin
    if (rst == `ResetEnable) begin
        rd_enable_o <= `WriteDisable;
    end
    else begin 
        rd_addr <= rd;
        rd_enable_o <= rd_enable;
        width_o <= 4'b0000;
        case (alusel)
            `Arith_OP: 
                rd_data_o <= res;
            `LUI_OP:
                rd_data_o <= Imm;
            `AUIPC_OP:
                rd_data_o <= res;
            `LOAD_OP: begin    
                width_o <= width_i; 
                rd_data_o <= res;
            end
            `STORE_OP: begin
                width_o <= width_i;
                rd_data_o <= reg2;
                mem_addr <= res;
            end
            default: 
                rd_data_o <= `ZERO_WORD;
        endcase
    end
end


endmodule
