`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2019 12:03:13 AM
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input clk,
    input rst,
    input wire [`RegLen - 1 : 0] mem_rd_data,
    input wire [`RegAddrLen - 1 : 0] mem_rd_addr,
    input wire mem_rd_enable,

    output reg [`RegLen - 1 : 0] wb_rd_data,
    output reg [`RegAddrLen - 1 : 0] wb_rd_addr,
    output reg wb_rd_enable,

    input wire [`PipelineDepth - 1 : 0] stall
    );

always @ (posedge clk) begin
    if (rst == `ResetEnable || (stall[4] == `StallEnable && stall[5] == `StallDisable)) begin
        wb_rd_data <= `ZERO_WORD;
        wb_rd_addr <= `RegAddrLen'h0;
        wb_rd_enable <= `WriteDisable;
    end
    else if (stall[4] == `StallDisable) begin
        wb_rd_data <= mem_rd_data;
        wb_rd_addr <= mem_rd_addr;
        wb_rd_enable <= mem_rd_enable;
    end
end
endmodule
