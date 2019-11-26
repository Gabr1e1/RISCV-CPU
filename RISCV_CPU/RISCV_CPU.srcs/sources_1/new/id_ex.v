`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2019 06:06:10 PM
// Design Name: 
// Module Name: id_ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Pass the variables from stage ID to EX
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module id_ex(
    input wire clk,
    input wire rst,
    
    input wire [`AddrLen - 1 : 0] id_pc,
    output reg [`AddrLen - 1 : 0] ex_pc,
    
    input wire [`RegLen - 1 : 0] id_reg1,
    input wire [`RegLen - 1 : 0] id_reg2,
    input wire [`RegLen - 1 : 0] id_Imm,
    input wire [`RegLen - 1 : 0] id_rd,
    input wire id_rd_enable,
    input wire [`OpCodeLen - 1 : 0] id_aluop,
    input wire [`OpSelLen - 1 : 0] id_alusel,
    input wire [`CtrlLen - 1 : 0] id_ctrlsel,
    input wire [3:0] id_width,
    input wire [`AddrLen - 1 : 0] id_jmp_addr,
    input wire [`AddrLen - 1 : 0] id_prediction,
    
    output reg [`RegLen - 1 : 0] ex_reg1,
    output reg [`RegLen - 1 : 0] ex_reg2,
    output reg [`RegLen - 1 : 0] ex_Imm,
    output reg [`RegLen - 1 : 0] ex_rd,
    output reg ex_rd_enable,
    output reg [`OpCodeLen - 1 : 0] ex_aluop,
    output reg [`OpSelLen - 1 : 0] ex_alusel,
    output reg [`CtrlLen - 1 : 0] ex_ctrlsel,
    output reg [3:0] ex_width,
    output reg [`AddrLen - 1 : 0] ex_jmp_addr,
    output reg [`AddrLen - 1 : 0] ex_prediction,

    input wire [`PipelineDepth - 1 : 0] stall,
    input wire flush
    );

always @ (posedge clk) begin
    if (rst == `ResetEnable || (stall[2] == `StallEnable && stall[3] == `StallDisable)) begin
        ex_reg1 <= `ZERO_WORD;
        ex_reg2 <= `ZERO_WORD;
        ex_Imm <= `ZERO_WORD;
        ex_rd <= `ZERO_WORD;
        ex_rd_enable <= `WriteDisable;
        ex_aluop <= `ZERO_WORD;
        ex_alusel <= `ZERO_WORD;
        ex_width <= `ZERO_WORD;
        ex_pc <= `ZERO_WORD;
    end
    else if (stall[2] == `StallDisable) begin
        if (flush == `FlushDisable) begin
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_Imm <= id_Imm;
            ex_rd <= id_rd;
            ex_rd_enable <= id_rd_enable;
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_ctrlsel <= id_ctrlsel;
            ex_width <= id_width;
            ex_jmp_addr <= id_jmp_addr;
            ex_prediction <= id_prediction;
            ex_pc <= id_pc;
        end
        else begin
            ex_aluop <= `FlushOp;
            ex_alusel <= `NO_OP;
            ex_rd_enable <= `WriteDisable;
            // ex_ctrlsel <= `Ctrl_NOP;
        end
    end
end

endmodule
