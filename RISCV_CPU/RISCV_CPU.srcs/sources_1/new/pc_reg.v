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
    output reg enable_pc
    );
 
    reg [`AddrLen - 1 : 0] npc;
    reg assigned;

always @ (posedge clk) begin
    if (rst == `ResetEnable) begin
        pc <= `ZERO_WORD;
        npc <= 32'h00000004;
        assigned <= 1'b0;
        enable_pc <= 1'b1;
    end
    else begin
        if (jmp_enable == `JumpEnable) begin
            assigned <= 1'b1;
            if (stall == `StallDisable) begin
                pc <= jmp_target;
                npc <= jmp_target + 4;
                enable_pc <= 1'b1;
            end
            else begin
                npc <= jmp_target;
            end
        end
        else if (pred_enable == `JumpEnable && assigned != 1'b1) begin
            if (stall == `StallDisable) begin
//                $display("%h",prediction);
                pc <= prediction;
                npc <= prediction + 4;
                enable_pc <= 1'b1;
            end
            else begin
                npc <= prediction;
            end
        end
        else if (stall == `StallDisable) begin
            pc <= npc;
            npc <= npc + 4;
            assigned <= 1'b0;
            enable_pc <= 1'b1;
        end
        else begin
            enable_pc <= 1'b0;
        end
    end
end

endmodule
