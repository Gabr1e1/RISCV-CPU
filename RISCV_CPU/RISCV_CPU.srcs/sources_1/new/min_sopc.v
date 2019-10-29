`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2019 07:05:06 PM
// Design Name: 
// Module Name: min_sopc
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


module min_sopc(
    input wire clk,
    input wire rst
    );

    wire [`AddrLen - 1 : 0] rom_addr;
    wire rom_ce;
    wire [`InstLen - 1 : 0] inst;

    cpu(.clk_in(clk), .rst(rst_in),
        .rom_data_i(inst), .rom_addr_o(rom_addr), .rom_ce_o(rom_ce));
    rom(.ce(rom_ce), .addr(rom_addr), .inst(inst));

endmodule
