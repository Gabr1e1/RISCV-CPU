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
    input wire stallreq,
    input wire stallreq_id,
    input wire stallreq_ex,
    input wire stallreq_mem,
    output reg[`PipelineDepth - 1 : 0] stall
    );

    always @ (*) begin
        if (rst == `ResetEnable) begin
            stall <= `PipelineDepth'b000000; //from msb to lsb!!!
        end 
        else if (stallreq_id == `StallEnable) begin
            stall <= `PipelineDepth'b000111;
        end        
        else if (stallreq_ex == `StallEnable) begin
            stall <= `PipelineDepth'b001111;
        end
        else if (stallreq_mem == `StallEnable) begin
            stall <= `PipelineDepth'b011111;
        end
        else if (stallreq == `StallEnable) begin
            stall <= `PipelineDepth'b111111;
        end 
        else begin
            stall <= `PipelineDepth'b000000;
        end 
    end

endmodule
