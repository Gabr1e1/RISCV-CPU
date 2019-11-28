`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Gabriel
// 
// Create Date: 10/24/2019 11:39:52 PM
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    input wire clk,
    input wire rst,
    input wire stall,

    input wire [`AddrLen - 1 : 0] jmp_target,
    input wire jmp_enable,
    input wire [`AddrLen - 1 : 0] prediction,
    input wire pred_enable,

    output reg [`AddrLen - 1 : 0] pc,
    output reg chip_enable,
    output reg enable
    );
    
always @ (posedge clk) begin
    if (rst == `ResetEnable)
        chip_enable <= `ChipDisable;
    else
        chip_enable <= `ChipEnable;
end

always @ (posedge clk) begin
    if (chip_enable == `ChipDisable) begin
        pc <= `ZERO_WORD;
    end
    else if (stall == `StallDisable) begin
        enable <= 1'b1;
        if (jmp_enable == `JumpEnable) begin
            pc <= jmp_target;
        end
        else if (pred_enable == `JumpEnable) begin
            pc <= prediction;
        end
        else begin
            pc <= pc + 4;
        end
//        $display("%d %h",count, pc);
    end
    else
        enable <= 1'b0;
end

endmodule
