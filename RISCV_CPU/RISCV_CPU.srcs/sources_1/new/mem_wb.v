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
    output reg wb_rd_enable
    );

always @ (posedge clk) begin
    if (rst == `ResetEnable) begin
        mem_rd_data <= `ZERO_WORD;
        mem_rd_addr <= `RegAddrLen'h0;
        mem_rd_enable <= `WriteDisable;
    end
    else begin
        mem_rd_data <= ex_rd_data;
        mem_rd_addr <= ex_rd_addr;
        mem_rd_enable <= ex_rd_enable;
    end
end
endmodule
