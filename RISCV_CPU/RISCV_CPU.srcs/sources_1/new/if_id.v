`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2019 04:44:14 PM
// Design Name: 
// Module Name: if_id
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


module if_id(
    input wire clk, 
    input wire rst,
    input wire [`AddrLen - 1 : 0] if_pc,
    input wire [`InstLen - 1 : 0] if_inst,
    output reg [`AddrLen - 1 : 0] id_pc,
    output reg [`InstLen - 1 : 0] id_inst,
    input wire [`PipelineDepth - 1 : 0] stall
    );
    
always @ (posedge clk) begin
    //if stall[1] & stall[2] are stallenable, then pass nothing downward
    if (rst == `ResetEnable || (stall[1] == `StallEnable && stall[2] == `StallDisable)) begin
        id_pc <= `ZERO_WORD;
        id_inst <= `ZERO_WORD;
    end
    else if (stall[1] == `StallDisable) begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
end
endmodule
