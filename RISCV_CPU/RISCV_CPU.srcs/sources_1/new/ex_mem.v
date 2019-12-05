`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2019 08:27:12 PM
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
    input wire clk,
    input wire rst,
    input wire [`RegLen - 1 : 0] ex_rd_data,
    input wire [`RegAddrLen - 1 : 0] ex_rd_addr,
    input wire [`AddrLen - 1 : 0] ex_mem_addr,

    input wire ex_rd_enable,
    input wire [3:0] ex_width, 

    output reg [`RegLen - 1 : 0] mem_rd_data,
    output reg [`RegAddrLen - 1 : 0] mem_rd_addr,
    output reg [`AddrLen - 1 : 0] mem_mem_addr,

    output reg mem_rd_enable,
    output reg [3:0] mem_width,
    
    input wire [`PipelineDepth - 1 : 0] stall
    );

always @ (posedge clk) begin
    if (rst == `ResetEnable || (stall[3] == `StallEnable && stall[4] == `StallDisable)) begin
        mem_rd_data <= `ZERO_WORD;
        mem_rd_addr <= `RegAddrLen'h00;
        mem_rd_enable <= `WriteDisable;
        mem_mem_addr <= `ZERO_WORD;
        mem_width <= 4'b0000;
    end
    else if (stall[3] == `StallDisable) begin
        mem_rd_data <= ex_rd_data;
        mem_rd_addr <= ex_rd_addr;
        mem_rd_enable <= ex_rd_enable;
        mem_mem_addr <= ex_mem_addr;
        mem_width <= ex_width;
    end
end

endmodule
