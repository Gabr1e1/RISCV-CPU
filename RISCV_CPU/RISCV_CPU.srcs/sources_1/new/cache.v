`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/26 22:30:02
// Design Name: 
// Module Name: cache
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


module cache(
    input wire clk,
    input wire rst,
    input wire [`AddrLen - 1 : 0] addr,
    input wire [`AddrLen - 1 : 0] data_r,
    input wire replace,

    output wire [`RegLen - 1 : 0] data,
    output wire isCorrect,
    output wire isValid
    );

    reg [`AddrLen - 1 : 0] entry[`CacheSize - 1 : 0];
    reg [`TagLen - 1 : 0] tag[`CacheSize - 1 : 0];
    reg [`CacheSize - 1 : 0] valid;

    assign data = entry[addr[`CacheLen - 1 + 2 : 2]];
    assign isValid = valid[addr[`CacheLen - 1 + 2 : 2]] == `Valid;
    assign isCorrect = (valid[addr[`CacheLen - 1 + 2 : 2]] == `Valid) ? (tag[addr[`CacheLen - 1 + 2 : 2]] == addr[`CacheLen + `TagLen + 1: `CacheLen + 2]) : 1'b0;
    
    integer i;
    always @ (posedge clk) begin
        if (rst == `ResetEnable) begin
            valid <= 0;
        end
        else if (replace) begin
//            $display("%h %h",data_r, addr);
            entry[addr[`CacheLen - 1 + 2 : 2]] <= data_r;
            tag[addr[`CacheLen - 1 + 2 : 2]] <= addr[`CacheLen + `TagLen + 1: `CacheLen + 2];
            valid[addr[`CacheLen - 1 + 2 : 2]] <= `Valid;
        end
    end
endmodule
