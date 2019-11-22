`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2019 04:59:04 PM
// Design Name: 
// Module Name: ctrl
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


module ctrl(
    input wire rst,
    input wire clk,
    input wire stallreq,
    input wire stallreq_if,
    input wire stallreq_mem,
    output reg [`PipelineDepth - 1 : 0] stall
    );

    always @ (posedge clk) begin
        if (rst == `ResetEnable) begin
            stall <= `PipelineDepth'b000000; //from msb to lsb!!!
        end 
        else if (stallreq_mem == `StallEnable) begin
            stall <= `PipelineDepth'b011111;
        end
        else if (stallreq_if == `StallEnable) begin
            stall <= `PipelineDepth'b000011;
        end        
        else if (stallreq == `StallEnable) begin
            stall <= `PipelineDepth'b111111;
        end 
        else begin
            stall <= `PipelineDepth'b000000;
        end 
    end

    always @ (negedge clk) begin
        if (rst == `ResetEnable) begin
            stall <= `PipelineDepth'b000000; //from msb to lsb!!!
        end 
        else if (stallreq_mem == `StallEnable) begin
            stall <= `PipelineDepth'b011111;
        end
        else if (stallreq_if == `StallEnable) begin
            stall <= `PipelineDepth'b000011;
        end        
        else if (stallreq == `StallEnable) begin
            stall <= `PipelineDepth'b111111;
        end 
        else begin
            stall <= `PipelineDepth'b000000;
        end 
    end
endmodule
