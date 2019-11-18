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
    input wire rst,
    input wire stall_test,
    input wire rdy
    );
    
localparam RAM_ADDR_WIDTH = 17; 			// 128KiB ram, should not be modified

    wire [ 7:0]   mem_din;
    wire [ 7:0]   mem_dout;
    wire [31:0]   mem_a;
    wire          mem_wr;	
    

    cpu cpu0(.clk_in(clk), .rst_in(rst), .stall_test(stall_test),
            .mem_din(mem_din), .mem_dout(mem_dout), .mem_a(mem_a), .mem_wr(mem_wr));
            
    ram #(.ADDR_WIDTH(RAM_ADDR_WIDTH))
        ram0(.clk_in(clk), .en_in(rdy),
            .r_nw_in(mem_wr), .a_in(mem_a), .d_in(mem_dout), .d_out(mem_din));
    
endmodule
